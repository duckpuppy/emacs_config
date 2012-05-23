;; Add in your own as you wish:
(defvar my-paikens-dt-packages '(p4))

(dolist (p my-paikens-dt-packages)
  (when (not (package-installed-p p))
    (package-install p)))
