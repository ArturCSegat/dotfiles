require'nvim-treesitter.configs'.setup {
    -- A list of parser names, or "all" (the five listed parsers should always be installed)
    ensure_installed = {"cpp", "go", "javascript", "python", "php", "c", "lua", "rust"},
    --
    -- Install parsers synchronously (only applied to `ensure_installed`)
    sync_install = false,

    -- Automatically install missing parsers when entering buffer
    -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
    auto_install = true,

    highlight = {
        enable = true,
    },

    -- for some reason highlight enable turns of identing for php files, this fixes it
    indent = {
        enable = false,
    },

    textobjects = {
        move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
                ["]m"] = "@function.outer",
                ["]]"] = { query = "@class.outer", desc = "Next class start" },
                --
                -- You can use regex matching (i.e. lua pattern) and/or pass a list in a "query" key to group multiple queires.
                ["]o"] = "@loop.*",
                -- ["]o"] = { query = { "@loop.inner", "@loop.outer" } }
                --
                -- You can pass a query group to use query from `queries/<lang>/<query_group>.scm file in your runtime path.
                -- Below example nvim-treesitter's `locals.scm` and `folds.scm`. They also provide highlights.scm and indent.scm.
                ["]s"] = { query = "@scope", query_group = "locals", desc = "Next scope" },
                ["]z"] = { query = "@fold", query_group = "folds", desc = "Next fold" },
            },
            goto_next_end = {
                ["]M"] = "@function.outer",
                ["]["] = "@class.outer",
            },
            goto_previous_start = {
                ["[m"] = "@function.outer",
                ["[["] = "@class.outer",
            },
            goto_previous_end = {
                ["[M"] = "@function.outer",
                ["[]"] = "@class.outer",
            },
            -- Below will go to either the start or the end, whichever is closer.
            -- Use if you want more granular movements
            -- Make it even more gradual by adding multiple queries and regex.
            goto_next = {
                ["]d"] = "@conditional.outer",
            },
            goto_previous = {
                ["[d"] = "@conditional.outer",
            }
        },
    },
}

