;; init-latex.el ---

;;; Commentary:

;;; Code:

;; TODO: configure tex
(use-package tex
  :ensure auctex
  :custom
  (TeX-auto-save t)
  (TeX-parse-self t)
  (TeX-master nil)
  (Tex-engine "luatex")
  (compilation-ask-about-save nil)
	(TeX-view-program-list '(("zathura" "zathura %o"))
												 TeX-view-program-selection '((output-pdf "zathura"))))
;; :hook
;; (LaTeX-mode . (lambda ()
;;                 (turn-on-reftex)
;;                 (setq reftex-plug-into-AUCTeX t)
;;                 (reftex-isearch-minor-mode)
;;                 (setq TeX-PDF-mode t)
;;                 (setq TeX-source-correlate-method 'synctex)
;;                 (setq TeX-source-correlate-start-server t)))

(provide 'init-latex)

;;; init-latex.el ends here
