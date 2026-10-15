-- ==========================================
-- 1. CONFIGURACIONES NATIVAS
-- ==========================================
-- Apaga proveedores que no uso (quita avisos de :checkhealth)
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

vim.opt.number = true         -- Números de línea
-- vim.opt.relativenumber = true -- Distancia relativa (útil para 5j, 12k)
vim.opt.cursorline = true     -- Resaltar línea actual
vim.opt.tabstop = 4           -- Tamaño de tabuladores
vim.opt.shiftwidth = 4
vim.opt.expandtab = true      -- Convertir tabs a espacios
vim.opt.ignorecase = true     -- Buscar sin distinguir mayúsculas...
vim.opt.smartcase = true      -- ...salvo que escribas alguna
vim.opt.scrolloff = 8         -- Margen al llegar al borde de la pantalla
vim.opt.undofile = true       -- Deshacer incluso después de cerrar
vim.opt.splitright = true     -- Divisiones verticales a la derecha
vim.opt.splitbelow = true     -- Divisiones horizontales abajo

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

-- Espacio como <leader> (debe ir antes de cargar los plugins)
vim.g.mapleader = " "
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- ==========================================
-- 3. CONFIGURACIÓN DE PLUGINS
-- ==========================================
require("lazy").setup({
    -- Tema visual
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function() vim.cmd([[colorscheme tokyonight]]) end,
    },

    -- Hace que lua_ls entienda la API de Neovim (evita avisos falsos en este archivo)
    { "folke/lazydev.nvim",   ft = "lua", opts = {} },

    -- Barra inferior estética
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function() require("lualine").setup({}) end,
    },

    -- Resaltado de sintaxis
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        lazy = false,
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter").install({
                "python", "javascript", "typescript", "tsx",
                "html", "css", "json", "bash",
            })
            vim.api.nvim_create_autocmd("FileType", {
                pattern = {
                    "python", "javascript", "javascriptreact",
                    "typescript", "typescriptreact",
                    "html", "css", "json", "sh", "lua", "markdown",
                },
                callback = function() vim.treesitter.start() end,
            })
        end,
    },

    -- Cierre automático de paréntesis/llaves
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function() require("nvim-autopairs").setup({}) end,
    },

    -- Comentarios rápidos (gcc, gc + movimiento)
    {
        "echasnovski/mini.comment",
        version = "*",
        config = function() require("mini.comment").setup() end,
    },

    -- Autocompletado
    {
        "saghen/blink.cmp",
        version = "1.*",
        opts = {
            keymap = { preset = "super-tab" }, -- Tab acepta, como en VS Code
            completion = { documentation = { auto_show = true } },
            sources = { default = { "lsp", "path", "snippets", "buffer" } },
        },
    },

    -- Instalador de servidores de lenguaje
    { "mason-org/mason.nvim", opts = {} },
    {
        "mason-org/mason-lspconfig.nvim",
        dependencies = { "mason-org/mason.nvim", "neovim/nvim-lspconfig" },
        opts = {
            ensure_installed = {
                "lua_ls", "pyright",
                "ts_ls", "html", "cssls", "tailwindcss",
            },
        },
    },

    -- Buscador de archivos y texto
    {
        "nvim-telescope/telescope.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Buscar archivos" },
            { "<leader>fg", "<cmd>Telescope live_grep<cr>",  desc = "Buscar texto" },
            { "<leader>fb", "<cmd>Telescope buffers<cr>",    desc = "Buffers" },
        },
    },

    -- Ayuda de atajos
    { "folke/which-key.nvim",    event = "VeryLazy", opts = {} },

    -- Git en el margen
    { "lewis6991/gitsigns.nvim", opts = {} },
})

-- ==========================================
-- 4. ATAJOS
-- ==========================================
-- Ctrl + Backspace borra palabras en modo inserción
vim.keymap.set("i", "<C-H>", "<C-W>", { noremap = true, silent = true })
vim.keymap.set("i", "<C-BS>", "<C-W>", { noremap = true, silent = true })

-- Ctrl+C copia la selección al portapapeles del sistema
vim.keymap.set("v", "<C-c>", '"+y', { desc = "Copiar al portapapeles" })

-- Guardar y salir
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Guardar" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Salir" })

-- Moverse entre buffers (en lugar de pestañas)
vim.keymap.set("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Buffer anterior" })
vim.keymap.set("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Buffer siguiente" })

-- LSP
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Ir a la definición" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Ver error de la línea" })

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
        local bin = vim.fn.has("win32") == 1 and "/.venv/Scripts/python.exe" or "/.venv/bin/python"
        local python = config.root_dir and (config.root_dir .. bin)
        if python and vim.uv.fs_stat(python) then
            config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
                python = { pythonPath = python },
            })
        end
    end,
})
