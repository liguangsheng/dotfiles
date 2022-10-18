local opt = vim.opt
local cmd = vim.cmd
local TABWIDTH = 4

opt.background = "light"
opt.clipboard:append("unnamed,unnamedplus")
opt.cursorline = true
opt.expandtab = true
opt.fileencoding = "UTF-8"
opt.mouse = "a"
opt.number = true
opt.relativenumber = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.signcolumn = "yes"
opt.smartindent = true
opt.softtabstop = TABWIDTH
opt.tabstop = TABWIDTH
opt.shiftwidth = TABWIDTH

vim.g.encoding = "UTF-8"
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.keymap.set('n', '<leader>w|', ':vs<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>w-', ':hs<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>ww', '<C-W>', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>wn', '<C-W>w', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>wp', '<C-W>p', { noremap = true, silent = true })
vim.keymap.set('n', '<leader>fI', ':e $MYVIMRC<CR>')

-- 复制之后高亮复制的块
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = vim.api.nvim_create_augroup('YankHighlight', { clear = true }),
    pattern = '*',
})

-- formatting
vim.keymap.set({ "n", "v" }, "<leader>mp", function()
    -- format with lsp
    local clients = vim.lsp.get_clients()
    if next(clients) ~= nil then
        vim.notify("format buffer with lsp", vim.log.levels.INFO)
        vim.lsp.buf.format()
        return
    end

    -- indent with gg=G
    vim.notify("format buffer with gg=G", vim.log.levels.INFO)
    local save_cursor = vim.api.nvim_win_get_cursor(0)
    vim.api.nvim_command('normal gg=G')
    vim.api.nvim_win_set_cursor(0, save_cursor)
end)


-- gui settings
if vim.fn.has("gui_running") == 1 then
    vim.opt.guifont = "MonaspiceNe Nerd Font Mono:h10"
end
