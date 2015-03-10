;;
;; PACKAGE: smartparens
;;
;; NOTE:

(require 'smartparens-config)
(show-smartparens-global-mode +1)
(smartparens-global-mode 1)

; add new line in curly braces
(sp-with-modes '(c-mode c++-mode)
  (sp-local-pair "{" nil :post-handlers '(("||\n[i]" "RET")))
  (sp-local-pair "/*" "*/" :post-handlers '((" | " "SPC")
                                            ("* ||\n[i]" "RET"))))
