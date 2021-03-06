(defvar *emacs-load-start* (current-time))

;; Store custom configuration in a shared folder
(setq custom-file (concat emacs-local-site-lisp "custom.el"))
(load custom-file)
(load-library "config/my-functions.el")

(load-library "config/basic.el")
(load-library "config/flyspell.el")
(load-library "config/pager.el")
(load-library "config/color-theme.el")

(if (eq system-type 'windows-nt)
	(load-library "config/cygwin.el"))
(load-library "config/org-mode.el")
(load-library "config/bbdb.el")
(load-library "config/gnus.el")
(load-library "config/weblogger.el")
(load-library "config/yasnippet.el")
;(load-library "config/autocomplete.el")
(load-library "config/development.el")
(load-library "config/flymake.el")
(load-library "config/maven.el")
(load-library "config/c-c++.el")
(load-library "config/java.el")
(load-library "config/ruby.el")
(load-library "config/groovy.el")
(load-library "config/xml-html.el")
;(load-library "config/muse.el")
;(load-library "config/ahk.el")
(load-library "config/markdown.el")
(load-library "config/hyde.el")

(server-start)
(message "My .emacs loaded in %ds" (destructuring-bind (hi lo ms) (current-time)
									 (- (+ hi lo) (+ (first *emacs-load-start*) (second *emacs-load-start*)))))
