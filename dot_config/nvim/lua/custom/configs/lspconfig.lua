-- cSpell:disable
local nvchad_on_attach = require("nvchad.configs.lspconfig").on_attach
local nvchad_capabilities = require("nvchad.configs.lspconfig").capabilities
local capabilities = vim.tbl_deep_extend("force", nvchad_capabilities, require('cmp_nvim_lsp').default_capabilities())

-- if you just want default config for the servers then put them in a table
-- https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md
local servers = {
  { "html",          { "html" } },
  -- { "cssls",         {"css"} },
  { "stylelint_lsp", { "css" } },
  { "ts_ls",         { "ts" } },
  { "bashls",        { "sh", "zsh" } },
  { "buf_ls",        { "buf" } },
  { "jsonls",        { "json" } },
  { "solargraph",    { "rb" } },
  { "rubocop",       { "rb" } },
  { "yamlls",        { "yaml" } },
  -- { "ansiblels",     {"yaml"} },
  { "vacuum",        { "yaml" } },
}

-- vacuum
vim.filetype.add {
  pattern = {
    [".*/swagger.ya?ml"] = "yaml.openapi",
    [".*/swagger.json"] = "json.openapi",
  },
}

local on_attach = function(client, bufnr)
  nvchad_on_attach(client, bufnr)
  client.server_capabilities.documentFormattingProvider = true
  client.server_capabilities.documentRangeFormattingProvider = true
end

for _, server in ipairs(servers) do
  local lsp = server[1]
  local filetypes = server[2]
  vim.lsp.config(lsp, {
    filetypes = filetypes,
    on_attach = on_attach,
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
