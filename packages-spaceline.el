;; Time-stamp: <2018-12-03 14:34:42 (slane)>
;; Split out package loading into a separate file.
;; ESS
(use-package spaceline-config :ensure spaceline
  :config
  (spaceline-helm-mode 1)

  (spaceline-define-segment my/buffer-status
    "Buffer status (read-only, modified), with color"
    (cond (buffer-read-only (propertize "RO" 'face 'my/spaceline-read-only))
          ((buffer-modified-p) (propertize "**" 'face 'my/spaceline-modified))
          (t "  ")))

  (spaceline-define-segment amitp/project-id
    "Name of project, or folder"
    (propertize
     (amitp/shorten-directory
      (cond (buffer-file-name (amitp/project-root-for-file buffer-file-name))
            (t (amitp/project-root-for-directory default-directory)))
      (- (window-width) (length (amitp/spaceline-buffer-id)) 60))
     'face 'amitp/spaceline-filename))

  (spaceline-define-segment amitp/buffer-id
    "Name of filename relative to project, or buffer id"
    (propertize
     (amitp/spaceline-buffer-id)
     'face 'amitp/spaceline-filename))

  (spaceline-define-segment my/unicode-character
    "Description of unicode character we're currently on"
    (let ((ch (following-char)))
      (when (and ch (>= ch 127))
        (get-char-code-property (following-char) 'name))))

  (spaceline-define-segment my/week-number
    "Year and week number, which I use for marking my projects"
    (format-time-string "W%y%V"))

  ;; When there are segments that may or may not appear, they will
  ;; affect the alternating background colors. I try to put the
  ;; indicators that appear/disappear the most towards the center.
  (spaceline-install
   'main
   '((my/buffer-status :tight-left t)
     (amitp/project-id :tight-right t)
     (amitp/buffer-id :tight-left t :face highlight-face)
     (process :when active))
   '((selection-info :face 'region :when mark-active)
     (my/unicode-character :face 'my/spaceline-unicode-character :when active)
     ((flycheck-error flycheck-warning flycheck-info) :when active)
     (which-function)
     (version-control :when active)
     (("L" line column) :separator ":" :when active)
     (my/week-number :when active)
     (global :face highlight-face)
     (major-mode))))

(defun amitp/spaceline-buffer-id ()
  (cond (buffer-file-name
         (s-chop-prefix (amitp/project-root-for-file buffer-file-name) buffer-file-name))
        (t (s-trim (powerline-buffer-id 'mode-line-buffer-id)))))