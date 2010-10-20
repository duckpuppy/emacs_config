;;
;; Org Mode
;;
(add-local-load-path "org-7.01h")
(add-local-load-path "org-7.01h/lisp")
(add-local-load-path "org-7.01h/contrib/lisp")

(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
;(require 'org-install)
(require 'loaddefs)

;;
;; Standard key bindings
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(define-key global-map "\C-cb" 'org-iswitchb)

(setq org-hide-leading-stars t)
(setq org-odd-levels-only t)
(setq org-completion-use-ido t)
(setq org-return-follows-link t)
(setq org-blank-before-new-entry '((heading . nil) (plain-list-item . nil)))

;; Task state can be changed using C-c C-t KEY
(setq org-use-fast-todo-selection t)

;; Do not consider the diary and calendar in org mode agenda
(setq org-agenda-include-diary nil)
(setq org-agenda-diary-file "~/org/diary.org")

;; Ignore S-left and S-right as far as logging time stamps and notes on state change
(setq org-treat-S-cursor-todo-selection-as-state-change nil)

;; Setup logging
(setq org-log-done (quote time))
(setq org-log-into-drawer t)

(setq org-todo-keywords
      '((sequence "TODO(t)" "STARTED(s!)" "|" "DONE(d!/!)")
	(sequence "WAITING(W@/!)" "SOMEDAY(S!)" "OPEN(O@)" "|" "CANCELLED(c@/!)")
	(sequence "REPORT(r@)" "BUG(b)" "KNOWNCAUSE(k@/!)" "|" "FIXED(f!)")
	;;	(sequence "|" "CANCELLED(c)")
	))

(setq org-todo-keyword-faces (quote (("TODO" :foreground "red" :weight bold)
				     ("STARTED" :foreground "blue" :weight bold)
				     ("DONE" :foreground "forest green" :weight bold)
				     ("WAITING" :foreground "orange" :weight bold)
				     ("SOMEDAY" :foreground "magenta" :weight bold)
				     ("CANCELLED" :foreground "forest green" :weight bold)
				     ("QUOTE" :foreground "red" :weight bold)
				     ("QUOTED" :foreground "magenta" :weight bold)
				     ("APPROVED" :foreground "forest green" :weight bold)
				     ("EXPIRED" :foreground "forest green" :weight bold)
				     ("REJECTED" :foreground "forest green" :weight bold)
				     ("OPEN" :foreground "blue" :weight bold))))

(setq org-tag-alist '((:startgroup . nil)
		      ("@work" . ?w) ("@home" . ?h)
		      (:endgroup . nil)
		      ("buy" . ?b) ("@comics" . ?c)
		      ("NEXT" . ?n) ("WAITING" . ?W)
		      ("PHONE" . ?p)
))

;; Enable orgstruct++-mode in Gnus message buffers to aid in creating structured email messages
(setq message-mode-hook
      (quote (orgstruct++-mode
	      (lambda nil (setq fill-column 72) (flyspell-mode 1))
	      turn-on-auto-fill
	      bbdb-define-all-aliases)))

;; Make TAB the yas trigger key in the org-mode-hook and turn on flyspell mode
(add-hook 'org-mode-hook
	  (lambda ()
	    ;; yasnippet
	    (make-variable-buffer-local 'yas/trigger-key)
	    (setq yas/trigger-key [tab])
	    (define-key yas/keymap [tab] 'yas/next-field-group)
	    ;; flyspell mode to spell check everywhere
	    (flyspell-mode 1)))

;; Use IDO for target completion
(setq org-completion-use-ido t)

;; Targets include this file and any file contributing to the agenda - up to 5 levels deep
(setq org-refile-targets (quote ((org-agenda-files :maxlevel . 5) (nil :maxlevel . 5))))

;; Targets start with the file name - allows creating level 1 tasks
(setq org-refile-use-outline-path (quote file))

;; Targets complete in steps so we start with filename, TAB shows the next level of targets etc
(setq org-outline-path-complete-in-steps t)

;; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

;; org-remember setup
(setq org-default-notes-file "~/org/refile.org")
(require 'remember)
(org-remember-insinuate)
(global-set-key (kbd "C-M-r") 'org-remember)
(setq org-remember-store-without-prompt t)
(setq org-remember-default-headline "Tasks")
(setq org-remember-templates (quote (("todo" ?t "* TODO %?\n  %u\n  %a" nil bottom nil)
                                     ("note" ?n "* %?                                        :NOTE:\n  :CLOCK:\n  :END:\n  %U\n  %a" nil bottom nil)
                                     ("phone" ?p "* PHONE %:name - %:company -                :PHONE:\n  Contact Info: %a\n  %u\n  %?" nil bottom nil)
                                     ("appointment" ?a "* %?\n  %U" "~/org/todo.org" "Appointments" nil))))

;; ditaa
(setq org-ditaa-jar-path (concat emacs-local-site-lisp "org-7.01h/contrib/scripts/ditaa.jar"))

(org-babel-do-load-languages
 'org-babel-load-languages
 '((R . t)
   (ditaa . t)
   (dot . t)
   (emacs-lisp . t)
   (gnuplot . t)
   (haskell . nil)
   (ocaml . nil)
   (python . t)
   (ruby . t)
   (screen . nil)
   (sh . t)
   (sql . nil)
   (sqlite . t)))

;; Custom agenda views
(setq org-agenda-custom-commands
      (quote (("s" "Started Tasks" todo "STARTED" ((org-agenda-todo-ignore-scheduled nil)
                                                   (org-agenda-todo-ignore-deadlines nil)
                                                   (org-agenda-todo-ignore-with-date nil)))
              ("w" "Tasks waiting on something" tags "WAITING/!" ((org-use-tag-inheritance nil)))
              ("r" "Refile New Notes and Tasks" tags "LEVEL=1+REFILE" ((org-agenda-todo-ignore-with-date nil)
                                                                       (org-agenda-todo-ignore-deadlines nil)
                                                                       (org-agenda-todo-ignore-scheduled nil)))
              ("N" "Notes" tags "NOTE" nil)
              ("n" "Next" tags "NEXT-WAITING-CANCELLED/!" nil)
              ("p" "Projects" tags-todo "LEVEL=2-NEXT-WAITING-CANCELLED/!-DONE" nil)
              ("A" "Tasks to be Archived" tags "LEVEL=2/DONE|CANCELLED" nil)
              ("h" "Habits" tags "STYLE=\"habit\"" ((org-agenda-todo-ignore-with-date nil) (org-agenda-todo-ignore-scheduled nil) (org-agenda-todo-ignore-deadlines nil))))))

;; Nice keybindings
(global-set-key (kbd "<f12>") 'org-agenda)
;;(global-set-key (kbd "<f5>") 'bh/org-todo)
(global-set-key (kbd "<S-f5>") 'widen)
(global-set-key (kbd "<f7>") 'set-truncate-lines)
(global-set-key (kbd "<f8>") 'org-cycle-agenda-files)
(global-set-key (kbd "<f9> b") 'bbdb)
(global-set-key (kbd "<f9> c") 'calendar)
(global-set-key (kbd "<f9> f") 'boxquote-insert-file)
(global-set-key (kbd "<f9> g") 'gnus)
(global-set-key (kbd "<f9> h") 'hide-other)
;;(global-set-key (kbd "<f9> i") (lambda ()
;;                                 (interactive)
;;                                 (info "~/.emacs.d/org-6.34c/doc/org.info")))
;;(global-set-key (kbd "<f9> m") 'bh/clock-in-read-mail-and-news-task)
;;(global-set-key (kbd "<f9> o") 'bh/clock-in-organization-task)
;;(global-set-key (kbd "<f9> O") 'org-clock-out)
(global-set-key (kbd "<f9> r") 'boxquote-region)
(global-set-key (kbd "<f9> s") (lambda () (interactive) (switch-to-buffer "*scratch*") (delete-other-windows)))
;;(global-set-key (kbd "<f9> t") 'bh/insert-inactive-timestamp)
(global-set-key (kbd "<f9> u") (lambda ()
                                 (interactive)
                                 (untabify (point-min) (point-max))))
(global-set-key (kbd "<f9> v") 'visible-mode)
;;(global-set-key (kbd "<f9> SPC") 'bh/clock-in-interrupted-task)
(global-set-key (kbd "C-<f9>") 'previous-buffer)
(global-set-key (kbd "C-x n r") 'narrow-to-region)
(global-set-key (kbd "C-<f10>") 'next-buffer)
;;(global-set-key (kbd "<f11>") 'org-clock-goto)
;;(global-set-key (kbd "C-<f11>") 'org-clock-in)
;;(global-set-key (kbd "C-s-<f12>") 'bh/save-then-publish)
;;(global-set-key (kbd "M-<f11>") 'org-resolve-clocks)
(global-set-key (kbd "C-M-r") 'org-remember)
