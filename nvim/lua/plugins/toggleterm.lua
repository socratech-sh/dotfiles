return {
    'akinsho/toggleterm.nvim',
    version = "*",
    keys = {
        { "<c-o>t",     desc = "Toggle Terminal" },
        { "<leader>zd", "<cmd>lua _lazydocker_toggle()<CR>", desc = "Lazydocker" },
        { "<leader>vG", "<cmd>lua _ghdash_toggle()<CR>",     desc = "Git Dash" },
    },
    config = function()
        local toggleterm = require("toggleterm")
        toggleterm.setup({
            size = 20,
            hide_numbers = false,
            open_mapping = [[<c-o>t]],
            shade_filetypes = {},
            shade_terminals = false,
            shading_factor = 0.1,
            start_in_insert = true,
            persist_size = true,
            direction = "horizontal",
            close_on_exit = true,
            float_opts = {
                border = "curved",
                highlights = {
                    border = "Normal",
                    background = "Normal",
                },
                title_pos = "center",
            },
        })

        function _G.set_terminal_keymaps()
            vim.keymap.set('t', '<esc>', [[<C-\><C-n>]])
        end

        local Terminal = require("toggleterm.terminal").Terminal
        local ghdash = Terminal:new({
            cmd = "gh dash",
            hidden = true,
            direction = "float",
            close_on_exit = true,
            float_opts = { width = vim.o.columns, height = vim.o.lines },
        })
        vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
    end,
}
