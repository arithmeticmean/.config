-- local utils = require('utils')
vim.g.mapleader = " "
--vim.keymap.set("n", "<leader>p", vim.cmd.Ex)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set('n', '<leader>p', "<cmd>Neotree toggle<cr>")
--vim.keymap.set('n', '<leader>[', "<cmd>Neotree close<cr>")

-- Sets colors to line numbers Above, Current and Below  in this order

-- harpoon
--vim.keymap.set('n', '<leader>hx', require('harpoon.mark').add_file)
--vim.keymap.set('n', '<leader>hn', require('harpoon.ui').nav_next)
--vim.keymap.set('n', '<leader>hp', require('harpoon.ui').nav_prev)
-- utils.map('n', [[<leader>hm]], ':Telescope harpoon marks<CR>')
local hardmode = true
if hardmode then
  -- Show an error message if a disabled key is pressed
  local msg = [[<cmd>echohl Error | echo "KEY DISABLED" | echohl None<CR>]]

  -- Disable arrow keys in insert mode with a styled message
  vim.api.nvim_set_keymap('i', '<Up>', '<C-o>' .. msg, { noremap = true, silent = false })
  vim.api.nvim_set_keymap('i', '<Down>', '<C-o>' .. msg, { noremap = true, silent = false })
  vim.api.nvim_set_keymap('i', '<Left>', '<C-o>' .. msg, { noremap = true, silent = false })
  vim.api.nvim_set_keymap('i', '<Right>', '<C-o>' .. msg, { noremap = true, silent = false })
  --vim.api.nvim_set_keymap('i', '<Del>', '<C-o>' .. msg, { noremap = true, silent = false })
  --vim.api.nvim_set_keymap('i', '<BS>', '<C-o>' .. msg, { noremap = true, silent = false })

  -- Disable arrow keys in normal mode with a styled message
  vim.api.nvim_set_keymap('n', '<Up>', msg, { noremap = true, silent = false })
  vim.api.nvim_set_keymap('n', '<Down>', msg, { noremap = true, silent = false })
  vim.api.nvim_set_keymap('n', '<Left>', msg, { noremap = true, silent = false })
  vim.api.nvim_set_keymap('n', '<Right>', msg, { noremap = true, silent = false })
  --vim.api.nvim_set_keymap('n', '<BS>', msg, { noremap = true, silent = false })
end
