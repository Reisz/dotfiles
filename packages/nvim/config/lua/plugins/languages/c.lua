return {
    {
        "nvim-lspconfig",
        opts = {
            clangd = {
                cmd = { "clangd", "--header-insertion=never" },
                after_attach = function()
                    vim.keymap.set(
                        "n",
                        "gI",
                        "<cmd>LspClangdSwitchSourceHeader<cr>",
                        { desc = "Switch between source and header" }
                    )
                end,
            },
        },
    },
    {
        "conform.nvim",
        opts = {
            formatters_by_ft = {
                c = { "clang-format" },
                cpp = { "clang-format" },
            },
        },
    },
    {
        "nvim-dap",
        dependencies = {
            {
                "Reisz/nvim-dap-ctest-config-provider",
                opts = { templates = { "gdb" } },
            },
        },
        opts = {
            gdb = {
                type = "executable",
                command = "gdb",
                args = { "--interpreter=dap", "--eval-command", "set print pretty on" },
            },
        },
    },
}
