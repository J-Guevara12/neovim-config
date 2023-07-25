require("bufferline").setup{
    options = {
        separator_style = "slant",

        diagnostics = "nvim_lsp",
        diagnostics_indicator = function(_, _, diagnostics_dict )
            local s = ""
            for level, count in pairs(diagnostics_dict) do
                local icon = level:match("error") and " " or (level:match("warning") and " " or " ")
                s = s  .. icon .. count .. " "
            end
            return s
        end,

        get_element_icon = function(element)
            -- element consists of {filetype: string, path: string, extension: string, directory: string}
            -- This can be used to change how bufferline fetches the icon
            -- for an element e.g. a buffer or a tab.
            -- e.g.
            local icon, hl = require('nvim-web-devicons').get_icon_by_filetype(element.filetype, { default = false })
            return icon, hl
        end,

        show_buffer_icons = true,
        color_icons = true,

        indicator = {
            icon = '▎', -- this should be omitted if indicator style is not 'icon'
            style = 'icon'
        },

        show_buffer_close_icons = false,
        show_close_icon = false,

        offsets = {
            filetype = "CHADTree",
            text = "File Explorer",
            highlight = "Directory",
            separator = true,
            text_align = "left"
        }
    }
}
