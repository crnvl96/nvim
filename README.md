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

```bash
curl -LO <tool>
sudo rm -rf ~/.local/bin/<tool>
sudo tar -C ~/.local/bin -xzf <tool>
```

### LazyGit

> https://github.com/jesseduffield/lazygit

### Bat

> https://github.com/sharkdp/bat

### Eza

> https://github.com/eza-community/eza

### Diff-so-fancy

> https://github.com/so-fancy/diff-so-fancy

### Ripgrep

> https://github.com/BurntSushi/ripgrep

### FD

> https://github.com/sharkdp/fd
