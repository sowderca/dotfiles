vim.pack.add({

    -- Files
    { src = 'https://github.com/ptzz/lf.vim'           },
    { src = 'https://github.com/voldikss/vim-floaterm' },

    -- Fuzzy finder
    { src = 'https://github.com/junegunn/fzf'     },
    { src = 'https://github.com/junegunn/fzf.vim' },

    -- Unit testing
    { src = 'https://github.com/nvim-neotest/neotest'      },
    { src = 'https://github.com/nvim-neotest/nvim-nio'     },
    { src = 'https://github.com/nvim-lua/plenary.nvim'     },

    -- Test adapters
    { src = 'https://github.com/marilari88/neotest-vitest'     },
    { src = 'https://github.com/nsidorenco/neotest-vstest'     },
    { src = 'https://github.com/nvim-neotest/neotest-jest'     },
    { src = 'https://codeberg.org/mmllr/neotest-swift-testing' },
    { src = 'https://github.com/fredrikaverpil/neotest-golang' },

    -- LSP / DAP / Linter installation
    { src = 'https://github.com/mason-org/mason.nvim'                      },
    { src = 'https://github.com/mason-org/mason-lspconfig.nvim'            },
    { src = 'https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim' },

    -- Debugging
    { src = 'https://github.com/rcarriga/nvim-dap-ui'  },
    { src = 'https://github.com/mfussenegger/nvim-dap' },

    -- LSP configs
    { src = 'https://github.com/neovim/nvim-lspconfig' },

    -- Color theme
    { src = 'https://github.com/sainnhe/gruvbox-material' },

    -- Tree-Sitter
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter'         },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },

    -- Tmux navigation
    { src = 'https://github.com/christoomey/vim-tmux-navigator' },

    -- Autocomplete
    { src = 'https://github.com/Saghen/blink.cmp', version = 'v1' },

    -- Copilot
    { src = 'https://github.com/github/copilot.vim' }

})


require('nio')
require('dap')
require('dapui').setup({ })
require('neotest').setup({
    adapters = {
      require('neotest-jest'),
      require('neotest-vitest'),
      require('neotest-vstest'),
      require('neotest-golang'),
      require('neotest-swift-testing'),
    }
})

require('lsp.config')
require('pkg.config')

vim.opt.fillchars = {
  fold = " ",
  foldsep = " ",
  foldopen = "▾",
  foldclose = "▸",
  foldinner = " ",
}

vim.opt.foldenable = true
vim.opt.foldlevel = 99
vim.opt.foldmethod = 'expr'
vim.opt.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.opt.foldcolumn = "1"

vim.cmd 'source ~/.vimrc'
