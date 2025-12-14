-- cSpell:disable
---@type MappingsTable
local M = {}

M.disabled = {
  n = {
    ["<tab>"] = "",
    ["<S-tab>"] = "",
    ["n"] = "",
    ["K"] = "",
    ["<leader>v"] = "",
  },
}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["q;"] = { "q:", "command history sugar syntax", opts = { nowait = true } },
    ["<c-Up>"] = { ":resize +5<CR>", "resize window " },
    ["<c-Down>"] = { ":resize -5<CR>", "resize window down" },
    ["<c-left>"] = { ":vertical resize +5<CR>", "resize window left" },
    ["<c-right>"] = { ":vertical resize -5<CR>", "resize window right" },
    ["<leader>yy"] = { ":let @* = expand('%:p')<cr>", "current file absolute path to clipboard" },
    ["<leader>yr"] = { ":let @* = expand('%:p:.')<cr>", "current file relative path to clipboard" },
    ["<leader>yf"] = { ":let @* = expand('%:t:r')<cr>", "current filename without extensions" },
    ["<leader>tt"] = { [[<cmd>ToggleTerm direction="horizontal" <CR>]], "toggle term" },
    ["<leader>ol"] = { "<cmd>AerialToggle<CR>", "outline toggle" },
    ["<leader>on"] = { "<cmd>AerialNavToggle<CR>", "outline navi toggle" },
    ["<leader>lt"] = { [[:lua require("lsp_lines").toggle() <CR>]], "diagnostic lines toggle" },
    ["<leader>an"] = { [[:lua require('neogen').generate() <CR>]], "generate annotatioin for neogen" },
    ["<leader>th"] = { [[:lua require('tsht').nodes()<CR>]], "Treehopper" },
    ["<leader>td"] = { "<cmd>DocsViewToggle<CR>", "toggle view docs" },
    ["<leader>to"] = { "<cmd>NvimTreeToggle<CR>", "toggle neovim tree" },
    ["<leader>tf"] = { "<cmd>NvimTreeFocus<CR>", "focus neovim tree" },
    ["<leader>nn"] = { "<cmd>Yazi<CR>", "Open yazi at the current file" },
    ["<leader>nN"] = { "<cmd>Yazi cwd<CR>", "Open the file manager in nvim's working directory" },
    ["<leader>tl"] = { "<cmd>Translate JA<CR>", "translate to ja" },
    ["<leader>tre"] = { "<cmd>Translate EN -output=register<CR>", "translate to en, output register" },
    ["[c"] = {
      function()
        require('treesitter-context').go_to_context(vim.v.count1)
      end,
      "jumping to context by treesitter context",
    },
    ["<leader>gf"] = { "<cmd>OpenCurrentFileLine<CR>", "open file from current line" },
    ["<leader>gF"] = { "<cmd>OpenCurrentFileLineNewWindow<CR>", "open file to new window from current line" },
    ["<leader>sn"] = { "<cmd>ScratchWithName<CR>", "scratch with name" },
  },
  x = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>tl"] = { "<cmd>Translate JA<CR>", "translate to ja" },
    ["<leader>tre"] = { "<cmd>Translate EN -output=register<CR>", "translate to en, output register" },
    ["<leader>wo"] = { "<Plug>(openbrowser-smart-search)", "search browser" },
  },
}

M.codecompanion = {
  n = {
    ["<leader>co"] = { "<cmd>CodeCompanionChat Toggle<CR>", "toggle codecompanion chat " },
    ["<leader>cca"] = { "<cmd>CodeCompanionActions<CR>", "codecompanion actions" },
    ["<leader>ccco"] = { "<cmd>CodeCompanion /commitstaged<CR>", "generate commit message for codecompanion" },
  },
  x = {
    ["<leader>co"] = { "<cmd>CodeCompanionChat Add<CR>", "add codecompanion chat" },
  },
}

M.hop = {
  n = {
    ["ff"] = { "<cmd>HopWord<CR>", "hop word" },
    ["f/"] = { "<cmd>HopPattern<CR>", "hop pattern" },
    ["fl"] = { "<cmd>HopLineStart<CR>", "hop line" },
  },
  x = {
    ["<leader>ss"] = { "<cmd>HopWord<CR>", "hop word" },
    ["<leader>sp"] = { "<cmd>HopPattern<CR>", "hop pattern" },
    ["<leader>sl"] = { "<cmd>HopLineStart<CR>", "hop line" },
  },
}

M.bookmark = {
  n = {
    ["mm"] = { [[:lua require("bookmarks").bookmark_toggle()<CR>]], "add or remove bookmark at current line" },
    ["mi"] = { [[:lua require("bookmarks").bookmark_ann()<CR>]], "add or edit mark annotation at current line" },
    ["mc"] = { [[:lua require("bookmarks").bookmark_clean()<CR>]], "clean all marks in local buffer" },
    ["mn"] = { [[:lua require("bookmarks").bookmark_next()<CR>]], "jump to next mark in local buffer" },
    ["mp"] = { [[:lua require("bookmarks").bookmark_prev()<CR>]], "jump to previous mark in local buffer" },
    ["ml"] = { [[:lua require("bookmarks").bookmark_list()<CR>]], "show marked file list in quickfix window" },
    ["mx"] = { [[:lua require("bookmarks").bookmark_clear_all()<CR>]], "removes all bookmarks" },
    ["ms"] = { "<cmd> Telescope bookmarks list <CR>", "telescope bookmarks" },
  },
}

M.command_pallet = {
  n = {
    ["<leader>@treesj-toggle"] = { [[<cmd>TSJToggle<CR>]], "treesj toggle" },
    ["<leader>@auto-save-toggle"] = { [[:ASToggle<CR>]], "auto save toggle" },
    ["<leader>@compare-diff"] = { [[:windo diffthis<CR>]], "compare file diff left and right" },
    ["<leader>@edit-snippet-files"] = {
      [[:lua require("luasnip.loaders").edit_snippet_files()<CR>]],
      "edit snippet files",
    },
    ["<leader>@quicker-expand"] = {
      [[:lua require("quicker").expand({ before = 2, after = 2, add_to_existing = true })<CR>]],
      "Expand quickfix context" },
    ["<leader>@quicker-collapse"] = { [[:lua require("quicker").collapse()<CR>]], "Collapse quickfix context" },
    ["<leader>@tig-blame"] = { [[:silent !tmux new-window "tig blame $(echo %:p)"<CR>]], "tig blame current file" },
    ["<leader>@tig-log-in-file"] = { [[:silent !tmux new-window "tig $(echo %:p)"<CR>]], "tig log current file" },
    ["<leader>@mysql-cli"] = { [[:silent !tmux new-window "/usr/local/bin/mycli -h 127.0.0.1 -u root"<CR>]], "mysql cli" },
    ["<leader>@find-and-replace"] = { '<cmd>GrugFar<CR>', "find and replace" },
    ["<leader>@open-finder"] = { ":silent !open %:p:h<CR>", "open finder" },
    ["<leader>@open-sublimetext"] = { ":silent !subl %:p<CR>", "open sublimetext" },
    ["<leader>@open-vscode-current-path"] = { ":silent !NODE_OPTIONS='' code %:p<CR>", "open vscode current path" },
    ["<leader>@open-vscode"] = { ":silent !NODE_OPTIONS='' code <CR>", "open vscode" },
    ["<leader>@open-irb-history"] = { ":edit ~/.config/irb/irb_history<CR>", "open irb history" },
    ["<leader>@open-github"] = { ":silent !gh browse <CR>", "open github repository" },
    ["<leader>@suggest-diff-command"] = { [[:execute 'vert diffsplit' @+]], "suggest diffsplit command with clipboard" },
    ["<leader>@sessions"] = { "<cmd> Telescope session-lens <CR>", "telescope session list" },
    ["<leader>@project-list"] = { "<cmd> Proot <CR>", "project list" },
    ["<leader>@lspsaga-finder"] = { "<cmd>Lspsaga finder <CR>", "lspsaga LSP finder" },
    ["<leader>@docs-view"] = { "<cmd>DocsViewToggle<CR>", "Docs View Toggle" },
    ["<leader>@defined-keymaps"] = { "<cmd> Telescope keymaps <CR>", "Defined Keymaps" },
    ["<leader>@git-worktree"] = { "<cmd>lua require('telescope').extensions.git_worktree.git_worktrees()<CR>", "git worktrees" },
    ["<leader>@create-git-worktree"] = { "<cmd>lua require('telescope').extensions.git_worktree.create_git_worktree()<CR>", "create git worktree" },
  },
}

M.obsidian = {
  n = {
    ["<leader>obf"] = { "<cmd>ObsidianQuickSwitch<CR>", "obsidian quick switch" },
    ["<leader>obo"] = { "<cmd>ObsidianOpen<CR>", "obsidian open" },
  },
}

M.telescope = {
  n = {
    -- find
    ["<leader>fs"] = { [[:lua require("telescope").extensions.smart_open.smart_open({ cwd_only = true })<CR>]], "find files by smart open" },
    ["<leader>ff"] = { [[<cmd> Telescope find_files follow=true hidden=true<CR>]], "find files" },
    ["<leader>fg"] = { "<cmd> Telescope live_grep_args <CR>", "live grep" },
    ["<leader>fd"] = {
      function()
        require('custom.utils.pick_changed_files').pick_changed_files()
      end,
      "telescope changed files",
    },
    ["gl"] = {
      [[:lua require("telescope-live-grep-args.shortcuts").grep_word_under_cursor({ postfix='', quote=false })<cr>]],
      "live grep" },
    ["<leader>jj"] = { "<cmd> Telescope buffers <CR>", "find buffers" },
    ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "find oldfiles" },
    ["<leader>fc"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "find in current buffer" },
    ["<leader>jl"] = { "<cmd> Telescope jumplist <CR>", "telescope jumplist" },
    ["<leader>fq"] = { "<cmd> Telescope quickfixhistory <CR>", "telescope quickfixhistory" },
    ["<leader>fe"] = { "<cmd> Telescope diagnostics<CR>", "telescope diagnostics" },
    ["<leader>fh"] = {
      "<cmd> Telescope highlight-annotate annotations<cr>",
      "telescope highlight-annotate annotations",
    },
    ["<leader>fr"] = { "<cmd> Telescope telescope-alternate alternate_file<cr>", "telescope relation files" },
    ["<leader>hh"] = { "<cmd> Telescope help_tags <CR>", "help page" },
    ["<leader>mh"] = { "<cmd> Telescope heading <CR>", "telescope markdown heading" },
    ["<leader>mc"] = { "<cmd> Telescope macros <CR>", "macros list" },
    ["<leader>so"] = { "<cmd> ScratchOpen<cr>", "scratch open" },
    ["<leader>sf"] = { "<cmd> ScratchOpenFzf<cr>", "scratch fzf" },
    ["<leader>tn"] = { "<cmd> Telescope notify<cr>", "open notifies" },
    ["g]"] = {
      "<cmd>lua require('telescope').extensions.ctags_plus.jump_to_tag()<cr>",
      "ctags jump list for telescope",
      opts = { nowait = true },
    },
  },
  x = {
    ["gl"] = { [[:lua require("telescope-live-grep-args.shortcuts").grep_visual_selection()<cr>]], "live grep" },
  },
}

M.git = {
  n = {
    ["<leader>ghl"] = { ":GetCommitLink<CR>", "copy github code link" },
    ["<leader>gho"] = { ":GitBlameOpenFileURL<CR>", "open github browse with file and line" },
    ["<leader>ghp"] = { ":silent !gh pr view --web <CR>", "open github pr" },
    ["<leader>gby"] = { "<cmd> GitBlameCopySHA<cr>", "copy github blame commit SHA" },
    ["<leader>gbo"] = { "<cmd> GitBlameOpenCommitURL<cr>", "open github blame commit" },
    ["<leader>gbp"] = { "<cmd> OpenGithubBlamePr<cr>", "open github blame pull request" },
    ["<leader>]h"] = { "<cmd>lua require('gitsigns').next_hunk<cr>", "next hunk" },
    ["<leader>[h"] = { "<cmd>lua require('gitsigns').prev_hunk<cr>", "prev hunk" },
    ["<leader>hs"] = { "<cmd>lua require('gitsigns').stage_hunk<cr>", "state hunk" },
    ["<leader>hr"] = { "<cmd>lua require('gitsigns').reset_hunk<cr>", "reset hunk" },
    ["<leader>hp"] = { "<cmd>lua require('gitsigns').preview_hunk<cr>", "preview hunk" },
    ["<leader>ti"] = { "<cmd>TigStatus<CR>", "tig status" },
    ["<leader>gd"] = { "<cmd>GinDiff<cr>", "Git diff" },
  },
  x = {
    ["<leader>ghl"] = { ":GetCommitLink<CR>", "github line link copy" },
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
  },
}

M.legendary = {
  n = {
    ["<leader>cp"] = { "<cmd> Legendary <CR>", "command palette" },
  },
}

M.tmux = {
  n = {
    ["<C-h>"] = { ":NvimTmuxNavigateLeft <CR>", "tmux navigate left" },
    ["<C-j>"] = { ":NvimTmuxNavigateDown <CR>", "tmux navigate down" },
    ["<C-k>"] = { ":NvimTmuxNavigateUp <CR>", "tmux navigate up" },
    ["<C-l>"] = { ":NvimTmuxNavigateRight <CR>", "tmux navigate right" },
  },
}

M.rspec = {
  n = {
    ["<leader>rf"] = { [[:RspecCurrentFile<CR>]], "rspec current file" },
    ["<leader>rn"] = { [[:RspecCurrentLine<CR>]], "rspec nearest" },
    ["<leader>crf"] = { [[:RspecCurrentFileCoverage<CR>]], "rspec current file and coverage" },
    ["<leader>crn"] = { [[:RspecCurrentLineCoverage<CR>]], "rspec nearest and coverage" },
    -- ["<leader>rl"] = { ":call RunLastSpec()<CR>", "run rspec last" },
  },
}

M.browser = {
  n = {
    ["<leader>ws"] = { "<Plug>(openbrowser-smart-search)", "search browser" },
    ["<leader>wo"] = { "<Plug>(openbrowser-open)", "open browser" },
  },
  x = {
    ["<leader>ws"] = { "<Plug>(openbrowser-smart-search)", "search browser" },
    ["<leader>wo"] = { "<Plug>(openbrowser-open)", "open browser" },
  },
}

M.camelsnek = {
  n = {
    ["<leader>csn"] = { "<cmd>Snek<cr>", "convert snake case" },
    ["<leader>ccm"] = { "<cmd>Camel<cr>", "convert camel case" },
    ["<leader>ckb"] = { "<cmd>Kebab<cr>", "convert kebab" },
  },
  x = {
    ["<leader>csn"] = { "<cmd>Snek<cr>", "convert snake case" },
    ["<leader>ccm"] = { "<cmd>Camel<cr>", "convert camel case" },
    ["<leader>ckb"] = { "<cmd>Kebab<cr>", "convert kebab" },
  },
}

M.debugger = {
  n = {
    ["<leader>dbt"] = { [[:lua require"dap".toggle_breakpoint()<CR>]], "debugger toggle breakpoint" },
    ["<leader>dbc"] = { [[:lua require"dap".continue()<CR>]], "debugger continue" },
    ["<leader>dbo"] = { [[:lua require'dap'.repl.open()<CR>]], "debugger console open" },
    ["<leader>dbn"] = { [[:lua require"dap".step_over()<CR>]], "debugger step_over" },
    ["<leader>dbi"] = { [[:lua require"dap".step_into()<CR>]], "debugger step_into" },
    ["<leader>dbh"] = { [[:lua require"dap.ui.widgets".hover()<CR>]], "debugger hover" },
    ["<leader>dbruby"] = { [[:lua require"dap".run('ruby')<CR>]], "debugger ruby run" },
  },
}

M.ruby = {
  n = {
    ["<leader>rc"] = { [[:lua require('ror.commands').list_commands()<CR>]], "rails commands" },
  },
}

M.tabufline = {
  plugin = true,

  n = {
    -- cycle through buffers
    ["<S-k>"] = {
      function()
        require("nvchad.tabufline").tabuflineNext()
      end,
      "Goto next buffer",
    },

    ["<S-j>"] = {
      function()
        require("nvchad.tabufline").tabuflinePrev()
      end,
      "Goto prev buffer",
    },
  },
}

M.lspconfig = {
  plugin = true,

  n = {
    ["<leader>k"] = {
      function()
        vim.lsp.buf.hover()
      end,
      "LSP hover",
    },
  },
}

-- lua/nvchad/configs/lspconfig.lua
M.lsp_support = {
  n = {
    ["gj"] = { "<cmd>Lspsaga peek_definition<CR>", "lspsaga open peek_definition" },
    ["gt"] = { "<cmd>Lspsaga peek_type_definition<CR>", "lspsaga peek_type_definition" },
    ["ge"] = { "<cmd>Lspsaga show_cursor_diagnostics<CR>", "lspsaga show_cursor_diagnostics" },
    ["gk"] = { "<cmd>Lspsaga hover_doc ++keep<CR>", "lspsaga hover_doc keep" },
    ["[e"] = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", "diagnostic_jump_prev" },
    ["]e"] = { "<cmd>Lspsaga diagnostic_jump_next<CR>", "diagnostic_jump_next" },
    ["<leader>ca"] = { "<cmd>Lspsaga code_action<CR>", "lspsaga Code action" },
    ["<leader>re"] = { [[<cmd>Lspsaga rename<CR>]], "lsp rename" },
  },
}


M.octo = {
  n = {
    ["@octo-review-comment"] = { "<cmd>Octo review comment<CR>", "Add comment for Octo" },
    ["@octo-review-start"] = { "<cmd>Octo review start<CR>", "Start review for Octo" },
    ["@octo-review-resume"] = { "<cmd>Octo review resume<CR>", "Resume review for Octo" },
    ["@octo-review-close"] = { "<cmd>Octo review close<CR>", "Close review for Octo" },
    ["@octo-review-submit"] = { "<cmd>Octo review submit<CR>", "Submit review for Octo" },
  },
}

return M
