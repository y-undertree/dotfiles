return {
  {
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    config = function(_, opts)
      require("luasnip").config.set_config(opts)

      vim.g.vscode_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/snippets/vscode"
      vim.g.vscode_standalone_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/snippets/vscode/all.code-snippets"
      vim.g.snipmate_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/snippets/snipmate"
      vim.g.lua_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/snippets/lua"

      -- vscode format
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }
      require("luasnip.loaders.from_vscode").load_standalone { path = vim.g.vscode_standalone_snippets_path or "" }

      -- snipmate format
      require("luasnip.loaders.from_snipmate").load()
      require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }

      -- lua format
      require("luasnip.loaders.from_lua").load()
      require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }

      vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
          if
              require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
              and not require("luasnip").session.jump_active
          then
            require("luasnip").unlink_current()
          end
        end,
      })
    end,
  },
}