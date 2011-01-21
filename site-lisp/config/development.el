(add-local-load-path "cedet-1.0")
(add-local-load-path "ecb-2.40")

;; Load CEDET
(load-file (concat emacs-local-site-lisp "cedet-1.0/common/cedet.el"))

;; Enable EDE (Project Management) features
(global-ede-mode 1)

;; Enabling various SEMANTIC minor modes.  See semantic/INSTALL for more ideas.
;; Select one of the following:

;; * This enables the database and idle reparse engines
;;(semantic-load-enable-minimum-features)

;; * This enables some tools useful for coding, such as summary mode
;;   imenu support, and the semantic navigator
;; (semantic-load-enable-code-helpers)

;; * This enables even more coding tools such as the nascent intellisense mode
;;   decoration mode, and stickyfunc mode (plus regular code helpers)
;; (semantic-load-enable-guady-code-helpers)

;; * This turns on which-func support (Plus all other code helpers)
(semantic-load-enable-excessive-code-helpers)

;; This turns on modes that aid in grammar writing and semantic tool
;; development.  It does not enable any other features such as code
;; helpers above.
;; (semantic-load-enable-semantic-debugging-helpers)

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

;; Only load Perforce support on my work laptop
(if (is-work-laptop)
	;; Load P4 support
	(progn
	  (add-local-load-path "p4")
	  (require 'p4)
	  (setq p4-do-find-file nil)
	  (require 'vc-p4)
	  (if (eq system-type 'windows-nt)
		  (p4-set-p4-executable "c:/program files/perforce/p4.exe"))))

(require 'psvn)
