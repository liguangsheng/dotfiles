-- [[ Basic Configuration ]],

local TABWIDTH = 4
vim.g.encoding = "UTF-8"
vim.opt.background = "dark"
vim.opt.clipboard:append("unnamed,unnamedplus")
vim.opt.cursorline = true
vim.opt.expandtab = true
vim.opt.fileencoding = "UTF-8"
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.smartindent = true
vim.opt.softtabstop = TABWIDTH
vim.opt.tabstop = TABWIDTH
vim.opt.shiftwidth = TABWIDTH

-- [[ Baisc Keymaps ]]
vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.keymap.set('n', '<leader>w|', ':vs<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>w-', ':hs<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ww', '<C-W>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>wn', '<C-W>w', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>wp', '<C-W>p', { noremap = true, silent = true })

local function format_buffer()
    if vim.lsp.buf.server_ready() then
        vim.lsp.buf.format()
    else
        -- 保存光标位置
        local save_cursor = vim.api.nvim_win_get_cursor(0)
        -- 格式化整个缓冲区
        vim.api.nvim_command('normal gg=G')
        -- 还原光标位置
        vim.api.nvim_win_set_cursor(0, save_cursor)
    end
end

vim.keymap.set('n', '<leader>fI', ':e $MYVIMRC<CR>')
vim.keymap.set('n', '<leader>=', format_buffer)

local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- [[ Plugins ]]

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)


local theme = { "navarasu/onedark.nvim", name = "onedark", config = function() vim.cmd("colorscheme onedark") end, }

-- local theme = {
--     'navarasu/onedark.nvim',
--     lazy = false,
--     priority = 1000,
--     config = function()
--         require('onedark').setup {
--             style = 'cool'
--         }
--         require('onedark').load()
--     end,
-- }

-- local theme = {
--     "olimorris/onedarkpro.nvim",
--     lazy = false,
--     priority = 1000,
--     config = function()
--         vim.cmd("colorscheme onedark_vivid")
--     end,
-- }
--
local barbecue = {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
        "SmiteshP/nvim-navic",
        "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    opts = {
        theme = 'tokyonight',
    },
}

local lualine = {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
        require('lualine').setup {
            options = {
                icons_enabled = true,
                theme = 'auto',
                component_separators = { left = '', right = '' },
                section_separators = { left = '', right = '' },
            },
        }
    end
}

local file_explorer = {
    "nvim-tree/nvim-tree.lua",
    keys = {
        {
            "<leader>ft", "<cmd>:NvimTreeToggle<CR>", desc = "NvimTree(root dir)",
        },
        { "<leader>fT", "<cmd>Neotree toggle<CR>", desc = "NeoTree (cwd)" },
    },
    init = function()
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1
        -- disable netrw at the very start of your init.lua (strongly advised)
        vim.g.loaded_netrw = 1
        vim.g.loaded_netrwPlugin = 1

        -- set termguicolors to enable highlight groups
        vim.opt.termguicolors = true
    end,
    config = {
        sort_by = "case_sensitive",
        renderer = {
            group_empty = true,
        },
        filters = {
            dotfiles = false,
        },
        sync_root_with_cwd = true,
        respect_buf_cwd = true,
        update_focused_file = {
            enable = true,
            update_root = true
        },
    },
}

local autopairs = {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = function()
        require("nvim-autopairs").setup {}
        -- config autopairs
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        local nvim_cmp = require('cmp')
        nvim_cmp.event:on(
            'confirm_done',
            cmp_autopairs.on_confirm_done()
        )
    end
}

local snippet = {
    'L3MON4D3/LuaSnip',
    event = "InsertEnter",
    dependencies = {
        'rafamadriz/friendly-snippets',
        config = function()
            require('luasnip.loaders.from_vscode').lazy_load()
        end,
    },
}

local telescope = {
    {
        'nvim-telescope/telescope.nvim',
        version = '0.1.x',
        dependencies = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('telescope').setup {
                defaults = {
                    mappings = {
                        i = {
                            ['<C-u>'] = false,
                            ['<C-d>'] = false,
                        },
                    },
                    file_ignore_patterns = { 'node_modules', '.git' },
                },
                extensions = {
                    fzf = {
                        fuzzy = true,                   -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true,    -- override the file sorter
                        case_mode = "smart_case",       -- or "ignore_case" or "respect_case"
                        -- the default case_mode is "smart_case"
                    },
                    file_browser = {
                        theme = "ivy",
                        -- disables netrw and use telescope-file-browser in its place
                        hijack_netrw = true,
                        mappings = {
                            ["i"] = {
                                -- your custom insert mode mappings
                            },
                            ["n"] = {
                                -- your custom normal mode mappings
                            },
                        },
                    },
                }
            }

            -- Enable telescope fzf native, if installed
            require('telescope').load_extension('fzf')
            require('telescope').load_extension('file_browser')
            require('telescope').load_extension('project')
        end,
        keys = {
            { '<leader>bb', function() require('telescope.builtin').buffers() end },
            { '<leader>fb', function() require("telescope").extensions.file_browser.file_browser() end },
            { '<leader>p',  function() require("telescope").extensions.project.project() {} end },
            { '<leader>ff', function() require('telescope.builtin').find_files { hidden = true } end },
            { '<leader>fg', function() require('telescope.builtin').live_grep() end },
            { '<leader>fh', function() require('telescope.builtin').help_tags() end },
            { '<leader>fr', function() require('telescope.builtin').oldfiles() end },
        },
    },
    {
        "nvim-telescope/telescope-file-browser.nvim",
        dependencies = { "nvim-telescope/telescope.nvim",
            "nvim-lua/plenary.nvim" }
    },
    { 'nvim-telescope/telescope-project.nvim' },
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make', },
}

local completion = {
    'hrsh7th/nvim-cmp',
    event = "InsertEnter",
    dependencies = { 'hrsh7th/cmp-buffer', 'hrsh7th/cmp-path', 'hrsh7th/cmp-nvim-lsp',
        'hrsh7th/cmp-nvim-lsp-signature-help',
        'L3MON4D3/LuaSnip', 'saadparwaiz1/cmp_luasnip',
    },
    config = function()
        local cmp = require 'cmp'
        local luasnip = require 'luasnip'

        cmp.setup {
            snippet = {
                expand = function(args)
                    luasnip.lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert {
                ['<C-d>'] = cmp.mapping.scroll_docs(-4),
                ['<C-f>'] = cmp.mapping.scroll_docs(4),
                ['<C-Space>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = true,
                },
                ['<Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif luasnip.expand_or_jumpable() then
                        luasnip.expand_or_jump()
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
                ['<S-Tab>'] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { 'i', 's' }),
            },
            sources = {
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
                { name = 'buffer' },
                { name = 'path' },
                { name = 'nvim_lsp_signature_help' }
            },
        }
    end
}

local lsp = {
    'neovim/nvim-lspconfig',
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        -- Automatically install LSPs to stdpath for neovim
        { 'williamboman/mason.nvim', config = true, cmd = "Mason" },
        'williamboman/mason-lspconfig.nvim',
        -- Useful status updates for LSP
        { 'j-hui/fidget.nvim',       config = true },
        -- Additional lua configuration, makes nvim stuff amazing
        { 'folke/neodev.nvim',       config = true },
        'hrsh7th/cmp-nvim-lsp',
    },
    config = function()
        -- LSP settings.
        --  This function gets run when an LSP connects to a particular buffer.
        local on_attach = function(_, bufnr)
            -- In this case, we create a function that lets us more easily define mappings specific
            -- for LSP related items. It sets the mode, buffer and description for us each time.
            local nmap = function(keys, func, desc)
                if desc then
                    desc = 'LSP: ' .. desc
                end
                vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
            end

            nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
            nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')

            nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
            nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
            nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
            nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
            nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
            nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols,
                '[W]orkspace [S]ymbols')

            -- See `:help K` for why this keymap
            nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
            nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

            -- Lesser used LSP functionality
            nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
            nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
            nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
            nmap('<leader>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end, '[W]orkspace [L]ist Folders')

            -- Create a command `:Format` local to the LSP buffer
            vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
                vim.lsp.buf.format()
            end, { desc = 'Format current buffer with LSP' })
            vim.keymap.set('n', '<Leader>f', ":Format<cr>")
        end

        -- Enable the following language servers
        local servers = {
            -- clangd = {},
            -- gopls = {},
            -- pyright = {},
            -- rust_analyzer = {},
            -- pylsp = {
            --   configurationSources = { "flake8" },
            --   plugins = {
            --     jedi_completion = {
            --       include_params = true -- this line enables snippets
            --     },
            --   },
            -- },
            -- sumneko_lua = {
            --   Lua = {
            --     workspace = { checkThirdParty = false },
            --     telemetry = { enable = false },
            --   },
            -- },
        }

        -- nvim-cmp supports additional completion capabilities, so broadcast that to servers
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

        -- Ensure the servers above are installed
        local mason_lspconfig = require 'mason-lspconfig'
        mason_lspconfig.setup {
            ensure_installed = vim.tbl_keys(servers),
        }

        mason_lspconfig.setup_handlers {
            function(server_name)
                require('lspconfig')[server_name].setup {
                    capabilities = capabilities,
                    on_attach = on_attach,
                    settings = servers[server_name],
                }
            end,
        }
    end
}

local comment = { 'numToStr/Comment.nvim', config = true }

require("lazy").setup({
    theme,
    lualine,
    comment,
    barbecue,
    file_explorer,
    telescope,
    lsp,
    autopairs,
    snippet,
    completion,
})
