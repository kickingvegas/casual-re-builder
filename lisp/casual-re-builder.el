;;; casual-re-builder.el --- Transient UI for RE-Builder -*- lexical-binding: t; -*-

;; Copyright (C) 2024  Charles Choi

;; Author: Charles Choi <kickingvegas@gmail.com>
;; URL: https://github.com/kickingvegas/casual-re-builder
;; Keywords: tools
;; Version: 1.1.4-rc.1
;; Package-Requires: ((emacs "29.1") (casual-lib "1.1.0"))

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

;; Casual RE-Builder is an opinionated Transient-based porcelain for the Emacs regular expression editor.

;; INSTALLATION
;; (require 'casual-re-builder) ;; optional
;; (keymap-set reb-mode-map "C-o" #'casual-re-builder-tmenu)
;; (keymap-set reb-lisp-mode-map "C-o" #'casual-re-builder-tmenu)

;; Alternately with `use-package'
;; (use-package re-builder
;;   :defer t)
;; (use-package casual-re-builder
;;   :ensure nil
;;   :bind (:map
;;          reb-mode-map ("C-o" . casual-re-builder-tmenu)
;;          :map
;;          reb-lisp-mode-map ("C-o" . casual-re-builder-tmenu))
;;   :after (re-builder))

;; NOTE: This package requires `casual-lib' which in turn requires an update of
;; the built-in package `transient' ≥ 0.6.0. Please customize the variable
;; `package-install-upgrade-built-in' to t to allow for `transient' to be
;; updated. For further details, consult the INSTALL section of this package's
;; README.

;;; Code:
(require 're-builder)
(require 'rx)
(require 'transient)
(require 'casual-lib)
(require 'casual-re-builder-utils)
(require 'casual-re-builder-settings)

;;;###autoload (autoload 'casual-re-builder-tmenu "casual-re-builder" nil t)
(transient-define-prefix casual-re-builder-tmenu ()
  "Transient menu for RE-Builder commands.

Menu for RE-Builder (`re-builder'), a tool to construct a
regexp interactively.

* References
- Info node `(elisp) Regular Expressions'"
  :refresh-suffixes t
  ["RE-Builder"
   :description (lambda () (format "RE-Builder (%s)" reb-target-buffer))
   ["Copy Regexp"
    ("w" "Interactive" casual-re-builder-copy
     :if casual-re-builder-interactive-export-p
     :transient t)
    ("g" "Interactive grep" casual-re-builder-grep-copy
     :if casual-re-builder-interactive-export-p
     :transient t)
    ("c" "Code" reb-copy :transient t)]

   ["Match"
    ("p" "Previous" reb-prev-match
     :description (lambda () (casual-re-builder-unicode-get :previous))
     :transient t)
    ("n" "Next" reb-next-match
     :description (lambda () (casual-re-builder-unicode-get :next))
     :transient t)]

   ["Change"
    ("x" "Syntax" reb-change-syntax
     :description (lambda () (format "Syntax (%s)" reb-re-syntax))
     :transient t)
    ("b" "Target buffer" reb-change-target-buffer
     :transient t)
    ("t" "Case sensitivity" reb-toggle-case :transient t)]

   ["Display"
    ("s" "Subexp mode" reb-enter-subexp-mode)
    ("f" "Force update" reb-force-update :transient t)]]

  [:class transient-row
          (casual-lib-quit-one)
          ("i" "ⓘ Regexp Syntax" casual-re-builder-regexp-info
           :if (lambda () (derived-mode-p 'reb-mode)))
          ("i" "ⓘ Rx Notation" casual-re-builder-rx-info
           :if (lambda () (derived-mode-p 'reb-lisp-mode)))
          ("," "Settings" casual-re-builder-settings-tmenu)
          ("q" "Quit" reb-quit)
          (casual-lib-quit-all)])

(provide 'casual-re-builder)
;;; casual-re-builder.el ends here
