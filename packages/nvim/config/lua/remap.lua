----------------
-- COPY PASTE --
----------------

-- Copy to system clipboard
vim.keymap.set({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank (copy) to system clipboard" })
vim.keymap.set("n", "<leader>Y", '"+Y', { desc = "Yank (copy) until end of line to system clipboard" })

-- Replace
vim.keymap.set("v", "R", '"_dP', { desc = "Replace" })

-----------------
-- VISUAL LINE --
-----------------

-- Move lines
vim.keymap.set("v", "J", ":m '>+1<cr>gv=gv", { desc = "Move selection up" })
vim.keymap.set("v", "K", ":m '<-2<cr>gv=gv", { desc = "Move selection down" })

-- Keep selection after indentation
vim.keymap.set("v", "<", "<gv", { desc = "Decrease indentation" })
vim.keymap.set("v", ">", ">gv", { desc = "Increase indentation" })

----------
-- VIEW --
----------

-- Keep cursor on join
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join with next line" })

--------------------
-- USER INTERFACE --
--------------------

-- Terminal
vim.keymap.set("n", "<leader>t", "<cmd>15sp term://bash<cr><c-w><c-x>", { desc = "Open terminal" })
vim.keymap.set("t", "<esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })

----------
-- MISC --
----------

-- Go to definition in help
vim.keymap.set("n", "gd", "<c-]>", { desc = "Go to definition" })

-- Close Quickfix
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "qf" },
    callback = function(data)
        vim.keymap.set("n", "<cr>", "<cr><cmd>cclose<cr>", { buffer = data.buf })
        vim.keymap.set("n", "q", "<cmd>q<cr>", { buffer = data.buf })
    end,
})
