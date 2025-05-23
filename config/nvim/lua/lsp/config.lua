require('mason').setup()
require('mason-nvim-dap').setup()
require('mason-lspconfig').setup()

require('blink.cmp').setup({
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
  signature = { enabled = true }
})


vim.lsp.enable('angularls')
vim.lsp.enable('awk')
vim.lsp.enable('azure_pipelines_ls')
vim.lsp.enable('ballerina')
vim.lsp.enable('bashls')
vim.lsp.enable('bicep')
vim.lsp.enable('buck2')
vim.lsp.enable('clangd')
vim.lsp.enable('docker')
vim.lsp.enable('elixirls')
vim.lsp.enable('erlangls')
vim.lsp.enable('eslint')
vim.lsp.enable('gleam')
vim.lsp.enable('gopls')
vim.lsp.enable('graphql')
vim.lsp.enable('helm_ls')
vim.lsp.enable('html')
vim.lsp.enable('jsonls')
vim.lsp.enable('lua_ls')
vim.lsp.enable('msbuild_project_tools_server')
vim.lsp.enable('pearlls')
vim.lsp.enable('powershell_es')
vim.lsp.enable('sourcekit')
vim.lsp.enable('v_analyzer')
