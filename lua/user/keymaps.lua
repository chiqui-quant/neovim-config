-- Note: if you use whichkey.lua consult also that file
-- Check also the config file of each plugin
-- If you use Telescope you can see all the keymaps and their actions
local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Better navigation in the file (centered view)
keymap("n", "<C-f>", "<C-f>zz", opts) -- forward 1 page
keymap("n", "<C-b>", "<C-b>zz", opts) -- backward 1 page
keymap("n", "<C-d>", "12jzz", opts) -- up 1/2 page remapped to 12 lines (better consistency)
keymap("n", "<C-u>", "12kzz", opts)
keymap("n", "<S-G>", "<S-G>zz", opts)
keymap("n", "j", "jzz", opts)
keymap("n", "k", "kzz", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Navigate buffers
keymap("n", "<S-l>", ":bnext<CR>", opts)
keymap("n", "<S-h>", ":bprevious<CR>", opts)

-- Move text up and down
keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Insert --
-- Press jk fast to exit insert mode 
-- keymap("i", "jk", "<ESC>", opts)
-- keymap("i", "kj", "<ESC>", opts)

-- Visual --
-- Stay in indent mode (todo: organize better)
keymap("n", "<", "<<", opts)
keymap("n", ">", ">>", opts)
keymap("n", "<Tab>", ">>", opts) -- conflicting with luasnips
keymap("n", ",", ">>", opts) -- momentarily workaround

keymap("v", ",", ">gv", opts) -- momentarily workaround
keymap("v", "<", "<gv", opts)
keymap("v", "<Tab>", ">gv", opts)

keymap("n", "s", "dd", opts)

-- Move text up and down
keymap("v", "<A-j>", ":m .+1<CR>==", opts)
keymap("v", "<A-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

keymap("n", "<leader>f", ":Telescope<CR>", opts) -- open telescope
-- reload config (custom reload.lua file) see:
-- https://stackoverflow.com/questions/72412720/how-to-source-init-lua-without-restarting-neovim
-- keymap("n", "<leader><CR>", "<cmd>lua ReloadConfig()<CR>", { noremap = true, silent = false }) -- custom function reload
keymap("n", "<leader><CR>", "<cmd>lua reload_config()<CR>", { noremap = true, silent = false })   -- reload with plenary


-- Comfortable Alt/Meta + key stuff
keymap("n", "<A-f>", "<cmd>Telescope oldfiles<cr>", opts) -- telescope recent files
keymap("n", "<A-e>", ":NvimTreeToggle<CR>", opts) -- toggle NvimTree
-- keymap("n", "<A-z>", ":ZenMode<CR>:SoftPencil<CR>:set nonumber<CR>", opts) -- zenmode/softpencil (fix toggle/untoggle number) 
keymap("n", "<A-z>", ":ZenMode<CR>::set nonumber<CR>", opts) -- zenmode (without soft pencil)
keymap("n", "<A-q>", "<cmd>Bdelete!<CR>", opts) -- close buffer in normal mode
keymap("i", "<A-q>", "<cmd>Bdelete!<CR>", opts) -- close buffer in insert mode
keymap("n", "<A-w>", "<cmd>w!<CR>", opts) -- save (write) buffer in normal mode
keymap("i", "<A-w>", "<cmd>w!<CR>", opts) -- save (write) buffer in insert mode
keymap("n", "<A-a>", "<cmd>Alpha<cr>", opts) -- toggle alpha (dashboard plugin)


