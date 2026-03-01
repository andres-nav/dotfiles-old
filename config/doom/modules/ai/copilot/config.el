;;; tools/copilot/config.el -*- lexical-binding: t; -*-

(use-package! copilot
  :after-call (copilot-mode)
  :hook ((prog-mode markdown-mode text-mode) . copilot-mode)
  :bind (:map copilot-completion-map
              ("<tab>" . 'copilot-accept-completion)
              ("TAB" . 'copilot-accept-completion)
              ("C-TAB" . 'copilot-accept-completion-by-word)
              ("C-<tab>" . 'copilot-accept-completion-by-word))
  :config
  (setq copilot-indent-offset-warning-disable t)

  )

(map! :leader :prefix ("l" . "llm")
      :desc "Copilot" "c" #'copilot-mode
      )
