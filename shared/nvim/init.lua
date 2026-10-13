-- ==========================================
-- 1. CONFIGURACIONES NATIVAS
-- ==========================================
vim.opt.number = true       -- Números de línea normales
vim.opt.cursorline = true   -- Resaltar línea actual
vim.opt.tabstop = 4         -- Tamaño de tabuladores
vim.opt.shiftwidth = 4
vim.opt.expandtab = true    -- Convertir tabs a espacios

-- ==========================================
-- 2. INSTALACIÓN AUTOMÁTICA DE LAZY.NVIM
-- ==========================================
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- ==========================================
-- 3. CONFIGURACIÓN DE PLUGINS
-- ==========================================
require("lazy").setup({
  -- Tema visual
  { "folke/tokyonight.nvim", lazy = false, priority = 1000,
    config = function() vim.cmd([[colorscheme tokyonight]]) end,
  },

  -- Barra inferior estética
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function() require("lualine").setup() end,
  },

  -- Resaltado de sintaxis inteligente
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({
        ensure_installed = { "lua", "javascript", "json", "bash", "python", "java", "css", "html" },
        highlight = { enable = true },
      })
    end,
  },

  -- Cierre automático de paréntesis/llaves
  { "windwp/nvim-autopairs", event = "InsertEnter",
    config = function() require("nvim-autopairs").setup({}) end,
  },

  -- Comentarios rápidos
  { "echasnovski/mini.comment", version = "*",
    config = function() require("mini.comment").setup() end,
  },

  -- Autocompletado
  { "saghen/blink.cmp", version = "1.*",
    opts = {
      keymap = { preset = "super-tab" },  -- Tab acepta, como en VS Code
      completion = { documentation = { auto_show = true } },
      sources = { default = { "lsp", "path", "snippets", "buffer" } },
    },
  },

  -- Instalador de servidores de lenguaje
  { "mason-org/mason.nvim", opts = {} },
  { "mason-org/mason-lspconfig.nvim",
    dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
    opts = {
      ensure_installed = { "lua_ls", "ts_ls", "html", "cssls", "pyright" },
    },
  },
})

-- ==========================================
-- 4. ATAJOS
-- ==========================================
-- Ctrl + Backspace borra palabras en modo inserción
vim.keymap.set("i", "<C-H>", "<C-W>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-BS>", "<C-W>", { noremap = true, silent = true })

-- ==========================================
-- 5. APARIENCIA
-- ==========================================
-- Fondo transparente: usar el de la terminal
local function clear_bg()
  for _, g in ipairs({ "Normal", "NormalNC", "NormalFloat", "SignColumn",
                       "EndOfBuffer", "LineNr", "FoldColumn", "StatusLine" }) do
    vim.api.nvim_set_hl(0, g, { bg = "none" })
  end
end
clear_bg()
vim.api.nvim_create_autocmd("ColorScheme", { callback = clear_bg })

-- ==========================================
-- 6. LSP
-- ==========================================
-- Pyright: usar el .venv del proyecto si existe
vim.lsp.config("pyright", {
  before_init = function(_, config)
    local python = config.root_dir and (config.root_dir .. "/.venv/bin/python")
    if python and vim.uv.fs_stat(python) then
      config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
        python = { pythonPath = python },
      })
    end
  end,
})
