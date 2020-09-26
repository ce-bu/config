(setq backup-inhibited t)
(global-set-key "\C-z" 'shell)

(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/")
             t)


(custom-set-variables
 '(custom-enabled-themes (quote (leuven)))
 '(global-linum-mode t)
 '(indent-tabs-mode nil)
 '(mouse-drag-copy-region t))
 
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "Fira Code Medium" :foundry "outline" :slant normal :weight normal :height 135 :width normal)))))


