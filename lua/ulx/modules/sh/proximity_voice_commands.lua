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
proximityGlobal:help( "Enabled proximity voice for everyone" )
proximityGlobal:setOpposite( "ulx disableproximityvoice", {nil, true} )
