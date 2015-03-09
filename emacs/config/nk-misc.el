;;
;; PACKAGE: misc plugins
;;
;; NOTE:

; PACKAGE: clean-aindent-mode
; Usage: clear whitespace with editing code
(require 'clean-aindent-mode)
(add-hook 'prog-mode-hook 'clean-aindent-mode)

; PACKAGE: dtrt-indent
; Usage: determine where to use Tab and Space
(require 'dtrt-indent)
(dtrt-indent-mode 1)
(setq dtrt-indent-verbosity 0)

; PACKAGE: ws-butler
; Usage: remove noisy whitespace
(require 'ws-butler)
(add-hook 'c-mode-common-hook 'ws-butler-mode)

; PACKAGE: nyan-mode
; Usage: fancy nyan cat
(require 'nyan-mode)
(nyan-mode)
(nyan-start-animation)

; PACKAGE: smooth-scrolling
; Usage: smooth scrolling
(require 'smooth-scrolling)
(setq smooth-scroll-margin 10)
(setq scroll-conservatively 9999
      scroll-preserve-screen-position t)






