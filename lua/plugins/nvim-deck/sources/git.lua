return function() require('deck').start(require('deck.builtin.source.git')({ cwd = vim.uv.cwd() })) end
