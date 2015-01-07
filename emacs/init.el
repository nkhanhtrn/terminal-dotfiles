; ================================================================
; misc settings
(setq user-mail-address "thek.trn@gmail.com")
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

; ===============================================================
; adjust some defaults key binding
(global-set-key (kbd "C-x C-b") 'ibuffer)

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
(defvar nkhanhtrn/elpa-packages
  '(
    ; IDE plugins
    flycheck
    auto-complete
    ; Lisp Mode
    elisp-slime-nav
    ; Web Mode
    web-mode
    ; C/C++
    ggtags    
    ; Dired dired-details
    dired-details+
    dired+
    dired-rainbow
    ; misc plugins
    nyan-mode
    smooth-scrolling
  ))
(dolist (p nkhanhtrn/elpa-packages)
  (when (not (package-installed-p p))
    (package-install p)))


; ================================================================
; Set theme for emacs
(setq custom-theme-directory "~/.emacs.d/lib/themes/")
(add-to-list 'custom-theme-load-path custom-theme-directory)
(load-theme 'nk t)

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


; ================================================================
; Web Mode
(require 'web-mode)
(web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[gj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.xml?\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.php\\'" . web-mode))

(defun web-mode-hook ()
  ; indendation
  (setq web-mode-markup-indent-offset 2)
  (setq web-mode-css-indent-offset 2)
  (setq web-mode-code-indent-offset 4)

  ; shortcuts
  ;(define-key web-mode-map (kbd "M-f") 'web-mode-fold-or-unfold)
  ;(define-key web-mode-map (kbd "M-j") 'web-mode-element-next)
  ;(define-key web-mode-map (kbd "M-k") 'web-mode-element-previous)
  ;(define-key web-mode-map (kbd "M-l") 'web-mode-element-child)
  ;(define-key web-mode-map (kbd "M-h") 'web-mode-element-parent)
  ;(define-key web-mode-map (kbd "M-;") 'web-mode-navigate)
  ;(define-key web-mode-map (kbd "M-n") 'web-mode-comment-or-uncomment)
  ;(define-key web-mode-map (kbd "M-v") 'web-mode-mark-and-expand)
  ;(define-key web-mode-map (kbd "M-r") 'web-mode-reload)
  ;(define-key web-mode-map (kbd "M-w") 'web-mode-whitespaces-show)

  ; auto completion
  (setq web-mode-ac-sources-alist
  '(("css" . (ac-source-css-property))
    ("html" . (ac-source-words-in-buffer ac-source-abbrev)))
  )
)

(add-hook 'web-mode-hook 'web-mode-hook)

;; ggtags
(require 'ggtags)
(add-hook 'c-mode-common-hook
          (lambda ()
            (when (derived-mode-p 'c-mode 'c++-mode 'java-mode 'asm-mode)
              (ggtags-mode 1))))

(define-key ggtags-mode-map (kbd "C-c g s") 'ggtags-find-other-symbol)
(define-key ggtags-mode-map (kbd "C-c g h") 'ggtags-view-tag-history)
(define-key ggtags-mode-map (kbd "C-c g r") 'ggtags-find-reference)
(define-key ggtags-mode-map (kbd "C-c g f") 'ggtags-find-file)
(define-key ggtags-mode-map (kbd "C-c g c") 'ggtags-create-tags)
(define-key ggtags-mode-map (kbd "C-c g u") 'ggtags-update-tags)

(define-key ggtags-mode-map (kbd "M-,") 'pop-tag-mark)
