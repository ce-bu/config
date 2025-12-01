;;
;; Add the following to ~/.emacs
;; (load-file "C:/Git/config/emacs/.emacs")
;;

(setq backup-inhibited t)
(global-display-line-numbers-mode 1)

(custom-set-variables
 '(global-linum-mode t)
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

;; sub extensions
(defvar ext-dir (file-name-directory load-file-name))

(use-package markdown-mode)
(use-package yaml-mode)

(load-file (format "%s/use_project.el" ext-dir))

;; zenburn theme
(use-package zenburn-theme)
(load-theme 'zenburn t)
(set-face-attribute 'region nil :background "#559")

;; GTAGS
(use-package helm-gtags)
(defun use-gtags()
  (interactive)
  (global-set-key (kbd "M-<up>") 'helm-gtags-previous-history)
  (global-set-key (kbd "M-<down>") 'helm-gtags-next-history)
  (global-set-key (kbd "M-.") 'helm-gtags-dwim)
  (global-set-key (kbd "M-]") 'helm-gtags-find-tag))
    

(defun shell-other-window ()
  "Open a `shell' in a new window."
  (interactive)
  (let ((buf (shell)))
    (switch-to-buffer (other-buffer buf))
    (switch-to-buffer-other-window buf)))

(global-set-key "\C-z" 'shell-other-window)
(global-set-key (kbd "M-<up>") 'xref-go-back)
(global-set-key (kbd "M-<down>") 'xref-go-forward)
(global-set-key (kbd "M-]") 'xref-find-references)


;; c-style
(load-file (format "%s/snippets.el" ext-dir))
(load-file (format "%s/use_cstyle.el" ext-dir))

(use-package company)


;; eglot
(load-file (format "%s/use_eglot.el" ext-dir))
;; project
(load-file (format "%s/use_project.el" ext-dir))

