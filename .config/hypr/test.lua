local function has_monitor(name)
    for _, monitor in ipairs(hl.get_monitors()) do
        print(monitor.name)
        if monitor.name == name then
            return true
        end
    end

    return false
end