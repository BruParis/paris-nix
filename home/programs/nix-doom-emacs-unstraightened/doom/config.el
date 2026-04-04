;; Personal information
(setq user-full-name "Bruno"
      user-mail-address "parisbruno85@gmail.com")

;; Theme
(setq doom-theme 'catppuccin)
(setq catppuccin-flavor 'mocha)

;; Font
(setq doom-font (font-spec :family "monospace" :size 14))

;; Line numbers
(setq display-line-numbers-type 'relative)

;; Org directory
(setq org-directory "~/org/")

;; gptel
(load! "gptel")

;; Claude Code
(use-package! claude-code)
