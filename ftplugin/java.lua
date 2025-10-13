-- 设置 Java 缩进为 4 个空格
vim.bo.shiftwidth = 4     -- 自动缩进和重复缩进的宽度
vim.bo.tabstop = 4        -- 制表符的显示宽度
vim.bo.softtabstop = 4    -- 按 Tab 时的实际宽度（结合 expandtab 生效）
vim.bo.expandtab = true   -- 将制表符转换为空格（Java 常用规范）
vim.bo.smartindent = true -- 智能缩进（如大括号后自动缩进）


local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')

local jdtls_config_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"

local jdtls_workspace_dir = vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"

local function get_lombok()
    local args = {}
    local lombok_jar = vim.fn.expand("$MASON/share/jdtls/lombok.jar")
    if vim.fn.filereadable(lombok_jar) == 1 then
        table.insert(args, string.format('--jvm-arg=-javaagent:%s', lombok_jar))
    end
    return unpack(args)
end

-- 需要安装的 DAP 适配器和工具
local bundles = {}
bundles = vim.fn.glob("$MASON/share/java-debug-adapter/com.microsoft.java.debug.plugin-*jar", false, true)
vim.list_extend(bundles, vim.fn.glob("$MASON/share/java-test/*.jar", false, true))

local config = {
    name = "jdtls",
    cmd = {
        'jdtls',
        '-configuration',
        jdtls_config_dir,
        '-data',
        jdtls_workspace_dir,
        get_lombok(),
    },
    root_dir = vim.fs.root(0, { ".git", "mvnw", "gradlew" }),
    init_options = {
        bundles = bundles,
    },
    settings = {
        java = {
            import = {
                gradle = {
                    enabled = true
                },
                maven = {
                    enabled = true
                }
            },
            inlayHints = {
              parameterNames = {
                enabled = "all",
              },
            },
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
            gradle = {
                downloadSources = true
            },
            configuration = {
                updateBuildConfiguration = "interactive"
            },
            classFileContentsSupport = true,
            generateToStringPromptSupport = true,
            hashCodeEqualsPromptSupport = true,
            advancedExtractRefactoringSupport = true,
            advancedOrganizeImportsSupport = true,
            generateConstructorsPromptSupport = true,
            generateDelegateMethodsPromptSupport = true,
            moveRefactoringSupport = true,
            overrideMethodsPromptSupport = true,
            executeClientCommandSupport = true,
            inferSelectionSupport = {
                "extractMethod",
                "extractVariable",
                "extractConstant",
                "extractVariableAllOccurrence"
            },
        },

    }

}

require('jdtls').start_or_attach(config)
