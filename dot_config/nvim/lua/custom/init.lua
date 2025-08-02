-- local autocmd = vim.api.nvim_create_autocmd

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })
--
-- migrate. 後で整理する

-- ------- default mapping -------
-- ESCを2回押すことでハイライトを消す
-- vim.cmd "nnoremap <silent> <Esc><Esc> :nohlsearch<CR>"
vim.cmd "nnoremap <silent> H ^"
vim.cmd "nnoremap <silent> L $"
vim.cmd "vnoremap <silent> H ^"
vim.cmd "vnoremap <silent> L $"
-- cmdlineで省略入力
vim.cmd [[cnoremap <F2> \(.*\)]]
vim.cmd [[inoremap jj <ESC>]]
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
vim.cmd "set laststatus=3"
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
opt.lazyredraw = true
opt.cursorline = false
opt.relativenumber = false

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
-- :verbose autocmd CursorMoved
-- :verbose autocmd CursorMovedI
-- :verbose autocmd CursorHold
-- :verbose autocmd CursorHoldI
vim.api.nvim_create_user_command("ProfileStart", function()
  vim.api.nvim_command "profile start /tmp/profile.log"
  vim.api.nvim_command "profile func *"
  vim.api.nvim_command "profile file *"
end, {})
vim.api.nvim_create_user_command("ProfileEnd", function()
  vim.api.nvim_command "profile pause"
  vim.api.nvim_command "profile dump"
  vim.api.nvim_command "edit /tmp/profile.log"
end, {})
vim.api.nvim_create_user_command("ProfileContinue", function()
  vim.api.nvim_command "profile continue"
end, {})

-- dos'nt save register
-- vim.cmd [[vnoremap x "_x]]
-- vim.cmd [[nnoremap x "_x]]
-- vim.cmd [[vnoremap s "_s]]
-- vim.cmd [[nnoremap s "_s]]

-- vim.cmd [[if executable('rg')
--     let &grepprg = 'rg --vimgrep'
--     set grepformat=%f:%l:%c:%m
-- endif]]

-- vim.cmd [[augroup GrepCmd
--     autocmd!
--     autocmd QuickFixCmdPost vim,grep,make,cfile,cbuffer if len(getqflist()) != 0 | cwindow | endif
-- augroup END]]

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

vim.api.nvim_create_user_command("OpenGithubBlamePr", function()
  local line = vim.api.nvim_get_current_line()
  local commit_id = line:match("commit%s*(%w+)")
  if not commit_id then
    local commit_pattern = "%x%x%x%x%x%x%x[%x]*"
    commit_id = line:match(commit_pattern)
  end
  if not commit_id then
    local clipboard = vim.fn.getreg('+')
    commit_id = clipboard
  end
  if not commit_id then
    print("No commit ID found on the current line")
    return
  end

  local command = "git pr-find " .. commit_id
  local handle = io.popen(command, 'r')
  handle:close()
end, {})

local function open_in_direction(new_window)
  local file = vim.fn.expand('<cfile>')
  local line = nil

  -- ファイル名:行番号対応（例: foo.py:42）
  local current_line = vim.api.nvim_get_current_line()
  local filename, lineno = string.match(current_line, "([^: ]+):(%d+)")
  if filename and lineno then
    file = filename
    line = tonumber(lineno)
  end

  -- 入力を取得
  print("方向を入力してください (h/j/k/l): ")
  local char = vim.fn.getchar()
  local key = vim.fn.nr2char(char)

  -- 移動方向と分割コマンドのマッピング
  local direction_map = {
    h = { move = 'wincmd h', split = 'leftabove vsplit' },
    j = { move = 'wincmd j', split = 'belowright split' },
    k = { move = 'wincmd k', split = 'aboveleft split' },
    l = { move = 'wincmd l', split = 'rightbelow vsplit' },
  }

  local direction = direction_map[key]
  if not direction then
    print("無効な入力: " .. key)
    return
  end

  if new_window then
    vim.cmd(direction.split)
  else
    vim.cmd(direction.move)
  end

  vim.cmd('edit ' .. file)
  if line then
    vim.cmd(tostring(line))
  end
end

vim.api.nvim_create_user_command("OpenCurrentFileLine", function()
  open_in_direction(false)
end, {})
vim.api.nvim_create_user_command("OpenCurrentFileLineNewWindow", function()
  open_in_direction(true)
end, {})
