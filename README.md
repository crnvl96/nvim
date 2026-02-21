# Nvim Configuration

## Installation

> https://github.com/neovim/neovim/blob/master/INSTALL.md#pre-built-archives-2

```bash
# Add nvim location to your path, eg:
PATH=/opt/nvim-linux-x86_64/bin:$PATH
```

```bash
# Nightly release
curl -LO https://github.com/neovim/neovim/releases/download/nightly/nvim-linux-x86_64.tar.gz
sudo rm -rf /opt/nvim-linux-x86_64
sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
```

## Complementary tools

### LazyGit

> https://github.com/jesseduffield/lazygit

```bash
curl -LO https://github.com/jesseduffield/lazygit/releases/download/v0.59.0/lazygit_0.59.0_linux_x86_64.tar.gz
sudo rm -rf ~/.local/bin/lazygit
sudo tar -C ~/.local/bin -xzf lazygit_0.59.0_linux_x86_64.tar.gz
```

### Diff-so-fancy

> https://github.com/so-fancy/diff-so-fancy

### Ripgrep

> https://github.com/BurntSushi/ripgrep

### FD

> https://github.com/sharkdp/fd
