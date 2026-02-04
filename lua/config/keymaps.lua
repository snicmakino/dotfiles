local keymap = vim.keymap

-- リーダーキーはinit.luaで設定済み

-- ウィンドウ移動（基本操作）
keymap.set("n", "<C-h>", "<C-w>h")
keymap.set("n", "<C-j>", "<C-w>j")
keymap.set("n", "<C-k>", "<C-w>k")
keymap.set("n", "<C-l>", "<C-w>l")

-- バッファ移動（ショートカット）
keymap.set("n", "<Tab>", ":bnext<CR>")
keymap.set("n", "<S-Tab>", ":bprev<CR>")

-- ターミナル脱出
keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>:ToggleTerm<CR>")

-- which-key設定
local wk = require("which-key")


-- ノーマルモード用
wk.add({
  -- ファイル操作
  { "<leader>e",  ":Neotree toggle<CR>",           desc = "Explorer" },
  { "<leader>ef", ":Neotree reveal<CR>",           desc = "Find in tree" },

  -- Find系（Telescope）
  { "<leader>f",  group = "Find" },
  { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Files" },
  { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Grep" },
  { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Buffers" },

  -- Format
  {
    "<leader>F",
    function()
      require("conform").format({ async = true, lsp_fallback = true })
    end,
    desc = "Format"
  },

  -- Git
  { "<leader>g",  group = "Git" },
  { "<leader>gg", ":LazyGit<CR>",                                     desc = "LazyGit" },

  -- Diagnostics
  { "<leader>x",  group = "Diagnostics" },
  { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>",              desc = "All" },
  { "<leader>xd", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer" },
  { "<leader>d",  vim.diagnostic.open_float,                          desc = "Show diagnostic" },

  -- Test（大文字 - 使用頻度低）
  { "<leader>T",  group = "Test" },
  { "<leader>Tn", ":TestNearest<CR>",                                 desc = "Nearest" },
  { "<leader>Tf", ":TestFile<CR>",                                    desc = "File" },
  { "<leader>Tl", ":TestLast<CR>",                                    desc = "Last" },
  { "<leader>Ta", ":TestSuite<CR>",                                   desc = "All" },

  -- Terminal（小文字 - 使用頻度高）
  { "<leader>t",  group = "Terminal" },
  { "<leader>tt", ":ToggleTerm<CR>",                                  desc = "Toggle" },
  { "<leader>th", ":ToggleTerm direction=horizontal<CR>",             desc = "Horizontal" },
  { "<leader>tv", ":ToggleTerm direction=vertical size=80<CR>",       desc = "Vertical" },
  { "<leader>tf", ":ToggleTerm direction=float<CR>",                  desc = "Float" },
  { "<leader>t1", ":ToggleTerm 1<CR>",                                desc = "Terminal 1" },
  { "<leader>t2", ":ToggleTerm 2<CR>",                                desc = "Terminal 2" },
  { "<leader>t3", ":ToggleTerm 3<CR>",                                desc = "Terminal 3" },

  -- Buffer
  { "<leader>b",  group = "Buffer" },
  { "<leader>bd", ":bd<CR>",                                          desc = "Close" },
  { "<leader>bn", ":bnext<CR>",                                       desc = "Next" },
  { "<leader>bp", ":bprev<CR>",                                       desc = "Previous" },

  -- AI/Claude Code
  { "<leader>a",  group = "AI" },
  { "<leader>ac", "<cmd>ClaudeCode<cr>",                              desc = "Toggle" },
  { "<leader>af", "<cmd>ClaudeCodeFocus<cr>",                         desc = "Focus" },

  -- REST
  { "<leader>r",  group = "REST" },
  { "<leader>rr", ":lua require('kulala').run()<CR>",                 desc = "Run" },
  { "<leader>ra", ":lua require('kulala').run_all()<CR>",             desc = "Run all" },
  { "<leader>rp", ":lua require('kulala').preview()<CR>",             desc = "Preview" },
  { "<leader>rc", ":lua require('kulala').copy()<CR>",                desc = "Copy as cURL" },
  { "<leader>ri", ":lua require('kulala').inspect()<CR>",             desc = "Inspect" },
  { "<leader>re", ":lua require('kulala').set_selected_env()<CR>",    desc = "Set env" },

  -- LSP（詳細なキーマップはlsp.luaのLspAttachで設定）
  { "<leader>l",  group = "LSP" },

  -- Yank paths
  { "<leader>y",  group = "Yank" },
  {
    "<leader>yp",
    function()
      local path = vim.fn.expand("%:p:h")
      vim.fn.setreg("+", path)
      print("Copied: " .. path)
    end,
    desc = "Directory path"
  },
  {
    "<leader>yf",
    function()
      local path = vim.fn.expand("%:p")
      vim.fn.setreg("+", path)
      print("Copied: " .. path)
    end,
    desc = "File path"
  },
  {
    "<leader>yd",
    function()
      local path = vim.fn.getcwd()
      vim.fn.setreg("+", path)
      print("Copied: " .. path)
    end,
    desc = "Current directory"
  },
})

-- ビジュアルモード用
wk.add({
  { "<leader>a",  group = "AI",              mode = "v" },
  { "<leader>as", "<cmd>ClaudeCodeSend<cr>", desc = "Send to Claude", mode = "v" },
})

-- 診断移動
keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })

-- .httpファイル専用
vim.api.nvim_create_autocmd("FileType", {
  pattern = "http",
  callback = function()
    local opts = { buffer = true, silent = true }
    vim.keymap.set("n", "<CR>", ":lua require('kulala').run()<CR>", opts)
  end,
})
