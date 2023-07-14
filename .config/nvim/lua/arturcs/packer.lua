-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use {
        'nvim-telescope/telescope.nvim', tag = '0.1.1',
        -- or                            , branch = '0.1.x',
        requires = { {'nvim-lua/plenary.nvim'} }
    }
    use { "ellisonleao/gruvbox.nvim" }


    use('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
    use { "mbbill/undotree" }
    use {
        'VonHeikemen/lsp-zero.nvim',
        branch = 'v2.x',
        requires = {
            -- LSP Support
            {'neovim/nvim-lspconfig'},             -- Required
            {                                      -- Optional
            'williamboman/mason.nvim',
            run = function()
                pcall(vim.cmd, 'MasonUpdate')
            end,
        },
        {'williamboman/mason.nvim'},
        {'williamboman/mason-lspconfig.nvim'},
        {'neovim/nvim-lspconfig'},

        -- Autocompletion
        {'hrsh7th/nvim-cmp'},     -- Required
        {'hrsh7th/cmp-nvim-lsp'}, -- Required
        {'L3MON4D3/LuaSnip'},     -- Required
    }
}

use {
    'nvim-lualine/lualine.nvim',
    requires = { 'nvim-tree/nvim-web-devicons', opt = true }
}

use({
    "nvim-treesitter/nvim-treesitter-textobjects",
    after = "nvim-treesitter",
    requires = "nvim-treesitter/nvim-treesitter",
})

use "terrortylor/nvim-comment"

use 'alvan/vim-closetag'
use "Alexis12119/nightly.nvim"
use ({"ziontee113/color-picker.nvim",
config = function()
    require("color-picker")
end,
})
    use { "bluz71/vim-moonfly-colors", as = "moonfly" }

    use({ 'rose-pine/neovim', as = 'rose-pine' })
end)

