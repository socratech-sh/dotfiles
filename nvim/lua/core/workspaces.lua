local M = {}

local kv_store = require("core.kvstore")

local workspace_dir = vim.fn.expand("~/.workspace")

if vim.fn.isdirectory(workspace_dir) == 0 then
    vim.fn.mkdir(workspace_dir, "p")
end

local db = kv_store.create(workspace_dir)

local function list_files_in_dir(dir)
    local files = {}
    local p = io.popen('ls "' .. dir .. '"')
    if p then
        for file in p:lines() do
            table.insert(files, file)
        end
        p:close()
    end
    return files
end

function M.save_workspace()
    local current_path = vim.fn.getcwd()

    vim.ui.input({ prompt = "Enter workspace name: " }, function(name)
        if name == nil or name == "" then
            print("Workspace cannot be empty")
        else
            db[name] = { name = name, path = current_path }
            db:save(name)
            print("Workspace saved: " .. name .. " -> " .. current_path)
        end
    end)
end

function M.load_workspaces()
    local workspaces = {}

    local files = list_files_in_dir(workspace_dir)
    if #files == 0 then
        print("No workspaces found in the directory.")
        return workspaces
    end

    for _, file in ipairs(files) do
        local workspace_name = file
        local workspace = kv_store.load_page(workspace_dir .. "/" .. file)

        if workspace and workspace.path then
            table.insert(workspaces, { name = workspace_name, path = workspace.path })
        else
            print("Invalid workspace file:", file)
        end
    end

    return workspaces
end

function M.delete_workspace(selected_workspace)
    local workspace = selected_workspace.name
    local workspace_full = workspace_dir .. "/" .. workspace

    if vim.fn.isdirectory(workspace_dir) == 1 then
        if vim.fn.filereadable(workspace_full) == 1 then
            local result = vim.fn.delete(workspace_full)
            if result == 0 then
                print("Workspace deleted successfully.")
            else
                print("Failed to delete Workspace")
            end
        else
            print("Workspace does not exist")
        end
    else
        print("Workspace does not exist")
    end
end

function M.goto_workspace(selected_workspace)
    local workspace = selected_workspace.path
    if vim.fn.isdirectory(workspace) == 1 then
        vim.cmd("cd " .. workspace)
        require("auto-session").RestoreSession()
        require("neo-tree.sources.filesystem.commands").refresh(
            require("neo-tree.sources.manager").get_state("filesystem")
        )
        require("toggleterm").setup({ dir = workspace })
    else
        print("Workspace does not exist.")
    end
end

function M.delete_unused_workspace()
    local workspaces = M.load_workspaces()

    if #workspaces == 0 then
        print("No workspaces found.")
        return
    end

    for _, workspace in ipairs(workspaces) do
        if vim.fn.isdirectory(workspace.path) == 0 and vim.fn.filereadable(workspace.path) == 0 then
            M.delete_workspace({ name = workspace.name })
            print("Workspace " .. workspace.name .. " deleted successfully.")
        end
    end
end

function M.pick_delworkspace()
    local workspaces = M.load_workspaces()
    if #workspaces == 0 then
        print("No workspaces found.")
        return
    end

    local pick_items = {}
    local current_path = vim.fn.getcwd()
    for _, workspace in ipairs(workspaces) do
        if workspace.path ~= current_path then
            table.insert(pick_items, workspace.name .. " -> " .. workspace.path)
        end
    end

    require("telescope.pickers")
        .new({}, {
            prompt_title = "Delete Workspace",
            finder = require("telescope.finders").new_table({
                results = pick_items,
            }),
            sorter = require("telescope.config").values.generic_sorter(),
            attach_mappings = function(prompt_bufnr, map)
                map("i", "<CR>", function()
                    local selection = require("telescope.actions.state").get_selected_entry()
                    print("Selection " .. selection.value)
                    if selection then
                        require("telescope.actions").close(prompt_bufnr)
                        local workspace_name, _ = string.match(selection[1], "^(.-)%s*->")
                        workspace_name = string.gsub(workspace_name, "[/%.]", "")
                        if workspace_name and workspace_name ~= "" and workspace_name ~= "." and workspace_name ~= "-" then
                            M.delete_workspace({ name = workspace_name })
                        else
                            print("Invalid workspace selection.")
                        end
                    else
                        print("No selection made.")
                    end
                end)
                return true
            end,
        })
        :find()
end

function M.pick_workspace()
    local workspaces = M.load_workspaces()

    if #workspaces == 0 then
        print("No workspaces found.")
        return
    end

    local pick_items = {}
    local current_path = vim.fn.getcwd()
    for _, workspace in ipairs(workspaces) do
        if workspace.path ~= current_path then
            table.insert(pick_items, workspace.name .. " -> " .. workspace.path)
        end
    end

    require("telescope.pickers")
        .new({}, {
            prompt_title = "Select Workspace",
            finder = require("telescope.finders").new_table({
                results = pick_items,
            }),
            sorter = require("telescope.config").values.generic_sorter(),
            attach_mappings = function(prompt_bufnr, map)
                map("i", "<CR>", function()
                    local selection = require("telescope.actions.state").get_selected_entry()
                    if selection then
                        require("telescope.actions").close(prompt_bufnr)
                        local workspace_name, workspace_path = string.match(selection[1], "([^ ]+) -> (.+)")
                        if workspace_name and workspace_path then
                            M.goto_workspace({ name = workspace_name, path = workspace_path })
                        else
                            print("Invalid workspace selection.")
                        end
                    else
                        print("No selection made.")
                    end
                end)
                return true
            end,
        })
        :find()
end

return M
