
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
  nnoremap('<C-k>', vim.lsp.buf.signature_help, bufopts, "Show signature")
  nnoremap('<space>D', vim.lsp.buf.type_definition, bufopts, "Go to type definition")
  nnoremap('<space>rn', vim.lsp.buf.rename, bufopts, "Rename")
  nnoremap('<space>f', function() vim.lsp.buf.format { async = true } end, bufopts, "Format file")
end

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
                path = "/usr/lib/jvm/java-21-openjdk",
              }
            }
          }
        }
      },
      cmd = {
        "jdtls",
        "-data", workspace_folder,
      },
    }

    jdtls.start_or_attach(config)
  end,
})
