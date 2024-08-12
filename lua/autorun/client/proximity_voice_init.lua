local proximityEnabled = CreateClientConVar( "proximity_voice_enabled", "0", true, true )
local transmitOnly = CreateClientConVar( "proximity_voice_transmit_only", "0", true, true )
cvars.AddChangeCallback( "proximity_voice_enabled", function( _, _, new )
    new = tobool( tonumber( new ) )
    net.Start( "proximity_voice_enabled_changed" )
        net.WriteBool( new )
        if new then
            net.WriteBool( transmitOnly:GetBool() )
        end
    net.SendToServer()
end )
cvars.AddChangeCallback( "proximity_voice_transmit_only", function( _, _, new )
    local enabled = proximityEnabled:GetBool()
    if not enabled then return end
    net.Start( "proximity_voice_enabled_changed" )
        net.WriteBool( enabled )
        net.WriteBool( tobool( tonumber( new ) ) )
    net.SendToServer()
end )

local function populatePanel( form )
    local checkbox = form:CheckBox( "Enable Proximity Voice", "proximity_voice_enabled" )
    checkbox:SetChecked( proximityEnabled:GetBool() )

    local checkbox2 = form:CheckBox( "Proximity Voice is transmit only?", "proximity_voice_transmit_only" )
    checkbox2:SetChecked( transmitOnly:GetBool() )
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
        net.WriteBool( proximityEnabled:GetBool() )
        if proximityEnabled:GetBool() then
            net.WriteBool( transmitOnly:GetBool() )
        end
    net.SendToServer()
end )
