Config.now(function() require('crnvl.plug.mini-icons') end)

Config.now_if_args(function() require('crnvl.plug.schemastores') end)
Config.now_if_args(function() require('crnvl.plug.sleuth') end)
Config.now_if_args(function() require('crnvl.plug.ts-autotag') end)
Config.now_if_args(function() require('crnvl.plug.ts-comments') end)
Config.now_if_args(function() require('crnvl.plug.vim-tmux-navigator') end)
Config.now_if_args(function() require('crnvl.plug.gitsigns') end)

-- wtiting
Config.now_if_args(function() require('crnvl.plug.image') end)
Config.now_if_args(function() require('crnvl.plug.img-clip') end)
Config.now_if_args(function() require('crnvl.plug.markdown-preview') end)
Config.now_if_args(function() require('crnvl.plug.typst-preview') end)

-- lang
Config.now_if_args(function() require('crnvl.plug.treesitter') end)
Config.now_if_args(function() require('crnvl.plug.lspconfig') end)
Config.now_if_args(function() require('crnvl.plug.conform') end)

-- mini
Config.now_if_args(function() require('crnvl.plug.mini-bufremove') end)
Config.now_if_args(function() require('crnvl.plug.mini-indentscope') end)
Config.now_if_args(function() require('crnvl.plug.mini-completion') end)
Config.now_if_args(function() require('crnvl.plug.mini-hipatterns') end)
Config.now_if_args(function() require('crnvl.plug.mini-jump2d') end)
Config.now_if_args(function() require('crnvl.plug.mini-pairs') end)
Config.now_if_args(function() require('crnvl.plug.mini-ai') end)
Config.now_if_args(function() require('crnvl.plug.mini-keymap') end)
Config.now_if_args(function() require('crnvl.plug.mini-snippets') end)
Config.now_if_args(function() require('crnvl.plug.mini-files') end)
Config.now_if_args(function() require('crnvl.plug.mini-pick') end)
Config.now_if_args(function() require('crnvl.plug.mini-clue') end)

-- mini pt. 2
Config.now_if_args(function() require('mini.align').setup() end)
Config.now_if_args(function() require('mini.statusline').setup() end)
Config.now_if_args(function() require('mini.operators').setup() end)
Config.now_if_args(function() require('mini.move').setup() end)
Config.now_if_args(function() require('mini.surround').setup() end)
Config.now_if_args(function() require('mini.splitjoin').setup() end)
Config.now_if_args(function() require('mini.cmdline').setup() end)
Config.now_if_args(function() require('mini.git').setup() end)
