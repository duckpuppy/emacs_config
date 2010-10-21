(add-local-load-path "malabar-1.4.0/lisp")
(require 'malabar-mode)
(setq malabar-groovy-lib-dir "~/.emacs.d/site-lisp/malabar-1.4.0/lib")
(add-to-list 'auto-mode-alist '("\\.java\\'" . malabar-mode))
