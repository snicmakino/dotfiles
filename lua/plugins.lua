return {
  -- LSP
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
    },
  },

  -- 補完
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
  },

  -- Treesitter（シンタックスハイライト）
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        auto_install = true, -- 自動インストール有効化
        highlight = {
          enable = true,
        },
      })
    end,
  },

  -- ファジーファインダー
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("telescope").setup({

        defaults = {
          -- 除外パターン
          file_ignore_patterns = {
            "node_modules",
            ".git/",
            "build/",
            "target/",
            "dist/",
            "%.lock",
            ".gradle/",
            ".idea/",
          },
          -- ripgrepの設定（文字列検索用）
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--hidden",
            "--glob=!.git/",
          },
        },
        pickers = {
          find_files = {
            -- fdを使ってファイル検索（高速）
            find_command = { "fdfind", "--type", "f", "--hidden", "--exclude", ".git" },
            -- または fd が使える場合: { "fd", "--type", "f", "--hidden", "--exclude", ".git" }
          },
        },

      })
    end,
  },

  -- ファイルツリー
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({})
    end,
  },

  -- Git表示
  { "lewis6991/gitsigns.nvim", config = true },

  -- コメント操作
  { "numToStr/Comment.nvim",   config = true },

  -- カラースキーム
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme tokyonight]])
    end,
  },

  -- フォーマッター
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          lua = { "stylua" },
          kotlin = { "ktlint" },
          javascript = { "prettier" },
          typescript = { "prettier" },
          typescriptreact = { "prettier" },
          javascriptreact = { "prettier" },
          html = { "prettier" },
          css = { "prettier" },
        },
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true,
        },
      })
    end,
  },

  -- 括弧の自動閉じ
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    config = true,
  },

  -- インデント可視化
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    config = function()
      require("ibl").setup()
    end,
  },

  -- 括弧操作（囲む、削除、変更）
  {
    "kylechui/nvim-surround",
    version = "*",
    event = "VeryLazy",
    config = true,
  },

  -- ステータスライン
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "tokyonight",
        },
      })
    end,
  },

  -- LSP進捗表示
  {
    "j-hui/fidget.nvim",
    config = true,
  },

  -- エラー一覧表示
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-web-devicons" },
    config = function()
      require("trouble").setup()
    end,
  },

  -- LazyGit統合
  {
    "kdheepak/lazygit.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
  },

  -- テスト実行
  {
    "vim-test/vim-test",
    config = function()
      -- Nvim内のターミナルで実行
      vim.g["test#strategy"] = "neovim"

      -- Kotlin/Spring Boot用
      vim.g["test#java#runner"] = "gradletest"
      vim.g["test#kotlin#runner"] = "gradletest"

      -- JavaScript/TypeScript用
      vim.g["test#javascript#runner"] = "jest"
      vim.g["test#typescript#runner"] = "jest"
    end,

    -- バッファライン（タブ表示）
    {
      "akinsho/bufferline.nvim",
      version = "*",
      dependencies = "nvim-web-devicons",
      config = function()
        require("bufferline").setup({
          options = {
            diagnostics = "nvim_lsp",
            separator_style = "slant",
            offsets = {
              {
                filetype = "NvimTree",
                text = "File Explorer",
                highlight = "Directory",
                text_align = "left"
              }
            },
          },
        })
      end,
    },

    -- ターミナル管理
    {
      "akinsho/toggleterm.nvim",
      version = "*",
      config = function()
        require("toggleterm").setup({
          size = 20,
          -- open_mapping = [[<c-\>]],
          direction = "horizontal",
          shade_terminals = true,
          persist_size = true,
        })
      end,
    },
  },

  -- ClaudeCode設定:williamboman
  {
    "coder/claudecode.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "folke/snacks.nvim",
    },
    config = function()
      require("claudecode").setup({})
    end
  },

  -- キーバインド表示
{
  "folke/which-key.nvim",
  event = "VeryLazy",
  keys = {
    {
      "<leader>?",
      function()
        require("which-key").show({ global = false })
      end,
      desc = "Buffer Local Keymaps (which-key)",
    },
  },
},
  -- REST Client
  {
    "mistweaverco/kulala.nvim",
    config = function()
      require("kulala").setup({
        -- デフォルト設定で十分使える
        default_view = "body", -- body, headers, headers_body
        default_env = "dev",   -- デフォルト環境
        debug = false,
      })
    end,
  },

  -- 通知UI
  {
    "rcarriga/nvim-notify",
    config = function()
      require("notify").setup({
        stages = "fade",
        timeout = 3000,
      })
      vim.notify = require("notify")
    end,
  },

  -- UI改善（コマンドライン、メッセージ、通知）
  {
    "folke/noice.nvim",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    config = function()
      require("noice").setup({
        cmdline = {
          enabled = true,
          view = "cmdline_popup", -- ポップアップ表示
          format = {
            cmdline = { icon = ">" },
            search_down = { icon = "🔍⌄" },
            search_up = { icon = "🔍⌃" },
            filter = { icon = "$" },
            lua = { icon = "☾" },
            help = { icon = "?" },
          },
        },
        messages = {
          enabled = true,
          view = "notify", -- 通知として表示
        },
        popupmenu = {
          enabled = true,
          backend = "nui", -- "nui" or "cmp"
        },
        lsp = {
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
      })
    end,
  },
}
