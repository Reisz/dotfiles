return {
    {
        {
            "mfussenegger/nvim-dap",
            dependencies = {
                "nvim-dap-ui",
            },
            keys = {
                -- Session management
                {
                    "<leader>dd",
                    function()
                        require("dap").continue()
                    end,
                    desc = "Dap: Start / continue",
                },
                {
                    "<leader>dp",
                    function()
                        require("dap").pause()
                    end,
                    desc = "Dap: Pause",
                },
                {
                    "<leader>dr",
                    function()
                        require("dap").restart()
                    end,
                    desc = "Dap: Restart",
                },
                {
                    "<leader>dq",
                    function()
                        require("dap").terminate()
                    end,
                    desc = "Dap: Stop",
                },

                -- Stepping
                {
                    "<F9>",
                    function()
                        require("dap").step_back()
                    end,
                    desc = "Dap: Step back",
                },
                {
                    "<F10>",
                    function()
                        require("dap").step_over()
                    end,
                    desc = "Dap: Step over",
                },
                {
                    "<F11>",
                    function()
                        require("dap").step_into()
                    end,
                    desc = "Dap: Step into",
                },
                {
                    "<F12>",
                    function()
                        require("dap").step_out()
                    end,
                    desc = "Dap: Step out",
                },
                {
                    "<leader>dc",
                    function()
                        require("dap").run_to_cursor()
                    end,
                    desc = "Dap: Run to cursor",
                },

                -- Inspection
                {
                    "<leader>dj",
                    function()
                        require("dap").down()
                    end,
                    desc = "Dap: Down",
                },
                {
                    "<leader>dk",
                    function()
                        require("dap").up()
                    end,
                    desc = "Dap: Up",
                },

                -- Breakpoints
                {
                    "<leader>db",
                    function()
                        require("dap").toggle_breakpoint()
                    end,
                    desc = "Toggle breakpoint",
                },
                {
                    "<leader>dB",
                    function()
                        require("dap").set_breakpoint(vim.fn.input "Breakpoint condition: ")
                    end,
                    desc = "Set conditional breakpoint",
                },
            },
            config = function(_, opts)
                local dap = require "dap"

                -- Apply options
                for adapter, adapter_opts in pairs(opts) do
                    dap.adapters[adapter] = adapter_opts
                end

                vim.fn.sign_define("DapBreakpoint", { text = " ", texthl = "DiagnosticInfo" })
                vim.fn.sign_define("DapBreakpointCondition", { text = " ", texthl = "DiagnosticInfo" })
                vim.fn.sign_define("DapBreakpointRejected", { text = " ", texthl = "DiagnosticError" })
                vim.fn.sign_define("DapLogPoint", { text = ".>", texthl = "DiagnosticInfo" })
                vim.fn.sign_define(
                    "DapStopped",
                    { text = "󰁕 ", texthl = "DiagnosticWarn", linehl = "DapStoppedLine", numhl = "DapStoppedLine" }
                )
            end,
        },
        {
            "rcarriga/nvim-dap-ui",
            lazy = true,
            dependencies = {
                "nvim-neotest/nvim-nio",
            },
            opts = {
                controls = { enabled = false },
            },
            config = function(_, opts)
                local dapui = require "dapui"
                dapui.setup(opts)

                local dap = require "dap"
                dap.listeners.before.attach.dapui_config = dapui.open
                dap.listeners.before.launch.dapui_config = dapui.open
                dap.listeners.before.event_terminated.dapui_config = dapui.close
                dap.listeners.before.event_exited.dapui_config = dapui.close
            end,
        },
    },
}
