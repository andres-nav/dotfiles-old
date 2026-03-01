;; init-edit.el --- Initialize editing configurations

;;; Commentary:

;;; Code:

;; Automatically reload files was modified by external program
(use-package autorevert
  :ensure nil
  :diminish
  :hook (after-init . global-auto-revert-mode))

;; TODO: configure aggresive indent
;; ;; Minor mode to aggressively keep your code always indented
;; (use-package aggressive-indent
;;   :diminish
;;   :hook ((after-init . global-aggressive-indent-mode)
;;          ;; NOTE: Disable in large files due to the performance issues
;;          ;; https://github.com/Malabarba/aggressive-indent-mode/issues/73
;;          (find-file . (lambda ()
;;                         (when (too-long-file-p)
;;                           (aggressive-indent-mode -1)))))
;;   :config
;;   ;; Disable in some modes
;;   (dolist (mode '(gitconfig-mode asm-mode web-mode html-mode css-mode go-mode scala-mode prolog-inferior-mode))
;;     (push mode aggressive-indent-excluded-modes))

;;   ;; Disable in some commands
;;   (add-to-list 'aggressive-indent-protected-commands #'delete-trailing-whitespace t)

;;   Be slightly less aggressive in C/C++/C#/Java/Go/Swift
;;   (add-to-list 'aggressive-indent-dont-indent-if
;;                '(and (derived-mode-p 'c-mode 'c++-mode 'csharp-mode
;;                                      'java-mode 'go-mode 'swift-mode)
;;                      (null (string-match "\\([;{}]\\|\\b\\(if\\|for\\|while\\)\\b\\)"
;;                                          (thing-at-point 'line))))))

;; TODO: configure avy
;; Jump to things in Emacs tree-style
(use-package avy			;
  :after evil
  :hook (after-init . avy-setup-default)
  :custom
  (avy-all-windows nil)
  (avy-all-windows-alt t)
  (avy-background t)
  (avy-timeout-seconds 0.5)
  (avy-style 'pre)
  (avy-keys '(?a ?s ?d ?f ?g ?h ?j ?k ?l ?q ?w ?e ?r ?t ?u ?m ?i ?o ?p))
  )

;; Show number of matches in mode-line while searching
(use-package anzu
  :diminish
  :bind (([remap query-replace] . anzu-query-replace)
         ([remap query-replace-regexp] . anzu-query-replace-regexp)
         :map isearch-mode-map
         ([remap isearch-query-replace] . anzu-isearch-query-replace)
         ([remap isearch-query-replace-regexp] . anzu-isearch-query-replace-regexp))
  :hook (after-init . global-anzu-mode))

;; TODO: configure drag-stuff
;; ;; Drag stuff (lines, words, region, etc...) around
;; (use-package drag-stuff
;;   :diminish
;;   :autoload drag-stuff-define-keys
;;   :hook (after-init . drag-stuff-global-mode)
;;   :config
;;   (add-to-list 'drag-stuff-except-modes 'org-mode)
;;   (drag-stuff-define-keys))

;; A comprehensive visual interface to diff & patch
(use-package ediff
  :ensure nil
  :hook(;; show org ediffs unfolded
        (ediff-prepare-buffer . outline-show-all)
        ;; restore window layout when done
        (ediff-quit . winner-undo))
  :custom
  (ediff-window-setup-function 'ediff-setup-windows-plain)
  (ediff-split-window-function 'split-window-horizontally)
  (ediff-merge-split-window-function 'split-window-horizontally)
  )

;; Automatic parenthesis pairing
(use-package elec-pair
  :ensure nil
  :hook
  (after-init . electric-pair-mode)
  (minibuffer-setup . (lambda () (electric-pair-local-mode 0)))
  :custom
  (electric-pair-inhibit-predicate 'electric-pair-conservative-inhibit)
  (electric-pair-open-newline-between-pairs-psif t)
  )

;; TODO: configure iedit
;; ;; Edit multiple regions in the same way simultaneously
;; (use-package iedit
;;   :defines desktop-minor-mode-table
;;   :bind (("C-;" . iedit-mode)
;;          ("C-x r RET" . iedit-rectangle-mode)
;;          :map isearch-mode-map ("C-;" . iedit-mode-from-isearch)
;;          :map esc-map ("C-;" . iedit-execute-last-modification)
;;          :map help-map ("C-;" . iedit-mode-toggle-on-function))
;;   :config
;;   ;; Avoid restoring `iedit-mode'
;;   (with-eval-after-load 'desktop
;;     (add-to-list 'desktop-minor-mode-table
;;                  '(iedit-mode nil))))

;; TODO: configure expand-region
;; ;; Increase selected region by semantic units
;; (use-package expand-region
;;   :bind ("C-=" . er/expand-region)
;;   :config
;;   (when (centaur-treesit-available-p)
;;     (defun treesit-mark-bigger-node ()
;;       "Use tree-sitter to mark regions."
;;       (let* ((root (treesit-buffer-root-node))
;;              (node (treesit-node-descendant-for-range root (region-beginning) (region-end)))
;;              (node-start (treesit-node-start node))
;;              (node-end (treesit-node-end node)))
;;         ;; Node fits the region exactly. Try its parent node instead.
;;         (when (and (= (region-beginning) node-start) (= (region-end) node-end))
;;           (when-let ((node (treesit-node-parent node)))
;;             (setq node-start (treesit-node-start node)
;;                   node-end (treesit-node-end node))))
;;         (set-mark node-end)
;;         (goto-char node-start)))
;;     (add-to-list 'er/try-expand-list 'treesit-mark-bigger-node)))

;; TODO: configure a lot of packages
;; ;; Multiple cursors
;; (use-package multiple-cursors
;;   :bind (("C-c m" . multiple-cursors-hydra/body)
;;          ("C-S-c C-S-c"   . mc/edit-lines)
;;          ("C->"           . mc/mark-next-like-this)
;;          ("C-<"           . mc/mark-previous-like-this)
;;          ("C-c C-<"       . mc/mark-all-like-this)
;;          ("C-M->"         . mc/skip-to-next-like-this)
;;          ("C-M-<"         . mc/skip-to-previous-like-this)
;;          ("s-<mouse-1>"   . mc/add-cursor-on-click)
;;          ("C-S-<mouse-1>" . mc/add-cursor-on-click)
;;          :map mc/keymap
;;          ("C-|" . mc/vertical-align-with-space))
;;   :pretty-hydra
;;   ((:title (pretty-hydra-title "Multiple Cursors" 'mdicon "nf-md-border_all")
;;     :color amaranth :quit-key ("q" "C-g"))
;;    ("Up"
;; 	(("p" mc/mark-previous-like-this "prev")
;; 	 ("P" mc/skip-to-previous-like-this "skip")
;; 	 ("M-p" mc/unmark-previous-like-this "unmark")
;; 	 ("|" mc/vertical-align "align with input CHAR"))
;;     "Down"
;;     (("n" mc/mark-next-like-this "next")
;; 	 ("N" mc/skip-to-next-like-this "skip")
;; 	 ("M-n" mc/unmark-next-like-this "unmark"))
;;     "Misc"
;;     (("l" mc/edit-lines "edit lines" :exit t)
;; 	 ("a" mc/mark-all-like-this "mark all" :exit t)
;; 	 ("s" mc/mark-all-in-region-regexp "search" :exit t)
;;      ("<mouse-1>" mc/add-cursor-on-click "click"))
;;     "% 2(mc/num-cursors) cursor%s(if (> (mc/num-cursors) 1) \"s\" \"\")"
;; 	(("0" mc/insert-numbers "insert numbers" :exit t)
;; 	 ("A" mc/insert-letters "insert letters" :exit t)))))

;; ;; Smartly select region, rectangle, multi cursors
;; (use-package smart-region
;;   :hook (after-init . smart-region-on))

;; ;; On-the-fly spell checker
;; (use-package flyspell
;;   :ensure nil
;;   :diminish
;;   :if (executable-find "aspell")
;;   :hook (((text-mode outline-mode) . flyspell-mode)
;;          ;; (prog-mode . flyspell-prog-mode)
;;          (flyspell-mode . (lambda ()
;;                             (dolist (key '("C-;" "C-," "C-."))
;;                               (unbind-key key flyspell-mode-map)))))
;;   :init (setq flyspell-issue-message-flag nil
;;               ispell-program-name "aspell"
;;               ispell-extra-args '("--sug-mode=ultra" "--lang=en_US" "--run-together")))

;; ;; Hungry deletion
;; (use-package hungry-delete
;;   :diminish
;;   :hook (after-init . global-hungry-delete-mode)
;;   :init (setq hungry-delete-chars-to-skip " \t\f\v"
;;               hungry-delete-except-modes
;;               '(help-mode minibuffer-mode minibuffer-inactive-mode calc-mode)))

;; ;; Framework for mode-specific buffer indexes
;; (use-package imenu
;;   :ensure nil
;;   :bind (("C-." . imenu)))

;; ;; Move to the beginning/end of line or code
;; (use-package mwim
;;   :bind (("C-a" . mwim-beginning-of-code-or-line)
;;          ("C-e" . mwim-end-of-code-or-line)
;;          ("<home>" . mwim-beginning-of-line-or-code)
;;          ("<end>" . mwim-end-of-line-or-code)))


;; Undo history handler
(use-package undo-fu
	:ensure nil
  :diminish
  :custom
  (undo-limit 67108864) ; 64mb
  (undo-strong-limit 100663296) ; 96mb
  (undo-outer-limit 1006632960) ; 960mb
  )

(use-package undo-fu-session
	:ensure nil
  :diminish
  :after undo-fu
  :hook (after-init . undo-fu-session-global-mode)
  :custom
  (undo-fu-session-incompatible-files '("/COMMIT_EDITMSG\\'" "/git-rebase-todo\\'"))
  )

;; TODO: run formatter before saving
(use-package super-save
  :ensure nil
  :diminish super-save-mode
	:hook (after-init . super-save-mode)
  :custom
  (super-save-auto-save-when-idle t)
	(super-save-silent t)
	(super-save-delete-trailing-whitespace t)
	(super-save-all-buffers t)
	(super-save-exclude '(".gpg" "COMMIT_EDITMSG" "git-rebase-todo"))
  (super-save-triggers
     '(ace-window evil-window-next evil-window-prev evil-window-right evil-window-left evil-window-up evil-window-down balance-windows other-window next-buffer previous-buffer)) ;; edit
	)

;; TODO: add code folding <https://github.com/seagle0128/.emacs.d/blob/master/lisp/init-edit.el#L363>

;; Hanlde minified code
(use-package so-long
  :hook (after-init . global-so-long-mode)
  )

(use-package which-key
  :diminish
  :hook (after-init . which-key-mode)
  :custom
  (which-key-idle-delay 0.5)
	(which-key-separator " ")
  (which-key-prefix-prefix "+")
  )

(use-package rg
  :ensure t
  :custom
  (rg-show-header nil)
  )

;; Writable grep buffer
(use-package wgrep
  :ensure t
  :hook (grep-setup . wgrep-setup)
  :custom
  (wgrep-change-readonly-file t)
  )


(provide 'init-edit)

;;; init-edit.el ends here
