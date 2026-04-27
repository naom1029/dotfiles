-- diffview.nvim
-- Git差分表示とマージツール

return {
  "sindrets/diffview.nvim",
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
