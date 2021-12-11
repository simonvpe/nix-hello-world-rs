lua << EOF

    function xrequire (x, ok)
        local status, res = pcall(require, x)
        if status and ok then
            ok(res)
        end
    end

    xrequire("lspconfig", function (nvim_lsp)
        print("lspconfig loaded")
        local opts = {
            tools = {
                autoSetHints = true,
                hover_with_actions = true,
                inlay_hints = {
                    show_parameter_hints = false,
                    parameter_hints_prefix = "",
                    other_hints_prefix = "",
                },
            },

            server = {
                settings = {
                    ["rust-analyzer"] = {
                        checkOnSave = {
                            command = "clippy"
                        },
                    },
                },
            },

            root_dir = function()
                return vim.fn.getcwd()
            end
        }

        xrequire "rust-tools"
    end)
EOF

