
(defun indent-marked-files ()
  (interactive)
  (dolist (file (dired-get-marked-files))
    (find-file file)
    (indent-region (point-min) (point-max))
    (save-buffer)
    (kill-buffer nil)))


(defun vc-indent-marked-files ()
  (interactive)
  (dolist (file (vc-dir-marked-files))
    (find-file file)
    (indent-region (point-min) (point-max))
    (save-buffer)
    (kill-buffer nil)))

(defun compile-cmake ()  
  (interactive)
  (get-build-directory)
  )

(defvar compile-cmake-build-directory "build")

(defun get-build-directory ()
  (if buffer-file-name
      (let ((root-dir (locate-dominating-file buffer-file-name compile-cmake-build-directory)))
        (if root-dir
            (let ((build-dir (file-name-concat root-dir compile-cmake-build-directory)))
              
              (progn
                (message (format "building %s" build-dir))
                (compile (format "cmake --build %s" build-dir))))))))


