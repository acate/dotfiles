;;    (setq mac-option-key-is-meta t)
;;    (setq mac-option-modifier 'meta)

(add-to-list 'load-path "~/.emacs.d/lisp/")

;; added 2014.9.30
;;(load-file "c:/graphviz-dot-mode.el")

;;Changed the next line to the line following it 2014.6.29
;;(cd "c:/Users/acate/Documents")
;; For office PC:
;;(setq default-directory "C:/Users/acate/Documents/")
;;(cd "C:/Users/acate/Documents/")

;; 2018-03-07 added by adc
;; To get better error messages
(setq debug-on-error t)

;; for UbuntuVM on Macbook; will fail if not running as su (2018.01.13 ??)
;; (2018.01.13 Was originally set to "/media/sf_acate/"
(setq default-directory "~/")

;;(cd "/media/sf_acate/")
(cd default-directory)

;; 2018.01.13 adc added, throwing caution to wind and using the functions that just seem right:
(setq ac_diary_file "~/Dropbox/anthony/writing/diary.txt")
;; uncomment if problem with "custom set variables" definition of initial-buffer-choice:
(setq initial-buffer-choice "~/Dropbox/work/science.txt")

;; 2018.01.13 adc added to (finally -- long-time goal!) automatically open commonly-used file and put point at end.
;; With help from https://learnxinyminutes.com/docs/elisp/
;; Decided to put science.txt last so that diary.txt will not be visible over my shoulder when starting emacs.
;; Again: yay!

(progn
  (find-file ac_diary_file)
  (end-of-buffer)
  (find-file initial-buffer-choice)
  (end-of-buffer))



;; adc added 2017.07.17
(add-hook 'org-mode-hook 'toggle-truncate-lines)

(put 'downcase-region 'disabled nil)

(put 'upcase-region 'disabled nil)

;; adc added 2015.11.29
(show-paren-mode 1)

;; adc added 2018-04-02
;; (add-hook 'text-mode-hook 'disable-theme) ;; DOESN'T WORK 2018-04-02-12:15
   

;; adc added 2015.1.7 based on http://comments.gmane.org/gmane.emacs.nxml.general/2015
;; only a problem for Windows office PC
;; works on office PC!
;;(global-set-key [C-return] 'completion-at-point)

;; adc added on 2015.8.20 based on
;; https://stackoverflow.com/questions/251908/how-can-i-insert-current-date-and-time-into-a-file-using-emacs
;; ====================
;; insert date and time

(defvar current-date-time-format "%Y-%m-%d-%H:%M"
  "Format of date to insert with `insert-current-date-time' func
See help of `format-time-string' for possible replacements")

(defvar current-date-format "%Y-%m-%d"
  "Format of date to insert with `insert-current-date' func.
Note the weekly scope of the command's precision.")

(defun insert-current-date-time ()
  "insert the current date and time into current buffer.
Uses `current-date-time-format' for the formatting the date/time."
       (interactive)
;       (insert "==========\n")
;       (insert (let () (comment-start)))
       (insert (format-time-string current-date-time-format (current-time)))
;       (insert "\n")
       )

(defun insert-current-date ()
  "insert the current date into the current buffer."
       (interactive)
       (insert (format-time-string current-date-format (current-time)))
;       (insert "\n")
       )

(global-set-key (kbd "C-c t") 'insert-current-date-time)
(global-set-key (kbd "C-c d") 'insert-current-date)

;; adc wrote this 2015.9.3 
(defun insert-end-tag ()
  "Insert an xml close tag to match last unclosed open tag, at the current point (AC custom function)."
  (interactive)
  (save-excursion  ; this restores point to orig. location before inserting
    (re-search-backward "^<\\([^/].*\\)>")
   )
  (insert (concat "\n\n\n</" (match-string 1) ">\n"))
  ;; move point back (up) this many lines
  (forward-line -3)
  )

(global-set-key (kbd "C-c x") 'insert-end-tag)

;; adc wrote this 2017.02.21
(defun pandoc-replace-with-underscores ()
  "Replace all characters between pairs of double asterisks with same number of underscores (AC custom function)."
  (interactive)
(replace-regexp "\\*\\*\\([[:alnum:][:space:]-)(!.&?'\"=+]+\\)\\*\\*" (quote (replace-eval-replacement concat "**" (replace-quote (replace-regexp-in-string "." "_" (match-string 1))) "**")) nil )
)

;; adc added 2017.07.17
;; from https://stackoverflow.com/questions/22313198/changing-margin-for-emacs-text-mode
;; (defun ac-set-margins ()
;;   "Set margins in current buffer."
;;   (setq left-margin-width 3)
;;   (setq right-margin-width 3)
;;   )

;; (add-hook 'org-mode-hook 'ac-set-margins)


;; adc added 2019-03-20
;; from https://www.emacswiki.org/emacs/KillMatchingLines
(defun kill-matching-lines (regexp &optional rstart rend interactive)
  "Kill lines containing matches for REGEXP.

See `flush-lines' or `keep-lines' for behavior of this command.

If the buffer is read-only, Emacs will beep and refrain from deleting
the line, but put the line in the kill ring anyway.  This means that
you can use this command to copy text from a read-only buffer.
\(If the variable `kill-read-only-ok' is non-nil, then this won't
even beep.)"
  (interactive
   (keep-lines-read-args "Kill lines containing match for regexp"))
  (let ((buffer-file-name nil)) ;; HACK for `clone-buffer'
    (with-current-buffer (clone-buffer nil nil)
      (let ((inhibit-read-only t))
        (keep-lines regexp rstart rend interactive)
        (kill-region (or rstart (line-beginning-position))
                     (or rend (point-max))))
      (kill-buffer)))
  (unless (and buffer-read-only kill-read-only-ok)
    ;; Delete lines or make the "Buffer is read-only" error.
    (flush-lines regexp rstart rend interactive)))


 ;; for linux/mac: (add-to-list 'load-path "~/")
  ;; for Windows:
  ;;Changed the next line to the line following it 2014.6.29
  ;;(add-to-list 'load-path "C:/Users/acate/")
  ;;(add-to-list 'load-path "~/")
 (autoload 'matlab-mode "matlab" "Matlab Editing Mode" t)
 (add-to-list
  'auto-mode-alist
  '("\\.m$" . matlab-mode))
 (setq matlab-indent-function t)
 (setq matlab-shell-command "matlab")

;; adc added 2017.03.12
;; from https://www.emacswiki.org/emacs/RecentFiles
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)

;; adc added 2018.01.03
;; From http://melpa.milkbox.net/#/getting-started
(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;; adc added 2018-12-20
;; via melpa
(require 'ac-octave)
(add-hook 'octave-mode-hook
          '(lambda () (ac-octave-setup)))

;; adc added 2018-12-22
;; via melpa
(require 'ess-r-mode)


(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(graphviz-dot-dot-program "dot")
 '(initial-buffer-choice "~/Dropbox/work/science.txt")
 '(package-selected-packages
   (quote
    (## elpy graphviz-dot-mode ac-octave ess tiny ranger markdown-mode)))
 '(show-paren-mode t)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


;; adc added 2019-11-28:
(elpy-enable)
(setq elpy-rpc-virtualenv-path 'current)

;; for elpy autocompletion, adc added 2019-11-28
;; from website: https://github.com/jorgenschaefer/elpy/issues/1359
(add-hook 'elpy-mode-hook
(lambda ()
(set (make-local-variable 'company-backends)
'((company-dabbrev-code company-yasnippet elpy-company-backend)))))
