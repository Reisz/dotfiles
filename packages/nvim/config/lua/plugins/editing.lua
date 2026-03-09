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
        dependencies = { "nvim-next" },
        config = function(_, opts)
            local leap = require "leap"
            leap.setup(opts)

            local leap_backward, leap_forward = require("nvim-next.move").make_repeatable_pair(function(args)
                leap.leap { ["repeat"] = args.repeating, backward = true }
            end, function(args)
                leap.leap { ["repeat"] = args.repeating }
            end)

            vim.keymap.set({ "n", "x", "o" }, "s", leap_forward, { desc = "Leap forwards" })
            vim.keymap.set({ "n", "x", "o" }, "S", leap_backward, { desc = "Leap backwards" })
            vim.keymap.set({ "n", "o" }, "gs", function()
                require("leap.remote").action()
            end, { desc = "Phantom Leap" })

            vim.keymap.set({ "n", "x", "o" }, "ga", function()
                require("leap.treesitter").select()
            end, { desc = "Leap Tree-sitter selection" })
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
