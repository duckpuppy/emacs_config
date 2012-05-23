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

;; Disable vc-git, since I'm using magit
(require 'vc)
(delete 'Git vc-handled-backends)
(remove-hook 'find-file-hooks 'vc-find-file-hook)

;; Magit
(add-local-load-path "magit-1.1.1")
(require 'magit)

;; ==========================
;; Indentation
;; ==========================
(defun my-c-mode-common-hook ()
  (turn-on-font-lock)
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'case-label '+)
;;  (c-set-offset 'arglist-cont-nonempty c-lineup-arglist))
)
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

;; nXhtml
(load "~/.emacs.d/site-lisp/nxhtml/autostart.el")

;; Perforce
(if (is-work-machine)
	;; Load P4 support
	(progn
	  (require 'p4)
	  (setq p4-do-find-file nil)))

;; Autocomplete
(add-local-load-path "auto-complete-1.3.1")
(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/site-lisp/auto-complete-1.3.1/dict")
(ac-config-default)

(add-hook 'c-mode-common-hook
		  (lambda ()
			(add-to-list 'ac-sources 'ac-source-semantic)))
