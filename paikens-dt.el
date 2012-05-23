;; Add in your own as you wish:
(defvar my-paikens-dt-packages '(p4))

(dolist (p my-paikens-dt-packages)
  (when (not (package-installed-p p))
    (package-install p)))

;; Fix flyspell
(setq ispell-program-name "C:/Program Files (x86)/Aspell/bin/aspell.exe")
