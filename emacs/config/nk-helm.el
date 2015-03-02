;;
;; PACKAGE: helm
;;
;; NOTE: configuration for Helm

; require helm
(require 'helm)
(require 'helm-config)

; global key set
(global-set-key (kbd "C-c h") 'helm-command-prefix)            ; change helm prefix to avoid pressing C-x C-c
(global-set-key (kbd "M-x") 'helm-M-x)
(global-set-key (kbd "C-x b") 'helm-mini)
(global-set-key (kbd "M-y") 'helm-show-kill-ring)
(global-set-key (kbd "C-x C-f") 'helm-find-files)
(global-set-key (kbd "C-c h o") 'helm-occur)
(global-set-key (kbd "C-h SPC") 'helm-all-mark-rings)
(global-set-key (kbd "C-c C-h x") 'helm-register)
(global-set-key (kbd "C-c C-h g") 'helm-google-suggest)
(global-set-key (kbd "C-c C-h M-:") 'helm-eval-expression-with-eldoc)
(global-unset-key (kbd "C-x c"))

; helm-map key set
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)       ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action)
(define-key minibuffer-local-map (kbd "C-c C-l") 'helm-minibuffer-history)

; curl for google suggest
(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

; some helm configs
(setq helm-split-window-in-side-p           t                  ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t                  ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t                  ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8                  ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)
(setq helm-M-x-fuzzy-match                  t                  ; fuzzy matching
      helm-buffers-fuzzy-matching           t
      helm-recentf-fuzzy-match              t
      helm-locate-fuzzy-match               t
      helm-apropos-fuzzy-match              t
      helm-lisp-fuzzy-completion            t)
(setq helm-autoresize-mode                  t)                 ; auto resize helm

; enable helm
(helm-mode 1)
