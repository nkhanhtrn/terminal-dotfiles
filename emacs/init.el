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
(setq-default indent-tabs-mode nil)
(custom-set-variables
 '(initial-frame-alist (quote ((fullscreen . maximized))))) ;; start maximized
(show-paren-mode t)
(setq evil-move-cursor-back nil)
; remember cursor position
(setq save-place-file "~/.emacs.d/saveplace")
(setq-default save-place t)
(require 'saveplace)


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
  '(
    ; evil-mode
    evil
    evil-tabs
    ; Color theme
    ;color-theme
    ;color-theme-solarized
    ; IDE plugins
    flycheck
    auto-complete
    ; Lisp Mode
    elisp-slime-nav
    ; Web Mode
    web-mode
    ; Dired dired-details
    dired-details+
    dired+
    dired-rainbow
    ; misc plugins
    nyan-mode
    smooth-scrolling
  ))
(dolist (p nkhanhtran/elpa-packages)
  (when (not (package-installed-p p))
    (package-install p)))


; ================================================================
; Set theme for emacs
(setq custom-theme-directory "~/.emacs.d/lib/themes/")
(add-to-list 'custom-theme-load-path custom-theme-directory)
(load-theme 'nk t)


; ================================================================
; evil-mode
(require 'evil)
(evil-mode 1)
(global-evil-tabs-mode t)
;(setq evil-emacs-state-cursor '("white" bar))
;(setq evil-visual-state-cursor '("YellowGreen" box))
;(setq evil-insert-state-cursor '("white" bar))


; ================================================================
; Lisp Mode
(progn
  (require 'elisp-slime-nav)
  (defun nk-lisp-hook ()
    (elisp-slime-nav-mode)
    (turn-on-eldoc-mode)
    )
  (add-hook 'emacs-lisp-mode-hook 'nk-lisp-hook)
)

; ================================================================
; misc plugins config
; nyan cat
(require 'nyan-mode)
(nyan-mode)
(nyan-start-animation)

; smooth scrolling
(require 'smooth-scrolling)
(setq smooth-scroll-margin 10)
(setq scroll-conservatively 9999
      scroll-preserve-screen-position t)


; ================================================================
; custom keyboard shortcuts
; global keys
(define-key global-map (kbd "RET") 'newline-and-indent)

; evil key
(define-key evil-normal-state-map (kbd "C-h") 'evil-window-left)
(define-key evil-normal-state-map (kbd "C-j") 'evil-window-down)
(define-key evil-normal-state-map (kbd "C-k") 'evil-window-up)
(define-key evil-normal-state-map (kbd "C-l") 'evil-window-right)
;(define-key evil-normal-state-map (kbd "M-k") (lambda ()
;                    (interactive)
;                    (evil-scroll-up nil)))
;(define-key evil-normal-state-map (kbd "M-j") (lambda ()
;                        (interactive)
;                        (evil-scroll-down nil)))


; ================================================================
; Web Mode
(require 'web-mode)
(web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.xml?\\'" . web-mode))

(defun web-mode-hook ()
  ; indendation
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 4)

  ; shortcuts
  (define-key web-mode-map (kbd "M-f") 'web-mode-fold-or-unfold)
  (define-key web-mode-map (kbd "M-j") 'web-mode-element-next)
  (define-key web-mode-map (kbd "M-k") 'web-mode-element-previous)
  (define-key web-mode-map (kbd "M-l") 'web-mode-element-child)
  (define-key web-mode-map (kbd "M-h") 'web-mode-element-parent)
  (define-key web-mode-map (kbd "M-;") 'web-mode-navigate)
  (define-key web-mode-map (kbd "M-n") 'web-mode-comment-or-uncomment)
  (define-key web-mode-map (kbd "M-v") 'web-mode-mark-and-expand)
  (define-key web-mode-map (kbd "M-r") 'web-mode-reload)
  (define-key web-mode-map (kbd "M-w") 'web-mode-whitespaces-show)

  ; auto completion
  (setq web-mode-ac-sources-alist
  '(("css" . (ac-source-css-property))
    ("html" . (ac-source-words-in-buffer ac-source-abbrev)))
  )
)

(add-hook 'web-mode-hook 'web-mode-hook)
