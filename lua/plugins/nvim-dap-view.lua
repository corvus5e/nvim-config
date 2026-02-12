return {
        "igorlfs/nvim-dap-view",
        ---@module 'dap-view'
        ---@type dapview.Config
        opts = {
		winbar = {
        		show = true,
			sections = { "scopes", "exceptions", "breakpoints", "threads", "repl", "console", "watches"},
			default_section = "scopes",
		},

		auto_toggle = true,
	},
}
