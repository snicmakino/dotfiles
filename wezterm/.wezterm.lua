local wezterm = require 'wezterm'
local config = {}

if wezterm.config_builder then
  config = wezterm.config_builder()
end

-- ===== 基本 =====
config.default_domain = 'WSL:Ubuntu'
config.color_scheme = 'Tokyo Night Storm'

-- ===== フォント =====
config.font = wezterm.font('HackGen Console NF', { weight = 'Regular' })
config.font_size = 12.0
config.line_height = 1.2

-- ===== 見た目 =====
-- ウィンドウ
config.window_background_opacity = 0.75
config.win32_system_backdrop = 'Acrylic'
config.window_decorations = 'RESIZE'
config.window_padding = { left = 12, right = 12, top = 12, bottom = 8 }

-- タブバー
config.use_fancy_tab_bar = false
config.hide_tab_bar_if_only_one_tab = false -- 常に表示してステータスバーを見えるように
config.tab_bar_at_bottom = false
config.tab_max_width = 32
config.show_tab_index_in_tab_bar = false

-- カーソルとペイン
config.default_cursor_style = 'BlinkingBar'
config.cursor_blink_rate = 500
config.inactive_pane_hsb = {
  saturation = 0.7,
  brightness = 0.6,
}

-- アクティブペインの境界線を目立たせる
config.window_frame = {
  font = wezterm.font({ family = 'HackGen Console NF', weight = 'Bold' }),
  font_size = 11.0,
}

-- タブバーの色設定（透過対応）
config.colors = {
  -- 背景色を透過対応に明示的に設定
  background = '#1f2335',

  tab_bar = {
    -- 背景は透過させるためコメントアウト
    -- background = '#1f2335',
    active_tab = {
      bg_color = '#7aa2f7',
      fg_color = '#1f2335',
      intensity = 'Bold',
    },
    inactive_tab = {
      bg_color = 'rgba(41, 46, 66, 0.8)',
      fg_color = '#565f89',
    },
    inactive_tab_hover = {
      bg_color = 'rgba(59, 66, 97, 0.9)',
      fg_color = '#7aa2f7',
    },
    new_tab = {
      bg_color = 'rgba(31, 35, 53, 0.8)',
      fg_color = '#7aa2f7',
    },
    new_tab_hover = {
      bg_color = 'rgba(59, 66, 97, 0.9)',
      fg_color = '#7aa2f7',
    },
  },
}

-- ===== パフォーマンス =====
config.scrollback_lines = 10000
config.front_end = 'WebGpu'
config.audible_bell = 'Disabled'
config.animation_fps = 60
config.max_fps = 60

-- ===== その他の視覚効果 =====
-- スクロール時のスムースさ
config.enable_scroll_bar = false

-- 起動時のウィンドウサイズとポジション
config.initial_cols = 120
config.initial_rows = 30

-- ベルの視覚的フィードバック
config.visual_bell = {
  fade_in_function = 'EaseIn',
  fade_in_duration_ms = 150,
  fade_out_function = 'EaseOut',
  fade_out_duration_ms = 150,
}
config.colors.visual_bell = '#3b4261'

-- ===== リーダーキー =====
config.leader = { key = 'a', mods = 'CTRL', timeout_milliseconds = 1000 }

-- ===== キーバインド =====
config.keys = {
  -- ペイン分割
  { key = '[', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
  { key = ']', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },

  -- ペイン移動 (hjkl)
  { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
  { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
  { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
  { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },

  -- ペインリサイズ (HJKL)
  { key = 'H', mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Left', 5 } },
  { key = 'L', mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Right', 5 } },
  { key = 'K', mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Up', 5 } },
  { key = 'J', mods = 'LEADER', action = wezterm.action.AdjustPaneSize { 'Down', 5 } },

  -- ペインを閉じる
  { key = 'x', mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = true } },

  -- タブ操作
  { key = 'c', mods = 'LEADER', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
  { key = 'n', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(1) },
  { key = 'p', mods = 'LEADER', action = wezterm.action.ActivateTabRelative(-1) },

  -- タブ番号ジャンプ
  { key = '1', mods = 'LEADER', action = wezterm.action.ActivateTab(0) },
  { key = '2', mods = 'LEADER', action = wezterm.action.ActivateTab(1) },
  { key = '3', mods = 'LEADER', action = wezterm.action.ActivateTab(2) },
  { key = '4', mods = 'LEADER', action = wezterm.action.ActivateTab(3) },
  { key = '5', mods = 'LEADER', action = wezterm.action.ActivateTab(4) },

  -- コピーモード & 検索
  { key = 'v', mods = 'LEADER', action = wezterm.action.ActivateCopyMode },
  { key = '/', mods = 'LEADER', action = wezterm.action.Search 'CurrentSelectionOrEmptyString' },

  -- Quick Select（URL・パスの即コピー）
  { key = 'f', mods = 'LEADER', action = wezterm.action.QuickSelect },
}

-- ===== タブのフォーマット =====
wezterm.on('format-tab-title', function(tab, tabs, panes, config, hover, max_width)
  local title = tab.active_pane.title
  local index = tab.tab_index + 1

  -- アクティブペインのプロセス名を取得
  local process_name = string.gsub(tab.active_pane.foreground_process_name, '(.*[/\\])(.*)', '%2')

  -- アイコンマッピング
  local icons = {
    ['nvim'] = '',
    ['vim'] = '',
    ['bash'] = '',
    ['zsh'] = '',
    ['fish'] = '',
    ['node'] = '',
    ['python'] = '',
    ['lua'] = '',
    ['git'] = '',
  }

  local icon = icons[process_name] or ''

  -- タブタイトルの構築
  local formatted_title = string.format(' %d: %s %s ', index, icon, process_name)

  if tab.is_active then
    return {
      { Background = { Color = '#7aa2f7' } },
      { Foreground = { Color = '#1f2335' } },
      { Text = formatted_title },
    }
  else
    return {
      { Background = { Color = '#292e42' } },
      { Foreground = { Color = '#565f89' } },
      { Text = formatted_title },
    }
  end
end)

-- ===== ステータスバー =====
wezterm.on('update-right-status', function(window, pane)
  local date = wezterm.strftime('%Y-%m-%d %H:%M:%S')
  local leader_status = ''

  if window:leader_is_active() then
    leader_status = wezterm.format {
      { Attribute = { Intensity = 'Bold' } },
      { Background = { Color = '#f7768e' } },
      { Foreground = { Color = '#1f2335' } },
      { Text = ' LEADER ' },
    }
  end

  local battery_info = ''
  for _, b in ipairs(wezterm.battery_info()) do
    local battery_icon = '󰁹'
    if b.state == 'Charging' then
      battery_icon = '󰂄'
    elseif b.state_of_charge > 0.8 then
      battery_icon = '󰁹'
    elseif b.state_of_charge > 0.5 then
      battery_icon = '󰁾'
    elseif b.state_of_charge > 0.2 then
      battery_icon = '󰁼'
    else
      battery_icon = '󰁺'
    end
    battery_info = wezterm.format {
      { Background = { Color = '#3b4261' } },
      { Foreground = { Color = '#9ece6a' } },
      { Text = string.format(' %s %.0f%% ', battery_icon, b.state_of_charge * 100) },
    }
  end

  local time_info = wezterm.format {
    { Background = { Color = '#7aa2f7' } },
    { Foreground = { Color = '#1f2335' } },
    { Text = ' ' .. date .. ' ' },
  }

  window:set_right_status(leader_status .. battery_info .. time_info)
end)

return config
