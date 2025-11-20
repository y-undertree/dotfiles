-- cSpell:disable
local overrides = require "custom.configs.overrides"

---@type NvPluginSpec[]
local plugins = {

  -- Override plugin definition options
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      -- format & linting
      {
        "nvimtools/none-ls.nvim",
        config = function()
          require "custom.configs.null-ls"
        end,
      },
    },
    config = function()
      require "nvchad.configs.lspconfig"
      require "custom.configs.lspconfig"
    end, -- Override to setup mason-lspconfig
  },
  -- override plugin configs
  {
    "williamboman/mason.nvim",
    opts = overrides.mason,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function()
      local default_opts = require "nvchad.configs.treesitter"
      local opts = overrides.treesitter
      return vim.tbl_deep_extend("force", default_opts, opts)
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    opts = function()
      local default_opts = require "nvchad/configs/gitsigns"
      local opts = overrides.gitsigns
      return vim.tbl_deep_extend("force", default_opts, opts)
    end,
  },
  {
    "nvim-tree/nvim-tree.lua",
    opts = overrides.nvimtree,
  },
  {
    "nvim-telescope/telescope.nvim",
    opts = function()
      local default_opts = require "nvchad.configs.telescope"
      local opts = require "custom.configs.telescope_options"
      return vim.tbl_deep_extend("force", default_opts, opts)
    end,
  },
  {
    "hrsh7th/nvim-cmp",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = {
      { 'hrsh7th/cmp-cmdline' },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { 'roginfarrer/cmp-css-variables' },
      { "ray-x/cmp-treesitter" },
      {
        "zbirenbaum/copilot-cmp",
        -- event = { "InsertEnter", "LspAttach" },
        -- fix_pairs = true,
        config = function()
          require("copilot_cmp").setup()
        end,
      },
    },
    opts = function()
      local default_opts = require "nvchad.configs.cmp"
      local opts = require "custom.configs.cmp"
      return vim.tbl_deep_extend("force", default_opts, opts)
    end,
    config = function(_, opts)
      local cmp = require "cmp"
      cmp.setup(opts)
      cmp.setup.filetype("DressingInput", {
        sources = cmp.config.sources { { name = "omni" } },
      })
      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
      cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
          },
          {
            {
              name = 'cmdline',
              option = {
                ignore_cmds = { 'Man', '!' }
              }
            }
          }),
      })
    end,
  },
  {
    "folke/snacks.nvim",
    lazy = false,
    priority = 1000
  },
  {
    -- snippet plugin
    "L3MON4D3/LuaSnip",
    version = "v2.*",
    build = "make install_jsregexp",
    config = function(_, opts)
      require("luasnip").config.set_config(opts)

      vim.g.vscode_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/snippets/vscode"
      vim.g.vscode_standalone_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/snippets/vscode/all.code-snippets"
      vim.g.snipmate_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/snippets/snipmate"
      vim.g.lua_snippets_path = vim.fn.stdpath "config" .. "/lua/custom/snippets/lua"

      -- vscode format
      require("luasnip.loaders.from_vscode").lazy_load()
      require("luasnip.loaders.from_vscode").lazy_load { paths = vim.g.vscode_snippets_path or "" }
      require("luasnip.loaders.from_vscode").load_standalone { path = vim.g.vscode_standalone_snippets_path or "" }

      -- snipmate format
      require("luasnip.loaders.from_snipmate").load()
      require("luasnip.loaders.from_snipmate").lazy_load { paths = vim.g.snipmate_snippets_path or "" }

      -- lua format
      require("luasnip.loaders.from_lua").load()
      require("luasnip.loaders.from_lua").lazy_load { paths = vim.g.lua_snippets_path or "" }

      -- local snippet_path = vim.fn.expand("~/.snippets/")
      -- local filetypes = {
      --   javascript = "javascript.lua",
      --   ruby = "ruby.lua",
      -- }
      --
      -- for ft, file in pairs(filetypes) do
      --   local snippets = loadfile(snippet_path .. file)()
      --   require("luasnip").add_snippets(ft, snippets)
      -- end

      vim.api.nvim_create_autocmd("InsertLeave", {
        callback = function()
          if
              require("luasnip").session.current_nodes[vim.api.nvim_get_current_buf()]
              and not require("luasnip").session.jump_active
          then
            require("luasnip").unlink_current()
          end
        end,
      })
    end,
  },
  -- Install a plugin
  {
    "davidmh/cspell.nvim",
    dependencies = { "nvimtools/none-ls.nvim" },
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    config = function()
      vim.diagnostic.config { virtual_text = false }
      require("lspsaga").setup {
        finder = {
          right_width = 0.7,
          default = 'tyd+def+imp+ref',
          keys = {
            vsplit = 'v',
            split = 's',
            tabe = 't',
            tabnew = 'r'
          }
        },
        definition = {
          keys = {
            edit = 'o',
            vsplit = 'v',
            split = 's',
            tabe = 't'
          }
        },
        hover_doc = {
          open_link = 'wo',
        },
        symbol_in_winbar = {
          enable = false,
          folder_level = 7,
        },
        request_timeout = 5000,
        outline = {
          -- win_position = "left",
        },
        lightbulb = {
          virtual_text = false,
          debounce = 400,
        },
        diagnostic = {
          diagnostic_only_current = false,
        },
        code_action = {
          show_server_name = true,
          extend_gitsigns = true,
        },
      }
    end,
    dependencies = {
      { "nvim-tree/nvim-web-devicons" },
      { "nvim-treesitter/nvim-treesitter" },
      { "neovim/nvim-lspconfig" },
    },
  },
  {
    "smoka7/hop.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      -- you can configure Hop the way you like here; see :h hop-config
      require("hop").setup { keys = "etovxqpdygfblzhckisuran" }
      local hop = require "hop"
      local directions = require("hop.hint").HintDirection
      vim.keymap.set("", "f", function()
        hop.hint_char1 { direction = directions.AFTER_CURSOR, current_line_only = true }
      end, { remap = true })
      vim.keymap.set("", "F", function()
        hop.hint_char1 { direction = directions.BEFORE_CURSOR, current_line_only = true }
      end, { remap = true })
    end,
  },
  {
    'mfussenegger/nvim-treehopper',
    event = "VeryLazy",
    dependencies = {
      { "nvim-treesitter/nvim-treesitter" },
      { "smoka7/hop.nvim" }, -- for curl, log wrapper
    },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VeryLazy",
    config = function()
      require("toggleterm").setup {
        start_in_insert = true,
      }
      -- rspec
      _rspec_current_line = function(count, is_coverage)
        local linenr = vim.api.nvim_win_get_cursor(0)[1]
        coverage_prefix = is_coverage and "COVERAGE=true " or ""
        require("toggleterm").exec(
          coverage_prefix .. "bundle exec rspec " .. vim.fn.expand "%" .. ":" .. linenr .. ";beep", count)
      end
      _rspec_current_file = function(count, is_coverage)
        coverage_prefix = is_coverage and "COVERAGE=true " or ""
        require("toggleterm").exec(coverage_prefix .. "bundle exec rspec " .. vim.fn.expand "%" .. ";beep", count)
      end

      local Terminal      = require('toggleterm.terminal').Terminal
      local tig_status    = Terminal:new({
        start_in_insert = true,
        insert_mappings = false,
        cmd = "tig status",
        dir = "git_dir",
        hidden = true,
        direction = "float",
        close_on_exit = false,
      })
      _tig_status         = function()
        tig_status:toggle()
      end

      vim.cmd [[command! -count=1 TigStatus lua _tig_status()]]
      vim.cmd [[command! -count=1 RspecCurrentLine lua _rspec_current_line(<count>, false)]]
      vim.cmd [[command! -count=1 RspecCurrentFile lua _rspec_current_file(<count>, false)]]
      vim.cmd [[command! -count=1 RspecCurrentLineCoverage lua _rspec_current_line(<count>, true)]]
      vim.cmd [[command! -count=1 RspecCurrentFileCoverage lua _rspec_current_file(<count>, true)]]
    end,
  },
  {
    "mechatroner/rainbow_csv",
    ft = { "csv" },
  },
  {
    "zbirenbaum/copilot.lua",
    event = { "InsertEnter", "LspAttach" },
    enabled = true,
    config = function()
      require("copilot").setup {
        copilot_node_command = vim.fn.expand("$HOME") .. '/.asdf/installs/nodejs/24.11.1/bin/node',
        suggestion = {
          enabled = false,
          -- auto_trigger = true,
          -- debounce = 75,
          -- keymap = {
          --   accept = "<C-]>",
          --   accept_word = false,
          --   accept_line = false,
          --   next = "<C-n>",
          --   prev = "<C-p>",
          --   dismiss = "<C-e>",
          -- },
        },
        panel = { enabled = false },
        filetypes = {
          yaml = true,
          markdown = true,
          help = true,
          gitcommit = true,
          gitrebase = true,
          hgcommit = true,
          svn = true,
          cvs = true,
          javascript = true,
          typescript = true,
          ['*'] = true,
        },
      }
    end,
  },
  {
    "RRethy/vim-illuminate",
    init = function()
      require("core.utils").lazy_load "vim-illuminate"
    end,
    config = function()
      require("illuminate").configure {
        providers = {
          "treesitter",
          "regex",
          "lsp",
        },
        -- providers_regex_syntax_allowlist = {
        --   "ruby",
        --   "lua",
        --   "markdown",
        --   "text",
        -- },
        large_file_cutoff = 1000,
        min_count_to_highlight = 1,
        filetypes_denylist = {
          "telescope",
          "quickfix",
          "nvim-tree",
        },
      }
    end,
  },
  {
    "otavioschwanck/telescope-alternate",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    'ThePrimeagen/git-worktree.nvim',
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {},
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if you prefer nvim-web-devicons
    lazy = false,
  },
  {
    "gnfisher/nvim-telescope-ctags-plus",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "danielfalk/smart-open.nvim",
    branch = "0.2.x",
    dependencies = {
      "kkharji/sqlite.lua",
      { "nvim-telescope/telescope.nvim" },
      { "nvim-telescope/telescope-fzf-native.nvim" },
    },
  },
  {
    "nvim-telescope/telescope-live-grep-args.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "nvim-telescope/telescope-media-files.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
  },
  {
    "debugloop/telescope-undo.nvim",
    dependencies = { -- note how they're inverted to above example
      {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
  },
  {
    "folke/todo-comments.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "keaising/im-select.nvim",
    event = "VeryLazy",
    config = function()
      require("im_select").setup {
        default_im_select = "com.apple.keylayout.ABC",
        default_command = "/usr/local/bin/im-select",
        set_default_events = { "InsertLeave", "CmdlineLeave" },
        set_previous_events = {},
      }
    end,
  },
  {
    "pwntester/octo.nvim",
    cmd = "Octo",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      require("octo").setup()
    end,
  },
  {
    "mrjones2014/smart-splits.nvim",
    config = function()
      require("smart-splits").setup {
        move_cursor_same_row = true,
        cursor_follows_swapped_bufs = false,
      }
    end,
  },
  {
    "folke/which-key.nvim",
    -- TODO: Needs adjustment in v3. There are currently no problems.
    -- opts = overrides.whichkey,
    dependencies = {
      { "echasnovski/mini.nvim" },
      { "nvim-tree/nvim-web-devicons" },
    },
  },
  {
    "mrjones2014/legendary.nvim",
    event = "VeryLazy",
    config = function()
      local keymaps = {}
      for _, keymap in pairs(vim.api.nvim_get_keymap "n") do
        if keymap["desc"] then
          table.insert(keymaps, {
            keymap["lhs"],
            keymap["rhs"],
            description = keymap["desc"],
            opts = {
              silent = (keymap["silent"] == 1) and true or false,   -- use `silent` when creating keymaps
              noremap = (keymap["noremap"] == 1) and true or false, -- use `noremap` when creating keymaps
              nowait = (keymap["nowait"] == 1) and true or false,   -- use `nowait` when creating keymaps
              expr = (keymap["expr"] == 1) and true or false,       -- use `expr` when creating keymaps
            }
          })
        end
      end
      require("legendary").setup {
        keymaps = keymaps,
        extensions = {
          -- default settings shown below:
          smart_splits = {
            directions = { "h", "j", "k", "l" },
            mods = {
              -- for moving cursor between windows
              move = "<C>",
              -- for resizing windows
              resize = false,
              -- for swapping window buffers
              swap = {
                -- this will create the mapping like
                -- <leader><C-h>
                -- <leader><C-j>
                -- <leader><C-k>
                -- <leader><C-l>
                mod = "<C>",
                prefix = "<leader>",
              },
            },
          },
        },
        default_item_formatter = function(item)
          -- https://github.com/mrjones2014/legendary.nvim/blob/master/lua/legendary/ui/format.lua#L17
          local Toolbox = require "legendary.toolbox"
          local Config = require "legendary.config"

          if Toolbox.is_keymap(item) then
            return {
              Config.icons.keymap or table.concat(item --[[@as Keymap]]:modes(), ", "),
              item.description,
              item.keys,
            }
          elseif Toolbox.is_command(item) then
            return {
              Config.icons.command,
              item.cmd,
              item.description,
            }
          elseif Toolbox.is_autocmd(item) then
            local pattern = vim.tbl_get(item, "opts", "pattern") or { "*" }
            if type(pattern) == "string" then
              pattern = { pattern }
            end
            return {
              table.concat(item.events, ", "),
              table.concat(pattern, ", "),
              item.description,
            }
          elseif Toolbox.is_function(item) then
            return {
              Config.icons.fn,
              "<function>",
              item.description,
            }
          elseif Toolbox.is_itemgroup(item) then
            return {
              item.icon or Config.icons.itemgroup,
              item.name,
              item.description or "Expand to select an item...",
            }
          else
            -- unreachable
            return {
              vim.inspect(item),
              "",
              "",
            }
          end
        end,
      }
    end,
    dependencies = {
      "kkharji/sqlite.lua",
      "stevearc/dressing.nvim",
      "mrjones2014/smart-splits.nvim",
    },
  },
  {
    "ntpeters/vim-better-whitespace",
    keys = "<C-s>",
    cmd = "ToggleWhitespace",
  },
  {
    "slim-template/vim-slim",
    ft = "slim",
  },
  {
    "RRethy/nvim-treesitter-endwise",
    lazy = false,
    -- init = function()
    --   require("core.utils").lazy_load "nvim-treesitter-endwise"
    -- end,
  },
  {
    "nvim-treesitter/nvim-treesitter-context",
    lazy = false,
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesitter-context").setup {
        enable = true,            -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0,            -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0,    -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = "outer",     -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = "cursor",          -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20,     -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      }
    end,
  },
  {
    "sindrets/diffview.nvim",
    event = "VeryLazy"
  },
  {
    "AndrewRadev/linediff.vim",
    cmd = "Linediff",
  },
  {
    "kylechui/nvim-surround",
    event = "VeryLazy",
    config = function()
      require("nvim-surround").setup {}
    end,
    dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-treesitter/nvim-treesitter-textobjects" },
  },
  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
    config = function()
      require("bqf").setup {
        preview = {
          wrap = true,
        },
      }
    end,
  },
  {
    "tyru/open-browser.vim",
    init = function()
      require("core.utils").lazy_load "open-browser.vim"
    end,
  },
  {
    'rmagatti/auto-session',
    lazy = false,
    envet = "VeryLazy",
    dependencies = {
      { "nvim-telescope/telescope.nvim" }
    },
    config = function()
      vim.o.sessionoptions = "buffers,curdir,tabpages,winsize,winpos,localoptions"
      require("auto-session").setup({
        log_level = "error",
        use_git_branch = true,
        suppressed_dirs = { '~/', '~/Downloads', '/' },
        auto_restore_last_session = false,
        session_lens = {
          path_display = { "shorten" },
          theme = "ivy", -- default is dropdown
          previewer = true,
        }
      })
    end
  },
  {
    "nicwest/vim-camelsnek",
    event = "CmdlineEnter",
  },
  {
    "rhysd/committia.vim",
    lazy = false,
    ft = "gitcommit",
    -- init = function()
    --   require("core.utils").lazy_load "committia.vim"
    -- end,
  },
  {
    "hotwatermorning/auto-git-diff",
    lazy = false,
    ft = "gitrebase",
    -- init = function()
    --   require("core.utils").lazy_load "auto-git-diff"
    -- end,
  },
  {
    "knsh14/vim-github-link",
    cmd = "GetCommitLink",
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "tomasky/bookmarks.nvim",
    event = "VimEnter",
    config = function()
      local current_dir = vim.fn.getcwd()
      local current_branch = vim.fn.system("git rev-parse --abbrev-ref HEAD"):match("^%s*(.-)%s*$")
      if current_branch == nil or current_branch == '' then
        current_branch = "bookmarks"
      end
      local bookmark_paths = { "$HOME", ".bookmarks", current_dir }
      local bookmark_dir = table.concat(bookmark_paths, "/")
      local command = "mkdir -p " .. bookmark_dir
      local result = os.execute(command)
      if result then
        vim.notify("Folder created successfully.", vim.log.levels.INFO)
      else
        vim.notify("Failed to create folder.", vim.log.levels.ERROR)
      end
      require('bookmarks').setup {
        save_file = vim.fn.expand(bookmark_dir .. "/" .. current_branch),
        keywords = {
          ["@t"] = "☑️ ", -- mark annotation startswith @t ,signs this icon as `Todo`
          ["@w"] = "⚠️ ", -- mark annotation startswith @w ,signs this icon as `Warn`
          ["@f"] = "⛏ ", -- mark annotation startswith @f ,signs this icon as `Fix`
          ["@n"] = " ", -- mark annotation startswith @n ,signs this icon as `Note`
        },
      }
    end
  },
  -- debugger
  {
    "mfussenegger/nvim-dap",
    keys = { "<leader>dbt" },
    config = function()
      local dap = require "dap"
      -- lua debugger
      dap.configurations.lua = {
        {
          type = "nlua",
          request = "attach",
          name = "Attach to running Neovim instance",
        },
      }
      dap.adapters.nlua = function(callback, config)
        callback { type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 }
      end
      -- ruby
      dap.adapters.ruby = function(callback, config)
        callback {
          type = "server",
          host = "127.0.0.1",
          port = "${port}",
          executable = {
            command = "bundle",
            args = {
              "exec",
              "rdbg",
              "--nonstop",
              "--open",
              -- "--port",
              -- "${port}",
              "--command",
              "--",
              config.command,
              config.script,
            },
          },
        }
      end

      dap.configurations.ruby = {
        {
          type = "ruby",
          name = "debug current file",
          request = "attach",
          localfs = true,
          command = "ruby",
          script = "${file}",
        },
        {
          type = "ruby",
          name = "run current spec file",
          request = "attach",
          localfs = true,
          command = "rspec",
          script = "${file}",
        },
        {
          -- domian socketだとconnectできないときがあるので、portにて対応
          -- bundle exec rdbg --open --port 12345 --nonstop --command -- bin/rails server
          type = "rdbg",
          name = "rails debugger by rdbg",
          request = "attach",
          localfs = true,
          debugPort = "127.0.0.1:12345",
          command = "bin/rails",
          script = "server -p 3000",
        },
      }
    end,
  },
  {
    "theHamsta/nvim-dap-virtual-text",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("nvim-dap-virtual-text").setup()
    end,
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      require("dapui").setup()
      local dap, dapui = require "dap", require "dapui"
      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end,
  },
  {
    "kchmck/vim-coffee-script",
    ft = { "coffee" },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async", "nvim-treesitter/nvim-treesitter" },
    config = function()
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local suffix = (' 󰁂 %d '):format(endLnum - lnum)
        local sufWidth = vim.fn.strdisplaywidth(suffix)
        local targetWidth = width - sufWidth
        local curWidth = 0
        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            local hlGroup = chunk[2]
            table.insert(newVirtText, { chunkText, hlGroup })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            -- str width returned from truncate() may less than 2nd argument, need padding
            if curWidth + chunkWidth < targetWidth then
              suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end
        table.insert(newVirtText, { suffix, 'MoreMsg' })
        return newVirtText
      end
      require("ufo").setup {
        open_fold_hl_timeout = 150,
        close_fold_kinds_for_ft = { default = { 'imports', 'comment' } },
        preview = {
          win_config = {
            border = { "", "─", "", "", "", "─", "", "" },
            winhighlight = "Normal:Folded",
            winblend = 0,
          },
          mappings = {
            scrollU = "<C-u>",
            scrollD = "<C-d>",
            jumpTop = "[",
            jumpBot = "]",
          },
        },
        provider_selector = function()
          return { "treesitter", "indent" }
        end,
        fold_virt_text_handler = handler,
      }
    end,
  },
  {
    "stevearc/aerial.nvim",
    cmd = { "AerialToggle", "AerialNavToggle" },
    config = function()
      require("aerial").setup {
        autojump = true,
        nav = {
          -- Jump to symbol in source window when the cursor moves
          -- autojump = true,
          -- Show a preview of the code in the right column, when there are no child symbols
          preview = true,
        },
      }
    end,
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
  },
  {
    "gennaro-tedesco/nvim-jqx",
    ft = { "json", "yaml" },
  },
  {
    "kazhala/close-buffers.nvim",
    event = "VeryLazy",
  },
  {
    "AckslD/messages.nvim",
    event = "VeryLazy",
    config = function()
      require("messages").setup()
      PrintDebug = function(val)
        require("messages.api").capture_thing(val)
      end
    end,
  },
  {
    "vidocqh/data-viewer.nvim",
    ft = { "csv", "tsv", "sqlite" },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "kkharji/sqlite.lua", -- Optional, sqlite support
    },
    config = function()
      require("data-viewer").setup {
        autoDisplayWhenOpenFile = false,
        maxLineEachTable = 100,
        columnColorEnable = true,
        columnColorRoulette = { -- Highlight groups
          "DataViewerColumn0",
          "DataViewerColumn1",
          "DataViewerColumn2",
        },
        view = {
          float = false, -- False will open in current window
          width = 0.8,   -- Less than 1 means ratio to screen width, valid when float = true
          height = 0.8,  -- Less than 1 means ratio to screen height, valid when float = true
          zindex = 50,   -- Valid when float = true
        },
        keymap = {
          quit = "q",
          next_table = "<C-l>",
          prev_table = "<C-h>",
        },
      }
      vim.cmd [[highlight DataViewerColumn0 guifg=#e6cc00]]
      vim.cmd [[highlight DataViewerColumn1 guifg=#cc3333]]
      vim.cmd [[highlight DataViewerColumn2 guifg=#00cc00]]
    end,
  },
  {
    "Wansmer/treesj",
    cmd = "TSJToggle",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("treesj").setup { --[[ your config ]]
      }
    end,
  },
  {
    "cshuaimin/ssr.nvim",
    event = "VeryLazy",
    config = function()
      require("ssr").setup {
        border = "rounded",
        min_width = 50,
        min_height = 5,
        max_width = 120,
        max_height = 25,
        adjust_window = true,
        keymaps = {
          close = "q",
          next_match = "n",
          prev_match = "N",
          replace_confirm = "<cr>",
          replace_all = "<leader><cr>",
        },
      }
      vim.keymap.set({ "n", "x" }, "<leader>sr", function()
        require("ssr").open()
      end)
    end,
  },
  {
    "nmac427/guess-indent.nvim",
    event = "VeryLazy",
    config = function()
      require("guess-indent").setup {}
    end,
  },
  {
    "okuuva/auto-save.nvim",
    cmd = "ASToggle",                         -- optional for lazy loading on command
    event = { "InsertLeave", "TextChanged" }, -- optional for lazy loading on trigger events
    opts = {
      condition = function(buf)
        local fn = vim.fn
        -- harpoon menuなど特殊なbufferは除外する
        if fn.getbufvar(buf, "&buftype") ~= '' then
          return false
        end
        return true
      end
    },
  },
  {
    "nvim-focus/focus.nvim",
    event = "VeryLazy",
    config = function()
      local ignore_filetypes = { "qf", "neo-tree", "neo-tree-popup", "notify", "help", "dashboard", "NvimTree",
        "nvim-docs-view" }
      local ignore_buftypes = { 'prompt', 'popup', 'terminal', 'quickfix', 'help', 'nofile' }

      local augroup =
          vim.api.nvim_create_augroup('FocusDisable', { clear = true })

      vim.api.nvim_create_autocmd('WinEnter', {
        group = augroup,
        callback = function(_)
          if vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
          then
            vim.w.focus_disable = true
          else
            vim.w.focus_disable = false
          end
        end,
        desc = 'Disable focus autoresize for BufType',
      })

      vim.api.nvim_create_autocmd('FileType', {
        group = augroup,
        callback = function(_)
          if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
            vim.b.focus_disable = true
          else
            vim.b.focus_disable = false
          end
        end,
        desc = 'Disable focus autoresize for FileType',
      })

      require("focus").setup({
        autoresize = {
          enable = true,
          minwidth = 10,  -- Force minimum width for the unfocused window
          minheight = 10, -- Force minimum height for the unfocused window
          height_quickfix = 5
        },
      })
    end,
  },
  {
    'lewis6991/whatthejump.nvim',
    event = "VeryLazy",
  },
  -- 便利だけどあまり使わない
  -- {
  --   "chrisgrieser/nvim-rip-substitute",
  --   cmd = "RipSubstitute",
  --   keys = {
  --     {
  --       "<leader>S",
  --       function() require("rip-substitute").sub() end,
  --       mode = { "n", "x" },
  --       desc = " rip substitute",
  --     },
  --   },
  -- },
  {
    "amrbashir/nvim-docs-view",
    lazy = true,
    cmd = "DocsViewToggle",
    opts = {
      position = "bottom",
      height = 5
    }
  },
  {
    "rcarriga/nvim-notify",
    config = function()
      vim.notify = require("notify")
      require("notify").setup {
        timeout = 2500,
        max_width = 80,
        stages = "static",
      }
    end
  },
  {
    'stevearc/quicker.nvim',
    event = "FileType qf",
    ---@module "quicker"
    ---@type quicker.SetupOptions
    opts = {},
  },
  -- partial jumpの関係で必要
  {
    "tpope/vim-rails",
    lazy = false,
  },
  {
    "monaqa/dial.nvim",
    event = "VeryLazy",
    config = function()
      vim.keymap.set("n", "<C-a>", function()
        require("dial.map").manipulate("increment", "normal")
      end)
      vim.keymap.set("n", "<C-x>", function()
        require("dial.map").manipulate("decrement", "normal")
      end)
      vim.keymap.set("n", "g<C-a>", function()
        require("dial.map").manipulate("increment", "gnormal")
      end)
      vim.keymap.set("n", "g<C-x>", function()
        require("dial.map").manipulate("decrement", "gnormal")
      end)
      vim.keymap.set("x", "<C-a>", function()
        require("dial.map").manipulate("increment", "visual")
      end)
      vim.keymap.set("x", "<C-x>", function()
        require("dial.map").manipulate("decrement", "visual")
      end)
      vim.keymap.set("x", "g<C-a>", function()
        require("dial.map").manipulate("increment", "gvisual")
      end)
      vim.keymap.set("x", "g<C-x>", function()
        require("dial.map").manipulate("decrement", "gvisual")
      end)
    end
  },
  {
    'f-person/git-blame.nvim',
    event = "VeryLazy",
    config = function()
      -- vim.g.gitblame_display_virtual_text = 0
      vim.g.gitblame_schedule_event = 'CursorHold'
      vim.g.gitblame_clear_event = 'CursorHoldI'
      require('gitblame').setup {
        enabled = true,
        message_template = " <date> | <summary> | <author>",
        date_format = "%Y/%m/%d(%r)",
      }
    end
  },
  {
    "j-hui/fidget.nvim",
    event = "VeryLazy",
    opts = {
      -- options
    },
  },
  {
    "olimorris/codecompanion.nvim",
    cmd = { 'CodeCompanion', 'CodeCompanionChat', 'CodeCompanionActions' },
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      -- {
      --   "ravitemer/mcphub.nvim",
      --   build = "npm install -g mcp-hub@latest",
      --   lazy = false,
      --   config = function()
      --     require("mcphub").setup({
      --       auto_approve = false,
      --       log_level = "info",
      --     })
      --   end
      -- },
      "j-hui/fidget.nvim",
      {
        "MeanderingProgrammer/render-markdown.nvim",
        ft = { "markdown", "codecompanion" }
      },
      {
        "HakonHarnes/img-clip.nvim",
        ft = { 'markdown', 'codecompanion' },
        opts = {
          filetypes = {
            codecompanion = {
              prompt_for_file_name = false,
              template = "[Image]($FILE_PATH)",
              use_absolute_path = true,
            },
          },
        },
      },
      {
        "Davidyz/VectorCode",
        version = "*", -- optional, depending on whether you're on nightly or release
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "VectorCode"
      },
      {
        "ravitemer/codecompanion-history.nvim"
      }
    },
    config = function()
      require("codecompanion.fidget-spinner"):init()
      require("codecompanion.fidget-progress-message"):init()
      local opts = require "custom.configs.codecompanion.config"
      require("codecompanion").setup(opts)
      vim.cmd([[cab cc CodeCompanion]])
    end
  },
  {
    "uga-rosa/translate.nvim",
    event = "VeryLazy",
    config = function()
      require("translate").setup({
        default = {
          command = "translate_shell",
        },
        preset = {
          output = {
            split = {
              append = true,
            },
          },
        },
      })
    end
  },
  ---@type LazySpec
  {
    "mikavilpas/yazi.nvim",
    event = "VeryLazy",
    dependencies = {
      "folke/snacks.nvim",
      "MagicDuck/grug-far.nvim"
    },
    ---@type YaziConfig | {}
    opts = {
      -- if you want to open yazi instead of netrw, see below for more info
      open_for_directories = true,
      keymaps = {
        show_help = "<f1>",
        send_to_quickfix_list = "<c-l>",
        grep_in_directory = "<c-g>",
        replace_in_directory = "<c-r>",
      },
      integrations = {
        resolve_relative_path_implementation = function(args, get_relative_path)
          -- By default, the path is resolved from the file/dir yazi was focused on
          -- when it was opened. Here, we change it to resolve the path from
          -- Neovim's current working directory (cwd) to the target_file.
          local cwd = vim.fn.getcwd()
          local path = get_relative_path({
            selected_file = args.selected_file,
            source_dir = cwd,
          })
          return path
        end,
      },
    },
    -- 👇 if you use `open_for_directories=true`, this is recommended
    init = function()
      -- More details: https://github.com/mikavilpas/yazi.nvim/issues/802
      -- vim.g.loaded_netrw = 1
      vim.g.loaded_netrwPlugin = 1
    end,
  },
  {
    "kiyoon/treesitter-indent-object.nvim",
    keys = {
      {
        "ai",
        function() require 'treesitter_indent_object.textobj'.select_indent_outer() end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (outer)",
      },
      {
        "aI",
        function() require 'treesitter_indent_object.textobj'.select_indent_outer(true) end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (outer, line-wise)",
      },
      {
        "ii",
        function() require 'treesitter_indent_object.textobj'.select_indent_inner() end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (inner, partial range)",
      },
      {
        "iI",
        function() require 'treesitter_indent_object.textobj'.select_indent_inner(true, 'V') end,
        mode = { "x", "o" },
        desc = "Select context-aware indent (inner, entire range) in line-wise visual mode",
      },
    },
  },
  {
    "wsdjeg/quickfix.nvim",
    ft = { "qf" },
  },
  {
    "LintaoAmons/scratch.nvim",
    event = "VeryLazy",
    dependencies = {
      { "ibhagwan/fzf-lua" },              --optional: if you want to use fzf-lua to pick scratch file. Recommanded, since it will order the files by modification datetime desc. (require rg)
      { "nvim-telescope/telescope.nvim" }, -- optional: if you want to pick scratch file by telescope
      { "stevearc/dressing.nvim" }         -- optional: to have the same UI shown in the GIF
    },
    config = function()
      require("scratch").setup({
        -- scratch_file_dir = vim.fn.stdpath("cache") .. "/scratch.nvim",
        scratch_file_dir = "~/Documents/andpad/50-Resource/Scratch",
      })
    end
  },
  {
    "folke/trouble.nvim",
    opts = {
      throttle = {
        refresh = 250,                           -- fetches new data when needed
        update = 100,                            -- updates the window
        render = 100,                            -- renders the window
        follow = 250,                            -- follows the current item
        preview = { ms = 100, debounce = true }, -- shows the preview for the current item
      }
    },
    cmd = "Trouble",
    keys = {
      {
        "<leader>xX",
        "<cmd>Trouble diagnostics toggle<cr>",
        desc = "Diagnostics (Trouble)",
      },
      {
        "<leader>xx",
        "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
        desc = "Buffer Diagnostics (Trouble)",
      },
      {
        "<leader>cs",
        "<cmd>Trouble symbols toggle focus=false<cr>",
        desc = "Symbols (Trouble)",
      },
      {
        "<leader>cl",
        "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
        desc = "LSP Definitions / references / ... (Trouble)",
      },
      {
        "<leader>xL",
        "<cmd>Trouble loclist toggle<cr>",
        desc = "Location List (Trouble)",
      },
      {
        "<leader>xQ",
        "<cmd>Trouble qflist toggle<cr>",
        desc = "Quickfix List (Trouble)",
      },
    },
  },
  {
    'windwp/nvim-ts-autotag',
    ft = { "vue", "html", "jsx" },
    config = function()
      require('nvim-ts-autotag').setup({
        opts = {
          enable_close = true,          -- Auto close tags
          enable_rename = true,         -- Auto rename pairs of tags
          enable_close_on_slash = false -- Auto close on trailing </
        },
      })
    end
  },
  {
    'WeiTing1991/diagnostic-hover.nvim',
    event = "VeryLazy",
    opts = {}
  },
  {
    'fei6409/log-highlight.nvim',
    ft = { "log" },
    opts = {},
  },
  {
    'lambdalisue/vim-gin',
    event = "VeryLazy",
    dependencies = {
      {
        'vim-denops/denops.vim',
        event = "VeryLazy",
      }
    }
  },
}

return plugins
