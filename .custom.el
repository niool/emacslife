;; Please note the color theme's name is "molokai"
(when (or (display-graphic-p)
          (string-match-p "256color"(getenv "TERM")))
  (load-theme 'molokai t))

;; ============================================================================
;; Set all coding global parameter to utf-8
;; Fix issue "Bad file encoding" in MobileOrg
(prefer-coding-system       'utf-8)
(set-default-coding-systems 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(setq default-buffer-file-coding-system 'utf-8)

;; ============================================================================
;; Org mode
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(auto-raise-tool-bar-buttons t t)
 '(auto-resize-tool-bars t t)
 '(calendar-week-start-day 1)
 '(case-fold-search t)
 '(make-backup-files nil)
 '(normal-erase-is-backspace t)
 '(org-agenda-files (quote ("c:/Emacs/mybook/org/MyGTD.org" "c:/Emacs/mybook/org/myagendas.org" )))
 '(org-agenda-ndays 7)
 '(org-agenda-repeating-timestamp-show-all nil)
 '(org-agenda-restore-windows-after-quit t)
 '(org-agenda-show-all-dates t)
 '(org-agenda-skip-deadline-if-done t)
 '(org-agenda-skip-scheduled-if-done t)
 '(org-agenda-sorting-strategy (quote ((agenda time-up priority-down tag-up) (todo tag-up))))
 '(org-agenda-start-on-weekday nil)
 '(org-agenda-todo-ignore-deadlines t)
 '(org-agenda-todo-ignore-scheduled t)
 '(org-agenda-todo-ignore-with-date t)
 '(org-agenda-window-setup (quote other-window))
 '(org-deadline-warning-days 7)
 '(org-export-html-style "<link rel=\"stylesheet\" type=\"text/css\" href=\"mystyles.css\">")
 '(org-fast-tag-selection-single-key nil)
 '(org-log-done (quote (done)))
 '(org-refile-targets (quote (("newgtd.org" :maxlevel . 1) ("someday.org" :level . 2))))
 '(org-reverse-note-order nil)
 '(org-tags-column -78)
 '(org-tags-match-list-sublevels nil)
 '(org-time-stamp-rounding-minutes 5)
 '(org-use-fast-todo-selection t)
 '(org-use-tag-inheritance nil))
; '(unify-8859-on-encoding-mode t nil (ucs-tables)))

;; Following directory is on my home drive
;(setq load-path (append load-path (list "L:/elisp")))

;; Highlight text chosen in with Mark region
(transient-mark-mode t)

; Save files in DOS mode
(setq-default buffer-file-coding-system 'raw-text-dos)

(setq default-major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

; dont use tabs for indenting
(setq-default indent-tabs-mode nil)
(setq-default tab-width 3)

;; These lines only if org-mode is not part of the X/Emacs distribution.
(autoload 'org-mode "org" "Org mode" t)
(autoload 'org-diary "org" "Diary entries from Org mode")
(autoload 'org-agenda "org" "Multi-file agenda from Org mode" t)
(autoload 'org-store-link "org" "Store a link to the current location" t)
(autoload 'orgtbl-mode "org" "Org tables as a minor mode" t)
(autoload 'turn-on-orgtbl "org" "Org tables as a minor mode")

(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)

(setq org-log-done nil)
(setq org-agenda-include-diary nil)
(setq org-deadline-warning-days 7)
(setq org-timeline-show-empty-dates t)
(setq org-insert-mode-line-in-empty-file t)

(setq org-directory "c:/Emacs/mybook/org/")


;; ============================================================================
;; Org-Capture mode
(define-key global-map "\C-cc" 'org-capture)
(setq org-capture-templates nil)

(add-to-list 'org-capture-templates
             '("n" "Notes" entry (file "c:/Emacs/mybook/org/inbox.org")
               "* %^{heading} %t %^g\n  %?\n"))
(add-to-list 'org-capture-templates
             '("j" "Journal" entry (file "c:/Emacs/mybook/org/journals.org")
               "* %U - %^{heading}\n  %?"))
(add-to-list 'org-capture-templates
             '("i" "Inbox" entry (file "c:/Emacs/mybook/org/inbox.org")
               "* %U - %^{heading} %^g\n %?\n"))

(add-to-list 'org-capture-templates
             '("r" "Book Reading Task" entry
               (file+olp "c:/Emacs/mybook/org/MyGTD.org" "Reading" "Book")
               "* TODO %^{Book Name}\n%u\n%a\n" :clock-in t :clock-resume t))
(add-to-list 'org-capture-templates
             '("t" "Work Task" entry
               (file+headline "c:/Emacs/mybook/org/MyGTD.org" "Capture Tasks")
               "* TODO %^{Task Name}\n\tCreated:%u\n%a\n" :clock-in t :clock-resume t))

(add-to-list 'org-capture-templates
             '("b" "Billing" plain
               (file+function "c:/Emacs/mybook/org/billing.org" find-month-tree)
               " | %U | %^{类别} | %^{描述} | %^{金额} |" :kill-buffer t))

(defun get-year-and-month ()
  (list (format-time-string "%Y年") (format-time-string "%m月")))

(defun find-month-tree ()
  (let* ((path (get-year-and-month))
         (level 1)
         end)
    (unless (derived-mode-p 'org-mode)
      (error "Target buffer \"%s\" should be in Org mode" (current-buffer)))
    (goto-char (point-min))             ;移动到 buffer 的开始位置
    ;; 先定位表示年份的 headline，再定位表示月份的 headline
    (dolist (heading path)
      (let ((re (format org-complex-heading-regexp-format
                        (regexp-quote heading)))
            (cnt 0))
        (if (re-search-forward re end t)
            (goto-char (point-at-bol))  ;如果找到了 headline 就移动到对应的位置
          (progn                        ;否则就新建一个 headline
            (or (bolp) (insert "\n"))
            (if (/= (point) (point-min)) (org-end-of-subtree t t))
            (insert (make-string level ?*) " " heading "\n"))))
      (setq level (1+ level))
      (setq end (save-excursion (org-end-of-subtree t t))))
    (org-end-of-subtree)))

(setq org-default-notes-file (concat org-directory "/inbox.org"))

;; ============================================================================
;; Org-Agenda mode
(setq org-agenda-exporter-settings
      '((ps-number-of-columns 1)
        (ps-landscape-mode t)
        (htmlize-output-type 'css)))

(setq org-agenda-custom-commands
'(

("P" "Projects"
((tags "PROJECT")))

("H" "Office and Home Lists"
     ((agenda)
          (tags-todo "OFFICE")
          (tags-todo "HOME")
          (tags-todo "COMPUTER")
          (tags-todo "DVD")
          (tags-todo "READING")))

("D" "Daily Action List"
     (
          (agenda "" ((org-agenda-ndays 1)
                      (org-agenda-sorting-strategy
                       (quote ((agenda time-up priority-down tag-up) )))
                      (org-deadline-warning-days 0)
                      ))))
)
)

(defun gtd ()
    (interactive)
    (find-file "c:/Emacs/mybook/org/MyGTD.org")
)
(global-set-key (kbd "C-c g") 'gtd)

(add-hook 'org-agenda-mode-hook 'hl-line-mode)

; org mode start - added 20 Feb 2006
;; The following lines are always needed. Choose your own keys.

(global-font-lock-mode t)

(global-set-key "\C-x\C-r" 'prefix-region)
(global-set-key "\C-x\C-l" 'goto-line)
(global-set-key "\C-x\C-y" 'copy-region-as-kill)

 ;; Changes all yes/no questions to y/n type
(fset 'yes-or-no-p 'y-or-n-p)

;; ============================================================================
;; MobileOrg Configuration
;; https://blog.csdn.net/lujun9972/article/details/46002799

(setq org-mobile-directory "c:/Emacs/syncdirs/org")
(setq org-mobile-files (list "c:/Emacs/mybook/org/MyGTD.org"
                             "c:/Emacs/mybook/org/myagendas.org" ))

;; 当要把MobileOrg所做的修改同步到电脑端Org时,电脑端Org会先把MobileOrg的修改动作记录到该变量指定的文件中,然后再根据该文件中所记录的操作对电脑端Org进行修改
(setq org-mobile-inbox-for-pull "c:/Emacs/mybook/org/inbox.org")

(defcustom org-mobile-checksum-binary (or (executable-find "c:/emacs/bin/md5sums.exe"))
 "Executable used for computing checksums of agenda files."
 :group 'org-mobile
 :type 'string)
