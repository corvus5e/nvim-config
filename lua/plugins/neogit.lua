return {
	"NeogitOrg/neogit",

	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim",-- optional - Diff integration
		"nvim-tree/nvim-web-devicons",
	},

	config = function()
		local neogit = require("neogit")
		neogit.setup {
			commit_view = {
				kind = "split"
			}
		}
	end
}
