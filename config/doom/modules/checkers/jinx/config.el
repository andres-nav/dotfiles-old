;;; tools/jinx/config.el -*- lexical-binding: t; -*-

(use-package! jinx
  :defer t
  :init
  (setq jinx-languages "en_US es_ES")
  :hook (emacs-startup . global-jinx-mode)
  :custom
  (jinx-include-modes '(text-mode prog-mode))
  (jinx-exclude-regexps
   '((t "[A-Z]+\\>" ;; sequences of uppercase letters
      "\\w*?[0-9\.'\"-]\\w*" ;; words that have at least one digit of ., ', ", -
      "[a-z]+://\\S-+" ;; urls
      "<?[-+_.~a-zA-Z][-+_.~:a-zA-Z0-9]*@[-.a-zA-Z0-9]+>?" ;; email addresses
      )))
  :config
  (push 'org-inline-src-block
        (alist-get 'org-mode jinx-exclude-faces))

  (map! :map evil-normal-state-map
        "z SPC" #'jinx-correct)

  ;; (after! evil-commands
  ;;   (global-set-key [remap evil-next-flyspell-error] #'jinx-next)
  ;;   (global-set-key [remap evil-prev-flyspell-error] #'jinx-previous))

  ;; I prefer for `point' to end up at the start of the word,
  ;; not just after the end.
  ;; (advice-add 'jinx-next :after (lambda (_) (left-word)))
  )
