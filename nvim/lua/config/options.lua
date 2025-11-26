-- Editor options (similar to old vimrc)

local opt = vim.opt

-- Line numbers
opt.number = true
opt.relativenumber = true

-- Tabs & indentation
opt.tabstop = 4
opt.shiftwidth = 4
opt.softtabstop = 4
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- Line wrapping
opt.wrap = false
opt.linebreak = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Appearance
opt.termguicolors = true
opt.background = "dark"
opt.signcolumn = "yes"
opt.cursorline = true
opt.showmode = false
opt.laststatus = 3  -- Global statusline

-- Behavior
opt.hidden = true
opt.mouse = "a"
opt.splitbelow = true
opt.splitright = true
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.updatetime = 250
opt.timeoutlen = 300
opt.undofile = true
opt.swapfile = false
opt.backup = false

-- Completion
opt.completeopt = "menu,menuone,noselect"
opt.wildmode = "longest:full,full"

-- Misc
opt.clipboard = "unnamedplus"  -- Use system clipboard
opt.shortmess:append("I")  -- Disable intro message
opt.iskeyword:append("-")  -- Treat dash as part of word

-- Disable netrw (using file explorer plugin instead)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
