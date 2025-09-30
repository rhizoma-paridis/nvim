-- 左侧行号及相关设置
vim.opt.number = true -- 显示行号
vim.opt.relativenumber = true -- 显示相对行号
vim.opt.numberwidth = 2 -- 设置行号栏宽度为2
vim.opt.signcolumn = "yes" -- 始终显示标记列
vim.opt.wrap = false -- 不自动换行，长行显示为一行
vim.opt.scrolloff = 1 -- 光标上下保留10行
vim.opt.sidescrolloff = 3 -- 光标左右保留8列

-- Tab缩进及行为
vim.opt.expandtab = true -- 将Tab键转换为空格
vim.opt.shiftwidth = 4 -- 每次缩进使用4个空格
vim.opt.tabstop = 4 -- Tab字符宽度为4个空格
vim.opt.softtabstop = 4 -- <Tab>键插入4个空格
vim.opt.smartindent = true -- 启用智能缩进
vim.opt.breakindent = true -- 换行时保持缩进

-- 通用行为
vim.g.loaded_netrw = 1 -- 禁用netrw插件
vim.g.loaded_netrwPlugin = 1 -- 禁用netrw插件
vim.opt.backup = false -- 不生成备份文件
vim.opt.clipboard = "unnamedplus" -- 启用系统剪贴板
vim.opt.conceallevel = 0 -- markdown中显示反引号
vim.opt.fileencodings = "utf-8,gbk,gb2312,cp936,latin1"  -- 优先尝试 UTF-8
vim.opt.mouse = "a" -- 启用鼠标支持
vim.opt.showmode = false -- 隐藏模式显示
vim.opt.splitbelow = true -- 新建水平分割窗口在下方
vim.opt.splitright = true -- 新建垂直分割窗口在右侧
vim.opt.termguicolors = true -- 启用终端真彩色
vim.opt.timeoutlen = 1000 -- 映射序列超时时间为1000ms
vim.opt.undofile = true -- 启用持久化撤销
vim.opt.updatetime = 100 -- 更快的补全响应
vim.opt.writebackup = false -- 不允许同时编辑同一文件
vim.opt.cursorline = true -- 高亮当前行
vim.opt.clipboard = "unnamedplus" -- 使用系统剪贴板

-- 搜索行为
vim.opt.hlsearch = true -- 搜索时高亮所有匹配项
vim.opt.ignorecase = true -- 搜索时忽略大小写
vim.opt.smartcase = true -- 搜索时包含大写字母则区分大小写

vim.o.foldcolumn = '1'      -- 显示折叠列（可选）
vim.o.foldlevel = 99        -- ufo 需要较大的 foldlevel 值
vim.o.foldlevelstart = 99   -- 打开文件时不自动折叠（由 ufo 控制）
vim.o.foldenable = true     -- 启用折叠