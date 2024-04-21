local M = {
  'mfussenegger/nvim-dap',
  dependencies = {
    { 'rcarriga/nvim-dap-ui' },
    { 'theHamsta/nvim-dap-virtual-text' },
    { 'nvim-telescope/telescope-dap.nvim' },
    { 'jbyuki/one-small-step-for-vimkind' },
    { 'mfussenegger/nvim-dap-python' },
  },
  -- stylua: ignore
  keys = {
    { "<leader>dR", function() require("dap").run_to_cursor() end, desc = "Run to Cursor", },
    { "<leader>dE", function() require("dapui").eval(vim.fn.input "[Expression] > ") end, desc = "Evaluate Input", },
    { "<leader>dC", function() require("dap").set_breakpoint(vim.fn.input "[Condition] > ") end, desc = "Conditional Breakpoint", },
    { "<leader>dU", function() require("dapui").toggle() end, desc = "Toggle UI", },
    { "<leader>db", function() require("dap").step_back() end, desc = "Step Back", },
    { "<leader>dc", function() require("dap").continue() end, desc = "Continue", },
    { "<leader>dd", function() require("dap").disconnect() end, desc = "Disconnect", },
    { "<leader>de", function() require("dapui").eval() end, mode = {"n", "v"}, desc = "Evaluate", },
    { "<leader>dg", function() require("dap").session() end, desc = "Get Session", },
    { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Hover Variables", },
    { "<leader>dS", function() require("dap.ui.widgets").scopes() end, desc = "Scopes", },
    { "<leader>di", function() require("dap").step_into() end, desc = "Step Into", },
    { "<leader>do", function() require("dap").step_over() end, desc = "Step Over", },
    { "<leader>dp", function() require("dap").pause.toggle() end, desc = "Pause", },
    { "<leader>dq", function() require("dap").close() end, desc = "Quit", },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle REPL", },
    { "<leader>ds", function() require("dap").continue() end, desc = "Start", },
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint", },
    { "<leader>dx", function() require("dap").terminate() end, desc = "Terminate", },
    { "<leader>du", function() require("dap").step_out() end, desc = "Step Out", },
  },
  opts = {
    setup = {
      osv = function(_, _)
        require('adam.plugins.dap.lua').setup()
      end,

      debugpy = function(_, _)
        -- local dap_python = require 'dap-python'
        --
        -- dap_python.setup('python', {})
        --
        -- dap_python.setup '/usr/bin/python'
        -- dap_python.test_runner = 'pytest'
        -- dap_python.default_port = 5678

        -- table.insert(require('dap').configurations.python, {
        --   type = 'python',
        --   request = 'attach',
        --   connect = {
        --     port = 5678,
        --     host = '127.0.0.1',
        --   },
        --   mode = 'remote',
        --   name = 'container attach debug',
        --   cwd = vim.fn.getcwd(),
        --   pathmappings = {
        --     {
        --       localroot = function()
        --         return vim.fn.input('local code folder > ', vim.fn.getcwd(), 'file')
        --       end,
        --       remoteroot = function()
        --         return vim.fn.input('container code folder > ', '/data', 'file')
        --       end,
        --     },
        --   },
        -- })

        -- require('dap').adapters.python = function(cb, config)
        --   if config.request == 'attach' then
        --     local port = (config.connect or config).port
        --     cb {
        --       type = 'server',
        --       port = assert(port, '`connect.port` is required for a python `attach` configuration'),
        --       host = (config.connect or config).host or '127.0.0.1',
        --       enrich_config = enrich_config,
        --       options = {
        --         source_filetype = 'python',
        --       },
        --     }
        --   else
        --     cb {
        --       type = 'executable',
        --       command = adapter_python_path,
        --       args = { '-m', 'debugpy.adapter' },
        --       enrich_config = enrich_config,
        --       options = {
        --         source_filetype = 'python',
        --       },
        --     }
        --   end
        -- end
      end,
    },
  },
  config = function(plugin, opts)
    require('nvim-dap-virtual-text').setup {
      commented = true,
    }

    local dap, dapui = require 'dap', require 'dapui'
    dapui.setup {}

    vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapStopped', { text = '🟢', texthl = '', linehl = '', numhl = '' })
    -- vim.fn.sign_define('DapBreakpointCondition', { text = '⛔', texthl = '', linehl = '', numhl = '' })
    -- vim.fn.sign_define('DapLogPoint', { text = '📍', texthl = '', linehl = '', numhl = '' })
    -- vim.fn.sign_define('DapBreakpointRejected', { text = '💀', texthl = '', linehl = '', numhl = '' })

    local dap_python = require 'dap-python'
    dap_python.setup '/usr/bin/python'
    dap_python.test_runner = 'pytest'
    dap_python.default_port = 5678

    dap.set_log_level 'TRACE'

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    require('adam.plugins.dap.lua').setup()

    -- set up debugger
    for k, _ in pairs(opts.setup) do
      opts.setup[k](plugin, opts)
    end
  end,
}

return M

-- return { -- dap debugging {{{
--   'mfussenegger/nvim-dap',
--   lazy = true,
--   dependencies = {
--     { 'mfussenegger/nvim-dap-python' },
--     { 'theHamsta/nvim-dap-virtual-text' },
--     { 'nvim-telescope/telescope-dap.nvim' },
--     { 'rcarriga/nvim-dap-ui' },
--     -- { 'jbyuki/one-small-step-for-vimkind' },
--   },
--   keys = {
--
--     {
--       '<leader>dc',
--       function()
--         require('dap').continue()
--       end,
--       desc = 'continue',
--     },
--
--     {
--       '<leader>dU',
--       function()
--         require('dapui').toggle()
--       end,
--       desc = 'Toggle UI',
--     },
--
--     {
--       '<leader>ds',
--       function()
--         require('dap').continue()
--       end,
--       desc = 'Start',
--     },
--     {
--       '<leader>dl',
--       function()
--         require('dap').run_last()
--       end,
--       desc = 'run last',
--     },
--     {
--       '<leader>dq',
--       function()
--         require('dap').terminate()
--       end,
--       desc = 'terminate',
--     },
--     {
--       '<leader>dh',
--       function()
--         require('dap').stop()
--       end,
--       desc = 'stop',
--     },
--     {
--       '<leader>dn',
--       function()
--         require('dap').step_over()
--       end,
--       desc = 'step over',
--     },
--     {
--       '<leader>ds',
--       function()
--         require('dap').step_into()
--       end,
--       desc = 'step into',
--     },
--     {
--       '<leader>dS',
--       function()
--         require('dap').step_out()
--       end,
--       desc = 'step out',
--     },
--     {
--       '<leader>db',
--       function()
--         require('dap').toggle_breakpoint()
--       end,
--       desc = 'toggle br',
--     },
--     {
--       '<leader>dB',
--       function()
--         require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
--       end,
--       desc = 'set br condition',
--     },
--     {
--       '<leader>dp',
--       function()
--         require('dap').set_breakpoint(nil, nil, vim.fn.input 'Log point message: ')
--       end,
--       desc = 'set log br',
--     },
--     {
--       '<leader>dr',
--       function()
--         require('dap').repl.open()
--       end,
--       desc = 'REPL open',
--     },
--     {
--       '<leader>dk',
--       function()
--         require('dap').up()
--       end,
--       desc = 'up callstack',
--     },
--     {
--       '<leader>dj',
--       function()
--         require('dap').down()
--       end,
--       desc = 'down callstack',
--     },
--     {
--       '<leader>di',
--       function()
--         require('dap.ui.widgets').hover()
--       end,
--       desc = 'info',
--     },
--     -- ['?'] = { '<Cmd>lua local widgets=require"dap.ui.widgets";widgets.centered_float(widgets.scopes)<CR>', 'scopes' },
--     -- { "<leader>f", '<Cmd>Telescope dap frames<CR>', 'search frames' },
--     -- { "<leader>C", '<Cmd>Telescope dap commands<CR>', 'search commands' },
--     -- { "<leader>L", '<Cmd>Telescope dap list_breakpoints<CR>', 'search breakpoints' },
--   },
--   config = function()
--     local dap = require 'dap'
--     vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
--     vim.fn.sign_define('DapStopped', { text = '🚏', texthl = '', linehl = '', numhl = '' })
--     dap.defaults.fallback.terminal_win_cmd = 'tabnew'
--     dap.defaults.fallback.focus_terminal = true
--
--     local dap_python = require 'dap-python'
--     dap_python.setup '/usr/bin/python'
--     dap_python.test_runner = 'pytest'
--     dap_python.default_port = 38000
--
--     dap.listeners.after.event_initialized['dapui_config'] = function()
--       require('dapui').open()
--     end
--     dap.listeners.before.event_terminated['dapui_config'] = function()
--       require('dapui').close()
--     end
--     dap.listeners.before.event_exited['dapui_config'] = function()
--       require('dapui').close()
--     end
--   end,
-- }
