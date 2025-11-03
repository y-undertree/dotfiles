local filetypes = { 'ruby' }
local nvchad_on_attach = require("nvchad.configs.lspconfig").on_attach
local nvchad_capabilities = require("nvchad.configs.lspconfig").capabilities
local capabilities = vim.tbl_deep_extend("force", nvchad_capabilities, require('cmp_nvim_lsp').default_capabilities())
local on_attach = function(client, bufnr)
  nvchad_on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = true
  client.server_capabilities.documentRangeFormattingProvider = true
end

-- https://github.com/mason-org/mason.nvim/issues/1777
vim.lsp.config('rubocop', {
  filetypes = filetypes,
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { vim.fn.expand("~/.asdf/shims/rubocop"), "--lsp" }
})
vim.lsp.enable('rubocop')
