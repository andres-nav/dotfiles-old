;; init-check --- Initialize check configurations

;;; Commentary:

;;; Code:

(use-package flycheck
  :diminish
  :hook (prog-mode . flycheck-mode)
  :custom
  (flycheck-temp-prefix ".flycheck")
  (flycheck-check-syntax-automatically '(save idle-change))
  (flycheck-emacs-lisp-load-path 'inherit)
  (flycheck-indication-mode (if (display-graphic-p) 'right-fringe 'right-margin))
  (flycheck-highlighting-mode 'symbols)
  :init
  (progn
    (define-fringe-bitmap 'my-flycheck-fringe-indicator
      (vector #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00011100
              #b00111110
              #b00111110
              #b00111110
              #b00011100
              #b00000000
              #b00000000
              #b00000000
              #b00000000
              #b00000000))

    (flycheck-define-error-level 'error
      :severity 2
      :overlay-category 'flycheck-error-overlay
      :fringe-bitmap 'my-flycheck-fringe-indicator
      :fringe-face 'flycheck-fringe-error)

    (flycheck-define-error-level 'warning
      :severity 1
      :overlay-category 'flycheck-warning-overlay
      :fringe-bitmap 'my-flycheck-fringe-indicator
      :fringe-face 'flycheck-fringe-warning)

    (flycheck-define-error-level 'info
      :severity 0
      :overlay-category 'flycheck-info-overlay
      :fringe-bitmap 'my-flycheck-fringe-indicator
      :fringe-face 'flycheck-fringe-info))
  )

(use-package flycheck-grammarly
	:ensure nil
  :after flycheck
  :hook
  (flycheck-mode . flycheck-grammarly-setup))

(use-package jinx
  :ensure nil
  :diminish
  :hook (after-init . global-jinx-mode)
  :bind (("C-," . jinx-correct)
         ("C-M-," . jinx-languages)))

(provide 'init-check)

;;; init-flycheck.el ends here
