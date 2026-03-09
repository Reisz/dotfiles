return {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-nvim-lsp-signature-help",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
    },
    opts = function()
        local luasnip = require "luasnip"
        local cmp = require "cmp"

        return {
            completion = {
                completeopt = "menu,menuone,noinsert",
            },
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert {
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-l>"] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(1) then
                        luasnip.jump(1)
                    else
                        fallback()
                    end
                end),
                ["<C-h>"] = cmp.mapping(function(fallback)
                    if luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end),
            },
            sources = cmp.config.sources({
                { name = "nvim_lsp" },
                { name = "nvim_lsp_signature_help" },
                { name = "luasnip" },
                { name = "lazydev" },
                { name = "path" },
            }, {
                { name = "buffer" },
            }),
        }
    end,
}
