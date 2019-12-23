(require 'org)

;; keybindings
(global-set-key (kbd "C-c a") 'org-agenda)
(global-set-key (kbd "C-c c") 'org-capture)
(global-set-key (kbd "C-c l") 'org-store-link)

;; soft line wrapping
(add-hook 'org-mode-hook (lambda () (visual-line-mode 1)))
;; Disable whitespace mode in org mode
(add-hook 'org-mode-hook (lambda () (whitespace-mode -1)))
;; Flyspell on
(add-hook 'org-mode-hook (lambda () (flyspell-mode 1)))

(setq
 ;; Default directory for org files
 org-directory "~/org"
 ;; Directory for notes/tasks to be refiled
 org-default-notes-file (concat org-directory "/refile.org")
 ;; Allows to store agenda files in their appropriate files.
 ;; This is useful when per project task lists are used.
 ;; Only show level 1 headings for refiling (level 2 are the task headers)
 org-refile-targets (quote ((nil :maxlevel . 1)
   			    (org-agenda-files :maxlevel . 1)))
 ;; Org agenda files read from here
 org-agenda-files (list org-directory)
 )

(setq
 ;; Be sure to use the full path for refile setup
 org-refile-use-outline-path 'file
 ;; Set this to nil to use helm/ivy for completion
 org-outline-path-complete-in-steps nil
 ;; Allow refile to create parent tasks with confirmation
 org-refile-allow-creating-parent-nodes 'confirm
 )

(setq org-todo-keywords
      (quote ((sequence "TODO(t)" "|" "DONE(d)")
	      (sequence "PROJECT(p)" "|" "DONE(d)" "CANCELLED(c)")
	      (sequence "WAITING(w)" "|")
	      (sequence "|" "CANCELLED(c)")
	      (sequence "SOMEDAY(s)" "|" "CANCELLED(c)")
	      (sequence "|" "MEETING")
	      )
	     )
      )

(setq
 ;; Coloured faces for agenda/todo items
 org-todo-keyword-faces
 '(
   ("DONE" . (:foreground "#2B4450" :weight bold))
   ("TODO" . (:foreground "#ff3030" :weight bold))
   ("WAITING" . (:foreground "#fe2f92" :weight bold))
   ("CANCELLED" . (:foreground "#999999" :weight bold))
   ("SOMEDAY" . (:foreground "#ab82ff" :weight bold))
   ("MEETING" . (:foreground "#1874cd" :weight bold))
   )
 )

(setq
 ;; Define the custum capture templates
 org-capture-templates
 '(("t" "todo" entry (file org-default-notes-file)
    "* TODO %?\n%u\n%a\n" :clock-in t :clock-resume t)
   ("m" "Meeting/Interruption" entry (file org-default-notes-file)
    "* MEETING with %? :MEETING:\n%t" :clock-in t :clock-resume t)
   ;; ("d" "Diary" entry (file+datetree "~/org/diary.org")
   ;;  "* %?\n%U\n" :clock-in t :clock-resume t)
   ("i" "Idea" entry (file org-default-notes-file)
    "* %? :IDEA: \n%t\n" :clock-in t :clock-resume t)
   ;; ("n" "Next task" entry (file+headline org-default-notes-file "Tasks")
   ;;  "** NEXT %? \nDEADLINE: %t")
   ("e" "Respond email" entry (file org-default-notes-file)
    "* TODO Respond to %:from on %:subject :EMAIL: \nSCHEDULED: %t\n%U\n%a\n" :clock-in t :clock-resume t :immediate-finish t)
   ("s" "Someday" entry (file org-default-notes-file)
    "* SOMEDAY %? :SOMEDAY: \n%u\n" :clock-in t :clock-resume t :empty-lines 1)
   ("p" "Project entry" entry (file org-default-notes-file)
    "* PROJECT %? :PROJECT: \n%u\n" :clock-in t :clock-resume t :empty-lines 1)
   )
 ;; Keep a line between headers
 org-cycle-separator-lines 1
 )

;; Custom tags
(setq org-tag-alist '((:startgroup . nil)
  		      ("@work" . ?w)
  		      ("@train" . ?t)
  		      ("@home" . ?h)
  		      (:endgroup . nil)
  		      ("research" . ?r)
  		      ("coding" . ?c)
  		      ("writing" . ?p)
  		      ("emacs" . ?e)
		      ("miscellaneous" . ?m)
		      ("supervision" . ?s)
  		      )
      )

(setq
 ;; Triggers for state changes
 org-todo-state-tags-triggers
 (quote (
	 ;; Move to cancelled adds the cancelled tag
	 ("CANCELLED" ("CANCELLED" . t))
	 ;; Move to waiting adds the waiting tag
	 ("WAITING" ("WAITING" . t))
	 ;; Move to a done state removes waiting/cancelled
	 (done ("WAITING") ("CANCELLED"))
	 ("DONE" ("WAITING") ("CANCELLED"))
	 ;; Move to todo, removes waiting/cancelled
	 ("TODO" ("WAITING") ("CANCELLED"))
	 )
	)
 )

(setq
 ;; Ensure child dependencies complete before parents can be marked complete
 org-enforce-todo-dependencies t
 )

(setq
 ;; Where I'm going to archive stuff
 org-archive-location "archive/%s_archive::"
 )

;; How archive files will appear
(defvar org-archive-file-header-format "#+FILETAGS: ARCHIVE\nArchived entries from file %s\n")

(setq
 ;; Set column view headings
 org-columns-default-format "%50ITEM(Task) %10Effort(Effort){:} %10CLOCKSUM"
 ;; Set default effort values
 org-global-properties (quote (("Effort_ALL" . "0:15 0:30 0:45 1:00 2:00 3:00 4:00 5:00 6:00 0:00")))
 ;; When there's 0 time spent, remove the entry
 org-clock-out-remove-zero-time-clocks t
 )

(setq org-agenda-category-icon-alist
      `(("TODO" (list (all-the-icons-faicon "tasks")) nil nil :ascent center)))
;; (setq
 ;; Add fancy icons to the agenda...
 ;; org-agenda-category-icon-alist
 ;; '(
 ;;   (("TODO" (#("" 0 1 (font-lock-ignore t rear-nonsticky t display (raise -0.24) face (:family "FontAwesome" :height 1.2)))) nil nil :ascent center))
 ;;   ;; (`(("MEETING" ,(list (all-the-icons-faicon "tasks")) nil nil :ascent center)))
 ;;   )
 ;; )

;; Custom agenda views
(setq org-agenda-custom-commands
      '(				; start list
	(" " "Agenda" ((agenda "" ((org-agenda-overriding-header "Today's Schedule:")
				   (org-agenda-span 'day)
				   (org-agenda-ndays 1)
				   (org-agenda-start-on-weekday nil)
				   (org-agenda-start-day "+0d")
				   ;; Remove refiling tasks (https://www.reddit.com/r/orgmode/comments/69acg5/orgagendaskipentryif_but_for_categories/)
				   (org-agenda-skip-function '(cond ((equal (file-name-nondirectory (buffer-file-name)) "refile.org")
								     (outline-next-heading) (1- (point)))
								    (t (org-agenda-skip-entry-if 'todo 'done))
								    ))
				   ;; (org-agenda-skip-entry-if 'todo 'done)
				   (org-agenda-todo-ignore-deadlines nil)))
		       ;; Project tickle list.
		       (todo "PROJECT" ((org-agenda-overriding-header "Project list:")
				       (org-tags-match-list-sublevels nil)))
		       ;; Refiling category set file wide in file.
		       (tags "REFILING" ((org-agenda-overriding-header "Tasks to Refile:")
				       (org-tags-match-list-sublevels nil)))
		       ;; Tasks upcoming (should be similar to above?)
		       (agenda "" ((org-agenda-overriding-header "Upcoming:")
				   (org-agenda-span 7)
				   (org-agenda-start-day "+1d")
				   (org-agenda-start-on-weekday nil)
				   (org-agenda-skip-function '(cond ((equal (file-name-nondirectory (buffer-file-name)) "refile.org")
								     (outline-next-heading) (1- (point)))
								    (t (org-agenda-skip-entry-if 'todo 'done))
								    ))
				   ;; I should set this next one to true, so that deadlines are ignored...?
				   (org-agenda-todo-ignore-deadlines nil)))
		       ;; Tasks that are unscheduled
		       (todo "TODO" ((org-agenda-overriding-header "Unscheduled Tasks:")
				     (org-tags-match-list-sublevels nil)
				     ;; (org-agenda-skip-entry-if 'scheduled 'deadline)
				     (org-agenda-todo-ignore-scheduled 'all)
				     ))
		       ;; Tasks that are waiting or someday
		       (todo "WAITING|SOMEDAY" ((org-agenda-overriding-header "Waiting/Someday Tasks:")
				       (org-tags-match-list-sublevels nil)))
		       )
	 )
	)				; end list

      ;; If an item has a (near) deadline, and is scheduled, only show the deadline.
      org-agenda-skip-scheduled-if-deadline-is-shown t
      )

(add-to-list 'org-modules 'org-habit t)
