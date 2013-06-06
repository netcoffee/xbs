(load-file "~/.emacs.d/site-lisp/misc/mine-auctex.el")
(load-file "~/.emacs.d/site-lisp/misc/mine-cedet.el")
;;+set title as file name
(setq frame-title-format
(if (eq system-type 'windows-nt)
      (list "WINNT@"(getenv "USERNAME")"@" "BJ" "  %b@%f@%p" :"%+"     )
(if (eq system-type 'gnu/linux)
;(list "Linux@"  "%f@%p" : "%+")))
(list "%f")))
)

(if (eq system-type 'gnu/linux)
    (load-file "~/.emacs.d/site-lisp/misc/mine-linux.el")
(if (equal system-type 'darwin)
    (load-file "~/.emacs.d/site-lisp/misc/mine-mac.el")))

(add-to-list 'load-path "~/.emacs.d/site-lisp/misc")
;; highlight-symbol (like Shift-F8 in Source Insight)
(require 'highlight-symbol)
(global-set-key [(control f3)] 'highlight-symbol-at-point)
(global-set-key [f3] 'highlight-symbol-next)
(global-set-key [(shift f3)] 'highlight-symbol-prev)
(global-set-key [(meta f3)] 'highlight-symbol-prev)
;; undo-tree
(require 'undo-tree)
(global-undo-tree-mode)

(global-auto-revert-mode t)
;;(set-w32-system-coding-system 'utf-8)
;;(set-keyboard-coding-system 'utf-8) (set-selection-coding-system 'utf-8)
;; turn off welcome
(setq inhibit-startup-message t)
;; disable tool-bar
(tool-bar-mode -1)
(blink-cursor-mode -1)
;; high light when mark
(transient-mark-mode t)
(auto-image-file-mode t)
;(require 'color-theme)
;(color-theme-tty-dark)
(setq default-directory "~/")
(setq scroll-margin 3
      scroll-conservatively 10000)
(defalias 'yes-or-no-p 'y-or-n-p)
;;使用折行
(setq truncate-partial-width-windows nil)
;; Backup
(setq backup-directory-alist '(("." . "~/.emacs.d/backup")))
(setq backup-by-copying t)
(setq version-control t)
(setq kept-new-versions 3)
(setq delete-old-versions t)
(setq kept-old-versions 2)
(setq dired-kept-versions 1)

;; ibuffer
(require 'ibuffer nil t)
(require 'ibuf-ext nil t)
(global-set-key (kbd "C-x C-b") 'ibuffer)
(autoload 'ibuffer "ibuffer" "List buffers." t)

;; session
(require 'session nil t)
(when (featurep 'session)
  (setq session-save-file "~/.emacs.d/_session")
  (setq session-save-file-coding-system 'chinese-gbk)
  ;; org-mark-ring,conflict with session
  (add-to-list 'session-globals-exclude 'org-mark-ring)
  (add-hook 'after-init-hook 'session-initialize))

;; Org-mode
(add-to-list 'load-path "~/.emacs.d/org-6.03/lisp")
(require 'org)
(add-to-list 'auto-mode-alist '("\\.org$" . org-mode))
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(setq org-log-done 'time)
(setq org-agenda-files (list "~/org/work.org"
			     "~/org/home.org"))
(setq org-todo-keywords
      '((sequence "TODO(t)" "DOING(i!)" "|" "DONE(d!)" "CANCELED(c@)")))

;; Desktop at the button, or will confilct with session
(require 'desktop)
(desktop-save-mode t)
(condition-case nil
    (desktop-read)
  (error nil))

;; OpenGrok--source navigate
;(require 'opengrok)
;(opengrok-minor-mode t)

;; GNU Global
(require 'xgtags)
(add-hook 'c-mode-common-hook
          (lambda ()
       (xgtags-mode 1)))
(add-hook 'c++-mode-hook
          (lambda ()
       (xgtags-mode 1)))


;; ==================================================
;; [] match
;;Emacs 在匹配的括号之间来回跳转的时候按 C-M-f 和 C-M-b 太麻烦。
;;vi的 % 就很方便，把 % 设置为匹配括号。
;;当 % 在括号上按下时，那么匹配括号，否则输入一个 %。
(global-set-key "%" 'match-paren)
(defun match-paren (arg)
  "Go to the matching paren if on a paren; otherwise insert %."
  (interactive "p")
  (cond ((looking-at "\\s\(") (forward-list 1) (backward-char 1))
((looking-at "\\s\)") (forward-char 1) (backward-list 1))
    (t (self-insert-command (or arg 1)))))
;; end [] match
