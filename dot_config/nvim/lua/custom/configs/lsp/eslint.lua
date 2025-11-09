local nvchad_on_attach = require("nvchad.configs.lspconfig").on_attach
local nvchad_capabilities = require("nvchad.configs.lspconfig").capabilities
local capabilities = vim.tbl_deep_extend("force", nvchad_capabilities, require('cmp_nvim_lsp').default_capabilities())
local on_attach = function(client, bufnr)
  nvchad_on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = true
  client.server_capabilities.documentRangeFormattingProvider = true
  -- client.server_capabilities.semanticTokensProvider.full = true
end
local filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }

vim.lsp.config('eslint', {
  filetypes = filetypes,
  on_attach = on_attach,
  capabilities = capabilities,
  settings = {
    -- Vue 2.7でも動作する設定
    workingDirectory = { mode = "auto" },
    format = { enable = true },
    packageManager = "pnpm",
  },
})
vim.lsp.enable('eslint')
