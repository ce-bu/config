
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

(use-package flycheck-rust);

(with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(add-hook 'before-save-hook
          (lambda ()
	    (when (eq major-mode 'rust-mode)
	      (eglot-format))))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '(rust-mode (executable-find "rust-analyzer" ))))
	       


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


(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((c-mode c++-mode)
                 . ("/usr/bin/clangd"
                    "-j=8"
                    "--log=error"
		    "--use-dirty-headers"
;                    "--malloc-trim"
                    "--background-index"
;                    "--clang-tidy=0"
 ;                   "--cross-file-rename"
                    "--completion-style=detailed"
;                    "--pch-storage=memory"
;                    "--header-insertion=never"
;                    "--header-insertion-decorators=0"
		    ))))

