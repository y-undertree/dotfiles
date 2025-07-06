return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      local default_opts = require "plugins.configs.treesitter"
      local opts = require("custom.configs.overrides").treesitter
      return vim.tbl_deep_extend("force", default_opts, opts)
    end,
  }
}