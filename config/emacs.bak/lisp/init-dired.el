;; init-dired.el --- Initialize dired configurations

;;; Commentary:

;;; Code:

(use-package dired
  :ensure nil
  :after evil
  :custom
  (dired-dwim-target t)
  (dired-kill-when-opening-new-dired-buffer t)
  ;; Always delete and copy recursively
  (dired-recursive-deletes 'always)
  (dired-recursive-copies 'always)
  ;; Show directory first
  (dired-listing-switches "-AFlhv --group-directories-first")
  ;; Dont prompt about killing buffer visiting delete file
  (dired-clean-confirm-killing-deleted-buffers nil)
  (dired-auto-revert-buffer #'dired-directory-changed-p)
  (dired-hide-details-hide-symlink-targets nil)
  ;; Hide free space
  (dired-free-space nil)

  :config
  ;; Don't complain about this command being disabled when we use it
  (put 'dired-find-alternate-file 'disabled nil)
  ;; evil keybindings for dired
  (evil-define-key 'normal dired-mode-map
    "h" 'dired-jump)
  (evil-define-key 'normal dired-mode-map
    "l" 'dired-find-alternate-file)

  ;; `find-dired' alternative using `fd'
  (when (executable-find "fd")
    (use-package fd-dired))

  ;; Hide hidden files
  (use-package dired-hide-dotfiles
    :hook
    (dired-mode . dired-hide-dotfiles-mode)
    :config

    (evil-define-key 'normal dired-mode-map
      "." 'dired-hide-dotfiles-mode)
    )

  ;; Make dired colorful
  (use-package diredfl
    :ensure t
    :hook (dired-mode . diredfl-mode))

  ;; Extra Dired functionality
  (use-package dired-aux
    :ensure nil
    :custom
    (dired-vc-rename-file t)
    (dired-do-revert-buffer t)
    (dired-isearch-filenames 'dwim)
    (dired-create-destination-dirs 'ask)
    )

  ;; FIXME: not working opening files externaly
  (use-package dired-x
    :ensure nil
    :custom
    (dired-guess-shell-alist-user `((,(rx "."
                                          (or
                                           ;; Videos
                                           "mp4" "avi" "mkv" "flv" "ogv" "ogg" "mov"
                                           ;; Music
                                           "wav" "mp3" "flac"
                                           ;; Images
                                           "jpg" "jpeg" "png" "gif" "xpm" "svg" "bmp"
                                           ;; Docs
                                           "pdf" "md" "djvu" "ps" "eps" "doc" "docx" "xls" "xlsx" "ppt" "pptx")
                                          string-end)
                                     ,(pcase system-type
					('gnu/linux "xdg-open")
					('darwin "open")
					('windows-nt "start")
					(_ ""))))))
  )


(provide 'init-dired)

;;; init-dired.el ends here
