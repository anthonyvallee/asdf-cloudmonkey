<div align="center">

# asdf-cloudmonkey [![Build](https://github.com/anthonyvallee/asdf-cloudmonkey/actions/workflows/build.yml/badge.svg)](https://github.com/anthonyvallee/asdf-cloudmonkey/actions/workflows/build.yml) [![Lint](https://github.com/anthonyvallee/asdf-cloudmonkey/actions/workflows/lint.yml/badge.svg)](https://github.com/anthonyvallee/asdf-cloudmonkey/actions/workflows/lint.yml)

[cloudmonkey](https://github.com/apache/cloudstack-cloudmonkey) plugin for the [asdf version manager](https://asdf-vm.com).

</div>

# Contents

- [Dependencies](#dependencies)
- [Install](#install)
- [Contributing](#contributing)
- [License](#license)

# Dependencies

**TODO: adapt this section**

- `bash`, `curl`, `tar`: generic POSIX utilities.

# Install

Plugin:

```shell
asdf plugin add cloudmonkey
# or
asdf plugin add cloudmonkey https://github.com/anthonyvallee/asdf-cloudmonkey.git
```

cloudmonkey:

```shell
# Show all installable versions
asdf list-all cloudmonkey

# Install specific version
asdf install cloudmonkey latest

# Set a version globally (on your ~/.tool-versions file)
asdf global cloudmonkey latest

# Now cloudmonkey commands are available
cmk --version
```

Check [asdf](https://github.com/asdf-vm/asdf) readme for more instructions on how to
install & manage versions.

# Contributing

Contributions of any kind welcome! See the [contributing guide](contributing.md).

[Thanks goes to these contributors](https://github.com/anthonyvallee/asdf-cloudmonkey/graphs/contributors)!

# License

See [LICENSE](LICENSE) © [Anthony Vallee](https://github.com/anthonyvallee/)
