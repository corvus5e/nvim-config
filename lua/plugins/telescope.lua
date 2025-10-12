return {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',

	dependencies = { 'nvim-lua/plenary.nvim',
	{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }},

	config = function()
		-- Enable Telescope extensions if they are installed
		pcall(require('telescope').load_extension, 'fzf')

		local actions = require('telescope.actions')

		-- Make Pickers full screen
		require('telescope').setup{
			defaults = {
				layout_strategy = 'horizontal',
				layout_config = { height = 0.99, width = 0.99 },
			},
			-- Map <C-d> to delete buffer without closing telescope
			pickers = {
				buffers = {
					mappings = {
						i = {
							["<C-d>"] = actions.delete_buffer + actions.move_to_top,
						}
					}
				}
			}
		}

		local builtin = require('telescope.builtin')
		local action_state = require('telescope.actions.state')

		local builtin = require('telescope.builtin')
		vim.keymap.set('n', '<leader>sf', builtin.find_files, { desc = 'Telescope [S]earch [F]iles' })
		vim.keymap.set('n', '<leader><leader>', builtin.buffers, { desc = 'Telescope find buffers' })
		vim.keymap.set('n', '<leader>sg', builtin.live_grep, { desc = 'Telescope [S]earch grep' })
		vim.keymap.set('n', '<leader>sr', builtin.resume, { desc = '[S]earch [R]esume' })
		vim.keymap.set('n', '<leader>sw', builtin.grep_string, { desc = '[S]earch current [W]ord' })
		vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = '[S]earch [M]arks' })

		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set('n', '<leader>sn', function()
			builtin.find_files { cwd = vim.fn.stdpath 'config' }
		end, { desc = '[S]earch [N]eovim files' })
	end
}
