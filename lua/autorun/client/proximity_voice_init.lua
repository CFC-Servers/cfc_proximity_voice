local convar = CreateClientConVar( "proximity_voice_enabled", "0", true, true )
cvars.AddChangeCallback( "proximity_voice_enabled", function( _, _, new )
    net.Start( "proximity_voice_enabled_changed" )
        net.WriteBool( tobool( new ) )
    net.SendToServer()
end )


local function populatePanel( form )
    local checkbox = form:CheckBox( "Enable Proximity Voice", "proximity_voice_enabled" )
    checkbox:SetChecked( convar:GetBool() )
end

hook.Add( "AddToolMenuCategories", "CFC_ProximityVoice_AddMenuCategory", function()
    spawnmenu.AddToolCategory( "Options", "CFC", "CFC" )
end )

hook.Add( "PopulateToolMenu", "CFC_ProximityVoice_CreateOptionsMenu", function()
    spawnmenu.AddToolMenuOption( "Options", "CFC", "proximity_voice", "Proximity Voice", "", "", function( panel )
        populatePanel( panel )
    end )
end )

hook.Add( "InitPostEntity", "CFC_ProximityVoice_SendConfigToServer", function()
    net.Start( "proximity_voice_enabled_changed" )
        net.WriteBool( convar:GetBool() )
    net.SendToServer()
end )
