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

        table.insert(require('dap').configurations.python, {
          type = 'python',
          request = 'attach',
          connect = {
            port = 5678,
            host = 'localhost',
          },
          mode = 'remote',
          name = 'Attach to Remote Python',
          cwd = vim.fn.getcwd(),
          pathmappings = {
            {
              localroot = vim.fn.getcwd(),
              remoteroot = '/data',
            },
          },
        })
      end,
    },
  },
  config = function(plugin, opts)
    require('nvim-dap-virtual-text').setup {
      commented = true,
    }

    local dap, dapui = require 'dap', require 'dapui'
    dapui.setup {}

    -- vim.fn.sign_define('DapBreakpoint', { text = '🛑', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpoint', { text = '\\ue602', texthl = '', linehl = '', numhl = '' })

    vim.fn.sign_define('DapStopped', { text = '🟢', texthl = '', linehl = '', numhl = '' })
    -- vim.fn.sign_define('DapBreakpointCondition', { text = '⛔', texthl = '', linehl = '', numhl = '' })
    -- vim.fn.sign_define('DapLogPoint', { text = '📍', texthl = '', linehl = '', numhl = '' })
    vim.fn.sign_define('DapBreakpointRejected', { text = '💀', texthl = '', linehl = '', numhl = '' })

    local dap_python = require 'dap-python'
    dap_python.setup '/usr/bin/python'
    dap_python.test_runner = 'pytest'
    dap_python.default_port = 5678
    -- dap_python.PathMappings = {
    --   RemoteRoot = '/data',
    --   LocalRoot = vim.fn.getcwd(),
    -- }

    table.insert(dap.configurations.python, {
      type = 'python',
      request = 'attach',
      name = 'Attach remote (with path mapping)',
      connect = function()
        local host = vim.fn.input 'Host [127.0.0.1]: '
        host = host ~= '' and host or '127.0.0.1'
        local port = tonumber(vim.fn.input 'Port [5678]: ') or 5678
        return { host = host, port = port }
      end,
      pathMappings = function()
        local cwd = '${workspaceFolder}'
        local local_path = vim.fn.input('Local path mapping [' .. cwd .. ']: ')
        local_path = local_path ~= '' and local_path or cwd
        local remote_path = vim.fn.input 'Remote path mapping [.]: '
        remote_path = remote_path ~= '' and remote_path or '.'
        return { { localRoot = local_path, remoteRoot = remote_path } }
      end,
    })

    table.insert(dap.configurations.python, 1, {
      type = 'python',
      request = 'attach',
      name = 'Attach remote (with default mapping)',
      connect = function()
        local host = '127.0.0.1'
        local port = 5678
        return { host = host, port = port }
      end,
      pathMappings = function()
        local local_path = '${workspaceFolder}'
        local remote_path = '.'
        return { { localRoot = local_path, remoteRoot = remote_path } }
      end,
    })

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
