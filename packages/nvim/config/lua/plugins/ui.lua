return {
    {
        "nvim-lualine/lualine.nvim",
        opts = {},
    },
    {
        "stevearc/dressing.nvim",
        opts = {
            input = {
                insert_only = false,
                start_in_insert = false,
            },
        },
    },
    {
        "mbbill/undotree",
        keys = {
            { "<leader>u", "<cmd>UndotreeToggle<cr>", desc = "Show undo tree" },
        },
    },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {},
    },
    {
        "j-hui/fidget.nvim",
        opts = {},
    },
    {
        "folke/tokyonight.nvim",
        priority = 1000,
        lazy = false,
        opts = {
            on_highlights = function(hl)
                hl.LineNr = { fg = "#7c8acc" }
            end,
        },
        config = function(_, opts)
            require("tokyonight").setup(opts)
            vim.cmd.colorscheme "tokyonight-storm"
        end,
    },
}
