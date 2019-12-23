(use-package company
  :ensure t
  :config
  ;; (setq ess-use-company 'script-only)
  (setq company-selection-wrap-around t
	company-tooltip-align-annotations t
	company-idle-delay 0.36
	company-minimum-prefix-length 2
	company-tooltip-limit 10)
  ;; TABS for completion
  (define-key company-active-map [return] nil)
  (define-key company-active-map [tab] 'company-complete-common)
  (define-key company-active-map (kbd "TAB") 'company-complete-common)
  (define-key company-active-map (kbd "M-TAB") 'company-complete-selection)
  ;; Enable it globally
  (add-hook 'after-init-hook 'global-company-mode)
  )
