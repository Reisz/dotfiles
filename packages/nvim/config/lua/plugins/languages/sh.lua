return {
    {
        "conform.nvim",
        opts = {
            formatters_by_ft = {
                sh = { "shfmt" },
            },
        },
    },
    {
        "nvim-lint",
        opts = {
            linters_by_ft = {
                sh = { "shellcheck" },
            },
        },
    },
}
