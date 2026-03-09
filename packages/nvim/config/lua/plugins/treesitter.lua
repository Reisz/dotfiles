return {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
        "nvim-treesitter/nvim-treesitter-textobjects",
        "nvim-treesitter/nvim-treesitter-context",
    },
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
        ensure_installed = "all",
        auto_install = false,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                node_incremental = "+",
                node_decremental = "-",
            },
        },
        indent = { enable = true },
        textobjects = {
            select = {
                enable = true,
                lookahead = true,
                keymaps = {
                    ["ia"] = { query = "@parameter.inner", desc = "inner argument" },
                    ["aa"] = { query = "@parameter.outer", desc = "an argument" },
                    ["if"] = { query = "@function.inner", desc = "inner function" },
                    ["af"] = { query = "@function.outer", desc = "a function" },
                    ["ic"] = { query = "@class.inner", desc = "inner class" },
                    ["ac"] = { query = "@class.outer", desc = "a class" },
                    ["aC"] = { query = "@comment.outer", desc = "a comment" },
                },
                include_surrounding_whitespace = function(data)
                    local settings = {
                        ["@parameter.outer_v"] = true,
                        ["@function.outer_v"] = true,
                        ["@class.outer_v"] = true,
                    }

                    return settings[data.query_string .. "_" .. data.selection_mode]
                end,
            },
            swap = {
                enable = true,
                swap_next = {
                    ["<leader>a"] = { query = "@parameter.inner", desc = "Swap argument with next" },
                },
                swap_previous = {
                    ["<leader>A"] = { query = "@parameter.inner", desc = "Swap argument with previous" },
                },
            },
        },
        nvim_next = {
            enable = true,
            textobjects = {
                move = {
                    enable = true,
                    set_jumps = true,
                    goto_next_start = {
                        ["]a"] = { query = "@parameter.inner", desc = "Next argument start" },
                        ["]m"] = { query = "@function.outer", desc = "Next method start" },
                        ["]]"] = { query = "@class.outer", desc = "Next class start" },
                    },
                    goto_next_end = {
                        ["]A"] = { query = "@parameter.inner", desc = "Next argument end" },
                        ["]M"] = { query = "@function.outer", desc = "Next method end" },
                        ["]["] = { query = "@class.outer", desc = "Next class end" },
                    },
                    goto_previous_start = {
                        ["[a"] = { query = "@parameter.inner", desc = "Previous argument start" },
                        ["[m"] = { query = "@function.outer", desc = "Previous method start" },
                        ["[["] = { query = "@class.outer", desc = "Previous class start" },
                    },
                    goto_previous_end = {
                        ["[A"] = { query = "@parameter.inner", desc = "Previous argument end" },
                        ["[M"] = { query = "@function.outer", desc = "Previous method end" },
                        ["[]"] = { query = "@class.outer", desc = "Previous class end" },
                    },
                },
            },
        },
    },
    config = function(_, opts)
        require("nvim-next.integrations").treesitter_textobjects()
        require("nvim-treesitter.configs").setup(opts)
        require("treesitter-context").setup {}

        vim.opt.foldmethod = "expr"
        vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt.foldenable = false
    end,
}
