require "core"

local custom_init_path = vim.api.nvim_get_runtime_file("lua/custom/init.lua", false)[1]

if custom_init_path then
  dofile(custom_init_path)
end

require("core.utils").load_mappings()

local lazypath = vim.fn.stdpath "data" .. "/lazy/lazy.nvim"

-- bootstrap lazy.nvim!
if not vim.loop.fs_stat(lazypath) then
  require("core.bootstrap").gen_chadrc_template()
  require("core.bootstrap").lazy(lazypath)
end

dofile(vim.g.base46_cache .. "defaults")
vim.opt.rtp:prepend(lazypath)
require "plugins"

local keymap = vim.api.nvim_set_keymap
local opts = { noremap = true, silent = true }

-- Normal mode
keymap('n', '<C-Left>', '<Home>', opts)
keymap('n', '<C-Right>', '<End>', opts)
keymap('n', '<C-Up>', '<C-Home>', opts)
keymap('n', '<C-Down>', '<C-End>', opts)


-- Insert mode
keymap('i', '<C-Left>', '<Home>', opts)
keymap('i', '<C-Right>', '<End>', opts)
keymap('i', '<C-Up>', '<C-Home>', opts)
keymap('i', '<C-Down>', '<C-End>', opts)

-- Visual mode
keymap('v', '<C-Left>', '<Home>', opts)
keymap('v', '<C-Right>', '<End>', opts)
keymap('v', '<C-Up>', '<C-Home>', opts)
keymap('v', '<C-Down>', '<C-End>', opts)

-- Select the word to the left
keymap('n', '<A-S-Left>', 'vb', opts)
keymap('i', '<A-S-Left>', '<Esc>vb', opts)

-- Select the word to the right
keymap('n', '<A-S-Right>', 've', opts)
keymap('i', '<A-S-Right>', '<Esc>ve', opts)

-- Function to select all text in the current buffer
function select_all()
  -- Go to the start of the file
  vim.cmd('normal! gg')
  -- Start visual mode
  vim.cmd('normal! V')
  -- Go to the end of the file
  vim.cmd('normal! G')
end

-- Function to select all text and delete it
function select_all_and_delete()
  select_all()
  -- Delete the selected text
  vim.cmd('normal! d')
end

-- Map Ctrl+A to select all text in normal mode
vim.api.nvim_set_keymap('n', '<C-a>', ':lua select_all()<CR>', { noremap = true, silent = true })

-- Map Ctrl+Shift+A to select all text and delete it in normal mode
vim.api.nvim_set_keymap('n', '<C-S-a>', ':lua select_all_and_delete()<CR>', { noremap = true, silent = true })

function ReplaceHighlighted()
  vim.cmd([[
    let old_reg = @"
    normal! gvy
    let search_term = escape(@", '\')
    let replace_term = input('Replace with: ')
    execute '%s/' . search_term . '/' . replace_term . '/g'
    let @" = old_reg
  ]])
end

-- Function to find highlighted text
function FindHighlighted()
  vim.cmd([[
    let old_reg = @"
    normal! gvy
    let search_term = escape(@", '\/')
    execute 'normal! /' . search_term
    let @" = old_reg
  ]])
end

-- Key mapping for Ctrl+f to find all instances of highlighted text
vim.api.nvim_set_keymap('v', '<C-f>', ':lua FindHighlighted()<CR>', { noremap = true, silent = true })


-- Key mapping for Ctrl+d to find and replace highlighted text
vim.api.nvim_set_keymap('v', '<C-d>', ':lua ReplaceHighlighted()<CR>', { noremap = true, silent = true })

require("custom.plugins")

-- FZF keymappings
vim.api.nvim_set_keymap('n', '<leader>a', ':Ag<CR>', { noremap = true, silent = true })

-- Tagbar toggle
vim.api.nvim_set_keymap('n', '<leader>tt', ':TagbarToggle<CR>', { noremap = true, silent = true })

