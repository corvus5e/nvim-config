return {
    'stevearc/overseer.nvim',
    ---@module 'overseer'
    ---@type overseer.SetupOpts
    opts = {},
    config = function()
        local overseer = require("overseer")
	overseer.setup({
		-- 1. Define a custom action
		  actions = {
		    ["Open Tab and search errors"] = {
		      desc = "Open task output in a new tab and highlights gcc errors",
		      run = function(task)
		        --require("overseer").close()  -- Closes the Overseer window
		        task:open_output("tab")      -- Opens the log in a new tab
                        -- (\c makes it case-insensitive, so it catches error, Error, and ERROR)
                        vim.fn.setreg('/', [[\Cerror:]])
                        vim.cmd('set hlsearch')
			vim.cmd('set wrap')
		      end,
		    },
		  },

            -- "job" runs commands headlessly in the background without spawning terminal splits
            strategy = "job",

            task_list = {
                direction = "bottom",
                -- bindings = {
                --     ["<CR>"] = "RunAction",
                -- },
		keymaps = {
			["<CR>"] = { "keymap.run_action", 
				opts = { action = "Open Tab and search errors" },
		        	desc = "Open tab and close list" 
			},
			["r"] = { "keymap.run_action", 
				opts = { action = "restart" },
			},
		    },
            },

            templates = { "builtin" },

            -- This is the out-of-the-box way to handle global behaviors.
            -- We inject explicit parameters into the default components to muzzle them.
            component_aliases = {
                default = {
                    "on_exit_set_status",
                    "on_complete_notify",
                    { "on_complete_dispose", require_view = { "SUCCESS", "FAILURE" } },
                    -- Force task terminal output windows to NEVER open automatically
                    { "open_output", on_start = "never", on_complete = "never", on_result = "never" },
                    -- Force Quickfix lists to NEVER pop up on output or exit
                    { "on_output_quickfix", open = false, open_on_exit = "never" },
                },
            },
        })


-- Vibecoded with Gemini, custom task completion logic
-- 1. Register a virtual component globally so it passes serialization rules safely
    package.loaded["overseer.component.user.global_error_handler"] = {
      desc = "Handles notifications and toggles UI on task completion status",
      constructor = function()
        return {
          on_complete = function(self, task, status)
            -- Using vim.notify prevents the message from being overwritten/hidden
            vim.notify("Task '" .. task.name .. "' completed: " .. status)

            -- If the task failed, execute your toggle logic
            if status == "FAILURE" then
              -- Check if the Overseer panel window is already visible
              local is_open = false
              for _, win in ipairs(vim.api.nvim_list_wins()) do
                local bufnr = vim.api.nvim_win_get_buf(win)
                if vim.bo[bufnr].filetype == "OverseerList" then
                  is_open = true
                  break
                end
              end

              -- Toggle the panel open ONLY if it is currently hidden
              if not is_open then
                vim.cmd("OverseerToggle")
              end
            end
          end,
        }
      end,
    }

    -- 2. Hook into ALL templates globally by passing 'nil' as the filter
    overseer.add_template_hook(nil, function(task_defn, util)
      util.remove_component(task_defn, "on_complete_notify")
      util.add_component(task_defn, { "user.global_error_handler" })
    end)
        vim.keymap.set('n', '<leader>tr', '<cmd>OverseerRun<cr>', { desc = 'Overseer [T]asks [R]un' })
        vim.keymap.set('n', '<leader>tt', '<cmd>OverseerToggle<cr>', { desc = 'Overseer [T]asks [T]oggle' })
        vim.keymap.set('n', '<leader>tb', '<cmd>OverseerRun Build<cr>', { desc = 'Overseer [T]asks Run [B]uild task' })
    end
}
