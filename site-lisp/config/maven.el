(require 'compile)
(setq compile-command "mvn compile")

(defvar mvn-command-history nil
  "Maven command history variable")

(defun mvn(&optional args)
  "Runs maven in the current project. Starting at the directoy where the file being vsisited resides, a search is
   made for pom.xml recsurively. A maven command is made from the first directory where the pom.xml file is found is then displayed
  in the minibuffer. The command can be edited as needed and then executed. Errors are navigate to as in any other compile mode"
  (interactive)
  (let ((fn (buffer-file-name)))
    (let ((dir (file-name-directory fn)))
      (while (and (not (file-exists-p (concat dir "/pom.xml")))
                  (not (equal dir (file-truename (concat dir "/..")))))
        (setf dir (file-truename (concat dir "/.."))))
      (if (not (file-exists-p (concat dir "/pom.xml")))
          (message "No pom.xml found")
        (compile (read-from-minibuffer "Command: "
                                       (concat "mvn -f " dir "/pom.xml test") nil nil 'mvn-command-history))))))

(add-to-list
 'compilation-error-regexp-alist-alist
 '(mvn "\\(^/.*\\):\\[\\([0-9]+\\),\\([0-9]+\\)\\]" 1 2 3 2 1))
(add-to-list 'compilation-error-regexp-alist 'mvn)
(add-to-list
 'compilation-error-regexp-alist-alist
 '(mvn-warning "^\\[WARNING\\] \\(/.*\\):\\[\\([0-9]+\\),\\([0-9]+\\)\\]" 1 2 3 1 1))
(add-to-list 'compilation-error-regexp-alist 'mvn-warning)

;; String pattern for locating errors in maven output. This assumes a Windows drive letter at the beginning
(add-to-list
 'compilation-error-regexp-alist-alist
 '(mvn-error-windows "^\\([a-zA-Z]:.*\\):\\[\\([0-9]+\\),\\([0-9]+\\)\\]" 1 2 3))
(add-to-list 'compilation-error-regexp-alist 'mvn-error-windows)
