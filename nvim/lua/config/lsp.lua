local cmp = require("cmp")

cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip.loaders.from_vscode").lazy_load()
      require('luasnip').lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
  })
})

local capabilities = require('cmp_nvim_lsp').default_capabilities()

local servers = { 'clangd',
  'rust_analyzer',
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
  vim.lsp.config(lsp, {
    capabilities = vim.tbl_deep_extend(
      'keep',
      capabilities,
      vim.lsp.config[lsp] and vim.lsp.config[lsp].capabilities or {}
    )
  })
end

require("luasnip.loaders.from_vscode").lazy_load()
vim.lsp.inlay_hint.enable(true)
vim.diagnostic.config({
  virtual_text = { current_line = true }
})

vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Show hover documentation' })
vim.keymap.set('i', '<C-k>', vim.lsp.buf.signature_help, { desc = 'Show signature help' })

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('cmp_lsp_attach', { clear = true }),
  callback = function()
    require('cmp_nvim_lsp')._on_insert_enter()
  end,
})

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

local home = os.getenv('HOME')
local jdtls = require('jdtls')

function nnoremap(rhs, lhs, bufopts, desc)
  bufopts.desc = desc
  vim.keymap.set("n", rhs, lhs, bufopts)
end

local on_attach = function(client, bufnr)
  local bufopts = { noremap=true, silent=true, buffer=bufnr }
  nnoremap('gD', vim.lsp.buf.declaration, bufopts, "Go to declaration")
  nnoremap('gd', vim.lsp.buf.definition, bufopts, "Go to definition")
  nnoremap('gi', vim.lsp.buf.implementation, bufopts, "Go to implementation")
  nnoremap('K', vim.lsp.buf.hover, bufopts, "Hover text")
  nnoremap('<C-k>', vim.lsp.buf.signature_help, bufopts, "Show signature")
  nnoremap('<space>wa', vim.lsp.buf.add_workspace_folder, bufopts, "Add workspace folder")
  nnoremap('<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts, "Remove workspace folder")
  nnoremap('<space>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, bufopts, "List workspace folders")
  nnoremap('<space>D', vim.lsp.buf.type_definition, bufopts, "Go to type definition")
  nnoremap('<space>rn', vim.lsp.buf.rename, bufopts, "Rename")
  nnoremap('<space>ca', vim.lsp.buf.code_action, bufopts, "Code actions")
  vim.keymap.set('v', "<space>ca", "<ESC><CMD>lua vim.lsp.buf.range_code_action()<CR>",
    { noremap=true, silent=true, buffer=bufnr, desc = "Code actions" })
  nnoremap('<space>f', function() vim.lsp.buf.format { async = true } end, bufopts, "Format file")

  -- Java extensions provided by jdtls
  nnoremap("<C-o>", jdtls.organize_imports, bufopts, "Organize imports")
  nnoremap("<space>ev", jdtls.extract_variable, bufopts, "Extract variable")
  nnoremap("<space>ec", jdtls.extract_constant, bufopts, "Extract constant")
  vim.keymap.set('v', "<space>em", [[<ESC><CMD>lua require('jdtls').extract_method(true)<CR>]],
    { noremap=true, silent=true, buffer=bufnr, desc = "Extract method" })
end

-- Only start jdtls for Java files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "java",
  callback = function()
    local root_markers = {'gradlew', 'mvnw', '.git'}
    local root_dir = require('jdtls.setup').find_root(root_markers)
    local workspace_folder = home .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

    local config = {
      flags = {
        debounce_text_changes = 80,
      },
      on_attach = on_attach,
      root_dir = root_dir,
      settings = {
        java = {
          import = {
            gradle = {
              annotationProcessing = { enabled = false },
            },
          },
          format = {
            settings = {
              url = home .. "/.local/share/eclipse/eclipse-java-google-style.xml",
              profile = "GoogleStyle",
            },
          },
          signatureHelp = { enabled = true },
          contentProvider = { preferred = 'fernflower' },
          completion = {
            favoriteStaticMembers = {
              "org.hamcrest.MatcherAssert.assertThat",
              "org.hamcrest.Matchers.*",
              "org.hamcrest.CoreMatchers.*",
              "org.junit.jupiter.api.Assertions.*",
              "java.util.Objects.requireNonNull",
              "java.util.Objects.requireNonNullElse",
              "org.mockito.Mockito.*"
            },
            filteredTypes = {
              "com.sun.*",
              "io.micrometer.shaded.*",
              "java.awt.*",
              "jdk.*", "sun.*",
            },
          },
          sources = {
            organizeImports = {
              starThreshold = 9999;
              staticStarThreshold = 9999;
            },
          },
          codeGeneration = {
            toString = {
              template = "${object.className}{${member.name()}=${member.value}, ${otherMembers}}"
            },
            hashCodeEquals = {
              useJava7Objects = true,
            },
            useBlocks = true,
          },
          configuration = {
            runtimes = {
              {
                name = "JavaSE-21",
                path = "/usr/lib/jvm/default",
              },
            }
          }
        }
      },
      cmd = {
        "/usr/bin/java",
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx4g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-jar', vim.fn.glob('/usr/share/java/jdtls/plugins/org.eclipse.equinox.launcher_*.jar'),

        '-configuration', home .. '/.cache/jdtls/config_linux',

        '-data', workspace_folder,
      },
    }

    jdtls.start_or_attach(config)
  end,
})



require("conform").setup({
  formatters_by_ft = {
    lua = { "stylua" },
    python = { "isort", "black" },
    rust = { "rustfmt", lsp_format = "fallback" },
    javascript = { "prettierd", "prettier", stop_after_first = true },
  },
})
