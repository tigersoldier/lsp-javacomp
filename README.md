# Emacs Language Server client backed by [JavaComp][javacomp]

lsp-javacomp is a [lsp-mode][lsp-mode] client that provides Java code-completion
and other IDE features for Emacs. It's backed by [JavaComp][javacomp].

## Usage

### Enable lsp-javacomp

```elisp
(require 'lsp-javacomp)
(add-hook 'java-mode-hook 'lsp-mode)
```

Alternatively, you can lazily load it using `use-package`:

```elisp
(use-package lsp-javacomp
  :defer t
  :commands (lsp-javacomp-mode)
  :init
  (progn
    (add-hook 'java-mode-hook 'lsp-javacomp-mode)))
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
