return {
  "elentok/format-on-save.nvim",
  config = function()
    local format_on_save = require("format-on-save")
    local formatters = require("format-on-save.formatters")

    format_on_save.setup({
      experiments = {
        partial_update = 'diff',
      },
      formatter_by_ft = {
        markdown = formatters.shell({
          cmd = { "prettierd", "%" }
        }),
      },
      run_with_sh = false,
    })
  end,
}
