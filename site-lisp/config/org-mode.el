;;
;; Org Mode
;;
(add-local-load-path "org-7.8.09")
(add-local-load-path "org-7.8.09/lisp")
(add-local-load-path "org-7.8.09/contrib/lisp")

(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))

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
(setq org-agenda-diary-file "~/Dropbox/Org/diary.org")

;; Ignore S-left and S-right as far as logging time stamps and notes on state change
(setq org-treat-S-cursor-todo-selection-as-state-change nil)

;; Setup logging
(setq org-log-done (quote time))
(setq org-log-into-drawer t)

(setq org-todo-keywords
      '((sequence "TODO(t)" "NEXT(n)" "STARTED(s!)" "|" "DONE(d!/!)")
		(sequence "WAITING(W@/!)" "SOMEDAY(S!)" "HOLD(h@/!)" "|" "CANCELLED(c@/!)" "PHONE")))

(setq org-todo-keyword-faces (quote (("TODO" :foreground "red" :weight bold)
									 ("NEXT" :foreground "blue" :weight bold)
									 ("STARTED" :foreground "blue" :weight bold)
									 ("DONE" :foreground "forest green" :weight bold)
									 ("WAITING" :foreground "orange" :weight bold)
									 ("SOMEDAY" :foreground "magenta" :weight bold)
									 ("HOLD" :foreground "magenta" :weight bold)
									 ("CANCELLED" :foreground "forest green" :weight bold)
									 ("PHONE" :foreground "forest green" :weight bold))))

(setq org-todo-state-tags-triggers
	  (quote (("CANCELLED" ("CANCELLED" . t))
			  ("WAITING" ("WAITING" . t))
			  ("HOLD" ("WAITING" . t) ("HOLD" . t))
			  (done ("WAITING") ("HOLD"))
			  ("TODO" ("WAITING") ("CANCELLED") ("HOLD"))
			  ("NEXT" ("WAITING") ("CANCELLED") ("HOLD"))
			  ("STARTED" ("WAITING") ("CANCELLED") ("HOLD"))
			  ("DONE" ("WAITING") ("CANCELLED") ("HOLD")))))

(setq org-agenda-files (quote ("~/Dropbox/Org")))

;; Targets include this file and any file contributing to the agenda - up to 5 levels deep
(setq org-refile-targets (quote ((org-agenda-files :maxlevel . 5) (nil :maxlevel . 5))))

;; Targets start with the file name - allows creating level 1 tasks
(setq org-refile-use-outline-path (quote file))

;; Targets complete in steps so we start with filename, TAB shows the next level of targets etc
(setq org-outline-path-complete-in-steps t)

;; Allow refile to create parent tasks with confirmation
(setq org-refile-allow-creating-parent-nodes (quote confirm))

(setq org-directory "~/Dropbox/Org")

;; org-capture setup
(setq org-default-notes-file "~/Dropbox/Org/refile.org")
(define-key global-map "\C-cc" 'org-capture)
(setq org-capture-templates
	  (quote
	   (("c"
		 "Web clipping"
		 entry
		 (file+headline "~/Dropbox/Org/refile.org" "Clippings")
		 "* %^{Title|%:description}\n\n  %u\n  Source: %c\n\n  %i"
		 :empty-lines 1
		 :immediate-finish t)
		("t"
		 "TODO"
		 entry
		 (file "~/Dropbox/Org/refile.org")
		 "* TODO %?\n%U\n%a\n"
		 :clock-resume t)
		("j"
		 "Journal"
		 entry
		 (file+datetree "~/Dropbox/Org/diary.org")
		 "* %?\n%U\n"
		 :clock-resume t)
		("n"
		 "note"
		 entry
		 (file "~/Dropbox/Org/refile.org")
		 "* %? :NOTE:\n%U\n%a\n"
		 :clock-resume t)
		("p"
		 "Phone call"
		 entry
		 (file "~/Dropbox/Org/refile.org")
		 "* PHONE %? :PHONE:\n%U"
		 :clock-in t :clock-resume t)
		)))

;; Remove empty LOGBOOK drawers on clock-out
(defun bh/remove-empty-drawer-on-clock-out ()
  (interactive)
  (save-excursion
	(beginning-of-line 0)
	(org-remove-empty-drawer-at "LOGBOOK" (point))))
(add-hook 'org-clock-out-hook 'bh/remove-empty-drawer-on-clock-out 'append)

;; ditaa
(setq org-ditaa-jar-path (concat emacs-local-site-lisp "org-7.8.09/contrib/scripts/ditaa.jar"))

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
              ("A" "Tasks to be Archived" tags "LEVEL=2/DONE|CANCELLED" nil))))

;; MobileOrg
(setq org-mobile-directory "~/Dropbox/MobileOrg")
(setq org-mobile-inbox-for-pull "~/Dropbox/Org/refile.org")

;; org-protocol
(require 'org-protocol)

;; Global key bindings
(global-set-key (kbd "<f12>") 'org-agenda)
(global-set-key (kbd "C-c r") 'org-capture)
