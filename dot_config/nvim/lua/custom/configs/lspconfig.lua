-- cSpell:disable
local on_attach = require("plugins.configs.lspconfig").on_attach
local capabilities = require("plugins.configs.lspconfig").capabilities

-- if you just want default config for the servers then put them in a table
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {
  "html",
  "cssls",
  "stylelint_lsp",
  "ts_ls",
  "solargraph",
  "ansiblels",
  "bashls",
  "buf_ls",
  "jsonls",
  "rubocop",
  "yamlls",
  "vacuum",
}

-- vacuum
vim.filetype.add {
  pattern = {
    [".*/swagger.ya?ml"] = "yaml.openapi",
    [".*/swagger.json"] = "json.openapi",
  },
}

for _, lsp in ipairs(servers) do
  vim.lsp.config(lsp, {
    -- on_attach = on_attach,
    on_attach = function(client, bufnr)
      on_attach(client, bufnr)
      client.server_capabilities.documentFormattingProvider = true
      client.server_capabilities.documentRangeFormattingProvider = true
    end,
    capabilities = capabilities,
  })
  vim.lsp.enable(lsp)
end

require("custom.configs.lsp.lua_ls")
require("custom.configs.lsp.vtsls")
require("custom.configs.lsp.eslint")

-- plugin/workspace.lua（好きな場所で読み込み）
local ws = (vim.lsp.buf.list_workspace_folders()[1]) or vim.fn.getcwd()
vim.env.WORKSPACE_FOLDER = ws
