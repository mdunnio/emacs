;; ~/.emacs.d/init.el (~/.emacs)
;;;; General ;;;;

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(add-to-list 'load-path "~/.emacs.d/elisp")   ; set default emacs load path
(setq auto-save-default nil)                  ; disable auto-save
(setq make-backup-files nil)                  ; clean-up backup files

(setq-default
 gc-cons-threshold 20000000                   ; gc every 20 MB allocated (form flx-ido docs)
 inhibit-splash-screen t                      ; disable splash screen
 truncate-lines t                             ; truncate, not wrap, lines
 indent-tabs-mode nil                         ; only uses spaces for indentation
 split-width-threshold 181                    ; min width to split window horizontially
 split-height-threshold 120                   ; min width to split window vertically
 reb-re-syntax 'string                        ; use string syntax for regexp builder
 require-final-newline 'visit-save)

(put 'set-goal-column 'disabled nil)          ; enable goal column setting
(put 'narrow-to-region 'disabled nil)         ; enable hiding
(put 'narrow-to-page 'disabled nil)

(fset 'yes-or-no-p 'y-or-n-p)                 ; replace yes/no prompts with y/n
(windmove-default-keybindings)                ; move between windows with shift-arrow

(column-number-mode t)                        ; show column numbers
(delete-selection-mode t)                     ; replace highlighted text
(which-function-mode t)                       ; function name at point in mode line
(transient-mark-mode t)                       ; highlight selection between point and mark
(electric-pair-mode t)                        ; automatically close opening characters
(global-font-lock-mode t)                     ; syntax highlighting
(global-subword-mode t)                       ; move by camelCase words
(global-hl-line-mode t)                       ; highlight current line
(global-set-key (kbd "C-c c") 'compile)       ; compile
(global-set-key (kbd "C-c r") 'recompile)     ; recompile
(global-set-key (kbd "C-c a") 'align-regexp)  ; align
(global-set-key (kbd "C-c g") 'rgrep)         ; grep
(global-linum-mode t)                         ; global linum mode


;;; ediff
(setq-default
  ediff-split-window-function 'split-window-horizontally
  ediff-window-setup-function 'ediff-setup-windows-plain)


;;; Darwin
(setq is-mac (equal system-type 'darwin))
(when is-mac
  (setq-default
   ring-bell-function 'ignore
   mac-command-modifier 'meta
   ns-pop-up-frames nil
   ispell-program-name "/usr/local/bin/aspell"))


;;; Xorg
(when window-system
  (tool-bar-mode -1)                          ; remove tool bar
  (scroll-bar-mode -1)                        ; remove scroll bar
  (unless is-mac (menu-bar-mode -1))          ; remove menu bar
  (set-frame-font (if is-mac "Inconsolata-12" "Ubuntu Mono-10.5") nil t))


;;;; Packages ;;;;

(require 'package-require)
(package-require '(company exec-path-from-shell expand-region flx-ido
 smex markdown-mode markdown-mode+ hgignore-mode move-text paredit
 rainbow-delimiters rainbow-mode json-mode json-reformat flycheck
 solarized-theme terraform-mode visual-regexp yasnippet yaml-mode
 zencoding-mode ediff))


;;; custom requires
(require 'init-ivy)
;; (require 'haskell-intero-init)
(require 'haskell-lsp-init)
(require 'javascript-init)
(require 'c-init)
(require 'ansible-init)
;;(require 'hg-init)


;;; text-mode
(add-hook 'fundamental-mode-hook 'flyspell-mode)      ; spellcheck text
(add-hook 'fundamental-mode-hook 'turn-on-auto-fill)  ; autofill text


;;; whitespace-mode
(global-whitespace-mode t)                            ; show whitespace
(add-hook 'before-save-hook 'whitespace-cleanup)      ; cleanup whitespace on exit
(setq-default
 whitespace-line-column 120                           ; column width
 whitespace-style                                     ; whitespace to highlight
 '(trailing lines-tail empty indentation
            space-before-tab space-after-tab))


;;; org-mode
(add-hook
 'org-mode-hook
 (lambda ()
   (local-set-key (kbd "M-p") 'org-move-item-up)
   (local-set-key (kbd "M-S-p") 'org-move-subtree-up)
   (local-set-key (kbd "M-n") 'org-move-item-down)
   (local-set-key (kbd "M-S-n") 'org-move-subtree-down)))


;;; ibuffer
(global-set-key (kbd "C-x C-b") 'ibuffer)             ; better buffer browser
(require 'ibuffer)
(require 'ibuf-ext)
(defun ibuffer-generate-filter-groups-by-major-mode ()
  (flet
      ((mode-group
        (mode)
        (let ((mode-title
               (capitalize (car (split-string (symbol-name mode) "-" t)))))
          (cons mode-title `((mode . ,mode)))))
       (buffer-modes
        ()
        (flet ((buffer-mode (buffer) (buffer-local-value 'major-mode buffer)))
          (ibuffer-remove-duplicates (remq nil (mapcar 'buffer-mode (buffer-list)))))))
    (mapcar 'mode-group (buffer-modes))))

(defun ibuffer-major-mode-group-hook ()
  (interactive)
  (setq ibuffer-filter-groups (ibuffer-generate-filter-groups-by-major-mode))
  (ibuffer-update nil t)
  (message "ibuffer-major-mode: groups set"))

(setq-default ibuffer-show-empty-filter-groups nil)
(add-hook 'ibuffer-hook (lambda () (ibuffer-major-mode-group-hook)))


;;; shell
(global-set-key (kbd "C-c s") 'eshell)  ; start shell
(exec-path-from-shell-copy-env "PYTHONPATH")
(exec-path-from-shell-initialize)
(eshell)
(add-hook 'eshell-mode-hook (lambda () (setenv "TERM" "emacs")))


;;; ido / smex / completion

(setq-default
 ido-enable-flex-matching t                           ; fuzzy matching for ido mode
 ido-create-new-buffer 'always                        ; create new buffer without prompt
 ido-max-window-height 1                              ; max ido window height
 ido-everywhere t                                     ; use ido where possible
 ido-use-faces nil)
(ido-mode t)                                          ; file/buffer selector
(flx-ido-mode t)
(global-set-key (kbd "M-/") 'completion-at-point)
;; (global-set-key (kbd "M-x") 'smex)
;; (global-set-key (kbd "M-X") 'smex-major-mode-commands)


;;; emacs-lisp-mode
(add-hook 'emacs-lisp-mode-hook 'enable-paredit-mode)


;;; company-mode
(global-company-mode t)
(global-set-key (kbd "M-/") 'company-complete)
(setq-default
 company-idle-delay nil
 company-minimum-prefix-length 2
 company-selection-wrap-around t
 company-show-numbers t
 company-tooltip-align-annotations t)

;;;
(add-hook 'find-file-hook 'linum-mode)


;;; flycheck-mode
(global-flycheck-mode t)
;; (flycheck-add-next-checker 'intero '(warning . haskell-hlint))


;;; uniquify
(require 'uniquify)                     ; unique buffer names with dirs
(setq
 uniquify-buffer-name-style 'post-forward
 uniquify-separator ":")


;;; color-theme
(setq-default
 custom-safe-themes
 '("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4"
   "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default))
(when window-system (load-theme 'solarized-dark))


;;; show-paren-mode - needs to be loaded after theme
(setq-default
 show-paren-style 'expression
 show-paren-delay 0)
(set-face-attribute
 'show-paren-match nil
 :background (face-background 'highlight)
 :foreground (face-foreground 'highlight))
(show-paren-mode t)


;;; yasnippets
(with-eval-after-load 'yasnippet
  (setq yas-snippet-dirs (remq 'yas-installed-snippets-dir yas-snippet-dirs)))
(setq-default yas-prompt-functions '(yas-ido-prompt yas-dropdown-prompt)) ; use ido for multiple snippets
(yas-global-mode t)


;;; markdown-mode
(add-hook 'markdown-mode-hook 'flyspell-mode)
(setq-default markdown-command "pandoc -f markdown_github")


;;; html-mode
(add-to-list 'auto-mode-alist '("\\.tpl\\'" . html-mode))
(add-hook 'html-mode-hook 'zencoding-mode)


;;; color-modes map
(mapc
 (lambda (x)
   (add-hook x
    (lambda ()
      (rainbow-mode t)
      (linum-mode t)
      (rainbow-delimiters-mode t))))
 '(text-mode-hook
   c-mode-common-hook
   python-mode-hook
   haskell-mode-hook
   js2-mode-hook
   html-mode-hook
   css-mode-hook
   sass-mode-hook
   clojure-mode-hook
   emacs-lisp-mode-hook
   conf-mode-hook
   yaml-mode-hook))


;;; expand-region
(global-set-key (kbd "C-=") 'er/expand-region)


;;; move-text
(global-set-key (kbd "M-p") 'move-text-up)
(global-set-key (kbd "M-n") 'move-text-down)


;;; Compilation

;; (global-set-key (kbd "C-c C-c") 'compile)
;; (global-set-key (kbd "C-c r") 'recompile)
(global-set-key (kbd "M-g M-f") 'first-error)

(setq compilation-scroll-output t)
(add-to-list 'display-buffer-alist
             '("\\*compilation\\*"
               display-buffer-at-bottom
               display-buffer-pop-up-window
               display-buffer-reuse-window
               (window-height . 18)))
(defun bury-compile-buffer-if-successful (buffer string)
  "Bury a compilation buffer if succeeded without warnings "
  (if (and
       (string-match "compilation" (buffer-name buffer))
       (string-match "finished" string)
       (not
        (with-current-buffer buffer
          (goto-char (point-min))
          (search-forward "warning" nil t))))
      (run-with-timer 1 nil
                      (lambda (buf)
                        (bury-buffer buf)
                        (delete-window (get-buffer-window buf)))
                      buffer)))
(add-hook 'compilation-finish-functions 'bury-compile-buffer-if-successful)

;;; dash integration
(autoload 'dash-at-point "dash-at-point" "Search the word at point with Dash." t nil)
(global-set-key (kbd "C-c d") 'dash-at-point)
(global-set-key (kbd "C-c e") 'dash-at-point-with-docset)

;;; visual-regexp
(global-set-key (kbd "C-M-%") 'vr/query-replace)
(global-set-key (kbd "M-%") 'vr/replace)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#657b83"])
 '(compilation-message-face (quote default))
 '(cua-global-mark-cursor-color "#2aa198")
 '(cua-normal-cursor-color "#839496")
 '(cua-overwrite-cursor-color "#b58900")
 '(cua-read-only-cursor-color "#859900")
 '(custom-safe-themes
   (quote
    ("c433c87bd4b64b8ba9890e8ed64597ea0f8eb0396f4c9a9e01bd20a04d15d358" "2809bcb77ad21312897b541134981282dc455ccd7c14d74cc333b6e549b824f3" "8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" "d677ef584c6dfc0697901a44b885cc18e206f05114c8a3b7fde674fce6180879" default)))
 '(debug-on-error nil)
 '(fci-rule-color "#073642")
 '(highlight-changes-colors (quote ("#d33682" "#6c71c4")))
 '(highlight-symbol-colors
   (quote
    ("#3b6b40f432d6" "#07b9463c4d36" "#47a3341e358a" "#1d873c3f56d5" "#2d86441c3361" "#43b7362d3199" "#061d417f59d7")))
 '(highlight-symbol-foreground-color "#93a1a1")
 '(highlight-tail-colors
   (quote
    (("#073642" . 0)
     ("#5b7300" . 20)
     ("#007d76" . 30)
     ("#0061a8" . 50)
     ("#866300" . 60)
     ("#992700" . 70)
     ("#a00559" . 85)
     ("#073642" . 100))))
 '(hl-bg-colors
   (quote
    ("#866300" "#992700" "#a7020a" "#a00559" "#243e9b" "#0061a8" "#007d76" "#5b7300")))
 '(hl-fg-colors
   (quote
    ("#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36" "#002b36")))
 '(hl-paren-colors (quote ("#2aa198" "#b58900" "#268bd2" "#6c71c4" "#859900")))
 '(lsp-ui-doc-border "#93a1a1")
 '(nrepl-message-colors
   (quote
    ("#dc322f" "#cb4b16" "#b58900" "#5b7300" "#b3c34d" "#0061a8" "#2aa198" "#d33682" "#6c71c4")))
 '(package-selected-packages
   (quote
    (flycheck-haskell imenu-anywhere imenu-list imenus lsp-treemacs lsp-ivy ivy-xref flx counsel-tramp counsel-projectile counsel ivy diminish use-package lsp-mode lsp-ui lsp-haskell company-lsp monky dash-at-point ## ag ansible-doc company-ansible jinja2-mode ac-js2 auto-complete haskell-snippets haskell-mode zencoding-mode yaml-mode yasnippet visual-regexp terraform-mode solarized-theme flycheck json-mode rainbow-mode rainbow-delimiters paredit move-text hgignore-mode markdown-mode+ markdown-mode smex flx-ido expand-region exec-path-from-shell company)))
 '(pos-tip-background-color "#073642")
 '(pos-tip-foreground-color "#93a1a1")
 '(smartrep-mode-line-active-bg (solarized-color-blend "#859900" "#073642" 0.2))
 '(term-default-bg-color "#002b36")
 '(term-default-fg-color "#839496")
 '(vc-annotate-background nil)
 '(vc-annotate-background-mode nil)
 '(vc-annotate-color-map
   (quote
    ((20 . "#dc322f")
     (40 . "#cb4366eb20b4")
     (60 . "#c1167942154f")
     (80 . "#b58900")
     (100 . "#a6ae8f7c0000")
     (120 . "#9ed892380000")
     (140 . "#96be94cf0000")
     (160 . "#8e5397440000")
     (180 . "#859900")
     (200 . "#77679bfc4635")
     (220 . "#6d449d465bfd")
     (240 . "#5fc09ea47092")
     (260 . "#4c68a01784aa")
     (280 . "#2aa198")
     (300 . "#303498e7affc")
     (320 . "#2fa1947cbb9b")
     (340 . "#2c879008c736")
     (360 . "#268bd2"))))
 '(vc-annotate-very-old-color nil)
 '(weechat-color-list
   (quote
    (unspecified "#002b36" "#073642" "#a7020a" "#dc322f" "#5b7300" "#859900" "#866300" "#b58900" "#0061a8" "#268bd2" "#a00559" "#d33682" "#007d76" "#2aa198" "#839496" "#657b83")))
 '(xterm-color-names
   ["#073642" "#dc322f" "#859900" "#b58900" "#268bd2" "#d33682" "#2aa198" "#eee8d5"])
 '(xterm-color-names-bright
   ["#002b36" "#cb4b16" "#586e75" "#657b83" "#839496" "#6c71c4" "#93a1a1" "#fdf6e3"]))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(require 'org-table)
(defun md-table-align ()
  (interactive)
  (org-table-align)
  (save-excursion
    (goto-char (point-min))
    (while (search-forward "-+-" nil t) (replace-match "-|-"))))
