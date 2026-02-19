return {
  'scottmckendry/cyberdream.nvim',
  priority = 1000,
  config = function()
    require('cyberdream').setup {
      italic_comments = false,
      transparent = true,
    }
    vim.cmd.colorscheme 'cyberdream'
  end,
}
