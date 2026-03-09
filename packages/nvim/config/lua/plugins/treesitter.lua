local function textobjects_keys()
    local keys = {
        {
            "<leader>a",
            function()
                require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
            end,
            desc = "Swap argument with next",
        },
        {
            "<leader>A",
            function()
                require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.inner"
            end,
            desc = "Swap argument with previous",
        },
    }

    local select_mappings = {
        { "a", "parameter" },
        { "f", "function" },
        { "c", "class" },
        { "C", "comment" },
    }
    for _, mapping in ipairs(select_mappings) do
    end
end

local function map_select(keybind, scope, desc)
    scope = "@" .. scope
    return {
        keybind,
        function()
            require("nvim-treesitter-textobjects.select").select_textobject(scope, "textobjects")
        end,
        mode = { "x", "o" },
        desc = desc,
    }
end

return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        dependencies = {
            -- "nvim-treesitter/nvim-treesitter-context",
        },
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
        config = function()
            -- Enable highlights, indent and fold
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local lang = vim.treesitter.language.get_lang(args.match)
                    if not lang then
                        return
                    end

                    if not require("nvim-treesitter").get_installed("parser")[lang] then
                        return
                    end

                    vim.treesitter.start(args.buf)

                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"

                    vim.wo[0][0].foldexpr = "v:lua.vim.treesitter.foldexpr()"
                    vim.wo[0][0].foldmethod = "expr"
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        branch = "main",
        opts = {
            select = {
                lookahead = true,
                include_surrounding_whitespace = function(data)
                    local settings = {
                        ["@parameter.outer_v"] = true,
                        ["@function.outer_v"] = true,
                        ["@class.outer_v"] = true,
                    }
                    return settings[data.query_string .. "_" .. data.selection_mode]
                end,
            },
            move = {
                set_jumps = true,
            },
        },
        keys = {
            map_select("ia", "parameter.inner", "inner argument"),
            map_select("aa", "parameter.outer", "an argument"),
            map_select("if", "function.inner", "inner function"),
            map_select("af", "function.outer", "a function"),
            map_select("ic", "class.inner", "inner class"),
            map_select("ac", "class.outer", "a class"),
            map_select("aC", "comment.outer", "a comment"),

            {
                "<leader>a",
                function()
                    require("nvim-treesitter-textobjects.swap").swap_next "@parameter.inner"
                end,
                desc = "Swap argument with next",
            },
            {
                "<leader>A",
                function()
                    require("nvim-treesitter-textobjects.swap").swap_previous "@parameter.inner"
                end,
                desc = "Swap argument with previous",
            },
        },
    },
}
