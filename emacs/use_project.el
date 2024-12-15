
; locate a project
(defun cargo-project (dir)
  (let ((workspace (locate-dominating-file dir ".project.el")))
    (if workspace
      (list 'cargo workspace)
      nil)))

(cl-defmethod project-root ((project (head cargo)))
  (nth 1 project))

(use-package project
  ;; Cannot use :hook because 'project-find-functions does not end in -hook
  ;; Cannot use :init (must use :config) because otherwise
  ;; project-find-functions is not yet initialized.
  :config
  (add-hook 'project-find-functions #'cargo-project))
