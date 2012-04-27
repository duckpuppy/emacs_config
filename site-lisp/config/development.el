(add-local-load-path "ecb-snap")
(add-local-load-path "gtags")

;; Enable EDE (Project Management) features
(semantic-mode 1)
;; (global-ede-mode 'nil)

(global-semantic-idle-summary-mode)
(global-semantic-idle-completions-mode)
(global-semantic-decoration-mode)
(global-semantic-highlight-func-mode)
(global-semantic-stickyfunc-mode)

;; ============================
;; Load ECB
;; ============================
(require 'ecb-autoloads)

(setq ecb-tip-of-the-day nil)
(setq ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))

;; mode-compile configuration
;; http://perso.tls.cena.fr/boubaker/distrib/mode-compile.el
(autoload 'mode-compile "mode-compile"
  "Command to compile current buffer file based on the major mode" t)
(global-set-key "\C-cc" 'mode-compile)
(autoload 'mode-compile-kill "mode-compile"
  "Command to kill a compilation launched by `mode-compile'" t)
(global-set-key "\C-ck" 'mode-compile-kill)

(global-set-key "\r" 'reindent-then-newline-and-indent)

;; Load git support
(add-local-load-path "magit")
(require 'magit)
(global-set-key "\C-cg" 'magit-status)

;; GNU Global support
(require 'gtags)

(add-hook 'gtags-mode-hook
	(lambda()
		(local-set-key (kbd "M-.") 'gtags-find-tag)
		(local-set-key (kbd "M-,") 'gtags-find-rtag)))

(add-hook 'c-mode-common-hook
	(lambda()
		(gtags-mode t)))

;; Only load Perforce support on my work laptop
(if (is-work-machine)
	;; Load P4 support
	(progn
	  (add-local-load-path "p4")
	  (require 'p4)
	  (setq p4-do-find-file nil)
	  (require 'vc-p4)
	  (if (eq system-type 'windows-nt)
		  (p4-set-p4-executable "c:/program files/perforce/p4.exe"))))

(require 'psvn)
