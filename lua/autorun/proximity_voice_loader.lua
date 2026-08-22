local function includeClient( file )
    if SERVER then
        AddCSLuaFile( file )
    else
        include( file )
    end
end

local function includeShared( file )
    includeClient( file )
    include( file )
end

local function includeServer( file )
    if SERVER then
        include( file )
    end
end

includeShared( "cfc_proximity_voice/shared/proximity_voice_shared.lua" )

includeClient( "cfc_proximity_voice/client/proximity_voice_init.lua" )
includeClient( "cfc_proximity_voice/client/proximity_voice_public.lua" )

includeServer( "cfc_proximity_voice/server/toggle_voice_init.lua" )
