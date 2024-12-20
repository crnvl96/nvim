local hipatterns = require('mini.hipatterns')
local hi_words = MiniExtra.gen_highlighter.words

hipatterns.setup({
  highlighters = {
    fixme = hi_words({ 'FIXME', 'Fixme', 'fixme' }, 'MiniHipatternsFixme'),
    hack = hi_words({ 'HACK', 'Hack', 'hack' }, 'MiniHipatternsHack'),
    todo = hi_words({ 'TODO', 'Todo', 'todo' }, 'MiniHipatternsTodo'),
    note = hi_words({ 'NOTE', 'Note', 'note' }, 'MiniHipatternsNote'),

    hex_color = hipatterns.gen_highlighter.hex_color(),
  },
})
