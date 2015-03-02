;;
;; PACKAGE: sr-speedbar
;;
;; NOTE: configuration for speedbar

(require 'sr-speedbar)

;; global key to toggle speedbar
(global-set-key (kbd "C-x C-a") 'sr-speedbar-toggle)

;; configuration
(setq speedbar-show-unknown-files t)
(setq sr-speedbar-skip-other-window-p t)
(setq sr-speedbar-auto-refresh t)
(setq sr-speedbar-right-side nil)
