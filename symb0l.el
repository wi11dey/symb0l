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

;; See README.org

;;; Code:

(eval-when-compile
  (require 'cl-lib))

(defgroup symb0l ()
  "Use top row of keyboard for symbols instead of numbers."
  :group 'editing)

(defvar-keymap symb0l-remappings
  :doc "Remappings of number keys to symbols"
  "1"             ?*
  "!"             ?1
  "2"             ?$
  "@"             ?2
  "3"             ?\M-\s
  "#"             ?3
  "4"             ?\{
  "$"             ?4
  "5"             ?\}
  "%"             ?5
  "6"             ?_
  "^"             ?6
  "7"             ?\\
  "&"             ?7
  "8"             ?\(
  "*"             ?8
  "9"             ?\)
  "("             ?\9
  "0"             ?&
  ")"             ?0
  "{"             ??
  "}"             ?!
  "\\"            ?^
  "_"             ?%
  "~"             ?#
  "?"             ?@
  "<f1>"          ?1
  "<f2>"          ?2
  "<f3>"          ?3
  "<f4>"          ?4
  "<f5>"          ?5
  "<f6>"          ?6
  "<f7>"          ?7
  "<f8>"          ?8
  "<f9>"          ?9
  "<f10>"         ?0
  "<f11>"         ?.
  "<kp-1>"        ?1
  "<kp-2>"        ?2
  "<kp-3>"        ?3
  "<kp-4>"        ?4
  "<kp-5>"        ?5
  "<kp-6>"        ?6
  "<kp-7>"        ?7
  "<kp-8>"        ?8
  "<kp-9>"        ?9
  "<kp-0>"        ?0
  "<kp-decimal>"  ?.
  "<kp-divide>"   ?/
  "<kp-multiply>" ?*
  "<kp-subtract>" ?-
  "<kp-add>"      ?+
  "<escape>"      ?~
  "<home>"        ?\C-g
  "<menu>"        ?\C-g
  "<apps>"        ?\C-g)

(defun symb0l-self-insert-command ()
  (interactive)
  (symb0l-map-mode -1)
  (add-hook 'pre-command-hook #'symb0l-map-mode)
  (push (lookup-key symb0l-remappings (this-command-keys)) unread-input-method-events))

(defconst symb0l-map
  (cl-loop with map = (make-sparse-keymap)
           for key being the key-codes of symb0l-remappings
           do (define-key map (vector key) #'symb0l-self-insert-command)
           finally return map)
  "Keymap for `symb0l-mode'.")

(define-minor-mode symb0l-map-mode
  nil
  :global t
  :keymap symb0l-map
  (when symb0l-map-mode
    (remove-hook 'pre-command-hook #'symb0l-map-mode)))

(defun symb0l-map-mode-enable (&rest args)
  (symb0l-map-mode 1))

(defun symb0l-read-passwd (oldfun &rest args)
  (symb0l-map-mode -1)
  (unwind-protect
      (apply oldfun args)
    (symb0l-map-mode 1)))

;;;###autoload
(define-minor-mode symb0l-mode
  nil
  :global t
  :keymap nil
  ;;;; Teardown
  (remove-hook 'pre-command-hook #'symb0l-map-mode)
  (advice-remove #'quail-add-unread-command-events #'symb0l-map-mode-enable)
  (advice-remove #'read-passwd #'symb0l-read-passwd)
  (symb0l-map-mode -1)
  (when symb0l-mode
    ;;;; Construction
    (advice-add #'read-passwd :around #'symb0l-read-passwd)
    (advice-add #'quail-add-unread-command-events :before #'symb0l-map-mode-enable)
    (symb0l-map-mode 1)))

(provide 'symb0l)

;;; symb0l.el ends here
