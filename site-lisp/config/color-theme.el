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
