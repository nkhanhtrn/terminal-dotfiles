; ================================================================
; misc settings
(setq user-mail-address "nkhanhtran@cogini.com")
(setq-default case-fold-search t)
(set-language-environment "UTF-8")
(setq backup-directory-alist
          `((".*" . ,temporary-file-directory)))
    (setq auto-save-file-name-transforms
          `((".*" ,temporary-file-directory t)))
(tool-bar-mode 0)
(menu-bar-mode 0)


; ================================================================
; package manager
(require 'package)
(dolist (source '(("marmalade" . "http://marmalade-repo.org/packages/")
                  ("elpa" . "http://tromey.com/elpa/")
                  ("melpa" . "http://melpa.milkbox.net/packages/")
                  ))
  (add-to-list 'package-archives source t))
(package-initialize)


; ================================================================
; autoload packages at start
(when (not package-archive-contents)
  (package-refresh-contents))
(defvar nkhanhtran/elpa-packages
    ; evil-mode
  '(evil
    ; powerline
    powerline
    powerline-evil
    ; Color theme
    color-theme
    color-theme-solarized))
(dolist (p nkhanhtran/elpa-packages)
  (when (not (package-installed-p p))
    (package-install p)))


; ================================================================
; solarized
;(load-theme 'solarized-dark t)
(load-theme 'solarized-dark t)


; ================================================================
; evil-mode
(require 'evil)
(evil-mode 1)


; ================================================================
; powerline
(require 'powerline)
(powerline-default-theme)
