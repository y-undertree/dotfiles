-- cSpell:disable
-- NOTE: to nvimtools/none-ls.nvim
local present, null_ls = pcall(require, "null-ls")

if not present then
  return
end

-- $XDG_CONFIG_HOME/cspell
local cspell_config_dir = '~/.config/cspell'
-- $XDG_DATA_HOME/cspell
local cspell_data_dir = '~/.local/share/cspell'
local cspell_files = {
  config = vim.call('expand', cspell_config_dir .. '/cspell.json'),
  dotfiles = vim.call('expand', cspell_config_dir .. '/dotfiles.txt'),
  vim = vim.call('expand', cspell_data_dir .. '/vim.txt.gz'),
  user = vim.call('expand', cspell_data_dir .. '/user.json'),
}

-- vim辞書がなければダウンロード
if vim.fn.filereadable(cspell_files.vim) ~= 1 then
  local vim_dictionary_url = 'https://github.com/iamcco/coc-spell-checker/raw/master/dicts/vim/vim.txt.gz'
  io.popen('curl -fsSLo ' .. cspell_files.vim .. ' --create-dirs ' .. vim_dictionary_url)
end

-- ユーザー辞書がなければ作成
if vim.fn.filereadable(cspell_files.user) ~= 1 then
  io.popen('mkdir -p ' .. cspell_data_dir)
  io.popen('touch ' .. cspell_files.user)
  io.popen('echo "{}" >' .. cspell_files.user)
end


local b = null_ls.builtins
local cspell = require('cspell')
-- https://github.com/davidmh/cspell.nvim
local cspell_config = {
  find_json = function()
    return cspell_files.user
  end,
}
-- local cspell_config = {
--   find_json = function()
--     return cspell_files.config
--   end,
-- }
-- local cspell_config_for_action = {
--   find_json = function()
--     return cspell_files.user
--   end,
-- }
-- https://github.com/jose-elias-alvarez/null-ls.nvim/blob/main/doc/BUILTINS.md
local sources = {
  -- b.diagnostics.jsonlint,
  -- -- Ruby
  -- -- gemがないとnull_lsでエラーがでるので注意
  -- b.diagnostics.reek,
  -- b.diagnostics.erb_lint,
  -- b.diagnostics.yamllint,
  -- cspell
  cspell.code_actions.with({ config = cspell_config }),
  cspell.diagnostics.with({ config = cspell_config }),
}

null_ls.setup {
  debug = false,
  sources = sources,
  timeout = 10000,
}
