require('telescope').setup({
    mappings = {
        n = {
            ["<leader>ff"] = "find_files",
            ["<leader>fg"] = "live_grep"
        }
    },
    extensions = {
        fzf = {
            fuzzy = true,                    -- false will only do exact matching
            override_generic_sorter = true,  -- override the generic sorter
            override_file_sorter = true,     -- override the file sorter
            case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
            -- the default case_mode is "smart_case"
        }
    }
})


require('telescope').load_extension('fzf')
