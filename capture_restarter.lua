function check_capture_status()
    local sources = obslua.obs_enum_sources()
    if sources == nil then return end
    for _, source in pairs(sources) do
        local source_id = obslua.obs_source_get_unversioned_id(source)
        if source_id == "screen_capture" then
            local properties = obslua.obs_source_properties(source)
            local reactivateBtn = obslua.obs_properties_get(properties, "reactivate_capture")
            local canReactivate = obslua.obs_property_enabled(reactivateBtn)
            if canReactivate then
                obslua.obs_property_button_clicked(reactivateBtn, source)
                print("Restarted screen capture")
            end
            obslua.obs_properties_destroy(properties)
        end
    end
    obslua.source_list_release(sources)
end

function script_description()
    return "This script automatically restarts frozen macOS screen captures, \z
            which can happen when the monitor is turned off or the computer goes into sleep mode."
end
    
function script_load(settings)
    obslua.timer_add(check_capture_status, 1000)
end

function script_unload()
    obs.timer_remove(check_capture_status)
end