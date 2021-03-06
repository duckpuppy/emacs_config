;; Ruby configuration
(add-local-load-path "ruby")
(autoload 'ruby-mode "ruby-mode" "Major mode for editing Ruby code" t)
(autoload 'run-ruby "inf-ruby" "Run an inferior Ruby process")
(autoload 'inf-ruby-keys "inf-ruby" "Set local key defs for inf-ruby in ruby-mode")

(eval-after-load "ruby-mode"
  '(progn
	 (add-to-list 'auto-mode-alist '("\\.rb$" . ruby-mode))
	 (add-to-list 'auto-mode-alist '("\\.rbw$" . ruby-mode))
	 (add-to-list 'auto-mode-alist '("\\.rjs$" . ruby-mode))
	 (add-to-list 'auto-mode-alist '("\\.rake$" . ruby-mode))
	 (add-to-list 'auto-mode-alist '("\\.gemspec$" . ruby-mode))
	 (add-to-list 'auto-mode-alist '("\\.ru$" . ruby-mode))
	 (add-to-list 'auto-mode-alist '("Rakefile$" . ruby-mode))
	 (add-to-list 'auto-mode-alist '("Gemfile$" . ruby-mode))
	 (add-to-list 'auto-mode-alist '("Capfile$" . ruby-mode))
	 (add-to-list 'auto-mode-alist '("Vagrantfile$" . ruby-mode))
	 (add-to-list 'interpreter-mode-alist '("ruby" . ruby-mode))
	 (add-hook 'ruby-mode-hook 'inf-ruby-keys)
	 ;(add-hook 'ruby-mode-hook (lambda () (local-set-key "\r" 'newline-and-indent)))
	 (add-hook 'ruby-mode-hook 'turn-on-font-lock)

	 (define-key ruby-mode-map (kbd "RET") 'reindent-then-newline-and-indent)
	 (define-key ruby-mode-map (kbd "C-c l") "lambda")
	 ))

(global-set-key (kbd "C-h r") 'ri)

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

(setq ruby-electric-expand-delimiters-list nil)

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
(autoload 'autotest-switch "autotest" "doco" t)
(autoload 'autotest "autotest" "doco" t)
(add-hook 'ruby-mode-hook
		  '(lambda ()
			 (define-key ruby-mode-map (kbd "C-c C-a") 'autotest-switch)))

;; yasnippet rails
(load-library "~/.emacs.d/site-lisp/yasnippets-rails/setup.el")

;; autocomplete
(add-hook 'ruby-mode-hook
		  (lambda ()
			(setq ac-omni-completion-sources '(("\\.\\=" ac-source-rcodetools)))));)

;; rcodetools
(add-local-load-path "rcodetools")
(require 'anything-rcodetools)
(setq rct-get-all-methods-command "PAGER=cat fri -l -L")
(define-key anything-map "\C-z" 'anything-execute-persistent-action)

										;(defvar my-ruby-close-brace-goto-close t)
										;(defun my-ruby-close-brace ()
										;  "replacement for ruby-electric-brace for the close brace"
										;  (interactive)
										;  (let ((p (point)))
										;    (if my-ruby-close-brace-goto-close
										;        (unless (search-forward "}" nil t)
										;          (message "No close brace found")
										;          (insert "}"))
										;      (insert "}")
										;      (save-excursion (if (search-forward "}" nil t)
										;                           (delete-char -1))))))
										;(define-key ruby-mode-map "}" 'my-ruby-close-brace)
