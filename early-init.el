;;; early-init.el --- Early Init -*- lexical-binding: t; -*-

;;; Garbage collection ;;;;
;; Temporarily increase the garbage collection threshold. These
;; changes help shave off about half a second of startup time. The
;; `most-positive-fixnum' is DANGEROUS AS A PERMANENT VALUE.
(setq gc-cons-threshold most-positive-fixnum
      gc-cons-percentage 0.5)

(add-hook 'emacs-startup-hook
          (lambda ()
            (setq gc-cons-threshold (* 100 100 8)
                  gc-cons-percentage 0.1
		  read-process-output-max (* 1024 1024))))

;;; Compilation ;;;
(setq package-native-compile t ; natively compile packages as part of their installation
      native-comp-async-query-on-exit t ; ask for confirmation when comp is running
      load-prefer-newer t ; prefer newer compiled files
      )

;;; Directories ;;;
(setq custom-theme-directory
      (expand-file-name "themes/" user-emacs-directory)
      custom-file
      (expand-file-name "custom.el" user-emacs-directory)
      auto-save-list-file-prefix
      (expand-file-name "autosave/" user-emacs-directory)
      tramp-auto-save-directory
      (expand-file-name "tramp-autosave/" user-emacs-directory))

;;; Performance: Miscellaneous options ;;;

;; In PGTK, this timeout introduces latency. Reducing it from the default 0.1
;; improves responsiveness of childframes and related packages.
(when (boundp 'pgtk-wait-for-event-timeout)
  (setq pgtk-wait-for-event-timeout 0.001))
;; Disable warnings from the legacy advice API. They aren't useful.
(setq ad-redefinition-action 'accept)

;; Font compacting can be very resource-intensive, especially when rendering
;; icon fonts on Windows. This will increase memory usage.
(setq inhibit-compacting-font-caches t)

(when (and (not (daemonp)) (not noninteractive))
  ;; Resizing the Emacs frame can be costly when changing the font. Disable this
  ;; to improve startup times with fonts larger than the system default.
  (setq frame-resize-pixelwise t)

  ;; Without this, Emacs will try to resize itself to a specific column size
  (setq frame-inhibit-implied-resize t)

  ;; A second, case-insensitive pass over `auto-mode-alist' is time wasted.
  ;; No second pass of case-insensitive search over auto-mode-alist.
  (setq auto-mode-case-fold nil)

  ;; Reduce *Message* noise at startup. An empty scratch buffer (or the
  ;; dashboard) is more than enough, and faster to display.
  (setq inhibit-startup-screen t
        inhibit-startup-echo-area-message user-login-name
	inhibit-startup-buffer-menu t
        inhibit-x-resources t)

  ;; Disable bidirectional text scanning for a modest performance boost.
  (setq-default bidi-display-reordering 'left-to-right
                bidi-paragraph-direction 'left-to-right)

  ;; Give up some bidirectional functionality for slightly faster re-display.
  (setq bidi-inhibit-bpa t)

  ;; Suppress the vanilla startup screen completely. 
  (advice-add 'display-startup-screen :override #'ignore)
  )


;;; Disabling useless aesthetics ;;;

;; Disable startup screens and messages
(setq inhibit-splash-screen t)

;; menu-bar
(push '(menu-bar-lines . 0) default-frame-alist)
(setq menu-bar-mode nil)

;; tool-bar
(when (and (not (daemonp))
           (not noninteractive))
  (when (fboundp 'tool-bar-setup)
    ;; Temporarily override the tool-bar-setup function to prevent it from
    ;; running during the initial stages of startup
    (advice-add 'tool-bar-setup :override #'ignore)
    ))
(push '(tool-bar-lines . 0) default-frame-alist)
(setq tool-bar-mode nil)

;; scroll-bar
(setq default-frame-scroll-bars 'right)
(push '(vertical-scroll-bars) default-frame-alist)
(push '(horizontal-scroll-bars) default-frame-alist)
(setq scroll-bar-mode nil)


;;; Security ;;;
(setq gnutls-verify-error t)  ; Prompts user if there are certificate issues
(setq tls-checktrust t)  ; Ensure SSL/TLS connections undergo trust verification
(setq gnutls-min-prime-bits 3072)  ; Stronger GnuTLS encryption

;;; use-package ;;;
(setq use-package-enable-imenu-support t)

(setq package-archives '(("melpa"        . "https://melpa.org/packages/")
                         ("gnu"          . "https://elpa.gnu.org/packages/")
                         ("nongnu"       . "https://elpa.nongnu.org/nongnu/")
                         ("melpa-stable" . "https://stable.melpa.org/packages/")))

(setq package-archive-priorities '(("gnu"    . 99)
                                   ("nongnu" . 80)
                                   ("melpa"  . 70)
                                   ("melpa-stable" . 50)))
