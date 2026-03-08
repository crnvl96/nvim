require('mini.jump2d').setup({
  spotter = require('mini.jump2d').gen_spotter.pattern('[^%s%p]+'),
  labels = 'asdfghjklweruioxcvn,.',
  view = {
    dim = true,
    n_steps_ahead = 2,
  },
})
