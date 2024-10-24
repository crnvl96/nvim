local M = {}

-- This should stand as the reference fot what size is the
-- threshold for we to consider is as "big", so that we can make some tweaks to
-- avoid slowing our editor
M.bigfile = math.floor(0.5 * 1024 * 1024) -- 0.5 mb

-- This variable should control if conform will run on save
M.autoformat = true

return M
