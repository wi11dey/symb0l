;;; symb0l.el --- Use top row of keyboard for symbols instead of numbers -*- lexical-binding: t -*-

;; Author: Will Dey
;; Maintainer: Will Dey
;; Version: 1
;; Package-Requires: ()
;; Homepage: homepage
;; Keywords: editing


;; This file is not part of GNU Emacs

;; This program is free software: you can redistribute it and/or modify
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

;; commentary

;;; Code:

(defgroup symb0l ()
  "Use top row of keyboard for symbols instead of numbers."
  :group 'editing)

(defun symb0l--on ()
  (remove-hook 'pre-command-hook #'symb0l--on)
  (internal-push-keymap symb0l-map 'overriding-terminal-local-map))

(defun symb0l--off ()
  (internal-pop-keymap symb0l-map 'overriding-terminal-local-map))

(defmacro symb0l--unread (event)
  `(lambda ()
     ,(format-message "Equivalent to pressing `%s'." (key-description (vector event)))
     (interactive)
     (symb0l--off)
     (add-hook 'pre-command-hook #'symb0l--on)
     (push ',event unread-input-method-events)))

(defconst symb0l-map
  (let ((map (make-sparse-keymap)))
    (define-key map "1"      (symb0l--unread ?*))
    (define-key map "!"      (symb0l--unread ?1))
    (define-key map "2"      (symb0l--unread ?$))
    (define-key map "@"      (symb0l--unread ?2))
    (define-key map "3"      (symb0l--unread S-menu))
    (define-key map "#"      (symb0l--unread ?3))
    (define-key map "4"      (symb0l--unread ?\{))
    (define-key map "$"      (symb0l--unread ?4))
    (define-key map "5"      (symb0l--unread ?\}))
    (define-key map "%"      (symb0l--unread ?5))
    (define-key map "6"      (symb0l--unread ?_))
    (define-key map "^"      (symb0l--unread ?6))
    (define-key map "7"      (symb0l--unread ?\\))
    (define-key map "&"      (symb0l--unread ?7))
    (define-key map "8"      (symb0l--unread ?\())
    (define-key map "*"      (symb0l--unread ?8))
    (define-key map "9"      (symb0l--unread ?\)))
    (define-key map "("      (symb0l--unread ?\9))
    (define-key map "0"      (symb0l--unread ?&))
    (define-key map ")"      (symb0l--unread ?0))
    (define-key map "{"      (symb0l--unread ??))
    (define-key map "}"      (symb0l--unread ?!))
    (define-key map "\\"     (symb0l--unread ?^))
    (define-key map "_"      (symb0l--unread ?%))
    (define-key map "~"      (symb0l--unread ?#))
    (define-key map "?"      (symb0l--unread ?@))
    (define-key map [ f1]    (symb0l--unread ?1))
    (define-key map [ f2]    (symb0l--unread ?2))
    (define-key map [ f3]    (symb0l--unread ?3))
    (define-key map [ f4]    (symb0l--unread ?4))
    (define-key map [ f5]    (symb0l--unread ?5))
    (define-key map [ f6]    (symb0l--unread ?6))
    (define-key map [ f7]    (symb0l--unread ?7))
    (define-key map [ f8]    (symb0l--unread ?8))
    (define-key map [ f9]    (symb0l--unread ?9))
    (define-key map [f10]    (symb0l--unread ?0))
    (define-key map [f11]    (symb0l--unread ?.))
    (define-key map [escape] (symb0l--unread ?~))
    (define-key map [home]   (symb0l--unread ?\C-g))
    (define-key map [menu]   (symb0l--unread ?\C-g))
    (define-key map [apps]   (symb0l--unread ?\C-g))
    map)
  "Keymap for `symb0l-mode'.")

;;;###autoload
(define-minor-mode symb0l-mode
  nil
  :global t
  :keymap nil
  ;;;; Teardown
  (remove-hook 'pre-command-hook #'symb0l--on)
  (symb0l--off)
  (when symb0l-mode
    ;;;; Construction
    (symb0l--on)))

(provide 'symb0l)

;;; symb0l.el ends here
