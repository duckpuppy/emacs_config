(add-local-load-path "malabar/lisp")

(require 'malabar-mode)
(setq malabar-groovy-lib-dir (concat emacs-local-site-lisp "malabar/lib"))
(add-to-list 'auto-mode-alist '("\\.java\\'" . malabar-mode))

;; enable semanticdb support for gnu global
(when (cedet-gnu-global-version-check t)
  (semanticdb-enable-gnu-global-databases 'java-mode)
  (semanticdb-enable-gnu-global-databases 'malabar-mode))

(add-hook 'malabar-mode-hook
	(lambda ()
		(gtags-mode 1)))
