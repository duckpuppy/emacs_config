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

;; Support a tag ring in semantic mode
(defvar semantic-tags-location-ring (make-ring 20))

(defun semantic-goto-definition (point)
  "Goto definition using semantic-ia-fast-jump and save the pointer marker if tag is found"
  (interactive "d")
  (condition-case err
	  (progn
		(ring-insert semantic-tags-location-ring (point-marker))
		(semantic-ia-fast-jump point))
	(error
	 ;; if not found remove the tag saved in the ring
	 (set-marker (ring-remove semantic-tags-location-ring 0) nil nil)
	 (signal (car err) (cdr err)))))

(defun semantic-pop-tag-mark ()
  "popup the tag saved by semantic-goto-definition"
  (interactive)
  (if (ring-empty-p semantic-tags-location-ring)
	  (message "%s" "No tags available")
	(let* ((marker (ring-remove semantic-tags-location-ring 0))
		   (buff (marker-buffer marker))
		   (pos (marker-position marker)))
	  (if (not buff)
		  (message "Buffer has been deleted")
		(switch-to-buffer buff)
		(goto-char pos))
	  (set-marker marker nil nil))))

;; GNU Global support
(require 'gtags)

(add-hook 'gtags-mode-hook
	(lambda()
		(local-set-key (kbd "M-.") 'gtags-find-tag)
		(local-set-key (kbd "M-,") 'gtags-find-rtag)))

(add-hook 'c-mode-common-hook
		  (lambda()
			(local-set-key (kbd "C-cj") 'semantic-goto-definition)
			(local-set-key (kbd "C-cp") 'semantic-pop-tag-mark)
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
