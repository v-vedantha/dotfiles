(require 'package)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(package-initialize)
(package-refresh-contents)

;; Download Evil
(unless (package-installed-p 'use-package)
  (package-install 'use-package))

(use-package undo-tree :config (global-undo-tree-mode))

(use-package evil
	     :config
	     (defun myhook-evil-mode ()
	     ;; I want underscore be part of word syntax table, but not in regexp-replace buffer
	     ;; where I'm more comfortable having more verbose navigation with underscore not
	     ;; being a part of a word. To achieve this I check if current mode has a syntax
	     ;; table different from the global one. The `(eq)' is a lightweight test of whether
	     ;; the args point to the same object.
	     (unless (eq (standard-syntax-table) (syntax-table))
	    	;; make underscore part of a word
	    	(modify-syntax-entry ?_ "w")))
	     (add-hook 'evil-local-mode-hook 'myhook-evil-mode)
	     (evil-mode 1)
	     (evil-set-undo-system 'undo-tree))

(use-package go-mode)
(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  (setq lsp-keymap-prefix "C-c l")
  :config (setq lsp-pylsp-server-command "/Users/vedantha/.pyenv/shims/pylsp")
  (setq lsp-go-gopls-server-path "/Users/vedantha/go/bin/gopls")
  	  (setq lsp-eldoc-render-all t)
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-mode . lsp)
	 (c-mode . lsp)
	 (go-mode . lsp)
	 (c++-mode . lsp)
         ;; if you want which-key integration
         (lsp-mode . lsp-enable-which-key-integration))
  :commands lsp)

;; optionally
(use-package lsp-ui :commands lsp-ui-mode :config (setq lsp-ui-doc-show-with-mouse nil))
;; if you are helm user
;; (use-package helm-lsp :commands helm-lsp-workspace-symbol)
;; if you are ivy user
(use-package lsp-ivy :commands lsp-ivy-workspace-symbol)
;; (use-package lsp-treemacs :commands lsp-treemacs-errors-list)

;; optionally if you want to use debugger
;; (use-package dap-mode)
;; (use-package dap-LANGUAGE) to load the dap adapter for your language

;; optional if you want which-key integration
(use-package which-key
    :config
    (setq which-key-idle-delay .4)
    (which-key-mode))


(setq inhibit-startup-message t)
(tool-bar-mode -1)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(line-number-mode t)

;; (use-package company
;;   ;; Navigate in completion minibuffer with `C-n` and `C-p`.
;;   :bind (:map company-active-map
;;          ("C-n" . company-select-next)
;;          ("C-p" . company-select-previous))
;;   :config
;;   ;; Provide instant autocompletion.
;;   (setq company-idle-delay 0.3)
;;   (global-company-mode t))
(use-package company-box
  :hook (company-mode . company-box-mode)
  (prog-mode . company-mode))

(use-package ivy
  :config
  (ivy-mode t))

(use-package projectile
  :config
  (setq projectile-auto-discover nil)
  (setq projectile-track-known-projects-automatically nil)
  (projectile-mode +1)
  (define-key projectile-mode-map (kbd "s-p") 'projectile-command-map))
(use-package quelpa)
(use-package quelpa-use-package)

(use-package copilot
  :quelpa (copilot :fetcher github
                   :repo "zerolfx/copilot.el"
                   :branch "main"
                   :files ("dist" "*.el"))
  :hook (prog-mode . copilot-mode)
  :config (define-key copilot-completion-map (kbd "<tab>") 'copilot-accept-completion)
  (define-key copilot-completion-map (kbd "TAB") 'copilot-accept-completion))

(use-package evil-commentary
  :config (evil-commentary-mode)
  (evil-define-operator evil-commentary-line (beg end type)
    "Comment or uncomment [count] lines."
    :motion evil-line
    :move-point nil
    (interactive "<R>")
    (when (evil-visual-state-p)
      (unless (memq type '(line))
        (let ((range (evil-expand beg end 'line)))
          (setq beg (evil-range-beginning range)
                end (evil-range-end range)
                type (evil-type range))))
      (evil-exit-visual-state))
    (evil-commentary beg end 'line)))


(use-package treemacs
  :bind (:map global-map
	      ("C-x t t"   . treemacs)
	      ("C-x t e"   . treemacs-edit-workspaces)))
(use-package treemacs-evil :after (treemacs evil))
(use-package treemacs-projectile :after (treemacs projectile))
(use-package treemacs-icons-dired
  :hook (dired-mode . treemacs-icons-dired-enable-once))
(setq lsp-eldoc-render-all t)
(defun render-eldoc ()
  (interactive)
  (if lsp-eldoc-render-all
      (progn (message "disabling render-all")
	     (setq lsp-eldoc-render-all nil))
    (progn (message "enabled render-all")
	   (setq lsp-eldoc-render-all t))))
(add-hook 'lsp-mode-hook (lambda () (local-set-key (kbd "C-x e") 'render-eldoc)))
(setq make-backup-files nil) 
(setq auto-save-default nil)

