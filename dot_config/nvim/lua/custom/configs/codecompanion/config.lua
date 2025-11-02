local copilot_token_path = vim.fn.expand("~/.config/github-copilot/apps.json")
local copilot_available = vim.fn.filereadable(copilot_token_path) == 1
local adapter = {
  name = 'copilot',
  model = 'gpt-4.1'
}
local inline_adapter = {
  name = 'copilot',
  model = 'gpt-4.1'
}
if copilot_available == true then
elseif vim.fn.executable("op") == 1 then
  adapter = {
    name = 'openai',
    model = 'gpt-4.1-nano'
  }
  inline_adapter = adapter
  vim.notify("Use OpenAI adapter", vim.log.levels.WARN)
else
  vim.notify("No available CodeCompanion adapter (OpenAI or Copilot)", vim.log.levels.ERROR)
  return
end


local M = {
  language = "Japanese",
  adapters = {
    http = {
      copilot = function()
        return require("codecompanion.adapters").extend("copilot", {
          schema = {
            model = {
              default = adapter.model
            }
          }
        })
      end,
      openai = function()
        return require("codecompanion.adapters").extend("openai", {
          env = {
            -- eval $(op signin)
            api_key = "cmd:op read op://personal/OpenAI/apikey --no-newline",
          },
          schema = {
            model = {
              default = 'gpt-4.1-nano'
            }
          }
        })
      end,
    }
  },
  display = {
    diff = {
      enabled = true,
      -- close_chat_at = 240,  -- Close an open chat buffer if the total columns of your display are less than...
      -- layout = "vertical", -- vertical|horizontal split for default provider
      -- opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
      -- provider = "default", -- default|mini_diff
    },
    chat = {
      auto_scroll = true,
      show_header_separator = true,
      window = {
        layout = "float", -- float|vertical|horizontal|buffer
      },
    }
  },
  strategies = {
    chat = {
      adapter = adapter,
      opts = {
        ---Decorate the user message before it's sent to the LLM
        ---@param message string
        ---@param adapter CodeCompanion.Adapter
        ---@param context table
        ---@return string
        prompt_decorator = function(message, adapter, context)
          return string.format([[<prompt>%s</prompt>]], message)
        end,
        completion_provider = "cmp",
      },
    },
    inline = {
      adapter = inline_adapter,
    },
  },
  sources = {
    per_filetype = {
      codecompanion = { "codecompanion" },
    }
  },
}

M.extensions = require('custom.configs.codecompanion.extensions')
M.prompt_library = require('custom.configs.codecompanion.prompt_library')

return M
