local lastWrite

local convarEnabled = CreateClientConVar( "proximity_voice_enabled", "0", true, true )
cvars.AddChangeCallback( "proximity_voice_enabled", function( name, old, new )
    net.Start( "proximity_voice_enabled_changed" )
        net.WriteBool( tobool( new ) )
    net.SendToServer()
end )

local convarHearDead = CreateClientConVar( "proximity_voice_hear_dead", "0", true, true )
cvars.AddChangeCallback( "proximity_voice_hear_dead", function( name, old, new )
    net.Start( "proximity_voice_hear_dead_changed" )
        net.WriteBool( tobool( new ) )
    net.SendToServer()
end )

local convar3D = CreateClientConVar( "proximity_voice_3D", "0", true, true )
cvars.AddChangeCallback( "proximity_voice_3D", function( name, old, new )
    net.Start( "proximity_voice_3D_changed" )
        net.WriteBool( tobool( new ) )
    net.SendToServer()
end )

local convarRange = CreateClientConVar( "proximity_voice_range", "1000", true, true, "Proximity voice range (500-2500)", 500, 2500 )
cvars.AddChangeCallback( "proximity_voice_range", function( name, old, new )
    timer.Create( "cfc_proximity_range_write", 0.5, 1, function()
        net.Start( "proximity_voice_range_changed" )
            net.WriteInt( new, 13 )
        net.SendToServer()
    end )
end )

hook.Add( "AddToolMenuCategories", "CFC_OptionalAddons_AddMenuCategory", function()
    spawnmenu.AddToolCategory( "Options", "CFC", "Proximity Voice" )
end )

local function populatePanel( form )
    local enableCheckbox = form:CheckBox( "Enable Proximity Voice", "proximity_voice_enabled" )
    enableCheckbox:SetChecked( convarEnabled:GetBool() )

    local hearDeadCheckbox = form:CheckBox( "Hear dead players", "proximity_voice_hear_dead" )
    hearDeadCheckbox:SetChecked( convarHearDead:GetBool() )

    local checkbox3D = form:CheckBox( "3D Sound", "proximity_voice_3D" )
    checkbox3D:SetChecked( convar3D:GetBool() )

    local rangeSlider = form:NumSlider( "Voice Range", "proximity_voice_range", 500, 2500, 0 )
    rangeSlider:SetValue( convarRange:GetInt() )
end

hook.Add( "PopulateToolMenu", "CFC_OptionalAddons_CreateOptionsMenu", function()
    spawnmenu.AddToolMenuOption( "Options", "CFC", "proximity_voice", "Proximity Voice", "", "", function( panel )
        populatePanel( panel )
    end )
end )

hook.Add( "InitPostEntity", "CFC_ProximityVoice_SendConfigToServer", function()
    net.Start( "proximity_voice_settings_changed" )
        net.WriteBool( convarEnabled:GetBool() )
        net.WriteBool( convarHearDead:GetBool() )
        net.WriteBool( convar3D:GetBool() )
        net.WriteInt( convarRange:GetInt(), 13 )
    net.SendToServer()
end )
