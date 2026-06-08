vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.g.have_nerd_font = true
vim.opt.termguicolors = true
-- vim.opt.clipboard = "unnamedplus" -- sync yank/delete with system clipboard

vim.opt.ruler = true       -- show position of cursor
vim.opt.laststatus = 0     -- status line, 0 - don't show
vim.opt.sidescrolloff = 10 -- keep 10 lines at left/right when scrolling
vim.opt.scrolloff = 10     -- keep 10 lines at top/bottom when scrolling
vim.opt.wrap = false       -- do not wrap long lines

vim.opt.list = true        -- show blanks
vim.opt.listchars = { tab = '» ', trail = '.', nbsp = '␣' } -- show blanks as

vim.opt.tabstop = 8
vim.opt.shiftwidth = 8

-- Key mappings
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>', {desc = 'stop highlight search results on <Esc>'})
vim.keymap.set('n', '<C-n>', '<cmd>:Lexplore<CR>', {desc = 'open file explore as left split'})
vim.keymap.set('n', '<Tab>', '<cmd>:tabnext<CR>', {desc = 'go to next tab'})
vim.keymap.set('n', '<S-Tab>', '<cmd>:tabprevious<CR>', { desc = 'go to previous tab'})
vim.keymap.set('n', '<C-t>', '<cmd>:tabnew<CR><BAR><cmd>:term<CR>', { desc = 'open terminal in new tab'})
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })
vim.keymap.set('n', '<leader>ts', '<cmd>set spell! spelllang=en_us<CR>', {desc = 'Spell on/off'})
vim.keymap.set('n', '*', function()
	local cword = vim.fn.expand('<cword>')
	return ':%s/' .. cword .. '//gn<CR>``'
end, { expr = true, noremap = true, desc = 'Count occurrences of word under cursor' })

vim.keymap.set('n', '#', function()
	local cword = vim.fn.expand('<cword>')
	return '/\\<' .. cword .. '\\><CR>'
end, { expr = true, noremap = true, desc = 'Count exact occurrences of word under cursor' })

-- Customize diagnostics window, Vibe-coded wiht Gemini
local function open_clean_loclist()
  local diagnostics = vim.diagnostic.get(0)
  local items = {}

  local severity_map = {
    [vim.diagnostic.severity.ERROR] = "[E]",
    [vim.diagnostic.severity.WARN]  = "[W]",
    [vim.diagnostic.severity.INFO]  = "[I]",
    [vim.diagnostic.severity.HINT]  = "[H]",
  }

  for _, d in ipairs(diagnostics) do
    local label = severity_map[d.severity] or "[?]"
    table.insert(items, {
      bufnr = d.bufnr,
      lnum = d.lnum + 1,
      col = d.col + 1,
      text = string.format("%s%d: %s", label, d.lnum + 1, d.message),
      type = label:sub(2,2),
    })
  end

  -- We define the formatter separately to handle the 'nil' edge case
  local function clean_formatter(info)
    -- Fetch the specific list being rendered
    local list = vim.fn.getloclist(0, { id = info.id, items = 1 })
    if not list.items or #list.items == 0 then return {} end

    local res = {}
    for i = info.start_idx, info.end_idx do
      -- Added a safety check here to prevent the 'nil' error
      local item = list.items[i]
      if item then
        table.insert(res, item.text)
      else
        table.insert(res, "")
      end
    end
    return res
  end

  -- Pass the function directly
  vim.fn.setloclist(0, {}, ' ', {
    title = "Buffer Diagnostics",
    items = items,
    quickfixtextfunc = clean_formatter
  })

  vim.cmd("lopen")
  -- Apply custom colors to the [E] and [W] prefixes
  vim.fn.matchadd("DiagnosticError", "^\\[E\\].*")
  vim.fn.matchadd("DiagnosticWarn",  "^\\[W\\].*")
  vim.fn.matchadd("DiagnosticInfo",  "^\\[I\\].*")
  vim.fn.matchadd("DiagnosticHint",  "^\\[H\\].*")
end

-- LSP key mappings
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		vim.keymap.set('i', '<C-Space>','<C-x><C-o>', { desc = 'Trigger completion' })
		vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = '[C]ode [A]ction' })
		vim.keymap.set('n', '<leader>cf', vim.lsp.buf.format, { desc = '[C]ode [F]ormat' })
		vim.keymap.set('v', '<leader>cf', vim.lsp.buf.format, { desc = '[C]ode [F]ormat' })
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = '[R]e[N]ame' })
		vim.keymap.set('n', '<leader>D', open_clean_loclist, { desc = 'Open [D]iagnostic list' })
		--vim.keymap.set('n', '<leader>D', vim.diagnostic.setloclist, { desc = 'Open [D]iagnostic list' })
		vim.keymap.set('n', '<leader>d', vim.diagnostic.open_float,{ desc = 'Open [d]iagnostic under cursor' })
		vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = '[G]o to [D]eclaration' })
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = '[G]o to [D]eclaration' })
		vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = '[G]o to [I]mplementation' })
		vim.keymap.set('n', 'gT', vim.lsp.buf.type_definition, { desc = '[G]o to [T]ype definition' })
		vim.keymap.set('n', 'grr', vim.lsp.buf.references, { desc = '[G]o to [R]efe[R]ences' })
		vim.keymap.set('n', 'K',  vim.lsp.buf.hover, { desc = '[G]o to [R]efe[R]ences' })

		vim.keymap.set('n', '<leader>td', function()
		    local current_setting = vim.diagnostic.config().signs
		    vim.diagnostic.config({ signs = not current_setting })
		    print("Diagnostic signs: " .. (current_setting and "OFF" or "ON"))
		end, { desc = "Toggle Diagnostic Signs" })
	end
})

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Load Lazy plugins
require("config.lazy")

-- Do things after plugins are loaded
vim.lsp.enable('clangd')

