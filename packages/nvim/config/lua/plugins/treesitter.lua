return {
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        event = { "BufReadPost", "BufNewFile" },
        opts = {},
        config = function()
            local lang_index = {}
            for _, lang in ipairs(require("nvim-treesitter").get_installed "parser") do
                lang_index[lang] = true
            end

            -- Enable highlights, indent and fold
            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local lang = vim.treesitter.language.get_lang(args.match)
                    if not lang or not lang_index[lang] then
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
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            select = {
                lookahead = true,
                include_surrounding_whitespace = {
                    { query = "@parameter.outer", mode = "v" },
                    { query = "@function.outer", mode = "v" },
                    { query = "@class.outer", mode = "v" },
                },
                keys = {
                    ["ia"] = { query = "parameter", desc = "inner argument" },
                    ["aa"] = { query = "parameter", desc = "an argument" },
                    ["if"] = { query = "function" },
                    ["af"] = { query = "function" },
                    ["ic"] = { query = "class" },
                    ["ac"] = { query = "class" },
                    ["aC"] = { query = "comment" },
                },
            },
            swap = {
                keys = {
                    ["<leader>a"] = { query = "@parameter.inner", desc = "argument" },
                    ["<leader>A"] = { query = "@parameter.inner", desc = "argument" },
                },
            },
            move = {
                set_jumps = true,
                keys = {
                    ["]a"] = { query = "@parameter.inner", desc = "argument" },
                    ["[a"] = { query = "@parameter.inner", desc = "argument" },
                    ["]A"] = { query = "@parameter.inner", desc = "argument" },
                    ["[A"] = { query = "@parameter.inner", desc = "argument" },
                    ["]m"] = { query = "@function.outer", desc = "method" },
                    ["[m"] = { query = "@function.outer", desc = "method" },
                    ["]M"] = { query = "@function.outer", desc = "method" },
                    ["[M"] = { query = "@function.outer", desc = "method" },
                    ["]]"] = { query = "@class.outer", desc = "class" },
                    ["[["] = { query = "@class.outer", desc = "class" },
                    ["]["] = { query = "@class.outer", desc = "class" },
                    ["[]"] = { query = "@class.outer", desc = "class" },
                },
            },
        },
        config = function(_, opts)
            local whitespace_config = {}
            for _, config in ipairs(opts.select.include_surrounding_whitespace) do
                whitespace_config[("%s_%s"):format(config.query, config.mode)] = true
            end
            opts.select.include_surrounding_whitespace = function(args)
                return whitespace_config[("%s_%s"):format(args.query_string, args.selection_mode)]
            end

            require("nvim-treesitter-textobjects").setup(opts)

            -- Select keybinds
            for keybind, key_opts in pairs(opts.select.keys) do
                local inner_outer_query, inner_outer_desc
                local inner_outer_key = keybind:sub(1, 1)
                if inner_outer_key == "i" then
                    inner_outer_query = "inner"
                    inner_outer_desc = "inner"
                elseif inner_outer_key == "a" then
                    inner_outer_query = "outer"
                    inner_outer_desc = "a"
                else
                    error("Keybind does not start with `i` or `a`: " .. keybind)
                end

                local query = ("@%s.%s"):format(key_opts.query, inner_outer_query)
                local desc = key_opts.desc or ("%s %s"):format(inner_outer_desc, key_opts.query)
                vim.keymap.set({ "x", "o" }, keybind, function()
                    require("nvim-treesitter-textobjects.select").select_textobject(query, "textobjects")
                end, { desc = desc })
            end

            -- Swap keybinds
            for keybind, key_opts in pairs(opts.swap.keys) do
                local next_prev = "next"
                local final_key = keybind:sub(-1)
                if final_key == final_key:upper() then
                    next_prev = "previous"
                end

                local method = "swap_" .. next_prev
                local desc = ("Swap %s with %s"):format(key_opts.desc, next_prev)
                vim.keymap.set("n", keybind, function()
                    require("nvim-treesitter-textobjects.swap")[method](key_opts.query, "textobjects")
                end, { desc = desc })
            end

            -- Move keybinds
            for keybind, key_opts in pairs(opts.move.keys) do
                local next_prev
                local next_prev_key = keybind:sub(1, 1)
                if next_prev_key == "]" then
                    next_prev = "next"
                elseif next_prev_key == "[" then
                    next_prev = "previous"
                else
                    error("Keybind does not start with `[` or `]`: " .. keybind)
                end

                local start_end = "start"
                local final_key = keybind:sub(-1)
                if
                    (final_key:find "%a" and final_key == final_key:upper())
                    or (final_key:find "%A" and final_key ~= next_prev_key)
                then
                    start_end = "end"
                end

                local method = ("goto_%s_%s"):format(next_prev, start_end)
                local next_prev_desc = next_prev:sub(1, 1):upper() .. next_prev:sub(2)
                local desc = ("%s %s %s"):format(next_prev_desc, key_opts.desc, start_end)
                vim.keymap.set({ "n", "x", "o" }, keybind, function()
                    require("nvim-treesitter-textobjects.move")[method](key_opts.query, "textobjects")
                end, { desc = desc })
            end
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-context",
        event = { "BufReadPost", "BufNewFile" },
    },
}
