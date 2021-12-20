;; The default is 800 kilobytes.  Measured in bytes.
(setq gc-cons-threshold (* 50 1000 1000))

;; You will most likely need to adjust this font size for your system!
(defvar efs/default-font-size 110)
(defvar efs/default-variable-font-size 110)

;; Set frame transparency
(set-frame-parameter (selected-frame) 'alpha '(90 . 90))
(add-to-list 'default-frame-alist '(alpha . (90 . 90)))
(set-frame-parameter (selected-frame) 'fullscreen 'maximized)
(add-to-list 'default-frame-alist '(fullscreen . maximized))


(setq inhibit-startup-message t)

(scroll-bar-mode -1) ;;disable visible scrollbar
(tool-bar-mode -1)   ;;Disable toolbar
(tooltip-mode -1)    ;;Disable tooltip
(set-fringe-mode 10) ;;Give some fringe

(menu-bar-mode -1)   ;;Disable the menu bar

(setq split-width-threshold nil)
(setq split-width-threshold 1)

;; Initialize package sources
(require 'package)

(setq package-archives '(("melpa" . "https://melpa.org/packages/")
                         ("org" . "https://orgmode.org/elpa/")
                         ("elpa" . "https://elpa.gnu.org/packages/")))

(package-initialize)
(unless package-archive-contents
 (package-refresh-contents))

;; Initialize use-package on non-Linux platforms
(unless (package-installed-p 'use-package)
   (package-install 'use-package))

(require 'use-package)
(setq use-package-always-ensure t)




(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   '("~/organizer/education.org" "~/Projects/masterThesis/thesis.org"))
 '(package-selected-packages
   '(spaceline solarized-theme zenburn-theme spacemacs-theme desktop-environment exwm djvu pdf-tools modern-cpp-font-lock flycheck auto-complete yasnippet-snippets visual-fill-column evil-magit magit counsel-projectile projectile nord-theme doom-themes helpful counsel ivy-rich which-key rainbow-delimiters doom-modeline-now-playing ivy doom-modeline use-package)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(column-number-mode)
(global-display-line-numbers-mode t)



(set-face-attribute 'default nil :font "Fira Code Retina" :height efs/default-font-size)

;; Set the fixed pitch face
(set-face-attribute 'fixed-pitch nil :font "Fira Code Retina" :height efs/default-font-size)

;; Set the variable pitch face
(set-face-attribute 'variable-pitch nil :font "DejaVu Serif Book" :height efs/default-variable-font-size :weight 'regular)

;; disable line numbers for some modes
(dolist (mode '(org-mode-hook
                shell-mode-hook
                eshell-mode-hook
		term-mode-hook
		text-mode-hook))
  (add-hook mode (lambda () (display-line-numbers-mode 0))))


(use-package ivy
  :diminish
  :bind (("C-s" . swiper)
         :map ivy-minibuffer-map
         ("TAB" . ivy-alt-done)
         ("C-l" . ivy-alt-done)
         ("C-j" . ivy-next-line)
         ("C-k" . ivy-previous-line)
         :map ivy-switch-buffer-map
         ("C-k" . ivy-previous-line)
         ("C-l" . ivy-done)
         ("C-d" . ivy-switch-buffer-kill)
         :map ivy-reverse-i-search-map
         ("C-k" . ivy-previous-line)
         ("C-d" . ivy-reverse-i-search-kill))
  :init
  (ivy-mode 1))

(global-set-key (kbd "C-M-j") 'counsel-switch-buffer)
(global-set-key (kbd "C-;") 'backward-char)

(use-package all-the-icons
  :if (display-graphic-p))

(use-package doom-modeline
  :ensure t
  :init (doom-modeline-mode 1))

(use-package rainbow-delimiters
  :hook (prog-mode . rainbow-delimiters-mode))

(use-package which-key
  :diminish which-key-mode
  :config
  (setq which-key-idle-delay 0.5))

(use-package counsel
  :bind (("M-x" . counsel-M-x)
	 ("C-x b" . counsel-ibuffer)
	 ("C-x C-f" . counsel-find-file)
	 :map minibuffer-local-map
	 ("C-r" . 'counsel-minibuffer-history)))

(require 'ivy-rich)
(ivy-rich-mode 1)

(use-package helpful
  :commands (helpful-callable helpful-variable helpful-command helpful-key)
  :custom
  (counsel-describe-function-function #'helpful-callable)
  (counsel-describe-variable-function #'helpful-variable)
  :bind
  ([remap describe-function] . counsel-describe-function)
  ([remap describe-command] . helpful-command)
  ([remap describe-variable] . counsel-describe-variable)
  ([remap describe-key] . helpful-key))

(add-to-list 'custom-theme-load-path (expand-file-name "~/.emacs.d/themes/"))

(load-theme 'doom-homage-black t)

(use-package projectile
  :diminish projectile-mode
  :config (projectile-mode)
  :custom ((projectile-completion-system 'ivy))
  :bind-keymap
  ("C-c p" . projectile-command-map)
  :init
  ;; NOTE: Set this to the folder where you keep your Git repos!
  (when (file-directory-p "~/Projects")
    (setq projectile-project-search-path '("~/Projects")))
  (setq projectile-switch-project-action #'projectile-dired))

(use-package counsel-projectile
  :config (counsel-projectile-mode))

(use-package magit
  :commands (magit-staus magit-get-current-branch)
  :custom
  (magit-display-buffer-function #'magit-display-buffer-same-window-except-diff-v1))

(require 'org)

(use-package org
  :hook (org-mode . efs/org-mode-setup)
  :config
  (setq org-ellipsis " ▾"
        org-hide-emphasis-markers t)
  (setq org-agenda-start-with-log-mode t)
  (setq org-log-done 'time)
  (setq org-log-into-drawer t))

(setq org-todo-keywords
    '((sequence "TODO(t)" "NEXT(n)" "|" "DONE(d!)")
      (sequence "BACKLOG(b)" "PLAN(p)" "READY(r)" "ACTIVE(a)" "REVIEW(v)" "WAIT(w@/!)" "HOLD(h)" "|" "COMPLETED(c)" "CANC(k@)")))

;; Configure custom agenda views
;(setq org-agenda-custom-commands
 ;'(("d" "Dashboard"
  ; ((agenda "" ((org-deadline-warning-days 7)))
   ; (todo "NEXT"
    ;  ((org-agenda-overriding-header "Next Tasks")))
    ;(tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))))

  ;; Configure custom agenda views
  (setq org-agenda-custom-commands
   '(("d" "Dashboard"
     ((agenda "" ((org-deadline-warning-days 7)))
      (todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))
      (tags-todo "agenda/ACTIVE" ((org-agenda-overriding-header "Active Projects")))))

    ("n" "Next Tasks"
     ((todo "NEXT"
        ((org-agenda-overriding-header "Next Tasks")))))

    ("W" "Work Tasks" tags-todo "+work-email")

    ;; Low-effort next actions
    ("e" tags-todo "+TODO=\"NEXT\"+Effort<15&+Effort>0"
     ((org-agenda-overriding-header "Low Effort Tasks")
      (org-agenda-max-todos 20)
      (org-agenda-files org-agenda-files)))))

(defun efs/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•")))))))
(setq org-tags-column 0)

(efs/org-font-setup)

(with-eval-after-load 'org-faces
  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "DejaVu Serif Book" :weight 'regular :height (cdr face)))

;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch)
  (set-face-attribute 'line-number nil :inherit 'fixed-pitch)
  (set-face-attribute 'line-number-current-line nil :inherit 'fixed-pitch))

(defun efs/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org-bullets
  :after org
  :hook (org-mode . org-bullets-mode))

(defun efs/org-mode-visual-fill ()
  (setq visual-fill-column-width 120
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . efs/org-mode-visual-fill))

(require 'yasnippet)

(yas-global-mode 1)

(use-package auto-complete
  :ensure t
  :init
  (progn
    (ac-config-default)
    (global-auto-complete-mode t)
    ))

(global-flycheck-mode)

(use-package modern-cpp-font-lock
  :ensure t)

(use-package pdf-tools
  :ensure t
  :config
  (pdf-tools-install))


(defun hooman/exwm-update-class ()
  (exwm-workspace-rename-buffer exwm-class-name))

(defun hmg/set-wallpaper ()
  (interactive)
  (start-process-shell-command
   "feh" nil  "feh --bg-scale /usr/share/backgrounds/hooman/einstein.webp"))

(defun efs/exwm-update-title ()
  (pcase exwm-class-name
    ("Firefox" (exwm-workspace-rename-buffer (format "Firefox: %s" exwm-title)))))

(use-package exwm
  :config
  ;;Set the default number of workspaces
  (setq exwm-workspace-number 5)


  ;; When window title updates, use it to set the buffer name
  (add-hook 'exwm-update-title-hook #'efs/exwm-update-title)
  
  ;;When window "class" updates, use it to set the buffer name
  ;;(add-hook) 'exwm-update-class-hook # 'hooman/exwm-update-class)

  ;; Set the wallpaper after setting screen resolution
  (hmg/set-wallpaper)
  
  (require 'exwm-systemtray)
  (exwm-systemtray-enable)

  (defun hm/run-in-background (command)
  (let ((command-parts (split-string command "[ ]+")))
    (apply #'call-process `(,(car command-parts) nil 0 nil ,@(cdr command-parts)))))



  (defun hm/exwm-init-hook ()
    ;; Make workspace 1 be the one where we land at startup
    (exwm-workspace-switch-create 1)

    ;; Launch apps that will run in the background
    (hm/run-in-background "nm-applet"))

  ;; Show the time and date in modeline
  (setq display-time-day-and-date t)
  (display-time-mode 1)
  ;; Also take a look at display-time-format and format-time-string
  ;;These keys should always pass through to Emacs
  (setq exwm-input-prefix-keys
	'(?\C-x
	  ?\C-u
	  ?\C-h
	  ?\M-x
	  ?\M-`
	  ?\M-&
	  ?\M-:
	  ?\C-\M-j ;; Buffer list
	  ?\C-\ )) ;; Ctrl+Space
  ;; Ctrl+Q will enable the next key to be sent directly
  (define-key exwm-mode-map  [?\C-q] 'exwm-input-send-next-key)

  ;; Set up global key bindings. These always work, no matter the input state!
  ;; Keep in mind that changing this list after EXWM Initializes has no effect.
  (setq exwm-input-global-keys
	`(
	  ;; Reset to line-mode (C-c C-k switches to char-mode via exwm-input-release-keyboard)
	  ([?\s-r] . exwm-reset)

	  ;;Move between windows
	  ([s-left] . windmove-left)
	  ([s-right] . windmove-right)
	  ([s-up] . windmove-up)
	  ([s-down] . windmove-down)

	  ;; Launch applications via shell command
	  ([?\s-&] . (lambda (command)
		       (interactive (list (read-shell-command "$ ")))
		       (start-process-shell-command command nil command)))

	  ;; Switch workspaces
	  ([?\s-w] . exwm-workspace-switch)

	  ;; 's-N': Switch to certain workspace with Super (win) plus a number key (0 - 9)
	  ,@(mapcar (lambda (i)
		      `(,(kbd (format "s-%d" i)) .
			(lambda ()
			  (interactive)
			  (exwm-workspace-switch ,i))))
		    (number-sequence 0 9))))
  (exwm-input-set-key (kbd "s-SPC") 'counsel-linux-app)
  
  (exwm-enable))

;;desktop environment package enables exwm control voulume and brightness

(add-to-list 'load-path "~/.emacs.d/lib/desktop-environment/")
  (require 'desktop-environment)
(desktop-environment-mode)



(defun bidi-direction-toggle ()
  "Switch the explicit direction of text for current buffer."
  (interactive "")
  (if (equal bidi-paragraph-direction 'right-to-left)
      (setq bidi-paragraph-direction 'left-to-right)
    (setq bidi-paragraph-direction 'right-to-left)
    )
  (message bidi-paragraph-direction)
  )

(setq org-clock-sound "~/Downloads/alarm.wav")

(use-package dired
  :ensure nil
  :commands (dired dired-jump)
  :bind (("C-x C-j" . dired-jump))
  :custom ((dired-listing-switches "-agho --group-directories-first")))

(require 'exwm-xim)
(exwm-xim-enable)
(push ?\C-\\ exwm-input-prefix-keys)

(defun efs/display-startup-time ()
  (message "Emacs loaded in %s with %d garbage collections."
           (format "%.2f seconds"
                   (float-time
                    (time-subtract after-init-time before-init-time)))
           gcs-done))

(add-hook 'emacs-startup-hook #'efs/display-startup-time)

;; Make gc pauses faster by decreasing the threshold.
(setq gc-cons-threshold (* 2 1000 100))
