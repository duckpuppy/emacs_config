(load-file "~/.emacs.d/site-lisp/cedet-1.1/common/cedet.el")

;; Enable EDE (Project Management) features
(global-ede-mode t)

(semantic-load-enable-excessive-code-helpers)
(require 'semantic-ia)

(global-set-key "\r" 'reindent-then-newline-and-indent)

(autoload 'gtags-mode "gtags" "" t)

;; enable semanticdb support for gnu global
(when (cedet-gnu-global-version-check t)
  (require 'semanticdb-global)
  (semanticdb-enable-gnu-global-databases 'c-mode)
  (semanticdb-enable-gnu-global-databases 'c++-mode))

;; ECB
(add-local-load-path "ecb-2.40")
(require 'ecb-autoloads)

;; Magit
(add-local-load-path "magit-1.1.1")
(require 'magit)
