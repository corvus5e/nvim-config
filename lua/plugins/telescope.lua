return {

-- Fuzzy finder (used by telescope)
{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

-- Telescope
{ 'nvim-telescope/telescope.nvim', tag = '0.1.8',
	dependencies = { 'nvim-lua/plenary.nvim' },
	config = function()
		-- Enable Telescope extensions if they are installed
		pcall(require('telescope').load_extension, 'fzf')

		-- Make Pickers full screen
		require('telescope').setup{
			defaults = {
				layout_strategy = 'horizontal',--'vertical',
				layout_config = { height = 0.99, width = 0.99 },
			},
		}

		local builtin = require('telescope.builtin')
		local action_state = require('telescope.actions.state')
		local actions = require('telescope.actions')

		--- Overriding telescope pickers behavior. Key mappings to delete opened buffer
		--- Thanks Jose Garcia: https://medium.com/@jogarcia/delete-buffers-on-telescope-21cc4cf61b63
		local buffer_picker
		buffer_picker = function()
			builtin.buffers {
				sort_mru = true,
				show_all_buffers = true,
				attach_mappings = function(prompt_bufnr, map)
					local refresh_buffer_searcher = function()
						actions.close(prompt_bufnr)
						vim.schedule(buffer_picker)
					end
					local delete_buf = function()
						local selection = action_state.get_selected_entry()
						vim.api.nvim_buf_delete(selection.bufnr, { force = true })
						refresh_buffer_searcher()
					end
					map('n', '<C-d>', delete_buf)
					map('i', '<C-d>', delete_buf)
					return true
				end
			}
		end

		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Telescope [S]earch [F]iles' })
		vim.keymap.set('n', '<leader><leader>', buffer_picker, { desc = 'Telescope find buffers' })
		vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Telescope [S]earch grep' })
		vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
		vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
		vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = '[S]earch [M]arks' })

		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set('n', '<leader>sn', function()
			builtin.find_files { cwd = vim.fn.stdpath 'config' }
		end, { desc = '[S]earch [N]eovim files' })
	end
},

}
