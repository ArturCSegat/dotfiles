local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr})
end)

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

-- Make sure you setup `cmp` after lsp-zero

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()

require'lspconfig'.pylsp.setup{
  settings = {
    pylsp = {
      plugins = {
        pycodestyle = {
          maxLineLength = 1000
        }
      }
    }
  }
}

cmp.setup({
  mapping = {
    -- `Enter` key to confirm completion
    ['<CR>'] = cmp.mapping.confirm({select =true}),

    -- Ctrl+Space to trigger completion menu
    ['<C-Space>'] = cmp.mapping.complete(),

    -- Navigate between snippet placeholder
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
  }
})

lsp.setup()

require("mason").setup()
require("mason-lspconfig").setup()

require("mason-lspconfig").setup {
    ensure_installed = { "lua_ls", "rust_analyzer", "eslint", "vtsls", "tsserver", "gopls", "golangci_lint_ls"},
}
