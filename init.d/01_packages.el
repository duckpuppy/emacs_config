(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/") t)
(add-to-list 'package-archives
             '("elpa" . "http://tromey.com/elpa/"))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/"))
(package-initialize)

(when (not package-archive-contents)
  (package-refresh-contents))

;; Add in your own as you wish:
(defvar my-packages '(starter-kit
                      starter-kit-bindings
                      starter-kit-eshell
                      starter-kit-ruby
                      starter-kit-js
                      starter-kit-lisp
                      auto-complete
                      org
                      rinari
                      yasnippet
                      haml-mode
                      sass-mode
                      markdown-mode
                      markdown-mode+
                      coffee-mode
                      yaml-mode
                      gtags
                      ctags
		      rainbow-mode
		      oauth2
		      google-maps
                      twilight-theme
                      ))

(dolist (p my-packages)
  (when (not (package-installed-p p))
    (package-install p)))
