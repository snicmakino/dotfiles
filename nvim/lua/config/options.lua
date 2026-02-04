local opt = vim.opt

-- 行番号
opt.number = true
opt.relativenumber = true

-- タブ・インデント
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true

-- 検索
opt.ignorecase = true
opt.smartcase = true

-- 見た目
opt.termguicolors = true
opt.signcolumn = "yes"
opt.cursorline = true

-- クリップボード連携
opt.clipboard = "unnamedplus"
