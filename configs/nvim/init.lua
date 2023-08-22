vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.hlsearch = false
vim.o.incsearch = true
vim.wo.number = true
vim.wo.relativenumber = true
vim.o.mouse = 'a'
vim.o.autoindent = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.softtabstop = 2
vim.o.shiftwidth = 2
vim.o.smartindent = true
vim.o.breakindent = true
vim.o.undofile = true
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.updatetime = 250
vim.o.timeoutlen = 300
vim.o.completeopt = 'menuone,noselect'
vim.o.langmap =
'ФИСВУАПРШОЛДЬТЩЗЙКЫЕГМЦЧНЯ;ABCDEFGHIJKLMNOPQRSTUVWXYZ,фисвуапршолдьтщзйкыегмцчня;abcdefghijklmnopqrstuvwxyz'
vim.opt.termguicolors = true
vim.o.scrolloff = 8
vim.o.smoothscroll = true
vim.o.backspace = "indent,eol,start"
vim.o.showmode = false
vim.o.list = true
vim.o.listchars = "tab:»·,trail:·,nbsp:·,extends:→,precedes:←"
vim.g.rust_recommended_style = 0
vim.o.guifont = "Cascadia Code:h14"

-- vim.o.signcolumn = "no"

-- vim.o.spell = true
-- vim.o.spelllang = "en,ru"


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

require("lazy").setup({
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
      flavour = "mocha",
      show_end_of_buffer = true,
      integrations = {
        mason = true,
        cmp = true,
        gitsigns = true,
        treesitter = true,
        noice = true,
        indent_blankline = {
          enabled = true,
        },
        which_key = true,
        telescope = {
          enabled = true,
        }
      },
    }
  },
  { "folke/which-key.nvim",                   opts = {} },
  { "stevearc/dressing.nvim",                 opts = {} },
  { "windwp/nvim-ts-autotag",                 opts = {} },
  { "numToStr/Comment.nvim",                  opts = {} },
  { "lewis6991/gitsigns.nvim",                opts = {} },
  { "roobert/tailwindcss-colorizer-cmp.nvim", opts = {} },
  { "mrjones2014/smart-splits.nvim",          opts = {} },
  {
    "zbirenbaum/copilot.lua",
    opts = {
      suggestion = { enabled = true, auto_trigger = true, keymap = { accept = "<S-Tab>" } }
    }
  },
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.2',
    dependencies = { 'nvim-lua/plenary.nvim' },
  },
  { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
  "nvim-telescope/telescope-file-browser.nvim",
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    dependencies = {
      'JoosepAlviste/nvim-ts-context-commentstring',
    },
  },
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v2.x',
    dependencies = {
      { 'neovim/nvim-lspconfig' },
      { 'williamboman/mason.nvim' },
      { 'williamboman/mason-lspconfig.nvim' },
      { 'hrsh7th/nvim-cmp' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'L3MON4D3/LuaSnip' },
    }
  },
  'jose-elias-alvarez/null-ls.nvim',
  {
    'nvim-lualine/lualine.nvim',
    opts = {
      options = { section_separators = '', component_separators = '', globalstatus = true, theme = "catppuccin" },
      extensions = { "fzf", "lazy", "toggleterm" },
    },
    dependencies = { { "nvim-tree/nvim-web-devicons" } }
  },
  {
    'akinsho/toggleterm.nvim',
    version = "*",
    opts = {
      open_mapping = [[<C-t>]],
      direction = "horizontal"
    }
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    opts = {
      show_current_context = true,
    }
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      }
    },
    dependencies = {
      "MunifTanjim/nui.nvim",
    }
  },
  "ahmedkhalf/project.nvim",
}, {})

require('telescope').load_extension('fzf')
require('telescope').load_extension('file_browser')
require("telescope").load_extension("projects")
vim.cmd.colorscheme("catppuccin")

require("project_nvim").setup({})


require('nvim-treesitter.configs').setup {
  ensure_installed = { "vim", "lua", "javascript", "rust", "typescript", "html", "json", "tsx", "markdown",
    "markdown_inline", "bash", "regex", "yaml", "toml" },
  highlight = {
    enable = true
  },
  autotag = {
    enable = true,
    enable_close_on_slash = false
  },
}

local lsp = require('lsp-zero').preset({})
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({ buffer = bufnr })
  lsp.buffer_autoformat()
end)
lsp.ensure_installed({
  'tsserver',
  'eslint',
  'rust_analyzer',
  'tailwindcss',
})
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())
lsp.setup()

local null_ls = require("null-ls")
null_ls.setup({
  sources = {
    null_ls.builtins.diagnostics.eslint,
    null_ls.builtins.formatting.prettierd
  },
})

local cmp = require('cmp')
local cmp_action = require('lsp-zero').cmp_action()
cmp.setup({
  mapping = {
    ['<CR>'] = cmp.mapping.confirm({ select = false }),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-f>'] = cmp_action.luasnip_jump_forward(),
    ['<C-b>'] = cmp_action.luasnip_jump_backward(),
  }
})


vim.keymap.set({ "i", "v", "n" }, "<C-s>", vim.cmd.w)
vim.keymap.set("", "<C-|>", vim.cmd.split)
vim.keymap.set("", "<C-\\>", vim.cmd.vsplit)
vim.api.nvim_set_keymap(
  "n",
  "<space>e",
  ":Telescope file_browser<CR>",
  { noremap = true }
)
vim.keymap.set("i", "<C-_>", "<Esc><Plug>(comment_toggle_linewise_current)a")
vim.keymap.set("n", "<C-_>", "<Plug>(comment_toggle_linewise_current)")
vim.keymap.set("v", "<C-_>", "<Plug>(comment_toggle_linewise_visual)")
vim.keymap.set("i", "<C-H>", "<C-w>")
vim.keymap.set("i", "^Z", vim.cmd.u)

vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")
vim.keymap.set("x", "<leader>p", [["_dP]])

vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set({ "n", "v" }, "<leader>p", [["+p]])
vim.keymap.set({ "n", "v" }, "<leader>d", [["_d]])

vim.keymap.set("n", "<leader>q", vim.cmd.q)

local Terminal = require('toggleterm.terminal').Terminal
local lazygit  = Terminal:new({ cmd = "lazygit", hidden = true, direction = "float" })

function _lazygit_toggle()
  lazygit:toggle()
end

vim.keymap.set("n", "<leader>g", "<cmd>lua _lazygit_toggle()<CR>", { noremap = true, silent = true })

vim.keymap.set("n", "<leader>r", "<Cmd>Telescope projects<CR>")

vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])

local builtin = require('telescope.builtin')
vim.keymap.set("n", "<C-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>f", builtin.live_grep, {})

function _G.set_terminal_keymaps()
  local opts = { buffer = 0 }
  vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
  vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
  vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
  vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
  vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
  vim.keymap.set('t', '<C-w>', [[<C-\><C-n><C-w>]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')
