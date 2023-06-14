;;
;; Add the following to ~/.emacs
;; (load-file "C:/Git/config/emacs/.emacs")
;;

(setq backup-inhibited t)

(global-set-key "\M-c" 'company-complete)

(custom-set-variables
 '(global-linum-mode t)
 '(indent-tabs-mode nil)
 '(mouse-drag-copy-region t))

(setq gnutls-algorithm-priority "NORMAL:-VERS-TLS1.3")

;; Initialize package sources

(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ;("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")
                         )
      )

(package-initialize) ; activate all the packages

(unless package-archive-contents
  (package-refresh-contents))

(require 'use-package)
(setq use-package-always-ensure t)

(use-package markdown-mode)
(use-package yaml-mode)
(use-package haskell-mode)
(use-package zenburn-theme)

(load-theme 'zenburn t)
(set-face-attribute 'region nil :background "#559")


(setenv "PATH" (concat (getenv "PATH") ":" (expand-file-name "~/.ghcup/bin")))
(setq exec-path (append exec-path '(expand-file-name "~/.ghcup/bin")))

(use-package eglot
  :hook (
         (haskell-mode . eglot-ensure)
         (c++-mode . eglot-ensure)
         ))

(use-package flycheck :config (global-flycheck-mode))
(use-package company
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.5)
  (company-tooltip-align-annotations t)
  (company-tooltip-margin 2)
  :config
  (global-company-mode))


(defvar cbext-dir (file-name-directory load-file-name))
(load-file (format "%s/snippets.el" cbext-dir))

(load-file (format "%s/use_cstyle.el" cbext-dir))

(use-package helm-gtags)

(add-hook 'c-mode-common-hook
  (lambda ()
    (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
      (helm-gtags-mode 1))))

(defun use-gtags()
  (interactive)
  (global-set-key (kbd "M-<up>") 'helm-gtags-previous-history)
  (global-set-key (kbd "M-<down>") 'helm-gtags-next-history)
  (global-set-key (kbd "M-.") 'helm-gtags-dwim)
  (global-set-key (kbd "M-]") 'helm-gtags-find-tag))

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
    

(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((c-mode c++-mode)
                 . ("clangd"
                    "-j=8"
                    "--log=error"
                    "--malloc-trim"
                    "--background-index"
                    "--clang-tidy"
                    "--cross-file-rename"
                    "--completion-style=detailed"
                    "--pch-storage=memory"
                    "--header-insertion=never"
                    "--header-insertion-decorators=0"))))

(defun shell-other-window ()
  "Open a `shell' in a new window."
  (interactive)
  (let ((buf (shell)))
    (switch-to-buffer (other-buffer buf))
    (switch-to-buffer-other-window buf)))

(global-set-key "\C-z" 'shell-other-window)
