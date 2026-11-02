;;; bytesofpie.el -*- lexical-binding: t; -*-

(defun bytesofpie/kill-other-buffers ()
  "Kill all other buffers but the current one."
  (interactive)
  (dolist (buffer (buffer-list))
    (when (and (not (eq buffer (current-buffer)))
	       (buffer-file-name buffer))
      (kill-buffer buffer))))

(defun bytesofpie/hover ()
  "Show Flycheck diagnostics or documentation at point."
  (interactive)
  (if (and (bound-and-true-p flycheck-mode)
           (flycheck-overlay-errors-at (point)))
      (flycheck-display-error-at-point)
    (eldoc-box-help-at-point)))

(provide 'bytesofpie)
