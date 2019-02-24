; ----
; package
; ----
(require 'package)
(package-initialize)

;(setq package-enable-at-startup nil)
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

; company
(when (require 'company nil t)
  (global-company-mode)
  (setq company-idle-delay 0)
  (setq company-minimum-prefix-length 2)
  (setq company-selection-wrap-around t)
  (define-key company-active-map (kbd "M-n") nil)
  (define-key company-active-map (kbd "M-p") nil)
  (define-key company-active-map (kbd "C-n") 'company-select-next)
  (define-key company-active-map (kbd "C-p") 'company-select-previous)
  (define-key company-active-map (kbd "C-h") nil))

; Ivy/counsel
(when (require 'ivy-mode nil t)
  (ivy-mode 1)
  (counseq:l-mode 1)

  (global-set-key "\C-s" 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  (global-set-key (kbd "<f2> u") 'counsel-unicode-char)
  (global-set-key (kbd "C-c g") 'counsel-git)
  (global-set-key (kbd "C-c j") 'counsel-git-grep)
  (global-set-key (kbd "C-c k") 'counsel-ag)
  (global-set-key (kbd "C-x l") 'counsel-locate)
  (global-set-key (kbd "C-S-o") 'counsel-rhythmbox))

; markdown-mode
(when (require 'markdown-mode nil t)
(setq markdown-command "multimarkdown"))

; flycheck
(require 'flycheck)

; editorconfig
(when (require 'editorconfig nil t)
  (editorconfig-mode 1)
  (setq edconf-exec-path "/usr/local/bin/editorconfig")

  (with-eval-after-load 'editorconfig
                        (add-to-list 'editorconfig-indentation-alist
                                     '(vue-mode css-indent-offset
                                                js-indent-level
                                                sgml-basic-offset
                                                ssass-tab-width
                                                ))))

; git-gutter-plus
(when (require 'git-gutter+ nil t)
  (global-git-gutter+-mode))

; undo-tree
(when (require 'undo-tree nil t)
  (global-undo-tree-mode))

; recentf
(when (require 'recentf nil t)
(setq recentf-max-saved-items 2000)
(setq recentf-auto-cleanup 'never)
(setq recentf-auto-save-timer (run-with-idle-timer 30 t 'recentf-save-list))
(recentf-mode 1))

; lsp
(when (require 'vue-mode nil t))
(when (require 'lsp-mode nil t)
  (setq lsp-auto-guess-root t)  ;; if you have projectile ...
  (with-eval-after-load 'lsp-mode
                        (require 'lsp-ui))
  (defun vuejs-custom ()
    (lsp)
    (lsp-ui-mode)
    (push 'company-lsp company-backends)
    (flycheck-mode t)
    (company-mode))

  (add-hook 'vue-mode-hook 'vuejs-custom))


; ----
; org
; ----
(global-set-key (kbd "C-c C-q") 'org-capture)


; ----
; language
; ----
(setq default-input-method "MacOSX")
(set-locale-environment nil)
(set-language-environment "Japanese")
(set-terminal-coding-system 'utf-8-unix)
(set-keyboard-coding-system 'utf-8)
(set-buffer-file-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)
(set-default-coding-systems 'utf-8)
(prefer-coding-system 'utf-8)

; ----------------
; key bind
; ----------------
;; C-h
(global-set-key "\C-h" 'delete-backward-char)
;; help
(global-set-key "\C-c\C-h" 'help-command)
;; comment out
(global-set-key "\C-c;" 'comment-dwim)
;; window operation
(global-set-key "\C-t" 'other-window)
;; undo
(define-key global-map (kbd "C-z") 'undo)

; ----
; preferences
; ----
(when (require 'zenburn-theme nil t)
  (load-theme 'zenburn t))

; startup message
(setq inhibit-startup-message 1)
(if (eq window-system 'x)
    (menu-bar-mode 1) (menu-bar-mode 0))
(menu-bar-mode nil)
(setq initial-scratch-message "")
; backup
(setq create-lockfiles nil)
(setq make-backup-files nil)
(setq delete-auto-save-files t)
(setq auto-save-default nil)
;beep
(defun next-line (arg)
  (interactive "p")
  (condition-case nil
      (line-move arg)
    (end-of-buffer)))

(electric-pair-mode 1)

(setq inhibit-startup-message t)

(column-number-mode t)

(global-linum-mode t)

(setq scroll-conservatively 1)

(show-paren-mode 1)

(menu-bar-mode -1)

(tool-bar-mode -1)

;allow symlink
(setq vc-follow-symlinks t)
(setq auto-revert-check-vc-info t)


(display-time)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
  '(package-selected-packages
     (quote
       (counsel lsp-ui lsp-mode lsp-vue htmlize avy undo-tree multiple-cursors wgrep git-gutter+ company editorconfig flycheck ox-hugo vue-mode zenburn-theme auto-complete yaml-mode php-mode neotree markdown-mode init-loader golint go-mode go-autocomplete dockerfile-mode))))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
  )
