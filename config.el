;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; refresh' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jake Runzer"
      user-mail-address "jakerunzer@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
(setq doom-font (font-spec :family "JetBrains Mono" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. These are the defaults.
(load-theme 'doom-solarized-dark)

(use-package! doom-modeline
  :defer
  (setq doom-modeline-height 35
        doom-modeline-icon t))

(setq evil-normal-state-cursor '(box "hot pink")
      evil-insert-state-cursor '(bar "hot pink")
      evil-visual-state-cursor '(hollow "hot pink"))

;; If you intend to use org, it is recommended you change this!
(setq org-directory "~/Dropbox/org/")

;; If you want to change the style of line numbers, change this to `relative' or
;; `nil' to disable it:
(setq display-line-numbers-type t)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', where Emacs
;;   looks when you load packages with `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c g k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c g d') to jump to their definition and see how
;; they are implemented.

;; Better defaults

(setq delete-old-versions t
      version-control t
      delete-by-moving-to-trash t
      vc-make-backup-files t
      tab-width 2
      indent-tabs-mode nil
      require-final-newline t)

;; Buffers

(defun switch-to-previous-buffer ()
  (interactive)
  (switch-to-buffer (other-buffer)))

(map! :leader
      :desc "Prev" "TAB" 'switch-to-previous-buffer
      :desc "Switch buffers" "b b" 'ivy-switch-buffer)

;; Windows

(map! :leader
      :desc "Split horizontally" "w /" 'split-window-horizontally
      :desc "Split vertically" "w -" 'split-window-horizontally
      :desc "Center" "m" 'recenter)

(defun size-callback ()
  (cond ((> (frame-pixel-width) 1280) '(90 . 0.6))
        (t                            '(0.5 . 0.5))))

(use-package! zoom
  :init
  (zoom-mode t)
  :config
  (setq zoom-size 'size-callback))

;; Which key

(use-package! which-key
  :config
  (setq which-key-idle-delay 0.3
        which-key-idle-secondary-delay 0.05))

;; Autocomplete

(after! company
  :config
  (setq company-idle-delay 0.1
        company-minimum-prefix-length 2
        company-show-numbers nil
        company-dabbrev-downcase nil
        company-dabbrev-ignore-case t))

;; Ivy/Counsel/Swiper

(use-package! ivy
  :config
  (setq ivy-re-builders-alist
        '((swiper . ivy--regex-plus)
          (t        . ivy--regex-fuzzy))
        ivy-initial-inputs-alist nil
        ivy-display-style 'fancy
        ivy-use-virtual-buffers t))

(map!
  "C-s" 'swiper
  "M-x" 'counsel-M-x

  (:map (ivy-minibuffer-map minibuffer-local-map)
    "C-k" 'kill-line
    "RET" 'ivy-alt-done)

  (:leader
    :desc "M-x" "SPC" 'counsel-M-x
    :desc "List projects" "p l" 'counsel-projectile-switch-project
    :desc "Search project" "p g" 'counsel-git-grep))

;; Magit

(map! :leader
      :desc "Magic status" "g s" 'magit-status)

;; Wakatime

(use-package! wakatime-mode
  :config
  (setq wakatime-api-key "f175432d-53db-4495-9ef3-a518b67d4c1a")
  (global-wakatime-mode))

;; Prettier

(use-package! prettier-js
  :commands (prettier-js-mode)
  :init
  (defun setup-prettier-js ()
    "Sets up prettier js formatting."
    (interactive)
    (prettier-js-mode))

  (add-hook! (typescript-mode js2-mode web-mode)
             (prettier-js-mode)))

;; TypeScript

(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))

(defun setup-tide-mode ()
  (interactive)
  (tide-mode)
  (tide-setup)
  (flycheck-mode +1)
  (company-mode +1)
  (tide-hl-identifier-mode +1)
  (tide-restart-server))

(after! typescript-mode
  (setq typescript-indent-level 2))

(use-package! tide
  :after (typescript-mode)
  :hook ((typescript-mode . setup-tide-mode)
         (typescript-mode . tide-hl-identifier-mode)))

(after! web-mode
  (setq web-mode-code-indent-offset 2
        web-mode-attr-indent-offset 2
        web-mode-markup-indent-offset 2
        web-mode-css-indent-offset 2))

(map! :map (typescript-mode-map web-mode-map)
      "C-c r" 'tide-rename-symbol
      "C-c o" 'tide-organize-imports
      "C-c l" 'setup-tide-mode)

;; Emmet

(after! emmet-mode
  (map! :i "C-p" 'emmet-expand-line))

;; Drag stuff

(define-key!
  "M-j" 'drag-stuff-down
  "M-p" 'drag-stuff-up)

;; Evil

(setq evil-escape-delay 0.1)

;; Errors

(map! :leader
      :desc "Prev error" "e p" 'previous-error
      :desc "Next error" "e n" 'next-error)
