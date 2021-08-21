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
(use-package counsel
  :init
  (setq ivy-use-virtual-buffers t)
  (setq ivy-count-format "(%d/%d) ")
  :config (ivy-mode 1))
(use-package flycheck
  :config (global-flycheck-mode))		;; all buffers use flycheck mode
(use-package ripgrep
  :bind ("C-c r" . ripgrep-regexp))		;; quick, easy to use keybinding for ripgrep
(use-package exec-path-from-shell		;; environment variables are the same between emacs and your shell
  :config (exec-path-from-shell-initialize))	;; sets $MANPATH, $PATH, and exec-path from your shell
(use-package yaml-mode)
(use-package terraform-mode)                    ;; install terraform mode
(use-package typescript-mode)                   ;; install typescript mode

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

;; counsel/ivy keybindings
(global-set-key (kbd "C-s") 'swiper-isearch)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)
(global-set-key (kbd "M-y") 'counsel-yank-pop)
(global-set-key (kbd "<f1> f") 'counsel-describe-function)
(global-set-key (kbd "<f1> v") 'counsel-describe-variable)
(global-set-key (kbd "<f1> l") 'counsel-find-library)
(global-set-key (kbd "<f2> i") 'counsel-info-lookup-symbol)
(global-set-key (kbd "<f2> u") 'counsel-unicode-char)
(global-set-key (kbd "<f2> j") 'counsel-set-variable)
(global-set-key (kbd "C-x b") 'ivy-switch-buffer)
(global-set-key (kbd "C-c v") 'ivy-push-view)
(global-set-key (kbd "C-c V") 'ivy-pop-view)
(global-set-key (kbd "C-c c") 'counsel-compile)
(global-set-key (kbd "C-c g") 'counsel-git)
(global-set-key (kbd "C-c j") 'counsel-git-grep)
(global-set-key (kbd "C-c L") 'counsel-git-log)
(global-set-key (kbd "C-c k") 'counsel-rg)
(global-set-key (kbd "C-c m") 'counsel-linux-app)
(global-set-key (kbd "C-c n") 'counsel-fzf)
(global-set-key (kbd "C-x l") 'counsel-locate)
(global-set-key (kbd "C-c J") 'counsel-file-jump)
(global-set-key (kbd "C-S-o") 'counsel-rhythmbox)
(global-set-key (kbd "C-c w") 'counsel-wmctrl)

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
(setq create-lockfiles nil)                     ;; disables lockfile (*#*) creation
(setq make-backup-files nil)                    ;; disables backup file creation
(fset 'yes-or-no-p 'y-or-n-p)                   ;; replace yes/no prompts with y/n
(add-to-list 'safe-local-variable-values
             '(haskell-hoogle-command "stack hoogle --"))
;; (add-to-list 'safe-local-variable-values
;; 	     '(haskell-hoogle-server-command . "(lambda (port) (list \"stack\" \"hoogle\" \"--\" \"server\" \"--local\" \"-p\" (number-to-string port))))"))

(add-hook 'before-save-hook
          'delete-trailing-whitespace)  ;; deletes trailing whitespace on save

(setq backup-directory-alist
      `(("." . ,(concat user-emacs-directory "backups")))) ;; put all backups (~ files) into ~/.emacs.d/backups/

;; custom elisp files
(load "~/.emacs.d/elisp/haskell-init.el")

(provide 'init)
;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-safe-themes
   '("2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" default))
 '(package-selected-packages
   '(typescript-mode counsel ivy terraform-mode dash-at-point ormolu lsp-ui lsp-haskell lsp-mode flycheck-haskell yaml-mode exec-path-from-shell ripgrep flycheck helm company solarized-theme use-package))
 '(safe-local-variable-values
   '((haskell-hoogle-url . "http://localhost:8123/?hoogle=%s")
     (ormolu-process-path . "fourmolu")
     (lsp-haskell-formatting-provider . "fourmolu")
     (haskell-stylish-on-save)
     (haskell-process-type . stack-ghci)
     (haskell-indentation-starter-offset . 4)
     (haskell-indentation-left-offset . 4)
     (haskell-indentation-layout-offset . 4)
     (web-mode-code-indent-offset . 2)
     (web-mode-css-indent-offset . 2)
     (web-mode-markup-indent-offset . 2))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
