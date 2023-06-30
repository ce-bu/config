
(defun c-align-arglist-intro-under-par (langelem)
  (if (eq (c-langelem-sym langelem) 'arglist-intro)
      (save-excursion
        (goto-char (c-langelem-pos langelem))
        (c-syntactic-re-search-forward "(" nil t)
        (if (looking-at c-syntactic-eol)
          (vector (current-column))))))

(defun c-align-substatement-open (langelem)
  (if (eq (c-langelem-sym langelem) 'substatement-open)
      (save-excursion
        (goto-char (c-langelem-pos langelem))
        (when (looking-at "return")
          (goto-char (match-beginning 0))
          (vector (+ 7 (current-column)))))))


;; fix statement continuations

(defun c-align-statement-cont (langelem)
  (save-excursion
    (beginning-of-line)
    (c-skip-ws-forward)
    (cond
     ((eq (char-after) ?.)
      (progn
        (c-beginning-of-statement-1)
        (vector (+ 4  (current-column)))))

     ((eq (char-after) ?{)
      (progn
        (c-beginning-of-statement-1)
        (vector (+ 7  (current-column)))))     

     )))

;;;###autoload
(defconst cb-c-style
  `(
    (c-basic-offset . 4)
    (indent-tabs-mode . nil)
    (c-comment-only-line-offset . 0)
    (c-offsets-alist . (
                        (inexpr-class . +)
                        (inexpr-statement . +)
                        (lambda-intro-cont . +)
                        (inlambda . c-lineup-inexpr-block)
                        (template-args-cont c-lineup-template-args +)
                        (incomposition . +)
                        (inmodule . +)
                        (innamespace . +)
                        (inextern-lang . +)
                        (composition-close . 0)
                        (module-close . 0)
                        (namespace-close . 0)
                        (extern-lang-close . 0)
                        (composition-open . 0)
                        (module-open . 0)
                        (namespace-open . 0)
                        (extern-lang-open . 0)
                        (objc-method-call-cont c-lineup-ObjC-method-call-colons c-lineup-ObjC-method-call +)
                        (objc-method-args-cont . c-lineup-ObjC-method-args)
                        (objc-method-intro .
                                           [0])
                        (friend . 0)
                        (cpp-define-intro c-lineup-cpp-define +)
                        (cpp-macro-cont . +)
                        (cpp-macro .
                                   [0])
                        (inclass . +)
                        (stream-op . c-lineup-streamop)
                        (arglist-cont-nonempty c-lineup-arglist)
                        ;(arglist-cont-nonempty . c-lineup-under-anchor)
                        (arglist-cont c-lineup-gcc-asm-reg 0)
                        (comment-intro . 0)
                        (catch-clause . 0)
                        (else-clause . 0)
                        (do-while-closure . 0)
                        (access-label . /)
                        (case-label . 0)
                        (substatement . +)
                        (statement-case-intro . +)
                        (statement . 0)
                        (brace-entry-open . 0)
                        (brace-list-open . c-lineup-under-anchor)
                        (brace-list-entry . c-lineup-under-anchor)
                        (brace-list-close . 0)
                        (brace-list-intro . +)
                        (block-close . 0)
                        (block-open . 0)
                        (inher-cont . c-lineup-multi-inher)
                        (inher-intro . ++)
                        (member-init-cont . c-lineup-multi-inher)
                        (member-init-intro . +)
                        (annotation-var-cont . +)
                        (annotation-top-cont . 0)
                        (topmost-intro . 0)
                        (knr-argdecl . 0)
                        (func-decl-cont . ++)
                        (inline-close . 0)
                        (class-close . 0)
                        (class-open . 0)
                        (defun-block-intro . +)
                        (defun-close . 0)
                        (defun-open . 0)
                        (c . c-lineup-C-comments)
                        (string . c-lineup-dont-change)
                        (topmost-intro-cont . c-lineup-topmost-intro-cont)
                        (inline-open . 0)
                        (arglist-close . c-lineup-arglist)
                        (arglist-intro . google-c-lineup-expression-plus-4)
                        (statement-cont nil c-align-statement-cont)
                        (statement-case-open . +)
                        (label . /)
                        (substatement-label . 2)
                        (substatement-open . c-lineup-under-anchor)
                        (knr-argdecl-intro . +)
                        (statement-block-intro . +)
                        )
                     ))
  
  "CB Programming Style.")

(defun cb-set-c-style ()
  "Set the current buffer's c-style to Google C/C++ Programming
  Style. Meant to be added to `c-mode-common-hook'."
  (interactive)
  (make-local-variable 'c-tab-always-indent)
  (setq c-tab-always-indent t)
  (c-add-style "CB" cb-c-style t))

(provide 'cb-c-style)

(add-hook 'c-mode-common-hook 'cb-set-c-style)

(defun indent-buffer ()
  (interactive)
  (save-excursion
    (c-indent-region (point-min) (point-max))))


(global-set-key (kbd "M-b") 'indent-buffer)
