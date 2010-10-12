;; Basic config
(setq inhibit-splash-screen t)
(setq initial-scratch-message nil)
(global-font-lock-mode t)
(setq font-lock-maximum-decoration t)
(setq require-final-newline t)
(setq default-directory "~/")
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
(set-default-font "-outline-Inconsolata-normal-r-normal-normal-14-97-96-96-c-*-iso8859-1")

;; Disable the menu bar and the tool bar

(if (fboundp 'menu-bar-mode)
	(menu-bar-mode 1))
(if (fboundp 'tool-bar-mode)
	(tool-bar-mode 0))

(if (fboundp 'global-visual-line-mode)
	(global-visual-line-mode))

;; (cua-mode t)
(setq-default transient-mark-mode t)
(transient-mark-mode t) ;; No region when it is not highlighted
;; (setq cua-keep-region-after-copy t) ;; Standard Windows behaviour

(require 'ido)
(ido-mode t)

;; Highlight matches from searches
(setq isearch-highlight t)
(setq search-highlight t)
(when (fboundp 'blink-cursor-mode)
  (blink-cursor-mode -1))

;; Kill trailing whitespace on save
(add-local-load-path "nuke-whitespace")
(autoload 'nuke-trailing-whitespace "nuke-whitespace" nil t)
(add-hook 'write-file-hooks 'nuke-trailing-whitespace)

(add-local-load-path "window-numbering")
(require 'window-numbering)
(window-numbering-mode 1)

(require 'paren) (show-paren-mode t)
(require 'whitespace)

;; redo
(add-local-load-path "redo-plus")
(require 'redo+)
(global-set-key [(control -)] 'redo)

;; find-recursive
(add-local-load-path "find-recursive")
(require 'find-recursive)

;; anything
(add-local-load-path "anything")
(require 'anything)
;; TODO This messes with CEDET, find out why
;(require 'anything-config)

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

;; This seems to have disappeared in Emacs 23.2
(setq warning-suppress-types nil)
