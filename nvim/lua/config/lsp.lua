
local servers = { 'clangd', 'rust_analyzer',
  'pyright',
  'bashls',
  'lua_ls',
  'ts_ls',
  'tailwindcss',
  'gopls',
  'ols'
}

for _, lsp in ipairs(servers) do
  vim.lsp.enable(lsp)
  vim.lsp.config(lsp, {})
end

require("luasnip.loaders.from_vscode").lazy_load()
vim.lsp.inlay_hint.enable(true)
vim.diagnostic.config({
  virtual_text = { current_line = true }
})

vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show hover documentation' })
vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Show signature help' })
vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
  config = vim.tbl_deep_extend('keep', config or {}, { border = "rounded", max_width = 80 })
  vim.lsp.handlers.hover(err, result, ctx, config)
end
vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
  config = vim.tbl_deep_extend('keep', config or {}, { border = "rounded", max_width = 80 })
  vim.lsp.handlers.signature_help(err, result, ctx, config)
end

vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
    }
    vim.diagnostic.open_float(nil, opts)
  end
})

vim.opt.updatetime = 500


require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    rust = { "rustfmt", lsp_format = "fallback" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
  },
})


require("blink-cmp").setup({
      sources = {
        default = { "lazydev", "lsp", "path", "snippets", "buffer" },
        providers = {
          lazydev = {
            name = "LazyDev",
            module = "lazydev.integrations.blink",
            score_offset = 100,
          },
        },
      },
     keymap = {
	preset = "default",
	["<CR>"] = {"select_and_accept", "fallback"}
}})

require("markview").setup({})
