return {
  "folke/todo-comments.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  event = "VeryLazy",
  opts = {},
  -- stylua: ignore
  keys = {
    { "]t",         function() require("todo-comments").jump_next() end,              desc = "Next Todo Comment" },
    { "[t",         function() require("todo-comments").jump_prev() end,              desc = "Previous Todo Comment" },
    { "<leader>st", function() Snacks.picker.todo_comments() end, desc = "Todo" },
    { "<leader>sT", function () Snacks.picker.todo_comments({ keywords = { "TODO", "FIX", "FIXME" } }) end, desc = "Todo/Fix/Fixme" },
  },
}


