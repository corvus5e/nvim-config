return {
	"mfussenegger/nvim-dap",

	config = function()
		local dap = require("dap")

		dap.defaults.fallback.terminal_win_cmd = '50vsplit new'

		vim.fn.sign_define('DapBreakpoint', {text='', texthl='DiagnosticError', linehl='', numhl='DiagnosticError'})
		vim.fn.sign_define('DapBreakpointCondition', {text='', texthl='DiagnosticError', linehl='', numhl='DiagnosticError'})
		vim.fn.sign_define('DapLogPoint', {text='', texthl='DiagnosticError', linehl='', numhl='DiagnosticError'})
		vim.fn.sign_define('DapStopped', {text='󰁕', texthl='DiagnosticInfo', linehl='Visual', numhl='DiagnosticInfo'})
		vim.fn.sign_define('DapBreakpointRejected', {text='', texthl='DiagnosticHint', linehl='', numhl='DiagnosticHint'})

		--vim.keymap.set('n', '<F5>', ':DapNew<CR>', { silent = true, desc = 'Dap New' })
		vim.keymap.set('n', '<leader>db', ':DapToggleBreakpoint<CR>', { silent = true, desc = '[T]oggle [B]reakpoint' })
		vim.keymap.set('n', '<leader>dv', ':DapViewToggle<CR>', { silent = true, desc = '[T]oggle [V]iew' })

		-- Let's give our listener a clear name
		local listener_id = "user_keymaps"
		
		-- 1. Setup listeners to turn mappings ON
		dap.listeners.after.event_initialized[listener_id] = function()
		  -- These will only exist while debugging
		  vim.keymap.set('n', '<Down>', dap.step_over, { desc = 'Step Over' })
		  vim.keymap.set('n', '<Right>', dap.step_into, { desc = 'Step Into' })
		  vim.keymap.set('n', '<Left>', dap.step_out, { desc = 'Step Out' })
		  vim.keymap.set('n', '<Up>', dap.continue, { desc = 'Continue' })
		  print("Debugger Active: Arrow keys remapped to Stepping")
		end
		
		-- 2. Setup listeners to turn mappings OFF
		local function clear_keys()
		  pcall(vim.keymap.del, 'n', '<Down>')
		  pcall(vim.keymap.del, 'n', '<Right>')
		  pcall(vim.keymap.del, 'n', '<Left>')
		  pcall(vim.keymap.del, 'n', '<Up>')
		  print("Debugger Inactive: Arrow keys restored")
		end
		
		-- We trigger the cleanup on both 'terminated' and 'exited'
		dap.listeners.before.event_terminated[listener_id] = clear_keys
		dap.listeners.before.event_exited[listener_id] = clear_keys

		dap.adapters.lldb = {
			type = "executable",
			command = "/usr/bin/lldb-dap", -- adjust as needed, must be absolute path
			name = "lldb"
		}
	end
}
