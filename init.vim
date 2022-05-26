" -- 設定自動縮排
set smartindent
" -- 設定folder
set foldmethod=indent
set foldlevel=3
" -- 自動顯示行位
autocmd InsertLeave,WinEnter * set cursorline
autocmd InsertEnter,WinLeave * set nocursorline
" -- 存檔時自動刪除行尾空白
autocmd InsertLeave * :%s/\s\+$//e
" -- 自動回復到上次編輯位置
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
" -- Emment快捷鍵，記得還有一個預設的"，"
let g:user_emmet_leader_key='<C-Z>'
" -- tab顯示
let g:vem_tabline_show = 2
let g:vem_tabline_show_number = "index"
" -- 自動開啟縮排顏色
let g:indent_guides_enable_on_vim_startup = 1
" -- ctags
set tags=./tags
let mapleader = "\\"
" -- 檔案參照功能
filetype on
filetype plugin on
filetype indent on
syntax on
" -- 設定tab鍵寬度
set tabstop=2
set shiftwidth=2
set expandtab
" -- 設定主題
let g:context_nvim_no_redraw = 1
" -- 可以用滑鼠
set mouse=a
" -- 顯示行號
set number
set relativenumber
set termguicolors
" -- 設定檔案編碼方式
set encoding=utf8
setglobal fileencoding=utf-8
" -- 開啟狀態欄
set laststatus=2
" -- float termianl設定
let g:floaterm_keymap_toggle = '<F12>'
let g:floaterm_width = 0.9
let g:floaterm_height = 0.9
" -- fzf 設定
let g:fzf_preview_window = 'right:50%'
let g:fzf_layout = { 'window': { 'width': 0.9, 'height': 0.6  }  }
" -- 安裝外掛
call plug#begin()
  Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
  Plug 'ms-jpq/coq.artifacts', {'branch': 'artifacts'}
  Plug 'ms-jpq/coq.thirdparty', {'branch': '3p'}
  Plug 'petertriho/nvim-scrollbar'
  Plug 'kevinhwang91/nvim-hlslens'
  Plug 'ms-jpq/chadtree', {'branch': 'chad', 'do': 'python3 -m chadtree deps'}
  Plug 'ojroques/nvim-hardline'
  Plug 'williamboman/nvim-lsp-installer'
  Plug 'ap/vim-buftabline'
  Plug 'pacha/vem-tabline'
  Plug 'folke/lsp-colors.nvim'
  Plug 'folke/trouble.nvim'
  Plug 'github/copilot.vim'
  Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
  Plug 'digitaltoad/vim-pug'
  Plug 'Yggdroot/indentLine'
  Plug 'jiangmiao/auto-pairs'
  Plug 'kyazdani42/nvim-web-devicons'
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'voldikss/vim-floaterm'
  Plug 'karb94/neoscroll.nvim'
  Plug 'lilydjwg/colorizer'
  Plug 'neovim/nvim-lspconfig'
  Plug 'tmhedberg/SimpylFold'
  Plug 'Shougo/context_filetype.vim'
  Plug 'mattn/emmet-vim'
  Plug 'mbbill/undotree'
  Plug 'ryanoasis/vim-devicons'
  Plug 'LnL7/vim-nix'
  Plug 'mfussenegger/nvim-dap'
call plug#end()
colorscheme tokyonight
lua << EOF
  -- COQ.VIM 設定: 自動啟動+tabnine啟動
  vim.g.coq_settings = {auto_start = true, clients = {tabnine = {enabled = true}}}
  -- 啟用LSP
  local coq = require "coq"
  require("nvim-lsp-installer").setup {
    automatic_installation = true, -- automatically detect which servers to install (based on which servers are set up via lspconfig)
    ui = {
        icons = {
            server_installed = "✓",
            server_pending = "➜",
            server_uninstalled = "✗"
        }
    }
  }
  require'lspconfig'.rnix.setup{coq.lsp_ensure_capabilities{}}
  require'lspconfig'.eslint.setup{coq.lsp_ensure_capabilities{}}
  require'lspconfig'.pyright.setup{coq.lsp_ensure_capabilities{}}
  require'lspconfig'.vimls.setup{coq.lsp_ensure_capabilities{}}
  require'lspconfig'.vuels.setup{coq.lsp_ensure_capabilities{}}
  -- 設定ScrollerBar
  require('neoscroll').setup()
  local colors = require("tokyonight.colors").setup()
  require("scrollbar").setup({
      handle = {
          color = colors.bg_highlight,
      },
      marks = {
          Search = { color = colors.orange },
          Error = { color = colors.error },
          Warn = { color = colors.warning },
          Info = { color = colors.info },
          Hint = { color = colors.hint },
          Misc = { color = colors.purple },
      }
  })
  require("scrollbar.handlers").register("my_marks", function(bufnr)
    return {
        { line = 0 },
        { line = 1, text = "x", type = "Warn" },
        { line = 2, type = "Error" }
    }
  end)
  local kopts = {noremap = true, silent = true}
  vim.api.nvim_set_keymap('n', 'n',[[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],kopts)
  vim.api.nvim_set_keymap('n', 'N',[[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],kopts)
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  require'lspconfig'.html.setup {
    capabilities = capabilities,
  }

  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities.textDocument.completion.completionItem.snippetSupport = true
  require'lspconfig'.cssls.setup {
    capabilities = capabilities,
  }
  require("coq_3p") {
    { src = "nvimlua", short_name = "nLUA" },
    { src = "vimtex", short_name = "vTEX" },
    { src = "copilot", short_name = "COP", accept_key = "<c-f>" },
    { src = "bc", short_name = "MATH", precision = 6 },
    { src = "figlet", short_name = "BIG", trigger = "!big"},
    { src = "dap" }
  }
  vim.opt.termguicolors = true
  require('hardline').setup {
    bufferline = false,  -- enable bufferline
    bufferline_settings = {
      exclude_terminal = false,  -- don't show terminal buffers in bufferline
      show_index = false,        -- show buffer indexes (not the actual buffer numbers) in bufferline
    },
    theme = 'default',   -- change theme
    sections = {         -- define sections
      {class = 'mode', item = require('hardline.parts.mode').get_item},
      {class = 'high', item = require('hardline.parts.git').get_item, hide = 100},
      {class = 'med', item = require('hardline.parts.filename').get_item},
      '%<',
      {class = 'med', item = '%='},
      {class = 'low', item = require('hardline.parts.wordcount').get_item, hide = 100},
      {class = 'error', item = require('hardline.parts.lsp').get_error},
      {class = 'warning', item = require('hardline.parts.lsp').get_warning},
      {class = 'warning', item = require('hardline.parts.whitespace').get_item},
      {class = 'high', item = require('hardline.parts.filetype').get_item, hide = 60},
      {class = 'mode', item = require('hardline.parts.line').get_item},
    },
  }

  require("lsp-colors").setup({
    Error = "#db4b4b",
    Warning = "#e0af68",
    Information = "#0db9d7",
    Hint = "#10B981"
  })

  require("trouble").setup {
    position = "bottom", -- position of the list can be: bottom, top, left, right
    height = 10, -- height of the trouble list when position is top or bottom
    width = 50, -- width of the list when position is left or right
    icons = true, -- use devicons for filenames
    mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
    fold_open = "", -- icon used for open folds
    fold_closed = "", -- icon used for closed folds
    group = true, -- group results by file
    padding = true, -- add an extra new line on top of the list
    action_keys = { -- key mappings for actions in the trouble list
        -- map to {} to remove a mapping, for example:
        -- close = {},
        close = "q", -- close the list
        cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
        refresh = "r", -- manually refresh
        jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
        open_split = { "<c-x>" }, -- open buffer in new split
        open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
        open_tab = { "<c-t>" }, -- open buffer in new tab
        jump_close = {"o"}, -- jump to the diagnostic and close the list
        toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
        toggle_preview = "P", -- toggle auto_preview
        hover = "K", -- opens a small popup with the full multiline message
        preview = "p", -- preview the diagnostic location
        close_folds = {"zM", "zm"}, -- close all folds
        open_folds = {"zR", "zr"}, -- open all folds
        toggle_fold = {"zA", "za"}, -- toggle fold of current file
        previous = "k", -- preview item
        next = "j" -- next item
    },
    indent_lines = true, -- add an indent guide below the fold icons
    auto_open = false, -- automatically open the list when you have diagnostics
    auto_close = false, -- automatically close the list when you have no diagnostics
    auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
    auto_fold = false, -- automatically fold a file trouble list at creation
    auto_jump = {"lsp_definitions"}, -- for the given modes, automatically jump if there is only a single result
    signs = {
        -- icons / text used for a diagnostic
        error = "",
        warning = "",
        hint = "",
        information = "",
        other = "﫠"
    },
    use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client

  }
EOF

" -- 最下面的快捷鍵設定，會覆蓋掉上面的
nmap fp <Cmd>Files ./<CR>
nmap fh <Cmd>Files ~<CR>
"  -- ctrl+/設定為開啟、關閉註釋
" 注意！Unix作業系統中的ctrl+/會被認為是ctrl+_，所以下面有這樣一條if判斷
if has('win32')
    nmap <C-/> gcc
    vmap <C-/> gcc
else
    nmap <C-_> gcc
    vmap <C-_> gcc
endif
" -- 設定smooth換頁
nmap <PageUp> <C-u>
nmap <PageDown> <C-d>

" -- Ctrl + s 儲存
nmap <silent><C-s> :w<CR>
nmap <silent><C-c> :bdelete!<CR>
" -- F2打開側邊資料夾
nmap <silent><F2> :CHADopen <CR>
" -- tab & Buffer切換
nmap <leader>h <Plug>vem_move_buffer_left-
nmap <leader>l <Plug>vem_move_buffer_right-
nmap <leader>p <Plug>vem_prev_buffer-
nmap <leader>n <Plug>vem_next_buffer-
nnoremap <leader>1 :1tabnext<CR>
nnoremap <leader>2 :2tabnext<CR>
nnoremap <leader>3 :3tabnext<CR>
nnoremap <leader>4 :4tabnext<CR>
nnoremap <leader>5 :5tabnext<CR>
nnoremap <leader>6 :6tabnext<CR>
nnoremap <leader>7 :7tabnext<CR>
nnoremap <leader>8 :8tabnext<CR>
nnoremap <leader>9 :9tabnext<CR>
" -- Troble
nnoremap <leader>xx <cmd>TroubleToggle<cr>
nnoremap <leader>xw <cmd>TroubleToggle workspace_diagnostics<cr>
nnoremap <leader>xd <cmd>TroubleToggle document_diagnostics<cr>
nnoremap <leader>xq <cmd>TroubleToggle quickfix<cr>
nnoremap <leader>xl <cmd>TroubleToggle loclist<cr>
nnoremap gR <cmd>TroubleToggle lsp_references<cr>

nnoremap ca :lua vim.lsp.buf.code_action()<CR>
nnoremap rn :lua vim.lsp.buf.rename()<CR>

nnoremap <buffer> <space>e : lua vim.lsp.diagnostic.show_line_diagnostics()<CR>

nnoremap <F3> :UndotreeToggle<CR>


