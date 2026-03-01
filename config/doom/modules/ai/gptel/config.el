;;; ai/gptel/config.el -*- lexical-binding: t; -*-

(use-package! gptel
  :after-call (gptel-mode-hook)
  :custom
  (gptel-directives '((default . "")))
  :config
  (setq! gptel-default-mode #'org-mode)

  (setf (alist-get 'org-mode gptel-response-prefix-alist)
        "* *Response*: ")
  (setf (alist-get 'org-mode gptel-prompt-prefix-alist)
        "* *Prompt*: ")
  )

(map! :leader :prefix ("l" . "llm")
      :desc "Gptel menu" "m" #'gptel-menu
      :desc "Gptel buffer" "b" #'gptel
      :desc "Gptel send" "s" #'gptel-send
      :desc "Gptel system prompt" "p" #'gptel-system-prompt
      :desc "Gptel org set properties" "o" #'gptel-org-set-properties
      :desc "Gptel org set topic" "t" #'gptel-org-set-topic
      :desc "Gptel abort" "x" #'gptel-abort
      :desc "Gptel refactor" "r" #'gptel-abort
      )
