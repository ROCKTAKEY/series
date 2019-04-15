;;; series.el --- Multiple functions in continuous execution.  -*- lexical-binding: t; -*-

;; Copyright (C) 2019  ROCKTAKEY

;; Author: ROCKTAKEY <rocktakey@gmail.com>
;; Keywords: tools

;; Version: 0.0.0
;; Package-Requires:
;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;;

;;; Code:

(defgroup series nil
  "Series group."
  :group 'tools)

(defvar series-count 1)

(defun series-monitoring ()
  "Monitor `last-command'."
  (setq series-count
        (if (eq last-command this-command)
            (1+ series-count)
          1)))

(add-hook 'pre-command-hook 'series-monitoring)




(defvar series--mark-history nil)

(cl-defmacro series-defun (function-name &optional docstring &rest functions)
  ""
  (declare (doc-string 2) (indent defun))
  (unless (stringp docstring)
    (setq functions (cons docstring functions))
    (setq docstring ""))
  `(defun ,function-name ()
     ,docstring
     (interactive)
     (when (eq series-count 1)
       (setq series--mark-history (mark)))
     (call-interactively
      (nth
       (mod (1- series-count)
            ,(length functions))
       ',functions))))

(defun series-return ()
  "Return first position."
  (goto-char series--mark-history))

(provide 'series)
;;; series.el ends here
