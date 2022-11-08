local M = {}

function M.rust_tools()
    require('rust-tools').setup {
        server = {
            imports = {
                granularity = {
                    enforce = true,
                    group = 'crate',
                },
                merge = {
                    glob = false,
                },
                prefix = 'crate',
            },
            cargo = {
                features = 'all',
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true,
            },
            checkOnSave = {
                command = 'clippy',
            },
            diagnostics = {
                experimental = {
                    enable = true,
                },
            },
        }
    }
end

function M.crates()
    require('crates').setup {}

    vim.autocmd('BufRead', 'Cargo.toml', function()
        require('cmp').setup.buffer {
            sources = {
                { name = 'crates' },
            },
        }
    end, {})
end

function M.neorg()
    require('neorg').setup {
        load = {
            -- defaults:
            ['core.defaults'] = {},
            ['core.keybinds'] = {
                config = {
                    default_keybinds = false
                }
            },
            -- extra:
            ['core.norg.concealer'] = {
                config = {
                    icon_preset = "varied",
                    markup_preset = "dimmed"
                }
            },
            -- ['core.norg.dirman'] = {
            --     config = {
            --         workspaces = {
            --             main = "$XDG_NOTE_DIR",
            --         }
            --     }
            -- },
        },
    }
end

return M
