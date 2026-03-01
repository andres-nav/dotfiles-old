;;; $DOOMDIR/lisp/+keybindings.el -*- lexical-binding: t; -*-

(defun open-directory-fuzzy (directory)
  "Open the specified DIRECTORY with fuzzy search."
  (interactive "DDirectory: ")
  (let ((default-directory directory))
    (call-interactively #'find-file)))

(after! evil
  (map!
   :map pdf-view-mode-map
   :gn "j" #'pdf-view-scroll-up-or-next-page
   :gn "k" #'pdf-view-scroll-down-or-previous-page
   :gn "h" #'pdf-view-previous-page-command
   :gn "l" #'pdf-view-next-page-command
   :gn "c" #'pdf-view-center-in-window
   )

  (map! :map doom-leader-file-map
        :desc "Open Inbox directory with fuzzy search" "i" (lambda () (interactive) (open-directory-fuzzy "~/MEGA/0_inbox/"))
        :desc "Open /tmp directory with fuzzy search" "t" (lambda () (interactive) (open-directory-fuzzy "/tmp/"))
        :desc "Open Downloads directory with fuzzy search" "d" (lambda () (interactive) (open-directory-fuzzy "~/Downloads/"))
        :desc "Open Attachments directory with fuzzy search" "a" (lambda () (interactive) (open-directory-fuzzy "~/MEGA/2_attachments/"))
        :desc "Open Git directory with fuzzy search" "g" (lambda () (interactive) (open-directory-fuzzy "~/git/")))

  (map! :map doom-leader-code-map
        :desc "Tmux cd here" "d" #'+tmux/cd-to-here
        :desc "Tmux run" "r" #'+tmux/run
        :desc "Tmux rerun" "c" #'+tmux/rerun
        :desc "Tmux make" "m" (lambda () (interactive) (+tmux/run "make")))
  )
