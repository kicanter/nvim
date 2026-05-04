return {
    -- Treesitter ===============================================================
    {
        "nvim-treesitter/nvim-treesitter",
        branch = "main",
        commit = "90cd6580",
        lazy = false,
        config = function()
            local ensure_installed = {
                "bash",
                "c",
                "cpp",
                "css",
                "html",
                "javascript",
                "json",
                "go",
                "nu",
                "python",
                "regex",
                "rust",
                "toml",
                "tsx",
                "vimdoc",
                "yaml",
                "zsh",
                "zig",
            }

            local isnt_installed = function(lang)
                return #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".*", false) == 0
            end

            local to_install = vim.tbl_filter(isnt_installed, ensure_installed)

            if #to_install > 0 then
                require("nvim-treesitter").install(to_install)
            end

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(args)
                    local buf, filetype = args.buf, args.match

                    local language = vim.treesitter.language.get_lang(filetype)
                    if not language then
                        return
                    end

                    -- check if parser exists and load it
                    if not vim.treesitter.language.add(language) then
                        return
                    end
                    -- enables syntax highlighting and other treesitter features
                    vim.treesitter.start(buf, language)

                    -- enables treesitter based indentation
                    vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end,
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
    },

    -- Mason ===================================================================
    {
        "mason-org/mason.nvim",
        opts = {},
    },

    -- Formatting ===============================================================
    {
        "stevearc/conform.nvim",
        lazy = true,
        cmd = { "ConformInfo" },
        event = "BufWritePre",
        keys = {
            {
                "<leader>F",
                function()
                    require("conform").format({ async = true, lsp_format = "fallback" })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        opts = {
            formatters_by_ft = {
                lua = { "stylua" },
            },
        },
    },

    -- LSP =====================================================================
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "folke/lazydev.nvim",
        },
        lazy = true,
        event = { "BufReadPre", "BufNewFile" },
        config = function()
            vim.api.nvim_create_autocmd("LspAttach", {
                group = vim.api.nvim_create_augroup("kicanter-lsp-attach", { clear = true }),
                callback = function(event)
                    local map = function(keys, func, desc, mode)
                        mode = mode or "n"
                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                    end

                    vim.keymap.set(
                        { "n" },
                        "grn",
                        vim.lsp.buf.rename,
                        { buffer = event.buf, desc = "LSP: re[n]ame symbol" }
                    )
                    vim.keymap.set(
                        { "n", "x" },
                        "gra",
                        vim.lsp.buf.code_action,
                        { buffer = event.buf, desc = "LSP: code [a]ction" }
                    )

                    -- Highlight references of the word under your cursor when your cursor rests there for a little
                    -- while. When you move your cursor, the highlights will be cleared (the second autocommand).
                    local client = vim.lsp.get_client_by_id(event.data.client_id)
                    if client and client:supports_method("textDocument/documentHighlight", event.buf) then
                        local highlight_augroup =
                            vim.api.nvim_create_augroup("kicanter-lsp-highlight", { clear = false })
                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.document_highlight,
                        })

                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                            buffer = event.buf,
                            group = highlight_augroup,
                            callback = vim.lsp.buf.clear_references,
                        })

                        vim.api.nvim_create_autocmd("LspDetach", {
                            group = vim.api.nvim_create_augroup("kicanter-lsp-detach", { clear = true }),
                            callback = function(event2)
                                vim.lsp.buf.clear_references()
                                vim.api.nvim_clear_autocmds({ group = "kicanter-lsp-highlight", buffer = event2.buf })
                            end,
                        })
                    end

                    -- Toggle inlay hints
                    if client and client:supports_method("textDocument/inlayHint", event.buf) then
                        map("<leader>th", function()
                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                        end, "[T]oggle Inlay [H]ints")
                    end

                    -- Switch between header and impl for C & C++
                    if client and client.name == "clangd" then
                        map("grh", "<cmd>LspClangdSwitchSourceHeader<cr>", "switch source/[h]eader")
                    end
                end,
            })

            -- Diagnostics configuration
            vim.diagnostic.config({
                severity_sort = true,
                float = { border = "rounded", source = true },
                underline = { severity = vim.diagnostic.severity.ERROR },
                signs = vim.g.have_nerd_font and {
                    text = {
                        [vim.diagnostic.severity.ERROR] = "󰅚 ",
                        [vim.diagnostic.severity.WARN] = "󰀪 ",
                        [vim.diagnostic.severity.INFO] = "󰋽 ",
                        [vim.diagnostic.severity.HINT] = "󰌶 ",
                    },
                } or {},
                virtual_text = {
                    source = "if_many",
                    spacing = 2,
                    format = function(diagnostic)
                        local diagnostic_message = {
                            [vim.diagnostic.severity.ERROR] = diagnostic.message,
                            [vim.diagnostic.severity.WARN] = diagnostic.message,
                            [vim.diagnostic.severity.INFO] = diagnostic.message,
                            [vim.diagnostic.severity.HINT] = diagnostic.message,
                        }
                        return diagnostic_message[diagnostic.severity]
                    end,
                },
            })

            -- Server configurations
            local servers = {
                clangd = {
                    cmd = {
                        "clangd",
                        "--background-index",
                        "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                        "--function-arg-placeholders=true",
                    },
                    root_markers = { ".clang-format", "compile_commands.json" },
                    capabilities = {
                        textDocument = {
                            completion = {
                                completionItem = {
                                    snippetSupport = true,
                                },
                            },
                        },
                    },
                },
                cmake = {},
                lua_ls = {
                    settings = {
                        Lua = {
                            runtime = {
                                version = "LuaJIT",
                                path = { "lua/?.lua", "lua/?/init.lua" },
                            },
                        },
                    },
                },
                pyright = {},
                rust_analyzer = {},
                stylua = {},
            }

            -- configure servers with custom configs and install all listed above
            for name, conf in pairs(servers) do
                if next(conf) ~= nil then
                    vim.lsp.config(name, conf)
                end
                vim.lsp.enable(name)
            end
        end,
    },
}

--return {
--    {
--        "folke/lazydev.nvim",
--        ft = "lua",
--        opts = {
--            library = {
--                { path = "${3rd}/luv/library", words = { "vim%.uv" } },
--            },
--        },
--    },
--    {
--        -- Main LSP Configuration
--        "neovim/nvim-lspconfig",
--        dependencies = {
--            { "mason-org/mason.nvim", opts = {} },
--            "mason-org/mason-lspconfig.nvim",
--            "WhoIsSethDaniel/mason-tool-installer.nvim",
--            { "j-hui/fidget.nvim", opts = {} },
--            "saghen/blink.cmp",
--        },
--        config = function()
--            vim.api.nvim_create_autocmd("LspAttach", {
--                group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
--                callback = function(event)
--                    local map = function(keys, func, desc, mode)
--                        mode = mode or "n"
--                        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP " .. desc })
--                    end
--
--                    map("grn", vim.lsp.buf.rename, "[r]ename")
--                    map("gra", vim.lsp.buf.code_action, "code [a]ction")
--
--                    ---@param client vim.lsp.Client
--                    ---@param method vim.lsp.protocol.Method
--                    ---@param bufnr? integer
--                    ---@return boolean
--                    local function client_supports_method(client, method, bufnr)
--                        if vim.fn.has("nvim-0.11") == 1 then
--                            return client:supports_method(method, bufnr)
--                        else
--                            return client.supports_method(method, { bufnr = bufnr })
--                        end
--                    end
--
--                    local client = vim.lsp.get_client_by_id(event.data.client_id)
--                    if
--                        client
--                        and client_supports_method(
--                            client,
--                            vim.lsp.protocol.Methods.textDocument_documentHighlight,
--                            event.buf
--                        )
--                    then
--                        local highlight_augroup =
--                            vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
--                        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
--                            buffer = event.buf,
--                            group = highlight_augroup,
--                            callback = vim.lsp.buf.document_highlight,
--                        })
--
--                        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
--                            buffer = event.buf,
--                            group = highlight_augroup,
--                            callback = vim.lsp.buf.clear_references,
--                        })
--
--                        vim.api.nvim_create_autocmd("LspDetach", {
--                            group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
--                            callback = function(event2)
--                                vim.lsp.buf.clear_references()
--                                vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
--                            end,
--                        })
--                    end
--
--
--                    if
--                        client
--                        and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
--                    then
--                        map("<leader>th", function()
--                            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
--                        end, "[T]oggle Inlay [H]ints")
--                    end
--                end,
--            })
--
--            vim.diagnostic.config({
--                severity_sort = true,
--                float = { border = "rounded", source = "if_many" },
--                underline = { severity = vim.diagnostic.severity.ERROR },
--                signs = vim.g.have_nerd_font and {
--                    text = {
--                        [vim.diagnostic.severity.ERROR] = "󰅚 ",
--                        [vim.diagnostic.severity.WARN] = "󰀪 ",
--                        [vim.diagnostic.severity.INFO] = "󰋽 ",
--                        [vim.diagnostic.severity.HINT] = "󰌶 ",
--                    },
--                } or {},
--                virtual_text = {
--                    source = "if_many",
--                    spacing = 2,
--                    format = function(diagnostic)
--                        local diagnostic_message = {
--                            [vim.diagnostic.severity.ERROR] = diagnostic.message,
--                            [vim.diagnostic.severity.WARN] = diagnostic.message,
--                            [vim.diagnostic.severity.INFO] = diagnostic.message,
--                            [vim.diagnostic.severity.HINT] = diagnostic.message,
--                        }
--                        return diagnostic_message[diagnostic.severity]
--                    end,
--                },
--            })
--
--            local capabilities = require("blink.cmp").get_lsp_capabilities()
--            local servers = {
--                clangd = {
--                },
--                cmake = {},
--                lua_ls = {
--                    settings = {
--                        Lua = {
--                            completion = {
--                                callSnippet = "Replace",
--                            },
--                        },
--                    },
--                },
--            }
--            local ensure_installed = vim.tbl_keys(servers or {})
--            vim.list_extend(ensure_installed, {})
--            require("mason-tool-installer").setup({ ensure_installed = ensure_installed })
--
--            require("mason-lspconfig").setup({
--                ensure_installed = {},
--                automatic_installation = false,
--                handlers = {
--                    function(server_name)
--                        local server = servers[server_name] or {}
--                        server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
--                        require("lspconfig")[server_name].setup(server)
--                    end,
--                },
--            })
--        end,
--    },
--}
