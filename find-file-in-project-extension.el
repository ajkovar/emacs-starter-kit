(require 'find-file-in-project)

;; alternate implentation of file-file-in-project
(defun directory-files-recursive (directory)
  (let ((files (mapcar (lambda (file)
                         ;; add full path
                         (concat (file-name-as-directory directory) file))
                       ;; remove hidden directories
                       (remove-if (lambda (file)
                                    (string= (subseq file 0 1) "."))
                                  (directory-files directory))))
        subdirectory-files)
    (dolist (file files)
      (if (file-directory-p file)
          (setq subdirectory-files (append subdirectory-files (directory-files-recursive file)))))
    (setq files (remove-if 'file-directory-p files))
    (setq files (append files subdirectory-files))))

(defun find-file-in-project-wrapper ()
  "Wrapper around find-file-in-project to speed it up when there is no filter on file types to be searched"
  (interactive)
  (if ffip-patterns
      (find-file-in-project)
    (let ((file (ido-completing-read "Choose recent file: " (directory-files-recursive (ffip-project-root)) nil t)))
      (when file
        (find-file file)))))

(provide 'find-file-in-project-extension)
