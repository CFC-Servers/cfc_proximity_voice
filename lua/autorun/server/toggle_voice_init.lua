local forceLocalVoiceConvar = CreateConVar( "force_proximity_voice", "0", 0,
                                            "force everyone to use local voice" )
forceLocalVoice = forceLocalVoiceConvar:GetBool()

cvars.AddChangeCallback( "force_proximity_voice", function( convarName, valueOld, valueNew )
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

local playerConfig = {}
local playerConfigOverride = {}

local function canHear( listener, speaker )
    if not playerConfig[listener].hearDead and ( not listener:Alive() or not speaker:Alive() ) then
        return false
    end

    local speakerPos = speaker:GetPos()
    local listenerPos = listener:GetPos()
    local playerRange = playerConfig[listener].range or 1000

    if listenerPos:DistToSqr( speakerPos ) > playerRange ^ 2 then
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
    local cfgListener = playerConfig[listener] or {}
    local cfgSpeaker = playerConfig[listener] or {}
    local isPlayerConfig = cfgListener.enabled or cfgSpeaker.enabled
    local isOverrideConfig = playerConfigOverride[listener] or playerConfigOverride[speaker]

    local shouldUseLocal = forceLocalVoice or isPlayerConfig or isOverrideConfig
    if not shouldUseLocal then return end

    return canHear( listener, speaker ), playerConfig[listener].hear3D
end, HOOK_LOW )

hook.Add( "PlayerDisconnected", "CFC_ProximityVoice_CleanupTables", function( ply )
    playerConfig[ply] = nil
    playerConfigOverride[ply] = nil
end )

util.AddNetworkString( "proximity_voice_settings_changed" )
net.Receive( "proximity_voice_settings_changed", function( len, ply )
    local enabled = net.ReadBool()
    local hearDead = net.ReadBool()
    local hear3D = net.ReadBool()
    local range = net.ReadInt( 13 )

    playerConfig[ply] = playerConfig[ply] or {}
    playerConfig[ply] = {
        enabled = enabled,
        hearDead = hearDead,
        hear3D = hear3D,
        range = range or 1000,
    }
end )

util.AddNetworkString( "proximity_voice_enabled_changed" )
net.Receive( "proximity_voice_enabled_changed", function( len, ply )
    local enabled = net.ReadBool()

    playerConfig[ply] = playerConfig[ply] or {}
    playerConfig[ply].enabled = enabled or nil
end )

util.AddNetworkString( "proximity_voice_hear_dead_changed" )
net.Receive( "proximity_voice_hear_dead_changed", function( len, ply )
    local hearDead = net.ReadBool()

    playerConfig[ply] = playerConfig[ply] or {}
    playerConfig[ply].hearDead = hearDead or nil
end )

util.AddNetworkString( "proximity_voice_3D_changed" )
net.Receive( "proximity_voice_3D_changed", function( len, ply )
    local hear3D = net.ReadBool()

    playerConfig[ply] = playerConfig[ply] or {}
    playerConfig[ply].hear3D = hear3D or nil
end )

util.AddNetworkString( "proximity_voice_range_changed" )
net.Receive( "proximity_voice_range_changed", function( len, ply )
    local range = net.ReadInt( 13 )

    playerConfig[ply] = playerConfig[ply] or {}
    playerConfig[ply].range = range or 1000
end )
