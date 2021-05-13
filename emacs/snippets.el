
(defun snip-empty ()
  (interactive)
  (delete-region (point-min) (point-max)))

(defun snip-contents (file args)
  (save-excursion
    (get-buffer-create "*snippets*")
    (set-buffer "*snippets*")
    (snip-empty)
    (goto-char (point-min))
    (insert-file-contents file)
    (dolist (kv args)
      (let ((key (format "!%s!" (car kv)))
            (value (cdr kv)))
        (while (re-search-forward key nil t)
          (replace-match value)))))
  (insert-buffer-substring "*snippets*"))

(defun snip-file (name)
  (format "%s/%s" cbext-dir name))


(defun snip-class (name)
  (interactive "MClass Name: ")
  (let ((klass (cdr (assoc system-type '((windows-nt . "class.cpp") (gnu/linux . "class-linux.cpp"))))))
    (snip-contents (snip-file klass)
                   `(("name" . ,name) ))))

(defun snip-main ()
  (interactive)
  (snip-empty)
  (insert-file-contents (snip-file "main.cpp")))


(defun snip-ifdef ()
  (interactive)
  (require 'uuid)
  (save-excursion
    (goto-char (point-min))
    (let* ((id (upcase (replace-regexp-in-string "-" "_" (uuid-string)))))
      (insert (format "#ifndef H_%s\n" id))
      (insert (format "#define H_%s\n" id))
      (insert (format "#endif\n" id)))))
      
               
(defun snip-bash-array ()
  (interactive)
  (snip-empty)
  (insert-file-contents (snip-file "bash_array.sh")))
