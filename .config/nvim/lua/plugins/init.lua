local present, packer = pcall(require, "packer")
if not present then
    return
end

return packer.startup(function()
    -- packer
    use "wbthomason/packer.nvim"

    -- tree-sitter
    use {
        "nvim-treesitter/nvim-treesitter",
        run = function()
            require('nvim-treesitter.install').update({
                with_sync = true
            })
        end,
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = { "lua", "vim", "c" },
                auto_install = true,
                highlight = {
                    enable = true,
                },
            }
        end
    }

    -- completion
    use {
        "hrsh7th/nvim-cmp",
        requires = {
            { "hrsh7th/cmp-nvim-lsp" },
            --{ "hrsh7th/cmp-nvim-lua" },
            { "hrsh7th/cmp-buffer" },
            --{ "hrsh7th/cmp-path" },
            --{ "hrsh7th/cmp-cmdline" },
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup {
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    --{ name = "nvim_lua" },
                    --{ name = "path" },
                }, {
                    { name = "buffer" },
                }),
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                formatting = {
                    format = function(_, vim_item)
                        local icons = require("ui.icons").lspkind
                        vim_item.kind = string.format("%s %s", icons[vim_item.kind], vim_item.kind)
                        return vim_item
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<C-p>"] = cmp.mapping.select_prev_item(),
                    ["<C-n>"] = cmp.mapping.select_next_item(),
                    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
                    ["<C-f>"] = cmp.mapping.scroll_docs(4),
                    ["<C-Space>"] = cmp.mapping.complete(),
                    ["<C-e>"] = cmp.mapping.close(),
                    ["<CR>"] = cmp.mapping.confirm {
                        behavior = cmp.ConfirmBehavior.Replace,
                        select = false,
                    },
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        else
                            fallback()
                        end
                    end, {
                        "i",
                        "s",
                    }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        else
                            fallback()
                        end
                    end, {
                        "i",
                        "s",
                    }),
                }),
            }
        end
    }

    use {
        "L3MON4D3/LuaSnip",
        after = "nvim-cmp",
    }

    use {
        "saadparwaiz1/cmp_luasnip",
        after = "LuaSnip",
    }

    -- lsp
    use {
        "williamboman/nvim-lsp-installer",
        "neovim/nvim-lspconfig",
    }

    -- colorschemes
    use {
        "mcchrish/zenbones.nvim",
        requires = "rktjmp/lush.nvim"
    }

    use {
        "EdenEast/nightfox.nvim",
        config = function()
            require("nightfox").setup {
                options = {
                    transparent = true,
                }
            }
        end
    }

    -- telescope
    use {
        "nvim-telescope/telescope.nvim",
        requires = { { "nvim-lua/plenary.nvim" } },
        config = function()
            require("telescope").setup { }
            local mappings = {
                n = {
                    -- find
                    ["<leader>tf"] = { "<cmd> Telescope find_files <CR>", "  find files" },
                    ["<leader>ta"] = { "<cmd> Telescope find_files follow=true no_ignore=true hidden=true <CR>", "  find all" },
                    ["<leader>tg"] = { "<cmd> Telescope live_grep <CR>", "   live grep" },
                    ["<leader>tb"] = { "<cmd> Telescope buffers <CR>", "  find buffers" },
                    ["<leader>th"] = { "<cmd> Telescope help_tags <CR>", "  help page" },
                    ["<leader>to"] = { "<cmd> Telescope oldfiles <CR>", "   find oldfiles" },
                    ["<leader>tk"] = { "<cmd> Telescope keymaps <CR>", "   show keys" },
                    ["<leader>tc"] = { "<cmd> Telescope colorscheme <CR>", "   show keys" },
                    -- git
                    ["<leader>gc"] = { "<cmd> Telescope git_commits <CR>", "   git commits" },
                    ["<leader>gt"] = { "<cmd> Telescope git_status <CR>", "  git status" },
                },
            }
            require("utils").load_mappings(mappings)
        end
    }

    -- whichkey
    use {
        "folke/which-key.nvim",
        config = function()
            require("which-key").setup { }
        end
    }

    -- status line
    use {
        "nvim-lualine/lualine.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
        config = function()
            require("lualine").setup { }
        end
    }

    -- files tree
    use {
        "kyazdani42/nvim-tree.lua",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
        config = function()
            require("nvim-tree").setup {
                git = {
                    enable = true,
                    ignore = true,
                    timeout = 10000,
                },
                view = {
                    signcolumn = "yes",
                },
                renderer = {
                    icons = {
                        git_placement = "after",
                    },
                },
            }
            local mappings = {
                n = {
                    -- toggle
                    ["<C-n>"] = { "<cmd> NvimTreeToggle <CR>", "   toggle nvimtree" },
                    -- focus
                    ["<leader>e"] = { "<cmd> NvimTreeFocus <CR>", "   focus nvimtree" },
                },
            }
            require("utils").load_mappings(mappings)
        end
    }

    --[[
    -- tab bar
    use {
        "romgrk/barbar.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
        config = function()
            require("bufferline").setup { }
        end
    }
    ]]--

    -- diags
    use {
        "folke/trouble.nvim",
        requires = { "kyazdani42/nvim-web-devicons", opt = true },
        config = function()
            require("trouble").setup { }
        end
    }

    -- indentation
    use {
        "lukas-reineke/indent-blankline.nvim",
        config = function()
            require("indent_blankline").setup {
                show_current_context = true,
                max_indent_increase = 1,
                filetype = { "python" },
            }
        end
    }

    -- note taking
    use {
        "jakewvincent/mkdnflow.nvim",
        config = function()
            require("mkdnflow").setup {
                links = {
                    style = "wiki",
                    conceal = false,
                },
            }
        end
    }
end)
