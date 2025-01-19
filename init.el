(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(LaTeX-command "latex")
 '(TeX-command "lualatex")
 '(bibtex-dialect 'biblatex)
 '(custom-safe-themes
   '("b30ab3b30e70f4350dad6bfe27366d573ace2190cc405c619bd5e602110c6e0c" "f366d4bc6d14dcac2963d45df51956b2409a15b770ec2f6d730e73ce0ca5c8a7" default))
 '(lsp-pyright-multi-root nil)
 '(menu-bar-mode nil)
 '(package-archives
   '(("gnu" . "https://elpa.gnu.org/packages/")
     ("nongnu" . "https://elpa.nongnu.org/nongnu/")
     ("melpa-stable" . "https://stable.melpa.org/packages/")))
 '(package-selected-packages
   '(pdf-tools lsp-pyright lsp exec-path-from-shell pyvenv lsp-mode yaml-mode use-package typescript-mode tuareg tide rustic ripgrep rg projectile prettier powerline pkg-info php-mode ocamlformat nord-theme merlin-company magit lsp-ui js2-mode iedit flycheck-ocaml flycheck-google-cpplint flycheck-color-mode-line eglot dune-format dune dart-mode company auctex apheleia android-mode ag))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))
;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(default ((t (:inherit nil :extend nil :stipple nil :background "White" :foreground "Black" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight regular :height 130 :width normal :foundry "nil" :family "Monospace")))))

(package-initialize)


(use-package doc-view
  :config
  (setq doc-view-resolution 300))


(use-package auto-revert-mode
  :hook doc-view-mode)


(use-package exec-path-from-shell
  :if (memq window-system '(mac ns x))
  :custom
  (exec-path-from-shell-variables '("JAVA_HOME" "WORKON_HOME" "PATH"))
  :config
  (exec-path-from-shell-initialize))


;; company completion
(use-package company
  :config
  (global-company-mode))


;; lsp
(use-package lsp
  :init
  :hook ((c-mode)
	 (tuareg-mode))
  :commands (lsp lsp-deferred))


;; code formatting
(use-package apheleia
  :ensure t
  :hook (after-init . apheleia-global-mode))


;; python
(use-package lsp-pyright
  :custom
  (lsp-pyright-langserver-command "pyright")
  :hook ((python-mode . (lambda ()
                          (require 'lsp-pyright)
                          (lsp-deferred)))
	 (python-mode . (lambda () (setq python-shell-completion-native-enable nil)))))

(use-package pyvenv
  :ensure t
  :config (pyvenv-mode t)

  (setq venv-activate (lambda (parent-dir) (pyvenv-activate (concat parent-dir "venv/bin"))))

  (setq pyvenv-post-activate-hooks
	(list (lambda ()
		(setq python-shell-interpreter (concat pyvenv-virtual-env "bin/python3")))))
  (setq pyvenv-post-deactivate-hooks
	(list (lambda ()
		(setq python-shell-interpreter "python3")))))

;; auctex
(add-hook 'LaTeX-mode-hook
	  (server-start))
(add-hook 'LaTeX-mode-hook
	  (lambda ()
	    (set (make-local-variable 'TeX-view-program-list)
		 (cons '("eclient" "emacsclient -n -e '(find-file-other-window \"%o\")'
                                         -e '(doc-view-fit-window-to-page)'
                                         -e '(doc-view-last-page)'
                                         -e '(other-window 1)'")
		       '()))))
;; (use-package auctex
;;   :hook (TeX-mode LaTeX-mode)
;;   :config
;;   (server-start)
;;   (set (make-local-variable 'LaTeX-electric-left-right-brace) t)
;;   (set (make-local-variable 'TeX-elextric-math) (cons "\\(" "\\)"))
;;   (set (make-local-variable 'TeX-electric-sub-and-superscript) t)
;;   (set (make-local-variable 'TeX-view-program-list)
;;        (cons '("eclient" "emacsclient -n -e '(find-file-other-window \"%o\")'
;;                                          -e '(doc-view-fit-window-to-page)'
;;                                          -e '(doc-view-last-page)'
;;                                          -e '(other-window 1)'")
;; 	       '()))
;;   (set (make-local-variable 'TeX-view-program-selection)
;;        (cons '(output-pdf "eclient") '()))
;;   (auto-revert-mode))

;; disable line numbers in image mode
;; (add-hook 'image-minor-mode-hook display-line-numbers-mode)

;; Org
(require 'ox-md)
(setq org-todo-keywords
      '((sequence "TODO" "IN PROGRESS" "FEEDBACK" "|" "DONE")))


(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :extend nil :stipple nil :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight medium :height 120 :width normal :foundry "nil" :family "SF Mono")))))
