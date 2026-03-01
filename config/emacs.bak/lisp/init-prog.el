;; init-prog.el --- Initialize format-all configurations

;;; Commentary:

;;; Code:

(use-package csv-mode)

;; TODO: fix keybindings
(use-package eglot
  :disabled
  :hook (prog-mode . eglot-ensure)
  :bind (:map eglot-mode-map
              ("C-c f" . eglot-format)
              ("C-c d" . eldoc-doc-buffer)
              ("C-c a" . eglot-code-actions)
              ("C-c r" . eglot-rename)
              ("C-c l" . eglot-command-map))
  :config
  (defvar-keymap eglot-command-map
    :prefix 'eglot-command-map
    ;; workspaces
    "w q" #'eglot-shutdown
    "w r" #'eglot-reconnect
    "w s" #'eglot
    "w d" #'eglot-show-workspace-configuration

    ;; formatting
    "= =" #'eglot-format-buffer
    "= r" #'eglot-format

    ;; goto
    "g a" #'xref-find-apropos
    "g d" #'eglot-find-declaration
    "g g" #'xref-find-definitions
    "g i" #'eglot-find-implementation
    "g r" #'xref-find-references
    "g t" #'eglot-find-typeDefinition

    ;; actions
    "a q" #'eglot-code-action-quickfix
    "a r" #'eglot-code-action-rewrite
    "a i" #'eglot-code-action-inline
    "a e" #'eglot-code-action-extract
    "a o" #'eglot-code-action-organize-imports)
  :custom
  (eglot-sync-connect 0)
  (eglot-autoshutdown t)
  (eglot-extend-to-xref t)
  (eglot-events-buffer-size 0)
  (eglot-ignored-server-capabilities '(:documentLinkProvider
                                       :documentOnTypeFormattingProvider)))

(use-package emacs
  :custom
  (js-indent-level 2)
  (python-indent-offset 2)
  (standard-indent 2)
  (tab-width 2)
  (c-basic-offset 2)
  )

;; better compilation
(use-package compile
	:ensure nil
	:custom
	(compilation-always-kill t)
	(compilation-scroll-output 'first-error)
	(compilation-ask-about-save nil)
	(compilation-context-lines 5)
	(compilation-auto-jump-to-first-error t)
	(compilation-skip-threshold 2)
	(compilation-disable-input nil)
	(compilation-environment '("TERM=xterm-256color"))
	)


;; GitHub Copilot
(use-package copilot
  :straight (:host github :repo "zerolfx/copilot.el" :files ("dist" "*.el"))
  :ensure t
  :hook
  (prog-mode . copilot-mode)
  :bind (:map copilot-completion-map
              ("C-<SPC>" . copilot-accept-completion)
              ("C-S-n" . copilot-next-completion)
              ("C-S-p" . copilot-previous-completion)
              ("C-S-<SPC>" . copilot-accept-completion-by-word))
  )

(use-package direnv
  :hook (after-init .  direnv-mode)
  :custom
  (direnv-show-paths-in-summary nil)
  (direnv-always-show-summary nil)
  )

(provide 'init-prog)

;;; init-prog.el ends here
