;;; init.el --- Init -*- lexical-binding: t; -*-

;; Literate config
(require 'org)
(require 'org-tempo)
(org-babel-load-file
 (expand-file-name
  "config.org"
  user-emacs-directory))

;; battery and date on tty
(unless (display-graphic-p)
  (display-time-mode t)
  (display-battery-mode t)
  (menu-bar-mode t)
  )

;; some modes
(delete-selection-mode 1)
(setq auth-source-save-behavior nil ; auth-source never saves
      line-number-mode t
      column-number-mode t)

;; Allow for shorter responses: "y" for yes and "n" for no.
(setq read-answer-short t)
(if (boundp 'use-short-answers)
    (setq use-short-answers t)
  (advice-add 'yes-or-no-p :override #'y-or-n-p))

;; Undo/redo
(setq undo-limit (* 13 160000)
      undo-strong-limit (* 13 240000)
      undo-outer-limit (* 13 24000000))

;;; Minibuffer
;; Invoke commands that use minibuffers even when the minibuffer is active
(setq enable-recursive-minibuffers t)

;; Keep the cursor out of the read-only portions of the minibuffer
(setq minibuffer-prompt-properties
      '(read-only t intangible t cursor-intangible t face minibuffer-prompt))
(add-hook 'minibuffer-setup-hook #'cursor-intangible-mode)

;; No beeping or blinking
(setq ring-bell-function #'ignore)

;; remote cache
(setq remote-file-name-inhibit-cache 50)

;; This setting forces Emacs to save bookmarks immediately after each change.
(setq bookmark-save-flag 1)

;; Prefer vertical splits over horizontal ones
(setq split-width-threshold 170
      split-height-threshold nil)

;; comint (general command interpreter in a window)
(setq comint-prompt-read-only t
      comint-buffer-maximum-size 4096)

;; compilation
;; (setq compilation-scroll-output 'first-error)

;;; Backup files
;; Avoid backups or lockfiles to prevent creating world-readable copies of files
(setq create-lockfiles nil
      make-backup-files nil)

(setq backup-directory-alist
      `(("." . ,(expand-file-name "backup" user-emacs-directory)))
      backup-by-copying-when-linked t ; copying to create backups for files with multiple names.
      backup-by-copying t  ; Backup by copying rather renaming
      delete-old-versions t  ; Delete excess backup versions silently
      version-control t  ; Use version numbers for backup files
      kept-new-versions 5
      kept-old-versions 5)

;;; Buffer
(setq uniquify-buffer-name-style 'forward) ; different files with equal names

;;; VC
(setq vc-make-backup-files nil)  ; Do not backup version controlled files

;;; Auto save
;; Enable auto-save to safeguard against crashes or data loss. The
;; `recover-file' or `recover-session' functions can be used to restore
;; auto-saved data.
(setq auto-save-default nil
      auto-save-no-message t)

;; Auto save options
(setq kill-buffer-delete-auto-save-files t)

;; Remove duplicates from the kill ring to reduce clutter
(setq kill-do-not-save-duplicates t)

;;; Auto revert
;; Auto-revert in Emacs is a feature that automatically updates the contents of
;; a buffer to reflect changes made to the underlying file.
(setq revert-without-query (list "."))  ; Do not prompt

;; Revert other buffers (e.g, Dired)
(setq global-auto-revert-non-file-buffers t)
(setq global-auto-revert-ignore-modes '(Buffer-menu-mode))

;;; recentf

;; `recentf' is an that maintains a list of recently accessed files.
(setq recentf-max-saved-items 300) ; default is 20
(setq recentf-max-menu-items 15)
(setq recentf-auto-cleanup 'mode)
(setq recentf-exclude nil)

;;; saveplace

;; Enables Emacs to remember the last location within a file upon reopening.
(setq save-place-file (expand-file-name "saveplace" user-emacs-directory))

;;; savehist

;; `savehist-mode' is an Emacs feature that preserves the minibuffer history
;; between sessions.
(setq history-length 300)
(setq savehist-additional-variables
      '(kill-ring                        ; clipboard
        register-alist                   ; macros
        mark-ring global-mark-ring       ; marks
        search-ring regexp-search-ring)) ; searches

;;; Frames and windows

;; The native border "uses" a pixel of the fringe on the rightmost
;; splits, whereas `window-divider-mode' does not.
(setq window-divider-default-bottom-width 1
      window-divider-default-places t
      window-divider-default-right-width 1)

;;; Fontification

;; Disable fontification during user input to reduce lag in large buffers.
;; Also helps marginally with scrolling performance.
(setq redisplay-skip-fontification-on-input t)

;;; Scrolling

;; Precision
;;(pixel-scroll-precision-mode 0)

;; Enables faster scrolling. This may result in brief periods of inaccurate
;; syntax highlighting, which should quickly self-correct.
(setq fast-but-imprecise-scrolling t)

;; Move point to top/bottom of buffer before signaling a scrolling error.
(setq scroll-error-top-bottom t)

;; Keep screen position if scroll command moved it vertically out of the window.
(setq scroll-preserve-screen-position t)

;; Emacs recenters the window when the cursor moves past `scroll-conservatively'
;; lines beyond the window edge. A value over 101 disables recentering; the
;; default (0) is too eager. Here it is set to 20 for a balanced behavior.
(setq scroll-conservatively 106)

;; 1. Preventing automatic adjustments to `window-vscroll' for long lines.
;; 2. Resolving the issue of random half-screen jumps during scrolling.
(setq auto-window-vscroll nil)

;; Number of lines of margin at the top and bottom of a window.
(setq scroll-margin 0)

;; Number of lines of continuity when scrolling by screenfuls.
(setq next-screen-context-lines 0)

;; Horizontal scrolling
(setq hscroll-margin 2
      hscroll-step 1)

;;; Context menu
(when (and (display-graphic-p) (fboundp 'context-menu-mode))
  (add-hook 'after-init-hook #'context-menu-mode))

;;; Cursor

;; The blinking cursor is distracting and interferes with cursor settings in
;; some minor modes that try to change it buffer-locally (e.g., Treemacs).
(when (bound-and-true-p blink-cursor-mode)
  (blink-cursor-mode -1))

;; Don't blink the paren matching the one at point, it's too distracting.
(setq blink-matching-paren nil)

;; Reduce rendering/line scan work by not rendering cursors or regions in
;; non-focused windows.
(setq-default cursor-in-non-selected-windows nil)
(setq highlight-nonselected-windows nil)


;;; Text editing, indent, font, and formatting

;; Avoid automatic frame resizing when adjusting settings.
(setq global-text-scale-adjust-resizes-frames nil)

;; A longer delay can be annoying as it causes a noticeable pause after each
;; deletion, disrupting the flow of editing.
(setq delete-pair-blink-delay 0.03)

;;;;;;;;
(setq-default truncate-lines t)
;; If enabled and `truncate-lines' is disabled, soft wrapping will not occur
;; when the window is narrower than `truncate-partial-width-windows' characters.
(setq truncate-partial-width-windows nil)

;; Configure automatic indentation to be triggered exclusively by newline and
;; DEL (backspace) characters.
;;(setq-default electric-indent-chars '(?\n ?\^?))

;; Enable indentation and completion using the TAB key
;; (setq tab-always-indent 'complete)
;; (setq tab-first-completion 'word-or-paren-or-punct)

;; Perf: Reduce command completion overhead.
(setq read-extended-command-predicate #'command-completion-default-include-p)

;; Disable the obsolete practice of end-of-line spacing from the typewriter era.
(setq sentence-end-double-space nil)

;; According to the POSIX, a line is defined as "a sequence of zero or more
;; non-newline characters followed by a terminating newline".
(setq require-final-newline t)

;; Eliminate delay before highlighting search matches
(setq lazy-highlight-initial-delay 0)

;;; Filetype
;; Do not notify the user each time Python tries to guess the indentation offset
(setq python-indent-guess-indent-offset-verbose nil)

;;; Dired and ls-lisp

(setq dired-free-space nil
      dired-dwim-target t  ; Propose a target for intelligent moving/copying
      ;;dired-deletion-confirmer 'y-or-n-p
      ;;dired-filter-verbose nil
      dired-recursive-deletes 'top
      dired-recursive-copies 'always
      dired-vc-rename-file t
      dired-create-destination-dirs 'ask
      ;; Suppress Dired buffer kill prompt for deleted dirs
      dired-clean-confirm-killing-deleted-buffers nil)

(setq auto-revert-remote-files nil)
(setq dired-auto-revert-buffer 'dired-buffer-stale-p)

;; dired-omit-mode
(setq dired-omit-verbose nil)

;; (setq ls-lisp-verbosity nil)
;; (setq ls-lisp-dirs-first t)

;;; Ediff

;; Configure Ediff to use a single frame and split windows horizontally
(setq ediff-window-setup-function 'ediff-setup-windows-plain
      ediff-split-window-function 'split-window-horizontally)

;;; Help

;; Enhance `apropos' and related functions to perform more extensive searches
(setq apropos-do-all t)

;; Prevents help command completion from triggering autoload.
;; Loading additional files for completion can slow down help commands and may
;; unintentionally execute initialization code from some libraries.
(setq help-enable-completion-autoload nil
      help-enable-autoload nil
      help-enable-symbol-autoload nil
      help-window-select t)  ;; Focus new help windows when opened

;;; Eglot

;; A setting of nil or 0 means Eglot will not block the UI at all, allowing
;; Emacs to remain fully responsive, although LSP features will only become
;; available once the connection is established in the background.
(setq eglot-sync-connect 0 ; don't block ui
      eglot-autoshutdown t ; Shut down server after killing last managed buffer
      eglot-extend-to-xref t)

;;; Flymake
(setq flymake-show-diagnostics-at-end-of-line nil
      flymake-wrap-around nil)

;;; hl-line-mode
; highlight current line

;; Restrict `hl-line-mode' highlighting to the current window, reducing visual
;; clutter and slightly improving `hl-line-mode' performance.
(setq hl-line-sticky-flag nil)
(setq global-hl-line-sticky-flag nil)

;; Improves flyspell performance by preventing messages from being displayed for
;; each word when checking the entire buffer.
(setq flyspell-issue-message-flag nil)

;;; ispell

;; Disable Ispell completion to avoid annotation errors
;; when no `ispell' dictionary is set.
(setq text-mode-ispell-word-completion nil)

;;; xref

;; Enable completion in the minibuffer instead of the definitions buffer
(setq xref-show-definitions-function 'xref-show-definitions-completing-read
      xref-show-xrefs-function 'xref-show-definitions-completing-read)

;;; abbrev

;; Ensure `abbrev_defs` is stored in the correct location when
;; `user-emacs-directory` is modified, as it defaults to ~/.emacs.d/abbrev_defs
;; regardless of the change.
(setq abbrev-file-name (expand-file-name "abbrev_defs" user-emacs-directory))
(setq save-abbrevs 'silently)

;; eldoc
(setq eldoc-echo-area-use-multiline-p nil
      eldoc-echo-area-prefer-doc-buffer t)
