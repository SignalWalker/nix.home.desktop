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
        ensure_installed = { 'c', 'lua', 'rust', 'vim', 'regex', 'bash', 'markdown', 'markdown_inline' },
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

    -- Shell
    lsp.bashls.setup {}
    -- C/C++
    lsp.clangd.setup {
        handlers = stat.extensions.clangd.setup()
    }
    lsp.cmake.setup {}
    -- Misc Programming Languages
    lsp.hls.setup {} -- Haskell
    lsp.pyright.setup {} -- Python
    -- config languages
    lsp.dhall_lsp_server.setup {} -- dhall
    lsp.rnix.setup {} -- nix
    lsp.vimls.setup {} -- vimscript
    lsp.sumneko_lua.setup { -- lua
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
    }
    -- object / markup languages
    lsp.yamlls.setup {}
    lsp.jsonls.setup {
        settings = {
            json = {
                schemas = schema.json.schemas()
            }
        }
    }
end

return M
