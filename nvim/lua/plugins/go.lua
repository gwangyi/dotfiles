return {
  {
    "ray-x/go.nvim",
    dependencies = {  -- optional packages
      "ray-x/guihua.lua",
      "neovim/nvim-lspconfig",
      "nvim-treesitter/nvim-treesitter",
      "theHamsta/nvim-dap-virtual-text",
      "rcarriga/nvim-dap-ui",
      "mfussenegger/nvim-dap",
    },
    opts = {
      -- lsp_keymaps = false,
      -- other options
    },
    config = function(lp, opts)
      require("go").setup(opts)
      local format_sync_grp = vim.api.nvim_create_augroup("GoFormat", {})
      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*.go",
        callback = function()
        require('go.format').goimports()
        end,
        group = format_sync_grp,
      })
    end,
    event = {"CmdlineEnter"},
    ft = {"go", 'gomod'},
    build = ':lua require("go.install").update_all_sync()' -- if you need to install/update all binaries
  },
  {
    "rafaelsq/nvim-goc.lua",
    opts = {},
    config = function(lp, opts)
      local goc = require('nvim-goc')
      goc.setup(opts)
      vim.keymap.set('n', '<Leader>gcf', goc.Coverage, {silent=true})       -- run for the whole File
      vim.keymap.set('n', '<Leader>gct', goc.CoverageFunc, {silent=true})   -- run only for a specific Test unit
      vim.keymap.set('n', '<Leader>gcc', goc.ClearCoverage, {silent=true})  -- clear coverage highlights
    end
  }
}
