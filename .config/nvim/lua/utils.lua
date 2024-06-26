local M = {}

M.load_mappings = function(mappings, mapping_opt)
    -- set mapping function with/without whichkey
    local set_maps
    local whichkey_exists, wk = pcall(require, "which-key")

    if whichkey_exists then
        set_maps = function(keybind, mapping_info, opts)
            wk.register({ [keybind] = mapping_info }, opts)
        end
    else
        set_maps = function(keybind, mapping_info, opts)
            local mode = opts.mode
            opts.mode = nil
            vim.keymap.set(mode, keybind, mapping_info[1], opts)
        end
    end

    for mode, mode_values in pairs(mappings) do
        for keybind, mapping_info in pairs(mode_values) do
            -- merge default + user opts
            local default_opts = vim.tbl_deep_extend("force", { mode = mode }, mapping_opt or {})
            local opts = vim.tbl_deep_extend("force", default_opts, mapping_info.opts or {})

            if mapping_info.opts then
                mapping_info.opts = nil
            end

            set_maps(keybind, mapping_info, opts)
        end
    end
end

return M
