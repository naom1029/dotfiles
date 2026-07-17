-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  cmd = 'Neotree',
  keys = {
    { '\\', ':Neotree reveal<CR>', desc = 'NeoTree reveal', silent = true },
  },
  opts = {
    close_if_last_window = true,
    popup_border_style = 'rounded',
    source_selector = {
      winbar = true,
      sources = {
        { source = 'filesystem', display_name = ' Files' },
        { source = 'git_status', display_name = ' Git' },
        { source = 'buffers', display_name = '󰈙 Bufs' },
      },
    },
    default_component_configs = {
      indent = {
        padding = 0,
      },
      icon = {
        folder_closed = '',
        folder_open = '',
        folder_empty = '',
      },
      modified = {
        symbol = '●',
      },
      git_status = {
        symbols = {
          added = '',
          deleted = '',
          modified = '',
          renamed = '➜',
          untracked = '★',
          ignored = '◌',
          unstaged = '✗',
          staged = '✓',
          conflict = '',
        },
      },
    },
    window = {
      width = 30,
      mappings = {
        ['h'] = 'close_node',
        ['l'] = 'open',
        ['H'] = 'prev_source',
        ['L'] = 'next_source',
      },
    },
    filesystem = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      use_libuv_file_watcher = true,
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = true,
      },
      hijack_netrw_behavior = 'open_current',
      window = {
        mappings = {
          ['\\'] = 'close_window',
        },
      },
    },
  },
}
