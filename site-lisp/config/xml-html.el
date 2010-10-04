;; ===========================
;; HTML/CSS stuff
;; ===========================
(setq html-mode-hook 'turn-off-auto-fill)
(autoload 'css-mode "css-mode")
(setq auto-mode-alist
      (cons '("\\.css\\'" . css-mode) auto-mode-alist))

(setq nxml-path (concat emacs-local-site-lisp "nxml-mode/"))

(load "nxhtml/autostart.el")

;; take any buffer and turn it into an html file,
;; including syntax hightlighting
(require 'htmlize)

;; ============================
;; XML Mode stuff
;; ============================
;;(load "rng-auto.el")
(add-hook 'nxml-mode-hook (lambda () (local-set-key "\r" 'newline-and-indent)))

;; ============================
;; FTL Mode Stuff
;; ============================
(add-local-load-path "ftl-mode")
(load "ftl.el")
(autoload 'turn-on-ftl-mode "ftl" nil t)
(add-hook 'html-mode-hook 'turn-on-ftl-mode t t)
(add-hook 'xml-mode-hook 'turn-on-ftl-mode t t)
(add-hook 'text-mode-hook 'turn-on-ftl-mode t t)
(add-hook 'nxml-mode-hook 'turn-on-ftl-mode t t)

(autoload 'javascript-mode "javascript" nil t)

(add-to-list 'auto-mode-alist '("\\.php$" . php-mode))
(add-to-list 'auto-mode-alist '("\\.xhtml$" . nxhtml-mode))
(add-to-list 'auto-mode-alist '("\\.xml$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.xsl$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.rng$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.ftl$" . ftl-mode))
(add-to-list 'auto-mode-alist '("\\.js$" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.meta$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.tei$" . nxml-mode))
(add-to-list 'auto-mode-alist '("\\.html\\.erb$" . eruby-nxhtml-mumamo-mode))

(setq rng-schema-locating-files
	  (list
	   (concat emacs-local-site-lisp "schema/schemas.xml")
	   "schemas.xml"
	   (concat nxml-path "schema/schemas.xml")))

(setq
 nxhtml-global-minor-mode t
 mumamo-chunk-coloring 'submode-colored
 nxhtml-skip-welcome t
 indent-region-mode t
 rng-nxml-auto-validate-flag nil
 nxml-degraded t)

(custom-set-variables
 '(nxml-auto-insert-xml-declaration-flag t)
 '(nxml-child-indent 4)
 '(nxml-slash-auto-complete-flag t))

;; DTD mode
(autoload 'dtd-mode "tdtd" "Major mode for SGML and XML DTDs." t)
(autoload 'dtd-etags "tdtd" "Execute etags on FILESPEC and match on DTD-specific regular expressions." t)
(autoload 'dtd-grep "tdtd" "Grep for PATTERN in files matching FILESPEC." t)
(setq auto-mode-alist (append (list
    '("\\.dcl$" . dtd-mode)
    '("\\.dec$" . dtd-mode)
    '("\\.dtd$" . dtd-mode)
    '("\\.ele$" . dtd-mode)
    '("\\.ent$" . dtd-mode)
    '("\\.mod$" . etd-mode))
  auto-mode-alist))

;; css
(add-hook 'css-mode-hook
         (lambda()
           (local-set-key (kbd "<return>") 'newline-and-indent)
))


;; javascript
(add-to-list  'load-path "~/.emacs.d/plugins/javascript")
(add-to-list 'auto-mode-alist '("\\.js$" . javascript-mode))
(autoload 'javascript-mode "javascript" nil t)

(defvar javascript-identifier-regexp "[a-zA-Z0-9.$_]+")

(defun javascript-imenu-create-method-index-1 (class bound)
  (let (result)
    (while (re-search-forward (format "^ +\\(\%s\\): *function" javascript-identifier-regexp) bound t)
      (push (cons (format "%s.%s" class (match-string 1)) (match-beginning 1)) result))
    (nreverse result)))

(defun javascript-imenu-create-method-index()
  (cons "Methods"
        (let (result)
          (dolist (pattern (list (format "\\b\\(%s\\) *= *Class\.create" javascript-identifier-regexp)
                                 (format "\\b\\([A-Z]%s\\) *= *Object.extend(%s"
                                         javascript-identifier-regexp
                                         javascript-identifier-regexp)
                                 (format "^ *Object.extend(\\([A-Z]%s\\)" javascript-identifier-regexp)
                                 (format "\\b\\([A-Z]%s\\) *= *{" javascript-identifier-regexp)))
            (goto-char (point-min))
            (while (re-search-forward pattern (point-max) t)
              (save-excursion
                (condition-case nil
                    (let ((class (replace-regexp-in-string "\.prototype$" "" (match-string 1)))
                          (try 3))
                      (if (eq (char-after) ?\()
                          (down-list))
                      (if (eq (char-before) ?{)
                          (backward-up-list))
                      (forward-list)
                      (while (and (> try 0) (not (eq (char-before) ?})))
                        (forward-list)
                        (decf try))
                      (if (eq (char-before) ?})
                          (let ((bound (point)))
                            (backward-list)
                            (setq result (append result (javascript-imenu-create-method-index-1 class bound))))))
                  (error nil)))))
          (delete-duplicates result :test (lambda (a b) (= (cdr a) (cdr b)))))))

(defun javascript-imenu-create-function-index ()
  (cons "Functions"
         (let (result)
           (dolist (pattern '("\\b\\([[:alnum:].$]+\\) *= *function" "function \\([[:alnum:].]+\\)"))
             (goto-char (point-min))
             (while (re-search-forward pattern (point-max) t)
               (push (cons (match-string 1) (match-beginning 1)) result)))
           (nreverse result))))

(defun javascript-imenu-create-index ()
  (list
   (javascript-imenu-create-function-index)
   (javascript-imenu-create-method-index)))

(add-hook 'javascript-mode-hook
  (lambda ()
    (setq imenu-create-index-function 'javascript-imenu-create-index)
    (local-set-key (kbd "<return>") 'newline-and-indent)
  )
t)
