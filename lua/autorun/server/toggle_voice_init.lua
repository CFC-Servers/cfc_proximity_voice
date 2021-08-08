local forceLocalVoiceConvar = CreateConVar( "force_local_voice", "0", 0, "force everyone to use local voice")
forceLocalVoice = forceLocalVoiceConvar:GetBool()

cvars.AddChangeCallback("force_local_voice", function(convarName, valueOld, valueNew)
	foreLocalVoice = forceLocalVoiceConvar:GetBool()
end)

local config = {
	CHAT_DISTANCE = 750,
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
	if not forceLocalVoice and not playerConfig[listener] then return end

    return canHear( listener, speaker ), config.Chat.VOICE_3D
end)


concommand.Add("enable_local_voice", function(ply)
	playerConfig[ply] = true
end)

concommand.Add("disable_local_voice", function(ply)
	playerConfig[ply] = nil
end)
