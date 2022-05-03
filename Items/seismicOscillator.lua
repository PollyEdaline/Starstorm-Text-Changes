local path = "Items/Resources/"

it.SeismicOscillator = Item.new("Seismic Oscillator")
local sSeismicOscillator = Sound.load("SeismicOscillator", path.."seismicOscillator")
it.SeismicOscillator.pickupText = "Generate an earthquake." 
it.SeismicOscillator.sprite = Sprite.load("SeismicOscillator", path.."Seismic Oscillator.png", 2, 12, 12)
it.SeismicOscillator.isUseItem = true
it.SeismicOscillator.useCooldown = 50
it.SeismicOscillator:setTier("use")
itp.enigma:add(it.SeismicOscillator)
it.SeismicOscillator:setLog{
	group = "use",
	description = "Start an earthquake which &y&damages all grounded enemies.",
	story = "We've gotten a fairly good trade with the lambda group, we might no longer use this so it's yours to keep, you'll probably use it more than us over there, with all the recent earthquakes.\nWatch out for the beeping, it could mean a catastrophe.",
	destination = "Miean #676,2,\nPlausamdi,\nTitan",
	date = "04/05/2056"
}

local onPlayerStepCall = function(player)
	local playerData = player:getData()
	
	if playerData.usingQuake and playerData.usingQuake > 0 then
		if playerData.usingQuake % 30 == 0 then
			for _, actor in pairs(pobj.actors:findMatching("free", 0)) do
				if actor:isClassic() and actor:get("team") ~= player:get("team") then
					player:fireBullet(actor.x, actor.y, 90, 2, playerData.quakeDamage, nil, DAMAGER_NO_PROC)
				end
			end
		end
		if playerData.usingQuake % 6 == 0 then
			misc.shakeScreen(1)
		end
		playerData.usingQuake = playerData.usingQuake - 1
	end
end

it.SeismicOscillator:addCallback("use", function(player, embryo)
	local playerAc = player:getAccessor()
	sSeismicOscillator:play()
	player:getData().usingQuake = 360
	if embryo then
		player:getData().quakeDamage = 1.40
	else
		player:getData().quakeDamage = 0.7
	end
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)