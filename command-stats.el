;;; command-stats.el --- command stats

;; Author: 0xsuk
;; Version: 1.0
;; URL: https://github.com/0xsuk/command-stats.el

;;; Commentary:
;;; command stats

;;; Code:
(require 'cl-lib)

(defvar command-stats--alist '())

(defun command-stats--handler (&optional cmd)
  "Hook into `pre-command-hook' to intercept command."
  (setq cmd (or cmd this-command))
  (if-let* ((entry (assoc cmd command-stats--alist))
        (count (cdr entry)))
      (setcdr entry (1+ count))
    (add-to-list 'command-stats--alist (cons cmd 1))
    )
  )

(defun command-stats--sort-alist ()
	(sort command-stats--alist (lambda (a b) (> (cdr a) (cdr b)))))

(defun command-stats-print-stats ()
  "Print command-stats--alist"
  (interactive)
  (with-current-buffer (get-buffer-create "*command-stats*")
    (erase-buffer)
    (cl-loop for (command . count) in (command-stats--sort-alist) do
             (insert (format "%s :%6d\n" command count))))
  (display-buffer "*command-stats*")
  )

(defun command-stats-restart ()
  "restart command-stats"
  (interactive)
  (remove-hook 'pre-command-hook 'command-stats--handler)
  (add-hook 'pre-command-hook 'command-stats--handler)
  (message "command-stats restarted")
  )

(provide 'command-stats)

;;; command-stats ends here
