return {
  {
    "dnlhc/glance.nvim",
    event = "VeryLazy",
    enabled = false,
    config = function()
      local glance = require('glance')
      local actions = glance.actions
      glance.setup({
        height = 25,
        detached = true,
        border = {
          enable = true,
          top_char = '―',
          bottom_char = '―',
        },
        list = {
          position = 'left',
          ['<leader>ll'] = actions.enter_win('preview'),
          ['<leader>lq'] = actions.quickfix,
        },
        preview = {
          ['<leader>ll'] = actions.enter_win('list'),
        },
      })
      vim.cmd [[highlight GlanceListMatch guifg=#ffe396 guibg=NONE]]
      vim.cmd [[highlight GlancePreviewCursorLine guifg=#ffe396 guibg=NONE]]
      vim.cmd [[highlight GlancePreviewMatch guifg=NONE guibg=NONE]]
    end,
  },
}