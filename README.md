[![MELPA](https://melpa.org/packages/lsp-javacomp-badge.svg)](https://melpa.org/#/lsp-javacomp)

# Emacs Language Server client backed by [JavaComp][javacomp]

lsp-javacomp is a [lsp-mode][lsp-mode] client that provides Java code-completion
and other IDE features for Emacs. It's backed by [JavaComp][javacomp].

## Usage

### Enable lsp-javacomp

lsp-javacomp is available on [MELPA]. To install it, first [setup
MELPA][setup-melpa], then <kbd>M-x</kbd> `package-install` <kbd>RET</kbd>
`lsp-javacomp` <kbd>RET</kbd>.

After installing it, add the snippet below to your `.emacs` file to enable it
for `java-mode`:

```elisp
(require 'lsp-javacomp)
(add-hook 'java-mode-hook #'lsp-javacomp-enable)
```

I recommend using lsp-javacomp in with [company-lsp][compan-lsp]. If you are
lazy-loading company-lsp, make sure it's loaded before calling
`lsp-javacomp-enable`. You can lazily load lsp-javacomp and company-lsp with
[use-package][use-package]:

```elisp
(use-package lsp-javacomp
  :commands lsp-javacomp-enable
  :init
  (add-hook 'java-mode-hook
            (lambda ()
              ;; Load company-lsp before enabling lsp-javacomp, so that function
              ;; parameter snippet works.
              (require 'company-lsp)
              (lsp-javacomp-enable)
              ;; Use company-lsp as the company completion backend
              (set (make-variable-buffer-local 'company-backends) '(company-lsp))
              ;; Optional company-mode settings
              (set (make-variable-buffer-local 'company-idle-delay) 0.1)
              (set (make-variable-buffer-local 'company-minimum-prefix-length) 1)))
  ;; Optional, make sure JavaComp is installed. See below.
  :config
  (lsp-javacomp-install-server))
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

If you don't use company-lsp, you can use the vanilla `completion-at-point`
implemented by lsp-mode.

Run `M-x completion-at-point` in a .java file buffer to get completion
candidates. The default key binding is `C-M-i`.

### Customizing JavaComp server behavior

You can provide initialization options to JavaComp by setting the following
variables:

* `lsp-javacomp-server-log-path`
* `lsp-javacomp-server-log-level`
* `lsp-javacomp-server-ignore-paths`
* `lsp-javacomp-server-type-index-files`

If there is `javacomp.json` file in the project root, the corresponding options
will be overridden if specified in the `javacomp.json` file.

[company-lsp]: http://https://github.com/tigersoldier/company-lsp/
[javacomp]: https://github.com/tigersoldier/JavaComp
[lsp-mode]: https://github.com/emacs-lsp/lsp-mode
[melpa]: https://melpa.org
[setup-melpa]: https://melpa.org/#/getting-started
[use-package]: https://github.com/jwiegley/use-package
