vim.cmd.colorscheme 'miniwinter'

require('mini.extra').setup()
require('mini.misc').setup()
require('mini.statusline').setup()
require('mini.tabline').setup()
require('mini.trailspace').setup()
require('mini.colors').setup()
require('mini.bufremove').setup()
require('mini.align').setup()
require('mini.splitjoin').setup()
require('mini.bracketed').setup()
require('mini.jump').setup()
require('mini.move').setup()
require('mini.diff').setup { view = { style = 'sign' }, options = { algorithm = 'myers' } }
require('mini.git').setup { command = { split = 'vertical' } }
require('mini.pick').setup()
require('mini.visits').setup()
require('mini.keymap').setup()
require('mini.pairs').setup()

require('mini.basics').setup {
    options = {
        basic = false,
        extra_ui = false,
        win_borders = 'double',
    },
    mappings = {
        basic = true,
        option_toggle_prefix = [[\]],
        windows = true,
        move_with_alt = false,
    },
    autocommands = {
        basic = true,
        relnum_in_visual_mode = false,
    },
}

MiniKeymap.map_multistep('i', '<Tab>', { 'pmenu_next' })
MiniKeymap.map_multistep('i', '<C-n>', { 'pmenu_next' })
MiniKeymap.map_multistep('i', '<S-Tab>', { 'pmenu_prev' })
MiniKeymap.map_multistep('i', '<C-p>', { 'pmenu_prev' })
MiniKeymap.map_multistep('i', '<CR>', { 'pmenu_accept', 'minipairs_cr' })
MiniKeymap.map_multistep('i', '<BS>', { 'minipairs_bs' })

local mode = { 'i', 'c', 'x', 's' }

MiniKeymap.map_combo(mode, 'jk', '<BS><BS><Esc>')
MiniKeymap.map_combo(mode, 'kj', '<BS><BS><Esc>')
MiniKeymap.map_combo('t', 'jk', '<BS><BS><C-\\><C-n>')
MiniKeymap.map_combo('t', 'kj', '<BS><BS><C-\\><C-n>')

require('mini.notify').setup {
    content = {
        sort = function(notif_arr)
            return MiniNotify.default_sort(vim.iter(notif_arr)
                :filter(function(notif)
                    if not (notif.data.source == 'lsp_progress' and notif.data.client_name == 'lua_ls') then
                        return true
                    end

                    return notif.msg:find 'Diagnosing' == nil and notif.msg:find 'semantic tokens' == nil
                end)
                :totable())
        end,
    },
}

require('mini.jump2d').setup {
    spotter = require('mini.jump2d').gen_spotter.pattern '[^%s%p]+',
    labels = "asdfghjkl'",
    view = { dim = true, n_steps_ahead = 1 },
}

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
    mappings = {
        force_twostep = '<C-n>',
        force_fallback = '<A-n>',
        scroll_down = '<C-f>',
        scroll_up = '<C-b>',
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
    mappings = {
        go_in = '',
        go_in_plus = '<CR>',
        go_out = '',
        go_out_plus = '-',
    },
}

require('mini.clue').setup {
    triggers = {
        -- Leader triggers
        { mode = 'n', keys = '<Leader>' },
        { mode = 'x', keys = '<Leader>' },

        -- `[` and `]` keys
        { mode = 'n', keys = '[' },
        { mode = 'n', keys = ']' },

        -- Built-in completion
        { mode = 'i', keys = '<C-x>' },

        -- `g` key
        { mode = 'n', keys = 'g' },
        { mode = 'x', keys = 'g' },

        -- Marks
        { mode = 'n', keys = "'" },
        { mode = 'n', keys = '`' },
        { mode = 'x', keys = "'" },
        { mode = 'x', keys = '`' },

        -- Registers
        { mode = 'n', keys = '"' },
        { mode = 'x', keys = '"' },
        { mode = 'i', keys = '<C-r>' },
        { mode = 'c', keys = '<C-r>' },

        -- Window commands
        { mode = 'n', keys = '<C-w>' },

        -- `z` key
        { mode = 'n', keys = 'z' },
        { mode = 'x', keys = 'z' },

        -- `\` (toggle) key
        { mode = 'n', keys = [[\]] },
    },
    clues = {
        require('mini.clue').gen_clues.square_brackets(),
        require('mini.clue').gen_clues.builtin_completion(),
        require('mini.clue').gen_clues.g(),
        require('mini.clue').gen_clues.marks(),
        require('mini.clue').gen_clues.registers(),
        require('mini.clue').gen_clues.windows(),
        require('mini.clue').gen_clues.z(),

        { mode = 'i', keys = '<C-x><C-f>', desc = 'File names' },
        { mode = 'i', keys = '<C-x><C-l>', desc = 'Whole lines' },
        { mode = 'i', keys = '<C-x><C-o>', desc = 'Omni completion' },
        { mode = 'i', keys = '<C-x><C-s>', desc = 'Spelling suggestions' },
        { mode = 'i', keys = '<C-x><C-u>', desc = "With 'completefunc'" },

        { mode = 'n', keys = '<Leader>f', desc = '+Find' },
        { mode = 'n', keys = '<Leader>l', desc = '+Lsp' },
        { mode = 'n', keys = '<Leader>b', desc = '+Buffers' },
        { mode = 'n', keys = '<Leader>t', desc = '+Term' },

        { mode = 'n', keys = ']b', postkeys = ']' },
        { mode = 'n', keys = '[b', postkeys = '[' },
        { mode = 'n', keys = ']q', postkeys = ']' },
        { mode = 'n', keys = '[q', postkeys = '[' },
    },
    window = {
        config = {},
        delay = 200,
        scroll_down = '<C-d>',
        scroll_up = '<C-u>',
    },
}

MiniIcons.tweak_lsp_kind()
MiniNotify.make_notify()
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

vim.lsp.config('*', { capabilities = MiniCompletion.get_lsp_capabilities() })

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(ev) vim.bo[ev.buf].omnifunc = 'v:lua.MiniCompletion.completefunc_lsp' end,
})

local set = vim.keymap.set


-- stylua: ignore start
set('n', '-',    '<Cmd>lua MiniFiles.open(vim.api.nvim_buf_get_name(0))<CR>')
set('n', '<leader>bd', '<Cmd>lua MiniBufremove.wipeout(0,true)<CR>', { desc = 'Wipeout buffer' })

local function wipeall()
    local curr = vim.api.nvim_get_current_buf()
    vim.iter(vim.api.nvim_list_bufs())
        :filter(function(buf) return buf ~= curr end)
        :each(function(buf) MiniBufremove.wipeout(buf, true) end)
end


set('n', '<leader>bo', wipeall, { desc = 'Remove other buffers' })

set('n', '<leader>fb', '<Cmd>Pick buffers<CR>',                   { desc = 'Buffers' })
set('n', '<leader>fd', '<Cmd>Pick diagnostic scope="all"<CR>',    { desc = 'Diagnostic workspace' })
set('n', '<leader>ff', '<Cmd>Pick files<CR>',                     { desc = 'Files' })
set('n', '<leader>fg', '<Cmd>Pick grep_live<CR>',                 { desc = 'Grep live' })
set('n', '<leader>fh', '<Cmd>Pick help<CR>',                      { desc = 'Help tags' })
set('n', '<leader>fi', '<Cmd>Pick hl_groups<CR>',                 { desc = 'Highlight groups' })
set('n', '<leader>fl', '<Cmd>Pick buf_lines scope="current"<CR>', { desc = 'Lines' })
set('n', '<leader>fn', '<Cmd>lua MiniNotify.show_history()<CR>',  { desc = 'Notifications' })
set('n', '<leader>fr', '<Cmd>Pick resume<CR>',                    { desc = 'Resume' })
set('n', '<leader>fo', '<Cmd>Pick visit_paths<CR>',               { desc = 'Visit paths' })
set('n', '<leader>fv', '<Cmd>lua MiniDiff.toggle_overlay()<CR>',  { desc = 'Toggle buffer diff' })

local formatting_cmd = '<Cmd>lua require("conform").format({lsp_fallback=true})<CR>'

set('n', '<leader>la', '<Cmd>lua vim.lsp.buf.code_action()<CR>',     { desc='Actions'         })
set('n', '<leader>le', '<Cmd>lua vim.diagnostic.open_float()<CR>',   { desc='Diagnostic popup'})
set('n', '<leader>lf', formatting_cmd,                               { desc='Format'          })
set('x', '<leader>lf', formatting_cmd,                               { desc='Format selection' })
set('n', '<leader>li', '<Cmd>lua vim.lsp.buf.implementation()<CR>',  { desc='Implementation'  })
set('n', '<leader>lk', '<Cmd>lua vim.lsp.buf.hover()<CR>',           { desc='Hover'           })
set('n', '<leader>ln', '<Cmd>lua vim.lsp.buf.rename()<CR>',          { desc='Rename'          })
set('n', '<leader>lr', '<Cmd>lua vim.lsp.buf.references()<CR>',      { desc='References'      })
set('n', '<leader>ld', '<Cmd>lua vim.lsp.buf.definition()<CR>',      { desc='Source definition' })
set('n', '<leader>ly', '<Cmd>lua vim.lsp.buf.type_definition()<CR>', { desc='Type definition' })
-- stylua: ignore end
