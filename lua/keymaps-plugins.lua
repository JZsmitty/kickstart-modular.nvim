local function map(mode, l, r, textdesc)
  vim.keymap.set(mode, l, r, { desc = textdesc })
end

local nmap = function(keys, func, desc, bufnr)
  if desc then
    desc = 'LSP: ' .. desc
  end
  vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
end

local function bmap(mode, l, r, opts, bufnr)
  opts = opts or {}
  opts.buffer = bufnr
  vim.keymap.set(mode, l, r, opts)
end

local Mappings = {}
--[[
Mappings.addDap = function()
  local dap = require 'dap'
  map('n', '<F5>', dap.continue, 'Debug: Start/Continue')
  map('n', '<F10>', dap.step_over, 'Debug: Step Over')
  map('n', '<F11>', dap.step_into, 'Debug: Step Into')
  map('n', '<F12>', dap.step_out, 'Debug: Step Out')
  map('n', '<Leader>b', dap.toggle_breakpoint, 'Debug: Toggle Breakpoint')
  map('n', '<Leader>B', dap.set_breakpoint, 'Debug: Set Breakpoint')
  map('n', '<Leader>lp', function() dap.set_breakpoint(nil, nil, vim.fn.input('Log point message: ')) end,
    'Debug: Set Breakpoint msg')
  map('n', '<Leader>dr', dap.repl.open, 'Debug: Repl Open')
  map('n', '<Leader>dl', dap.run_last, 'Debug: Run Last')
  map({ 'n', 'v' }, '<Leader>dh', require('dap.ui.widgets').hover, 'Debug: Hover')
  map({ 'n', 'v' }, '<Leader>dp', require('dap.ui.widgets').preview, 'Debug: Preview')
  map('n', '<Leader>df', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.frames)
    end,
    'Debug: Centered Float Frame')
  map('n', '<Leader>ds', function()
      local widgets = require('dap.ui.widgets')
      widgets.centered_float(widgets.scopes)
    end,
    'Debug: Centered Float Scope')
  print 'keymaps-plugins: Added Dap mappings'
end

Mappings.addDapUi = function()
  local dapui = require 'dapui'
  -- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
  map('n', '<F7>', dapui.toggle, 'Debug: See last session result.')
  print 'keymaps-plugins: Added DapUi mappings'
end
--]]
Mappings.addLsp = function(bufnr)
  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame', bufnr)
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', bufnr)

  nmap('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition', bufnr)
  nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences', bufnr)
  nmap('gI', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation', bufnr)
  nmap('<leader>D', require('telescope.builtin').lsp_type_definitions, 'Type [D]efinition', bufnr)
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols', bufnr)
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols', bufnr)

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation', bufnr)
  nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation', bufnr)

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration', bufnr)
  nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder', bufnr)
  nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder', bufnr)
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders', bufnr)
  print 'keymaps-plugins: Added Lsp mappings'
end

Mappings.addTelescope = function()
  -- See `:help telescope.builtin`
  map('n', '<leader>?', require('telescope.builtin').oldfiles, '[?] Find recently opened files')
  map('n', '<leader><space>', require('telescope.builtin').buffers, '[ ] Find existing buffers')
  map('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
      winblend = 10,
      previewer = false,
    })
  end, '[/] Fuzzily search in current buffer')

  local function telescope_live_grep_open_files()
    require('telescope.builtin').live_grep {
      grep_open_files = true,
      prompt_title = 'Live Grep in Open Files',
    }
  end
  map('n', '<leader>s/', telescope_live_grep_open_files, '[S]earch [/] in Open Files')
  map('n', '<leader>ss', require('telescope.builtin').builtin, '[S]earch [S]elect Telescope')
  map('n', '<leader>gf', require('telescope.builtin').git_files, 'Search [G]it [F]iles')
  map('n', '<leader>sf', require('telescope.builtin').find_files, '[S]earch [F]iles')
  map('n', '<leader>sh', require('telescope.builtin').help_tags, '[S]earch [H]elp')
  map('n', '<leader>sw', require('telescope.builtin').grep_string, '[S]earch current [W]ord')
  map('n', '<leader>sg', require('telescope.builtin').live_grep, '[S]earch by [G]rep')
  map('n', '<leader>sG', ':LiveGrepGitRoot<cr>', '[S]earch by [G]rep on Git Root')
  map('n', '<leader>sd', require('telescope.builtin').diagnostics, '[S]earch [D]iagnostics')
  map('n', '<leader>sr', require('telescope.builtin').resume, '[S]earch [R]esume')
  -- print 'keymaps-plugins: Added Telescope mappings'
end

Mappings.addGitSigns = function(bufnr)
  local gs = package.loaded.gitsigns

  -- Navigation
  bmap({ 'n', 'v' }, ']c', function()
    if vim.wo.diff then
      return ']c'
    end
    vim.schedule(function()
      gs.next_hunk()
    end)
    return '<Ignore>'
  end, { expr = true, desc = 'Jump to next hunk' }, bufnr)

  bmap({ 'n', 'v' }, '[c', function()
    if vim.wo.diff then
      return '[c'
    end
    vim.schedule(function()
      gs.prev_hunk()
    end)
    return '<Ignore>'
  end, { expr = true, desc = 'Jump to previous hunk' }, bufnr)

  -- Actions
  -- visual mode
  bmap('v', '<leader>hs', function()
    gs.stage_hunk { vim.fn.line '.', vim.fn.line 'v' }
  end, { desc = 'stage git hunk' }, bufnr)
  bmap('v', '<leader>hr', function()
    gs.reset_hunk { vim.fn.line '.', vim.fn.line 'v' }
  end, { desc = 'reset git hunk' }, bufnr)
  -- normal mode
  bmap('n', '<leader>hs', gs.stage_hunk, { desc = 'git stage hunk' }, bufnr)
  bmap('n', '<leader>hr', gs.reset_hunk, { desc = 'git reset hunk' }, bufnr)
  bmap('n', '<leader>hS', gs.stage_buffer, { desc = 'git Stage buffer' }, bufnr)
  bmap('n', '<leader>hu', gs.undo_stage_hunk, { desc = 'undo stage hunk' }, bufnr)
  bmap('n', '<leader>hR', gs.reset_buffer, { desc = 'git Reset buffer' }, bufnr)
  bmap('n', '<leader>hp', gs.preview_hunk, { desc = 'preview git hunk' }, bufnr)
  bmap('n', '<leader>hb', function()
    gs.blame_line { full = false }
  end, { desc = 'git blame line' }, bufnr)
  bmap('n', '<leader>hd', gs.diffthis, { desc = 'git diff against index' }, bufnr)
  bmap('n', '<leader>hD', function()
    gs.diffthis '~'
  end, { desc = 'git diff against last commit' }, bufnr)

  -- Toggles
  bmap('n', '<leader>tb', gs.toggle_current_line_blame, { desc = 'toggle git blame line' }, bufnr)
  bmap('n', '<leader>td', gs.toggle_deleted, { desc = 'toggle git show deleted' }, bufnr)

  -- Text object
  bmap({ 'o', 'x' }, 'ih', ':<C-U>Gitsigns select_hunk<CR>', { desc = 'select git hunk' }, bufnr)
  -- print 'keymaps-plugins: Added GitSigns mappings'
end

Mappings.addObsidian = function()
  map('n', '<leader>mf', require('obsidian').util.gf_passthrough(), '[M]bsidian goto [F]ile')
  map('n', '<leader>mc', require('obsidian').util.toggle_checkbox(), '[M]bsidian [C]heckbox')
  map('n', '<leader>mn', ":ObsidianSearch", '[M]bsidian [N]ew')
  map('n', '<leader>me', ":ObsidianLink", '[M]bsidian link [E]xisting')
  map('n', '<leader>ml', ":ObsidianLinkNew", '[M]bsidian [L]ink new')
  map('n', '<leader>mt', ":ObsidianTemplate", '[M]bsidian [T]emplate')
  map('n', '<leader>mo', 'lua print("hello")', '[M]bsidian [O]pen')
end

return Mappings
