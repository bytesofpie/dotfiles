;;; bytesofpie.el -*- lexical-binding: t; -*-

(defun bytesofpie/kill-other-buffers ()
  "Kill all other buffers but the current one."
  (interactive)
  (dolist (buffer (buffer-list))
    (when (and (not (eq buffer (current-buffer)))
	       (buffer-file-name buffer))
      (kill-buffer buffer))))

(provide 'bytesofpie)
