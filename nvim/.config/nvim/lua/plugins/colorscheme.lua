local colorschemes = {
    {
        "NLKNguyen/papercolor-theme",
        priority = 1000,
        config = function()
            vim.cmd([[
                set t_Co=256
                set background=light
                colorscheme PaperColor
            ]])
        end,
    },
    {
        "bluz71/vim-nightfly-guicolors",
        priority = 1000,
        config = function()
            vim.cmd([[
                colorscheme nightfly
                highlight NvimTreeFolderArrowClosed guifg=#3FC5FF
                highlight NvimTreeFolderArrowOpen guifg=#3FC5FF
                ]])
        end,
    },
    {
        "catppuccin/nvim",
        priority = 1000,
        config = function()
            vim.cmd.colorscheme "catppuccin"
        end,
    },
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
        config = function()
            vim.cmd([[
                colorscheme tokyonight
                highlight BufferTabpageFill guibg=NONE
                highlight NvimTreeIndentMarker guifg=blue
                highlight NvimTreeFolderArrowClosed guifg=blue
                highlight NvimTreeFolderArrowOpen guifg=blue
                highlight WinSeparator guifg=blue
                ]])

            -- highlight SignColumn guibg=NONE
            -- highlight DiagnosticError guibg=NONE
            -- highlight DiagnosticWarn guibg=NONE
            -- highlight DiagnosticInfo guibg=NONE
            -- highlight DiagnosticHint guibg=NONE
            -- highlight DiagnosticOk guibg=NONE
            -- highlight DiagnosticFloatingError guibg=NONE
            -- highlight DiagnosticFloatingWarn guibg=NONE
            -- highlight DiagnosticFloatingInfo guibg=NONE
            -- highlight DiagnosticFloatingHint guibg=NONE
            -- highlight DiagnosticFloatingOk guibg=NONE
            --
        end
    },
    {
        "navarasu/onedark.nvim",
        name = "onedark",
        config = function()
            vim.cmd(
                "colorscheme onedark")
        end,
    },
    {
        "Mofiqul/dracula.nvim",
        name = "dracula",
        config = function()
            vim.cmd("colorscheme dracula")
        end,
    },
    {
        "shaunsingh/nord.nvim",
        name = "nord",
        config = function()
            vim.g.nord_contrast = true
            vim.g.nord_borders = true
            vim.g.nord_disable_background = false
            vim.g.nord_italic = false
            vim.g.nord_uniform_diff_background = true
            vim.g.nord_bold = true
            vim.cmd("colorscheme nord")
        end,
    },
}

return {
    colorschemes[2], -- main theme
}
