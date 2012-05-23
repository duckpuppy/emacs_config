;; Prompt before exiting Emacs
(defun ask-before-closing ()
 "Ask whether or not to close, and then close if y was pressed"
 (interactive)
 (if (y-or-n-p (format "Are you sure you want to exit Emacs? "))
	(if (< emacs-major-version 22)
	 (save-buffers-kill-terminal)
	 (save-buffers-kill-emacs))
	(message "Canceled exit")))

(setq scroll-preserve-screen-position 1)

(setq tab-width 4)
(setq c-basic-offset 4)

;; Change the font to something nicer
(if (string= (symbol-name system-type) "windows-nt")
	(set-default-font "-outline-Consolas-normal-normal-normal-mono-18-*-*-*-c-*-iso8859-1")
	(modify-frame-parameters nil '((wait-for-wm . nil))))

(if (string= (symbol-name system-type) "darwin")
	(set-default-font "-outline-Inconsolata-normal-normal-normal-mono-18-*-*-*-c-*-iso8859-1")
	(modify-frame-parameters nil '((wait-for-wm . nil))))

(when window-system
  (global-set-key (kbd "C-x C-c") 'ask-before-closing))
