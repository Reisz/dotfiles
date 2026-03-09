-- Line numbering
vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.cursorline = true

-- Indentation
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

vim.opt.expandtab = true
vim.opt.smartindent = true

-- Folding
vim.opt.foldlevelstart = 99

-- Buffer view
vim.opt.wrap = false
vim.opt.scrolloff = 8

-- Autosaving
vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.undodir = (os.getenv "HOME" or os.getenv "UserProfile") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.updatetime = 50

-- Spellchecking
vim.opt.spelllang = "en_us"
vim.opt.spelloptions = "camel"
vim.opt.spell = true

-- Search
vim.opt.hlsearch = false
vim.opt.incsearch = true

-- Ui
vim.opt.mouse = ""
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.wildmode = "longest:full"

-- Diffs
vim.opt.diffopt = "internal,filler,closeoff,iwhiteall,algorithm:histogram"

-- Local config
vim.opt.exrc = true

-- Keymap
vim.g.mapleader = " "
vim.g.maplocalleader = " "
