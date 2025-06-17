return {
  {
    'hrsh7th/nvim-cmp',
    dependencies = {
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-nvim-lua',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-vsnip',
      'hrsh7th/vim-vsnip',
      'onsails/lspkind.nvim',
      'neovim/nvim-lspconfig',
    },
    config = function()
      local cmp = require('cmp')

      cmp.setup({
        mapping = cmp.mapping.preset.insert({
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-u>"] = cmp.mapping.scroll_docs(4),
          ["<C-e>"] = cmp.mapping.close(),
          ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
          ["<Tab>"] = cmp.mapping.confirm({ select = true }),
        }),

        sources = {
          { name = "nvim_lsp" },
          { name = "path" },
          { name = "vim_vsnip" },
          { name = "buffer",   keyword_length = 5 },
        },

        sorting = {
          comparators = {}, -- We stop all sorting to let the lsp do the sorting
        },

        snippet = {
          expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
          end,
        },

        formatting = {
          format = require('lspkind').cmp_format({
            with_text = true,
            maxwidth = 40, -- half max width
            menu = {
              buffer = "[buffer]",
              nvim_lsp = "[LSP]",
              nvim_lua = "[API]",
              path = "[path]",
              vim_vsnip = "[snip]",
            },
          }),
        },

        experimental = {
          native_menu = false,
          ghost_text = true,
        },
      })

      vim.cmd([[
        augroup CmpZsh
          au!
          autocmd Filetype zsh lua require'cmp'.setup.buffer { sources = { { name = "zsh" }, } }
        augroup END
      ]])
    end,
    event = "VeryLazy"
  },
  {
    'neovim/nvim-lspconfig',
    config = function()
      local lspconfig = require'lspconfig'
      vim.lsp.config('gopls', require('helpers.lspconfig').config{
        single_file_support = false,
        root_dir = lspconfig.util.root_pattern('go.mod'),
      })
      vim.lsp.config('clangd', require('helpers.lspconfig').config{
        cmd = { 'clangd', '--query-driver=/usr/bin/gcc' },
        root_dir = lspconfig.util.root_pattern('compile_commands.json'),
      })

      vim.lsp.enable('gopls')
      vim.lsp.enable('clangd')

      vim.opt.completeopt = { "menu", "menuone", "noselect" }
      vim.opt.completeopt = { "menu", "menuone", "noselect" }
      vim.opt.shortmess:append("c")
    end,
    event = "VeryLazy"
  },
  {
    'onsails/lspkind.nvim',
    config = function()
      require('lspkind').init()
    end
  },
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      -- options
    },
  },
}

-- vim: set ts=2 sw=2 et:
