;; Define an "indent-whole-buffer" function
(defun indent-whole-buffer ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  )
(global-set-key "\C-x\C-i" 'indent-whole-buffer)

;; Define a helper function to add a local path to the load path
(defun add-local-load-path (path-string)
	(message (format "Adding %S to load path" (concat emacs-local-site-lisp path-string)))
	(add-to-list 'load-path (concat emacs-local-site-lisp path-string)))

;; show ascii table
;; obtained from http://www.chrislott.org/geek/emacs/dotemacs.html
(defun ascii-table ()
  "Print the ascii table. Based on a defun by Alex Schroeder <asc@bsiag.com>"
  (interactive)
  (switch-to-buffer "*ASCII*")
  (erase-buffer)
  (insert (format "ASCII characters up to number %d.\n" 254))
  (let ((i 0))
    (while (< i 254)
      (setq i (+ i 1))
      (insert (format "%4d %c\n" i i))))
  (beginning-of-buffer))


;; insert date into buffer at point
;; obtained from http://www.chrislott.org/geek/emacs/dotemacs.html
(defun insert-date ()
  "Insert date at point."
  (interactive)
  (insert (format-time-string "%a %Y-%m-%d - %l:%M %p")))


;; Centering code stolen from somewhere and restolen from
;; http://www.chrislott.org/geek/emacs/dotemacs.html
;; centers the screen around a line...
(global-set-key [(control l)]  'centerer)
(defun centerer ()
   "Repositions current line: once middle, twice top, thrice bottom"
   (interactive)
   (cond ((eq last-command 'centerer2)  ; 3 times pressed = bottom
          (recenter -1))
         ((eq last-command 'centerer1)  ; 2 times pressed = top
          (recenter 0)
          (setq this-command 'centerer2))
         (t                             ; 1 time pressed = middle
          (recenter)
          (setq this-command 'centerer1))))


;; Kills live buffers, leaves some emacs work buffers
;; obtained from http://www.chrislott.org/geek/emacs/dotemacs.html
(defun nuke-some-buffers (&optional list)
  "For each buffer in LIST, kill it silently if unmodified. Otherwise ask.
LIST defaults to all existing live buffers."
  (interactive)
  (if (null list)
      (setq list (buffer-list)))
  (while list
    (let* ((buffer (car list))
           (name (buffer-name buffer)))
      (and (not (string-equal name ""))
           ;(not (string-equal name "*Messages*"))
          ;; (not (string-equal name "*Buffer List*"))
           ;(not (string-equal name "*buffer-selection*"))
           ;(not (string-equal name "*Shell Command Output*"))
           (not (string-equal name "*scratch*"))
           (/= (aref name 0) ? )
           (if (buffer-modified-p buffer)
               (if (yes-or-no-p
                    (format "Buffer %s has been edited. Kill? " name))
                   (kill-buffer buffer))
             (kill-buffer buffer))))
    (setq list (cdr list))))

(defun is-work-laptop ()
  (interactive)
  "Returns true if this is my work laptop, false if not"
  (string-equal system-name "PAIKENS-LT"))

(defun is-work-desktop ()
  (interactive)
  "Returns true if this is my work desktop, false if not"
  (string-equal system-name "PAIKENS-DT"))

(defun is-work-machine ()
  (interactive)
  "Returns true if this is a work computer, false if not"
  (or
   (is-work-laptop)
   (is-work-desktop)))

(defun generate-my-autoloads nil
  (interactive)
  "Generate autoloads for packages which don't provide them already"
  (interactive)
  (setq generated-autoload-file "~/.emacs.d/site-lisp/config/loaddefs.el")
  (update-directory-autoloads "~/.emacs.d/site-lisp/org-7.01h/lisp"))

;; Prompt before exiting Emacs
(defun ask-before-closing ()
 "Ask whether or not to close, and then close if y was pressed"
 (interactive)
 (if (y-or-n-p (format "Are you sure you want to exit Emacs? "))
	(if (< emacs-major-version 22)
	 (save-buffers-kill-terminal)
	 (save-buffers-kill-emacs))
	(message "Canceled exit")))
