(add-local-load-path "weblogger")
(require 'weblogger)
(global-set-key "\C-cws" 'weblogger-start-entry)

(defun DE-org-export-weblogger ()
  (interactive)
  (let ((tmpbuffer (get-buffer-create " *org html export*"))
        title text)
    ;; export posting to HTML, but without headers
    (org-export-as-html 1 nil nil tmpbuffer t)
    (set-buffer tmpbuffer)
    (goto-char (point-min))
    ;; get the title
    (when (re-search-forward "<div id=\"outline-container-1\" class=\"outline-2\">[^\0]*\
<h2 id=\"sec-1\">\\(.*?\\)</h2>[^\0]*\
<div class=\"outline-text-2\" id=\"text-1\">"
                     nil t)
      (setq title (match-string 1))
      (replace-match ""))
    ;; get the posting
    (setq text (buffer-substring-no-properties (point) (point-max)))
    (weblogger-start-entry)
    (insert title)
    (goto-char (point-max))
    (insert text)
    (kill-buffer tmpbuffer)))