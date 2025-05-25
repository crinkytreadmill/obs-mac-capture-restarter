-- Define source types to monitor and their reactivation properties
local SOURCE_TYPES = {
    {
        id = "screen_capture",
        name = "screen capture",
        reactivate_property = "reactivate_capture"
    },
    {
        id = "coreaudio_input_capture", 
        name = "audio input",
        reactivate_property = "reactivate_capture"
    },
    {
        id = "coreaudio_output_capture",
        name = "audio output", 
        reactivate_property = "reactivate_capture"
    }
}

function check_capture_status()
    local sources = obslua.obs_enum_sources()
    if sources == nil then return end
    
    for _, source in pairs(sources) do
        local source_id = obslua.obs_source_get_unversioned_id(source)
        
        -- Check if this source type should be monitored
        for _, source_type in pairs(SOURCE_TYPES) do
            if source_id == source_type.id then
                local source_name = obslua.obs_source_get_name(source)
                local properties = obslua.obs_source_properties(source)
                
                if properties ~= nil then
                    local reactivate_btn = obslua.obs_properties_get(properties, source_type.reactivate_property)
                    
                    if reactivate_btn ~= nil then
                        local can_reactivate = obslua.obs_property_enabled(reactivate_btn)
                        if can_reactivate then
                            obslua.obs_property_button_clicked(reactivate_btn, source)
                            print("Restarted " .. source_type.name .. ": " .. source_name)
                        end
                    end
                    
                    obslua.obs_properties_destroy(properties)
                end
                break -- Found matching source type, no need to check others
            end
        end
    end
    obslua.source_list_release(sources)
end

function script_description()
    return "This script automatically restarts frozen macOS screen captures and audio sources, \z
            which can happen when the monitor is turned off, the computer goes into sleep mode, \z
            or audio devices are disconnected/reconnected."
end
    
function script_load(settings)
    obslua.timer_add(check_capture_status, 15000)
    print("Capture Restarter: Monitoring screen captures and audio sources every 15 seconds")
end

function script_unload()
    obslua.timer_remove(check_capture_status)
    print("Capture Restarter: Stopped monitoring")
end
