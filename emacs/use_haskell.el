(use-package haskell-mode) ; install mode for Haskell files
(use-package lsp-mode) ; you will definitely need LSP support
(use-package lsp-ui) ; that's a nice LSP package as well
;; finally, Haskell LSP setup:
(use-package lsp-haskell
  :hook
  (haskell-mode . lsp)
  (haskell-literate-mode . lsp))
(setenv "PATH" (concat (getenv "PATH") ":" (expand-file-name "~/.ghcup/bin")))
(setq exec-path (append exec-path '(expand-file-name "~/.ghcup/bin")))
