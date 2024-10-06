function OpenTmuxVerticalPane()
    local current_path = vim.fn.getcwd()

    local command = "tmux split-window -h -c " .. current_path

    os.execute(command)
end

function OpenTmuxWindowInCurrentDirectory()
    local current_path = vim.fn.getcwd()

    local command = "tmux new-window -c " .. current_path

    os.execute(command)
end

vim.api.nvim_set_keymap("n", "<leader>tp", ":lua OpenTmuxVerticalPane()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap(
    "n",
    "<leader>tw",
    ":lua OpenTmuxWindowInCurrentDirectory()<CR>",
    { noremap = true, silent = true }
)
