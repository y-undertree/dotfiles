return {
  {
    "hrsh7th/nvim-cmp",
    enabled = false,
    event = { "InsertEnter", "CmdlineEnter" },
    opts = function()
      local default_opts = require "plugins.configs.cmp"
      local opts = require "custom.configs.cmp_options"
      return vim.tbl_deep_extend("force", default_opts, opts)
    end,
    config = function(_, opts)
      local cmp = require "cmp"
      cmp.setup(opts)
      cmp.setup.filetype("DressingInput", {
        sources = cmp.config.sources { { name = "omni" } },
      })
    end,
  },
}