; ----
; package
; ----
(require 'package)

(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/") t)

(package-initialize)
(package-refresh-contents)

(package-install 'init-loader)
(package-install 'php-mode)
(package-install 'markdown-mode)
(package-install 'yaml-mode)
(package-install 'auto-complete)
(package-install 'go-mode)
(package-install 'go-autocomplete)
(package-install 'golint)
(package-install 'dockerfile-mode)
(package-install 'neotree)
(package-install 'zenburn-theme)

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
(load-theme 'zenburn t)
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

(setq-default tab-width 4 indent-tabs-mode nil)

(setq inhibit-startup-message t)

(column-number-mode t)

(global-linum-mode t)

(setq scroll-conservatively 1)

(show-paren-mode 1)

(menu-bar-mode -1)

(tool-bar-mode -1)

(display-time)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (zenburn-theme auto-complete yaml-mode php-mode neotree markdown-mode init-loader golint go-mode go-autocomplete dockerfile-mode))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
