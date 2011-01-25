;;; jde-mvn-build.el --- Using Maven2 as a build tool for JDEE
;;
;; Copyright (c) 2008 Espen Wiborg <espenhw@grumblesmurf.org>
;;
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2 of the License, or
;; (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, write to the Free Software
;; Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
;;

(defcustom jde-mvn-build-hook '(jde-compile-finish-kill-buffer
                                jde-compile-finish-refresh-speedbar
                                jde-compile-finish-update-class-info)
  "*List of hook functions run by `jde-mvn-build' (see `run-hooks'). Each
function should accept two arguments: the compilation buffer and a string
describing how the compilation finished"
  :group 'jde-mvn
  :type 'hook)

(defvar jde-mvn-build-interactive-args-history nil
  "History of arguments entered in the minibuffer.")

(defvar jde-mvn-build-interactive-goals-history nil
  "History of goals entered in the minibuffer.")

(defvar jde-mvn-build-default-goals-alist nil)

(defvar jde-mvn-build-default-goals 'install)

(defun jde-mvn-build-get-default-goals (pom-file)
  (or (cdr (assoc-string pom-file jde-mvn-build-default-goals-alist))
      jde-mvn-build-default-goals))

;; TODO: some way of specifying properties interactively
(defun* jde-mvn-build
    (&optional goals (pom-file (jde-mvn-find-pom-file jde-mvn-pom-file-name t))
               &rest properties)
  "Run the mvn program specified by `pom-maven-command' on the
given POM, triggering the given goals. If given a prefix arg,
read goals from the minibuffer.  If given two prefix
args (e.g. C-u C-u jde-mvn-build, read both goals and pom-file
from the minibuffer."
  (interactive
   (let ((prompt-for (cond ((null current-prefix-arg) nil)
                           ((and (consp current-prefix-arg)
                                 (eql (car current-prefix-arg) 16))
                            '(goals pom-file))
                           (t '(goals)))))
     (when prompt-for
       (let* ((pom (if (memq 'pom-file prompt-for)
                       (jde-mvn-prompt-for-pom-file)
                     (jde-mvn-find-pom-file)))
              (goals (if (memq 'goals prompt-for)
                         (setq jde-mvn-build-default-goals
                               (read-from-minibuffer "Goals: " nil nil nil
                                                     jde-mvn-build-interactive-goals-history))
                       (jde-mvn-build-get-default-goals pom))))
         (list goals pom nil)))))
  (unless goals
    (setq goals (jde-mvn-build-get-default-goals pom-file)))
  (let ((cell (assoc-string pom-file jde-mvn-build-default-goals-alist)))
    (if cell
        (rplacd cell goals)
      (setq jde-mvn-build-default-goals-alist (acons pom-file goals jde-mvn-build-default-goals-alist))))
  (if jde-mvn-use-server
      ;; Server mode!
      (apply #'jde-mvn-call-mvn-server 
             t pom-file goals
             #'(lambda (buf msg)
                 (run-hook-with-args 'jde-mvn-build-hook buf msg))
             properties)
    (let ((compile-command
           (mapconcat #'identity
                      `(,jde-mvn-command
                        "-B" "-N" "-f" ,pom-file
                        ,@(cond ((symbolp goals)
                                 (list (symbol-name goals)))
                                ((consp goals)
                                 (mapcar #'symbol-name goals))
                                (t (list goals)))
                        ,@(jde-mvn-make-maven-arguments properties))
                      " "))
          process-connection-type)
      (save-some-buffers (not compilation-ask-about-save) nil)
      (setq compilation-finish-functions 
            (list #'(lambda (buf msg)
                      (run-hook-with-args 'jde-mvn-build-hook buf msg)
                      (setq compilation-finish-functions nil))))
      (compilation-start compile-command))))

(defun* jde-mvn-build-run-test
    (&optional (test-class (jde-parse-get-buffer-class))
               (pom-file (jde-mvn-find-pom-file jde-mvn-pom-file-name t)))
  "Runs the public class in the current buffer as a test using Maven."
  (interactive)
  (jde-mvn-build '(test) pom-file :test test-class))

(defun jde-mvn-build-test-class-buffer-p (buffer)
  (let* ((pom-node (jde-mvn-get-pom-from-cache (jde-mvn-find-pom-file)))
         (test-source-path (jde-mvn-get-pom-property "project.build.testSourceDirectory"
                                                     nil
                                                     pom-node)))
    (and test-source-path 
         (string-match-p (concat "^"
                                 (regexp-quote test-source-path))
                         (buffer-file-name buffer)))))

(defun jde-mvn-build-find-failed-tests ()
  (interactive)
  (pop-to-buffer (compilation-find-buffer))
  (or (looking-at "  \\(\\w+\\)(\\([[:alnum:].]+\\))")
      (re-search-forward "Failed tests:" (point-max) t))
  (forward-line 1)
  (when (looking-at "  \\(\\w+\\)(\\([[:alnum:].]+\\))")
    (let ((class (match-string-no-properties 2))
          (method (match-string-no-properties 1)))
      (jde-find-class-source class t))))


;;; Hack alert!
;;; Insinuate jde-mvn-build into the custom definition of
;;; jde-build-function
(let ((type (cadr (get 'jde-build-function 'custom-type))))
  (unless (member '(const jde-mvn-build) type)
    (put 'jde-build-function 'custom-type
         (list 'list
               (append (butlast type)
                       (list '(const jde-mvn-build))
                       (last type))))))

(provide 'jde-mvn-build)
