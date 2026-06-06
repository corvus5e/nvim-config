return {
	'nvim-telescope/telescope.nvim', tag = '0.1.8',

	dependencies = { 'nvim-lua/plenary.nvim',
		{ 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
		{ 'nvim-telescope/telescope-ui-select.nvim' }
	},

	config = function()
		-- Enable Telescope extensions if they are installed
		pcall(require('telescope').load_extension, 'fzf')
		pcall(require('telescope').load_extension, 'ui-select')

		local actions = require('telescope.actions')

		-- Make Pickers full screen
		require('telescope').setup{
			defaults = {
				layout_strategy = 'horizontal',
				layout_config = { height = 0.99, width = 0.99 },
				border = true,
				winblend = 10,
				cache_picker = {
      					num_pickers = 5, -- Keep the last 5 pickers in memory
    				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown {
						-- You can use your global full-screen template or force specific layouts
						layout_strategy = 'horizontal',
						layout_config = { height = 0.99, width = 0.99 },
					}
				}
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
		vim.keymap.set('n', '<leader>r', builtin.registers, { desc = '[R]egisters' })
		--vim.keymap.set('n', '<leader>sm', builtin.marks, { desc = '[S]earch [M]arks' })

		local function resume_picker(target_title)
		    return function()
		        local builtin = require('telescope.builtin')
		        local state = require('telescope.state')
		        local cached_pickers = state.get_global_key('cached_pickers') or {}
		
		        -- Loop backwards through cache to find the most recent matching picker
		        for i = 1, #cached_pickers do
		            if cached_pickers[i].prompt_title == target_title then
		                builtin.resume({ cache_index = i })
		                return
		            end
		        end
		
		        -- Fallback: If no cache exists for it, just open a fresh one
		        if target_title == "Find Files" then
		            builtin.find_files()
		        elseif target_title == "Live Grep" then
		            builtin.live_grep()
		        end
		    end
		end

		-- Resume Separate Pickers (Matches the titles exact string)
		vim.keymap.set('n', '<leader>sF', resume_picker("Find Files"), { desc = "Resume Last Find Files" })
		vim.keymap.set('n', '<leader>sG', resume_picker("Live Grep"), { desc = "Resume Last Live Grep" })

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
