;;; lsp-javacomp.el --- Provide Java IDE features powered by JavaComp.  -*- lexical-binding: t -*-

;; Version: 1.0
;; Package-Requires: ((emacs "25.1") (lsp-mode "3.0") (s "1.2.0"))
;; Keywords: java
;; URL: https://github.com/tigersoldier/lsp-javacomp

;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:

;; A lsp-mode client that provides Java code-completion and other IDE
;; features for Emacs. It's backed by JavaComp.

;; To use it, add the code below to your .emacs file:

;;    (require 'lsp-javacomp)
;;    (add-hook 'java-mode-hook #'lsp-javacomp-enable)

;;; Code:

(require 'cc-mode)
(require 'lsp-mode)
(require 'json)
(require 's)

(defcustom lsp-javacomp-server-install-dir (locate-user-emacs-file "javacomp/")
  "Install directory for JavaComp server.
Requires to be ended with a slash."
  :group 'lsp-javacomp
  :risky t
  :type 'directory)

(defcustom lsp-javacomp-java-executable "java"
  "Name or path of the java executable binary file."
  :type '(choice (const nil) string)
  :group 'lsp-javacomp)

(defcustom lsp-javacomp-java-options nil
  "List of command line options to be pased to java command."
  :type '(set string)
  :group 'lsp-javacomp)

(defconst lsp-javacomp-latest-release-url
  "https://api.github.com/repos/tigersoldier/JavaComp/releases/latest"
  "URL to retrieve the latest release of JavaComp server.")

(defun lsp-javacomp--server-jar-path ()
  "Return the path to the JavaComp server JAR file."
  (expand-file-name "javacomp.jar" lsp-javacomp-server-install-dir))

(defun lsp-javacomp--command ()
  "Return a list of the command and arguments to launch the JavaComp server."
  `( ,lsp-javacomp-java-executable
     ,@lsp-javacomp-java-options
     "-jar"
     ,(lsp-javacomp--server-jar-path)))

(defun lsp-javacomp--get-root ()
  "Retrieves the root directory of the java project root if available.

The current directory is assumed to be the java project’s root otherwise."
  (expand-file-name
   (cond
    ((locate-dominating-file default-directory "javacomp.json"))
    ((and (featurep 'projectile) (projectile-project-p)) (projectile-project-root))
    ((vc-backend default-directory) (vc-root-dir))
    (t (let ((project-types '("pom.xml" "build.gradle" ".project" "WORKSPACE")))
        (or (seq-some (lambda (file) (locate-dominating-file default-directory file)) project-types)
            default-directory))))))

(defun lsp-javacomp--get-prefix ()
  "Get prefix for completion.

Return a cons of (start . end) for the bound of the prefix."
  (let* ((bound (bounds-of-thing-at-point 'symbol))
         (start (or (and bound (car bound)) (point)))
         (end (or (and bound (cdr bound)) (point))))
    ;; java-mode considers '@' as a symbol constituent. However JavaComp doesn't
    ;; take the leading '@' as part of the prefix. Remove the leading '@' from
    ;; the prefix.
    (when (and (< start end) (char-equal (char-after start) ?@))
      (setq start (1+ start)))
    (cons start end)))

;;;###autoload
(defun lsp-javacomp-install-server (&optional prompt-exists)
  "Download the JavaComp server JAR file if it does not exist.

If PROMPT-EXISTS is non-nil, show a message if the server jar
file already exists."
  (interactive '(t))
  (let ((jar-file (lsp-javacomp--server-jar-path)))
    (if (file-exists-p jar-file)
        (and prompt-exists (message "JavaComp server already exists."))
      (lsp-javacomp--download-server))))

;;;###autoload
(defun lsp-javacomp-update-server ()
  (interactive)
  (lsp-javacomp--download-server))

(defun lsp-javacomp--download-server ()
  (message "Getting the latest JavaComp server...")
  (url-retrieve lsp-javacomp-latest-release-url #'lsp-javacomp--latest-release-callback))

(defun lsp-javacomp--latest-release-callback (stats)
  "Handle the `url-retrive' callback for JavaComp latest release request.

STATS is passed by `url-retrieve'.

See https://developer.github.com/v3/repos/releases/#get-the-latest-release
"
  (search-forward "\n\n")
  (if-let (err (plist-get stats :error))
      (error "Failed to get the latest release of JavaComp server: %s" (car err))
    (let* ((release (json-read))
           (assets (alist-get 'assets release))
           (jar-asset (seq-find (lambda (asset)
                                  (s-match "^javacomp.*\\.jar$" (alist-get 'name asset)))
                                assets))
           (jar-url (alist-get 'browser_download_url jar-asset))
           (release-version (alist-get 'tag_name release)))
      (if jar-url
          (progn
            (message "Found JavaComp %s, downloading..." release-version)
            (make-directory (expand-file-name lsp-javacomp-server-install-dir) t)
            (url-copy-file jar-url (lsp-javacomp--server-jar-path) t))
        (error "Fail to get the URL of the JavaComp server")))))

(lsp-define-stdio-client lsp-javacomp "java" #'lsp-javacomp--get-root nil
                         :command-fn #'lsp-javacomp--command
                         :ignore-regexps '("^SLF4J: "
                                           "^Listening for transport dt_socket at address: ")
                         :prefix-function #'lsp-javacomp--get-prefix)

(provide 'lsp-javacomp)
;;; lsp-javacomp.el ends here
