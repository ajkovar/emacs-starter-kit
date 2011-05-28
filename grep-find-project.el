(require 'find-file-in-project)

(defvar gfp-file-history nil)
(defvar gfp-text-history nil)

(defun grep-find-project ()
  "Search for text in all files in a project"
  (interactive)
  ;; reliance on find-function-in-project.el
  (let* ((project-root (ffip-project-root))
         (default-file-match (or (car gfp-file-history) ""))
         (default-text-match (or (car gfp-text-history) ""))
         (file-match (read-shell-command "Files matching: " default-file-match 'gfp-file-history))
         (grep-for (read-shell-command "Search text: " default-text-match 'gfp-text-history))
         (find-command (concat "find " project-root " -name \"" file-match "\" -exec grep -Hn --color " grep-for " {} \\;")))
    (compilation-start find-command 'grep-mode)))

(provide 'grep-find-project)
