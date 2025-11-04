local M = {}

local function systemlist(cmd)
  return vim.fn.systemlist(cmd)
end

local function uniq_existing(paths)
  local set, out = {}, {}
  for _, p in ipairs(paths) do
    if p ~= '' and not set[p] and vim.loop.fs_stat(p) then
      set[p] = true
      table.insert(out, p)
    end
  end
  return out
end

local function pr_files()
  local out = systemlist('gh pr diff --name-only')
  if #out == 0 or (out[1] or ''):match('no pull requests found') then
    return {}
  end
  return uniq_existing(out)
end

local function index_files()
  local modified = systemlist('git diff --name-only')
  local staged   = systemlist('git diff --cached --name-only')
  local all = {}
  vim.list_extend(all, modified)
  vim.list_extend(all, staged)
  return uniq_existing(all)
end

function M.pick_changed_files(opts)
  opts = opts or {}
  local files = pr_files()
  local title = 'PR Changed Files'
  if #files == 0 then
    files = index_files()
    title = 'Index/Working-Tree Changed Files'
  end
  if #files == 0 then
    vim.notify('表示できる変更ファイルがありません', vim.log.levels.INFO)
    return
  end

  local pickers   = require('telescope.pickers')
  local finders   = require('telescope.finders')
  local conf      = require('telescope.config').values
  local actions   = require('telescope.actions')
  local action_st = require('telescope.actions.state')
  local builtin   = require('telescope.builtin')

  -- devicons（無ければフォールバック）
  local ok_devicons, devicons = pcall(require, 'nvim-web-devicons')

  -- entry_maker でアイコン付き表示
  local function entry_maker(path)
    local icon, icon_hl = '', nil -- デフォルトのドキュメントアイコン
    if ok_devicons then
      local _icon, _hl = devicons.get_icon(path, nil, { default = true })
      if _icon then icon = _icon end
      if _hl then icon_hl = _hl end
    end

    local rel = vim.fn.fnamemodify(path, ':.') -- 相対表示（好みで ':t' にするとファイル名のみ）
    local display = function(entry)
      return icon .. ' ' .. rel
    end

    -- アイコン部分にハイライトを当てたいときは display_highlights を返す
    local display_highlights = nil
    if icon_hl then
      display_highlights = function(_)
        -- アイコンの幅（UTF-8幅をざっくり1文字扱い）: 0..len(icon)
        return { { { 0, vim.fn.strdisplaywidth(icon) }, icon_hl } }
      end
    end

    return {
      value = path,          -- 実ファイルパス
      ordinal = path,        -- ソート/フィルタ用キー
      display = display,     -- 表示テキスト（アイコン + 相対パス）
      display_highlights = display_highlights,
      path = path,           -- 明示的に持たせておくと便利
      icon = icon,
      icon_hl = icon_hl,
    }
  end

  local entries = {}
  for _, f in ipairs(files) do
    table.insert(entries, entry_maker(f))
  end

  pickers.new(opts, {
    prompt_title = title,
    finder = finders.new_table({
      results = entries,
      entry_maker = function(e) return e end, -- そのまま使う
    }),
    sorter = conf.generic_sorter(opts),
    previewer = conf.file_previewer(opts),
    attach_mappings = function(prompt_bufnr, map)
      -- 単一選択で開く
      actions.select_default:replace(function()
        local entry = action_st.get_selected_entry()
        actions.close(prompt_bufnr)
        vim.cmd('edit ' .. vim.fn.fnameescape(entry.value))
      end)

      -- <C-g> で複数選択ファイルを対象に live_grep
      map('n', '<C-g>', function()
        local picker = action_st.get_current_picker(prompt_bufnr)
        local multi = picker:get_multi_selection()
        local targets = {}
        for _, e in ipairs(multi) do
          table.insert(targets, e.value)
        end
        if #targets == 0 then
          local single = action_st.get_selected_entry()
          if single then table.insert(targets, single.value) end
        end
        actions.close(prompt_bufnr)
        builtin.live_grep({
          search_dirs = targets,
          prompt_title = 'Live Grep in Selected Files',
        })
      end)

      return true
    end,
  }):find()
end

return M
