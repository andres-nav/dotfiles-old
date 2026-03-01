;;; init-projectile.el --- Projectile
;;; Commentary:

;;; Code:

(use-package projectile
  :diminish
  :hook (after-init . projectile-mode)
  :custom
  (projectile-use-git-grep t)
  (projectile-enable-caching t)
  (projectile-sort-order 'recentf)
  (projectile-switch-project-action 'projectile-commander)
  (projectile-globally-ignored-files '("TAGS" "tags" ".DS_Store"))
  (projectile-globally-ignored-file-suffixes '(".elc" ".pyc" ".o" ".swp" ".so" ".a"))
  (projectile-globally-ignored-directories
   '("^\\.idea"
     "^\\.vscode"
     "^\\.ensime_cache"
     "^\\.eunit"
     "^\\.git"
     "^\\.hg"
     "^\\.fslckout"
     "^_FOSSIL_"
     "^\\.bzr"
     "^_darcs"
     "^\\.pijul"
     "^\\.tox"
     "^\\.svn"
     "^\\.stack-work"
     "^\\.ccls-cache"
     "^\\.cache"
     "^\\.clangd"
     "^\\node_modules"))
  )

;; TODO: configure consult with projectile
;; (use-package consult-projectile
;;   :ensure t
;;   :init
;;   (+map!
;;    ":"  '(consult-projectile-find-file :wk "Find file in project")
;;    ;; Buffer
;;    "bp" #'consult-projectile-switch-to-buffer
;;    ;; Project
;;    "pp" #'consult-projectile
;;    "pP" '(consult-projectile-switch-project :wk "Switch")
;;    "pR" #'consult-projectile-recentf
;;    "pd" '(consult-projectile-find-dir :wk "Find directory")
;;    "pf" '(consult-projectile-find-file :wk "Find file")))

(provide 'init-projectile)

;;; init-projectile.el ends here
