
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



(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((rust-mode)
                 . ("~/.cargo/bin/rust-analyzer"
                    ))))

(add-hook 'before-save-hook
          (lambda ()
	    (when (eq major-mode 'rust-mode)
	      (eglot-format))))


(use-package flycheck :config (global-flycheck-mode))
(use-package company
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.5)
  (company-tooltip-align-annotations t)
  (company-tooltip-margin 2)
  :config
  (global-company-mode))

(global-set-key "\M-a" 'eglot-code-actions)
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

