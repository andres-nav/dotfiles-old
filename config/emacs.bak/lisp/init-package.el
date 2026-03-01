;;; init-package.el --- Initialize package configurations

;;; Commentary:

;;; Code:

;; Install straight.el
(let ((bootstrap-file
       (expand-file-name "straight/repos/straight.el/bootstrap.el" user-emacs-directory))
      (bootstrap-version 6))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
				(url-retrieve-synchronously
				 "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
				 'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(setq package-archives
      '(("melpa"  . "https://melpa.org/packages/")
        ("gnu"    . "https://elpa.gnu.org/packages/")
				("gnu-devel"   . "https://elpa.gnu.org/devel/")
				("nongnu" . "https://elpa.nongnu.org/nongnu/")))

;; Initialize packages
(unless (bound-and-true-p package--initialized) ; To avoid warnings in 27
  (setq package-enable-at-startup nil)          ; To prevent initializing twice
  (package-initialize))

;; Setup `use-package'
;; (unless (package-installed-p 'use-package)
;;   (package-refresh-contents)
;;   (package-install 'use-package))

(straight-use-package 'use-package)

;; Should set before loading `use-package'
(eval-and-compile
  (setq use-package-always-ensure t
				use-package-always-defer t
				use-package-expand-minimally t
				))

(eval-when-compile
  (require 'use-package))

;; Required by `use-package'
(use-package diminish
	:ensure nil)

;; Update GPG keyring for GNU ELPA
(use-package gnu-elpa-keyring-update)

(provide 'init-package)

;;; init-package.el ends here
