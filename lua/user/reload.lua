-- Custom function to reload nvim config written in lua
-- function _G.ReloadConfig()
--   for name,_ in pairs(package.loaded) do
--     if name:match('^user') and not name:match('nvim-tree') then
--       package.loaded[name] = nil
--     end
--   end
--
--   dofile(vim.env.MYVIMRC)
--   vim.notify("Nvim configuration reloaded!", vim.log.levels.INFO)
-- end

-- Note: you can also use :Telescope reloader to reload modules
-- Plenary reload function
 function _G.reload_config()
  local reload = require("plenary.reload").reload_module
  reload("user", false)

  dofile(vim.env.MYVIMRC)
end
