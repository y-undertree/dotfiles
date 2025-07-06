return {
  {
    "iguanacucumber/magazine.nvim",
    enabled = true,
    name = "nvim-cmp",
    dependencies = {
      { "iguanacucumber/mag-nvim-lsp", name = "cmp-nvim-lsp", opts = {} },
      { "iguanacucumber/mag-nvim-lua", name = "cmp-nvim-lua" },
      { "iguanacucumber/mag-buffer",   name = "cmp-buffer" },
      { "iguanacucumber/mag-cmdline",  name = "cmp-cmdline" },
    },
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
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = 'path' }
        }, {
          {
            name = 'cmdline',
            option = {
              ignore_cmds = { 'Man', '!' }
            }
          }
        }),
      })
    end,
  },
}