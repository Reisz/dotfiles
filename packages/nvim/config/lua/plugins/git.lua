return {
    {
        "tpope/vim-fugitive",
        keys = {
            { "<leader>gS", "<cmd>tab Git<cr>", desc = "Git status" },
            { "<leader>gl", "<cmd>tab Git log<cr>", desc = "Git log" },
        },
    },
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            on_attach = function(buf)
                local function map(modes, lhs, rhs, desc)
                    vim.keymap.set(modes, lhs, rhs, { buffer = buf, desc = desc })
                end

                local gitsigns = require "gitsigns"
                local move = require("nvim-next.integrations").gitsigns(gitsigns)

                -- Inspect
                map("n", "<leader>gK", gitsigns.preview_hunk, "Git preview hunk")
                map("n", "<leader>gb", gitsigns.blame_line, "Git blame line")

                -- Jump
                map("n", "]g", move.next_hunk, "Next Git hunk")
                map("n", "[g", move.prev_hunk, "Previous Git hunk")

                -- Modify
                map("n", "<leader>gs", gitsigns.stage_hunk, "Git stage hunk")
                map("n", "<leader>gu", gitsigns.undo_stage_hunk, "Git undo stage hunk")
            end,
        },
    },
}
