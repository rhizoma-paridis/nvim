local paridis_group = vim.api.nvim_create_augroup("Paridis", { clear = true })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  group = paridis_group,
  callback = function()
    (vim.hl or vim.highlight).on_yank()
  end,
})

-- close some filetypes with <q>
vim.api.nvim_create_autocmd("FileType", {
  group = paridis_group,
  pattern = {
    "PlenaryTestPopup",
    "checkhealth",
    "dbout",
    "gitsigns-blame",
    "grug-far",
    "help",
    "lspinfo",
    "neotest-output",
    "neotest-output-panel",
    "neotest-summary",
    "notify",
    "qf",
    "spectre_panel",
    "startuptime",
    "tsplayground",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.schedule(function()
      vim.keymap.set("n", "q", function()
        vim.cmd("close")
        pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
      end, {
        buffer = event.buf,
        silent = true,
        desc = "Quit buffer",
      })
    end)
  end,
})


-- 针对 Cargo.toml 文件设置按键映射
vim.api.nvim_create_autocmd("BufEnter", {
  pattern = "Cargo.toml", -- 仅匹配 Cargo.toml 文件
  callback = function()
    local crates = require("crates")

    vim.keymap.set("n", "<leader>ct", crates.toggle, { desc = "Toggle Crates", buffer = 0, silent = true })
    vim.keymap.set("n", "<leader>cr", crates.reload, { desc = "Reload Crates", buffer = 0, silent = true })

    vim.keymap.set("n", "<leader>cv", crates.show_versions_popup, { desc = "Show Versions", buffer = 0, silent = true })
    vim.keymap.set("n", "<leader>cf", crates.show_features_popup, { desc = "Show Features", buffer = 0, silent = true })
    vim.keymap.set("n", "<leader>cd", crates.show_dependencies_popup,
      { desc = "Show Dependencies", buffer = 0, silent = true })

    vim.keymap.set("n", "<leader>cu", crates.update_crate, { desc = "Update Crate", buffer = 0, silent = true })
    vim.keymap.set("v", "<leader>cu", crates.update_crates, { desc = "Update Crates", buffer = 0, silent = true })
    vim.keymap.set("n", "<leader>ca", crates.update_all_crates, { desc = "Update All Crates", buffer = 0, silent = true })
    vim.keymap.set("n", "<leader>cU", crates.upgrade_crate, { desc = "Upgrade Crate", buffer = 0, silent = true })
    vim.keymap.set("v", "<leader>cU", crates.upgrade_crates, { desc = "Upgrade Crates", buffer = 0, silent = true })
    vim.keymap.set("n", "<leader>cA", crates.upgrade_all_crates, { desc = "Upgrade All Crates", buffer = 0, silent = true })

    vim.keymap.set("n", "<leader>cx", crates.expand_plain_crate_to_inline_table,
      { desc = "Expand Crate", buffer = 0, silent = true })
    vim.keymap.set("n", "<leader>cX", crates.extract_crate_into_table,
      { desc = "Extract Crate", buffer = 0, silent = true })

    vim.keymap.set("n", "<leader>cH", crates.open_homepage, { desc = "Open Homepage", buffer = 0, silent = true })
    vim.keymap.set("n", "<leader>cR", crates.open_repository, { desc = "Open Repository", buffer = 0, silent = true })
    vim.keymap.set("n", "<leader>cD", crates.open_documentation, { desc = "Open Documentation", buffer = 0, silent = true })
    vim.keymap.set("n", "<leader>cC", crates.open_crates_io, { desc = "Open Crates.io", buffer = 0, silent = true })
    vim.keymap.set("n", "<leader>cL", crates.open_lib_rs, { desc = "Open Lib.rs", buffer = 0, silent = true })
  end
})
