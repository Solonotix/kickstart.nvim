-- If encountering errors, see telescope-fzf-native README for installation instructions
local config = {'nvim-telescope/telescope-fzf-native.nvim'}
-- `build` is used to run some command when the plugin is installed/updated.
-- This is only run then, not every time Neovim starts up.
config.build = 'make'
-- `cond` is a condition used to determine whether this plugin should be
-- installed and loaded.
function config.cond()
  return vim.fn.executable 'make' == 1
end

return config
