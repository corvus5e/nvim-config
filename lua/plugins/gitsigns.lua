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
	
		end
	},
}
