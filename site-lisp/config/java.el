(add-local-load-path "elib-1.0")
(add-local-load-path "jde-2.3.5.1/lisp")
(require 'jde)
(add-to-list 'auto-mode-alist '("\\.java$" . jde-mode))

(defun my-jde-mode-hook ()
  (c-add-style
   "my-java"
   '("java"
     (c-basic-offset . 4)
     (c-hanging-braces-alist . (
				(substatement-open after)
				))
     ))
  (c-set-style "my-java")
;  (setq c-auto-newline t)
  (setq c-comment-continuation-stars "* ")
  (define-key c-mode-base-map "\C-m" 'newline-and-indent)
  )

(add-hook 'jde-mode-hook 'my-jde-mode-hook)
