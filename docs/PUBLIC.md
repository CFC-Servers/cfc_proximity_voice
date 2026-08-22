# Public API

`lua/cfc_proximity_voice/client/proximity_voice_public.lua`

## `GetProximityVoiceMode( ply )`

Returns `ply`'s current proximity voice mode, accounting for admin overrides and the
global `force_proximity_voice` convar, not just their own toggle:

| Value | Constant                        | Meaning                                    |
|-------|----------------------------------|---------------------------------------------|
| `0`   | `PROXIMITY_VOICE_DISABLED`       | Proximity voice off.                       |
| `1`   | `PROXIMITY_TRANSMIT_ONLY`        | Outgoing voice proximity-limited; hearing normal. |
| `2`   | `PROXIMITY_TRANSMIT_AND_RECEIVE` | Both outgoing and incoming voice proximity-limited. |
