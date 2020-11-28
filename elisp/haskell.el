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
  :bind
  ("C-c C-c" . haskell-compile)
  ("M-." . haskell-mode-goto-loc)
  :hook (
	 (haskell-interactive-mode)
	 (haskell-mode)
	 (flycheck-haskell-setup)
	 )
  )

;; TODO: get lsp-mode, etc

(provide 'haskell)
;;; haskell.el ends here
