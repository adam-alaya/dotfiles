-- TODO: i think i need to set up jest in the dap setup

require("jester").setup({
    -- cmd="npm run test -- $file",
    -- cmd="cross-env TZ='America/Toronto' node ./node_modules/.bin/jest --config test/jest.conf.js --runInBand",
    cmd="jest -t '$result' -- $file env=jsdom",
    terminal_cmd = "FloatermNew --autoclose=3",
    dap= {
       console="integratedTerminal",
       type = 'node2',
       request = 'launch',
       cwd = vim.fn.getcwd(),
       -- runtimeArgs = { 'cross-env TZ="America/Toronto"', 'node ./node_modules/.bin/jest', '--config', 'test/jest.conf.js', '--runInBand'},
       runtimeArgs = {'--inspect-brk', '$path_to_jest', '--no-coverage', '-t', '$result', '--', '$file', '--env=jsdom'},
       args = { '--no-cache' },
       sourceMaps = false,
       protocol = 'inspector',
       skipFiles = {'<node_internals>/**/*.js'},
       port = 9229,
       disableOptimisticBPs = true
    },
})

local dap = require('dap')
dap.adapters.node2 = {
  type = 'executable',
  command = 'node',
  args = {os.getenv('HOME') .. '/dev/microsoft/vscode-node-debug2/out/src/nodeDebug.js'},
}
dap.configurations.javascript = {
  {
    name = 'Launch',
    type = 'node2',
    request = 'launch',
    program = '${file}',
    cwd = vim.fn.getcwd(),
    sourceMaps = true,
    protocol = 'inspector',
    console = 'integratedTerminal',
  },
  {
    -- For this to work you need to make sure the node process is started with the `--inspect` flag.
    name = 'Attach to process',
    type = 'node2',
    request = 'attach',
    processId = require'dap.utils'.pick_process,
  },
}

-- vim.keymap.set("n", "<leader>tt", ':lua require"jester".run()<CR>')
vim.keymap.set("n", "<leader>tf", ':lua require"jester".run_file()<CR>')
vim.keymap.set("n", "<leader>tl", ':lua require"jester".run_last()<CR>')
vim.keymap.set("n", "<leader>tb", ':lua require"jester".debug()<CR>')
vim.keymap.set("n", "<leader>tg", ':lua require"jester".debug_file()<CR>')
vim.keymap.set("n", "<leader>tv", ':lua require"jester".debug_last()<CR>')

