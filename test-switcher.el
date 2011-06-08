(defun switch-between-test-and-source ()
  "Switch between test and source files.. right now just for clojure"
  (interactive)
  (let* ((project-root (expand-file-name (ffip-project-root)))
       (current-file buffer-file-name)
       (remainder (subseq current-file (length project-root) (length current-file))))
  (find-file
   (concat project-root
           (if (is-test-file? remainder)
               (build-src-path remainder)
             (build-test-path remainder))))))

(defun build-test-path (remainder)
  (let ((separator ?/)
        (i 0)
       path-parts)
  (dolist (part (split remainder separator))
    (if (= i 0)
        (push "test" path-parts)
      (push part path-parts))
    (if (= i 1)
        (push "test" path-parts))
    (incf i))
  (join (nreverse path-parts) (char-to-string separator))))

(defun build-src-path (remainder)
  (let ((separator ?/)
        (i 0)
       path-parts)
  (dolist (part (split remainder separator))
    (if (= i 0)
        (push "src" path-parts)
      (if (/= i 2)
         (push part path-parts)))
    (incf i))
  (join (nreverse path-parts) (char-to-string separator))))

(defun is-test-file? (remainder)
  (string= (subseq remainder 0 4) "test"))

(defun split (string separator)
    "Returns a list of substrings of string divided by separator"
    (loop for i = 0 then (1+ j)
          as j = (position separator string :start i)
          collect (subseq string i j)
          while j))

(defun join (list separator)
  "Joins a list by separator"
  (let ((string "")
        (i 0))
    (dolist (item list)
      (if (not (= i 0))
          (setq string (concat string separator)))
      (incf i)
      (setq string (concat string item)))
    string))

(provide 'test-switcher)
