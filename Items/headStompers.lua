if not global.rormlflag.ss_og_headstompers then
it.Headstompers.pickupText = "Hurt enemies by falling. Hold down to fall faster."

local onPlayerStepCall = function(player)
	local headstompers = player:countItem(it.Headstompers)
	if headstompers > 0 then
		local playerAc = player:getAccessor()
		if playerAc.free == 1 and playerAc.ropeDown == 1 then
			playerAc.pVspeed = playerAc.pVspeed + (0.25 * headstompers)
		end
	end
end

it.Headstompers:addCallback("pickup", function(player)
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)
end