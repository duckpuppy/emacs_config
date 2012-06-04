(require 'compile)
(setq compile-command "mvn compile")

(defvar mvn-command-history nil
  "Maven command history variable")

(defun mvn-compile-buffer-name (mode)
  "*Maven Compile*")

(setq compilation-buffer-name-function 'mvn-compile-buffer-name)

(defun mvn-at-root (path)
  "Determine if the given path is root."
  (equal path (mvn-parent-path path)))

(defun mvn-parent-path (path)
  "The parent path for the given path."
  (file-truename (concat path "/..")))

(defun mvn-pom-at-path-p (path)
  "Does a pom.xml exist in the given path."
  (file-exists-p (concat path "/pom.xml")))

(defun mvn-find-path-to-pom ()
  "Move up the directory tree for the current buffer until root or a pom.xml is found."
  (let ((fn (buffer-file-name)))
    (let ((path (file-name-directory fn)))
      (while (and (not (mvn-pom-at-path-p path))
		  (not (mvn-at-root path)))
	(setf path (file-truename (mvn-parent-path path))))
      path)))

(defun mvn-master (&optional args)
  (interactive)
  "Determine the potential master pom by checking if there is a pom in a pom's parent directory. nil if no parent pom else the path to the parent."
  (let ((pom-path (mvn-find-path-to-pom)))
    (let ((parent-pom-path (file-truename (concat pom-path "/.."))))
      (if (not (mvn-pom-at-path-p parent-pom-path))
	  (message "No master pom found.")
	(compile (read-from-minibuffer "Command: "
				       (concat "mvn -f " parent-pom-path "/pom.xml clean install")
				       nil nil 'mvn-command-history))))))
(defun mvn (cmd)
  "Runs maven in the current project. Starting at the directoy where the file being vsisited resides, a search is
   made for pom.xml recsurively. A maven command is made from the first directory where the pom.xml file is found is then displayed
   in the minibuffer. The command can be edited as needed and then executed. Errors are navigate to as in any other compile mode"
  (interactive "n0-clean 1-package 2-clean package 3-install 4-test : ")
  (let ((path (mvn-find-path-to-pom)))
    (let ((goal (case cmd
		  ((0) "clean")
		  ((1) "package")
		  ((2) "clean package")
		  ((3) "install")
		  ((4) "test"))))
      (if (not (file-exists-p (concat path "/pom.xml")))
	  (message "No pom.xml found")
	(compile (read-from-minibuffer "Command: "
				       (concat "mvn -f " path (concat "/pom.xml " goal))
				       nil nil 'mvn-command-history))))))

					;(push '("\\(.*?\\):\\([0-9]+\\): error: \\(.*?\\)\n" 1 2 nil 2 3 (6 compilation-error-face)) compilation-error-regexp-alist)

					;(push '("\\(.*?\\):\\([0-9]+\\): warning: \\(.*?\\)\n" 1 2 nil 1 3 (6 compilation-warning-face)) compilation-error-regexp-alist)

;; String pattern for locating errors in maven output. This assumes a Windows drive letter at the beginning
					;(add-to-list
					; 'compilation-error-regexp-alist-alist
					; '(mvn-error-windows "^\\([a-zA-Z]:.*\\):\\[\\([0-9]+\\),\\([0-9]+\\)\\]" 1 2 3))
					;(add-to-list 'compilation-error-regexp-alist 'mvn-error-windows)
(add-to-list
 'compilation-error-regexp-alist-alist
 '(mvn-warning-windows "\\[WARNING\\][[:blank:]]+\\(.*\\):\\[\\([0-9]+\\),\\([0-9]+\\)\\]" 1 2 3 1 1 (0 compilation-warning-face)))
(add-to-list 'compilation-error-regexp-alist 'mvn-warning-windows)

(add-to-list
 'compilation-error-regexp-alist-alist
 '(mvn-error-windows "\\[ERROR\\][[:blank:]]+\\(.*\\):\\[\\([0-9]+\\),\\([0-9]+\\)\\]" 1 2 3 1 1 (0 compilation-error-face)))
(add-to-list 'compilation-error-regexp-alist 'mvn-error-windows)

(set 'compilation-mode-font-lock-keywords
     '(("^\\[ERROR\\] BUILD FAILURE"
	(0 compilation-error-face))
       ("^\\[WARNING\\]"
	(0 compilation-warning-face))
       ("^\\(\\[INFO\\]\\)\\([^\n]*\\)"
	(1 compilation-info-face)
	(2 compilation-line-face))
       ("^\\[ERROR\\]"
	(0 compilation-error-face))
       ("\\(Failures\\): [1-9][0-9]*,"
	(0 compilation-error-face))
       ("\\(Failures\\): 0"
	(0 compilation-info-face))
       ("\\(Errors\\): [1-9][0-9]*,"
	(0 compilation-error-face))
       ("\\(Errors\\): 0"
	(0 compilation-info-face))
       ("\\(Skipped\\): [1-9][0-9]*,"
	(0 compilation-error-face))
       ("\\(Skipped\\): 0"
	(0 compilation-info-face))
       ("Tests run: [0-9]+"
	(0 compilation-warning-face))
       ("T E S T S"
	(0 compilation-warning-face))
       ("Compilation finished at [^\n]+"
	(0 compilation-info-face))
       ("^Compilation \\(exited abnormally\\|interrupt\\|killed\\|terminated\\|segmentation fault\\)\\(?:.*with code \\([0-9]+\\)\\)?.*"
	(0 '(face nil message nil help-echo nil mouse-face nil) t)
	(1 compilation-error-face)
	(2 compilation-error-face nil t))))

(eval-after-load "jde"
  '(progn
     (setq jde-mvn-nexus-url "http://nexus.s1.com/content/groups/s1")))

(provide 'maven)
