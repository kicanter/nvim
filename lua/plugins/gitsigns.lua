return {
    {
        "lewis6991/gitsigns.nvim",
        opts = {
            signs = {
                add = { text = "+" },
                change = { text = "~" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
            on_attach = function(bufnr)
                local gitsigns = require("gitsigns")

                local function map(mode, keys, func, desc)
                    vim.keymap.set(mode, keys, func, { buffer = bufnr, desc = "[g]it: " .. desc })
                end

                -- Navigation
                vim.keymap.set("n", "]g", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "]g", bang = true })
                    else
                        gitsigns.nav_hunk("next")
                    end
                end, { desc = "Jump to next [g]it hunk" })

                vim.keymap.set("n", "[g", function()
                    if vim.wo.diff then
                        vim.cmd.normal({ "[g", bang = true })
                    else
                        gitsigns.nav_hunk("prev")
                    end
                end, { desc = "Jump to previous [g]it hunk" })

                -- Actions --

                -- visual mode
                map("v", "<leader>gs", function()
                    gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "[s]tage hunk")
                map("v", "<leader>gr", function()
                    gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
                end, "[r]eset hunk")

                -- normal mode
                map("n", "<leader>gs", gitsigns.stage_hunk, "[s]tage hunk")
                map("n", "<leader>gr", gitsigns.reset_hunk, "[r]eset hunk")
                map("n", "<leader>gS", gitsigns.stage_buffer, "[S]tage buffer")
                map("n", "<leader>gu", gitsigns.stage_hunk, "[u]ndo stage hunk")
                map("n", "<leader>gR", gitsigns.reset_buffer, "[R]eset buffer")
                map("n", "<leader>gp", gitsigns.preview_hunk, "[p]review hunk")
                map("n", "<leader>gb", gitsigns.blame_line, "[b]lame line")
                -- use count to diff against HEAD~<count> commit e.g. `2<leader>gd` for HEAD~2
                map("n", "<leader>gd", function()
                    local count = vim.v.count
                    if count == 0 then
                        vim.notify("Diff against HEAD", vim.log.levels.INFO)
                        return gitsigns.diffthis()
                    else
                        vim.notify("Diff against HEAD~" .. count, vim.log.levels.INFO)
                        return gitsigns.diffthis("~" .. count)
                    end
                end, "[d]iff against")
                map("n", "<leader>gD", function()
                    gitsigns.diffthis("@")
                end, "[D]iff against last commit")
                map("n", "<leader>gq", gitsigns.setqflist, "set [q]uickfix list for current file")
                map("n", "<leader>gQ", function()
                    gitsigns.setqflist("all")
                end, "set [Q]uickfix list for all files")

                -- Trigger vim search for conflict markers
                map("n", "<leader>g/", function()
                    local conflict_start = "<<<<<<<"
                    local conflict_middle = "======="
                    local conflict_end = ">>>>>>>"
                    local markers = table.concat({ conflict_start, conflict_middle, conflict_end }, "\\|")

                    vim.fn.setreg("/", markers)
                    local ok = pcall(vim.api.nvim_exec2, "normal! n", {})
                    if not ok then
                        vim.notify(string.format("No git conflicts in current file."), vim.log.levels.WARN)
                    end
                end, "search for conflict markers")

                -- Toggles
                vim.keymap.set("n", "<leader>gtb", gitsigns.blame, { desc = "[t]oggle [b]lame" })
                vim.keymap.set("n", "<leader>gtw", gitsigns.toggle_word_diff, { desc = "[t]oggle [w]ord diff" })
                vim.keymap.set("n", "<leader>gtd", gitsigns.preview_hunk_inline, { desc = "[t]oggle show [d]eleted" })
            end,
        },
    },
}
