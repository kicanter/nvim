-- Show current line number and relative line numbers
vim.opt.nu = true
vim.opt.relativenumber = true

-- Disable mouse mode
vim.opt.mouse = ""

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Enable break indent
vim.opt.breakindent = true

-- Set cursor style to default
vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50,a:Cursor/lCursor"

-- Tab settings
vim.opt.tabstop = 4 -- Defines column multiple used to display tab character
vim.opt.softtabstop = 4 -- Number of spaces a tab counts for when performing editing operations
vim.opt.shiftwidth = 4 -- Number of columns that make up one level of (auto)indentation
vim.opt.expandtab = true -- Use appropriate number of spaces to insert a tab
vim.opt.smartindent = true -- Smart indent with brackets and certain keywords

-- Buffer settings
vim.opt.undofile = true -- Save undo history
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir" -- Set directory(ies) for undo files
vim.opt.swapfile = false -- Do not use a swapfile for the buffer
vim.opt.backup = false -- Do not keep the backup file that's created when overwriting a file
vim.opt.isfname:append("@-@") -- Allow "@" symbol in filenames
-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s)
vim.opt.confirm = true

-- Search settings
vim.opt.hlsearch = false -- Do not show previous search pattern matches
vim.opt.incsearch = true -- Show where the search pattern matches as it's being typed
vim.opt.inccommand = "split" -- Preview substitutions live, as you type!

-- Visual settings
vim.opt.scrolloff = 8 -- Minimal number of screen lines to keep above and below the cursor.
vim.opt.signcolumn = "yes" -- Keep signcolumn on by default

-- Disable line wrapping
vim.opt.wrap = false
vim.opt.linebreak = true -- if wrapping is on, break at whitespace, not character

-- Set column to break text at when formatting with `gw`
vim.opt.textwidth = 120

-- Rulers
vim.opt.colorcolumn = "80,100,120" -- Set column ruler
local normal_bg = vim.api.nvim_get_hl(0, { name = "CursorLine" }).bg
vim.api.nvim_set_hl(0, "ColorColumn", { bg = normal_bg }) -- Set ruler color to cursor line background

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- Decrease update time
vim.opt.updatetime = 200

-- Decrease mapped sequence wait time
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Enable 24-bit RGB color in the terminal UI
vim.opt.termguicolors = true

-- Allow cursor to move where there is no text in visual block mode
vim.opt.virtualedit = "block"

-- Enable ui2 from 0.12
require("vim._core.ui2").enable()
