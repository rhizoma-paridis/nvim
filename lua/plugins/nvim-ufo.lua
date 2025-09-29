return {
    'kevinhwang91/nvim-ufo',
    dependencies = 'kevinhwang91/promise-async',
    enabled = true,
    config = function()
        local ufo = require('ufo')
        ufo.setup({
            -- 修复 default 拼写错误
            close_fold_kinds_for_ft = {
                default = {},       -- 默认不折叠任何类型（按需调整）
                java = { 'imports' }, -- Java 只折叠 imports
            },
        })
    end
}
