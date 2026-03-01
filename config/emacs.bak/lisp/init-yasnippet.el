;; init-yasnippet.el --- Initialize format-all configurations

;;; Commentary:

;;; Code:

;; NOTE: how to add snippets <https://github.com/MatthewZMD/.emacs.d/tree/b9c18962368aa6d38d6804b7256a450fccf1fba1/snippets>
;; TODO: configure yasnippet
;; (use-package yasnippet
;;   :diminish
;;   :init
;;   (use-package yasnippet-snippets :after yasnippet)
;;   :hook ((prog-mode LaTeX-mode org-mode markdown-mode) . yas-minor-mode)
;;   :bind
;;   (:map yas-minor-mode-map ("C-c C-n" . yas-expand-from-trigger-key))
;;   (:map yas-keymap
;;         (("TAB" . smarter-yas-expand-next-field)
;;          ([(tab)] . smarter-yas-expand-next-field)))
;;   :config
;;   (yas-reload-all)
;;   (defun smarter-yas-expand-next-field ()
;;     "Try to `yas-expand' then `yas-next-field' at current cursor position."
;;     (interactive)
;;     (let ((old-point (point))
;;           (old-tick (buffer-chars-modified-tick)))
;;       (yas-expand)
;;       (when (and (eq old-point (point))
;;                  (eq old-tick (buffer-chars-modified-tick)))
;;         (ignore-errors (yas-next-field))))))

(provide 'init-yasnippet)

;;; init-yasnippet.el ends here
