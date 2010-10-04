;; Ruby configuration
(add-local-load-path "ruby")
(autoload 'ruby-mode "ruby-mode" "Major mode for editing Ruby code" t)
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")
(add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rbw$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rjs$" . ruby-mode))
(add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))
(add-hook 'ruby-mode-hook (lambda () (inf-ruby-keys)))
(add-hook 'ruby-mode-hook (lambda () (local-set-key "\r" 'newline-and-indent)))
(add-hook 'ruby-mode-hook 'turn-on-font-lock)

(add-local-load-path "ruby-block")
(require 'ruby-block)

(require 'ruby-electric)
;; ruby electric
(defun try-complete-abbrev (old)
  (if (expand-abbrev) t nil))
(setq hippie-expand-try-functions-list
     '(try-complete-abbrev
   try-complete-file-name
   try-expand-dabbrev))

(defun my-ruby-mode-hook ()
  ;;  (make-variable-buffer-local 'compilation-error-regexp-alist)
  ;;   (setq compilation-error-regexp-alist
  ;;        (append compilation-error-regexp-alist
  ;;                (list (list
  ;;                       (concat "\\(.*?\\)\\([0-9A-Za-z_./\:-]+\\.rb\\):\\([0-9]+\\)") 2 3))))
  ;;  (make-variable-buffer-local 'compile-command)
  ;;  (setq compile-command (concat "ruby " (buffer-file-name) " "))
  (imenu-add-to-menubar "IMENU")
  (ruby-electric-mode t)
  (ruby-block-mode t)
  (define-key ruby-mode-map "\C-c\C-a" 'ruby-eval-buffer)
  (setq standard-indent 2)
  (local-set-key "\M-\C-i" 'ri-ruby-complete-symbol)
  (define-key ruby-mode-map "\M-\C-o" 'rct-complete-symbol)
  (local-set-key (kbd "<return>") 'newline-and-indent)
  (set (make-local-variable 'indent-tabs-mode) 'nil)
  (set (make-local-variable 'tab-width) 2)
  )

(require 'compile)
(add-hook 'ruby-mode-hook 'my-ruby-mode-hook)
(autoload 'rubydb "rubydb3x" "Ruby debugger" t)

(defun ruby-eval-buffer () (interactive)
  "Evaluate the buffer with ruby."
  (shell-command-on-region (point-min)(point-max) "ruby"))

;; yaml
(add-local-load-path "yaml-mode")
(require 'yaml-mode)
(add-to-list 'auto-mode-alist '("\\.yml$" . yaml-mode))

;; ri-emacs
(add-local-load-path "ri-emacs")
(setq ri-ruby-script (expand-file-name "~/.emacs.d/site-lisp/ri-emacs/ri-emacs.rb"))
(autoload 'ri (expand-file-name "~/.emacs.d/site-lisp/ri-emacs/ri-ruby.el") nil t)
(load-library "ri-ruby.el")

;; Rinari
(add-local-load-path "rinari")
(require 'rinari)
(setq rinari-tags-file-name "TAGS")

(add-local-load-path "autotest")
(require 'autotest)

;; yasnippet rails
(load-library "~/.emacs.d/site-lisp/yasnippets-rails/setup.el")

;; autocomplete
   (add-hook 'ruby-mode-hook
             (lambda ()
               (setq ac-omni-completion-sources '(("\\.\\=" ac-source-rcodetools)))));)

;; flymake
;(add-hook 'ruby-mode-hook
;          '(lambda ()

             ;; Don't want flymake mode for ruby regions in rhtml files and also on read only files
;             (if (and (not (null buffer-file-name)) (file-writable-p buffer-file-name))
;                 (flymake-mode))
;             ))

;; Invoke ruby with '-c' to get syntax checking
;(defun flymake-ruby-init ()
;  (let* ((temp-file   (flymake-init-create-temp-buffer-copy
;                       'flymake-create-temp-intemp))
;         (local-file  (file-relative-name
;                       temp-file
;                       (file-name-directory buffer-file-name))))
;    (list "ruby" (list "-c" local-file))))

;(push '(".+\\.rb$" flymake-ruby-init) flymake-allowed-file-name-masks)
;(push '(".+\\.rjs$" flymake-ruby-init) flymake-allowed-file-name-masks)
;(push '("Rakefile$" flymake-ruby-init) flymake-allowed-file-name-masks)

;; rcodetools
;(add-local-load-path "rcodetools")
;(require 'anything-rcodetools)
;(setq rct-get-all-methods-command "PAGER=cat fri -l -L")
;(define-key anything-map "\C-z" 'anything-execute-persistent-action)
