; load path
(add-to-list 'load-path "~/.emacs.d/config/")

; ================================================================
; package manager
(require 'package)
(dolist (source '(("marmalade" . "http://marmalade-repo.org/packages/")
                  ("elpa" . "http://tromey.com/elpa/")
                  ("melpa" . "http://melpa.milkbox.net/packages/")
                  ))
  (add-to-list 'package-archives source t))
(package-initialize)

; autoload packages at start
(when (not package-archive-contents)
  (package-refresh-contents))
(defvar nk/elpa-packages
  '(
    ; IDE plugins
    sr-speedbar
    company
    ; whitespace/indentation
    clean-aindent-mode
    dtrt-indent
    ws-butler
    ; Lisp Mode
    elisp-slime-nav
    ; Web Mode
    web-mode
    ; helm
    helm
    helm-gtags
    helm-projectile
    helm-descbinds
    ; C/C++
    function-args
    ; Lua
    lua-mode
    ; Dired dired-details
    dired-details+
    dired+
    dired-rainbow
    ; misc plugins
    nyan-mode
    smooth-scrolling
  ))
(dolist (p nk/elpa-packages)
  (when (not (package-installed-p p))
    (package-install p)))


; ================================================================
; Set theme for emacs
(setq custom-theme-directory "~/.emacs.d/lib/themes/")
(add-to-list 'custom-theme-load-path custom-theme-directory)
(load-theme 'nk t)

;; mode configuration
(load-library "nk-common")                     ; common settings
(load-library "nk-misc")                       ; misc plugins
(load-library "nk-helm")                       ; helm
(load-library "nk-helm-descbinds")             ; helm-descbinds
(load-library "nk-helm-gtags")                 ; helm-gtags
(load-library "nk-speedbar")                   ; sr-speedbar
(load-library "nk-company")                    ; company-mode
(load-library "nk-c-cpp")                      ; c/c++ mode
