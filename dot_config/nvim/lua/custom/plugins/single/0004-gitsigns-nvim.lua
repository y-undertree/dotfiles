return {
  {
    "lewis6991/gitsigns.nvim",
    opts = function()
      local default_opts = require "plugins.configs.treesitter"
      local opts = require("custom.configs.overrides").gitsigns
      return vim.tbl_deep_extend("force", default_opts, opts)
    end,
  }
}