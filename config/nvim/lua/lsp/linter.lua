local trouble = require('trouble')
local lualine = require('lualine')

local config  = require('fzf-lua.config')
local actions = require('trouble.sources.fzf').actions

local symbols = trouble.statusline({
  mode = 'lsp_document_symbols',
  title = false,
  groups = { },
  filter = { range = true },
  format = "{kind_icon}{symbol.name:Normal}",
  hl_group = "lualine_c_normal"
})

trouble.setup()
lualine.setup({
    options = {
        theme = 'gruvbox-material'
    },
    sections = {
      lualine_c = { { symbols.get, cond = symbols.has } }
    }
})

config.defaults.actions.files['ctrl-t'] = actions.open
