return {
    {
        "nvim-lspconfig",
        opts = {
            lua_ls = {},
        },
    },
    {
        "nvim-lint",
        opts = {
            linters_by_ft = {
                lua = { "selene" },
            },
        },
    },
    {
        "conform.nvim",
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
            },
        },
    },
    {
        "folke/lazydev.nvim",
        ft = "lua",
        opts = {},
    },
}
