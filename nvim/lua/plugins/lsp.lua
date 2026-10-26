return {

  'L3MON4D3/LuaSnip',
  'neovim/nvim-lspconfig',
  'rafamadriz/friendly-snippets',
  'mfussenegger/nvim-dap',
  'mfussenegger/nvim-jdtls', {
  'stevearc/conform.nvim',
  opts = {}
  },
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "saghen/blink.cmp",
    dependencies = {
	    'saghen/blink.lib', -- Add this exact line
    },
	build = function()require('blink.cmp').build():pwait() end
  },
{
    "OXY2DEV/markview.nvim",
    lazy = false,

    dependencies = { "saghen/blink.cmp" },
},
  }
