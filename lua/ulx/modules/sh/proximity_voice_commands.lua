local function forceProximityVoice( caller, disabled )
    if disabled then
        RunConsoleCommand("force_proximity_voice", "0")
        ulx.fancyLogAdmin(  caller, "#A disabled proximity voice globally" )
    else
        RunConsoleCommand("force_proximity_voice", "1")
        ulx.fancyLogAdmin(  caller, "#A enabled proximity voice globally")
    end
end
local proximityGlobal = ulx.command( CATEGORY_NAME, "ulx enableproximityvoice", forceProximityVoice )
proximityGlobal:addParam{ type=ULib.cmds.BoolArg, invisible=true }
proximityGlobal:defaultAccess( ULib.ACCESS_ADMIN )
proximityGlobal:help( "Enable proximity voice for everyone" )
proximityGlobal:setOpposite( "ulx disableproximityvoice", {nil, true} )


local function proximityVoiceOverride( caller, targets, enabled )
    for _, ply in ipairs( targets ) do
        ProximityVoiceOverridePlayerConfig( ply, enabled )
    end

    local word = enabled and "enabled" or "disabled"
    ulx.fancyLogAdmin( caller, "#A #s proximity voice for #T", word, targets )
end
local proximityOverride = ulx.command( CATEGORY_NAME, "ulx overrideproximityvoice", proximityVoiceOverride )
proximityOverride:addParam{ type=ULib.cmds.PlayersArg }
proximityOverride:addParam{ type=ULib.cmds.BoolArg }
proximityOverride:defaultAccess( ULib.ACCESS_ADMIN )
proximityOverride:help( "Enable proximity voice for specific players" )
