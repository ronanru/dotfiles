set number
set expandtab
set tabstop=2
set shiftwidth=2
set encoding=utf-8
set nobackup
set nowritebackup
set noswapfile
set mouse=a
set termguicolors
set noshowmode
set clipboard=unnamedplus
set autoindent
set hlsearch
set ignorecase
set smartcase
set cursorline
set title
set wildmenu
set noswapfile
set confirm
set linebreak
set nocompatible

call plug#begin(has('nvim') ? stdpath('data') . '/plugged' : '~/.vim/plugged')

Plug 'olimorris/onedarkpro.nvim'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'nvim-lualine/lualine.nvim'
Plug 'kyazdani42/nvim-web-devicons'
" Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'kyazdani42/nvim-tree.lua'
Plug 'preservim/nerdcommenter'
Plug 'mhinz/vim-startify'
Plug 'folke/which-key.nvim'
Plug 'prettier/vim-prettier', {
  \ 'do': 'yarn install --frozen-lockfile --production',
  \ 'branch': 'release/0.x'
  \ }
:
call plug#end()

syntax on
filetype plugin on

nnoremap <C-n> :NvimTreeToggle<CR>
nnoremap <C-_> :call nerdcommenter#Comment(0,"toggle")<CR>

lua << END
require'which-key'.setup()
require'nvim-tree'.setup {
  view = {
    side = "right",
  }
}
require'lualine'.setup()
require'nvim-treesitter.configs'.setup {
  ensure_installed = { "html", "css", "javascript", "typescript", "svelte", "json", "cpp" },
  sync_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
}
local onedarkpro = require("onedarkpro")
onedarkpro.setup({
  options = {
      italic = true,
      cursorline = true,
      transparency = true,
  }
})
onedarkpro.load()
END
