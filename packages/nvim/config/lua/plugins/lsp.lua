return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        opts = {},
        config = function(_, opts)
            vim.api.nvim_create_autocmd("LspAttach", {
                callback = function(event)
                    local function map(modes, lhs, rhs, desc)
                        vim.keymap.set(modes, lhs, rhs, { buffer = event.buf, desc = desc })
                    end

                    local function toggle_inlay()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
                    end

                    local buf = vim.lsp.buf
                    local diag = vim.diagnostic
                    local move = require("nvim-next.integrations").diagnostic()

                    -- Inspection
                    map("n", "K", buf.hover, "Hover")
                    map("n", "gK", buf.signature_help, "Signature help")
                    map("i", "<c-k>", buf.signature_help, "Signature help")
                    map("n", "gl", diag.open_float, "Show diagnostics")

                    -- Virtual text
                    map("n", "<leader>cK", toggle_inlay, "Toggle inlay hints")

                    -- Semantic Jumps
                    map("n", "gd", buf.definition, "Go to definition")
                    map("n", "gD", buf.declaration, "Go to declaration")
                    map("n", "gi", buf.implementation, "Go to implementation")
                    map("n", "go", buf.type_definition, "Go to type definition")

                    -- Diagnostic Jumps
                    map("n", "[d", move.goto_prev(), "Previous diagnostic")
                    map("n", "]d", move.goto_next(), "Next diagnostic")
                    map("n", "[D", move.goto_prev { severity = diag.severity.ERROR }, "Previous error")
                    map("n", "]D", move.goto_next { severity = diag.severity.ERROR }, "Next error")

                    -- Actions
                    map("n", "<leader>cr", buf.rename, "Rename symbol")
                    map({ "n", "v" }, "<leader>ca", buf.code_action, "Run code action")
                end,
            })

            for server, config in pairs(opts) do
                vim.lsp.config(server, config)
                vim.lsp.enable(server)
            end
        end,
    },
}
