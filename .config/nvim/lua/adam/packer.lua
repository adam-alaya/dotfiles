-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.4',
        -- or                            , branch = '0.1.x',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use {
        'rose-pine/neovim',
        as = 'rose-pine',
        config = function()
            vim.cmd('colorscheme rose-pine')
        end
    }
    use { "EdenEast/nightfox.nvim", as = "nightfox" }
    use { 'folke/tokyonight.nvim', as = "tokyonight" }
    use('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
    use('nvim-lua/plenary.nvim')
    use('ThePrimeagen/harpoon')
    use('mbbill/undotree')
    -- use 'airblade/vim-gitgutter'
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end
    }
    use('tpope/vim-fugitive')
    use {
        "max397574/better-escape.nvim",
        config = function()
            require("better_escape").setup()
        end,
    }
    use 'voldikss/vim-floaterm'
    use {
        "windwp/nvim-autopairs",
        config = function() require("nvim-autopairs").setup {} end
    }

    use 'nvim-tree/nvim-web-devicons'
    use { 'romgrk/barbar.nvim', wants = 'nvim-web-devicons' }

    use {
        "folke/trouble.nvim",
        requires = "kyazdani42/nvim-web-devicons",
        config = function()
            require("trouble").setup {
                -- your configuration comes here
                -- or leave it empty to use the default settings
                -- refer to the configuration section below
            }
        end
    }
    use "terrortylor/nvim-comment"
    use 'chentoast/marks.nvim'
    -- Testing
    use 'vim-test/vim-test'
    use 'David-Kunz/Jester'

    -- LSP
    use { 'williamboman/mason.nvim' }
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP Support
            { 'neovim/nvim-lspconfig' },
            { 'williamboman/mason-lspconfig.nvim' },

            -- Autocompletion
            { 'hrsh7th/nvim-cmp' },
            { 'hrsh7th/cmp-buffer' },
            { 'hrsh7th/cmp-path' },
            { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' },
            { 'hrsh7th/cmp-nvim-lua' },

            -- Snippets
            { 'L3MON4D3/LuaSnip' },
            { 'rafamadriz/friendly-snippets' },
        }
    }
    use {
        'nvim-lualine/lualine.nvim',
        requires = { 'kyazdani42/nvim-web-devicons', opt = true }
    }
    -- CoC
    use { "neoclide/coc.nvim", branch = "release" }
    use { "yaegassy/coc-volar", run = "yarn install" }
    use { "yaegassy/coc-volar-tools", run = "yarn install" }

    -- Debugging
    use { "leoluz/nvim-dap-go" }
    use { "rcarriga/nvim-dap-ui", requires = { "mfussenegger/nvim-dap" } }
    use { 'theHamsta/nvim-dap-virtual-text' }

    -- Copilot
    use {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function() require("copilot").setup({
        suggestion = {
            enabled = true,
            auto_trigger =true,
            keymap = {
                accept = "<Tab>",
                next = "<C-n>",
                prev = "<C-p>",
            },
        }
        }) end,
    }
end)
