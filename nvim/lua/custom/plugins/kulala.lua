return {
  'mistweaverco/kulala.nvim',
  ft = 'http',
  opts = {},
  keys = {
    { '<leader>kr', function() require('kulala').run() end, desc = '[K]ulala [R]un request' },
    { '<leader>ka', function() require('kulala').run_all() end, desc = '[K]ulala Run [A]ll requests' },
    { '<leader>kn', function() require('kulala').jump_next() end, desc = '[K]ulala [N]ext request' },
    { '<leader>kp', function() require('kulala').jump_prev() end, desc = '[K]ulala [P]revious request' },
  },
}
