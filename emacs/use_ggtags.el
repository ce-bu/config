(global-set-key (kbd "M-<up>") 'ggtags-prev-mark)
(global-set-key (kbd "M-<down>") 'ggtags-next-mark)

(add-hook 'c-mode-common-hook
  (lambda ()
    (when (derived-mode-p 'c-mode 'c++-mode 'java-mode)
      (ggtags-mode 1))))
