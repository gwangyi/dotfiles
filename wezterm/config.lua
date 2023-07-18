function get_script_path()
  local status, err = pcall(function () error("") end)
  local index = string.find(err, ":")
  if index == nil then
    return err
  else
    return string.sub(err, 1, index - 1)
  end
end

package.path = string.gsub(get_script_path(), "(.*/)(.*)", "%1") .. "/../corp/wezterm/?.lua;" .. package.path

function apply (wezterm)
  local config = {}

  if wezterm.config_builder then
    config = wezterm.config_builder()
  end

  config.color_scheme = 'Solarized (dark) (terminal.sexy)'
  config.font = wezterm.font 'MesloLGS NF'
  config.font_size = 15

  config.hyperlink_rules = wezterm.default_hyperlink_rules()

  config.mouse_bindings = {
    {
      event = { Down = { streak = 3, button = 'Left' } },
      action = wezterm.action.SelectTextAtMouseCursor 'SemanticZone',
      mods = 'NONE',
    },
  }

  config.keys = {
    { key = 'UpArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ScrollToPrompt(-1) },
    { key = 'DownArrow', mods = 'CTRL|SHIFT', action = wezterm.action.ScrollToPrompt(1) },
    { key = 'UpArrow', mods = 'SHIFT', action = wezterm.action.ScrollByLine(-1) },
    { key = 'DownArrow', mods = 'SHIFT', action = wezterm.action.ScrollByLine(1) },
  }

  local status, err = pcall(function() require('corp')(config, wezterm) end)
  if err ~= nil then
    wezterm.log_warn(err)
  end

  return config
end

return apply
