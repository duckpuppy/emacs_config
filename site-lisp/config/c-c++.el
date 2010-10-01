;; ==========================
;; C/C++ indentation
;; ==========================
(defun my-c-mode-common-hook ()
  (turn-on-font-lock)
  (c-set-offset 'substatement-open 0)
  (c-set-offset 'case-label '+)
;;  (c-set-offset 'arglist-cont-nonempty c-lineup-arglist))
)

(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)

(add-to-list 'auto-mode-alist '("\\.h$" . c++-mode))
