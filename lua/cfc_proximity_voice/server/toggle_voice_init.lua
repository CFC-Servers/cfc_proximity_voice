local forceLocalVoiceConvar = GetConVar( "force_proximity_voice" )
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

local function updateNetworkedVoiceMode( ply )
    if not IsValid( ply ) then return end

    local mode = playerConfigOverride[ply] and PROXIMITY_TRANSMIT_AND_RECEIVE or playerConfig[ply] or PROXIMITY_VOICE_DISABLED
    ply:SetNW2Int( NW2_PROXIMITY_VOICE_MODE, mode )
end

local function setPlayerConfig( ply, config )
    playerConfig[ply] = config
    updateNetworkedVoiceMode( ply )
end

local function setPlayerConfigOverride( ply, config )
    playerConfigOverride[ply] = config
    updateNetworkedVoiceMode( ply )
end

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
    setPlayerConfigOverride( ply, enabled )
    if not enabled then
        setPlayerConfigOverride( ply, nil )
    end
end

hook.Add( "PlayerCanHearPlayersVoice", "CFC_ToggleLocalVoice_CanHear", function( listener, speaker )
    local shouldUseLocal = forceLocalVoice or playerConfig[listener] == PROXIMITY_TRANSMIT_AND_RECEIVE or playerConfig[speaker] or playerConfigOverride[listener] or playerConfigOverride[speaker]
    if not shouldUseLocal then return end

    return canHear( listener, speaker ), VOICE_3D
end, HOOK_LOW )

hook.Add( "PlayerDisconnected", "CFC_ProximityVoice_CleanupTables", function( ply )
    setPlayerConfig( ply, nil )
    setPlayerConfigOverride( ply, nil )
end )

util.AddNetworkString( "proximity_voice_enabled_changed" )
net.Receive( "proximity_voice_enabled_changed", function( _, ply )
    local enabled = net.ReadBool()
    if not enabled then
        setPlayerConfig( ply, nil )
    elseif net.ReadBool() then
        setPlayerConfig( ply, PROXIMITY_TRANSMIT_ONLY )
    else
        setPlayerConfig( ply, PROXIMITY_TRANSMIT_AND_RECEIVE )
    end
end )
