return {
  "EthanJWright/vs-tasks.nvim",

  dependencies = {
    "nvim-lua/popup.nvim",
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
  },

  config = function()
        require("telescope").load_extension("vstask")
        require("vstask").setup {
                buffer_options = {},
                telescope_keys = { -- change the telescope bindings used to launch tasks
                vertical = '<C-v>',
                split = '<C-h>',
                tab = '<C-t>',
                current = '<CR>',
                background = '<C-b>',
                watch_job = '<C-w>',
                kill_job = '<C-d>',
                run = '<C-r>',
        }

        }
        local function run_vstask(task_name, direction)
                local Parse = require("vstask.Parse")
                local core = require("vstask.picker_core")

                local tasks = Parse.Tasks()
                if not tasks or #tasks == 0 then
                        vim.notify("vstasks: No tasks found in workspace", vim.log.levels.WARN)
                        return
                end

                local target_index = nil
                for idx, task in ipairs(tasks) do
                        if task.label == task_name then
                                target_index = idx
                                break
                        end
                end

                if not target_index then
                        vim.notify(string.format("vstasks: Task '%s' not found", task_name), vim.log.levels.WARN)
                        return
                end

                core.handle_direction(
                        direction or "vertical", -- "vertical", "horizontal", "current", "tab", or "background_job"
                        { index = target_index },
                        tasks,
                        false,
                        {},
                        nil,
                        "keymap"
                )
        end

        vim.keymap.set('n', '<leader>tb', function()
                run_vstask('Build', 'background_job')
        end, { desc = "Run 'Build' task" })

        vim.keymap.set('n', '<leader>tr', function()
                run_vstask('Run', 'tab')
        end, { desc = "Run 'Run' task" })

        vim.keymap.set('n', '<leader>tt', '<cmd>:Telescope vstask tasks<CR>', {desc = 'open tasks'})
        vim.keymap.set('n', '<leader>tj', '<cmd>:Telescope vstask jobs<CR>', {desc = 'open jobs'})
        vim.keymap.set('n', '<leader>tJ', '<cmd>:Telescope vstask cleanup_completed_jobs<CR>', {desc = 'clear completed jobs'})
        vim.keymap.set('n', '<leader>ti', '<cmd>:Telescope vstask inputs<CR>', {desc = 'open inputs'})
        vim.keymap.set('n', '<leader>tI', '<cmd>:Telescope vstask clear_inputs<CR>', {desc = 'clear remembered inputs'})
        vim.keymap.set('n', '<leader>tl', '<cmd>:Telescope vstask launch<CR>', {desc = 'launch picker'})

  end

}
