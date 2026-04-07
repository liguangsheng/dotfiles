return {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = { "markdown", "Avante" },
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons",
    },
    keys = {
        { "<leader>mr", "<cmd>RenderMarkdown toggle<cr>", desc = "Toggle render markdown" },
    },
    opts = {},
}
