(add-local-load-path "cygwin")

;; ==========================
;; Shell customizations
;; ==========================
;; Add color to a shell running in emacs 'M-x shell'
(autoload 'ansi-color-for-comint-mode-on "ansi-color" nil t)
(add-hook 'shell-mode-hook 'ansi-color-for-comint-mode-on)


;; Set up Cygwin
(setenv "PATH" (concat "c:/cygwin/bin;" (getenv "PATH")))
(setq exec-path (cons "c:/cygwin/bin/" exec-path))
(require 'cygwin-mount)
(require 'windows-path)
(cygwin-mount-activate)
(add-hook 'comint-output-filter-functions
		  'shell-strip-ctrl-m nil t)
(add-hook 'comint-output-filter-functions
		  'comint-watch-for-password-prompt nil t)
(setq explicit-shell-file-name "bash")
;; For subprocesses invoked via the shell
;; (e.g., "shell -c command")
(setq shell-file-name explicit-shell-file-name)

;; Set up Cygwin telnet
(require 'telnet)

(defun telnet (host)
  "Open a network login connection to host named HOST (a string).
Communication with HOST is recorded in a buffer `*PROGRAM-HOST*'
where PROGRAM is the telnet program being used.  This program
is controlled by the contents of the global variable
`telnet-host-properties', falling back on the value of the
global variable `telnet-program'. Normally input is edited
in Emacs and sent a line at a time."
  (interactive "sOpen connection to host: ")
  (let* ((comint-delimiter-argument-list '(?\  ?\t))
		 (properties (cdr (assoc host telnet-host-properties)))
		 (telnet-program (if properties (car properties) telnet-program))
		 (name (concat telnet-program "-" (comint-arguments host 0 nil) ))
		 (buffer (get-buffer (concat "*" name "*")))
		 (telnet-options (if (cdr properties)
							 (cons "-l" (cdr properties))))
		 process)
    (if (and buffer (get-buffer-process buffer))
		(pop-to-buffer (concat "*" name "*"))
      (pop-to-buffer
       (apply 'make-comint name telnet-program nil telnet-options))
      (setq process (get-buffer-process (current-buffer)))
      ;;(set-process-filter process 'telnet-initial-filter)
      ;; Don't send the `open' cmd till telnet is ready for it.
      ;;(accept-process-output process)
      (erase-buffer)
      (send-string process (concat "open " host "\n"))
      (telnet-mode)
      (setq telnet-remote-echoes nil)
      (setq telnet-new-line "\n") ;; needed for cygwin 1.3.11
      (setq comint-input-sender 'telnet-simple-send)
      (setq telnet-count telnet-initial-count)
      (setq comint-process-echoes t)
      )))

;; Set up Cygwin ftp
(defun ftp (host)
  "03Mar01, sailor"
  "Run the ftp program using cygwin ftp."
  "Fixed the problem that the login prompt cannot be seen."
  (interactive "sFtp to Host : ")
  (let ((bufname)
		(bufobject))
    (setq bufname (concat "*ftp-" host "*"))
    (setq bufobject (get-buffer bufname))

    (cond
     ((and bufobject (get-buffer-process bufobject))
      (pop-to-buffer bufname)
      )
     (t
      (let ((login)
			(process)
			(ftp-program "ftp.exe"))
		(setq bufobject (get-buffer-create bufname))
		(pop-to-buffer bufobject)
		(comint-mode)
		(setq login (read-from-minibuffer (format "%s - Login : " host)))
		(comint-exec bufobject bufname ftp-program nil
					 (list "--prompt=ftp> " "-v" host))
		(message "Login in progress. Please wait ...")
		(send-invisible (format "%s" login))
		(setq process (get-buffer-process (current-buffer)))
		(accept-process-output process)
		)
      )
     )
    )
  )

;; Support clear and man commands
(setq comint-input-sender 'n-shell-simple-send)
(defun n-shell-simple-send (proc command)
  "17Jan02 - sailor. Various commands pre-processing before sending to shell."
  (cond
   ;; Checking for clear command and execute it.
   ((string-match "^[ \t]*clear[ \t]*$" command)
    (comint-send-string proc "\n")
    (erase-buffer)
    )
   ;; Checking for man command and execute it.
   ((string-match "^[ \t]*man[ \t]*" command)
    (comint-send-string proc "\n")
    (setq command (replace-regexp-in-string "^[ \t]*man[ \t]*" "" command))
    (setq command (replace-regexp-in-string "[ \t]+$" "" command))
    ;;(message (format "command %s command" command))
    (funcall 'man command)
    )
   ;; Send other commands to the default handler.
   (t (comint-simple-send proc command))
   )
  )

;; Set up gzip and gunzip
(setq archive-zip-use-pkzip nil)
(require 'dired-aux)

(defun dired-call-process (program discard &rest arguments)
  ;; 09Feb02, sailor overwrite this function because Gnu Emacs cannot
  ;; recognize gunzip is a symbolic link to gzip. Thus, if the program
  ;; is "gunzip", replace it with "gzip" and add an option "-d".

  ;; "Run PROGRAM with output to current buffer unless DISCARD is t.
  ;; Remaining arguments are strings passed as command arguments to PROGRAM."
  ;; Look for a handler for default-directory in case it is a remote file name.
  (let ((handler
		 (find-file-name-handler (directory-file-name default-directory)
								 'dired-call-process)))
    (if handler (apply handler 'dired-call-process
					   program discard arguments)
      (progn
		(if (string-equal program "gunzip")
			(progn
			  (setq program "gzip")
			  (add-to-list 'arguments "-d")
			  )
		  )
		(apply 'call-process program nil (not discard) nil arguments)
		)
      )))


(add-hook 'shell-mode-hook
		  '(lambda ()
			 (local-set-key [home] ; move to beginning of line, after prompt
							'comint-bol)
			 (local-set-key [up] ; cycle backward through command history
							'(lambda () (interactive)
							   (if (comint-after-pmark-p)
								   (comint-previous-input 1)
								 (previous-line 1))))
			 (local-set-key [down] ; cycle forward through command history
							'(lambda () (interactive)
							   (if (comint-after-pmark-p)
								   (comint-next-input 1)
								 (forward-line 1))))
			 ))

;; Set up aspell
(if (or (eq system-type 'cygwin)
		(eq system-type 'gnu/linux)
		(eq system-type 'linux))
	(setq-default ispell-program-name "/usr/bin/aspell")
  (setq-default ispell-program-name "c:/cygwin/bin/aspell.exe"))

;; Functions copied from windows-path.el to convert paths from Windows to cygwin
(defconst windows-path-style1-regexp "\\`\\(.*/\\)?\\([a-zA-Z]:\\)\\\\")
(defconst windows-path-style2-regexp "\\`\\(.*/\\)?\\([a-zA-Z]:\\)/")

;; We cannot assume that NAME matched windows-path-style1-regexp nor
;; windows-path-cygwin-style2-regexp because this function could be called with
;; either argument to 'expand-file-name', but only one argument to
;; 'expand-file-name' may have matched a regexp.  For example,
;; '(expand-file-name ".." "c:/")' will trigger '(windows-path-convert-file-name
;; "..")' and '(windows-path-convert-file-name "c:/")' to be called.
(defun windows-path-convert-file-name (name)
  "Convert file NAME, to cygwin style.
`x:/' to `/cygdrive/x/'.
NOTE: \"/cygdrive/\" is only an example for the cygdrive-prefix \(see
`windows-path-cygdrive-prefix')."
  (cond ((string-match windows-path-style1-regexp name)
         (setq filename
               (replace-match (concat windows-path-cygdrive-prefix
                                      (downcase (substring (match-string 2 name) 0 1)))
                              t nil name 2))
         (while (string-match "\\\\" filename)
           (setq filename
                 (replace-match "/" t nil filename)))
         filename)
        ((string-match windows-path-style2-regexp name)
         (replace-match (concat windows-path-cygdrive-prefix
                                (downcase (substring (match-string 2 name) 0 1)))
                        t nil name 2))

        (t name)))
