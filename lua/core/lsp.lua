local handlers = require 'vim.lsp.handlers'

local env = {
    HOME = vim.uv.os_homedir(),
    XDG_CACHE_HOME = os.getenv 'XDG_CACHE_HOME',
    JDTLS_JVM_ARGS = os.getenv 'JDTLS_JVM_ARGS',
}

local function get_cache_dir()
    return env.XDG_CACHE_HOME and env.XDG_CACHE_HOME or env.HOME .. '/.cache'
end

local function get_jdtls_cache_dir()
    return get_cache_dir() .. '/jdtls'
end

local function get_jdtls_config_dir()
    return get_jdtls_cache_dir() .. '/config'
end

local function get_jdtls_workspace_dir()
    return get_jdtls_cache_dir() .. '/workspace'
end

local function get_jdtls_jvm_args()
    local args = {}
    for a in string.gmatch((env.JDTLS_JVM_ARGS or ''), '%S+') do
        local arg = string.format('--jvm-arg=%s', a)
        table.insert(args, arg)
    end
    return unpack(args)
end

local function get_jdtls()
    -- Find the full path to the directory where Mason has downloaded the JDTLS binaries
    local jdtls_path = "/Users/test/.local/share/nvim/mason/packages/jdtls"
    local shared_config_path = jdtls_path .. "/config_mac"
    -- Obtain the path to the jar which runs the language server
    local launcher = vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar")
    -- Declare white operating system we are using, windows use win, macos use mac
    local SYSTEM = "linux"
    -- Obtain the path to configuration files for your specific operating system
    local config = jdtls_path .. "/config_" .. SYSTEM
    -- Obtain the path to the Lomboc jar
    local lombok = jdtls_path .. "/lombok.jar"
    return launcher, lombok, shared_config_path
end

local launcher, lombok, shared_config_path = get_jdtls()

vim.lsp.config("jdtls", {
    cmd = {
        'java',
        '-Declipse.application=org.eclipse.jdt.ls.core.id1',
        '-Dosgi.bundles.defaultStartLevel=4',
        '-Declipse.product=org.eclipse.jdt.ls.core.product',
        "-Dosgi.checkConfiguration=true",
        "-Dosgi.sharedConfiguration.area=" .. shared_config_path,
        "-Dosgi.sharedConfiguration.area.readOnly=true",
        "-Dosgi.configuration.cascaded=true",
        '-Dlog.protocol=true',
        '-Dlog.level=ALL',
        '-Xmx1g',
        '--add-modules=ALL-SYSTEM',
        '--add-opens', 'java.base/java.util=ALL-UNNAMED',
        '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
        '-javaagent:' .. lombok,
        '-jar',
        launcher,
        '-configuration',
        get_jdtls_config_dir(),
        '-data',
        get_jdtls_workspace_dir(),
        get_jdtls_jvm_args(),
    },
    filetypes = { 'java' },
    root_markers = {
        -- Multi-module projects
        '.git',
        'build.gradle',
        'build.gradle.kts',
        -- Single-module projects
        'build.xml',           -- Ant
        'pom.xml',             -- Maven
        'settings.gradle',     -- Gradle
        'settings.gradle.kts', -- Gradle
    },
    settings = {
        java = {
            -- Enable method signature help
            signatureHelp = {
                enabled = true
            },
            implementationCodeLens = "all",
            referencesCodeLens = {
                enabled = true
            },
            maven = {
                downloadSources = true
            },
            configuration = {
                updateBuildConfiguration = "interactive"
            },
            
        
            
        },
    },
})


vim.lsp.enable({
    "lua_ls",
    "jdtls",
})

vim.diagnostic.config({
    virtual_text = true,
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        border = "rounded",
        source = true,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "󰅚 ",
            [vim.diagnostic.severity.WARN] = "󰀪 ",
            [vim.diagnostic.severity.INFO] = "󰋽 ",
            [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = "ErrorMsg",
            [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
    },
})


-- Extras

local function restart_lsp(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    for _, client in ipairs(clients) do
        vim.lsp.stop_client(client.id)
    end

    vim.defer_fn(function()
        vim.cmd('edit')
    end, 100)
end

vim.api.nvim_create_user_command('LspRestart', function()
    restart_lsp()
end, {})

local function lsp_status()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if #clients == 0 then
        print("󰅚 No LSP clients attached")
        return
    end

    print("󰒋 LSP Status for buffer " .. bufnr .. ":")
    print("─────────────────────────────────")

    for i, client in ipairs(clients) do
        print(string.format("󰌘 Client %d: %s (ID: %d)", i, client.name, client.id))
        print("  Root: " .. (client.config.root_dir or "N/A"))
        print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

        -- Check capabilities
        local caps = client.server_capabilities
        local features = {}
        if caps.completionProvider then table.insert(features, "completion") end
        if caps.hoverProvider then table.insert(features, "hover") end
        if caps.definitionProvider then table.insert(features, "definition") end
        if caps.referencesProvider then table.insert(features, "references") end
        if caps.renameProvider then table.insert(features, "rename") end
        if caps.codeActionProvider then table.insert(features, "code_action") end
        if caps.documentFormattingProvider then table.insert(features, "formatting") end

        print("  Features: " .. table.concat(features, ", "))
        print("")
    end
end

vim.api.nvim_create_user_command('LspStatus', lsp_status, { desc = "Show detailed LSP status" })

local function check_lsp_capabilities()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if #clients == 0 then
        print("No LSP clients attached")
        return
    end

    for _, client in ipairs(clients) do
        print("Capabilities for " .. client.name .. ":")
        local caps = client.server_capabilities

        local capability_list = {
            { "Completion",                caps.completionProvider },
            { "Hover",                     caps.hoverProvider },
            { "Signature Help",            caps.signatureHelpProvider },
            { "Go to Definition",          caps.definitionProvider },
            { "Go to Declaration",         caps.declarationProvider },
            { "Go to Implementation",      caps.implementationProvider },
            { "Go to Type Definition",     caps.typeDefinitionProvider },
            { "Find References",           caps.referencesProvider },
            { "Document Highlight",        caps.documentHighlightProvider },
            { "Document Symbol",           caps.documentSymbolProvider },
            { "Workspace Symbol",          caps.workspaceSymbolProvider },
            { "Code Action",               caps.codeActionProvider },
            { "Code Lens",                 caps.codeLensProvider },
            { "Document Formatting",       caps.documentFormattingProvider },
            { "Document Range Formatting", caps.documentRangeFormattingProvider },
            { "Rename",                    caps.renameProvider },
            { "Folding Range",             caps.foldingRangeProvider },
            { "Selection Range",           caps.selectionRangeProvider },
        }

        for _, cap in ipairs(capability_list) do
            local status = cap[2] and "✓" or "✗"
            print(string.format("  %s %s", status, cap[1]))
        end
        print("")
    end
end

vim.api.nvim_create_user_command('LspCapabilities', check_lsp_capabilities, { desc = "Show LSP capabilities" })

local function lsp_diagnostics_info()
    local bufnr = vim.api.nvim_get_current_buf()
    local diagnostics = vim.diagnostic.get(bufnr)

    local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

    for _, diagnostic in ipairs(diagnostics) do
        local severity = vim.diagnostic.severity[diagnostic.severity]
        counts[severity] = counts[severity] + 1
    end

    print("󰒡 Diagnostics for current buffer:")
    print("  Errors: " .. counts.ERROR)
    print("  Warnings: " .. counts.WARN)
    print("  Info: " .. counts.INFO)
    print("  Hints: " .. counts.HINT)
    print("  Total: " .. #diagnostics)
end

vim.api.nvim_create_user_command('LspDiagnostics', lsp_diagnostics_info, { desc = "Show LSP diagnostics count" })


local function lsp_info()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    print("═══════════════════════════════════")
    print("           LSP INFORMATION          ")
    print("═══════════════════════════════════")
    print("")

    -- Basic info
    print("󰈙 Language client log: " .. vim.lsp.get_log_path())
    print("󰈔 Detected filetype: " .. vim.bo.filetype)
    print("󰈮 Buffer: " .. bufnr)
    print("󰈔 Root directory: " .. (vim.fn.getcwd() or "N/A"))
    print("")

    if #clients == 0 then
        print("󰅚 No LSP clients attached to buffer " .. bufnr)
        print("")
        print("Possible reasons:")
        print("  • No language server installed for " .. vim.bo.filetype)
        print("  • Language server not configured")
        print("  • Not in a project root directory")
        print("  • File type not recognized")
        return
    end

    print("󰒋 LSP clients attached to buffer " .. bufnr .. ":")
    print("─────────────────────────────────")

    for i, client in ipairs(clients) do
        print(string.format("󰌘 Client %d: %s", i, client.name))
        print("  ID: " .. client.id)
        print("  Root dir: " .. (client.config.root_dir or "Not set"))
        print("  Command: " .. table.concat(client.config.cmd or {}, " "))
        print("  Filetypes: " .. table.concat(client.config.filetypes or {}, ", "))

        -- Server status
        if client.is_stopped() then
            print("  Status: 󰅚 Stopped")
        else
            print("  Status: 󰄬 Running")
        end

        -- Workspace folders
        if client.workspace_folders and #client.workspace_folders > 0 then
            print("  Workspace folders:")
            for _, folder in ipairs(client.workspace_folders) do
                print("    • " .. folder.name)
            end
        end

        -- Attached buffers count
        local attached_buffers = {}
        for buf, _ in pairs(client.attached_buffers or {}) do
            table.insert(attached_buffers, buf)
        end
        print("  Attached buffers: " .. #attached_buffers)

        -- Key capabilities
        local caps = client.server_capabilities
        local key_features = {}
        if caps.completionProvider then table.insert(key_features, "completion") end
        if caps.hoverProvider then table.insert(key_features, "hover") end
        if caps.definitionProvider then table.insert(key_features, "definition") end
        if caps.documentFormattingProvider then table.insert(key_features, "formatting") end
        if caps.codeActionProvider then table.insert(key_features, "code_action") end

        if #key_features > 0 then
            print("  Key features: " .. table.concat(key_features, ", "))
        end

        print("")
    end

    -- Diagnostics summary
    local diagnostics = vim.diagnostic.get(bufnr)
    if #diagnostics > 0 then
        print("󰒡 Diagnostics Summary:")
        local counts = { ERROR = 0, WARN = 0, INFO = 0, HINT = 0 }

        for _, diagnostic in ipairs(diagnostics) do
            local severity = vim.diagnostic.severity[diagnostic.severity]
            counts[severity] = counts[severity] + 1
        end

        print("  󰅚 Errors: " .. counts.ERROR)
        print("  󰀪 Warnings: " .. counts.WARN)
        print("  󰋽 Info: " .. counts.INFO)
        print("  󰌶 Hints: " .. counts.HINT)
        print("  Total: " .. #diagnostics)
    else
        print("󰄬 No diagnostics")
    end

    print("")
    print("Use :LspLog to view detailed logs")
    print("Use :LspCapabilities for full capability list")
end

-- Create command
vim.api.nvim_create_user_command('LspInfo', lsp_info, { desc = "Show comprehensive LSP information" })


local function lsp_status_short()
    local bufnr = vim.api.nvim_get_current_buf()
    local clients = vim.lsp.get_clients({ bufnr = bufnr })

    if #clients == 0 then
        return "" -- Return empty string when no LSP
    end

    local names = {}
    for _, client in ipairs(clients) do
        table.insert(names, client.name)
    end

    return "󰒋 " .. table.concat(names, ",")
end

local function git_branch()
    local ok, handle = pcall(io.popen, "git branch --show-current 2>/dev/null")
    if not ok or not handle then
        return ""
    end
    local branch = handle:read("*a")
    handle:close()
    if branch and branch ~= "" then
        branch = branch:gsub("\n", "")
        return " 󰊢 " .. branch
    end
    return ""
end

local function formatter_status()
    local ok, conform = pcall(require, "conform")
    if not ok then
        return ""
    end

    local formatters = conform.list_formatters_to_run(0)
    if #formatters == 0 then
        return ""
    end

    local formatter_names = {}
    for _, formatter in ipairs(formatters) do
        table.insert(formatter_names, formatter.name)
    end

    return "󰉿 " .. table.concat(formatter_names, ",")
end

local function linter_status()
    local ok, lint = pcall(require, "lint")
    if not ok then
        return ""
    end

    local linters = lint.linters_by_ft[vim.bo.filetype] or {}
    if #linters == 0 then
        return ""
    end

    return "󰁨 " .. table.concat(linters, ",")
end
-- Safe wrapper functions for statusline
local function safe_git_branch()
    local ok, result = pcall(git_branch)
    return ok and result or ""
end

local function safe_lsp_status()
    local ok, result = pcall(lsp_status_short)
    return ok and result or ""
end

local function safe_formatter_status()
    local ok, result = pcall(formatter_status)
    return ok and result or ""
end

local function safe_linter_status()
    local ok, result = pcall(linter_status)
    return ok and result or ""
end

_G.git_branch = safe_git_branch
_G.lsp_status = safe_lsp_status
_G.formatter_status = safe_formatter_status
_G.linter_status = safe_linter_status

-- THEN set the statusline
vim.opt.statusline = table.concat({
    "%{v:lua.git_branch()}",       -- Git branch
    "%f",                          -- File name
    "%m",                          -- Modified flag
    "%r",                          -- Readonly flag
    "%=",                          -- Right align
    "%{v:lua.linter_status()}",    -- Linter status
    "%{v:lua.formatter_status()}", -- Formatter status
    "%{v:lua.lsp_status()}",       -- LSP status
    " %l:%c",                      -- Line:Column
    " %p%%"                        -- Percentage through file
}, " ")
