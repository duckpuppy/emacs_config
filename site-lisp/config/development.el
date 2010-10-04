(add-local-load-path "cedet-1.0")
;(add-local-load-path "cedet-1.0/semantic")
;(add-local-load-path "cedet-1.0/eieio")
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
(semantic-load-enable-code-helpers)

;; * This enables even more coding tools such as the nascent intellisense mode
;;   decoration mode, and stickyfunc mode (plus regular code helpers)
;; (semantic-load-enable-guady-code-helpers)

;; * This turns on which-func support (Plus all other code helpers)
;; (semantic-load-enable-excessive-code-helpers)

;; This turns on modes that aid in grammar writing and semantic tool
;; development.  It does not enable any other features such as code
;; helpers above.
;; (semantic-load-enable-semantic-debugging-helpers)

;; ============================
;; Load ECB
;; ============================
(require 'ecb)

(setq ecb-tip-of-the-day nil)
(setq ecb-primary-secondary-mouse-buttons (quote mouse-1--mouse-2))
;(ecb-activate)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(ecb-layout-window-sizes (quote (("left8" (ecb-directories-buffer-name 0.23671497584541062 . 0.29310344827586204) (ecb-sources-buffer-name 0.23671497584541062 . 0.22413793103448276) (ecb-methods-buffer-name 0.23671497584541062 . 0.25862068965517243) (ecb-history-buffer-name 0.23671497584541062 . 0.20689655172413793)))))
 '(ecb-gzip-setup (quote cons))
 '(ecb-options-version "2.40")
 '(ecb-primary-secondary-mouse-buttons (quote mouse-1--C-mouse-1))
 '(ecb-tar-setup (quote cons))
 '(ecb-wget-setup (quote cons))
 )

;; mode-compile configuration
;; http://perso.tls.cena.fr/boubaker/distrib/mode-compile.el
(autoload 'mode-compile "mode-compile"
  "Command to compile current buffer file based on the major mode" t)
(global-set-key "\C-cc" 'mode-compile)
(autoload 'mode-compile-kill "mode-compile"
  "Command to kill a compilation launched by `mode-compile'" t)
(global-set-key "\C-ck" 'mode-compile-kill)

;; Load git support
;(add-local-load-path "git-emacs")
;(require 'git-emacs)
;(require 'git-status)
(add-local-load-path "magit")
(require 'magit)
(global-set-key "\C-cg" 'magit-status)

;; Load P4 support
;(add-local-load-path "p4")
;(require 'p4)
;(setq p4-do-find-file nil)
;(require 'vc-p4)
;(if (eq system-type 'windows-nt)
;	(p4-set-p4-executable "c:/program files/perforce/p4.exe"))
;(p4-set-p4-port "nrc-perforce.devlab.norc.s1.com:1666")

(require 'psvn)
