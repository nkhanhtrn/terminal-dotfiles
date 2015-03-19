;   
; PACKAGE: webmode
;
; NOTE
(setq web-mode-enable-current-element-highlight t)
(setq web-mode-enable-current-column-highlight t)

(require 'web-mode)

; apply mode for these extensions
(add-to-list 'auto-mode-alist '("\\.html" . web-mode))
(add-to-list 'auto-mode-alist '("\\.php" . web-mode))
(add-to-list 'auto-mode-alist '("\\.json" . web-mode))

; indentation
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 4)
(setq web-mode-style-padding 1)
(setq web-mode-script-padding 1)
(setq web-mode-block-padding 0)

; other features
(setq web-mode-comment-style 2)
(setq web-mode-enable-auto-pairing t)
(setq web-mode-enable-css-colorization t)

; autocomplete
(setq web-mode-ac-sources-alist
      '(("css" . (ac-source-css-property))
        ("html" . (ac-source-words-in-buffer ac-source-abbrev))))
