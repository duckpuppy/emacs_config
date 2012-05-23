(setq emacs-local-site-lisp (expand-file-name "~/.emacs.d/site-lisp/"))
(add-to-list 'load-path emacs-local-site-lisp)

(defvar *emacs-load-start* (current-time))
(require 'cl)

;; Store custom configuration in a shared folder
(setq custom-file (concat emacs-local-site-lisp "custom.el"))
(load custom-file)
(load-library "config/my-functions.el")

(load-library "config/basic.el")
(load-library "config/color-theme.el")
(load-library "config/org-mode.el")
(load-library "config/development.el")
(load-library "config/java.el")

(message "My .emacs loaded in %ds" (destructuring-bind (hi lo ms) (current-time)
									 (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))
