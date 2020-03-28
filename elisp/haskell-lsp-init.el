;;; package -- Summary

(require 'company)
(require 'align)
(require 'haskell)
(require 'haskell-mode)
(require 'haskell-compile)
(require 'haskell-process)
(require 'haskell-interactive-mode)
(require 'flycheck)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(setq use-package-always-ensure t)
(use-package diminish) ; for use with use-package

(use-package company-lsp
  :ensure t
  :commands company-lsp)

(defun haskell-company-backends ()
  (set (make-local-variable 'company-backends)
                   (append '((company-lsp company-capf company-dabbrev-code))
                           company-backends)))

(defun stack-compile-command ()
  (interactive)
  (setq compile-command "stack build -j4 --test --bench --no-run-tests --no-run-benchmarks --no-interleaved-output"))

(use-package haskell-mode
  :hook ((haskell-mode . interactive-haskell-mode)
         (haskell-mode . haskell-indentation-mode)
         (haskell-mode . haskell-decl-scan-mode)
         (haskell-mode . haskell-company-backends)
         (haskell-mode . stack-compile-command)
         (haskell-mode . yas-minor-mode)
         (haskell-cabal-mode . stack-compile-command))

  :bind (("C-c C-t" . haskell-mode-show-type-at)
         ("C-]" . haskell-mode-jump-to-def-or-tag)
         ("C-c C-l" . haskell-process-load-file)
         ("C-`" . haskell-interactive-bring)
         ;; ("C-c C-t" . haskell-process-do-type)
         ("C-c C-i" . haskell-process-do-info)
         ("C-c C-k" . haskell-interactive-mode-clear)
         ("C-c C-r" . haskell-process-restart)
         ("C-c C" . haskell-process-cabal-build)
         ("M-n" . haskell-goto-next-error)
         ("M-p" . haskell-goto-prev-error)
         ("C-c M-p" . haskell-goto-prev-error)
         :map haskell-cabal-mode-map
         ("C-c C-c" . haskell-compile)
         ("C-`" . haskell-interactive-bring)
         ("C-c C-k" . haskell-interactive-mode-clear)
         ("C-c C" . haskell-process-cabal-build))

  :config
  (setq haskell-stylish-on-save t

        haskell-interactive-set-+c t

        haskell-indentation-layout-offset 4
        haskell-indentation-left-offset 4

        haskell-compile-cabal-build-command "stack build -j4 --test --bench --no-run-tests --no-run-benchmarks --no-interleaved-output"
        haskell-compile-cabal-build-alt-command (concat "stack clean && " haskell-compile-cabal-build-command)

        haskell-process-type 'stack-ghci
        haskell-process-suggest-remove-import-lines t
        haskell-process-suggest-hoogle-imports t
        haskell-process-auto-import-loaded-modules t
        haskell-process-log t

        haskell-notify-p t
        haskell-align-imports-pad-after-name t
        haskell-ask-also-kill-buffers nil
        haskell-import-mapping t

        haskell-interactive-mode-eval-pretty t
        haskell-interactive-mode-scroll-to-bottom t
        haskell-interactive-mode-eval-mode 'haskell-mode
        haskell-interactive-popup-errors t)

  (eval-after-load "align"
    '(add-to-list 'align-rules-list
                  '(haskell-types
                    (regexp . "\\(\\s-+\\)\\(::\\|∷\\)\\s-+")
                    (modes quote (haskell-mode literate-haskell-mode)))))
  (eval-after-load "align"
    '(add-to-list 'align-rules-list
                  '(haskell-assignment
                    (regexp . "\\(\\s-+\\)=\\s-+")
                    (modes quote (haskell-mode literate-haskell-mode)))))
  (eval-after-load "align"
    '(add-to-list 'align-rules-list
                  '(haskell-arrows
                    (regexp . "\\(\\s-+\\)\\(->\\|→\\)\\s-+")
                    (modes quote (haskell-mode literate-haskell-mode)))))
  (eval-after-load "align"
    '(add-to-list 'align-rules-list
                  '(haskell-left-arrows
                    (regexp . "\\(\\s-+\\)\\(<-\\|←\\)\\s-+")
                    (modes quote (haskell-mode literate-haskell-mode)))))

)


(use-package lsp-mode
  :hook
  (haskell-mode . lsp)
  :ensure t
  :commands lsp
  :config
  (setq lsp-auto-configure t
        lsp-eldoc-render-all nil
        lsp-diagnostic-package :flycheck
        lsp-enable-xref nil
        lsp-enable-imenu t
        lsp-response-timeout 1))

(use-package lsp-ui
  :ensure t
  :commands lsp-ui-mode
  :config
  (setq warning-minimum-level ':error))

(use-package lsp-haskell
 :ensure t
 :config
 (setq lsp-haskell-process-path-hie "hie-wrapper")

 (use-package lsp-ivy
   :commands lsp-ivy-workspace-symbol)

 ;; (use-package lsp-treemacs
 ;;   :commands lsp-treemacs-errors-list)

 (add-hook 'haskell-mode-hook
            (lambda ()
              (lsp)
              (lsp-flycheck-enable t)
              (lsp-ui-sideline-enable nil)))

 (lsp-haskell-set-liquid-off)
 (lsp-haskell-set-hlint-on))

(message "Loading haskell-lsp-init...")
(provide 'haskell-lsp-init)
