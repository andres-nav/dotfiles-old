;; init-treesit.el --- Initialize treesit configurations

;;; Commentary:

;;; Code:

;; FIXME

;; (use-package treesit-auto
;;   :hook
;;   (after-init . global-treesit-auto-mode)
;;   :custom
;;   (treesit-auto-install 'prompt)
;;   :config
;;   (add-to-list 'treesit-auto-recipe-list
;; 	       (make-treesit-auto-recipe
;; 		:lang 'nix
;; 		:ts-mode 'nix-ts-mode
;; 		:remap 'nix-mode
;; 		:url "https://github.com/nix-community/tree-sitter-nix"
;; 		:revision "master"
;; 		:source-dir "src"))
;;   )

;; (use-package treesit
;;   :ensure nil
;;   :custom
;;   (treesit-language-source-alist
;;    '((bash "https://github.com/tree-sitter/tree-sitter-bash")
;;      (cmake "https://github.com/uyha/tree-sitter-cmake")
;;      (css "https://github.com/tree-sitter/tree-sitter-css")
;;      (elisp "https://github.com/Wilfred/tree-sitter-elisp")
;;      (go "https://github.com/tree-sitter/tree-sitter-go")
;;      (html "https://github.com/tree-sitter/tree-sitter-html")
;;      (javascript "https://github.com/tree-sitter/tree-sitter-javascript" "master" "src")
;;      (json "https://github.com/tree-sitter/tree-sitter-json")
;;      (make "https://github.com/alemuller/tree-sitter-make")
;;      (markdown "https://github.com/ikatyang/tree-sitter-markdown")
;;      (python "https://github.com/tree-sitter/tree-sitter-python")
;;      (toml "https://github.com/tree-sitter/tree-sitter-toml")
;;      (tsx "https://github.com/tree-sitter/tree-sitter-typescript" "master" "tsx/src")
;;      (typescript "https://github.com/tree-sitter/tree-sitter-typescript" "master" "typescript/src")
;;      (nix "https://github.com/nix-community/tree-sitter-nix" "master" "src")
;;      (yaml "https://github.com/ikatyang/tree-sitter-yaml")))
;;   (treesit-font-lock-level 4)
;;   (major-mode-remap-alist
;;    '((nix-mode . nix-ts-mode))
;;    )
;;   :config
;;   (dolist (lang treesit-language-source-alist)
;;     (unless (treesit-language-available-p (car lang))
;;       (treesit-install-language-grammar (car lang))))

;;   (cl-loop for (old-mode . new-mode) in major-mode-remap-alist
;;            do (set (intern (concat (symbol-name new-mode) "-hook"))
;;                    (list
;;                     (eval `(lambda ()
;;                              (run-hooks
;;                               ',(intern (concat (symbol-name old-mode) "-hook")))))))))

;; ;; TODO: make langs to install automatically

;; ;; TODO: add textobjects
;; (use-package evil-textobj-tree-sitter
;;   :diminish
;;   )

(provide 'init-treesit)

;;; init-treesit.el ends here
