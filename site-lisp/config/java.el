(add-local-load-path "malabar/lisp")

(require 'malabar-mode)
(setq malabar-groovy-lib-dir (concat emacs-local-site-lisp "malabar/lib"))
(add-to-list 'auto-mode-alist '("\\.java\\'" . malabar-mode))

;; enable semanticdb support for gnu global
(when (cedet-gnu-global-version-check t)
  (semanticdb-enable-gnu-global-databases 'malabar-mode))

(add-hook 'java-mode-hook
	(lambda ()
		(gtags-mode 1)))

(add-hook 'java-mode-hook 'flymake-mode-on)

(defun my-java-flymake-init ()
  (list "javac" (list (flymake-init-create-temp-buffer-copy
					   'flymake-create-temp-with-folder-structure))))

(add-to-list 'flymake-allowed-file-name-masks
			 '("\\.java$" my-java-flymake-init flymake-simple-cleanup))

(add-hook 'java-mode-hook
		  '(lambda ()
			 (semantic-add-system-include (getenv "JAVA_HOME") 'java-mode)))

(add-to-list 'ac-modes 'malabar-mode)
