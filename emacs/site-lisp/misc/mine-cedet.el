;;; CEDET
(load-file "~/.emacs.d/site-lisp/cedet-1.1/common/cedet.el")
(global-ede-mode t)                      ; Enable the Project management system
(semantic-load-enable-minimum-features)
(semantic-load-enable-code-helpers)      ; Enable prototype help and smart completion 
(semantic-load-enable-guady-code-helpers)
(semantic-load-enable-excessive-code-helpers)
(semantic-load-enable-semantic-debugging-helpers)
(global-srecode-minor-mode 1)            ; Enable template insertion menu
;(define-key c-mode-base-map (kbd "M-n") 'semantic-ia-complete-symbol-menu) ; Smart complete
(global-set-key [f11] 'semantic-symref)  ; Search reference
(global-set-key [f12] 'semantic-ia-fast-jump) ; Jump to define and jump back
(global-set-key [S-f12]
                (lambda ()
                  (interactive)
                  (if (ring-empty-p (oref semantic-mru-bookmark-ring ring))
                      (error "Semantic Bookmark ring is currently empty"))
                  (let* ((ring (oref semantic-mru-bookmark-ring ring))
                         (alist (semantic-mrub-ring-to-assoc-list ring))
                         (first (cdr (car alist))))
                    (if (semantic-equivalent-tag-p (oref first tag)
                                                   (semantic-current-tag))
                        (setq first (cdr (car (cdr alist)))))
                    (semantic-mrub-switch-tags first))))
;;;; C-mode-hooks .
(defun yyc/c-mode-keys ()
  "description"
  ;; Semantic functions.
  (semantic-default-c-setup)
  (local-set-key "\M-n" 'semantic-ia-complete-symbol-menu)
  (local-set-key "\C-cb" 'semantic-mrub-switch-tags)
  (local-set-key "\C-cR" 'semantic-symref)
  (local-set-key "\C-cj" 'semantic-ia-fast-jump)
  (local-set-key "\C-cp" 'semantic-ia-show-summary)
  (local-set-key "\C-cl" 'semantic-ia-show-doc)
  (local-set-key "\C-cr" 'semantic-symref-symbol)
  (local-set-key "\C-c/" 'semantic-ia-complete-symbol)
  (local-set-key [(control return)] 'semantic-ia-complete-symbol)
;  (local-set-key "." 'semantic-complete-self-insert)
;  (local-set-key ">" 'semantic-complete-self-insert)
  ;; Indent or complete
;  (local-set-key  [(tab)] 'indent-or-complete)
  )
(add-hook 'c-mode-common-hook 'yyc/c-mode-keys)
(defconst cedet-user-include-dirs
  (list ".." "../include" "../inc" "../common" "../public" "../include/core"
        "../.." "../../include" "../../inc" "../../common" "../../public"))
;(ede-cpp-root-project "skia" :file "/work/ics/external/skia/Android.mk"
;    :include-path '( "/include/effects" 
;		     "/include/pdf"
;		     "/include/utils"
;		     "/include/utils/unix"
;		     "/include/utils/android"
;		     "/include/utils/mac"
;		     "/include/config"
;		     "/include/ports"
;		     "/include/views"
;		     "/include/animator"
;		     "/include/core"
;		     "/include/text"
;		     "/include/pipe"
;		     "/include/gpu"
;		     "/include/images"
;		     "/include/xml"
;		     "../include" "/c/include" )
;    :system-include-path '( "/usr/include/c++/3.2.2/" )
;    :spp-table '( ("MOOSE" . "")
;                  ("CONST" . "const") )
;    :spp-files '( "include/config.h" )
;    ) 
(require 'semantic-c nil 'noerror)
(let ((include-dirs cedet-user-include-dirs))
  (when (eq system-type 'windows-nt)
    (setq include-dirs (append include-dirs cedet-win32-include-dirs)))
  (mapc (lambda (dir)
          (semantic-add-system-include dir 'c++-mode)
          (semantic-add-system-include dir 'c-mode))
        include-dirs))
