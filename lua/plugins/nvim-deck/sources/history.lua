return function()
  local ctx = require('deck').get_history()[1]
  if ctx then ctx.show() end
end
