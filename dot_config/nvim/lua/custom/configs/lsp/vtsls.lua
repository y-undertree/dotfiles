local vue_ls_path = vim.fn.stdpath('data')
  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
local filetypes = { 'typescript','javascript','javascriptreact','typescriptreact','vue' }
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_ls_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
  enableForWorkspaceTypeScriptVersions = true,
}

local nvchad_on_attach = require("nvchad.configs.lspconfig").on_attach
local nvchad_capabilities = require("nvchad.configs.lspconfig").capabilities
local capabilities = vim.tbl_deep_extend("force", nvchad_capabilities, require('cmp_nvim_lsp').default_capabilities())
local on_attach = function(client, bufnr)
  nvchad_on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = true
  client.server_capabilities.documentRangeFormattingProvider = true
  client.server_capabilities.semanticTokensProvider.full = true
end

vim.lsp.config('vtsls', {
  filetypes = filetypes,
  settings = { vtsls = { tsserver = { globalPlugins = { vue_plugin } } } },
  on_attach = on_attach,
  capabilities = capabilities
})
vim.lsp.config('vue_ls', {
  filetypes = { 'vue' },
  settings = {
    vue = {
      vueCompilerOptions = {
        target = 'vue2',
      },
    },
  },
  on_attach = on_attach,
  capabilities = capabilities
})
vim.lsp.enable('vtsls')
vim.lsp.enable('vue_ls')
