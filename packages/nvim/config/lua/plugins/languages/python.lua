return {
    {
        "nvim-lspconfig",
        opts = {
            ruff = {},
            pylsp = {
                settings = {
                    pylsp = {
                        plugins = {
                            autopep8 = { enabled = false },
                            fake8 = { enabled = false },
                            mccabe = { enabled = false },
                            pycodestyle = { enabled = false },
                            pydocstyle = { enabled = false },
                            pyflakes = { enabled = false },
                            pylint = { enabled = false },
                            yapf = { enabled = false },

                            jedi = { environment = ".venv" },
                            rope_autoimport = { enabled = true },
                            rope_completion = { enabled = true },
                        },
                    },
                },
            },
        },
    },
    {
        "conform.nvim",
        opts = {
            formatters_by_ft = {
                python = { "ruff_format", "ruff_organize_imports" },
            },
        },
    },
}
