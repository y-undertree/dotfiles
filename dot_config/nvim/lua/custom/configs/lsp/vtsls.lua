local vue_ls_path = vim.fn.stdpath('data')
  .. "/mason/packages/vue-language-server/node_modules/@vue/language-server"
local ts_filetypes = { 'typescript','javascript','javascriptreact','typescriptreact','vue' }
local vue_plugin = {
  name = '@vue/typescript-plugin',
  location = vue_ls_path,
  languages = { 'vue' },
  configNamespace = 'typescript',
  enableForWorkspaceTypeScriptVersions = true,
}

local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities
local function vtsls_on_attach(client, bufnr)
  on_attach(client, bufnr)
  client.server_capabilities.semanticTokensProvider.full = true
end

vim.lsp.config('vtsls', {
  filetypes = ts_filetypes,
  settings = { vtsls = { tsserver = { globalPlugins = { vue_plugin } } } },
  on_attach = vtsls_on_attach,
  capabilities = capabilities
})
vim.lsp.config('vue_ls', {
  filetypes = 'vue',
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
