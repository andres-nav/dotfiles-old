;; init-vcs.el --- Initialize version control system configurations

;;; Commentary:

;;; Code:

;; Git
;; TODO: add flyspell <https://github.com/condy0919/.emacs.d/blob/336f30dccd03f3e7b6c07d22c71d61aa26d61351/lisp/init-git.el>
(use-package magit
	:if (executable-find "git")
  :diminish
  :hook
  (git-commit-mode . evil-insert-state)
  (after-save . magit-after-save-refresh-status)
  :custom
  (magit-diff-refine-hunk t)
  (magit-diff-paint-whitespace nil)
  (magit-ediff-dwim-show-on-hunks t)
  )

(use-package forge
	:ensure nil
  :diminish
  :after magit)

;; NOTE: `diff-hl' depends on `vc'
(use-package vc
  :ensure nil
  :custom
  (vc-follow-symlinks t)
  (vc-allow-async-revert t)
  (vc-handled-backends '(Git)))

;; Highlight uncommitted changes using VC
;; TODO: fix and change bitmaps <https://github.com/angrybacon/dotemacs/blob/cd50742f286cbd2873dfb0f3c897cceaab18ed8d/lisp/use-git.el>
(use-package diff-hl
  :hook (
         (dired-mode         . diff-hl-dired-mode-unless-remote)
         (magit-pre-refresh  . diff-hl-magit-pre-refresh)
         (magit-post-refresh . diff-hl-magit-post-refresh))
  :config
  ;; When Emacs runs in terminal, show the indicators in margin instead.
  (unless (display-graphic-p)
    (diff-hl-margin-mode))
  (define-fringe-bitmap 'me/diff-hl-insert [240] nil nil '(center t))
  (define-fringe-bitmap 'me/diff-hl-change [240] nil nil '(center t))
  (define-fringe-bitmap 'me/diff-hl-delete (make-vector 6 240) nil nil 'top)
  :custom
  (diff-hl-fringe-bmp-function #'me/diff-hl-fringe-bitmap)
  (diff-hl-show-staged-changes nil)
  :preface
  (defun me/diff-hl-fringe-bitmap (type _position)
    "Return the name of the bitmap to use for a given change TYPE."
    (intern (format "me/diff-hl-%s" type)))
  )

;; Git configuration modes
(use-package git-modes
  :diminish)

;; TODO: add git-time-machine

;; TODO: check transient <https://github.com/angrybacon/dotemacs/blob/cd50742f286cbd2873dfb0f3c897cceaab18ed8d/lisp/use-git.el>

(provide 'init-vcs)

;;; init-vcs.el ends here
