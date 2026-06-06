return {
    'stevearc/overseer.nvim',
    ---@module 'overseer'
    ---@type overseer.SetupOpts
    opts = {},
    config = function()
        require("overseer").setup({
		-- 1. Define a custom action
		  actions = {
		    ["Open Tab and Close Window"] = {
		      desc = "Open task output in a new tab and close the overseer sidebar",
		      run = function(task)
		        require("overseer").close()  -- Closes the Overseer window
		        task:open_output("tab")      -- Opens the log in a new tab
                        -- (\c makes it case-insensitive, so it catches error, Error, and ERROR)
                        vim.fn.setreg('/', [[\Cerror:]])
                        vim.cmd('set hlsearch')
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
			["<C-t>"] = { "keymap.run_action", 
				opts = { action = "Open Tab and Close Window" }, 
		        	desc = "Open tab and close list" 
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

        -- Streamlined keymap (removed the redundant leading colon)
        vim.keymap.set('n', '<leader>or', '<cmd>OverseerRun<cr>', { desc = '[O]verseer [R]un' })
        vim.keymap.set('n', '<leader>ot', '<cmd>OverseerToggle<cr>', { desc = '[O]verseer [T]oggle' })
        vim.keymap.set('n', '<leader>b', '<cmd>OverseerRun Build<cr>', { desc = 'Overseer Run [B]uild task' })
    end
}
