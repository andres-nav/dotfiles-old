;;; init.el --- core initiazliation file
;;; Commentary:

;;; Code:

;; A big contributor to startup times is garbage collection. We up the gc
;; threshold to temporarily prevent it from running, and then reset it by the
;; `gcmh' package.
(setq gc-cons-threshold most-positive-fixnum)

;; Prevent flashing of unstyled modeline at startup
(setq-default mode-line-format nil)

;; Don't pass case-insensitive to `auto-mode-alist'
(setq auto-mode-case-fold nil)

(unless (or (daemonp) noninteractive init-file-debug)
  ;; Suppress file handlers operations at startup
  ;; `file-name-handler-alist' is consulted on each call to `require' and `load'
  (let ((old-value file-name-handler-alist))
    (setq file-name-handler-alist nil)
    (set-default-toplevel-value 'file-name-handler-alist file-name-handler-alist)
    (add-hook 'emacs-startup-hook
              (lambda ()
                "Recover file name handlers."
                (setq file-name-handler-alist
                      (delete-dups (append file-name-handler-alist old-value))))
              101)))

;; Load path
;; Optimize: Force "lisp"" and "site-lisp" at the head to reduce the startup time.
(defun update-load-path (&rest _)
  "Update `load-path'."
  (dolist (dir '("site-lisp" "lisp"))
    (push (expand-file-name dir user-emacs-directory) load-path)))

(defun add-subdirs-to-load-path (&rest _)
  "Add subdirectories to `load-path'.
	Don't put large files in `site-lisp' directory, e.g. EAF.
	Otherwise the startup will be very slow."
  (let ((default-directory (expand-file-name "site-lisp" user-emacs-directory)))
    (normal-top-level-add-subdirs-to-load-path)))

(advice-add #'package-initialize :after #'update-load-path)
(advice-add #'package-initialize :after #'add-subdirs-to-load-path)

;; Custom var file
(setq custom-file (locate-user-emacs-file "custom-vars.el"))
(load custom-file 'noerror 'nomessage)

(update-load-path)

;; Packages
(require 'init-package)

;; Preferences
(require 'init-base)

(require 'init-ui)
(require 'init-edit)
(require 'init-keyboard)
(require 'init-completion)
;; TODO: add corfu
;; TODO: add yasnippets
(require 'init-projectile)
(require 'init-vcs)
(require 'init-dired)
(require 'init-term)
(require 'init-yasnippet)

;; Progamming
(require 'init-prog)
(require 'init-check)
(require 'init-treesit)
(require 'init-format-all)
(require 'init-elisp)
(require 'init-org)
(require 'init-latex)
(require 'init-nix)

;; init.el ends here
