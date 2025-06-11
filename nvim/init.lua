local path = vim.fn.fnamemodify(vim.fn.resolve(vim.fn.expand('<sfile>:p')), ':h')

-- {{{ Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = 'https://github.com/folke/lazy.nvim.git'
  local out = vim.fn.system({ 'git', 'clone', '--filter=blob:none', '--branch=stable', lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to clone lazy.nvim:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)
-- }}}

-- {{{ Setup global configs
-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
vim.g.mapleader = ' '
vim.g.maplocalleader = '\\'

vim.g.python3_host_prog = path .. '/py/.venv/bin/python'
vim.g.clipboard = 'osc52'
-- }}}

-- {{{ luarocks
local hererocks = vim.fn.stdpath('data') .. '/lazy-rocks/hererocks'
if not (vim.uv or vim.loop).fs_stat(hererocks .. '/bin/lua') then
  local out = vim.fn.system({ vim.fs.dirname(vim.g.python3_host_prog) .. '/hererocks', hererocks, '-l5.1', '-rlatest', '--no-readline' })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { 'Failed to install luarocks:\n', 'ErrorMsg' },
      { out, 'WarningMsg' },
      { '\nPress any key to exit...' },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
-- }}}

-- {{{ Setup lazy.nvim
require('lazy').setup({
  spec = {
    -- import your plugins
    { import = 'plugins' },
  },
  -- Configure any other settings here. See the documentation for more details.
  -- colorscheme that will be used when installing plugins.
  install = { colorscheme = { 'neosolarized' } },
  -- automatically check for plugin updates
  checker = { enabled = true },
})
-- }}}

-- vim: set fdm=marker fmr={{{,}}} sw=2 ts=2 et:
