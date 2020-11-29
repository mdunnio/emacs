;;; package -- Summary
;;; Commentary:

;;; author: Michael Dunn <michaelsdunn1@gmail.com>

;;; Code:

;; melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; use-package
(eval-when-compile
  (require 'use-package))

;; packages
(use-package solarized-theme :ensure t)
(use-package company :ensure t)
(add-hook 'after-init-hook 'global-company-mode) ;; TODO: get this to work as a normal hook
(use-package helm
  :ensure t
  :config (helm-mode 1)
  :bind
  ("M-x" . helm-M-x)
  ("C-x C-f" . helm-find-files))
(use-package flycheck
  :ensure t
  :config (global-flycheck-mode))
(use-package ripgrep :ensure t)   ;; ag is inadequate
(use-package exec-path-from-shell ;; environment variables are the same between emacs and shell
  :ensure t
  :config (exec-path-from-shell-initialize))

;; customization
(load-theme `solarized-dark t)  ;; turn on solarized-dark by default
(set-default `truncate-lines t) ;; disable line-wrap
(set-frame-font "Monospace-10") ;; use monospace-10 as default font
(menu-bar-mode -1)              ;; remove menu bar
(toggle-scroll-bar -1)          ;; remove scroll bar
(tool-bar-mode -1)              ;; remove tool bar
(setq inhibit-startup-screen t) ;; remove startup screen

;; custom elisp files
(add-to-list `load-path "~/.emacs.d/elisp/")
(load "~/.emacs.d/elisp/haskell-init.el")

;; ---------------- auto-generated ---------------------
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(haskell-stylish-on-save t)
 '(haskell-tags-on-save t)
 '(package-selected-packages
   (quote
    (lsp-ui exec-path-from-shell flycheck-haskell ripgrep flycheck helm company use-package haskell-mode solarized-theme))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(provide 'init)
;;; init.el ends here
