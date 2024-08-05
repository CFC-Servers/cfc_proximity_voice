local forceLocalVoiceConvar = CreateConVar( "force_proximity_voice", "0", 0, "force everyone to use local voice" )
forceLocalVoice = forceLocalVoiceConvar:GetBool()

cvars.AddChangeCallback( "force_proximity_voice", function( _, _, _ )
    forceLocalVoice = forceLocalVoiceConvar:GetBool()
    if forceLocalVoice then
        msg = "Forced proximity voice enabled!"
    else
        msg = "Forced proximity voice disabled!"
    end

    for _, ply in ipairs( player.GetAll() ) do
        ply:ChatPrint( msg )
    end
end, "force_proximity_voice_callback" )

local config = {
    CHAT_DISTANCE = 1000,
    VOICE_3D = true
}

local CHAT_DISTANCESQ = config.CHAT_DISTANCE ^ 2
local VOICE_3D = config.VOICE_3D

local playerConfig = {}
local playerConfigOverride = {}

local function canHear( listener, speaker )
    if not listener:Alive() or not speaker:Alive() then
        return false
    end

    local speakerPos = speaker:GetPos()
    local listenerPos = listener:GetPos()

    if listenerPos:DistToSqr( speakerPos ) > CHAT_DISTANCESQ then
        return false
    end

    return true
end

function ProximityVoiceOverridePlayerConfig( ply, enabled )
    playerConfigOverride[ply] = enabled
    if not enabled then
        playerConfigOverride[ply] = nil
    end
end

hook.Add( "PlayerCanHearPlayersVoice", "CFC_ToggleLocalVoice_CanHear", function( listener, speaker )
    local shouldUseLocal = forceLocalVoice or playerConfig[listener] == 1 or playerConfig[speaker] or playerConfigOverride[listener] or playerConfigOverride[speaker]
    if not shouldUseLocal then return end

    return canHear( listener, speaker ), VOICE_3D
end, HOOK_LOW )

hook.Add( "PlayerDisconnected", "CFC_ProximityVoice_CleanupTables", function( ply )
    playerConfig[ply] = nil
    playerConfigOverride[ply] = nil
end )

util.AddNetworkString( "proximity_voice_enabled_changed" )
net.Receive( "proximity_voice_enabled_changed", function( _, ply )
    local enabled, transmitOnly = net.ReadBool(), nil
    if enabled then
        transmitOnly = net.ReadBool()
    end
    playerConfig[ply] = enabled and ( transmitOnly and 2 or 1 ) or nil
end )
