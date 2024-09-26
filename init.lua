---
--- This is sandbox replica of https://github.com/nvim-lua/kickstart.nvim
--- Just tinkering with nvim 
---

---
-- VIM OPTs ---
---

-- vim.opt.shell = '"C:/Program Files/Git/bin/bash.exe"' 
-- vim.opt.shellcmdflag = '-c'
-- vim.opt.shellquote = "\""

-- Make sure to setup `mapleader` and `maplocalleader` before
-- loading lazy.nvim so that mappings are correct.
-- This is also a good place to setup other settings (vim.opt)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

--- Turn relative number option on
vim.opt.number = true
vim.opt.relativenumber = true


-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = 'a'

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Keep signcolumn on by default
vim.opt.signcolumn = 'yes'

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4

-- To paste without inserting unned comment symbols 
vim.opt.formatoptions:remove('ro')

---
-- KEY MAPS ---
---
---
-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- OTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

--- Keymap to open terminal in bottom split
vim.keymap.set('n', '<C-t>', '<cmd>:sp<CR><BAR><cmd>:term<CR>')

-- Keybinds to make split navigation easier.
--  Use CTRL+<hjkl> to switch between windows
--  See `:help wincmd` for a list of all window commands
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

--- Keymaps for resizing split views
vim.keymap.set('n', '<C-Up>', '<cmd>resize +1<CR>')
vim.keymap.set('n', '<C-Down>', '<cmd>resize -1<CR>')
vim.keymap.set('n', '<C-Right>', '<cmd>vertical resize +1<CR>')
vim.keymap.set('n', '<C-Left>', '<cmd>vertical resize -1<CR>')

--- Keymaps to open terminal
vim.keymap.set('n', '<C-n>', '<cmd>:Lexplore<CR><BAR><cmd>:vertical resize 35<CR>')

--- Keymaps for tabs switching 
vim.keymap.set('n', '<Tab>', '<cmd>:tabn<CR>')
vim.keymap.set('n', '<S-Tab>', '<cmd>:tabp<CR>')
---
--- AUTOCOMMANDS ---
---

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

-- Setting formatoptions for every opened buffer (avoids pasting unneded comments)
vim.cmd([[autocmd BufEnter * set formatoptions-=ro]])

-- Using Lazy.Nvim plugin manager
require("bootstrap.lazy")

