(setq cust-emacs-init-file load-file-name)
(setq cust-emacs-config-dir
      (file-name-directory cust-emacs-init-file))
(setq cust-init-dir
      (expand-file-name "init.d" cust-emacs-config-dir))

(if (file-exists-p cust-init-dir)
    (dolist (file (directory-files cust-init-dir t "\.el$"))
      (load file)))

;; set up 'custom' system
(setq custom-file (expand-file-name "emacs-customizations.el" cust-emacs-config-dir))
(if (file-exists-p custom-file) 
   (load custom-file))

(server-start)
