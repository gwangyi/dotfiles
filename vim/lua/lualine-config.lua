local getScriptFunc = require('snrhelper').getScriptFunc

local config = {
  options = {
    theme = 'solarized_dark',
  },
  sections = {
    lualine_y = { getScriptFunc('hangeul.vim', 'ModeString'), 'progress' }
  }
}

return config
