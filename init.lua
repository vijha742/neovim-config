-- init.lua
-- Bootstrap Lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    error("Error cloning lazy.nvim:\n" .. out)
  end
end
vim.opt.rtp:prepend(lazypath)
-- Set leader key
vim.g.mapleader = ' '

-- Basic options
vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.wrap = false
vim.o.termguicolors = true
vim.o.foldmethod = "expr"
vim.o.foldexpr = "nvim_treesitter#foldexpr()"
vim.o.foldlevel = 99

-- Global Keymaps
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("i", "jj", "<Esc>")
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Clipboard support
-- set clipboard+=unnamedplus
vim.opt.clipboard = 'unnamedplus' --  Use the system clipboard
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

-- Font settings
vim.o.guifont = "Hack Nerd Font"

-- Keymaps
local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

vim.api.nvim_set_keymap('n', '<leader>qs', ':Prettier<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>r', ':!javac % && java %:r<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>di', "<cmd>lua require'jdtls'.organize_imports()<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dr', "<cmd>lua require'jdtls'.code_action(false, 'refactor')<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>dc', "<cmd>lua require'jdtls'.test_class()<CR>", { noremap = true, silent = true })
keymap('n', '<leader>ff', ':Telescope find_files<CR>', opts)
keymap('n', '<leader>fg', ':Telescope live_grep<CR>', opts)
keymap('n', '<leader>fb', ':Telescope buffers<CR>', opts)
keymap('n', '<leader>fh', ':Telescope help_tags<CR>', opts)
keymap('n', '<leader>r', ':lua vim.lsp.buf.rename()<CR>', opts)
keymap('n', '<leader>ca', ':lua vim.lsp.buf.code_action()<CR>', opts)
vim.keymap.set('n', '<leader>fe', ':NvimTreeToggle<CR>', { noremap = true, silent = true })
-- Package manager setup
  -- General Plugins
require("lazy").setup({
    -- Gruvbox theme
    { "morhetz/gruvbox", config = function()
        vim.cmd([[colorscheme tokyonight]])
    end },
    {
'windwp/nvim-ts-autotag',
config = function()
require('nvim-treesitter.configs').setup {
  autotag = { enable = true },
}end
},

{ -- Fuzzy Finder (files, lsp, etc)
    "nvim-telescope/telescope.nvim",
    event = "VimEnter",
    branch = "0.1.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { -- If encountering errors, see telescope-fzf-native README for installation instructions
        "nvim-telescope/telescope-fzf-native.nvim",

        -- `build` is used to run some command when the plugin is installed/updated.
        -- This is only run then, not every time Neovim starts up.
        build = "make",

        -- `cond` is a condition used to determine whether this plugin should be
        -- installed and loaded.
        cond = function()
          return vim.fn.executable("make") == 1
        end,
      },
      { "nvim-telescope/telescope-ui-select.nvim" },

      -- Useful for getting pretty icons, but requires a Nerd Font.
      { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    },
    config = function()
      -- Telescope is a fuzzy finder that comes with a lot of different things that
      -- it can fuzzy find! It's more than just a "file finder", it can search
      -- many different aspects of Neovim, your workspace, LSP, and more!
      --
      -- The easiest way to use Telescope, is to start by doing something like:
      --  :Telescope help_tags
      --
      -- After running this command, a window will open up and you're able to
      -- type in the prompt window. You'll see a list of `help_tags` options and
      -- a corresponding preview of the help.
      --
      -- Two important keymaps to use while in Telescope are:
      --  - Insert mode: <c-/>
      --  - Normal mode: ?
      --
      -- This opens a window that shows you all of the keymaps for the current
      -- Telescope picker. This is really useful to discover what Telescope can
      -- do as well as how to actually do it!

      -- [[ Configure Telescope ]]
      -- See `:help telescope` and `:help telescope.setup()`
      require("telescope").setup({
        -- You can put your default mappings / updates / etc. in here
        --  All the info you're looking for is in `:help telescope.setup()`
        --
        -- defaults = {
        --   mappings = {
        --     i = { ['<c-enter>'] = 'to_fuzzy_refine' },
        --   },
        -- },
        -- pickers = {}
        extensions = {
          ["ui-select"] = {
            require("telescope.themes").get_dropdown(),
          },
        },
      })

      -- Enable Telescope extensions if they are installed
      pcall(require("telescope").load_extension, "fzf")
      pcall(require("telescope").load_extension, "ui-select")

      -- See `:help telescope.builtin`
      local builtin = require("telescope.builtin")
      vim.keymap.set("n", "<leader>sh", builtin.help_tags, { desc = "[S]earch [H]elp" })
      vim.keymap.set("n", "<leader>sk", builtin.keymaps, { desc = "[S]earch [K]eymaps" })
      vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]ind [F]iles" })
      vim.keymap.set("n", "<leader>ss", builtin.builtin, { desc = "[S]earch [S]elect Telescope" })
      vim.keymap.set("n", "<leader>sw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
      vim.keymap.set("n", "<leader>sg", builtin.live_grep, { desc = "[S]earch by [G]rep" })
      vim.keymap.set("n", "<leader>sd", builtin.diagnostics, { desc = "[S]earch [D]iagnostics" })
      vim.keymap.set("n", "<leader>sr", builtin.resume, { desc = "[S]earch [R]esume" })
      vim.keymap.set("n", "<leader>s.", builtin.oldfiles, { desc = '[S]earch Recent Files ("." for repeat)' })
      vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
      vim.keymap.set("n", "<leader>fg", builtin.git_files, { desc = "[F]ind [G]it" })
      -- Slightly advanced example of overriding default behavior and theme
      vim.keymap.set("n", "<leader>/", function()
        -- You can pass additional configuration to Telescope to change the theme, layout, etc.
        builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end, { desc = "[/] Fuzzily search in current buffer" })

      -- It's also possible to pass additional configuration options.
      --  See `:help telescope.builtin.live_grep()` for information about particular keys
      vim.keymap.set("n", "<leader>s/", function()
        builtin.live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end, { desc = "[S]earch [/] in Open Files" })

      -- Shortcut for searching your Neovim configuration files
      vim.keymap.set("n", "<leader>sn", function()
        builtin.find_files({ cwd = vim.fn.stdpath("config") })
      end, { desc = "[S]earch [N]eovim files" })
    end,
  },
  {
    "SmiteshP/nvim-navic",
    dependencies = "neovim/nvim-lspconfig",
    config = function()
      -- Setup nvim-navic
      require("nvim-navic").setup {
        highlight = true,        -- Enable highlighting of breadcrumb text
        separator = " > ",       -- Set a custom separator
        depth_limit = 0,         -- No depth limit by default
      }

      -- Attach navic to your LSP (example for `lua_ls`):
      local lspconfig = require('lspconfig')
      lspconfig.lua_ls.setup {
        diagnostics = {globals = {'vim'},},
        on_attach = function(client, bufnr)
          if client.server_capabilities.documentSymbolProvider then
            require("nvim-navic").attach(client, bufnr)
          end
        end,
      }
    end
  },
  {'nvim-treesitter/nvim-treesitter',
  config = function()
  require'nvim-treesitter.configs'.setup {
  ensure_installed = { "java", "sql","python"},  -- Install Treesitter parser for Java
  highlight = { enable = true },
  indent = { enable = true },
  fold = { enable = true }
}
end
},
{'MunifTanjim/prettier.nvim',
config = function()
require('prettier').setup({
  bin = 'prettier', -- or 'prettierd'
  filetypes = {
    "css",
    "javascript",
    "javascriptreact",
    "typescript",
    "typescriptreact",
    "json",
    "html"
  },
})

-- Format on save
vim.api.nvim_command([[
  autocmd BufWritePre *.js,*.java,*.ts,*.jsx,*.tsx,*.json,*.css,*.html Prettier
]])
end
},
'norcalli/nvim-colorizer.lua',
  'neovim/nvim-lspconfig',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-path',
  'saadparwaiz1/cmp_luasnip',
  {
	"L3MON4D3/LuaSnip",
	-- follow latest release.
	version = "v2.*", -- Replace <CurrentMajor> by the latest released major (first number of latest release)
	-- install jsregexp (optional!).
	build = "make install_jsregexp"
},
  'nvim-neotest/nvim-nio',
  'lewis6991/gitsigns.nvim',
  'nvim-telescope/telescope.nvim',
  'nvim-telescope/telescope-fzf-native.nvim',
  'nvim-telescope/telescope-ui-select.nvim',
  'folke/which-key.nvim',
  'lewis6991/gitsigns.nvim',
  'lukas-reineke/indent-blankline.nvim',
  'nvim-lualine/lualine.nvim',
  'nvim-lua/plenary.nvim',
  'github/copilot.vim',
  'numToStr/Comment.nvim', -- for commenting code
  'windwp/nvim-autopairs', -- auto closing pairs
  'folke/todo-comments.nvim',
  'folke/tokyonight.nvim',
  'tpope/vim-sleuth',
{'simrat39/symbols-outline.nvim',
vim.keymap.set('n', '<leader>o', ':SymbolsOutline<CR>', { noremap = true, silent = true })
},
  -- Mason for LSP/DAP installer
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'WhoIsSethDaniel/mason-tool-installer.nvim',

  -- Debugging with DAP
  'mfussenegger/nvim-dap',
  'rcarriga/nvim-dap-ui',
  'theHamsta/nvim-dap-virtual-text',

  -- Java-specific plugins
  'mfussenegger/nvim-jdtls',  -- Java LSP
  'vim-test/vim-test',        -- Java testing
  'ray-x/lsp_signature.nvim', -- Function signature hints

  -- Formatter
  'stevearc/conform.nvim',

  -- Plugin to show LSP progress
  'j-hui/fidget.nvim',
})

-- Enable Treesitter
-- require('nvim-treesitter.configs').setup {
  -- ensure_installed = {"java","sql","bashls"},
--   highlight = { enable = true },
 --  indent = { enable = true },
--   fold = { enable = true}
-- }

-- LSP Setup (using mason to install and configure LSP servers)
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = { 'jdtls', 'lua_ls', 'bashls' }, -- Add other LSPs if needed
})
require('lspconfig').jdtls.setup{} -- Java LSP

-- Define signs for errors, warnings, hints, and info
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end

require("nvim-dap-virtual-text").setup({
  enabled = true,
  highlight_changed_variables = true,
  show_stop_reason = true,
})

-- Auto completion setup
local cmp = require'cmp'
local luasnip = require'luasnip'
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = {
    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    ['<C-y>'] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item.
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
  },
})
-- Gitsigns setup
require('gitsigns').setup()

require('colorizer').setup()
-- Telescope setup
require('telescope').setup{
  defaults = {
    file_ignore_patterns = { "node_modules" },
  },
}

local dap = require('dap')
dap.adapters.java = {
  type = 'server',
  host = '127.0.0.1',
  port = 8000,  -- Ensure that your Java debug server runs on this port
}

dap.configurations.java = {
  {
    type = 'java',
    request = 'launch',
    name = "Debug (Attach) - Remote",
    hostName = "127.0.0.1",
    port = 8000,
  },
}

-- Auto pairs setup
require('nvim-autopairs').setup()

-- Commenting plugin setup
require('Comment').setup()

-- DAP setup for debugging
require('dapui').setup()
require('nvim-dap-virtual-text').setup()

-- Configure signature help (for Java and other languages)
require('lsp_signature').setup()

-- Formatter setup
require('conform').setup({
  formatters_by_ft = {
    java = { "google_java_format" }, -- Configure the formatter you want for Java
  },
})

-- Lualine (statusline)
require('lualine').setup({
  options = {
    theme = 'tokyonight'
  }
})

-- Ensure web development language servers are installed
require('mason-lspconfig').setup({
  ensure_installed = { 'html', 'cssls', 'jsonls', 'emmet_ls' },
})

-- LSP configurations
require('lspconfig').html.setup{}      -- HTML
require('lspconfig').cssls.setup{}     -- CSS
require('lspconfig').jsonls.setup{}    -- JSON
require('lspconfig').emmet_ls.setup{}  -- Emmet for faster HTML and CSS

require('conform').setup({
  formatters_by_ft = {
    javascript = { "prettier" },
    typescript = { "prettier" },
    json = { "prettier" },
    css = { "prettier" },
    java = { "prettier" },
  },
})

-- Setup ESLint (npm install -g eslint)
require('lspconfig').eslint.setup{}
require('lspconfig').emmet_ls.setup({
  filetypes = { 'html', 'css', 'javascriptreact', 'typescriptreact' },
})


-- Snippets and autocompletion for web development
require('luasnip.loaders.from_vscode').lazy_load()  -- Loads VSCode-like snippets
require("cmp").setup({
  sources = {
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})

-- Which-key setup
require('which-key').setup()

-- Fidget setup (LSP progress indicator)
require('fidget').setup()

-- Additional configurations for plugins can be added here

-- Enable clipboard functionality
-- Yank to system clipboard
vim.api.nvim_set_keymap('n', '<leader>y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>y', '"+y', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>Y', '"+yg_', { noremap = true, silent = true })

-- Paste from system clipboard
vim.api.nvim_set_keymap('n', '<leader>p', '"+p', { noremap = true, silent = true })
vim.api.nvim_set_keymap('v', '<leader>p', '"+p', { noremap = true, silent = true })

-- Neovim-specific configurations (if needed)
-- For example, if you want to customize LSP or DAP settings, add them here.
local ls = require("luasnip")

vim.keymap.set({"i"}, "<C-K>", function() ls.expand() end, {silent = true},{desc = "For expand"})
vim.keymap.set({"i", "s"}, "<C-L>", function() ls.jump( 1) end, {silent = true},{desc = "For jumping forward"})
vim.keymap.set({"i", "s"}, "<C-J>", function() ls.jump(-1) end, {silent = true},{desc = "For jumping backward"})

vim.keymap.set({"i", "s"}, "<C-E>", function()
	if ls.choice_active() then
		ls.change_choice(1)
	end
end, {silent = true},{desc = "for changing active choice"})
