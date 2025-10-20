return {
    {
        "nvim-treesitter/nvim-treesitter",
        event = { "BufReadPre", "BufNewFile" },
        build = ":TSUpdate",
        config = function()
            -- import nvim-treesitter plugin
            local treesitter = require("nvim-treesitter.configs")

            -- configure treesitter
            treesitter.setup({ -- enable syntax highlighting
                highlight = {
                    enable = true,
                },
                -- enable indentation
                indent = { enable = true },

                -- ensure these languages parsers are installed
                ensure_installed = {
                    "json",
                    "lua",
                    "java",
                    -- "javascript",
                    -- "css"
                    "rust",
                    "ron",
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<leader>w=",
                        node_incremental = "<leader>w-",
                        scope_incremental = false,
                    },
                },
                additional_vim_regex_highlighting = false,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        config = function(_, opts)
            require('nvim-treesitter.configs').setup({
                textobjects = {
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]f"] = "@function.outer",
                            ["]c"] = "@class.outer",
                            ["]p"] = "@parameter.inner",
                        },
                        goto_next_end = {
                            ["]F"] = "@function.outer",
                            ["]P"] = "@parameter.inner",
                        },
                        goto_previous_start = {
                            ["[f"] = "@function.outer",
                            ["[c"] = "@class.outer",
                            ["[p"] = "@parameter.inner",
                        },
                        goto_previous_end = {
                            ["[F"] = "@function.outer",
                            ["[P"] = "@parameter.inner",
                        },
                    },
                },
            })
        end
    },
}
