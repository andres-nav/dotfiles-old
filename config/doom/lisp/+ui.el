;;; $DOOMDIR/lisp/+ui.el -*- lexical-binding: t; -*-

;; `doom-font' -- the primary font to use
;; - `doom-variable-pitch-font' -- a non-monospace font (where applicable)
;; - `doom-big-font' -- used for `doom-big-font-mode'; use this for presentations or streaming.
;; - `doom-symbol-font' -- for symbols
;; - `doom-serif-font' -- for the `fixed-pitch-serif' face

(setq doom-font (font-spec :family "CaskaydiaCove Nerd Font" :size 14)
      doom-big-font (font-spec :family "CaskaydiaCove Nerd Font" :size 26)
      doom-variable-pitch-font (font-spec :family "CaskaydiaCove Nerd Font" :size 16)
      doom-symbol-font (font-spec :family "CaskaydiaCove Nerd Font")
      doom-serif-font (font-spec :family "CaskaydiaCove Nerd Font" :size 12 :weight 'light))

(setq display-line-numbers-type nil) ;; disable line numbers

;; Theme
(setq doom-theme 'doom-gruvbox-light
      doom-gruvbox-light-brighter-modeline t
      +modeline-height 20)

(setq-default x-stretch-cursor t
              tab-width 4
              enable-local-variables t
              window-combination-resize t
              )

(setq which-key-idle-delay 1
      truncate-string-ellipsis "…"
      )

;; Modeline
;; TODO: Check if it really works
;; (defun doom-modeline-conditional-buffer-encoding ()
;;   "If the encoding is not LF UTF-8, so only show the modeline when is not the case"
;;   (setq-local doom-modeline-buffer-encoding
;;               (unless (and (memq (plist-get (coding-system-plist buffer-file-coding-system) :category)
;;                                  '(coding-category-undecided coding-category-utf-8))
;;                            (not (memq (coding-system-eol-type buffer-file-coding-system) '(1 2))))
;;                 t)))

;; (add-hook 'after-change-major-mode-hook #'doom-modeline-conditional-buffer-encoding)


(custom-set-faces
 '(tab-bar-tab-active ((t (:background "goldenrod" :foreground "black"))))
 '(tab-bar-tab-inactive ((t (:background "dim gray" :foreground "black"))))
 '(tab-bar-tab-unselected ((t (:background "dim gray" :foreground "black"))))
 )

(after! evil
  ;; TODO: create tab-map
  (map!
   :map evil-window-map
   "w" 'aw-flip-window
   "SPC" 'ace-window
   "t" 'tab-new
   "r" 'tab-rename
   "n" 'evil-tab-next
   "p" 'tab-previous
   )
  )
