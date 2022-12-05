local M = {}

function M.vgit()
    require 'vgit'.setup {

    }
end

function M.gitsigns()
    require 'gitsigns'.setup {}
end

function M.setup_coq()
    vim.g.coq_settings = { auto_start = 'shut-up' }
    -- require 'coq'.setup {}
end

function M.treesitter()
    require 'nvim-treesitter.configs'.setup {
        ensure_installed = { 'c', 'lua', 'rust', 'vim', 'regex', 'bash', 'markdown', 'markdown_inline', 'org' },
        auto_install = true,
        highlight = {
            enable = true,
            -- disable = function(lang, buf) -- disable highlighting for files > 1MiB
            --     local max_filesize = 1024 * 1024 -- 1MiB
            --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            --     if ok and stats.size > max_filesize then
            --         return true
            --     end
            -- end
        }
    }
end

function M.neoformat()
    local group = vim.api.nvim_create_augroup('fmt', {})
    vim.api.nvim_create_autocmd({'BufWritePre'}, {
        group = group,
        pattern = { '*.nix' },
        command = 'undojoin | Neoformat',
        desc = 'run neoformat on save for matching files'
    })
end

function M.lsp_format()
    require('lsp-format').setup{}
end

function M.comment()
    require 'Comment'.setup {

    }
end

function M.lsp()
    local function get_lua_runtime_paths()
        local runtime_paths = vim.split(package.path, ';')
        table.insert(runtime_paths, 'lua/?.lua')
        table.insert(runtime_paths, 'lua/?/init.lua')
        return runtime_paths
    end

    local lsp = require('lspconfig')
    -- local util = require('lspconfig/util')
    local stat = require('lsp-status')
    local schema = require('schemastore')

    local servers = {
        -- shell
        bashls = {}, -- bash
        -- C/C++
        clangd = {
            handlers = stat.extensions.clangd.setup()
        },
        cmake = {},
        -- Misc Programming Languages
        hls = {}, -- Haskell
        pyright = {}, -- Python
        vimls = {}, -- Vimscript
        sumneko_lua = { -- Lua
            cmd = { 'lua-language-server' },
            settings = {
                Lua = {
                    hint = {
                        enable = true,
                    },
                    runtime = {
                        version = 'LuaJIT',
                        path = get_lua_runtime_paths(),
                    },
                    diagnostics = {
                        globals = { 'vim' },
                    },
                    workspace = {
                        library = vim.api.nvim_get_runtime_file('', true),
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        },
        -- Configuration Languages
        dhall_lsp_server = {}, -- Dhall
        rnix = { auto_format = false }, -- Nix
        yamlls = {}, -- YAML
        jsonls = { -- JSON
            settings = {
                json = {
                    schemas = schema.json.schemas()
                }
            }
        },
    }

    local set_keymaps = function(client, bufnr)
        -- keymaps
        local kopts = { noremap = true, silent = true, buffer = bufnr }
        vim.keymap.set('n', '<Leader>lD', vim.lsp.buf.declaration, kopts)
        vim.keymap.set('n', '<Leader>ld', vim.lsp.buf.definition, kopts)
        vim.keymap.set('n', '<Leader>li', vim.lsp.buf.implementation, kopts)
        vim.keymap.set('n', '<Leader>lr', vim.lsp.buf.references, kopts)
        vim.keymap.set('n', '<Leader>ls', vim.lsp.buf.signature_help, kopts)
        -- -- telescope
        local tsb = require 'telescope.builtin'
        local tst = require 'telescope.themes'
        vim.keymap.set('n', '<Leader>fla', function() tsb.lsp_code_actions(tst.get_cursor()) end, kopts)
        vim.keymap.set('n', '<Leader>flr', function() tsb.lsp_references(tst.get_cursor()) end, kopts)
        vim.keymap.set('n', '<Leader>fld', function() tsb.lsp_definitions(tst.get_cursor()) end, kopts)
        vim.keymap.set('n', '<Leader>flt', function() tsb.lsp_type_definitions(tst.get_cursor()) end, kopts)
        vim.keymap.set('n', '<Leader>fli', function() tsb.lsp_implementations(tst.get_cursor()) end, kopts)
        -- -- trouble
        vim.keymap.set('n', '<Leader>xt', '<cmd>TroubleToggle<cr>', kopts)
        vim.keymap.set('n', '<Leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>', kopts)
        vim.keymap.set('n', '<Leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>', kopts)
        vim.keymap.set('n', '<Leader>xl', '<cmd>TroubleToggle loclist<cr>', kopts)
        vim.keymap.set('n', '<Leader>xq', '<cmd>TroubleToggle quickfix<cr>', kopts)
    end

    local on_attach = function(auto_format)
        if auto_format then
            return function(client, bufnr)
                -- formatting
                require('lsp-format').on_attach(client)
                set_keymaps(client, bufnr)
            end
        else
            return set_keymaps
        end
    end

    -- set global variable so rust-tools can use it
    SIGNAL_LSP_ON_ATTACH = on_attach

    for srv, cfg in pairs(servers) do
        local auto_format = false
        if cfg['auto_format'] ~= nil then
            auto_format = cfg.auto_format
            cfg.auto_format = nil
        end

        if cfg['on_attach'] == nil then
            cfg.on_attach = on_attach(auto_format)
        end

        lsp[srv].setup(cfg)
    end
end

return M
