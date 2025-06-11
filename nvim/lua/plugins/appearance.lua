return {
  {
    'svrana/neosolarized.nvim',
    lazy = false,
    priority = 1000,
    dependencies = {
      {
        'tjdevries/colorbuddy.nvim',
        config = function()
          require('colorbuddy').setup()
        end,
      },
    },
    config = function()
      require('neosolarized').setup({})
      vim.opt.termguicolors = true
      vim.cmd([[colorscheme neosolarized]])
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = {
      options = {
        theme = 'neosolarized',
      },
    },
  },
  {
    'willothy/nvim-cokeline',
    dependencies = {
      'nvim-lua/plenary.nvim',        -- Required for v0.4.0+
      'nvim-tree/nvim-web-devicons',  -- If you want devicons
      'stevearc/resession.nvim'       -- Optional, for persistent history
    },
    config = function()
      require('cokeline').setup()

      vim.keymap.set('n', '<leader>bp', function()
        require('cokeline.mappings').pick('focus')
      end, { desc = 'Pick a buffer to focus' })

      local map = vim.api.nvim_set_keymap

      map('n', '<S-Tab>', '<Plug>(cokeline-focus-prev)', { silent = true })
      map('n', '<Tab>', '<Plug>(cokeline-focus-next)', { silent = true })
      map('n', '<Leader>p', '<Plug>(cokeline-switch-prev)', { silent = true })
      map('n', '<Leader>n', '<Plug>(cokeline-switch-next)', { silent = true })
    end,
  },
}

-- vim: set sw=2 ts=2 et:
