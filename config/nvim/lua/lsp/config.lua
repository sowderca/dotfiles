require('mason').setup()
require('treesitter-context').setup()


local auto_complete = require('blink.cmp')

local tool_config       = require('mason-lspconfig')
local tool_installation = require('mason-tool-installer')

auto_complete.setup({
  keymap = {
    preset = "default",
      ["<CR>"] = { "accept", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
  },
  cmdline = {
    keymap = {
      ["<ESC>"] = {
        function(cmp)
          if cmp.is_visible() then
            cmp.cancel()
          else
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-c>", true, true, true), 'n', true)
          end
        end
      }
    }
  },
  sources = {
    default = { "lsp", "path", "buffer" },
  },
  signature = { enabled = true },
})


tool_config.setup({
  automatic_enable = {
    exclude = {
      'cspell_ls'
    }
  }
})

tool_installation.setup({
  ensure_installed = {
    -- JSON
    'json-lsp',

    -- Web
    'css-lsp',
    'html-lsp',
    'htmlhint',
    'stylelint',

    -- Angular
    'angular-language-server',

    -- Ansible
    'ansible-lint',
    'ansible-language-server',

    -- C/C++
    'clangd',
    'clang-format',

    -- Shell
    'shellcheck',
    'bash-debug-adapter',
    'bash-language-server',

    -- Go
    'gopls',

    -- .NET
    'netcoredbg', -- This is not quite as good as the proper MS vscode one.
    'csharp-language-server',
    'powershell-editor-services',

    -- JS/TS
    'eslint-lsp',
    'js-debug-adapter',
    'typescript-language-server',

    -- Markdown
    'markdownlint',

    -- DevOps
    'opa',
    'nomad',
    'bicep-lsp',
    'terraform-ls',
    'azure-pipelines-language-server',

    -- YAML
    'yamllint',
    'yaml-language-server',

    -- Rust
    'rust-analyzer',

    -- SQL
    'sqls',

    -- Misc
    'awk-language-server',
    'lua-language-server',
    'vim-language-server',

    -- Spelling
    'cspell',
    'cspell-lsp',

  }
})

vim.diagnostic.config({ virtual_text = false, virtual_lines = { current_line = true }, })

-- TODO get this working on linux.
vim.lsp.enable("sourcekit")

