local globals = {
  loaded_ruby_provider = 0,
  loaded_perl_provider = 0,
  
  -- Set <space> as the leader key
  -- See `:help mapleader`
  --  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
  mapleader = ' ',
  maplocalleader = ' ',
  
  -- Set to true if you have a Nerd Font installed and selected in the terminal
  have_nerd_font = true,
}

-- TIP: Disable arrow keys in normal mode
-- vim.keymap.set('n', '<left>', '<cmd>echo "Use h to move!!"<CR>')
-- vim.keymap.set('n', '<right>', '<cmd>echo "Use l to move!!"<CR>')
-- vim.keymap.set('n', '<up>', '<cmd>echo "Use k to move!!"<CR>')
-- vim.keymap.set('n', '<down>', '<cmd>echo "Use j to move!!"<CR>')

-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`
local keymaps = {
  -- Clear highlights on search when pressing <Esc> in normal mode
  --  See `:help hlsearch`
  { 'n', '<Esc>', '<cmd>nohlsearch<CR>' },
  -- Diagnostic keymaps
  { 'n', '<leader>q', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' } },
  -- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
  -- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
  -- is not what someone will guess without a bit more experience.
  --
  -- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
  -- or just use <C-\><C-n> to exit terminal mode
  { 't', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' } },
  -- Keybinds to make split navigation easier.
  --  Use CTRL+<hjkl> to switch between windows
  --
  --  See `:help wincmd` for a list of all window commands
  { 'n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' } },
  { 'n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' } },
  { 'n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' } },
  { 'n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' } }
}

local options = {
  -- [[ Setting options ]]
  -- See `:help vim.opt`
  -- NOTE: You can change these options as you wish!
  --  For more options, you can see `:help option-list`
  
  -- Make line numbers default
  number = true,
  -- You can also add relative line numbers, to help with jumping.
  --  Experiment for yourself to see if you like it!
  -- vim.opt.relativenumber = true
  
  -- Enable mouse mode, can be useful for resizing splits for example!
  mouse = 'a',
  
  -- Don't show the mode, since it's already in the status line
  showmode = false,

  -- Enable break indent
  breakindent = true,
  
  -- Save undo history
  undofile = true,
  
  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  ignorecase = true,
  smartcase = true,
  
  -- Keep signcolumn on by default
  signcolumn = 'yes',
  
  -- Decrease update time
  updatetime = 250,
  
  -- Decrease mapped sequence wait time
  -- Displays which-key popup sooner
  timeoutlen = 300,
  
  -- Configure how new splits should be opened
  splitright = true,
  splitbelow = true,
  
  -- Sets how neovim will display certain whitespace characters in the editor.
  --  See `:help 'list'`
  --  and `:help 'listchars'`
  list = true,
  listchars = { tab = '» ', trail = '·', nbsp = '␣' },
  
  -- Preview substitutions live, as you type!
  inccommand = 'split',
  
  -- Show which line your cursor is on
  cursorline = true,
  
  -- Minimal number of screen lines to keep above and below the cursor.
  scrolloff = 10,
}

local exports = {
  g = globals,
  keymaps = keymaps,
  opt = options
}

function exports.clipboardSync() 
  -- Sync clipboard between OS and Neovim.
  --  Schedule the setting after `UiEnter` because it can increase startup-time.
  --  Remove this option if you want your OS clipboard to remain independent.
  --  See `:help 'clipboard'`
  vim.opt.clipboard = 'unnamedplus'
end

function exports.textYankCallback()
  vim.highlight.on_yank()
end

exports.textYankConfig = {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = exports.textYankCallback
}

function exports.init()
  vim.schedule(exports.clipboardSync)
  -- [[ Basic Autocommands ]]
  --  See `:help lua-guide-autocommands`
  for group,values in pairs({ g = globals, keymaps = keymaps, opt = options }) do
    for k,v in pairs(values) do
      if group == 'g' then
        vim.g[k] = v
      elseif group == 'opt' then
        vim.opt[k] = v
      elseif group == 'keymaps' then
        if #v == 4 then
          vim.keymap.set(v[1], v[2], v[3], v[4])
        else
          vim.keymap.set(v[1], v[2], v[3])
        end
      end
    end
  end


  -- Highlight when yanking (copying) text
  --  Try it with `yap` in normal mode
  --  See `:help vim.highlight.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', exports.textYankConfig)
end

return exports
