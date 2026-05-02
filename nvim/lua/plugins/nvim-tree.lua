return {
  {
    'nvim-tree/nvim-tree.lua',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup {
        hijack_netrw = true,
        sync_root_with_cwd = true,
        update_focused_file = {
          enable = true,
          update_root = true,
        },
        view = {
          width = 34,
        },
        renderer = {
          group_empty = true,
        },
        filters = {
          dotfiles = false,
        },
      }

      vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle file tree' })
      vim.keymap.set('n', '<leader>o', '<cmd>NvimTreeFocus<CR>', { desc = 'Focus file tree' })

      -- run nvim-tree on startup
      local api = require 'nvim-tree.api'
      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          api.tree.open()
        end,
      })
    end,
  },
}
