;;
;; Add the following to ~/.emacs
;; (load-file "C:/Git/config/emacs/.emacs")
;;

(setq backup-inhibited t)
(global-set-key "\C-z" 'shell)

(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/")
             t)

(custom-set-variables
 '(global-linum-mode t)
 '(indent-tabs-mode nil)
 '(mouse-drag-copy-region t))
 
(defvar cbext-dir (file-name-directory load-file-name))

(load-file (format "%s/snippets.el" cbext-dir))
(load-file (format "%s/use_ggtags.el" cbext-dir))
;(load-file (format "%s/use_haskell.el" cbext-dir))
;(load-file (format "%s/use_rtags.el" cbext-dir))


(load-theme 'zenburn t)
(set-face-attribute 'region nil :background "#559")
