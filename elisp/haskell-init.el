;;; package -- Summary
;;; Commentary:

;;; Code:

;; packages
(use-package flycheck-haskell :ensure t)
(use-package haskell-mode
  :ensure t
  :config
  (setq haskell-stylish-on-save t)
  (setq haskell-tags-on-save t)
  (setq haskell-compile-stack-build-command "stack build --fast -j4 --no-interleaved-output") ;; idk why this warns, it works
  :bind
  ("C-c C-c" . haskell-compile)
  ("M-." . xref-find-definitions)
  :hook
  (haskell-mode . haskell-decl-scan-mode)
  (haskell-mode . haskell-doc-mode)
  (haskell-mode . haskell-indentation-mode)
  (flycheck-haskell-setup))

(use-package lsp-mode
  :ensure t
  :hook
  (haskell-mode . lsp)
  :commands lsp)
(use-package lsp-ui :ensure t)
(add-hook 'lsp-ui-doc-frame-hook ;; changes the font size of the lsp-doc-frame
          (lambda (frame _w)
            (set-face-attribute 'default frame :font "Monospace-10")))
(use-package lsp-haskell
  :ensure t)

(provide 'haskell-init)
;;; haskell-init.el ends here
