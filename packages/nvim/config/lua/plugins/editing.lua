return {
    -- Repeats
    { "tpope/vim-repeat", event = "VeryLazy" },
    {
        "ghostbuster91/nvim-next",
        event = "VeryLazy",
        opts = function()
            local builtins = require "nvim-next.builtins"
            return {
                items = {
                    builtins.f,
                    builtins.t,
                },
            }
        end,
        config = function(_, opts)
            require("nvim-next").setup(opts)

            local qf = require("nvim-next.integrations").quickfix()
            vim.keymap.set("n", "<C-j>", qf.cnext, { desc = "Go to next quickfix entry" })
            vim.keymap.set("n", "<C-k>", qf.cprevious, { desc = "Go to previous quickfix endtry" })
        end,
    },

    -- Jumps
    { "arnamak/stay-centered.nvim", opts = {} },
    {
        "https://codeberg.org/andyg/leap.nvim",
        config = function(_, opts)
            local leap = require "leap"
            leap.setup(opts)

            vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap-forward)", { desc = "Leap forward" })
            vim.keymap.set({ "n", "x", "o" }, "S", "<Plug>(leap-backward)", { desc = "Leap backward" })
            vim.keymap.set("n", "gs", "<Plug>(leap-from-window)", { desc = "Leap from window" })
        end,
    },

    -- Automation
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        opts = {},
    },
    {
        "numToStr/Comment.nvim",
        event = "VeryLazy",
        opts = {},
    },
}
