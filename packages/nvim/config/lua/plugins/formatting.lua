return {
    {
        "stevearc/conform.nvim",
        event = { "BufReadPost", "BufNewFile" },
        keys = {
            {
                "<F3>",
                function()
                    require("conform").format { async = true }
                end,
                mode = { "n", "v" },
                desc = "Format buffer",
            },
        },
        opts = {
            default_format_opts = {
                lsp_format = "fallback",
            },
            format_on_save = {
                timeout_ms = 500,
            },
        },
    },
}
