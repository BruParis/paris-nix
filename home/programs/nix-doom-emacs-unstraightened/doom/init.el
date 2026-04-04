(doom! :input
       :completion
       company
       vertico

       :ui
       doom
       doom-dashboard
       hl-todo
       modeline
       ophints
       (popup +defaults)
       treemacs
       (vc-gutter +pretty)
       vi-tilde-fringe
       workspaces
       zen

       :editor
       (evil +everywhere)
       file-templates
       fold
       (format +onsave)
       snippets
       word-wrap

       :emacs
       dired
       electric
       ibuffer
       undo
       vc

       :term
       vterm

       :checkers
       syntax
       (spell +flyspell)

       :tools
       (eval +overlay)
       lookup
       lsp
       magit
       direnv
       pdf

       :lang
       emacs-lisp
       (json +lsp)
       (nix +lsp)
       ; (python +lsp)
       (sh +lsp)
       (yaml +lsp)

       :config
       (default +bindings +smartparens))
