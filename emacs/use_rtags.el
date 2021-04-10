
(add-to-list 'load-path "/opt/rtags/share/emacs/site-lisp/rtags/")
(require 'rtags)
(require 'company-rtags)

(global-set-key (kbd "M-<up>") 'rtags-previous-match)
(global-set-key (kbd "M-<down>") 'rtags-next-match)

(global-set-key (kbd "M-.") 'rtags-find-symbol)
(global-set-key (kbd "M-]") 'rtags-find-references)



(add-hook 'c-mode-hook 'rtags-start-process-unless-running)
(add-hook 'c++-mode-hook 'rtags-start-process-unless-running)

;(define-key c-mode-base-map (kbd "<C-tab>") (function company-complete))
