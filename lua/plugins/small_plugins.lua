return {
	-- Gruvbox color scheme
	{'sainnhe/gruvbox-material',
	      lazy = false,
	      priority = 1000,
	      config = function()
		      vim.g.gruvbox_material_background = 'hard'
		      vim.g.gruvbox_material_foreground = 'material'
		      vim.g.gruvbox_material_enable_bold = 1
		      vim.g.gruvbox_material_enable_italic = 1
		      vim.cmd.colorscheme('gruvbox-material')
	      end
	},

	-- Git pling
	{ "NeogitOrg/neogit",
		dependencies = {
			"nvim-lua/plenary.nvim",         -- required
			"sindrets/diffview.nvim",        -- optional - Diff integration
		},
	},

}
