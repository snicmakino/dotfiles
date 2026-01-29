local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- 基本設定を読み込む
require("config.options")

-- プラグインを読み込む
require("lazy").setup("plugins")

require("config.keymaps")

-- LSP設定を読み込む
require("config.lsp")

