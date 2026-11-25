-- csgo-vulkan-fix (requires plugin to be loaded via hyprpm or hl.plugin.load)
if hl.plugin.csgo_vulkan_fix ~= nil and hl.plugin.csgo_vulkan_fix.vkfix_app ~= nil then
    hl.config({
        plugin = {
            csgo_vulkan_fix = {
                fix_mouse = true,
            },
        },
    })

    -- Exact initialClass match (not a regex)
    hl.plugin.csgo_vulkan_fix.vkfix_app({ app = "cs2", w = 1920, h = 1080 })
end
