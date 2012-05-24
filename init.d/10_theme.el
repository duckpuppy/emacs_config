;; Taken from http://stackoverflow.com/a/94277/645028
(defun set-frame-size-according-to-resolution ()
  (interactive)
  (if window-system
      (progn
        ;; use 120 char wide window for largeish displays
        ;; and smaller 80 column windows for smaller displays
        ;; pick whatever numbers make sense for you
        (if (> (x-display-pixel-width) 1280)
            (add-to-list 'default-frame-alist (cons 'width 120))
          (add-to-list 'default-frame-alist (cons 'width 80)))
        ;; for the height, subtract a couple hundred pixels
        ;; from the screen height (for panels, menubars and
        ;; whatnot), then divide by the height of a char to
        ;; get the height we want
        (add-to-list 'default-frame-alist
                     (cons 'height (/ (- (x-display-pixel-height) 200)
                                      (frame-char-height)))))))

(add-hook 'after-init-hook
          (lambda ()
            (load-theme 'twilight)
            ;; Change the font to something nicer
            (if (string= (symbol-name system-type) "windows-nt")
                (set-default-font "-outline-Consolas-normal-normal-normal-mono-18-*-*-*-c-*-iso8859-1")
              (modify-frame-parameters nil '((wait-for-wm . nil))))

            (if (string= (symbol-name system-type) "darwin")
                (set-default-font "-outline-Inconsolata-normal-normal-normal-mono-18-*-*-*-c-*-iso8859-1")
              (modify-frame-parameters nil '((wait-for-wm . nil))))
            (set-frame-size-according-to-resolution)
            ))
