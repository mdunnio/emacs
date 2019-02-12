;; ~/.emacs.d/elisp/haskell-intero-init.el
;; Luke Hoersten <Luke@Hoersten.org>

;;; Code:

;; Require packages
(require 'package-require)
(package-require '(haskell-mode intero yasnippet haskell-snippets flycheck company))

(require 'intero)
(require 'haskell)
(require 'haskell-mode)
(require 'haskell-interactive-mode)
(require 'haskell-snippets)
(require 'company)

(add-hook 'haskell-mode-hook 'intero-mode)

(define-key intero-mode-map (kbd "C-]") 'find-tag )

(setq
 haskell-stylish-on-save t
 haskell-indentation-layout-offset 4
 haskell-indentation-left-offset 4

 haskell-notify-p t
 haskell-align-imports-pad-after-name t
 haskell-ask-also-kill-buffers nil
 haskell-import-mapping t

 haskell-interactive-mode-eval-pretty t
 haskell-interactive-mode-scroll-to-bottom t
 haskell-interactive-mode-eval-mode 'haskell-mode
 haskell-interactive-popup-errors nil)

(flycheck-add-next-checker 'intero '(warning . haskell-hlint))

(autoload 'dash-at-point "dash-at-point" "Search the word at point with Dash." t nil)
(global-set-key (kbd "C-c d") 'dash-at-point)
(global-set-key (kbd "C-c e") 'dash-at-point-with-docset)

(message "Loading haskell-init...done")
(provide 'haskell-intero-init)
