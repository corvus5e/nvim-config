return {
	"lewis6991/gitsigns.nvim",

	opts = {
		signs = {
			add = { text = '+' },
			change = { text = '~' },
			delete = { text = '_' },
			topdelete = { text = '‾' },
			changedelete = { text = '~' },
		},
		signcolumn = true,
		linehl = false,

		on_attach = function(bufnr)
			local gitsigns = require('gitsigns')
	
			local function map(mode, l, r, opt)
				opts = opts or {}
				opts.buffer = bufnr
				vim.keymap.set(mode, l, r, opts)
			end
	
			map('n', ']c', function()
				 if vim.wo.diff then
				 	vim.cmd.normal({']c', bang = true})
				 else
				 	gitsigns.nav_hunk('next')
				 end
			end)
	
			map('n', '[c', function()
				if vim.wo.diff then
					vim.cmd.normal({'[c', bang = true})
				else
					gitsigns.nav_hunk('prev')
				end
			end)

			local base_is_head1 = false
			local function toggle_base_prev_commit()
			  if base_is_head1 then
			    gitsigns.change_base(nil, true) -- Reset to default (index)
			    print("Gitsigns: Base reset to Index")
			  else
			    gitsigns.change_base('HEAD~1', true) -- Set to previous commit
			    print("Gitsigns: Base set to HEAD~1")
			  end
			  base_is_head1 = not base_is_head1
			end

			-- Map it to a key
			vim.keymap.set('n', '<leader>hb', toggle_base_prev_commit, { desc = "Toggle signs against prev commit" })
		end
	},
}
