;; Time-stamp: <2018-12-03 14:34:42 (slane)>
;; Split out package loading into a separate file.
;; ESS
(use-package ess
  ;; installs if not already installed
  :ensure t
  :ensure julia-mode
  :init (require 'ess-site)
  :diminish eldoc-mode
  :defer 1
  ;; add jags mode (others taken care of)
  :mode ("\\.[Jj][Aa][Gg]\\'" . ess-jags-mode)
  ;; remap some keys
  :bind
  (:map ess-mode-map
        (";" . ess-insert-assign))
  (:map inferior-ess-mode-map
        (";" . ess-insert-assign))
  (:map ess-mode-map
	("M-p" . #'my/add-pipe))
  ;; Set ESS up the way you like it
  :config
  (setq-default inferior-R-args "--no-restore-history --no-restore --no-save")
  (add-hook 'ess-mode-hook (lambda () (auto-fill-mode 1)))
  (setq ess-ask-for-ess-directory nil)
  (setq inferior-R-program-name "C:\\Users\\e155986\\R\\R-3.6.1patched\\bin\\x64\\Rterm.exe") 
  (setq ess-local-process-name "R")
  ;; Default indentation style as RStudio
  (setq ess-default-style 'RStudio-)
  ;; But with indentation of 4
  (add-hook 'ess-mode-hook (lambda () (setq ess-indent-offset 4)))
  (setq ess-nuke-trailing-whitespace t)
  (setq ess-eval-visibly 'nowait)
  ;; Remove old _ mapping
  (setq ess-smart-S-assign-key nil)
  ;; Similarly for bugs/jags mode
  (define-key ess-jags-mode-map "_" nil)
  (define-key ess-jags-mode-map ";" #'ess-bugs-hot-arrow)
  
  )

;; Function to add the pipe operator (set in map above)
(defun my/add-pipe ()
  "Adds a pipe operator %>% with one space to the left and then starts a newline with proper indentation"
  (interactive)
  (just-one-space 1)
  (insert "%>%")
  (ess-newline-and-indent))
  
  
;; Disable conversion of underscores to arrows; map to M-- instead
(ess-toggle-underscore nil)
(setq ess-S-assign-key (kbd "M--"))
(add-hook 'ess-mode-hook (lambda () (ess-toggle-S-assign-key t)))



;; Bring up empty R script and R console for quick calculations
(defun R-scratch ()
  (interactive)
  (progn
    (delete-other-windows)
    (setq new-buf (get-buffer-create "scratch.R"))
    (switch-to-buffer new-buf)
    (R-mode)
    (setq w1 (selected-window))
    (setq w1name (buffer-name))
    (setq w2 (split-window w1 nil t))
    (if (not (member "*R*" (mapcar (function buffer-name) (buffer-list))))
        (R))
    (set-window-buffer w2 "*R*")
    (set-window-buffer w1 w1name)))

(global-set-key (kbd "C-x 9") 'R-scratch)

(defun ess-r-shiny-run-app (&optional arg)
  "Interface for `shiny::runApp()'.
With prefix ARG ask for extra args."
  (interactive)
  (inferior-ess-r-force)
  (ess-eval-linewise
   "shiny::runApp(\".\")\n" "Running app" arg
   '("" (read-string "Arguments: " "recompile = TRUE"))))
