return {
    "nvim-telescope/telescope.nvim",

    tag = "0.1.5",

    dependencies = {
        "nvim-lua/plenary.nvim"
    },

    config = function()
        require('telescope').setup({})

        local builtin = require('telescope.builtin')
        vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
        vim.keymap.set('n', '<leader>fg', builtin.git_files, {})
        vim.keymap.set('n', '<leader>fw', function()
            local word = vim.fn.expand("<cword>")
            builtin.grep_string({ search = word })
        end)
        vim.keymap.set("n", "<leader>fs", function()
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end)
        vim.keymap.set("n", "<leader>ft", builtin.help_tags, {})

        vim.keymap.set("n", "<leader>fd", function()
            local search_dir = vim.fn.input("Search Directory: ", "", "file")
            local command = string.format([[Telescope live_grep search_dirs={'%s'}]], search_dir)
            vim.cmd(command)
        end, { desc = "Live grep in specified directory" })

        vim.keymap.set("n", "<leader>fb", "<cmd>Telescope buffers<cr>")

    end
}
