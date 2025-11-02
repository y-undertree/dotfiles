local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

vim.lsp.config('lua_ls', {
  filetypes = { "lua" },
  on_attach = on_attach,
  capabilities = capabilities,

  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      completion = {
        callSnippet = "Replace",
      },
      diagnostics = {
        globals = { "vim" },
      },
      workspace = {
        library = {
          [vim.fn.expand "$VIMRUNTIME/lua"] = true,
          [vim.fn.expand "$VIMRUNTIME/lua/vim/lsp"] = true,
          [vim.fn.stdpath "data" .. "/lazy/ui/nvchad_types"] = true,
          [vim.fn.stdpath "data" .. "/lazy/lazy.nvim/lua/lazy"] = true,
        },
        maxPreload = 100000,
        preloadFileSize = 10000,
        checkThirdParty = false,
      },
    },
  },
})
vim.lsp.enable('lua_ls')
