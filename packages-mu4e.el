;; Time-stamp: <2018-07-04 16:46:31 (slane)>
;; Commands to load mu4e related stuff
;; When it comes time to add another account, this is a great resource:
;; https://notanumber.io/2016-10-03/better-email-with-mu4e/

(use-package mu4e
  ;; Must be installed first...
  :load-path "/usr/local/Cellar/mu/1.0/share/emacs/site-lisp/mu/mu4e"
  :config
  (use-package org-mu4e)
  (setq mu4e-sent-folder "/unimelb/Sent Items"
	mu4e-drafts-folder "/unimelb/Drafts"
	mu4e-trash-folder "/unimelb/Deleted Items/")
  ;; Better behaviour with moving on mbsync
  (setq mu4e-change-filenames-when-moving t
	;; HTML
	mu4e-view-prefer-html t
	;; Get email using mbsync every 60 minutes
	mu4e-get-mail-command "mbsync -aq"
	mu4e-update-interval 1800
	;; For wrapping nicer in other clients
	mu4e-compose-format-flowed t
	;; display attached images
	mu4e-view-show-images t
	;; shows email addresses rather than only names (may want to change later)
	mu4e-view-show-addresses t
	;; shortcuts access with 'j' ('jump')
	mu4e-maildir-shortcuts '(("/unimelb/Inbox" . ?i)
				 ("/unimelb/Sent Items" . ?s)
				 ("/unimelb/Drafts" . ?d))
	;; don't keep message buffers around
	message-kill-buffer-on-exit t
	;; don't confirm quit
	mu4e-confirm-quit nil
	;; default save directory for attachments
	mu4e-attachment-dir "~/Downloads"
	;; ;; Use imagemagick, if available.
	;; (when (fboundp 'imagemagick-register-types)
	;;   (imagemagick-register-types))
	;; Don't reply to self...
	;; Need to list all self emails
	mu4e-user-mail-address-list '("lane.s@unimelb.edu.au" "address2@domain2.com")
	mu4e-compose-dont-reply-to-self t
	;; Store link to message, not header, if in header mode
	org-mu4e-link-query-in-headers-mode nil

	;; Sendmail stuff...
	;; Use msmtp to send mail
	message-send-mail-function 'message-send-mail-with-sendmail
	sendmail-program "msmtp"
	message-sendmail-extra-arguments '("--read-envelope-from")
	message-sendmail-f-is-evil 't
	mail-specify-envelope-from 't
	mail-envelope-from 'header
	;; smtpmail-auth-credentials
	user-mail-address "lane.s@unimelb.edu.au"
	smtpmail-smtp-user "lane.s@unimelb.edu.au"
	;; Some user details
	user-full-name "Steve Lane"
	mu4e-compose-signature (concat
				"Steve Lane\n"
				"P // +61 3 8344 0071\n"
				"W // https://cebra.unimelb.edu.au/\n"
				"W // https://gtown-ds.netlify.com/\n"
				"T // https://twitter.com/stephenelane/\n")
	
	)
  ;; Auto fill on compose for line wrapping, and flyspell as well.
  (add-hook 'mu4e-compose-mode-hook
            (lambda ()
              (auto-fill-mode 1)
              (flyspell-mode)))

  ;; Provide an option to change the signature of an email.
  (defun my-mu4e-choose-signature ()
    "Insert one of a number of email signatures"
    (interactive)
    (let ((message-signature
           (mu4e-read-option "Signature:"
			     '(("formal" .
				(concat
				 "Dr Stephen Lane\n"
				 "Deputy Director & Research Fellow, CEBRA, School of Biosciences\n"
				 "P // +61 3 8344 0071\n"
				 "A // University of Melbourne, Victoria 3010, Australia\n"
				 "W // https://cebra.unimelb.edu.au/\n"
				 "W // https://gtown-ds.netlify.com/\n"
				 "T // https://twitter.com/stephenelane/\n"))
			       ("informal" .
				(concat
				 "Steve Lane\n"
				 "P // +61 3 8344 0071\n"
				 "W // https://cebra.unimelb.edu.au/\n"
				 "W // https://gtown-ds.netlify.com/\n"
				 "T // https://twitter.com/stephenelane/\n")
			        )))))
      (message-insert-signature)))
  ;; Set the local shortcut key to 'add' the signature at the mouse point.
  ;; That's a really important point: this just adds text...
  (add-hook 'mu4e-compose-mode-hook
            (lambda () (local-set-key (kbd "C-c C-w") #'my-mu4e-choose-signature)))
  )
