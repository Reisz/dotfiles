local function quick_menu()
    local harpoon = require "harpoon"
    harpoon.ui:toggle_quick_menu(harpoon:list())
end

local keys = {
    {
        "<leader>ha",
        function()
            require("harpoon"):list():add()
        end,
        desc = "Harpoon: Add file",
    },
    { "<leader>hl", quick_menu, desc = "Harpoon: Show list" },
}

for i = 1, 9 do
    table.insert(keys, {
        ("<C-%d>"):format(i),
        function()
            require("harpoon"):list():select(i)
        end,
        desc = "Harpoon: Show entry " .. i,
    })
end

return {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    requires = { "nvim-lua/plenary.nvim" },
    config = function()
        require("harpoon"):setup()
    end,
    keys = keys,
}
