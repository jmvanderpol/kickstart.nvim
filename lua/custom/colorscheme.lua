return {
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    opt = {
      flavour = 'macchiato', -- latte, frappe, macchiato, mocha
      auto_integrations = true,
      color_overrides = {
        macchiato = {
          rosewater = '#e441a9',
          flamingo = '#e679da',
          pink = '#d8aef9',
          mauve = '#be94e4',
          red = '#fdf96f',
          maroon = '#f8df72',
          peach = '#fab770',
          yellow = '#faca64',
          green = '#93eebc',
          teal = '#93eebc',
          sky = '#7bf5f4',
          sapphire = '#6e76ae',
          blue = '#7bf5f4',
          lavender = '#6e76ae',
          text = '#b9b5d3',
          subtext1 = '#9e98bf',
          subtext0 = '#837ea7',
          overlay2 = '#6a648c',
          overlay1 = '#544f71',
          overlay0 = '#46415f',
          surface2 = '#3e3954',
          surface1 = '#332f46',
          surface0 = '#2c293d',
          base = '#262335',
          mantle = '#241b2f',
          crust = '#241b2f',
        },
      },
      dim_inactive = {
        enabled = true, -- dims the background color of inactive window
        shade = 'dark',
        percentage = 0.15, -- percentage of the shade to apply to the inactive window
      },
      terminal_colors = true,
    },
    config = function()
      vim.cmd.colorscheme 'catppuccin'
    end,
  },
}
