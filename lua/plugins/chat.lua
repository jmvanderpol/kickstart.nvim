return {
  {
    'shadmansaleh/IRC.nvim',
    event = 'VimEnter',
    rocks = {
      'openssl',
    },
    config = function()
      local ircNick = vim.env.PICO_IRC_NICK
      local ircUser = vim.env.PICO_IRC_USER
      local ircPass = vim.env.PICO_IRC_PASS
      require('irc').setup {
        servers = {
          pico = {
            nick = ircNick,
            username = ircUser,
            password = ircPass,
            server = 'irc.pico.sh',
            port = 6697,
            use_ssl = false,
          },
        },
      }
    end,
  },
}
