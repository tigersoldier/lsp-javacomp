# Emacs Language Server client backed by [JavaComp][javacomp]

lsp-javacomp is a [lsp-mode][lsp-mode] client that provides Java code-completion
and other IDE features for Emacs. It's backed by [JavaComp][javacomp].

## Usage

### Enable lsp-javacomp

lsp-javacomp is avaliable on [MELPA]. It's recommended to install the package from it.

You need to add MELPA to your `package-archives` list. Add the snippet below to
your `.emacs` file.

```elisp
; Setup MELPA. Copied from https://melpa.org/#/getting-started
(require 'package) ;; You might already have this line
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (url (concat (if no-ssl "http" "https") "://melpa.org/packages/")))
  (add-to-list 'package-archives (cons "melpa" url) t))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line
```

Then you can use `M-x package-install` to install lsp-javacomp. After installing it,
add the snippet below to your `.emacs` file to enable it for `java-mode`:

```elisp
; Make sure lsp-javacomp is loaded when lsp-mode is used so that the JavaComp 
; LSP handler is installed.
(with-eval-after-load 'lsp-mode
  (require 'lsp-javacomp))
; Enable lsp-mode for java-mode
(add-hook 'java-mode-hook 'lsp-mode)
```

### Specify the Jar location of of JavaComp

Build or download the jar file from [JavaComp website][javacomp].

Set `lsp-javacomp-server-jar` to the path to the jar file:

```elisp
(setq lsp-javacomp-server-jar "path/to/JavaComp.jar")
```

### Complete using `completion-at-point`

`lsp-mode` implements `completion-at-point-function` for completion.

Run `M-x completion-at-point` in a .java file buffer to get completion
candidates. The default key binding is `C-M-i`.

### Complete using [company-mode][company-mode]

`company-capf` is the adapter between `completion-at-point-function` and
`company-mode`. Make sure it's added to `company-backends`:

```elisp
(push 'company-capf company-backends)
```

[company-mode]: http://company-mode.github.io/
[javacomp]: https://github.com/tigersoldier/JavaComp
[lsp-mode]: https://github.com/emacs-lsp/lsp-mode
[melpa]: https://melpa.org/
