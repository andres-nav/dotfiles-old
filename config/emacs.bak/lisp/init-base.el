;; init-base.el --- Better default configurations

;;; Commentary:

;;; Code:

(use-package compat
	:ensure nil
	:demand t)

;; Personal information
(setq user-full-name "Andres Navarro"
      user-mail-address "contact@andresnav.com"
      )

(with-no-warnings
  ;; Optimization
  (setq command-line-x-option-alist nil
        ;; Increase how much is read from processes in a single chunk (default is 4kb)
        read-process-output-max #x10000  ; 64kb
        ffap-machine-p-known 'reject ;; Don't ping things that look like domain names.
        )
  )

;; Garbage Collector Magic Hack
(use-package gcmh
	:ensure nil
  :diminish
  :hook (emacs-startup . gcmh-mode)
  :custom
  (gcmh-idle-delay 'auto)
  (gcmh-auto-idle-delay-factor 10)
  (gcmh-high-cons-threshold #x6400000) ;; 100 MB
	(gcmh-verbose nil)
  )

;; Set UTF-8 as the default coding system
(when (fboundp 'set-charset-priority)
  (set-charset-priority 'unicode))
(prefer-coding-system 'utf-8)
(setq locale-coding-system 'utf-8)
(setq system-time-locale "C")
(set-selection-coding-system 'utf-8)

;; Environment (check if it is really necessary)
;; (use-package exec-path-from-shell
;;   :custom (exec-path-from-shell-arguments '("-l"))
;;   :init (exec-path-from-shell-initialize)))

;; Don't compact font caches during GC
;; (setq inhibit-compacting-font-caches t)

;; add a new line at the end of the file
(setq require-final-newline t
			mode-require-final-newline t
			)

(use-package saveplace
  :hook (after-init . save-place-mode))

(use-package recentf
  :hook (after-init . recentf-mode)
  :custom
  (recentf-max-saved-items 300)
  (recentf-exnoninteractivelude
   '("\\.?cache" ".cask" "url" "COMMIT_EDITMSG\\'" "bookmarks"
     "\\.\\(?:gz\\|gif\\|svg\\|png\\|jpe?g\\|bmp\\|xpm\\)$"
     "\\.?ido\\.last$" "\\.revive$" "/G?TAGS$" "/.elfeed/"
     "^/tmp/" "^/var/folders/.+$" "^/ssh:" "/persp-confs/"
     (lambda (file) (file-in-directory-p file package-user-dir))))
  :config
  (push (expand-file-name recentf-save-file) recentf-exclude)
  (add-to-list 'recentf-filename-handlers #'abbreviate-file-name))

(use-package savehist
  :hook (after-init . savehist-mode)
  :custom
	(enable-recursive-minibuffers t) ; Allow commands in minibuffers
  (history-length 1000)
  (savehist-additional-variables '(mark-ring
                                   global-mark-ring
                                   search-ring
                                   regexp-search-ring
                                   extended-command-history))
  (savehist-autosave-interval 300)
  )

;;; Current Line
(use-package hl-line
  :ensure nil
  :hook
	(after-init . global-hl-line-mode)
  :custom
  (hl-line-sticky-flag nil)
  )

;; Enable autosave
;; (use-package files
;;   :ensure nil
;;   :preface
;;   (defun save-all ()
;;     (interactive)
;;     (save-some-buffers t))
;;   :hook
;;   (after-init . auto-save-visited-mode)
;;   :config
;;   (setq auto-save-no-message t
;;         auto-save-default t
;;         save-abbrevs 'silently
;;         )

;;   (setq after-focus-change-function 'save-all)
;;   )




;; TODO: see <https://github.com/seagle0128/.emacs.d/blob/master/lisp/init-base.el#L142C3-L142C3>

;; Misc
;; Change to y-or-n
(fset 'yes-or-no-p 'y-or-n-p)
(setq use-short-answers t)
;; Inhibit switching out from `y-or-n-p' and `read-char-choice'
(setq y-or-n-p-use-read-key t
      read-char-choice-use-read-key t)

(global-unset-key (kbd "C-<SPC>"))

(setq default-input-method "spanish-prefix")

(setq visible-bell t
      enable-recursive-minibuffers t   ; Enable recursive minibuffers
      inhibit-compacting-font-caches t ; Don’t compact font caches during GC
      delete-by-moving-to-trash t      ; Deleting files go to OS's trash folder
      make-backup-files nil            ; Forbide to make backup files

      initial-major-mode 'org-mode     ; Set scratch buffer mode to org

      create-lockfiles nil             ; Lockfiles create more pain than benefit

      tab-width 2
      indent-tabs-mode nil             ; Only use spaces

      display-raw-bytes-as-hex t       ; Improve display
      redisplay-skip-fontification-on-input t

      uniquify-buffer-name-style 'post-forward-angle-brackets ; Show path if names are same
      adaptive-fill-regexp "[ t]+|[ t]*([0-9]+.|*+)[ t]*"
      adaptive-fill-first-line-regexp "^* *$"
      sentence-end "\\([。！？]\\|……\\|[.?!][]\"')}]*\\($\\|[ \t]\\)\\)[ \t\n]*"
      )

;; Smooth scroll & friends
(setq scroll-step 2
      scroll-margin 2
      hscroll-step 2
      hscroll-margin 2
      scroll-conservatively 101
      scroll-preserve-screen-position 'always)

;; The nano style for truncated long lines.
(setq auto-hscroll-mode 'current-line)

;; Disable auto vertical scroll for tall lines
(setq auto-window-vscroll nil)

;;; Put Emacs auto-save and backup files to /tmp/ or C:/Temp/
(defconst emacs-tmp-dir (expand-file-name (format "emacs%d" (user-uid)) temporary-file-directory))
(setq backup-by-copying t        ; Avoid symlinks
      delete-old-versions t
      kept-new-versions 6
      kept-old-versions 2
      version-control t
      auto-save-list-file-prefix emacs-tmp-dir
      auto-save-file-name-transforms `((".*" ,emacs-tmp-dir t))  ; Change autosave dir to tmp
      backup-directory-alist `((".*" . ,emacs-tmp-dir)))

;; (setq-default major-mode 'text-mode
;;               fill-column 80
;;               tab-width 4
;;               indent-tabs-mode nil)     ; Permanently indent with spaces, never with TABs


;; Show line/column number and more
(use-package simple
  :ensure nil
  :custom
  ;; No visual feedback on copy/delete.
  (copy-region-blink-delay 0)
  (delete-pair-blink-delay 0)
  ;; confusing if no fringes (GUI only).
  (visual-line-fringe-indicators '(nil right-curly-arrow))
  ;; eliminate duplicates
  (kill-do-not-save-duplicates t)
  ;; include '\n' when point starts at the beginning-of-line
  (kill-whole-line t)
  ;; show cwd when `shell-command' and `async-shell-command'
  (shell-command-prompt-show-cwd t)
  ;; show the name of character in `what-cursor-position'
  (what-cursor-show-names t)
  ;; List only applicable commands.
  ;;
  ;; ``` elisp
  ;; (defun foo ()
  ;;   (interactive nil org-mode)
  ;;   (message "foo"))
  ;; ```
  ;;
  ;; M-x foo should only be available in `org-mode` or modes derived from `org-mode`.
  (read-extended-command-predicate #'command-completion-default-include-p))

;; TODO: set up trash-directory

(provide 'init-base)

;;; init-base.el ends here
