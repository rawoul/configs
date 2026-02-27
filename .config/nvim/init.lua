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
    pattern = { "c" },
    command = "setlocal sw=8 sts=0 noet cinoptions+=(0",
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
--vim.opt.background = "dark"
vim.opt.signcolumn = "no"
vim.opt.laststatus = 3
vim.opt.list = true
vim.opt.listchars:append("tab:>-")
vim.opt.listchars:append("nbsp:␣")
vim.opt.listchars:append("trail:⋅")
vim.cmd.hi("default link TrailSpace Error")
vim.fn.matchadd('Trailspace', [[\s\+$]])

vim.g.zenbones = { transparent_background = true, darkness = 'stark', lighten_non_text = 12 }
vim.g.rosebones = { transparent_background = true, darkness = 'stark', lighten_non_text = 4 }
vim.g.nordbones = { transparent_background = true, darkness = 'stark', lighten_non_text = 4 }
vim.g.neobones = { transparent_background = true, darkness = 'warm', lighten_non_text = 4 }
vim.g.forestbones = { transparent_background = true, darkness = 'stark', lighten_non_text = 4 }
vim.g.seoulbones = { transparent_background = true, darkness = 'warm', lighten_non_text = 4 }
vim.g.tokyobones = { transparent_background = true, solid_vert_split = true, solid_line_nr = true, darkness = 'warm', lighten_non_text = 4 }
vim.g.tokyonight_style = "night"
vim.g.tokyonight_italic_keywords = false
vim.g.tokyonight_transparent = true
vim.g.tokyonight_hide_inactive_statusline = true

if pcall(vim.cmd.colorscheme, "tokyobones") then
    vim.opt.termguicolors = true
end

local present, lsp_installer = pcall(require, "mason")
if present then
    lsp_installer.setup()
end

local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_set_option_value('omnifunc', 'v:lua.vim.lsp.omnifunc', {
        scope="local", buf=bufnr
    })

    require("which-key").add({
        { "gD", vim.lsp.buf.declaration, desc = "   lsp declaration" },
        { "gd", vim.lsp.buf.definition, desc = "   lsp definition" },
        { "gi", vim.lsp.buf.implementation, desc = "   lsp implementation" },
        { "gr", vim.lsp.buf.references, desc = "   lsp references" },
        { "K", vim.lsp.buf.hover, desc = "   lsp hover" },
        { "<leader>ls", vim.lsp.buf.signature_help, desc = "   lsp signature_help" },
        { "<leader>D", vim.lsp.buf.type_definition, desc = "   lsp definition type" },
        { "<leader>t", vim.lsp.buf.typehierarchy, desc = "   lsp type hierarchy" },
        { "<leader>rn", vim.lsp.buf.rename, desc = "   lsp rename" },
        { "<leader>ca", vim.lsp.buf.code_action, desc = "   lsp code_action" },
        { "<leader>f", vim.diagnostic.open_float, desc = "   floating diagnostic" },
        { "[d", function() vim.diagnostic.jump{count=-1, float=true} end, desc = "   goto prev" },
        { "d]", function() vim.diagnostic.jump{count=1, float=true} end, desc = "   goto_next" },
        { "<leader>q", vim.diagnostic.setloclist, desc = "   diagnostic setloclist" },
        { "<leader>fm", vim.lsp.buf.formatting, desc = "   lsp formatting" },
        { "<leader>wa", vim.lsp.buf.add_workspace_folder, desc = "   add workspace folder" },
        { "<leader>wr", vim.lsp.buf.remove_workspace_folder, desc = "   remove workspace folder" },
        { "<leader>wl",
            function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
            end,
            desc = "   list workspace folders",
        },
    })
end

local capabilities
local present, cmp_lsp = pcall(require, "cmp_nvim_lsp")
if present then
    capabilities = cmp_lsp.default_capabilities()
end

vim.lsp.config("lua_ls", {
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
})
vim.lsp.enable("lua_ls")

local servers = { "clangd" }
for _, lsp in ipairs(servers) do
    vim.lsp.config(lsp, {
        on_attach = on_attach,
        capabilities = capabilities,
    })
    vim.lsp.enable(lsp)
end
