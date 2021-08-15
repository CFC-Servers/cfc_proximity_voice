local forceLocalVoiceConvar = CreateConVar("force_proximity_voice", "0", 0,
                                           "force everyone to use local voice")
forceLocalVoice = forceLocalVoiceConvar:GetBool()

cvars.AddChangeCallback("force_proximity_voice", function(convarName, valueOld, valueNew)
    forceLocalVoice = forceLocalVoiceConvar:GetBool()
    if forceLocalVoice then
        msg = "Forced proximity voice enabled!"	
    else
        msg = "Forced proximity voice disabled!"
    end

    for _, ply in ipairs( player.GetAll() ) do
        ply:ChatPrint( msg )
    end
end, "force_proximity_voice_callback")

local config = {
    CHAT_DISTANCE = 1000,
    VOICE_3D = true
}

local playerConfig = {}

local function canHear( listener, speaker )
    if not listener:Alive() or not speaker:Alive() then
        return false
    end

    local speakerPos = speaker:GetPos()
    local listenerPos = listener:GetPos()

    if listenerPos:DistToSqr( speakerPos ) > config.CHAT_DISTANCE ^ 2 then
        return false
    end

    return true
end

hook.Add( "PlayerCanHearPlayersVoice", "CFC_ToggleLocalVoice_CanHear", function( listener, speaker )
    local shouldUseLocal = forceLocalVoice or playerConfig[listener] or playerConfig[speaker]
    if not shouldUseLocal then return end

    return canHear( listener, speaker ), config.VOICE_3D
end)

hook.Add( "PlayerDisconnected", "CFC_ProximityVoice_CleanupTables", function(ply)
    playerConfig[ply] = nil
end )

util.AddNetworkString( "proximity_voice_enabled_changed" )
net.Receive( "proximity_voice_enabled_changed", function( len, ply )
    local enabled = net.ReadBool()
    playerConfig[ply] = enabled or nil
end )
