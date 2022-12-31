local options = {
  backup = false,                          -- creates a backup file
  number = true,                          -- set numbered lines
  clipboard = "unnamedplus",               -- allows neovim to access the system clipboard
  cmdheight = 1,                           -- more space in the neovim command line for displaying messages
  completeopt = { "menuone", "noselect" }, -- mostly just for cmp
  conceallevel = 0,                        -- so that `` is visible in markdown files
  fileencoding = "utf-8",                  -- the encoding written to a file
  hlsearch = true,                         -- highlight all matches on previous search pattern
  ignorecase = true,                       -- ignore case in search patterns
  mouse = "a",                             -- allow the mouse to be used in neovim
  pumheight = 10,                          -- pop up menu height
  showmode = false,                        -- we don't need to see things like -- INSERT -- anymore
  showtabline = 2,                         -- always show tabs
  smartcase = true,                        -- smart case
  smartindent = true,                      -- make indenting smarter again
  -- smarttab = true,                         -- <tab>/<BS> indent/dedent in leading whitespace
  splitbelow = true,                       -- force all horizontal splits to go below current window
  splitright = true,                       -- force all vertical splits to go to the right of current window
  swapfile = false,                        -- creates a swapfile
  -- termguicolors = true,                    -- set term gui colors (most terminals support this)
  timeoutlen = 300,                        -- time to wait for a mapped sequence to complete (in milliseconds)
  undofile = true,                         -- enable persistent undo
  updatetime = 300,                        -- faster completion (4000ms default)
  writebackup = false,                     -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
  expandtab = true,                        -- convert tabs to spaces
  shiftwidth = 2,                          -- the number of spaces inserted for each indentation
  tabstop = 2,                             -- insert 2 spaces for a tab
  relativenumber = false,                  -- set relative numbered lines
  numberwidth = 4,                         -- set number column width to 2 {default 4}
  signcolumn = "yes",                      -- always show the sign column, otherwise it would shift the text each time
  wrap = false,                             -- display lines as one long line
  linebreak = true,                        -- companion to wrap, don't split words
  scrolloff = 8,                           -- minimal number of screen lines to keep above and below the cursor
  sidescrolloff = 8,                       -- minimal number of screen columns either side of cursor if wrap is `false`
  guifont = "monospace:h16",               -- the font used in graphical neovim applications
  whichwrap = "bs<>[]hl",                  -- which "horizontal" keys are allowed to travel to prev/next line
  cursorline = false,                      -- highlight the current line (costs a bit of performance, I prefer it disabled)
  -- autowrite  = true,                       -- write current buffer when moving buffers
  
  -- This should make vim a bit faster
  timeoutlen = 500,
  -- ttimeoutlen= 50,
  updatetime = 200,
  history = 5,                            -- number of items to remember in history
  ttyfast = true,
  -- bufhidden = unload,                      -- (save memory when other file is viewed),
  -- buftype = nowritefile,                   -- (is read only)
  -- undolevels = -1,                         -- (no undo possible)
}

for k, v in pairs(options) do
  vim.opt[k] = v
end

-- vim.opt.shortmess = "ilmnrx"                        -- flags to shorten vim messages, see :help 'shortmess'
vim.opt.shortmess:append "c"                           -- don't give |ins-completion-menu| messages
vim.opt.iskeyword:append "-"                           -- hyphenated words recognized by searches
vim.opt.formatoptions:remove({ "c", "r", "o" })        -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
vim.opt.runtimepath:remove("/usr/share/vim/vimfiles")  -- separate vim plugins from neovim in case vim still in use

-- VIMSCRIPT (fare in lua quando hai sbatti)
-- Disable spellcheck for markdown file and turn off syntax
-- after nospell: && :setlocal syntax off
vim.cmd[[
augroup textfiles
  autocmd!
  autocmd filetype markdown :setlocal nospell && :setlocal syntax off
augroup end
]]

-- Better visualization of word wrapping (keep text of bullet alligned)
-- To fix (make it work both for text without and with bullet points)
vim.cmd[[
let &showbreak='  '
set showbreak=▏"character used in linebreaks: ↴, ▏
]]

-- Hide everything status and commandline using Shift+x
vim.cmd[[
let s:hidden_all = 0
function! ToggleHiddenAll()
    if s:hidden_all  == 0
        let s:hidden_all = 1
        set noshowmode
        set noruler
        set laststatus=0
        set noshowcmd
        set cmdheight=0
    else
        let s:hidden_all = 0
        set showmode
        set ruler
        set laststatus=2
        set showcmd
        set cmdheight=1
    endif
endfunction

nnoremap <S-x> :call ToggleHiddenAll()<CR>
]]

-- Hide status and command line by default from startup (I prefer it)
vim.cmd[[
let s:hidden_all = 1
set noshowmode
set noruler
set laststatus=0
set noshowcmd
set cmdheight=0
]]

-- This should make vim a bit faster
vim.cmd[[
set synmaxcol=128 "may cause problem with markdown syntax highlight and vimtex
" set shada="NONE"  "the shada or viminfo file is used to store a lot of things like command line history, marks, input-line 
" history, search history. Disabling this for real dev work won’t be a wise choice but it can be a life-saver if you are
" using Vim over SSH. Pitfall: no recent file history if you use telescope/alpha dashboard.
" set viminfo="NONE" "same as above, not good with telescope/alpha dashbpoard.
set noswapfile "if you are a single user on your system, you probably don’t need swap files
set lazyredraw "makes vim a bit faster and avoid scrolling problems (see :h lazyredraw)
]]

-- Instead of pencil plugin (simpler solution)
vim.cmd[[
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
" set virtualedit=all "this allows you to move also in blank spaces
]]

-- Vimtex (go inside $ $ press tab and see if it returns 0 or 1)
-- vim.cmd[[
-- let g:vim_markdown_math = 1 "works with vim-markdown plugin
-- nno        <Tab> :echo vimtex#syntax#in_mathzone()<cr>
-- ino <expr> <Tab> "\<C-r>=vimtex#syntax#in_mathzone()<cr>"
-- ]]



