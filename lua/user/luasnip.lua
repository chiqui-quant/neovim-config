vim.cmd[[
" Expand or jump in insert mode
imap <silent><expr> jk luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : 'jk' 

" Jump forward through tabstops in visual mode
" smap <silent><expr> jk luasnip#jumpable(1) ? '<Plug>luasnip-jump-next' : 'jk'

" Jump backward through snippet tabstops with Shift-Tab (for example)
" imap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'
" smap <silent><expr> <S-Tab> luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : '<S-Tab>'

" Jump backward through snippet tabstops with kj
imap <silent><expr> kj luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : 'kj'
" smap <silent><expr> kj luasnip#jumpable(-1) ? '<Plug>luasnip-jump-prev' : 'kj'
]]

-- LuaSnip common abbreviations ---------------------------------------------
local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
-- others below (more advanced but I do not use them at the moment)
local isn = ls.indent_snippet_node
local c = ls.choice_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local m = require("luasnip.extras").m
local lambda = require("luasnip.extras").l
local postfix = require("luasnip.extras.postfix").postfix
------------------------------------------------------------------------------

-- see config settings at: https://github.com/L3MON4D3/LuaSnip#config
ls.config.set_config({
  history = false, -- don't store snippet history for less overhead (and better performance) 
  enable_autosnippets = true,     -- allow autotrigger snippets
  store_selection_keys = "<Tab>", -- equivalent of UltiSnips visual selection
  -- Event on which to check for exiting a snippet's region
  region_check_events = "CursorMoved,InsertEnter", -- important: do not leave a space after the comma
  update_events = "TextChanged,TextChangedI",
  delete_check_events = "TextChanged,InsertLeave",
})

require("luasnip.loaders.from_lua").load({paths = "C:/Users/Chiqui/AppData/Local/nvim/LuaSnip/"})
-- require("luasnip.loaders.from_lua").lazy_load({paths = "~/.config/nvim/LuaSnip/"})

