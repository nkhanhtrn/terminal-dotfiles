;;
;; Helm configuration
;;

; require helm
(require 'helm)
(require 'helm-config)

; global key set
(global-set-key (kbd "C-c h") 'helm-command-prefix)                     ; change helm-command-prefix to avoid pressing C-x C-c
(global-set-key (kbd "M-x") 'helm-M-x)                                  ; replace execute-extended-command with helm-M-x
(global-unset-key (kbd "C-x c"))

; helm-map key set
(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action)     ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action)       ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action)                  ; list actions using C-z

; curl for google suggest
(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

; some helm configs
(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

; enable helm
(helm-mode 1)

