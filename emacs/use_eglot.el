
(use-package rust-mode
  :ensure t)

(use-package flymake-clippy
  :hook (rust-mode . flymake-clippy-setup-backend))

(defun manually-activate-flymake ()
  (add-hook 'flymake-diagnostic-functions #'eglot-flymake-backend nil t)
  (flymake-mode 1))

(use-package eglot
  :ensure t
  :hook ((rust-mode . eglot-ensure)
         (eglot-managed-mode . manually-activate-flymake))
  :config
  (add-to-list 'eglot-stay-out-of 'flymake))

; locate a project
(defun cargo-project (dir)
  (let ((workspace (locate-dominating-file dir ".project.el")))
    (if workspace
      (list 'cargo workspace)
      nil)))

(cl-defmethod project-root ((project (head cargo)))
  (nth 1 project))

(add-hook 'before-save-hook
          (lambda ()
	    (when (eq major-mode 'rust-mode)
	      (eglot-format))))


;; (use-package eglot
;;   :hook (
;; ;         (haskell-mode . eglot-ensure)
;;          (c++-mode . eglot-ensure)
;;          (c-mode . eglot-ensure)
;;          (rust-mode . eglot-ensure)
;;          ))

;; (use-package flycheck :config (global-flycheck-mode))
;; (use-package company
;;   :custom
;;   (company-minimum-prefix-length 1)
;;   (company-idle-delay 0.5)
;;   (company-tooltip-align-annotations t)
;;   (company-tooltip-margin 2)
;;   :config
;;   (global-company-mode))

;; (with-eval-after-load 'eglot
;;   (add-to-list 'eglot-server-programs
;;                '((c-mode c++-mode)
;;                  . ("/Users/ubuser/opt/llvm-15.0.7/bin/clangd"
;;                     "-j=8"
;;                     "--log=error"
;; 		    "--use-dirty-headers"
;; ;                    "--malloc-trim"
;;                     "--background-index"
;; ;                    "--clang-tidy=0"
;;  ;                   "--cross-file-rename"
;;                     "--completion-style=detailed"
;; ;                    "--pch-storage=memory"
;; ;                    "--header-insertion=never"
;; ;                    "--header-insertion-decorators=0"
;; 		    ))))


;; (with-eval-after-load 'eglot
;;   (add-to-list 'eglot-server-programs
;;                '((rust-mode)
;;                  . ("~/.cargo/bin/rust-analyzer"
;;                     ))))

