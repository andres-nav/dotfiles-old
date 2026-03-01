;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

(setq! user-full-name "Andrés Navarro Pedregal"
       user-mail-address "contact@andresnav.com")

(setq! auth-sources '("~/.authinfo.gpg")
       auth-source-cache-expiry nil
       password-cache-expiry nil ;; never expire passwords
       default-input-method "spanish-prefix"
       )

(setq! initial-major-mode 'org-mode
       initial-scratch-message nil)

(setq! delete-by-moving-to-trash t
       large-file-warning-threshold 50000000 ;; 50mb
       )

;;; latex
(setq! ;; TeX-auto-save t
 ;; TeX-view-program-list '(("zathura" "zathura --page=$(outpage) %o"))
 +latex-viewers '(pdf-tools zathura)
 ;; TeX-parse-self t
 compilation-ask-about-save nil ;; save all buffers on compilation
 ;; TeX-engine 'luatex
 tex-directory "/tmp/latexbuild" ;; hide ugly files
 ;; TeX-command-extra-options "-output-directory=/tmp/latexbuild"
 )

;;; dired
(setq! dired-free-space nil
       dired-dwim-target t
       dired-kill-when-opening-new-dired-buffer t ;; only one dired buffer
       dired-recursive-copies 'always
       dired-recursive-deletes 'always
       dired-listing-switches "-AFlGh1v --group-directories-first" ;;  show directories first
       dired-clean-confirm-killing-deleted-buffers nil ;; don't ask to kill buffers visiting deleted files
       dired-auto-revert-buffer #'dired-directory-changed-p ;; auto revert dired buffer when directory changes

       find-file-visit-truename nil ;; don't resolve symlinks when opening files
       )

(defun open-file-in-main-frame ()
  "Open file in main frame."
  (interactive)
  (let ((file (dired-get-file-for-visit)))
    (when (and file (file-regular-p file))
      (dired--find-possibly-alternative-file file)
      )))

(map!
 :after dired
 :map dired-mode-map
 :nv "<return>" #'open-file-in-main-frame
 :nv "l" #'open-file-in-main-frame
 )

;; openwith
(use-package! openwith
  :after (dired)
  :hook (dired-mode . openwith-mode)
  :custom
  (openwith-associations '(
                           ("\\.doc\\|\\.docx\\|\\.ppt\\|\\.pptx\\|\\.xls\\|\\.xlsx\\'" "libreoffice" (file))
                           ("\\.gan\\'" "nix run nixpkgs#ganttproject-bin -- " (file))
                           ))
  )

;;; :app everywhere
(after! emacs-everywhere
  ;; Easier to match with a bspwm rule:
  ;;   bspc rule -a 'Emacs:emacs-everywhere' state=floating sticky=on
  (setq! emacs-everywhere-frame-name-format "emacs-anywhere")

  ;; The modeline is not useful to me in the popup window. It looks much nicer
  ;; to hide it.
  (remove-hook 'emacs-everywhere-init-hooks #'hide-mode-line-mode)

  ;; Semi-center it over the target window, rather than at the cursor position
  ;; (which could be anywhere).
  (defadvice! center-emacs-everywhere-in-origin-window (frame window-info)
    :override #'emacs-everywhere-set-frame-position
    (cl-destructuring-bind (x y width height)
        (emacs-everywhere-window-geometry window-info)
      (set-frame-position frame
                          (+ x (/ width 2) (- (/ width 2)))
                          (+ y (/ height 2))))))

(use-package! treesit-auto
  :config
  (global-treesit-auto-mode))

(use-package! websocket
  :after org-roam)

(use-package! org-roam-ui
  :after org-roam
  :config
  (setq org-roam-ui-sync-theme t
        org-roam-ui-follow t
        org-roam-ui-open-on-start t))

(use-package! vlf
  :config
  (require 'vlf-setup)
  (custom-set-variables
   '(vlf-application 'dont-ask))
  )

(load! "lisp/+ui")
(load! "lisp/+edit")
(load! "lisp/+org")
(load! "lisp/+ai")
(load! "lisp/+keybindings")
