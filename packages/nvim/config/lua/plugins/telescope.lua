local function telescope(picker, opts)
    return function()
        require("telescope.builtin")[picker](opts)
    end
end

local function fb(...)
    return require("telescope").extensions.file_browser.file_browser(...)
end

return {
    {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
    },
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-telescope/telescope-fzf-native.nvim",
            "nvim-telescope/telescope-file-browser.nvim",
        },
        opts = function()
            local actions = require "telescope.actions"
            local fb_actions = require("telescope").extensions.file_browser.actions
            return {
                defaults = {
                    mappings = {
                        i = {
                            ["<C-y>"] = actions.select_default,
                            ["<esc>"] = actions.close,
                        },
                    },
                },
                pickers = {
                    find_files = {
                        follow = true,
                    },
                    git_files = {
                        show_untracked = true,
                    },
                    lsp_references = {
                        include_declaration = false,
                        show_line = false,
                    },
                    lsp_document_symbols = {
                        symbol_width = 55,
                        ignore_symbols = { "namespace" },
                        symbol_highlights = {},
                    },
                    lsp_workspace_symbols = {
                        ignore_symbols = { "namespace" },
                        symbol_highlights = {},
                    },
                },
                extensions = {
                    file_browser = {
                        grouped = true,
                        hide_parent_dir = true,
                        mappings = {
                            i = {
                                -- No-op default <C-o> to prevent mistakes
                                ["<C-o>"] = function() end,
                                -- Individual mappings react faster than relying on default <C-o>
                                ["<C-o>c"] = fb_actions.create,
                                ["<C-o>r"] = fb_actions.rename,
                                ["<C-o>m"] = fb_actions.move,
                                ["<C-o>y"] = fb_actions.copy,
                                ["<C-o>d"] = fb_actions.remove,
                                ["<C-o>o"] = fb_actions.open,
                                ["<C-o>g"] = fb_actions.goto_parent_dir,
                                ["<C-o>e"] = fb_actions.goto_home_dir,
                                ["<C-o>w"] = fb_actions.goto_cwd,
                                ["<C-o>t"] = fb_actions.change_cwd,
                                ["<C-o>f"] = fb_actions.toggle_browser,
                                ["<C-o>h"] = fb_actions.toggle_hidden,
                                ["<C-o>s"] = fb_actions.toggle_all,
                            },
                        },
                    },
                },
            }
        end,
        config = function(_, opts)
            require("telescope").setup(opts)
            require("telescope").load_extension "fzf"
            require("telescope").load_extension "file_browser"
        end,
        keys = {
            -- Files
            { "<leader>ff", telescope "find_files", desc = "Find files" },
            { "<leader>fF", telescope("find_files", { no_ignore = true }), desc = "Find all files" },
            { "<leader>fg", telescope "git_files", desc = "Find git files" },
            -- Browser
            {
                "<leader>fb",
                function()
                    fb { path = vim.fn.expand "%:p:h", select_buffer = true }
                end,
                desc = "Open file browser",
            },
            {
                "<leader>fB",
                function()
                    fb()
                end,
                desc = "Open root file browser",
            },
            -- Search
            { "<leader>f/", telescope "live_grep", desc = "Find text" },
            {
                "<leader>f/",
                telescope "grep_string",
                mode = "v",
                desc = "Find text",
            },
            { "<leader>f*", telescope "current_buffer_fuzzy_find", desc = "Find in buffer" },
            -- LSP
            { "<leader>fr", telescope "lsp_references", desc = "List document symbols" },
            { "<leader>fs", telescope "lsp_document_symbols", desc = "List document symbols" },
            { "<leader>fS", telescope "lsp_workspace_symbols", desc = "List workspace symbols" },
            { "<leader>fd", telescope "diagnostics", desc = "List diagnostics" },
            -- Other
            { "<leader>f.", telescope "resume", desc = "Telescope resume previous" },
            { "<leader>fq", telescope "quickfix", desc = "Telescope quickfix" },
            { "<leader>fh", telescope "help_tags", desc = "Find in help" },
            { "<leader>fk", telescope "keymaps", desc = "Find in keymaps" },
        },
    },
}
