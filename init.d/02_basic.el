;; Prompt before exiting Emacs
(defun ask-before-closing ()
 "Ask whether or not to close, and then close if y was pressed"
 (interactive)
 (if (y-or-n-p (format "Are you sure you want to exit Emacs? "))
	(if (< emacs-major-version 22)
	 (save-buffers-kill-terminal)
	 (save-buffers-kill-emacs))
	(message "Canceled exit")))

(defun add-local-load-path (path-string)
  (message (format "Adding %S to load path" (concat emacs-local-site-lisp path-string)))
  (add-to-list 'load-path (concat emacs-local-site-lisp path-string)))

(setq scroll-preserve-screen-position 1)

(setq tab-width 4)
(setq c-basic-offset 4)

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/elpa/auto-complete-20120327/dict")
(ac-config-default)

(autoload 'project-mode "project-mode" "Project Mode" t)

(when window-system
  (global-set-key (kbd "C-x C-c") 'ask-before-closing))

(load "~/.emacs.d/site-lisp/nxhtml/autostart.el")

