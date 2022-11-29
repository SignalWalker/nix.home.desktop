local M = {}

function M.which_key()
    require 'which-key'.setup {}
end

function M.notify()
    local notify = require('notify')
    notify.setup {
        stages = 'static',
        fps = 120,
    }
	local ts = require('telescope')
    ts.load_extension("notify")
    vim.keymap.set('n', '<Leader>fvn', ts.extensions.notify.notify, { desc = 'telescope :: notifications' })
end

function M.hologram()
    require('hologram').setup{
        auto_display = true
    }
end

function M.gui_font_resize()
    require('gui-font-resize').setup{
        default_size = 9,
        change_by = 1,
        bounds = {
            maximum = 24,
            minimum = 6
        }
    }
    vim.keymap.set("n", '<D-Plus>', '<cmd>:GUIFontSizeUp<cr>', { desc = "increase gui font size" })
    vim.keymap.set("n", '<D-Minus>', '<cmd>:GUIFontSizeDown<cr>', { desc = "decrease gui font size" })
    vim.keymap.set("n", '<D-Equal>', '<cmd>:GUIFontSizeSet<cr>', { desc = "reset gui font size" })
    vim.keymap.set("n", '<D-kPlus>', '<cmd>:GUIFontSizeUp<cr>', { desc = "increase gui font size" })
    vim.keymap.set("n", '<D-kMinus>', '<cmd>:GUIFontSizeDown<cr>', { desc = "decrease gui font size" })
end

function M.hover()
    local hover = require 'hover'
    hover.setup {
        init = function()
            require 'hover.providers.lsp'
            require 'hover.providers.gh'
            require 'hover.providers.man'
            require 'hover.providers.dictionary'
        end,
        preview_opts = {
            border = nil,
        },
        preview_window = false,
        title = true,
    }
    vim.keymap.set('n', '<Leader>\'', hover.hover, { desc = "hover.nvim" })
    vim.keymap.set('n', '<Leader>g\'', hover.hover_select, { desc = "hover.nvim (select)" })
end

function M.noice()
    require('noice').setup {
        lsp = {
            override = {
                ["vim.lsp.util.convert_input_to_markdown_lines"] = false,
                ["vim.lsp.util.stylize_markdown"] = false,
                ["cmp.entry.get_documentation"] = false,
            }
        }
    }
	local ts = require('telescope')
    ts.load_extension("noice")
    vim.keymap.set('n', '<Leader>fvm', ts.extensions.noice.noice, { desc = 'telescope :: messages' })
end

function M.trouble()
    require('trouble').setup {

    }

    vim.keymap.set('n', '<Leader>xt', '<cmd>TroubleToggle<cr>', { desc = "trouble toggle" })
    vim.keymap.set('n', '<Leader>xw', '<cmd>TroubleToggle workspace_diagnostics<cr>',
        { desc = "trouble toggle workspace" })
    vim.keymap.set('n', '<Leader>xd', '<cmd>TroubleToggle document_diagnostics<cr>',
        { desc = "trouble toggle document" })
    vim.keymap.set('n', '<Leader>xl', '<cmd>TroubleToggle loclist<cr>',
        { desc = "trouble toggle loclist" })
    vim.keymap.set('n', '<Leader>xq', '<cmd>TroubleToggle quickfix<cr>',
        { desc = "trouble toggle quickfix" })

end

function M.leap()
    -- forward: s
    -- backward: S
    local leap = require'leap'
    leap.add_default_mappings()
end

function M.flit()
    -- forward to: f
    -- backward to: F
    -- forward before: t
    -- backward before: T
    require('flit').setup{}
end

function M.indent_guides()
    require('indent_blankline').setup {
        buftype_exclude = { 'terminal', 'alpha', 'help', 'packer', 'dashboard' },
        show_current_context = true,
    }
end

function M.lualine()
    require('lualine').setup {
        options = {
            icons_enabled = true,
            theme = 'auto',
            component_separators = { left = '', right = '' },
            section_separators = { left = '', right = '' },
            disabled_filetypes = {},
            always_divide_middle = true,
        },
        sections = {
            lualine_a = { 'mode' },
            lualine_b = { 'branch', 'diagnostics' },
            lualine_c = { 'hostname', { 'filename', path = 1 } },
            lualine_x = { 'encoding', 'fileformat', 'filetype' },
            lualine_y = { 'progress' },
            lualine_z = { 'location' }
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { 'hostname', { 'filename', path = 1 } },
            lualine_x = { 'location' },
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {
            lualine_a = { 'buffers' },
            lualine_b = { 'branch' },
            lualine_c = { 'hostname', { 'filename', path = 2 } },
            lualine_x = {},
            lualine_y = {},
            lualine_z = { 'tabs' }
        },
        extensions = {
            'nvim-tree',
        }
    }
end

M.dashboard = require('signal.plugins.ui.dashboard')

function M.window_picker()
    require('window-picker').setup{
        autoselect_one = true,
        include_current = false,
        filter_rules = {
            bo = {
                filetype = { 'neo-tree', 'neo-tree-popup', 'notify' },
                buftype = { 'terminal', 'quickfix' }
            }
        },
    }
end

M.neotree = require('signal.plugins.ui.neotree')

function M.nvimtree()
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwPlugin = 1
    vim.opt.termguicolors = true
    require 'nvim-tree'.setup {
        disable_netrw = true,
        hijack_netrw = true,
        open_on_setup = true,
        open_on_setup_file = false,
        ignore_ft_on_setup = { 'startify', 'alpha' },
        ignore_buf_on_tab_change = {},
        auto_reload_on_write = true,
        create_in_closed_folder = true,
        sort_by = 'extension',
        hijack_cursor = true,
        root_dirs = {},
        prefer_startup_root = false,
        sync_root_with_cwd = true,
        reload_on_bufenter = true,
        respect_buf_cwd = false,
        hijack_directories = {
            enable = true,
            auto_open = true,
        },
        update_focused_file = {
            enable = true,
            update_root = true,
            ignore_list = {}
        },
        system_open = {
            cmd = "",
            args = {},
        },
        diagnostics = {
            enable = true,
            show_on_dirs = true,
        },
        git = {
            enable = true,
            ignore = true,
            show_on_dirs = true,
        },
        filesystem_watchers = {
            enable = true
        },
        remove_keymaps = false,
        select_prompts = true,
        view = {
            adaptive_size = true,
            centralize_selection = false,
            hide_root_folder = false,
        },
        renderer = {
            add_trailing = false,
            group_empty = true,
            full_name = true,
            highlight_opened_files = 'name',
            indent_markers = {
                enable = false,
            },
            icons = {
                webdev_colors = true,
                git_placement = 'signcolumn',
            }
        },
        filters = {
            dotfiles = true,
            exclude = { '.gitignore' }
        },
        actions = {
            change_dir = {
                enable = true,
            },
            open_file = {
                quit_on_open = false,
                resize_window = true,
                window_picker = {
                    enable = true,
                }
            },
            remove_file = {
                close_window = false,
            },
            use_system_clipboard = true,
        },
        log = {
            enable = false,
            truncate = true,
        }
    }
    vim.keymap.set('n', '<Leader>tt', '<cmd>NvimTreeToggle<cr>', { desc = 'nvim-tree toggle' })
    vim.keymap.set('n', '<Leader>tf', '<cmd>NvimTreeFindFile<cr>', { desc = 'nvim-tree find file' })
end

function M.project()
    require('project_nvim').setup {
        exclude_dirs = { "~/.local/share/cargo/*" },
        scope_chdir = 'global'
    }
	local ts = require('telescope')
    ts.load_extension('projects')
    vim.keymap.set('n', '<Leader>ffp', ts.extensions.projects.projects, { desc = 'telescope :: projects' })
end

function M.telescope()
    local ts = require 'telescope'
    ts.setup {
        extensions = {
            file_browser = {
                hijack_netrw = false,
            },
            project = {
                sync_with_nvim_tree = true
            }
        }
    }
    -- keymaps
    local tsb = require 'telescope.builtin'
    local tst = require 'telescope.themes'

    -- files
    vim.keymap.set('n', '<Leader>fff', tsb.find_files, { desc = 'tsb.find_files' })
    vim.keymap.set('n', '<Leader>ffi', tsb.git_files, { desc = 'tsb.git_files' })
    -- vim.keymap.set('n', '<Leader>ffb', tsb.file_browser, {desc = 'tsb.file_browser'})
    vim.keymap.set('n', '<Leader>ffr', tsb.oldfiles, { desc = 'tsb.oldfiles' })
    vim.keymap.set('n', '<Leader>ffg', tsb.live_grep, { desc = 'tsb.live_grep' })

    -- buffer
    vim.keymap.set('n', '<Leader>fbf', tsb.current_buffer_fuzzy_find, { desc = 'tsb.current_buffer_fuzzy_find' })

    -- commands
    vim.keymap.set('n', '<Leader>fcc', tsb.commands, { desc = 'tsb.commands' })
    vim.keymap.set('n', '<Leader>fch', tsb.command_history, { desc = 'tsb.command_history' })

    -- help
    vim.keymap.set('n', '<Leader>fhm', tsb.man_pages, { desc = 'tsb.man_pages' })

    -- nvim meta
    vim.keymap.set('n', '<Leader>fvh', tsb.help_tags, { desc = 'tsb.help_tags' })
    vim.keymap.set('n', '<Leader>fvc', tsb.colorscheme, { desc = 'tsb.colorscheme' })
    vim.keymap.set('n', '<Leader>fvb', tsb.buffers, { desc = 'tsb.buffers' })
    vim.keymap.set('n', '<Leader>fvo', tsb.vim_options, { desc = 'tsb.vim_options' })
    vim.keymap.set('n', '<Leader>fvr', tsb.registers, { desc = 'tsb.registers' })
    vim.keymap.set('n', '<Leader>fva', tsb.autocommands, { desc = 'tsb.autocommands' })
    vim.keymap.set('n', '<Leader>fvk', tsb.keymaps, { desc = 'tsb.keymaps' })

    -- lsp
    vim.keymap.set('n', '<Leader>fla', function() tsb.lsp_code_actions(tst.get_cursor()) end,
        { desc = 'tsb.lsp_code_actions(tst.get_cursor())' })
    vim.keymap.set('n', '<Leader>flr', function() tsb.lsp_references(tst.get_cursor()) end,
        { desc = 'tsb.lsp_references(tst.get_cursor())' })
    vim.keymap.set('n', '<Leader>fld', function() tsb.lsp_definitions(tst.get_cursor()) end,
        { desc = 'tsb.lsp_definitions(tst.get_cursor())' })
    vim.keymap.set('n', '<Leader>flt', function() tsb.lsp_type_definitions(tst.get_cursor()) end,
        { desc = 'tsb.lsp_type_definitions(tst.get_cursor())' })
    vim.keymap.set('n', '<Leader>fli', function() tsb.lsp_implementations(tst.get_cursor()) end,
        { desc = 'tsb.lsp_implementations(tst.get_cursor())' })
    -- vim.keymap.set('n', '<Leader>flo', tsb.lsp_document_diagnostics, {desc = 'tsb.lsp_document_diagnostics'})
    -- vim.keymap.set('n', '<Leader>flw', tsb.lsp_workspace_diagnostics, {desc = 'tsb.lsp_workspace_diagnostics'})

    -- git
    vim.keymap.set('n', '<Leader>fgc', tsb.git_commits, { desc = 'tsb.git_commits' })
    vim.keymap.set('n', '<Leader>fgb', tsb.git_branches, { desc = 'tsb.git_branches' })
    vim.keymap.set('n', '<Leader>fgs', tsb.git_status, { desc = 'tsb.git_status' })

end

function M.telescope_file_browser()
	local ts = require('telescope')
    ts.load_extension('file_browser')
    vim.keymap.set('n', '<Leader>ffb', ts.extensions.file_browser.file_browser, { desc = 'telescope :: file browser' })
end

function M.telescope_fzf_native()
    require 'telescope'.load_extension('fzf')
end

function M.telescope_project()
    require 'telescope'.load_extension('project')
end

return M
