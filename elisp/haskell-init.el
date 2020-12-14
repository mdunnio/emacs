;;; package -- Summary
;;; Commentary:

;;; Code:

;; packages
(use-package flycheck-haskell)			;; flycheck for haskell
(use-package haskell-mode                       ;; haskell major mode
  :config
  (setq haskell-stylish-on-save nil)		;; run stylish haskell on save
  (setq haskell-tags-on-save t)			;; create tags on save
  :bind
  ("C-c C-c" . haskell-compile)			;; set compile command
  ("M-." . xref-find-definitions)		;; convenient binding for jumping to definition
  :hook
  (haskell-mode . haskell-decl-scan-mode)	;; enables minor mode that enables top-level definition movement commands (C-M-a, C-M-e, etc)
  (haskell-mode . haskell-indentation-mode)	;; enables semi-automatic indentation (not compatible with `haskell-indent-mode`)
  (flycheck-haskell-setup))			;; enables flycheck-haskell
(use-package lsp-mode                           ;; provides an IDE-like experience compatible with packages (company, flycheck, etc)
  :hook
  (haskell-mode . lsp))                         ;; enables lsp-mode in haskell-modea
(use-package lsp-haskell)                       ;; lsp-mode extension for use with `haskell-language-server` and `ghcide`)
(use-package lsp-ui :ensure t)                  ;; high-level UI modules of lsp-mode - displays info on sideline, in child-frame doc, etc
(add-hook 'lsp-ui-doc-frame-hook                ;; changes the font size of the lsp-doc-frame
          (lambda (frame _w)
            (set-face-attribute 'default frame :font "Monospace-10")))

(provide 'haskell-init)
;;; haskell-init.el ends here
