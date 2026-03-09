Config.now(function() require('crnvl.plug._mini-icons') end)

Config.now_if_args(function() require('crnvl.plug._codediff') end)
Config.now_if_args(function() require('crnvl.plug._schemastore') end)
Config.now_if_args(function() require('crnvl.plug._sleuth') end)
Config.now_if_args(function() require('crnvl.plug._ts-autotag') end)
Config.now_if_args(function() require('crnvl.plug._ts-comments') end)

-- wtiting
Config.now_if_args(function() require('crnvl.plug._image') end)
Config.now_if_args(function() require('crnvl.plug._img-clip') end)
Config.now_if_args(function() require('crnvl.plug._markdown-preview') end)
Config.now_if_args(function() require('crnvl.plug._typst-preview') end)

-- lang
Config.now_if_args(function() require('crnvl.plug._treesitter') end)
Config.now_if_args(function() require('crnvl.plug._lspconfig') end)
Config.now_if_args(function() require('crnvl.plug._conform') end)

-- mini
Config.now_if_args(function() require('crnvl.plug._mini-bufremove') end)
Config.now_if_args(function() require('crnvl.plug._mini-indentscope') end)
Config.now_if_args(function() require('crnvl.plug._mini-completion') end)
Config.now_if_args(function() require('crnvl.plug._mini-hipatterns') end)
Config.now_if_args(function() require('crnvl.plug._mini-jump2d') end)
Config.now_if_args(function() require('crnvl.plug._mini-pairs') end)
Config.now_if_args(function() require('crnvl.plug._mini-ai') end)
Config.now_if_args(function() require('crnvl.plug._mini-keymap') end)
Config.now_if_args(function() require('crnvl.plug._mini-snippets') end)
Config.now_if_args(function() require('crnvl.plug._mini-files') end)
Config.now_if_args(function() require('crnvl.plug._mini-pick') end)
Config.now_if_args(function() require('crnvl.plug._mini-clue') end)

-- mini pt. 2
Config.now_if_args(function() require('mini.align').setup() end)
Config.now_if_args(function() require('mini.statusline').setup() end)
Config.now_if_args(function() require('mini.operators').setup() end)
Config.now_if_args(function() require('mini.move').setup() end)
Config.now_if_args(function() require('mini.surround').setup() end)
Config.now_if_args(function() require('mini.splitjoin').setup() end)
Config.now_if_args(function() require('mini.cmdline').setup() end)
Config.now_if_args(function() require('mini.git').setup() end)
Config.now_if_args(function() require('mini.diff').setup() end)
