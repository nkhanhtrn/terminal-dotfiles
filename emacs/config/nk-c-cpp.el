;;
;; PACKAGE: function-args
;;
;; NOTE:

; function arguments
(require 'function-args)
(fa-config-default)
;(define-key c-mode-map  [(contrl tab)] 'moo-complete)
;(define-key c++-mode-map  [(control tab)] 'moo-complete)
;(define-key c-mode-map (kbd "M-o") 'fa-show)
;(define-key c++-mode-map (kbd "M-o") 'fa-show)

;; semantic
(require 'cc-mode)
(require 'semantic)

(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(semantic-add-system-include "/usr/include/boost")

(semantic-mode 1)

(require 'ede)
(global-ede-mode)


