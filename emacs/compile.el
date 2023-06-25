;; This buffer is for text that is not saved, and for Lisp evaluation.
;; To create a file, visit it with C-x C-f and enter text in its buffer.

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


