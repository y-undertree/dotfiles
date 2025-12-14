local M = {
  -- mcphub = {
  --   callback = "mcphub.extensions.codecompanion",
  --   opts = {
  --     make_tools = true,                -- @neovim__read_file のような個別ツールを有効化
  --     show_server_tools_in_chat = true, -- チャットUIのツール選択に出す
  --     show_result_in_chat = true,
  --     make_vars = true,                 -- MCPリソースを #変数 として使う
  --     make_slash_commands = true,       -- MCPの prompts を /mcp:xxx コマンド化
  --   }
  -- },
  history = {
    enabled = true,
    opts = {
      -- Keymap to open history from chat buffer (default: gh)
      keymap = "gh",
      -- Keymap to save the current chat manually (when auto_save is disabled)
      save_chat_keymap = "sc",
      -- Save all chats by default (disable to save only manually using 'sc')
      auto_save = true,
      -- Number of days after which chats are automatically deleted (0 to disable)
      expiration_days = 14,
      -- Customize picker keymaps (optional)
      picker_keymaps = {
        rename = { n = "r", i = "<M-r>" },
        delete = { n = "d", i = "<M-d>" },
        duplicate = { n = "<C-y>", i = "<C-y>" },
      },
      ---Automatically generate titles for new chats
      auto_generate_title = false,
      ---On exiting and entering neovim, loads the last chat on opening chat
      continue_last_chat = false,
      ---When chat is cleared with `gx` delete the chat from history
      delete_on_clearing_chat = false,
      ---Directory path to save the chats
      dir_to_save = vim.fn.stdpath("data") .. "/codecompanion-history",
      ---Enable detailed logging for history extension
      enable_logging = false,

      -- Summary system
      summary = {
        -- Keymap to generate summary for current chat (default: "gcs")
        create_summary_keymap = "gcs",
        -- Keymap to browse summaries (default: "gbs")
        browse_summaries_keymap = "gbs",
      },
    }
  },
  -- required vectorcode cli
  vectorcode = {
    ---@type VectorCode.CodeCompanion.ExtensionOpts
    opts = {
      tool_group = {
        -- this will register a tool group called `@vectorcode_toolbox` that contains all 3 tools
        enabled = true,
        -- a list of extra tools that you want to include in `@vectorcode_toolbox`.
        -- if you use @vectorcode_vectorise, it'll be very handy to include
        -- `file_search` here.
        extras = {},
        collapse = false,   -- whether the individual tools should be shown in the chat
      },
      tool_opts = {
        ---@type VectorCode.CodeCompanion.ToolOpts
        ["*"] = {},
        ---@type VectorCode.CodeCompanion.LsToolOpts
        ls = {},
        ---@type VectorCode.CodeCompanion.VectoriseToolOpts
        vectorise = {},
        ---@type VectorCode.CodeCompanion.QueryToolOpts
        query = {
          max_num = { chunk = -1, document = -1 },
          default_num = { chunk = 50, document = 10 },
          include_stderr = false,
          use_lsp = truj,
          no_duplicate = true,
          chunk_mode = false,
          ---@type VectorCode.CodeCompanion.SummariseOpts
          summarise = {
            ---@type boolean|(fun(chat: CodeCompanion.Chat, results: VectorCode.QueryResult[]):boolean)|nil
            enabled = false,
            adapter = nil,
            query_augmented = true,
          }
        },
        files_ls = {},
        files_rm = {}
      }
    },
  },
}

return M
