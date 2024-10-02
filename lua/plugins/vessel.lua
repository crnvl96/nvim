return {
    'gcmt/vessel.nvim',
    config = function()
        local util = require('vessel.util')
        local vessel = require('vessel')

        vessel.opt.window.options.border = 'rounded'
        vessel.opt.marks.formatters.header = function() end
        vessel.opt.marks.formatters.mark = function(mark, meta)
            -- Makes sure each line number is vertically aligned
            local lnum_fmt = '%' .. #tostring(meta.max_lnum) .. 's'
            local lnum = string.format(lnum_fmt, mark.lnum)

            local line, line_hl
            if mark.loaded then
                -- strips leading white spaces from each line
                line = string.gsub(mark.line, '^%s+', '')
                line_hl = 'Normal'
            else
                -- If the file the mark belongs to is not loaded in memory,
                -- display its path instead
                line = util.prettify_path(mark.file)
                line_hl = 'Comment'
            end

            -- Display a vertically aligned file name
            local path_fmt = '%-' .. meta.max_suffix .. 's' -- align file names
            local label = string.format(path_fmt, meta.suffixes[mark.file])

            return util.format(
                ' [%s]  %s %s %s',
                { mark.mark, 'Keyword' },
                { label, 'none' },
                { lnum, 'LineNr' },
                { line, line_hl }
            )
        end
    end,
    keys = {
        { '<leader>mm', '<Plug>(VesselViewMarks)', desc = 'Show Marks' },
        { '<leader>mj', '<Plug>(VesselViewJumps)', desc = 'Show Jumps' },
    },
}
