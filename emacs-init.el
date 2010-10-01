;; Store custom configuration in a shared folder
(setq custom-file (concat emacs-local-site-lisp "custom.el"))
(load custom-file)

;; Basic config
(setq inhibit-splash-screen t)
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)
;; Display the current time
(setq display-time-day-and-date t)
(display-time)
;; Show column number at bottom of screen
(column-number-mode 1)
;; Don't add new lines when scrolling down at end of buffer
(setq next-line-add-newlines nil)
;; Pgup/Pgdn will return exactly to the starting point
(setq scroll-preserve-screen-position 1)
;; Format the title bar to always include the buffer name
(setq frame-title-format "emacs - %f")
;; Turn on word wrapping in text mode
(add-hook 'text-mode-hook 'turn-on-auto-fill)
;; replace highlighted text with what I type
(delete-selection-mode t)
;; Resize the minibuffer when necessary
(setq resize-minibuffer-mode t)
;; highlight during searching
(setq query-replace-highlight t)
(setq search-highlight t)

;; Set the default tab width to 4 spaces
(setq tab-width 4)
(setq c-basic-offset 4)

;; Change the font to something nicer
(set-default-font "-outline-Consolas-normal-r-normal-normal-14-97-96-96-c-*-iso8859-1")

;; Disable the menu bar and the tool bar

(if (fboundp 'menu-bar-mode)
	(menu-bar-mode 1))
(if (fboundp 'tool-bar-mode)
	(tool-bar-mode 0))

(if (fboundp 'global-visual-line-mode)
	(global-visual-line-mode))

;; Load flyspell
(autoload 'flyspell-mode "flyspell" "On-the-fly spelling checker" t)
(autoload 'flyspell-delay-command "flyspell" "Delay on command" t)
(autoload 'tex-mode-flyspell-verify "flyspell" "" t)

;; (cua-mode t)
(setq-default transient-mark-mode t)
(transient-mark-mode 1) ;; No region when it is not highlighted
;; (setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

(load-library "my-functions.el")
(load-library "cygwin-config.el")
(load-library "gnus-config.el")
(load-library "bbdb-config.el")
(load-library "yasnippet-config.el")
(load-library "development-config.el")
(load-library "maven-config.el")
(load-library "c-c++-config.el")
(load-library "java-config.el")
(load-library "ruby-config.el")
(load-library "xml-html-config.el")
(load-library "ahk-config.el")
(load-library "org-mode.el")
(load-library "muse-config.el")
(load-library "weblogger-config.el")

(require 'ido)
(ido-mode t)

(require 'window-numbering)
(window-numbering-mode 1)

(require 'tempo-snippets)

(require 'paren) (show-paren-mode t)
(require 'whitespace)
(require 'psvn)

;; w3m stuff
(add-local-load-path "w3m")
(require 'w3m-load)

;; w3 stuff
(add-local-load-path "w3/lisp")
(require 'w3-auto)

;; http://www.emacswiki.org/cgi-bin/wiki.pl?ColorTheme
(add-local-load-path "color-theme-6.6.0")
(add-local-load-path "color-theme-6.6.0/themes")
(require 'color-theme)
(load-library "color-theme-colorful-obsolescence.el")
(load-library "color-theme-active.el")
(load-library "color-theme-wombat.el")
(load-library "zen-and-art.el")
(color-theme-initialize)
;;(color-theme-wombat)
(color-theme-zen-and-art)

;; http://user.it.uu.se/~mic/pager.el
(require 'pager)
(global-set-key "\C-v"	   'pager-page-down)
(global-set-key [next] 	   'pager-page-down)
(global-set-key "\ev"	   'pager-page-up)
(global-set-key [prior]	   'pager-page-up)
(global-set-key '[M-up]    'pager-row-up)
(global-set-key '[M-kp-8]  'pager-row-up)
(global-set-key '[M-down]  'pager-row-down)
(global-set-key '[M-kp-2]  'pager-row-down)

;; Kill trailing whitespace on save
(autoload 'nuke-trailing-whitespace "nuke-whitespace" nil t)
(add-hook 'write-file-hooks 'nuke-trailing-whitespace)

;; Highlight matches from searches
(setq isearch-highlight t)
(setq search-highlight t)
(when (fboundp 'blink-cursor-mode)
  (blink-cursor-mode -1))

;; ============================
;; Set up which modes to use for which file extensions
;; ============================
(setq auto-mode-alist
      (append
       '(
	 ("\\.dps$"           . pascal-mode)
	 ("\\.py$"            . python-mode)
	 ("\\.Xdefaults$"     . xrdb-mode)
	 ("\\.Xenvironment$"  . xrdb-mode)
	 ("\\.Xresources$"    . xrdb-mode)
	 ) auto-mode-alist))
