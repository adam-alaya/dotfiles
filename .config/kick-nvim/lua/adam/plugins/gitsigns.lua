-- return { -- Adds git related signs to the gutter, as well as utilities for managing changes
--   'lewis6991/gitsigns.nvim',
--   config = function()
--     local gitsigns = require('gitsigns')
--     gitsigns.setup({
--         signs = {
--           add = { text = '│' },
--           change = { text = '│' },
--           delete = { text = '_' },
--           topdelete = { text = '‾' },
--           changedelete = { text = '~' },
--           untracked = { text = '┆' },
--         }
--     })
--   end
-- }
return {
    'lewis6991/gitsigns.nvim',
}
