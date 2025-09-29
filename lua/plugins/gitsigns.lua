return {
    "lewis6991/gitsigns.nvim",
    event = "VeryLazy",
    opts = {
        on_attach = function(buffer)
            local wk = require("which-key")
            local gs = require("gitsigns")
            wk.add({
                {
                    mode = "n",
                    buffer = buffer,
                    { "<leader>gh",  group = "Git Blame" },
                    { "<leader>ghb", function() gs.blame_line({ full = true }) end, desc = "Blame Line" },
                    { "<leader>ghB", function() gs.blame() end,                     desc = "Blame Buffer" },
                }
            })
        end
    },

}
