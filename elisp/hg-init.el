;; ~/.emacs.d/elisp/hg-init.el
;; Michael Dunn <michaelsdunn1@gmail.com>

(require 'monky)

;; By default monky spawns a seperate hg process for every command.
;; This will be slow if the repo contains lot of changes.
;; if `monky-process-type' is set to cmdserver then monky will spawn a single
;; cmdserver and communicate over pipe.
;; Available only on mercurial versions 1.9 or higher

(setq monky-process-type 'cmdserver)


(setq eshell-visual-subcommands
      '(("hg" "diff" "log" "glog")))
