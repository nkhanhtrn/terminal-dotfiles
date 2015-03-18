;
; PACKAGE: auto-complete
;
; NOTE

(require 'auto-complete-config)

(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

(setq ac-use-menu-map t)
;; Default settings
(define-key ac-menu-map "\C-n" 'ac-next)
(define-key ac-menu-map "\C-p" 'ac-previous)

;; style
(set-face-background 'ac-candidate-face "#073642")
(set-face-foreground 'ac-candidate-face "#657b83")
(set-face-background 'ac-selection-face "#002B36")
(set-face-foreground 'ac-selection-face "#93A1A1")
(set-face-background 'ac-completion-face "#002B36")
(set-face-foreground 'ac-completion-face "#93A1A1")
