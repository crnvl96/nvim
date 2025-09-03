local U = require('utils')

require('opencode').setup()

U.nmap('<leader>oc', function() require('opencode').ask() end, 'Ask opencode')
U.xmap('<leader>oc', function() require('opencode').ask('@selection: ') end, 'Ask opencode about selection')
U.nmap('<leader>oo', function() require('opencode').toggle() end, 'Toggle embedded opencode')
U.nmap('<leader>oy', function() require('opencode').command('messages_copy') end, 'Copy last message')
U.nmap('<leader>op', function() require('opencode').select_prompt() end, 'Select prompt')
U.nmap('<M-u>', function() require('opencode').command('messages_half_page_up') end, 'Scroll messages up')
U.nmap('<M-d>', function() require('opencode').command('messages_half_page_down') end, 'Scroll messages down')

U.augroup('crnvl96-opencode', function(g)
  U.aucmd('User', {
    pattern = 'OpencodeEvent',
    group = g,
    callback = function(e)
      if e.data.type == 'session.idle' then U.publish('opencode finished responding') end
    end,
  })
end)
