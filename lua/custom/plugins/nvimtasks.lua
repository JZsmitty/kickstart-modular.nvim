return {
  'shatur/neovim-tasks',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'mfussenegger/nvim-dap',
  },
  config = function()
    require('tasks').setup({
      default_params = {
        cmake = {
          dap_name = "codelldb",
        }
      }
    })
  end
}
