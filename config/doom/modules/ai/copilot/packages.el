;; -*- no-byte-compile: t; -*-
;;; tools/copilot/packages.el

(package! copilot
  :recipe (:host github :repo "copilot-emacs/copilot.el" :files ("*.el"))
  :pin "5f30a2b667df03c120ba31ce3af933255c8a558b")
