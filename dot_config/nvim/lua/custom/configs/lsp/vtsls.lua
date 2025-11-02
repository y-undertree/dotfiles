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

-- local on_attach = require("plugins.configs.lspconfig").on_attach
-- local capabilities = require("plugins.configs.lspconfig").capabilities

vim.lsp.config('vtsls', {
  filetypes = ts_filetypes,
  settings = { vtsls = { tsserver = { globalPlugins = { vue_plugin } } } }
})
vim.lsp.config('vue_ls', {
  settings = {
    vue = {
      vueCompilerOptions = {
        target = 'vue2',
      },
    },
  },
})
vim.lsp.enable('vtsls')
vim.lsp.enable('vue_ls')
