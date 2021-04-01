;;; package -- Summary
;;; Commentary:

;;; author: Michael Dunn <michaelsdunn1@gmail.com>

;;; Code:

;; melpa
(require 'package)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)
(package-initialize)

;; use-package initialization
(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-when-compile
  (require 'use-package))
(setq use-package-always-ensure t) ;; sets ':ensure t' on all use-package calls

;; packages
(use-package solarized-theme)
(use-package company
  :config (global-company-mode))		;; all buffers use company mode
(use-package helm
  :config (helm-mode 1)				;; start helm mode automatically
  :bind
  ("M-x" . helm-M-x)				;; use helm for all M-x commands
  ("C-x C-f" . helm-find-files)                 ;; use helm for finding files
  ("C-x C-l" . helm-locate))                    ;; use helm for file fuzzy match search
(use-package flycheck
  :config (global-flycheck-mode))		;; all buffers use flycheck mode
(use-package ripgrep
  :bind ("C-c r" . ripgrep-regexp))		;; quick, easy to use keybinding for ripgrep
(use-package exec-path-from-shell		;; environment variables are the same between emacs and your shell
  :config (exec-path-from-shell-initialize))	;; sets $MANPATH, $PATH, and exec-path from your shell
(use-package yaml-mode)

;; keyboard customizations
(setq is-mac (equal system-type 'darwin))	;; sets is-mac to true of macos
(when is-mac
  (setq-default
   mac-command-modifier 'meta			;; changes the meta key from ESC to COMMAND on macos
   ring-bell-function 'ignore                   ;; turn off bell
   )
  (use-package dash-at-point                    ;; use dash-at-point package when on macos
    :bind("C-c d" . dash-at-point))             ;; binds C-c d to open dash
  )
(global-set-key (kbd "C-c a") 'align-regexp)	;; bind align-regexp to C-c a
(global-set-key (kbd "C-x C-b") 'ibuffer)	;; uses ibuffer

(global-set-key (kbd "C-x <up>") 'windmove-up)		;; allows arrow-key window movement
(global-set-key (kbd "C-x <down>") 'windmove-down)	;; allows arrow-key window movement
(global-set-key (kbd "C-x <left>") 'windmove-left)	;; allows arrow-key window movement
(global-set-key (kbd "C-x <right>") 'windmove-right)	;; allows arrow-key window movement

;; completely optional customization
(load-theme `solarized-dark t)			;; turn on solarized-dark by default
(set-default `truncate-lines t)			;; disable line-wrap
(set-frame-font "Monospace-10")			;; use monospace-10 as default font
(menu-bar-mode -1)				;; remove menu bar
(toggle-scroll-bar -1)				;; remove scroll bar
(tool-bar-mode -1)				;; remove tool bar
(setq inhibit-startup-screen t)			;; remove startup screen
(global-display-line-numbers-mode)		;; display line numbers on left side
(show-paren-mode 1)				;; highlight matching pairs of parens
(electric-pair-mode)				;; enables auto-pair characters (example, creates groups of brackets automatically)

(add-hook 'before-save-hook
          'delete-trailing-whitespace)  ;; deletes trailing whitespace on save

(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups")))) ;; put all backups (~ files) into ~/.emacs.d/backups/

;; custom elisp files
(load "~/.emacs.d/elisp/haskell-init.el")

(provide 'init)
;;; init.el ends here
