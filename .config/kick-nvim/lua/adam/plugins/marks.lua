return {
  'chentoast/marks.nvim',
  config = function()
    require('marks').setup {
      mappings = {
        -- set_next = "m,",
        -- next = "m]",
        -- preview = "m:",
        -- set_bookmark0 = "m0",
      },
    }
  end,
}
