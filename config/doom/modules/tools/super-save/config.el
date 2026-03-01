;;; tools/super-save/config.el -*- lexical-binding: t; -*-

(use-package! super-save
  :hook (after-init . super-save-mode)
  :custom
  (super-save-auto-save-when-idle t)
  (super-save-idle-duration 30)
  (super-save-silent t)
  (save-silently t)
  (super-save-all-buffers t)
  (auto-save-default nil) ;; Disable auto-save as we use super-save
  (super-save-remote-files t)
  (super-save-max-buffer-size (* 1024 1024)) ;; 1mb
  (super-save-exclude '(".gpg" "COMMIT_EDITMSG" "git-rebase-todo" ".pyc" ".elc"))
  :config
  ;; (add-to-list 'super-save-triggers 'switch-window)
  (add-to-list 'super-save-hook-triggers 'focus-out-hook)
  )
