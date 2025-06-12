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

vim.api.nvim_set_keymap(
    "n",
    "<leader>Wl",
    [[<cmd>lua require('core.workspaces').pick_workspace()<CR>]],
    { noremap = true, silent = true, desc = "Pick Workspace" }
)

vim.api.nvim_set_keymap(
    "n",
    "<leader>Wd",
    [[<cmd>lua require('core.workspaces').pick_delworkspace()<CR>]],
    { noremap = true, silent = true, desc = "Delete Workspace" }
)

vim.api.nvim_set_keymap(
    "n",
    "<leader>WD",
    [[<cmd>lua require('core.workspaces').delete_unused_workspace()<CR>]],
    { noremap = true, silent = true, desc = "Delete Workspace" }
)
