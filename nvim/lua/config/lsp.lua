require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "lua_ls", "ts_ls", "kotlin_language_server" },
})

local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Neovim 0.11以降の新しいAPI
local lsp_config = vim.lsp.config

-- TypeScript/JavaScript
lsp_config("ts_ls", {
  capabilities = capabilities,
})

-- Kotlin
lsp_config("kotlin_language_server", {
  capabilities = capabilities,
})

-- Lua
lsp_config("lua_ls", {
  capabilities = capabilities,
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
    },
  },
})

-- LSPが起動したときのキーバインド
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local opts = { buffer = args.buf }

    -- 定義・宣言ジャンプ（IntelliJ: Ctrl+B）
    vim.keymap.set("n", "gd", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "定義へジャンプ" }))
    vim.keymap.set("n", "-d", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "定義へジャンプ" }))
    vim.keymap.set("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "宣言へジャンプ" }))

    -- 実装ジャンプ（IntelliJ: Ctrl+Alt+B）
    vim.keymap.set("n", "gi", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "実装へジャンプ" }))
    vim.keymap.set("n", "-i", vim.lsp.buf.implementation, vim.tbl_extend("force", opts, { desc = "実装へジャンプ" }))

    -- 型定義ジャンプ
    vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "型定義へジャンプ" }))
    vim.keymap.set("n", "-t", vim.lsp.buf.type_definition, vim.tbl_extend("force", opts, { desc = "型定義へジャンプ" }))

    -- 参照検索（IntelliJ: Alt+F7 - usages）
    vim.keymap.set("n", "gr", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "参照を表示" }))
    vim.keymap.set("n", "-u", vim.lsp.buf.references, vim.tbl_extend("force", opts, { desc = "参照を表示（usages）" }))

    -- ホバー情報（IntelliJ: Ctrl+Q）
    vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "ホバー情報" }))

    -- シグネチャヘルプ（IntelliJ: Ctrl+P - parameter info）
    vim.keymap.set("n", "-k", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "シグネチャヘルプ" }))
    vim.keymap.set("i", "<C-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "シグネチャヘルプ" }))

    -- リネーム（IntelliJ: Shift+F6）
    vim.keymap.set("n", "<F2>", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "リネーム" }))
    vim.keymap.set("n", "-r", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "リネーム" }))

    -- コードアクション（IntelliJ: Alt+Enter）
    vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "コードアクション" }))
    vim.keymap.set("n", "-a", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "コードアクション" }))
    vim.keymap.set("v", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "コードアクション" }))
    vim.keymap.set("v", "-a", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "コードアクション" }))

    -- フォーマット用の localleader マッピング（IntelliJ: Ctrl+Alt+L）
    vim.keymap.set("n", "-f", function()
      require("conform").format({ async = true, lsp_fallback = true })
    end, vim.tbl_extend("force", opts, { desc = "フォーマット" }))
  end,
})

-- 補完設定
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
})
