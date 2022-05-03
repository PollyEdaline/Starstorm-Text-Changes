-- ANOINTED

local path = "Survivors/Spectator/Skins/Anointed/"

local survivor = Survivor.find("Spectator", "Starstorm")
local ASpectator = SurvivorVariant.new(survivor, "Anointed Spectator", nil, nil, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(ASpectator, {{"Perception", 10}, {"Analysis", 10}, {"Why", 10}})
SurvivorVariant.setDescription(ASpectator, "You've gone too far.")

survivor:addCallback("step", function(player)
	if math.chance(20) and SurvivorVariant.getActive(player) == ASpectator then
		par.PixelDust:burst("middle", player.x, player.y, 1, Color.fromHex(0xB5F7FF))
	end
end)