return{
    {
        "EdenEast/nightfox.nvim",
    },
    {
        "feline-nvim/feline.nvim",
        config = function()
            vim.cmd("colorscheme nightfox")
            require('btezergil.ui.feline')
        end
    }
}
