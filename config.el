;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Ronie Uliana"
      user-mail-address "ronie.uliana@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))

;; I like JetBrains with ligatures.
(setq doom-font (font-spec :family "JetBrains Mono" :size 18)
      doom-big-font (font-spec :family "JetBrains Mono" :size 24))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-city-lights)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type 't)

(setq visual-line-mode nil)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

(setq avy-keys '(?i ?e ?a ?o ?u ?m ?d ?s ?r ?n))

;;==================================================
;; Overwrite default keybinds
;;==================================================

;; Faster movement
(map!
 :n "<S-right>" #'evil-window-right
 :n "<S-left>" #'evil-window-left
 :n "<S-down>" #'evilem-motion-next-line
 :n "<S-up>" #'evilem-motion-previous-line)

;;
(map!
 :i "<C-/>" #'hippie-expand ;; Fix things on MacOS
 :i "<C-SPC>" #'hippie-expand) ;; More convenient shortcut

;; Quick delete in normal mode
(map!
 :n "<delete>" #'sp-kill-symbol
 :n "<backspace>" #'sp-backward-kill-symbol)


;;==================================================
;; Opinionated defaults for everything
;;==================================================

(setq projectile-project-search-path
      '("~/Workspace" "~/src/github.com/Shopify/" "~/src/github.com/ruliana")

      ;; Prefered method for ivy search
      prescient-filter-method '(anchored)

      ;; Global substitution is more common, so make it default
      evil-ex-substitute-global t)


;;==================================================
;; Package configuration
;;==================================================

(use-package! editorconfig
  :config
  (editorconfig-mode 1))

;; OpenSCAD
(use-package! scad-mode)

(use-package! chruby)

;; Python stuff
(use-package! python
  :init
  (setq flycheck-disabled-checkers '(python-pylint)
        flycheck-pylintrc '("pylintrc" ".pylintrc")
        flycheck-flake8rc '("setup.cfg" ".flake8rc")
        python-environment-directory "~/.pyenv/virtualenvs"
        python-environment-default-root-name "starscream")
  :custom
  (rotate-text-local-symbols
   '(("and" "or")
     ("&&" "||")
     ("&" "|")
     ("True" "False")
     ("0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "10")
     ("<=" "<" "==" ">=" ">"))))

(use-package! py-yapf
  :after python)

;; Shadowenv is a Shopify package to overwrite env variable depending on buffer.
;; Doesn't seem to work here.
(use-package! shadowenv
  :config
  (shadowenv-global-mode t))

;; (defun python-config/virtualenv-paths (venv-path)
;;   (let* ((json-array-type 'vector)
;;          (json-key-type 'string)
;;          (json-object-type 'hash-table)
;;          (paths (shell-command-to-string (concat "source " venv-path "/bin/activate"
;;                                                  "&& python -c \"import sys; import json; print(json.dumps({'paths': sys.path}))\""))))
;;     (gethash "paths" (json-read-from-string paths))))

;; (add-hook 'hack-local-variables-hook
;;           (lambda ()
;;             (shadowenv-mode t)
;;             (when (getenv "VIRTUAL_ENV")
;;               (setq lsp-python-ms-python-executable-cmd (concat (getenv "VIRTUAL_ENV") "/bin/python")
;;                     lsp-python-ms-python-executable (concat (getenv "VIRTUAL_ENV") "/bin/python")
;;                     lsp-python-ms-extra-paths
;;                     (vconcat (python-config/virtualenv-paths (getenv "VIRTUAL_ENV"))
;;                              `(,(expand-file-name "~/src/github.com/Shopify/starscream/.dev/starscream/spark/current/python/lib/pyspark.zip")))))))

;; Amazing package for change word case
(use-package! evil-string-inflection
  :config
  (map!
   :n "gi" #'evil-operator-string-inflection))

;; Let's go directly to where we want
;; (use-package! evil-snipe
;;   :config
;;   (setq evil-snipe-spillover-scope 'whole-visible))

;; Sane regexps
(use-package! pcre2el)

(use-package! keyfreq
  :config
  (setq keyfreq-mode 1
        keyfreq-autosave-mode 1))

(use-package! atomic-chrome
  :after-call focus-out-hook
  :config
  (setq atomic-chrome-default-major-mode 'markdown-mode
        atomic-chrome-buffer-open-style 'frame)
  (atomic-chrome-start-server))

;;==================================================
;; Fix for git-timemachine keybinding in evil
;; source: http://blog.binchen.org/posts/use-git-timemachine-with-evil.html
;; see also https://bitbucket.org/lyro/evil/issue/511/let-certain-minor-modes-key-bindings
;;==================================================
(with-eval-after-load 'git-timemachine
  (evil-make-overriding-map git-timemachine-mode-map 'normal)
  ;; force update evil keymaps after git-timemachine-mode loaded
  (add-hook 'git-timemachine-mode-hook #'evil-normalize-keymaps))

;;==================================================
;; DWIM Paste (tentative minor mode)
;;==================================================
;; Handle spaces around paste
;;
;; Reason: very rarely I paste partial stuff, so I want paste to be a little
;; smarter when it comes to spaces.
;; I had to do some weird stuff to get a handle executed after _every_ paste but
;; it worked.
;;
;; How does it work?
;; After pasting, it looks for a regular expression after and before the pasted
;; text to see if it needs to insert a space or not. For convenience we create
;; an undo point if a space is needed, so the first undo only removes the space.
(defun dwim-paste--yank-handle (_property beg end)
  (let ((pre-regexes '(("\\([|=.,;><!?&]\\)$" . "\\1 ")
                       ("\\([\\])}]\\) +\\([,\\.]\\)$" . "\\1\\2")))
        (pos-regexes '(("^\\([|=<>&]\\)" . " \\1")))
        (rule-applied nil))
    ;; Create a undo checkpoint. We are going to remove it later if there was no
    ;; need for the extra space.
    (undo-boundary)
    (save-excursion
      (save-restriction

        ;; Check chars after the pasted text
        (narrow-to-region end (line-end-position))
        (goto-char end)
        (dolist (elt pos-regexes)
          (let ((regexp (car elt))
                (replacement (cdr elt)))
            (when (re-search-forward regexp nil t)
              (replace-match replacement)
              (setq rule-applied t))))

        (widen)

        ;; Check chars before the pasted text
        (narrow-to-region (line-beginning-position) beg)
        (goto-char beg)
        (dolist (elt pre-regexes)
          (let ((regexp (car elt))
                (replacement (cdr elt)))
            (when (re-search-backward regexp nil t)
              (replace-match replacement)
              (setq rule-applied t))))

        ;; If nothing happened, we remove the useless undo-boundary
        ;; created at the beginning.
        (when (not rule-applied)
          (setq buffer-undo-list (cdr buffer-undo-list)))))))

(setq default-text-properties '(dwim-paste--yank-handle t))

(push (cons 'dwim-paste--yank-handle #'dwim-paste--yank-handle)
      yank-handled-properties)


;;==================================================
;; User custom commands
;;
;; Mostly shortcuts for things I frequently use in
;; my daily job.
;;==================================================

(evil-define-operator ronie--copy-regex
  (beg end pattern register)
  :repeat nil
  :move-point nil
  :motion evil-line
  (interactive "<r></><a>")
  (message "register:%s" register)
  (save-excursion
    (save-match-data
      (save-restriction
        (narrow-to-region beg end)
        (goto-char (point-min))
        (let ((desired-register ?a))
          (evil-set-register desired-register "")
          (while (search-forward-regexp pattern nil t)
            (let* ((match-all (match-string 0))
                   (match-first (match-string 1))
                   (the-match (or match-first match-all)))
              (evil-append-register desired-register (concat the-match "\n")))))))))

(evil-ex-define-cmd "yy[ank]" #'ronie--copy-regex)


;; Symbol navigation
(evil-define-motion ronie--next-symbol (count)
  "Move the cursor to the beginning and end of symbols"
  :type inclusive
  (let ((boundaries (bounds-of-thing-at-point 'symbol)))
    (cond ((not boundaries)
           (forward-thing 'symbol 1)
           (beginning-of-thing 'symbol))
          ((= (point) (1- (cdr boundaries)))
           (forward-thing 'symbol 2)
           (beginning-of-thing 'symbol))
          ((= (point) (cdr boundaries))
           (forward-thing 'symbol 1)
           (beginning-of-thing 'symbol))
          (t
           (end-of-thing 'symbol)
           (backward-char)))))

(evil-define-motion ronie--previous-symbol (count)
  (let ((boundaries (bounds-of-thing-at-point 'symbol)))
    (cond ((not boundaries)
           (forward-thing 'symbol -1)
           (end-of-thing 'symbol)
           (backward-char))
          ((= (point) (cdr boundaries))
           (forward-thing 'symbol -1)
           (end-of-thing 'symbol)
           (backward-char))
          ((= (point) (car boundaries))
           (forward-thing 'symbol -1)
           (end-of-thing 'symbol)
           (backward-char))
          (t
           (beginning-of-thing 'symbol)))))

;; Prevent the command above from being repeated by "."
;; (They are just navigation)
(evil-declare-abort-repeat 'ronie--next-symbol)
(evil-declare-abort-repeat 'ronie--previous-symbol)


(map!
  :nv [right] #'ronie--next-symbol
  :nv [left] #'ronie--previous-symbol)


(defun ronie--align-contract ()
  (interactive)
  (require 'evil-indent-plus)
  (save-excursion
    (let* ((region (evil-indent-plus--same-indent-range))
           (beg (save-excursion (goto-char (nth 0 region)) (point-at-bol)))
           (end (save-excursion (goto-char (nth 1 region)) (point-at-eol))))
        (evil-lion-right 1 beg end ?:))))

(map! :leader
  (:prefix ("a" . "ronie")
    :desc "Align contract" "c" #'ronie--align-contract))
