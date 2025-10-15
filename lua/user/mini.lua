-- ┌────────────┐
-- │ Statusline │
-- └────────────┘

require('mini.statusline').setup {}
require('mini.map').setup {}
require('mini.operators').setup {}
require('mini.tabline').setup {}
require('mini.extra').setup {}
require('mini.misc').setup {}
require('mini.starter').setup()
require('mini.bufremove').setup()
require('mini.align').setup {}
require('mini.splitjoin').setup {}
require('mini.colors').setup {}
require('mini.bracketed').setup()
require('mini.jump').setup()
require('mini.move').setup()
require('mini.trailspace').setup()
require('mini.diff').setup()
require('mini.git').setup { command = { split = 'vertical' } }
require('mini.pick').setup()
require('mini.visits').setup()
require('mini.notify').setup()

require('mini.icons').setup {
    use_file_extension = function(ext, _)
        local ext3_blocklist = { scm = true, txt = true, yml = true }
        local ext4_blocklist = { json = true, yaml = true }
        return not (ext3_blocklist[ext:sub(-3)] or ext4_blocklist[ext:sub(-4)])
    end,
}

require('mini.completion').setup {
    lsp_completion = {
        source_func = 'omnifunc',
        auto_setup = false,
        process_items = function(items, base)
            return MiniCompletion.default_process_items(items, base, { kind_priority = { Text = -1, Snippet = 99 } })
        end,
    },
}

require('mini.ai').setup {
    custom_textobjects = {
        g = MiniExtra.gen_ai_spec.buffer(),
        f = require('mini.ai').gen_spec.treesitter { a = '@function.outer', i = '@function.inner' },
        d = MiniExtra.gen_ai_spec.diagnostic(),
        i = MiniExtra.gen_ai_spec.indent(),
    },
    search_method = 'cover',
}

require('mini.hipatterns').setup {
    highlighters = {
        fixme = MiniExtra.gen_highlighter.words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
        hack = MiniExtra.gen_highlighter.words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
        todo = MiniExtra.gen_highlighter.words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
        note = MiniExtra.gen_highlighter.words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),
        hex_color = require('mini.hipatterns').gen_highlighter.hex_color(),
    },
}

require('mini.files').setup {
    mappings = { go_in = '', go_in_plus = '<CR>', go_out = '', go_out_plus = '-' },
}

require('mini.clue').setup {
    clues = {
        { mode = 'n', keys = '<Leader>f', desc = '+Find' },
        { mode = 'n', keys = '<Leader>b', desc = '+Buffers' },
        { mode = 'n', keys = '<Leader>m', desc = '+Map' },
        { mode = 'n', keys = '<Leader>t', desc = '+Term' },
    },
    triggers = {
        { mode = 'n', keys = '<leader>' },
        { mode = 'x', keys = '<leader>' },
    },
    window = {
        config = {},
        delay = 200,
        scroll_down = '<C-d>',
        scroll_up = '<C-u>',
    },
}

require('mini.map').setup {
    symbols = { encode = require('mini.map').gen_encode_symbols.dot '4x2' },
    integrations = {
        -- require('mini.map').gen_integration.builtin_search(),
        -- require('mini.map').gen_integration.diff(),
        require('mini.map').gen_integration.diagnostic(),
    },
}

MiniIcons.tweak_lsp_kind()

MiniNotify.make_notify()

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev) vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end,
})

vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })

vim.cmd.colorscheme 'miniwinter'

MiniMisc.setup_restore_cursor()
MiniMisc.setup_auto_root()
MiniMisc.setup_termbg_sync()

MiniColors.get_colorscheme()
    :add_transparency({
        general = false,
        float = true,
        statuscolumn = false,
        statusline = false,
        tabline = false,
        winbar = false,
    })
    :apply()

for _, key in ipairs { 'n', 'N', '*', '#' } do
    vim.keymap.set('n', key, key .. 'zv<Cmd>lua MiniMap.refresh({}, { lines = false, scrollbar = false })<CR>')
end

local set = vim.keymap.set

set('n', '-', '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>')

set('n', '<leader>bo', function()
    local curr = vim.api.nvim_get_current_buf()
    vim.iter(vim.api.nvim_list_bufs())
        :filter(function(buf) return buf ~= curr end)
        :each(function(buf) MiniBufremove.wipeout(buf, true) end)
end, { desc = 'Remove other buffers' })

-- stylua: ignore start
set('n', '<leader>fa', '<Cmd>Pick git_hunks scope="staged"<CR>',  { desc = 'Added hunks' })
set('n', '<leader>fb', '<Cmd>Pick buffers<CR>',                   { desc = 'Buffers' })
set('n', '<leader>fc', '<Cmd>Pick git_commits<CR>',               { desc = 'Commits' })
set('n', '<leader>fd', '<Cmd>Pick diagnostic scope="all"<CR>',    { desc = 'Diagnostic workspace' })
set('n', '<leader>ff', '<Cmd>Pick files<CR>',                     { desc = 'Files' })
set('n', '<leader>fg', '<Cmd>Pick grep_live<CR>',                 { desc = 'Grep live' })
set('n', '<leader>fh', '<Cmd>Pick help<CR>',                      { desc = 'Help tags' })
set('n', '<leader>fH', '<Cmd>Pick hl_groups<CR>',                 { desc = 'Highlight groups' })
set('n', '<leader>fl', '<Cmd>Pick buf_lines scope="current"<CR>', { desc = 'Lines' })
set('n', '<leader>fm', '<Cmd>Pick git_hunks<CR>',                 { desc = 'Hunks' })
set('n', '<leader>fn', '<Cmd>lua MiniNotify.show_history()<CR>',  { desc = 'Notifications' })
set('n', '<leader>fr', '<Cmd>Pick resume<CR>',                    { desc = 'Resume' })
set('n', '<leader>fv', '<Cmd>Pick visit_paths<CR>',               { desc = 'Visit paths' })

set('n', '<leader>mf', '<Cmd>lua MiniMap.toggle_focus()<CR>',     { desc = 'Focus (toggle)' })
set('n', '<leader>mr', '<Cmd>lua MiniMap.refresh()<CR>',          { desc = 'Refresh' })
set('n', '<leader>ms', '<Cmd>lua MiniMap.toggle_side()<CR>',      { desc = 'Side (toggle)' })
set('n', '<leader>mt', '<Cmd>lua MiniMap.toggle()<CR>',           { desc = 'Toggle' })

set('n', '<leader>gA',         '<Cmd>Git diff --cached<CR>',              { desc = 'Added diff' })
set('n', '<leader>ga',         '<Cmd>Git diff --cached -- %<CR>',         { desc = 'Added diff buffer' })
set('n', '<leader>gC',         '<Cmd>Git commit<CR>',                     { desc = 'Commit' })
set('n', '<leader>gc',         '<Cmd>Git commit --amend<CR>',             { desc = 'Commit amend' })
set('n', '<leader>gD',         '<Cmd>Git diff<CR>',                       { desc = 'Diff' })
set('n', '<leader>gd',         '<Cmd>Git diff -- %<CR>',                  { desc = 'Diff buffer' })

local git_log_cmd = [[Git log --pretty=format:\%h\ \%as\ │\ \%s --topo-order]]
local git_log_buf_cmd = git_log_cmd .. ' --follow -- %'

set('n', '<leader>gL',         '<Cmd>' .. git_log_cmd .. '<CR>',          { desc = 'Log' })
set('n', '<leader>gl',         '<Cmd>' .. git_log_buf_cmd .. '<CR>',      { desc = 'Log buffer' })
set('n', '<leader>go',         '<Cmd>lua MiniDiff.toggle_overlay()<CR>',  { desc = 'Toggle overlay' })
set('n', '<leader>gs',         '<Cmd>lua MiniGit.show_at_cursor()<CR>',   { desc = 'Show at cursor' })
set('x', '<leader>gs',         '<Cmd>lua MiniGit.show_at_cursor()<CR>',   { desc = 'Show at selection' })

-- NOTE: most LSP mappings represent a more structured way of replacing built-in
-- LSP mappings (like `:h gra` and others). This is needed because `gr` is mapped
-- by an "replace" operator in 'mini.operators' (which is more commonly used).
local formatting_cmd = '<Cmd>lua require("conform").format({lsp_fallback=true})<CR>'

set('n', '<leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>',     { desc='Actions'         })
set('n', '<leader>le', '<Cmd>lua vim.diagnostic.open_float()<CR>',   { desc='Diagnostic popup'})
set('n', '<leader>lf', formatting_cmd,                               { desc='Format'          })
set('n', '<leader>li', '<Cmd>lua vim.lsp.buf.implementation()<CR>',  { desc='Implementation'  })
set('n', '<leader>lk', '<Cmd>lua vim.lsp.buf.hover()<CR>',           { desc='Hover'           })
set('n', '<leader>ln', '<Cmd>lua vim.lsp.buf.rename()<CR>',          { desc='Rename'          })
set('n', '<leader>lr', '<Cmd>lua vim.lsp.buf.references()<CR>',      { desc='References'      })
set('n', '<leader>ld', '<Cmd>lua vim.lsp.buf.definition()<CR>',      { desc='Source definition' })
set('n', '<leader>ly', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', { desc='Type definition' })
set('x', '<leader>lf', formatting_cmd,                               { desc='Format selection' })

-- stylua: ignore end
