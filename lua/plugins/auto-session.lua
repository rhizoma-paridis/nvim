return {
    {
        "rmagatti/auto-session",
        lazy = false,
        keys = {
            -- Will use Telescope if installed or a vim.ui.select picker otherwise
            { "<leader>ql", "<cmd>AutoSession search<CR>", desc = "Session search" },
            { "<leader>qs", "<cmd>AutoSession save<CR>",   desc = "Save session" },
            { "<leader>qd", "<cmd>AutoSession delete<CR>", desc = "Delete session" },
        },

        ---enables autocomplete for opts
        ---@module "auto-session"
        ---@type AutoSession.Config
        opts = {
            suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
            -- log_level = 'debug',
            session_lens = {
                picker = "snacks",
                mappings = {
                    -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
                    delete_session = { "i", "<C-d>" },
                    alternate_session = { "i", "<C-s>" },
                    copy_session = { "i", "<C-y>" },
                },
            },
        },
    }
}
