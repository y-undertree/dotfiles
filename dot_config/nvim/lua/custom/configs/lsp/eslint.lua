local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local ts_filetypes = { 'typescript', 'javascript', 'javascriptreact', 'typescriptreact', 'vue' }

vim.lsp.config('eslint', {
  filetypes = ts_filetypes,
  on_attach = function(client, bufnr)
    if on_attach then on_attach(client, bufnr) end

    -- vim.api.nvim_create_autocmd("BufWritePre", {
    --   buffer = bufnr,
    --   command = "EslintFixAll",
    -- })
  end,
  capabilities = capabilities,
  settings = {
    -- Vue 2.7でも動作する設定
    workingDirectory = { mode = "auto" },
    -- codeAction = {
    --   disableRuleComment = { enable = true, location = "separateLine" },
    --   showDocumentation = { enable = true },
    -- },
    format = { enable = true },
    packageManager = "pnpm",
    rulesCustomizations = {},
  },
})
vim.lsp.enable('eslint')
