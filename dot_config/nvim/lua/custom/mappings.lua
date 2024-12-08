-- cSpell:disable
---@type MappingsTable
local M = {}

M.disabled = {
  n = {
    ["<tab>"] = "",
    ["<S-tab>"] = "",
    ["n"] = "",
    ["K"] = "",
  },
}

M.general = {
  n = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<c-Up>"] = { ":resize +5<CR>", "resize window " },
    ["<c-Down>"] = { ":resize -5<CR>", "resize window down" },
    ["<c-left>"] = { ":vertical resize +5<CR>", "resize window left" },
    ["<c-right>"] = { ":vertical resize -5<CR>", "resize window right" },
    ["<leader>yy"] = { ":let @* = expand('%:p')<cr>", "current file absolute path to clipboard" },
    ["<leader>yr"] = { ":let @* = expand('%:p:.')<cr>", "current file relative path to clipboard" },
    ["<leader>yf"] = { ":let @* = expand('%:t:r')<cr>", "current filename without extensions" },
    ["<leader>sbo"] = { ":!subl %:p<CR>", "sublime editor open" },
    ["<leader>vso"] = { ":!NODE_OPTIONS='' code %:p<CR>", "vscode open" },
    ["<leader>irbh"] = { ":edit ~/.config/irb/irb_history<CR>", "irb history open" },
    ["<leader>tt"] = { [[<cmd>ToggleTerm direction="horizontal" <CR>]], "toggle term" },
    ["<leader>ol"] = { "<cmd>AerialToggle<CR>", "outline toggle" },
    ["<leader>on"] = { "<cmd>AerialNavToggle<CR>", "outline navi toggle" },
    ["<leader>lt"] = { [[:lua require("lsp_lines").toggle() <CR>]], "diagnostic lines toggle" },
    ["<leader>an"] = { [[:lua require('neogen').generate() <CR>]], "generate annotatioin for neogen" },
    ["<leader>diff"] = { [[:vert diffs ]], "diffsplit open to vertical" },
    ["<leader>th"] = { [[:lua require('tsht').nodes()<CR>]], "Treehopper" },
    ["<leader>td"] = { "<cmd>DocsViewToggle<CR>", "toggle view docs" },
    ["<leader>to"] = { "<cmd>NvimTreeToggle<CR>", "toggle neovim tree" },
    ["<leader>tf"] = { "<cmd>NvimTreeFocus<CR>", "focus neovim tree" },
    ["<leader>nn"] = { "<cmd>Yazi<CR>", "Open yazi at the current file" },
    ["<leader>nN"] = { "<cmd>Yazi cwd<CR>", "Open the file manager in nvim's working directory" },
  },
  x = {
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>sna"] = { [[:lua require("scissors").addNewSnippet() <CR>]], "add snippet" },
  },
}

M.hop = {
  n = {
    ["ss"] = { "<cmd>HopWord<CR>", "hop word" },
    ["sp"] = { "<cmd>HopPattern<CR>", "hop pattern" },
    ["sl"] = { "<cmd>HopLineStart<CR>", "hop line" },
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
    ["<leader>@task-select"] = { [[<cmd>Telescope toggletasks spawn<CR>]], "task select to spawn" },
    ["<leader>@auto-save-toggle"] = { [[:ASToggle<CR>]], "auto save toggle" },
    ["<leader>@compare-file-diff"] = { [[:windo diffthis<CR>]], "compare file diff" },
    ["<leader>@edit-snippet-files"] = {
      [[:lua require("luasnip.loaders").edit_snippet_files()<CR>]],
      "edit snippet files",
    },
    ["<leader>@quicker-expand"] = { [[:lua require("quicker").expand({ before = 2, after = 2, add_to_existing = true })<CR>]], "Expand quickfix context" },
    ["<leader>@quicker-collapse"] = { [[:lua require("quicker").collapse()<CR>]], "Collapse quickfix context" },
    ["<leader>@tig-blame"] = { [[:!tmux split-window -h "tig blame $(echo %:p)"<CR>]], "tig blame current file" },
    ["<leader>@mysql-cli"] = { [[:!tmux split-window -h "/usr/local/bin/mycli -h 127.0.0.1 -u root"<CR>]], "mysql cli" },
    ["<leader>@macro-menu"] = { [[:lua require('NeoComposer.ui').toggle_macro_menu()<CR>]], "macro menu open" },
  },
}

M.obsidian = {
  n = {
    ["<leader>obf"] = { "<cmd>ObsidianQuickSwitch<CR>", "obsidian quick switch" },
    ["<leader>obo"] = { "<cmd>ObsidianOpen<CR>", "obsidian open" },
  },
}

M.search = {
  n = {
    ["<leader>ss"] = { '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', "replace and search by spectre" },
    ["<leader>sc"] = {
      '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
      "replace and search on current file by spectre",
    },
  },
  x = {
    ["<leader>ss"] = { '<esc><cmd>lua require("spectre").open_visual()<CR>', "Search current word" },
    ["<leader>sc"] = {
      '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
      "replace and search on current file by spectre",
    },
  },
}

M.telescope = {
  n = {
    -- find
    ["<leader>ff"] = { [[:lua require("telescope").extensions.smart_open.smart_open({ cwd_only = true })<CR>]], "find files by smart open" },
    ["<leader>fa"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "find all" },
    ["<leader>fg"] = { "<cmd> Telescope live_grep_args <CR>", "live grep" },
    ["gl"] = { [[:lua require("telescope-live-grep-args.shortcuts").grep_word_under_cursor({ postfix='', quote=false })<cr>]], "live grep" },
    ["<leader>jj"] = { "<cmd> Telescope buffers <CR>", "find buffers" },
    ["<leader>fo"] = { "<cmd> Telescope oldfiles <CR>", "find oldfiles" },
    ["<leader>fc"] = { "<cmd> Telescope current_buffer_fuzzy_find <CR>", "find in current buffer" },
    ["<leader>jl"] = { "<cmd> Telescope jumplist <CR>", "telescope jumplist" },
    ["<leader>fq"] = { "<cmd> Telescope quickfixhistory <CR>", "telescope quickfixhistory" },
    ["<leader>fe"] = { "<cmd> Telescope diagnostics<CR>", "telescope diagnostics" },
    ["<leader>fs"] = { "<cmd> Telescope treesitter<CR>", "telescope symbol treesitter" },
    ["<leader>fh"] = {
      "<cmd> Telescope highlight-annotate annotations<cr>",
      "telescope highlight-annotate annotations",
    },
    ["<leader>fr"] = { "<cmd> Telescope telescope-alternate alternate_file<cr>", "telescope relation files" },
    ["<leader>hh"] = { "<cmd> Telescope help_tags <CR>", "help page" },
    ["<leader>hk"] = { "<cmd> Telescope keymaps <CR>", "find in keymappings" },
    ["<leader>sl"] = { "<cmd> Telescope session-lens <CR>", "telescope session list" },
    ["<leader>mh"] = { "<cmd> Telescope heading <CR>", "telescope markdown heading" },
    ["<leader>mc"] = { "<cmd> Telescope macros <CR>", "macros list" },
    ["<leader>yh"] = { "<cmd> Telescope yank_history <CR>", "yank history" },
    ["<leader>cz"] = { "<cmd> lua require('telescope').extensions.chezmoi.find_files()<cr>", "chezmoi find files" },
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

M.yanky = {
  n = {
    ["y"] = { "<Plug>(YankyYank)", "Yank text" },
    ["p"] = { "<Plug>(YankyPutAfter)", "Put yanked text after cursor" },
    ["P"] = { "<Plug>(YankyPutBefore)", "Put yanked text before cursor" },
    ["gp"] = { "<Plug>(YankyGPutAfter)", "Put yanked text after selection" },
    ["gP"] = { "<Plug>(YankyGPutBefore)", "Put yanked text before selection" },
    ["<c-p>"] = { "<Plug>(YankyPreviousEntry)", "Select previous entry through yank history" },
    -- ["<c-n>"] = { "<Plug>(YankyNextEntry)", "Select next entry through yank history" },
    ["]p"] = { "<Plug>(YankyPutIndentAfterLinewise)", "Put indented after cursor (linewise)" },
    ["[p"] = { "<Plug>(YankyPutIndentBeforeLinewise)", "Put indented before cursor (linewise)" },
    ["]P"] = { "<Plug>(YankyPutIndentAfterLinewise)", "Put indented after cursor (linewise)" },
    ["[P"] = { "<Plug>(YankyPutIndentBeforeLinewise)", "Put indented before cursor (linewise)" },
    [">p"] = { "<Plug>(YankyPutIndentAfterShiftRight)", "Put and indent right" },
    ["<p"] = { "<Plug>(YankyPutIndentAfterShiftLeft)", "Put and indent left" },
    [">P"] = { "<Plug>(YankyPutIndentBeforeShiftRight)", "Put before and indent right" },
    ["<P"] = { "<Plug>(YankyPutIndentBeforeShiftLeft)", "Put before and indent left" },
    ["=p"] = { "<Plug>(YankyPutAfterFilter)", "Put after applying a filter" },
    ["=P"] = { "<Plug>(YankyPutBeforeFilter)", "Put before applying a filter" },
  }
}

M.git = {
  n = {
    ["<leader>ghl"] = { ":GetCommitLink<CR>", "github line link copy" },
    ["<leader>gs"] = { ":Neogit cwd=%:p:h<CR>", "git stage by neo-git" },
    ["<leader>git"] = { [[<cmd>Neogit<CR>]], "neogit" },
    ["<leader>cf"] = { "<cmd> Easypick changed_files<cr>", "telescope changed files for git" },
    ["<leader>P"] = { "<cmd> OpenGithubPr<cr>", "open github pull request" },
  },
  x = {
    ["<leader>ghl"] = { ":GetCommitLink<CR>", "github line link copy" },
    [";"] = { ":", "enter command mode", opts = { nowait = true } },
    ["<leader>sna"] = { [[:lua require("scissors").addNewSnippet() <CR>]], "add snippet" },
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

M.lsp_support = {
  n = {
    -- ["gr"] = { "<cmd>Lspsaga finder <CR>", "lspsaga LSP finder - Find the symbol's definition" },
    -- ["gj"] = { "<cmd>Lspsaga peek_definition<CR>", "lspsaga open peek_definition" },
    -- ["gt"] = { "<cmd>Lspsaga peek_type_definition<CR>", "lspsaga peek_type_definition" },
    ["<leader>dial"] = { "<cmd>Lspsaga show_line_diagnostics<CR>", "lspsaga show_line_diagnostics" },
    ["<leader>diab"] = { "<cmd>Lspsaga show_buf_diagnostics<CR>", "lspsaga show_buf_diagnostics" },
    ["<leader>diac"] = { "<cmd>Lspsaga show_cursor_diagnostics<CR>", "lspsaga show_cursor_diagnostics" },
    ["[e"] = { "<cmd>Lspsaga diagnostic_jump_prev<CR>", "diagnostic_jump_prev" },
    ["]e"] = { "<cmd>Lspsaga diagnostic_jump_next<CR>", "diagnostic_jump_next" },
    ["<leader>ca"] = { "<cmd>Lspsaga code_action<CR>", "lspsaga Code action" },
    ["gK"] = { "<cmd>Lspsaga hover_doc ++keep<CR>", "lspsaga hover_doc keep" },
    ["<leader>ra"] = { "<cmd>Lspsaga rename<CR>", "lspsaga rename" },
    ["gi"] = { "<cmd>Glance implementations<CR>", "Glance implementations" },
    ["gr"] = { "<cmd>Glance references<CR>", "Glance references" },
    ["gj"] = { "<cmd>Glance definitions<CR>", "Glance definitions" },
    ["gt"] = { "<cmd>Glance type_definitions <CR>", "Glance type_definitions" },
  },
  x = {
    ["<leader>wo"] = { "<Plug>(openbrowser-smart-search)", "search browser" },
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

return M
