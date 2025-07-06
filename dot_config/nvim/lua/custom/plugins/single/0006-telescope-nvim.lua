return {
  {
    "nvim-telescope/telescope.nvim",
    opts = function()
      local default_opts = require "plugins.configs.telescope"
      local opts = require "custom.configs.telescope_options"
      return vim.tbl_deep_extend("force", default_opts, opts)
    end,
  }
}