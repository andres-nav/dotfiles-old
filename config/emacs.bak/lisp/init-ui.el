;; init-ui.el --- Better lookings and appearances

;;; Commentary:

;;; Code:

;; Optimization
(setq idle-update-delay 1.0)

(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)

(setq fast-but-imprecise-scrolling t)
(setq redisplay-skip-fontification-on-input t)

;; Inhibit resizing frame
(setq frame-inhibit-implied-resize t
      frame-resize-pixelwise t)

;; Theme
(use-package doom-themes
	:ensure nil
  :custom
  (doom-themes-enable-bold t)    ; if nil, bold is universally disabled
  (doom-themes-enable-italic t) ; if nil, italics is universally disabled
  :init
  (load-theme 'doom-gruvbox-light t)

  ;; Enable flashing mode-line on errors
  (doom-themes-visual-bell-config)

  ;; Corrects (and improves) org-mode's native fontification.
  (doom-themes-org-config)

  ;; Widnow divider
  ;; (custom-theme-set-variables
  ;;  'doom-dracula
  ;;  '(window-divider-default-bottom-width 3)
  ;;  '(window-divider-default-right-width 3)
  ;;  )

  (custom-theme-set-faces
   'doom-gruvbox
   '(window-divider ((t (:foreground "yellow")))))

  )

(use-package doom-modeline
	:ensure nil
	:after doom-themes
  :hook (after-init . doom-modeline-mode)
  :custom
  (doom-modeline-minor-modes t)
  (doom-modeline-hud t)
  (doom-modeline-buffer-encoding nil)
  (doom-modeline-vcs-max-length 20)
	(doom-modeline-unicode-fallback t)
  )

;; TODO: add popper <https://github.com/karthink/popper> or popwin or shackle

;; Hide mode line for some modes
(use-package hide-mode-line
  :diminish
  :hook ((help-mode
					treemacs-mode
					eshell-mode shell-mode
					term-mode vterm-mode) . hide-mode-line-mode)
  )

;; Show line numbers
(use-package display-line-numbers
  :ensure nil
  :hook ((prog-mode yaml-mode conf-mode markdown-mode text-mode) . display-line-numbers-mode)
  :custom
  (display-line-numbers-width-start t)
  (display-line-numbers-width 1))

;; Suppress GUI features
(setq use-file-dialog nil
      use-dialog-box nil
      inhibit-x-resources t
      inhibit-startup-screen t
      inhibit-startup-message t
      inhibit-startup-buffer-menu t
      inhibit-startup-echo-area-message user-login-name
      inhibit-default-init t
      initial-scratch-message nil)

;; Pixelwise resize
(setq window-resize-pixelwise t
      frame-resize-pixelwise t)

(use-package ace-window
	:custom
	(aw-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l))
	(aw-dispatch-always nil)
	)

;; Linux specific
(setq x-gtk-use-system-tooltips nil
      x-gtk-use-native-input t
      x-underline-at-descent-line t)

;; Optimize for very long lines
(setq-default bidi-paragraph-direction 'left-to-right)
(setq bidi-inhibit-bpa t)

;; Display dividers between windows
(setq window-divider-default-places t
      window-divider-default-bottom-width 1
      window-divider-default-right-width 1)
(add-hook 'window-setup-hook #'window-divider-mode)

;; Font
(add-to-list 'default-frame-alist '(font . "CaskaydiaCove Nerd Font Mono 10"))

;; Highlight parenthesises
(use-package paren
  :ensure nil
  :hook (after-init . show-paren-mode)
  :custom
  (show-paren-when-point-inside-paren t)
  (show-paren-when-point-in-periphery t)
  (show-paren-context-when-offscreen t)
  )

;; Type text
(use-package text-mode
  :ensure nil
  :custom
  ;; better word wrapping for CJK characters
  (word-wrap-by-category t)
  ;; paragraphs
  (sentence-end-double-space nil)
	)


(provide 'init-ui)

;;; init-ui.el ends here
