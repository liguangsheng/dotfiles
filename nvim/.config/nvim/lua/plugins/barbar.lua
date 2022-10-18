return {
    'romgrk/barbar.nvim',
    event = { "BufReadPre", "BufNewFile" },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
    dependencies = {
        'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
        'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    opts = {
        -- lazy.nvim will automatically call setup for you. put your options here, anything missing will use the default:
        animation = true,
        -- insert_at_start = true,
        -- …etc.
    },
    config = function ()

        require("barbar").setup({
            highlight_visible = false,
            icons = {
                -- Configure the base icons on the bufferline.
                -- Valid options to display the buffer index and -number are `true`, 'superscript' and 'subscript'
                buffer_index = false,
                buffer_number = false,
                button = '',
                -- Enables / disables diagnostic symbols
                diagnostics = {
                    -- [vim.diagnostic.severity.ERROR] = {enabled = true, icon = ' '},
                    -- [vim.diagnostic.severity.WARN] = {enabled = true, icon = ' '},
                    -- [vim.diagnostic.severity.INFO] = {enabled = true, icon = ' '},
                    -- [vim.diagnostic.severity.HINT] = {enabled = true},
                },
                -- gitsigns = {
                --     added = {enabled = true, icon = '+'},
                --     changed = {enabled = true, icon = '~'},
                --     deleted = {enabled = true, icon = '-'},
                -- },
                filetype = {
                    -- Sets the icon's highlight group.
                    -- If false, will use nvim-web-devicons colors
                    custom_colors = true,

                    -- Requires `nvim-web-devicons` if `true`
                    enabled = true,
                },
                separator = {left = '▎', right = ''},

                -- If true, add an additional separator at the end of the buffer list
                separator_at_end = true,

                -- Configure the icons on the bufferline when modified or pinned.
                -- Supports all the base icon options.
                modified = {button = '●'},
                pinned = {button = '', filename = true},

                -- Use a preconfigured buffer appearance— can be 'default', 'powerline', or 'slanted'
                preset = 'default',

                -- Configure the icons on the bufferline based on the visibility of a buffer.
                -- Supports all the base icon options, plus `modified` and `pinned`.
                alternate = {filetype = {enabled = false}},
                current = {buffer_index = false},
                inactive = {button = '󰒲'},
                visible = {modified = {buffer_number = false}},
            },
        })

        local keymap = require "vim.keymap"
        local opts = { noremap = true, silent = true }
        vim.cmd([[
                " For barbar
                highlight BufferTabpageFill guibg=NONE
                " highlight BufferTabpages guibg=NONE
                highlight BufferTabpagesSep guibg=NONE
                " barbar - current buffer
                highlight BufferCurrent guibg=NONE guifg=#A6E3A1
                highlight BufferCurrentADDED guibg=NONE
                highlight BufferCurrentCHANGED guibg=NONE
                highlight BufferCurrentDELETED guibg=NONE
                highlight BufferCurrentERROR guibg=NONE guifg=#F38BA8
                highlight BufferCurrentWARN guibg=NONE guifg=#F9E2AF
                highlight BufferCurrentHINT guibg=NONE guifg=#A6E3A1
                " highlight BufferCurrentIcon guibg=NONE
                highlight BufferCurrentIndex guibg=NONE
                " highlight BufferCurrentINFO guibg=NONE
                highlight BufferCurrentMod guibg=NONE guifg=#A6E3A1
                highlight BufferCurrentNumber guibg=NONE
                highlight BufferCurrentSign guibg=NONE
                highlight BufferCurrentSignRight guibg=NONE
                highlight BufferCurrentTarget guibg=NONE

                " barbar - inactive buffer
                highlight BufferInactive guibg=NONE
                highlight BufferInactiveADDED guibg=NONE
                highlight BufferInactiveCHANGED guibg=NONE
                highlight BufferInactiveDELETED guibg=NONE
                highlight BufferInactiveERROR guibg=NONE
                highlight BufferInactiveHINT guibg=NONE
                highlight BufferInactiveIcon guibg=NONE
                highlight BufferInactiveIndex guibg=NONE
                highlight BufferInactiveINFO guibg=NONE
                highlight BufferInactiveMod guibg=NONE
                highlight BufferInactiveNumber guibg=NONE
                highlight BufferInactiveSign guibg=NONE
                highlight BufferInactiveSignRight guibg=NONE
                highlight BufferInactiveTarget guibg=NONE
                highlight BufferInactiveWARN guibg=NONE

                " highlight BufferVisible          guibg=NONE
                " highlight BufferVisibleADDED     guibg=NONE
                " highlight BufferVisibleCHANGED   guibg=NONE
                " highlight BufferVisibleDELETED   guibg=NONE
                " highlight BufferVisibleERROR     guibg=NONE
                " highlight BufferVisibleHINT      guibg=NONE
                " highlight BufferVisibleIcon      guibg=NONE
                " highlight BufferVisibleIndex     guibg=NONE
                " highlight BufferVisibleINFO      guibg=NONE
                " highlight BufferVisibleMod       guibg=NONE
                " highlight BufferVisibleNumber    guibg=NONE
                " highlight BufferVisibleSign      guibg=NONE
                " highlight BufferVisibleSignRight guibg=NONE
                " highlight BufferVisibleTarget    guibg=NONE
                " highlight BufferVisibleWARN      guibg=NONE

                ]])
        -- Move to previous/next
        keymap.set('n', '<S-H>', '<Cmd>BufferPrevious<CR>', opts)
        keymap.set('n', '<S-L>', '<Cmd>BufferNext<CR>', opts)
        -- Re-order to previous/next
        keymap.set('n', '<S-B>', '<Cmd>BufferMovePrevious<CR>', opts)
        keymap.set('n', '<S-F>', '<Cmd>BufferMoveNext<CR>', opts)
        -- Goto buffer in position...
        keymap.set('n', '<A-1>', '<Cmd>BufferGoto 1<CR>', opts)
        keymap.set('n', '<A-2>', '<Cmd>BufferGoto 2<CR>', opts)
        keymap.set('n', '<A-3>', '<Cmd>BufferGoto 3<CR>', opts)
        keymap.set('n', '<A-4>', '<Cmd>BufferGoto 4<CR>', opts)
        keymap.set('n', '<A-5>', '<Cmd>BufferGoto 5<CR>', opts)
        keymap.set('n', '<A-6>', '<Cmd>BufferGoto 6<CR>', opts)
        keymap.set('n', '<A-7>', '<Cmd>BufferGoto 7<CR>', opts)
        keymap.set('n', '<A-8>', '<Cmd>BufferGoto 8<CR>', opts)
        keymap.set('n', '<A-9>', '<Cmd>BufferGoto 9<CR>', opts)
        keymap.set('n', '<A-0>', '<Cmd>BufferLast<CR>', opts)
        -- Pin/unpin buffer
        keymap.set('n', '<C-p>', '<Cmd>BufferPin<CR>', opts)
        -- Close buffer
        keymap.set('n', '<C-c>', '<Cmd>BufferCloseAllButCurrentOrPinned<CR>', opts)
        -- Wipeout buffer
        --                 :BufferWipeout
        -- Close commands
        --                 :BufferCloseAllButCurrent
        --                 :BufferCloseAllButPinned
        --                 :BufferCloseAllButCurrentOrPinned
        --                 :BufferCloseBuffersLeft
        --                 :BufferCloseBuffersRight
        -- Magic buffer-picking mode

        keymap.set('n', 'mp', '<Cmd>BufferPick<CR>', opts)
        -- Sort automatically by...

        keymap.set('n', '<Space>bb', '<Cmd>BufferOrderByBufferNumber<CR>', opts)
        keymap.set('n', '<Space>bd', '<Cmd>BufferOrderByDirectory<CR>', opts)
        keymap.set('n', '<Space>bl', '<Cmd>BufferOrderByLanguage<CR>', opts)
        keymap.set('n', '<Space>bw', '<Cmd>BufferOrderByWindowNumber<CR>', opts)
    end,
}
