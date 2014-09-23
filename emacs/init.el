
(setq user-mail-address "nkhanhtran@cogini.com")
(setq-default case-fold-search t)
(set-language-environment "UTF-8")

(require 'package)
(dolist (source '(("marmalade" . "http://marmalade-repo.org/packages/")
                  ("elpa" . "http://tromey.com/elpa/")
                  ("melpa" . "http://melpa.milkbox.net/packages/")
                  ))
  (add-to-list 'package-archives source t))
(package-initialize)
