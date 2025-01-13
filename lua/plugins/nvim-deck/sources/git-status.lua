return function() require('deck').start(require('deck.builtin.source.git.status')({ cwd = vim.uv.cwd() })) end
