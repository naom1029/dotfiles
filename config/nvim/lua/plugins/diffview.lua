-- diffview.nvim
-- Git差分表示とマージツール

return {
  -- 本家(sindrets)は2024-06以降停止しているため、活動中の後継フォークを使用
  "dlyongemallo/diffview-plus.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
  keys = {
    {
      "<leader>gD",
      function()
        local lib = require("diffview.lib")
        local dv = require("diffview")
        if lib.get_current_view() then
          dv.close()
        else
          dv.open()
        end
      end,
      desc = "Toggle [D]iffview (project-wide)",
    },
    { "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "Git file [H]istory" },
  },
  opts = {
    enhanced_diff_hl = true,
  },
}
