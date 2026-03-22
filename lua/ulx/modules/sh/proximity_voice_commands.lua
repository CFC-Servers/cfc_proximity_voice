local CATEGORY_NAME = "Fun"

local function forceProximityVoice( caller, disabled )
    if disabled then
        RunConsoleCommand( "force_proximity_voice", "0" )
        ulx.fancyLogAdmin(  caller, "#A disabled proximity voice globally" )
    else
        RunConsoleCommand( "force_proximity_voice", "1" )
        ulx.fancyLogAdmin(  caller, "#A enabled proximity voice globally" )
    end
end
local proximityGlobal = ulx.command( CATEGORY_NAME, "ulx enableproximityvoice", forceProximityVoice )
proximityGlobal:addParam{ type = ULib.cmds.BoolArg, invisible = true }
proximityGlobal:defaultAccess( ULib.ACCESS_ADMIN )
proximityGlobal:help( "Enable proximity voice for everyone" )
proximityGlobal:setOpposite( "ulx disableproximityvoice", { nil, true } )


if not TimedPunishments then return end

local PUNISHMENT = "timedproxyvoice"
local HELP = "Force proximity voice on a player for a set duration."

if SERVER then
    local function enable( ply )
        ProximityVoiceOverridePlayerConfig( ply, true )
    end

    local function disable( ply )
        ProximityVoiceOverridePlayerConfig( ply, false )
    end

    TimedPunishments.Register( PUNISHMENT, enable, disable )
end

local action = "forced proximity voice upon ##"
local inverseAction = "freed ## from proximity voice"
TimedPunishments.MakeULXCommands( PUNISHMENT, action, inverseAction, CATEGORY_NAME, HELP )
