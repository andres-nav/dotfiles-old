;; init-format-all.el --- Initialize format-all configurations

;;; Commentary:

;;; Code:

(use-package format-all
	:ensure nil
  :diminish
  :hook (prog-mode . format-all-mode)
  :custom
  (format-all-show-errors 'never)
  )

(provide 'init-format-all)

;;; init-format-all.el ends here
