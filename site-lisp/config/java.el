(add-local-load-path "elib-1.0")
(add-local-load-path "malabar/lisp")

(require 'malabar-mode)
(setq malabar-groovy-lib-dir (concat emacs-local-site-lisp "malabar/lib"))
(add-to-list 'auto-mode-alist '("\\.java\\'" . malabar-mode))

(setq-mode-local java-mode
				 semanticdb-find-default-throttle
				 '(local project unloaded recursive))

(semanticdb-enable-gnu-global-databases 'java-mode)
