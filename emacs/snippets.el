
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
  (snip-contents (snip-file "class.cpp") `(("name" . ,name) )))

(defun snip-main ()
  (interactive)
  (snip-empty)
  (insert-file-contents (snip-file "main.cpp")))

