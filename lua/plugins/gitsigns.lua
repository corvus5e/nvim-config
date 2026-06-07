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
			map('n', '<leader>gp', gitsigns.preview_hunk_inline)

			vim.api.nvim_create_user_command('GitsignChangeBase', function(opts)
				local gs = package.loaded.gitsigns
				if not gs then
					vim.notify("Gitsigns not loaded", vim.log.levels.ERROR)
			    		return
			    	end
			
				local arg = tonumber(opts.args)
				local base

				-- Check if arg exists and is greater than 0
				if arg and arg > 0 then
					base = "HEAD~" .. arg
				else
					-- Default to index (nil usually points to index in gitsigns)
					base = nil 
				end
		
				gs.change_base(base, true)
		
				local message = base and ("Base changed to " .. base) or "Base changed to index"
				vim.notify(message, vim.log.levels.INFO)
			end, {
				nargs = '?', -- Allows 0 or 1 argument
				desc = 'Change gitsigns base to HEAD~n or index'
			})
		end
	}
}
