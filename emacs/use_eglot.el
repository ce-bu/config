
(use-package rust-mode
  :ensure t)

(add-hook 'before-save-hook
          (lambda ()
	    (when (eq major-mode 'rust-mode)
	      (eglot-format))))


(use-package eglot
  :hook ((rust-mode nix-mode) . eglot-ensure)
  :config (add-to-list 'eglot-server-programs
                       `(rust-mode . (,(executable-find "rust-analyzer")
				      :initializationOptions
                                      ( :procMacro (:enable t)
					:check (:command "clippy")
					:cargo (
						:buildScripts (:enable t)
					        :targetDir ".rust-analyzer" ;(file-name-concat (getenv "HOME") ".rust-analyzer")
							     
					       :features "all"))))))

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
                    "--header-insertion=never"
;                    "--header-insertion-decorators=0"
		    ))))

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((cperl-mode perl-mode) . ("/home/ubuser/.nvm/versions/node/v25.1.0/bin/perlnavigator" "--stdio"))))
(add-hook 'cperl-mode-hook 'eglot-mode)
(add-hook 'perl-mode-hook 'eglot-ensure)

(use-package company
  :config
  (global-company-mode))

