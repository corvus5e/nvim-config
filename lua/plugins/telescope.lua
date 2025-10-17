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
				border = true,
				winblend = 10,
			},
			-- Map <C-d> to delete buffer without closing telescope
			pickers = {
				buffers = {
					sort_mru = true,
					mappings = {
						i = {
							["<C-d>"] = actions.delete_buffer + actions.move_to_bottom,
						}
					}
				},
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
		--vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = '[S]earch [M]arks' })

		-- Shortcut for searching your Neovim configuration files
		vim.keymap.set('n', '<leader>sn', function()
			builtin.find_files { cwd = vim.fn.stdpath 'config' }
		end, { desc = '[S]earch [N]eovim files' })

		-- Custom marks picker
		-- TODO: Revise 
		-- https://github.com/nvim-telescope/telescope.nvim/blob/master/developers.md?utm_source=chatgpt.com
		local pickers = require('telescope.pickers')
		local finders = require('telescope.finders')
		local conf = require('telescope.config').values
		local entry_display = require('telescope.pickers.entry_display')
		
		local function marks_entry_maker(opts)
			opts = opts or {}
			local displayer = entry_display.create({
				separator = " ",
				items = {
					{ width = 5 },  -- custom filename width
					{ width = 6 },
					{ width = 6 },
					{ remaining = true},
				},
			})
		
			local make_display = function(entry)
				return displayer({
				  entry.value,
				  entry.lnum,
				  entry.col,
				  vim.fn.fnamemodify(entry.filename, ":t"),
			  })
			end
		
			return function(entry)
				return {
					value = entry.mark,
					ordinal = entry.mark,
					display = make_display,
					filename = entry.file,
					lnum = entry.pos[2],
					col = entry.pos[3],
					text = "Mark text",
				}
			end
		end
		
		local function custom_marks()
			local marks = vim.fn.getmarklist()
			pickers.new({}, {
				prompt_title = 'Short Marks',
				finder = finders.new_table({
					results = marks,
					entry_maker = marks_entry_maker(),
				}),
				sorter = conf.generic_sorter({}),
			}):find()
		end

		vim.keymap.set('n', '<leader>sm', custom_marks, { desc = 'Custom marks picker' })

	end
}
