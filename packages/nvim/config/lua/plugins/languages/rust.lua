return {
    {
        "nvim-lspconfig",
        opts = {
            rust_analyzer = {
                settings = {
                    ["rust-analyzer"] = {
                        check = { command = "clippy" },
                    },
                },
                on_attach = function()
                    -- Stop semantic highlight from overriding custom injection
                    vim.api.nvim_set_hl(0, "@lsp.type.comment", {})
                end,
            },
        },
    },
    {
        "conform.nvim",
        opts = {
            formatters_by_ft = {
                rust = { "rustfmt", "leptosfmt" },
            },
        },
    },
    {
        "vxpm/ferris.nvim",
        ft = "rust",
        opts = {},
    },
}
