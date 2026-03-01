;;; $DOOMDIR/lisp/+org.el -*- lexical-binding: t; -*-

(setq +directory (expand-file-name "~/MEGA/")
      +directory-inbox (file-name-concat +directory "0_inbox")
      +directory-projects (file-name-concat +directory "1_projects")
      +directory-brain (file-name-concat +directory "2_brain")
      +directory-contacts (file-name-concat +directory "3_contacts")
      +directory-references (file-name-concat +directory "4_references")
      +directory-attachments (file-name-concat +directory "5_attachments")
      +directory-archive (file-name-concat +directory "z_archive")
      +file-bibliography (file-name-concat +directory-references "bibliography.bib")

      org-directory +directory
      org-roam-directory (file-truename +directory)
      org-attach-id-dir +directory-attachments
      +org-capture-todo-file (file-name-concat +directory-inbox "todo.org")
      +org-capture-notes-file (file-name-concat +directory-inbox "notes.org")

      citar-bibliography +file-bibliography
      citar-org-roam-subdir +directory-references
      org-cite-global-bibliography (list +file-bibliography)
      citar-file-additional-files-separator "-"
      citar-indicators (list (citar-indicator-create :symbol "" :function #'citar-has-files :tag "has:files")
                             (citar-indicator-create :symbol "" :function #'citar-has-links :tag "has:links")
                             (citar-indicator-create :symbol "" :function #'citar-has-notes :tag "has:notes"))
      )

(use-package! org-roam
  :custom
  (org-roam-directory +directory)
  (org-roam-list-files-commands '(find fd fdfind rg))
  (org-roam-db-gc-threshold most-positive-fixnum)
  (org-roam-database-connector 'sqlite-builtin)
  (org-roam-db-location (file-name-concat +directory-archive ".org-roam.db"))
  (org-id-link-to-org-use-id t)
  (org-roam-db-update-on-save nil)
  (org-roam-completion-everywhere nil) ;; disable org-roam completition everywhere
  (org-roam-verbose nil)
  (org-roam-file-exclude-regexp '(".git/" "z_archive/" "node_modules/" "5_attachments" "0_inbox/" ".debris/"))
  :config
  (set-popup-rules!
    `((,(regexp-quote org-roam-buffer) ; persistent org-roam buffer
       :side right :width .33 :height .5 :ttl nil :modeline nil :quit nil :slot 1)
      ("^\\*org-roam: " ; node dedicated org-roam buffer
       :side right :width .33 :height .5 :ttl nil :modeline nil :quit nil :slot 2)))
  (setq org-roam-capture-templates
        '(("b" "brain" plain
           "%?"
           :if-new (file+head "2_brain/%<%Y%m%d%H%M%S>-${slug}.org"
                              "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ("r" "reference" plain "%?"
           :if-new
           (file+head "4_references/${slug}.org" "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ("p" "project" plain "%?"
           :if-new
           (file+head "1_projects/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ("c" "contact" plain "%?"
           :if-new
           (file+head "3_contacts/%<%Y%m%d%H%M%S>-${slug}.org" "#+title: ${title}\n")
           :immediate-finish t
           :unnarrowed t)
          ))
  (defun andresnav/tag-new-node-as-draft ()
    (org-roam-tag-add '("draft")))
  (add-hook 'org-roam-capture-new-node-hook #'andresnav/tag-new-node-as-draft)

  (cl-defmethod org-roam-node-type ((node org-roam-node))
    "Return the TYPE of NODE without the leading number and underscore."
    (condition-case nil
        (replace-regexp-in-string
         "^[0-9]+_" ""  ;; Match a number followed by an underscore at the start
         (file-name-nondirectory
          (directory-file-name
           (file-name-directory
            (file-relative-name (org-roam-node-file node) org-roam-directory)))))
      (error "")))

  (setq org-roam-node-display-template
        (concat "${type:15} ${title:*} " (propertize "${tags:20}" 'face 'org-tag)))

  (require 'citar)
  (defun andresnav/org-roam-node-from-cite (keys-entries)
    (interactive (list (citar-select-ref :multiple nil :rebuild-cache t)))
    (let ((title (citar--format-entry-no-widths (cdr keys-entries)
                                                "${title} :: ${author editor}")))
      (org-roam-capture- :templates
                         '(("r" "reference" plain "%?" :if-new
                            (file+head "4_references/${citekey}.org"
                                       ":PROPERTIES:
:ROAM_REFS: [cite:@${citekey}]
:END:
#+title: ${title}\n")
                            :immediate-finish t
                            :unnarrowed t))
                         :info (list :citekey (car keys-entries))
                         :node (org-roam-node-create :title title)
                         :props '(:finalize find-file)))))

(defun andresnav/org-roam-agenda-files ()
  "Return a list of note files containing project tag." ;
  (seq-uniq
   (seq-map
    #'car
    (org-roam-db-query
     [:select [nodes:file]
      :from tags
      :left-join nodes
      :on (= tags:node-id nodes:id)
      :where (or (like tag (quote "%\"area\"%"))
                 (like tag (quote "%\"project\"%")))]))))

(defun andresnav/agenda-files-update (&rest _)
  "Update the value of `org-agenda-files'."
  (interactive)
  (setq org-agenda-files (andresnav/org-roam-agenda-files)))

(setq org-capture-templates
      '(
        ("t" "Task Inbox" entry
         (file +org-capture-todo-file)
         "* TODO %?\n %i\n %a" :prepend t :empty-lines-after 1)
        ("n" "Note Inbox" entry
         (file +org-capture-notes-file)
         "* %?\n %i\n %a\n %u" :prepend t :empty-lines-after 1)
        ("p" "Projects")
        ("pt" "Task" entry
         (function (org-roam-node-find))
         "* TODO %?\n %i\n %a" :prepend t :empty-lines-after 1)
        )
      )


(after! org
  (setq org-ellipsis " ▼ "
        org-hide-emphasis-markers t
        org-image-actual-width '(0.9)
        org-list-demote-modify-bullet '(("+" . "-") ("-" . "+") ("*" . "+") ("1." . "a."))
        org-preview-latex-default-process 'dvisvgm
        org-startup-with-latex-preview nil
        org-startup-folded 'fold
        org-export-in-background t
        org-cycle-separator-lines 0
        org-tags-column 8
        org-fast-tag-selection-include-todo t
        org-todo-keywords
        '(
          (sequence
           "TODO(t)" ; doing later
           "NEXT(n)" ; doing now or soon
           "FOCS(f)" ; doing now or soon
           "|"
           "DONE(d)" ; done
           )
          (sequence
           "WAIT(w@/!)" ; waiting
           "IDEA(i)" ; maybe someday
           "GOAL(g)" ; goal to achieve
           "EVNT(e)" ; goal to achieve
           "|"
           "STOP(s@/!)" ; stopped waiting, decided not to work on it
           )
          )
        org-log-done 'time
        org-log-into-drawer t
        )


  (use-package! org-super-agenda
    :hook (org-agenda-mode . org-super-agenda-mode)
    )

  (setq org-agenda-skip-scheduled-if-done t
        org-agenda-skip-deadline-if-done t
        org-agenda-include-deadlines t
        org-agenda-block-separator nil
        org-agenda-compact-blocks t
        org-agenda-files (andresnav/org-roam-agenda-files)
        org-agenda-start-day nil ;; i.e. today
        org-agenda-span 7
        )

  (setq org-columns-default-format
        "%TODO %3PRIORITY %40ITEM(Task) %17Effort(Estimated Effort){:} %CLOCKSUM %8TAGS(TAG)")

  (defun andresnav/org-roam-get-title ()
    "Get the first 15 characters of the Org-roam title for the current entry, right-aligned and padded with spaces."
    (when-let* ((file (buffer-file-name))
                (title (caar (org-roam-db-query
                              [:select title :from nodes :where (= file $s1)]
                              file))))
      (let ((short-title (if (> (length title) 15)
                             (substring title 0 15)
                           title)))
        (format "%-15s" short-title))))  ;; Pad with spaces to 10 characters, left-aligned

  (setq org-agenda-prefix-format
        '((agenda . "%-4t %(andresnav/org-roam-get-title) %-4t %s")
          (todo . "%-4t %(andresnav/org-roam-get-title) %-4t %s")
          (tags . "%-4t %(andresnav/org-roam-get-title) %-4t %s")
          (search . " %l")))

  ;; hide project and area tags in the org agenda view
  (setq org-agenda-hide-tags-regexp "\\(?:\\`\\|:\\)\\(project\\|area\\)\\(?:\\'\\|:\\)")

  ;; Customize the look of deadlines and scheduled tasks in the agenda
  (setq org-agenda-deadline-leaders '("" "In %d days: " "%d days ago: "))
  (setq org-agenda-scheduled-leaders '("" "%d days ago: "))

  ;; Ensure scheduled tasks are shown on all agenda views
  (setq org-agenda-show-all-dates t)

  ;; Remove inherited tags
  (setq org-agenda-show-inherited-tags nil)

  (setq org-agenda-sorting-strategy
        '((agenda deadline-up scheduled-up habit-down time-up urgency-down category-keep)
          (todo deadline-up scheduled-up urgency-down category-keep)
          (tags deadline-up scheduled-up urgency-down category-keep)
          (search category-keep)))


  (setq org-agenda-custom-commands
        '(("z" "Super view"
           ((agenda "" ((org-agenda-span 'day)
                        (org-super-agenda-groups
                         '((:name "Today"
                            :date today
                            :scheduled (past, today)
                            :deadline (past, today)
                            :order 1)
                           (:name "Due Soon"
                            :scheduled future
                            :deadline future
                            :order 2)
                           ))))
            (alltodo "" ((org-agenda-overriding-header "")
                         (org-agenda-todo-ignore-scheduled 'near)
                         (org-agenda-todo-ignore-deadlines 'near)
                         (org-super-agenda-groups
                          '((:name "Next to do"
                             :todo "NEXT"
                             :order 10)
                            (:name "REALLY Important"
                             :priority "A"
                             :order 11)
                            (:name "Waiting"
                             :todo "WAIT"
                             :order 12)
                            (:name "Important"
                             :priority "B"
                             :order 13)
                            (:name "Future"
                             :scheduled future
                             :deadline future
                             :order 14)
                            (:name "Active Projects"
                             :and (:tag "project"
                                   :not (:todo "IDEA"))
                             :order 20)
                            (:name "Focus Areas"
                             :and (:tag "area"
                                   :not (:todo "IDEA"))
                             :order 21)
                            (:name "Ideas"
                             :todo ("IDEA")
                             :order 90)))))))))


  (use-package! org-agenda-show-deadlines
    :after org
    :hook (org-agenda-mode . org-agenda-show-deadlines-mode)
    :custom
    (org-agenda-show-deadlines-date-format  "%B %d, %Y")
    (org-agenda-show-deadlines-column 125)
    )
  )


;; Customize the face for org-bold using your Doom theme colors
(after! org
  (defface andresnav/org-bold
    '((t (:inherit bold :foreground "#cc241d")))
    "Bold face."
    :group 'custom-faces)  ;; Specify the group

  (add-to-list 'org-emphasis-alist
               ;; set emphasis face
               '("*" andresnav/org-bold))
  )


(map! :leader "z" #'org-agenda)

(map! :after (evil org)
      :map org-super-agenda-header-map
      "j" #'org-agenda-next-item
      "k" #'org-agenda-previous-item
      )

;; ox-hugo config
(setq org-hugo-base-dir "~/git/github/quartz-andresnav.com"
      org-export-with-broken-links t
      )

(defun andresnav/clear-directories (directory)
  "Remove all subdirectories inside the specified DIRECTORY, leaving files intact."
  (when (file-directory-p directory)
    (dolist (file (directory-files directory t))
      (when (and (file-directory-p file)
                 (not (member (file-name-nondirectory file) '("." ".."))))
        (delete-directory file t t)))))

(after! org
  (org-link-set-parameters "projectile"
                           :follow (lambda (path)
                                     (projectile-switch-project-by-name path)))
  )

(after! projectile
  (add-to-list 'projectile-globally-ignored-directories "~/MEGA/"))

(defun andresnav/remove-publish-tag (file-path)
  "Remove the publish tag from the front matter of the markdown FILE-PATH."
  (with-temp-buffer
    (insert-file-contents file-path)
    (goto-char (point-min))
    ;; Match the tags line, ensuring it starts with 'tags:' and contains a list
    (when (re-search-forward "^tags = *\\(\\[.*\\]\\)" nil t)
      (let ((tags (match-string 1)))
        ;; Remove the "publish" tag from the list
        (setq tags (replace-regexp-in-string "\"publish\",? *" "" tags))
        ;; If 'publish' was removed and the list is now empty, clean up any trailing commas or whitespace
        (setq tags (replace-regexp-in-string "^,\\|,$" "" tags))
        ;; Replace the original line with the updated tags
        (goto-char (match-beginning 1))
        (delete-region (match-beginning 1) (match-end 1))
        (insert tags)))
    (write-region (point-min) (point-max) file-path)))


(defun andresnav/copy-directory (src dst)
  "Copy SRC directory to DST directory, including all files and subdirectories."
  (unless (file-directory-p src)
    (error "Source directory does not exist: %s" src))
  (when (file-directory-p dst)
    (error "Destination directory already exists: %s" dst))
  (copy-directory src dst t))

(defun andresnav/org-roam-export-publish ()
  "Re-exports all Org-roam files with the publish filetag to Hugo markdown."
  (interactive)
  (when (bound-and-true-p org-hugo-base-dir)
    (let* ((content-dir (expand-file-name "content" org-hugo-base-dir))
           (static-dir (expand-file-name "static" org-hugo-base-dir))
           (ox-hugo-src-dir (expand-file-name "static/ox-hugo" org-hugo-base-dir))
           (ox-hugo-content-dir (expand-file-name "content/ox-hugo" org-hugo-base-dir))
           )

      ;; Clear the content directory
      (when (file-directory-p content-dir)
        (andresnav/clear-directories content-dir))

      ;; Clear the static directory
      (when (file-directory-p static-dir)
        (andresnav/clear-directories static-dir))

      ;; Proceed with the export process
      (dolist (f (org-roam-db-query
                  [:select [nodes:file]
                   :from tags
                   :left-join nodes
                   :on (= tags:node-id nodes:id)
                   :where (like tag (quote "%\"publish\"%"))]))
        (with-current-buffer (find-file (car f))
          (org-hugo-export-to-md)))

      ;; Copy the ox-hugo folder to the content directory
      (when (file-directory-p ox-hugo-src-dir)
        (andresnav/copy-directory ox-hugo-src-dir ox-hugo-content-dir))

      ;; Remove 'publish' tag from all markdown files in content-dir
      (dolist (file (directory-files-recursively content-dir "\\.md$"))
        (andresnav/remove-publish-tag file)))))

;; TODO limit the org agenda files to org files that are not in the archive repo



;; add org-extras to ignore headlines
(after! ox
  (require 'ox-extra)
  (ox-extras-activate '(ignore-headlines latex-header-blocks)))

(defun andresnav/org-roam-filter-by-tags (tag-names)
  "Filter function to check if the given NODE has the specified TAGS and is not a heading."
  (lambda (node)
    (and (cl-loop for tag in tag-names
                  thereis (member tag (org-roam-node-tags node)))
         (= (org-roam-node-level node) 0))))  ;; Exclude headings (level > 0)

(defun andresnav/org-roam-find-project-or-area ()
  "Find and open an Org-roam node based on the \=project\= or \=area\= tags."
  (interactive)
  (org-roam-node-find nil nil
                      (andresnav/org-roam-filter-by-tags '("project" "area"))))

(defun andresnav/org-roam-find-contact ()
  "Find and open an Org-roam node based on the \=contact\= tag."
  (interactive)
  (org-roam-node-find nil nil
                      (andresnav/org-roam-filter-by-tags '("contact"))))

(defun andresnav/org-roam-find-all ()
  "Find and open an Org-roam node in my brain, including only top-level nodes (non-headings)."
  (interactive)
  (org-roam-node-find nil nil
                      (lambda (node)
                        (= (org-roam-node-level node) 0))))  ;; Filter for top-level nodes only

;; open the life org roam note
(defun andresnav/org-roam-open-life ()
  "Open the Org-roam note titled 'Life' directly."
  (interactive)
  (let ((node (org-roam-node-from-title-or-alias "Life")))
    (if node
        (org-roam-node-visit node)
      (message "No note with the title 'Life' found."))))

(map! :after evil
      :map doom-leader-notes-map
      :desc "Org capture" "n" #'org-capture
      :desc "Life page" "SPC" #'andresnav/org-roam-open-life
      (:prefix-map ("f" . "find")
       :desc "Find project or area" "f" #'andresnav/org-roam-find-project-or-area
       :desc "Find node" "SPC" #'andresnav/org-roam-find-all
       :desc "Find contact" "c" #'andresnav/org-roam-find-contact
       :desc "Find all" "a" #'org-roam-node-find
       )
      )

                                        ; use leader z for org agenda

;; ;; Offer completion for #tags and @areas separately from notes.
;; (add-to-list 'org-roam-completion-functions #'org-roam-complete-tag-at-point)

;; ;; Make the backlinks buffer easier to peruse by folding leaves by default.
;; (add-hook 'org-roam-buffer-postrender-functions #'magit-section-show-level-2)

;; ;; Open in focused buffer, despite popups
;; (advice-add #'org-roam-node-visit :around #'+popup-save-a)

;; ;; Add ID, Type, Tags, and Aliases to top of backlinks buffer.
;; (advice-add #'org-roam-buffer-set-header-line-format :after #'org-roam-add-preamble-a)

(use-package! consult-org-roam
  :after org-roam
  :init
  (require 'consult-org-roam)
  ;; Activate the minor mode
  (consult-org-roam-mode 1)
  :custom
  ;; Use `ripgrep' for searching with `consult-org-roam-search'
  (consult-org-roam-grep-func #'consult-ripgrep)
  ;; Configure a custom narrow key for `consult-buffer'
  (consult-org-roam-buffer-narrow-key ?r)
  ;; Display org-roam buffers right after non-org-roam buffers
  ;; in consult-buffer (and not down at the bottom)
  (consult-org-roam-buffer-after-buffers t)
  :config
  ;; Eventually suppress previewing for certain functions
  (consult-customize
   consult-org-roam-forward-links
   :preview-key "M-.")
  )
