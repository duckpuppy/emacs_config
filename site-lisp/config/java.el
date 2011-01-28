(add-local-load-path "elib-1.0")
(add-local-load-path "jdee-2.4.0.1/lisp")

;(setq defer-loading-jde t)
;(if defer-loading-jde
;	(progn
;	  (autoload 'jde-mode "jde" "JDE mode." t)
;	  (add-to-list 'auto-mode-alist '("\\.java$" . jde-mode)))
;  (require 'jde))

;(eval-after-load "jde"
;  '(progn
;	 (defun my-jde-mode-hook ()
;	   (c-add-style
;		"my-java"
;		'("java"
;		  (c-basic-offset . 4)
;		  (c-hanging-braces-alist . (
;									 (substatement-open after)
;									 ))
;		  ))
;	   (c-set-style "my-java")
;										;  (setq c-auto-newline t)
;	   (setq c-comment-continuation-stars "* ")
;	   (define-key c-mode-base-map "\C-m" 'newline-and-indent)
;	   (define-key c-mode-base-map (kbd "RET") 'reindent-then-newline-and-indent)
;	   )

;	 (setq jde-jdk-registry '(
;							   ("1.5.0_22" . "c:/program files/java/1.5.0_22")
;							   ("1.6.0_13" . "c:/program files/java/1.6.0_13")
;							   ("default" . "$JAVA_HOME")
;							   )
;							  )
;	 (setq jde-jdk '("default"))
;	 (add-hook 'jde-mode-hook 'my-jde-mode-hook)))

(setq-mode-local java-mode
				 semanticdb-find-default-throttle
				 '(project unloaded system recursive))
