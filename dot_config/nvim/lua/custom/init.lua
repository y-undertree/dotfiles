-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
--
-- migrate. 後で整理する

-- ------- default mapping -------
-- 入力モード中に素早くjjと入力した場合はESCとみなす
vim.cmd "inoremap <silent> <C-]> <ESC>"
vim.cmd "inoremap <silent> っｊ <ESC>"
-- ESCを2回押すことでハイライトを消す
-- vim.cmd "nnoremap <silent> <Esc><Esc> :nohlsearch<CR>"
vim.cmd "nnoremap <silent> H ^"
vim.cmd "nnoremap <silent> L $"
vim.cmd "vnoremap <silent> H ^"
vim.cmd "vnoremap <silent> L $"
-- cmdlineで省略入力
vim.cmd [[cnoremap <F2> \(.*\)]]
vim.cmd [[tnoremap <ESC> <C-\><C-n>]]
vim.cmd [[cnoremap <C-p> <C-r><C-w>]]
-- vim.cmd('cnoremap initr :<C-u>source $MYVIMRC<CR>')
-- vim.cmd('cnoremap ccd :<C-u>cd %:h<CR>')
-- ------- / default mapping -------

-- https://qiita.com/reireias/items/230c77b3ff5575832654
vim.cmd "set tags +=./tags,tags,./.tags,.tags"
vim.cmd "set showmatch"
--set smartindent
--let php_sql_query=1
--let php_htmlInStrings=1
--let php_folding=1

-- window split
vim.cmd "set splitbelow"
vim.cmd "set splitright"

vim.cmd "set expandtab"
vim.cmd "set smarttab"
-- これが有効だとペーストモードとなり、jjがきかない
--set paste
-- vim.cmd "set textwidth=0"
vim.cmd "set formatoptions=q"
vim.cmd "set whichwrap+=<,>,h,l"
-- vim.cmd('set colorcolumn=80')
vim.cmd "set incsearch"
vim.cmd "set showmatch"
vim.cmd "set list"
vim.cmd "set listchars=tab:>.,space:-,"
vim.cmd "set laststatus=2"
vim.cmd "set showcmd"
vim.cmd "set wildmenu"
vim.cmd "set clipboard+=unnamedplus"
-- folding
vim.cmd "set foldmethod=indent"
vim.cmd "set foldlevel=99"
vim.cmd "set history=200"
vim.cmd "set noswapfile"
vim.cmd "set nobackup"
vim.cmd "set nowritebackup"
vim.cmd "set updatetime=300"
vim.cmd "set noundofile"
vim.cmd "set wildmode=longest,list,full"
vim.cmd "set shell=/bin/zsh"
vim.cmd "let g:strip_whitespace_on_save = 1"
vim.cmd "let g:nnn#set_default_mappings = 0"
vim.cmd "set rnu!"
-- QuickFix format
vim.cmd [[set errorformat+=%f\|%l\ col\ %c\|\ %m"]]

local opt = vim.opt
local g = vim.g
g.mapleader = " "
g.ttimeout = true
g.fileformats = { "unix", "dos", "mac" }
g.fileencodings = { "utf-8", "sjis" }
-- g.ttimeoutlen = 10
opt.termguicolors = true
opt.timeoutlen = 800
opt.tabstop = 2
opt.shiftwidth = 2
opt.wrap = true
opt.linebreak = true
opt.signcolumn = "yes"
opt.ignorecase = true
opt.smartcase = true
opt.hidden = true
opt.cursorline = false

-- spell checking
opt.spell = true
opt.spelllang = { "en_us" }

-- ファイルを開いた時に、カーソルの場所を復元する
vim.api.nvim_create_autocmd({ "BufReadPost" }, {
  pattern = { "*" },
  callback = function()
    vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})

-- vim.cmd [[
-- if has('nvim')
--     augroup terminal_setup | au!
--         autocmd TermOpen * nnoremap <buffer><LeftRelease> <LeftRelease>i
--     augroup end
-- endif
-- ]]
-- profile
vim.api.nvim_create_user_command("Profilestart", function()
  vim.api.nvim_command "profile start profile.log"
  vim.api.nvim_command "profile func *"
  vim.api.nvim_command "profile file *"
end, {})
vim.api.nvim_create_user_command("Profileend", function()
  vim.api.nvim_command "profile pause"
  vim.api.nvim_command "edit profile.log"
end, {})

-- dos'nt save register
vim.cmd [[vnoremap x "_x]]
vim.cmd [[nnoremap x "_x]]
vim.cmd [[vnoremap s "_s]]
vim.cmd [[nnoremap s "_s]]

vim.cmd [[if executable('rg')
    let &grepprg = 'rg --vimgrep'
    set grepformat=%f:%l:%c:%m
endif]]

vim.cmd [[augroup GrepCmd
    autocmd!
    autocmd QuickFixCmdPost vim,grep,make,cfile,cbuffer if len(getqflist()) != 0 | cwindow | endif
augroup END]]

if vim.g.neovide then
  vim.g.neovide_cursor_vfx_mode = "railgun"

  -- Allow clipboard copy paste in neovim
  vim.api.nvim_set_keymap('', '<D-v>', '+p<CR>', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('!', '<D-v>', '<C-R>+', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('t', '<D-v>', '<C-R>+', { noremap = true, silent = true })
  vim.api.nvim_set_keymap('v', '<D-v>', '<C-R>+', { noremap = true, silent = true })

  -- dynamic scale
  vim.g.neovide_scale_factor = 1.0
  local change_scale_factor = function(delta)
    vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
  end
  vim.keymap.set("n", "<D-+>", function()
    change_scale_factor(1.25)
  end).keymap.set("n", "<D-0>", function()
    change_scale_factor(1)
  end)
  vim.keymap.set("n", "<D-->", function()
    change_scale_factor(1 / 1.25)
  end)
end

vim.api.nvim_create_autocmd('TermOpen', {
  group = augroup,
  callback = function(_)
    vim.b.focus_disable = true
  end,
  desc = 'Disable focus autoresize for TermOpen',
})
vim.api.nvim_create_autocmd('FileType', {
  group = augroup,
  pattern = { "qf" },
  callback = function(_)
    vim.b.focus_disable = true
  end,
  desc = 'Disable focus autoresize for FileType',
})
