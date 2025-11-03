local nvchad_on_attach = require("nvchad.configs.lspconfig").on_attach
local nvchad_capabilities = require("nvchad.configs.lspconfig").capabilities
local capabilities = vim.tbl_deep_extend("force", nvchad_capabilities, require('cmp_nvim_lsp').default_capabilities())
local on_attach = function(client, bufnr)
  nvchad_on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = true
  client.server_capabilities.documentRangeFormattingProvider = true
  client.server_capabilities.semanticTokensProvider.full = true
end

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
