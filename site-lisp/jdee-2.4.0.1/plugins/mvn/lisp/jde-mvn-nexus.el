;;;; jde-mvn-nexus.el --- Integrating JDEE with Nexus
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

(require 'url)
(require 'json)
(require 'efc)

(defcustom jde-mvn-nexus-url "http://localhost:8081/nexus"
  "*The URL to the root of your Nexus."
  :group 'jde-mvn
  :type '(string))
  
(defconst +jde-mvn-nexus-search-path+ "/service/local/data_index")

(defconst +json-mime-type+ "application/json")

(defun jde-mvn-nexus-build-search-url (groupId artifactId version classname)
  "Builds a URL to search Nexus."
  (concat jde-mvn-nexus-url
          +jde-mvn-nexus-search-path+
          "?"
          (mapconcat 'identity
                     (remove nil
                             (list (and groupId (concat "g=" groupId))
                                   (and artifactId (concat "a=" artifactId))
                                   (and version (concat "v=" version))
                                   (and classname (concat "cn=" classname))))
                     "&")))

(defun* jde-mvn-nexus-search (&key groupId artifactId version classname)
  (let ((url-mime-accept-string +json-mime-type+))
    (let ((buffer (url-retrieve-synchronously
                   (jde-mvn-nexus-build-search-url groupId
                                                   artifactId
                                                   version
                                                   classname))))
      (prog1
          (with-current-buffer buffer
            (goto-char (point-max))
            (when (re-search-backward "^\r?$" nil t)
              (let ((json-array-type 'list))
                (mapcar #'(lambda (artifact)
                            (remove-if-not #'(lambda (s)
                                               (memq s '(groupId artifactId version classifier)))
                                           artifact
                                           :key #'car))
                        (cdr (assoc 'data (json-read)))))))
        (kill-buffer buffer)))))

(defun jde-mvn-nexus-artifact-to-string (artifact)
  (mapconcat
   'cdr
   (remove nil (list (assq 'groupId artifact)
                     (assq 'artifactId artifact)
                     (assq 'classifier artifact)
                     (assq 'version artifact)))
   ":"))

(defclass jde-mvn-nexus-artifact-dialog (efc-option-dialog)
  nil)

(defmethod efc-dialog-create ((this jde-mvn-nexus-artifact-dialog))
  (widget-insert (oref this text))
  (widget-insert "\n\n")
  (oset this radio-buttons
        (widget-create
         (list 'radio-button-choice
               :value (caar (oref this options))
               :args (mapcar (lambda (x)
                               (list 'item (car x)))
                             (oref this options)))))
  (widget-insert "\n"))

(defmethod efc-dialog-ok ((this jde-mvn-nexus-artifact-dialog))
  (oset this 
	selection 
	(cdr (assoc (widget-value (oref this radio-buttons))
                    (oref this options))))
  (delete-window)
  (set-buffer (oref this initbuf))
  (pop-to-buffer (oref this initbuf))
  (kill-buffer (oref this buf))
  (exit-recursive-edit))

(defun jde-mvn-nexus-choose-dependency (prompt artifacts)
  (let ((dialog
         (jde-mvn-nexus-artifact-dialog "Choose dependency"
                                        :text prompt
                                        :options (mapcar (lambda (a)
                                                           (cons (jde-mvn-nexus-artifact-to-string a)
                                                                 a))
                                                         artifacts))))
    (efc-dialog-show dialog)
    (oref dialog selection)))
  
(defun* jde-mvn-nexus-add-dependency (&optional (scope 'compile))
  (interactive (when current-prefix-arg
                 (list (jde-mvn-pom-prompt-for-scope))))
  (let ((groupId (read-string "Group ID: "))
        (artifactId (read-string "Artifact ID: "))
        (version (read-string "Version: ")))
    (let ((artifacts (jde-mvn-nexus-search :groupId (when (> (length groupId) 0)
                                                      groupId)
                                           :artifactId (when (> (length artifactId) 0)
                                                         artifactId)
                                           :version (when (> (length version) 0)
                                                      version))))
      (if artifacts
          (let ((artifact (if (> (length artifacts) 1)
                              (jde-mvn-nexus-choose-dependency "Add which dependency"
                                                               artifacts)
                            (car artifacts))))
            (jde-mvn-pom-add-dependency (cdr (assq 'groupId artifact))
                                        (cdr (assq 'artifactId artifact))
                                        (cdr (assq 'version artifact))
                                        scope))))))

(provide 'jde-mvn-nexus)
