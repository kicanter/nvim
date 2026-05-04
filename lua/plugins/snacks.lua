return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    picker = { enabled = true },
    image = { enabled = true },
  },
  keys = {
    -- find
    { "<leader>fs", function() Snacks.picker.smart() end, desc = "Find Files [s]mart" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Find [b]uffers" },
    { "<leader>fc", function() Snacks.picker.files({ cwd = vim.fn.stdpath("config") }) end, desc = "Find Files [c]onfig" },
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Find Files cwd" },
    { "<leader>fg", function() Snacks.picker.git_files() end, desc = "Find [g]it Files" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Find Files [r]ecent" },
    -- grep
    { "<leader>sb", function() Snacks.picker.lines() end, desc = "Fuzzy Search in [b]uffer" },
    { "<leader>sB", function() Snacks.picker.grep_buffers() end, desc = "Grep Open [B]uffers" },
    { "<leader>ss", function() Snacks.picker.grep() end, desc = "Grep cwd" },
    { "<leader>sg", function() Snacks.picker.git_grep() end, desc = "Grep [g]it Files" },
    { "<leader>sw", function() Snacks.picker.grep_word() end, desc = "Search with Visual Selection or [w]ord", mode = { "n", "x" } },
    -- search
    { "<leader>sr", function() Snacks.picker.resume() end, desc = "Search [r]esume" },
    { "<leader>sh", function() Snacks.picker.help() end, desc = "Search [h]elp Pages" },
    { "<leader>sc", function() Snacks.picker.command_history() end, desc = "Search [c]ommand History" },
    { "<leader>sC", function() Snacks.picker.commands() end, desc = "Search [C]ommands" },
    { "<leader>sd", function() Snacks.picker.diagnostics_buffer() end, desc = "Search [d]iagnostics in Buffer" },
    { "<leader>sD", function() Snacks.picker.diagnostics() end, desc = "Search [D]iagnostics" },
    { "<leader>sj", function() Snacks.picker.jumps() end, desc = "Search [j]umps" },
    { "<leader>sk", function() Snacks.picker.keymaps() end, desc = "Search [k]eymaps" },
    { "<leader>sl", function() Snacks.picker.loclist() end, desc = "Search [l]ocation List" },
    { "<leader>sq", function() Snacks.picker.qflist() end, desc = "Search [q]uickfix List" },
    { "<leader>sM", function() Snacks.picker.man() end, desc = "Search [m]an Pages" },
    { "<leader>su", function() Snacks.picker.undo() end, desc = "Search [u]ndo History" },
    -- LSP
    { "grd", function() Snacks.picker.lsp_definitions() end, desc = "Goto LSP [d]efinition" },
    { "grD", function() Snacks.picker.lsp_declarations() end, desc = "Goto LSP [D]eclaration" },
    { "grr", function() Snacks.picker.lsp_references() end, nowait = true, desc = "Goto LSP [r]eferences" },
    { "gri", function() Snacks.picker.lsp_implementations() end, desc = "Goto LSP [i]mplementation" },
    { "grt", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto LSP [t]ype Definition" },
    { "grci", function() Snacks.picker.lsp_incoming_calls() end, desc = "Goto LSP [c]alls [i]ncoming" },
    { "grco", function() Snacks.picker.lsp_type_definitions() end, desc = "Goto LSP [c]alls [o]utgoing" },
    { "grs", function() Snacks.picker.lsp_symbols() end, desc = "LSP [s]ymbols" },
    { "grS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "LSP Workspace [S]ymbols" },
    -- Helpful for dev
    { "<leader>sH", function() Snacks.picker.highlights() end, desc = "Search [H]ighlights" },
    { "<leader>si", function() Snacks.picker.icons() end, desc = "Search [i]cons" },
    { "<leader>.",  function() Snacks.scratch() end, desc = "Toggle Scratch Buffer" },
  }
}
