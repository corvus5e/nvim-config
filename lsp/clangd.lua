return {
	cmd = { 'clangd', '--clang-tidy' },
	filetypes = {'c', 'cpp', 'objc', 'objcpp', 'cuda'},
	root_makers = { '.clangd',
			'.clang-tidy',
			'.clang-format',
			'compile_commands.json',
			'compile_flags.txt',
			'configure.ac',
			'.git', },
	capabilities = {
		textDocument = {
			completion = {
				editsNearCursor = true,
			},
		},
		offsetEncoding = { 'utf-8', 'utf-16' },
	},
}
