--[[
 To install packer:
  git clone --depth 1 https://github.com/wbthomason/packer.nvim \
     ~/.local/share/nvim/site/pack/packer/start/packer.nvim
--]]

require "plugins"

--
-- Config options
--
vim.opt.autochdir = true
vim.opt.cinoptions = "g0,t0,Ws,m1,:0"
vim.opt.completeopt = "menu,menuone,noselect"
vim.opt.ignorecase = true
vim.opt.mouse = "nv"
vim.opt.smartcase = true
vim.opt.updatecount = 0

--
-- Autocommands
--
local autocmd = vim.api.nvim_create_autocmd

autocmd("FileType", {
    pattern = { "text", "tex" },
    command = "setlocal textwidth=80",
})

autocmd("FileType", {
    pattern = { "cpp", "lua", "javascript", "qmljs" },
    command = "setlocal sw=4 sts=4 et",
})

autocmd("FileType", {
    pattern = { "perl" },
    command = "setlocal sw=2 et",
})

autocmd({ "BufNewFile", "BufRead" }, {
    pattern = { "*.qml" },
    command = "setlocal ft=qmljs",
})

--
-- UI
--
vim.opt.background = "dark"
vim.opt.signcolumn = "no"
vim.opt.laststatus = 3
vim.opt.list = true
vim.opt.listchars:append("tab:>-")
vim.opt.listchars:append("nbsp:␣")
vim.opt.listchars:append("trail:⋅")
vim.api.nvim_exec('hi default link TrailSpace Error', false)
vim.fn.matchadd('Trailspace', [[\s\+$]])

vim.g.zenbones = { transparent_background = true, darkness = 'stark', lighten_non_text = 12 }
vim.g.rosebones = { transparent_background = true, darkness = 'stark', lighten_non_text = 4 }
vim.g.nordbones = { transparent_background = true, darkness = 'stark', lighten_non_text = 4 }
vim.g.neobones = { transparent_background = true, darkness = 'warm', lighten_non_text = 4 }
vim.g.forestbones = { transparent_background = true, darkness = 'stark', lighten_non_text = 4 }
vim.g.seoulbones = { transparent_background = true, darkness = 'warm', lighten_non_text = 4 }
vim.g.tokyobones = { transparent_background = true, darkness = 'warm', lighten_non_text = 4 }

if pcall(vim.cmd, "colorscheme tokyobones") then
    vim.opt.termguicolors = true
end

local present, lsp_installer = pcall(require, "nvim-lsp-installer")
if present then
    lsp_installer.setup()
end

local present, lspconfig = pcall(require, "lspconfig")
if not present then
    print("lspconfig not present")
else
    local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, bufopts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', '<space>f', vim.lsp.buf.formatting, bufopts)
    end

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    local present, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    if present then
        capabilities = cmp_lsp.update_capabilities(capabilities)
    end

    lspconfig["sumneko_lua"].setup {
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
            Lua = {
                runtime = {
                    version = 'LuaJIT'
                },
                diagnostics = {
                    globals = {'vim'},
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = vim.api.nvim_get_runtime_file("", true),
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    }

    local servers = { "clangd" }
    for _, lsp in ipairs(servers) do
        lspconfig[lsp].setup {
            on_attach = on_attach,
            capabilities = capabilities,
        }
    end
end