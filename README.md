[![MELPA](https://melpa.org/packages/lsp-javacomp-badge.svg)](https://melpa.org/#/lsp-javacomp)

# Emacs Language Server client backed by [JavaComp][javacomp]

lsp-javacomp is a [lsp-mode][lsp-mode] client that provides Java code-completion
and other IDE features for Emacs. It's backed by [JavaComp][javacomp].

## Usage

### Enable lsp-javacomp

lsp-javacomp is available on [MELPA]. To install it, first [setup
MELPA][setup-melpa], then <kbd>M-x</kbd> `package-install` <kbd>RET</kbd>
`company-lsp` <kbd>RET</kbd>.

After installing it, add the snippet below to your `.emacs` file to enable it
for `java-mode`:

```elisp
(require 'lsp-javacomp)
(add-hook 'java-mode-hook #'lsp-javacomp-enable)
```

### Install/Update JavaComp server

After installing lsp-javacomp to your Emacs, you can use `M-x
lsp-javacomp-install-server` to install the JavaComp server.

If you want to update to the latest version of JavaComp, you can use `M-x
lsp-javacomp-update-server`.

Alternatively, you can build or download the jar file manually. You must rename
the jar file to `javacomp.jar` and put it into the directory specified by the
`lsp-javacomp-server-install-dir` variable. The default value of
`lsp-javacomp-server-install-dir` is `~/.emacs.d/javacomp/`.

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
[melpa]: https://melpa.org
[setup-melpa]: https://melpa.org/#/getting-started
