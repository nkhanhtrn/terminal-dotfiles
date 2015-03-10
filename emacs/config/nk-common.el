;;
;; NOTE: misc configurations
;;

(setq-default case-fold-search t)
(set-language-environment "UTF-8")
(setq backup-directory-alist
          `((".*" . ,temporary-file-directory)))
    (setq auto-save-file-name-transforms
          `((".*" ,temporary-file-directory t)))
(tool-bar-mode 0)
(menu-bar-mode 0)
(setq-default indent-tabs-mode nil)
(show-paren-mode t)
(setq evil-move-cursor-back nil)

; remember cursor position
(setq save-place-file "~/.emacs.d/saveplace")
(setq-default save-place t)
(require 'saveplace)

; startup setting
(custom-set-variables
 '(inhibit-startup-screen t)
 '(initial-frame-alist (quote ((fullscreen . maximized)))))

; defaults key binding
(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key (kbd "C-c w") 'whitespace-mode)
(global-set-key (kbd "RET") 'newline-and-indent)

; set indentation by default
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)

; set theme
(setq custom-theme-directory "~/.emacs.d/lib/themes/")
(add-to-list 'custom-theme-load-path custom-theme-directory)
(load-theme 'nk t)

; compilation support
(global-set-key (kbd "<f5>") (lambda ()
                               (interactive)
                               (setq-local compilation-read-command nil)
                               (call-interactively 'compile)))
