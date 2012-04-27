;; Set the default news server
(setq tls-program '("C:/Progra~2/Git/bin/openssl.exe s_client -connect %h:%p -no_ssl2 -ign_eof"))
(setq gnus-select-method '(nnimap "gmail"
								  (nnimap-address "imap.gmail.com")
								  (nnimap-server-port 993)
								  (nnimap-stream ssl)))
