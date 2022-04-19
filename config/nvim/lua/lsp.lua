local cmp = require('cmp')
local snp = require('luasnip')
local lsp = require('lspconfig')
local cfg = require('cmp_nvim_lsp')
local add = require('nvim-lsp-installer')


local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end


local capabilities = cfg.update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
)


cmp.setup({
    snippet = {
        expand = function(args)
            snp.lsp_expand(args.body)
        end,
    },
    sources = {
        { name = 'path' },
        { name = 'buffer' },
        { name = 'luasnip' },
        { name = 'nvim_lsp' },
        { name = 'nvim_lsp_signature_help' }
    },
    mapping = cmp.mapping.preset.insert({
        ["<Tab>"] = cmp.mapping(
            function(fallback)
              if cmp.visible() then
                cmp.select_next_item()
              elseif snp.expand_or_jumpable() then
                snp.expand_or_jump()
              elseif has_words_before() then
                cmp.complete()
              else
                fallback()
              end
            end,
            { "i", "s" }
        ),

        ["<S-Tab>"] = cmp.mapping(
            function(fallback)
              if cmp.visible() then
                cmp.select_prev_item()
              elseif snp.jumpable(-1) then
                snp.jump(-1)
              else
                fallback()
              end
            end,
            { "i", "s" }
        ),
      ['<C-e>'] = cmp.mapping.abort(),
      ['<C-f>'] = cmp.mapping.scroll_docs(4),
      ['<C-Space>'] = cmp.mapping.complete(),
      ['<C-b>'] = cmp.mapping.scroll_docs(-4),
      ['<CR>'] = cmp.mapping.confirm({ select = true }),
    }),
})


add.settings({
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
})


add.on_server_ready(
    function(server)
        local opts = { }
        opts.capabilities = capabilities
        server:setup(opts)
    end
)