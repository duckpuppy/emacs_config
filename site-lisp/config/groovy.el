(add-local-load-path "groovy-mode")

(autoload 'groovy-mode "groovy-mode" "Major mode for editing Groovy code." t)
(add-to-list 'auto-mode-alist '("\.groovy$" . groovy-mode))
(add-to-list 'interpreter-mode-alist '("groovy" . groovy-mode))

(add-hook 'groovy-mode-hook
		  '(lambda ()
			 (require 'groovy-electric)
			 (groovy-electric-mode)))
