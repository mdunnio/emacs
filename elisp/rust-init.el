;; ~/.emacs.d/elisp/rust-init.el
;; Michael Dunn <michaelsdunn1@gmail.com>

;;; Code:

;; Require packages
(require 'package-require)
(package-require '(rust-mode cargo flycheck-rust))

(add-hook 'rust-mode-hook 'cargo-minor-mode)
(add-hook 'flycheck-mode-hook #'flycheck-rust-setup)

(setq racer-cmd "~/.cargo/bin/racer") ;; Rustup binaries PATH
(setq racer-rust-src-path "/Users/mdunn/Code/rust/src") ;; Rust source code PATH

(with-eval-after-load 'rust-mode
  (add-hook 'flycheck-mode-hook #'flycheck-rust-setup))

(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)

(message "Loading rust-init...done")
(provide 'rust-init)
