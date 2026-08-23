function GetProximityVoiceMode( ply )
    if GetConVar( "force_proximity_voice" ):GetBool() then
        return PROXIMITY_TRANSMIT_AND_RECEIVE
    end

    return ply:GetNW2Int( NW2_PROXIMITY_VOICE_MODE, PROXIMITY_VOICE_DISABLED )
end
