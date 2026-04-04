(use-package! gptel
  :config
  (defvar my/anthropic-backend
    (gptel-make-anthropic "Claude"
      :stream t
      :key (lambda ()
             (auth-source-pick-first-password
               :host "api.anthropic.com"
               :user "apikey"))))

  ;; Default model
  (setq gptel-model 'claude-sonnet-4-6
        gptel-backend my/anthropic-backend)

  ;; Quick toggle between Sonnet and Opus
  (defun my/gptel-toggle-model ()
    (interactive)
    (if (eq gptel-model 'claude-sonnet-4-6)
        (progn
          (setq gptel-model 'claude-opus-4-5)
          (message "gptel: switched to Opus"))
      (progn
        (setq gptel-model 'claude-sonnet-4-6)
        (message "gptel: switched to Sonnet"))))

  (global-set-key (kbd "C-c g m") #'my/gptel-toggle-model))
