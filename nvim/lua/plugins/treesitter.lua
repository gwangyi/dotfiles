return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function ()
      require("nvim-treesitter").setup({
        -- auto_install is supported directly here
        auto_install = true,
      })
      vim.api.nvim_create_autocmd("FileType", {
        callback = function()
          pcall(vim.treesitter.start)
        end,
      })
      if vim.treesitter.highlighter.hl_map ~= nil then
        vim.treesitter.highlighter.hl_map.error = nil
      end
    end
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    config = function()
      require("nvim-treesitter-textobjects").setup({
        -- configure textobject keymaps here
      })
    end,
  }
}

-- vim: set sw=2 ts=2 et:
