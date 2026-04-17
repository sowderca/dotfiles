vim.pack.add({
    { src = 'https://github.com/rcarriga/nvim-dap-ui'                    },
    { src = 'https://github.com/nvim-neotest/neotest'                    },
    { src = 'https://github.com/nvim-neotest/nvim-nio'                   },
    { src = 'https://github.com/mason-org/mason.nvim'                    },
    { src = 'https://github.com/mfussenegger/nvim-dap'                   },
    { src = 'https://github.com/neovim/nvim-lspconfig'                   },
    { src = 'https://github.com/sainnhe/gruvbox-material'                },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter'         },
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter-context' },
    { src = 'https://github.com/christoomey/vim-tmux-navigator'          },
    { src = 'https://github.com/Saghen/blink.cmp', version = 'v1'        }
})

require('nio')
require('dap')
require('dapui').setup({ })
require('mason').setup({ })
require('neotest').setup({ })

require('lsp.config')

vim.cmd 'source ~/.vimrc'
