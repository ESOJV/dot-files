-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information

-- ============================================
-- Custom Keymaps
-- ============================================

-- Run code in a small terminal split
local runners = {
  go = "go run %",
  python = "python3 %",
  javascript = "node %",
  typescript = "ts-node %",
  lua = "lua %",
  rust = "cargo run",
  c = "gcc % -o /tmp/a.out && /tmp/a.out",
  cpp = "g++ % -o /tmp/a.out && /tmp/a.out",
}

vim.keymap.set("n", "<leader>rc", function()
  local ft = vim.bo.filetype
  local cmd = runners[ft]
  if cmd then
    vim.cmd("write") -- save first
    vim.cmd("10split | terminal " .. cmd)
  else
    print("No runner for filetype: " .. ft)
  end
end, { desc = "Run code" })

-- Close terminal easily with q
vim.api.nvim_create_autocmd("TermOpen", {
  callback = function()
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = true })
  end,
})

-- New tab
vim.keymap.set("n", "<leader>ntv", "<cmd>tabnew<cr>", { desc = "New tab" })

return {}
