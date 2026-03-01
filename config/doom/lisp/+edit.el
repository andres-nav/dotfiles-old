;;; $DOOMDIR/lisp/+edit.el -*- lexical-binding: t; -*-

;;; basic
(setq! require-final-newline t
       )

;; evil
(after! evil
  (setq! evil-escape-key-sequence nil
         evil-split-window-below t
         evil-vsplit-window-right t
         evil-move-beyond-eol nil
         evil-kill-on-visual-paste nil
         evil-move-cursor-back nil
         evil-ex-substitute-global t
         evil-esc-delay 0
         evil-shift-width 4
         evil-search-module 'isearch ;; NOTE: testing this
         )

  ;; prompt to opne buffer after splitting window
  (defadvice! prompt-for-buffer (&rest _)
    :after '(evil-window-split evil-window-vsplit tab-new)
    (if (projectile-project-p)
        (projectile-find-file)
      (consult-buffer)))

  (global-set-key [remap evil-quit] 'kill-current-buffer)

  (map! :after evil
        :map evil-normal-state-map
        ":" 'evil-repeat-find-char
        ";" 'evil-ex)

  )

;; hippie expand
(setq! hippie-expand-try-functions-list
       '(try-expand-list
         try-expand-dabbrev-visible
         try-expand-dabbrev
         try-expand-all-abbrevs
         try-expand-dabbrev-all-buffers
         try-complete-file-name-partially
         try-complete-file-name
         try-expand-dabbrev-from-kill
         try-expand-whole-kill
         try-expand-line
         try-complete-lisp-symbol-partially
         try-complete-lisp-symbol))
(global-set-key [remap dabbrev-expand] #'hippie-expand)

;; corfu
(setq! corfu-auto-delay 2
       corfu-auto nil
       corfu-count 5
       )

;;; flycheck
(setq flycheck-check-syntax-automatically '(idle-buffer-switch))

;;; magit
(setq! magit-repository-directories '(("~/git" . 2))
       magit-save-repository-buffers 'dontask
       ;; Don't restore the wconf after quitting magit, it's jarring
       magit-inhibit-save-previous-winconf t
       git-commit-major-mode 'markdown-mode
       magit-commit-ask-to-stage t
       transient-values '((magit-rebase "--autosquash" "--autostash")
                          (magit-pull "--rebase" "--autostash")
                          (magit-merge "--ff-only")
                          (magit-revert "--autostash")))

(after! magit
  (defun +magit-fetch-from-upstream-default ()
    "Fetch from the upstream remote."
    (magit-git-fetch (magit-get-current-remote) (magit-fetch-arguments)))

  ;; Fetch from upstream when entering magit-status
  (add-hook 'magit-status-mode-hook #'+magit-fetch-from-upstream-default)
  )

;;; projectile
(setq! projectile-ignored-projects (list "~/" "~/MEGA/" "/tmp" (expand-file-name "straight/repos" doom-local-dir)))
