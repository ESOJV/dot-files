return {
  'cideM/yui',
  priority = 1000,
  config = function()
    vim.cmd.colorscheme 'yui'
    vim.api.nvim_set_hl(0, 'Normal', { bg = '#000000' })
    vim.api.nvim_set_hl(0, 'NormalNC', { bg = '#000000' })
    vim.api.nvim_set_hl(0, 'String', { fg = '#00ff00' })
  end,
}
