local path = "Items/Resources/"

it.WatchMetronome = Item.new("Watch Metronome")
it.WatchMetronome.pickupText = "Standing still charges speed for your next movement." 
it.WatchMetronome.sprite = Sprite.load("WatchMetronome", path.."Watch Metronome.png", 1, 15, 12)
it.WatchMetronome:setTier("uncommon")
it.WatchMetronome:setLog{
	group = "uncommon",
	description = "Standing still &y&charges speed&!& for your &b&next movement&!&.",
	story = "Grandpa gave me this as a relic of the past. He says it belonged to our great-great-great-great-great grandfather. I couldn't care less about antiques and family belongings so I think it's best if you have it instead.\nNot like it's of any use anyways..",
	destination = "Cage 1,\nG-44 (Underground),\nEarth",
	date = "09/05/2054"
}
it.WatchMetronome:addCallback("pickup", function(player)
	player:set("metronomeWatch", (player:get("metronomeWatch") or 0) + 1)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.WatchMetronome then
		player:set("metronomeWatch", player:get("metronomeWatch") - amount)
		if player:countItem(item) == 0 then
			local playerData = player:getData()
			player:set("pHmax", player:get("pHmax") - playerData._chroCharge)
			playerData._chroCharge = 0
			playerData._lastChroCharge = 0
		end
	end
end)

callback.register("onActorStep", function(actor)
	local actorAc = actor:getAccessor()
	local actorData = actor:getData()
	
	-- Watch Metronome
	local metronomeWatch = actorAc.metronomeWatch
	if actor:isClassic() and metronomeWatch and metronomeWatch > 0 then
		if not actorData._lastChroCharge then actorData._lastChroCharge = 0 end
		if not actorData._chroCharge then actorData._chroCharge = 0 end
		
		if actorAc.pHspeed == 0 and actorAc.activity ~= 30 or actorAc.activity == 30 and actorAc.ropeUp == 0 and actorAc.ropeDown == 0 then
			actorData._chroCharge = math.min(actorData._chroCharge + 0.01, 2.4)
		else
			if actorData._chroCharge > 0 then
				local calc = 0.015 / metronomeWatch
				actorData._chroCharge = math.max(actorData._chroCharge - calc, 0)
			end
		end
	end
	if actorData._chroCharge then
		if actorData._chroCharge ~= actorData._lastChroCharge then
			
			local dif = actorData._chroCharge - actorData._lastChroCharge
			actorAc.pHmax = actorAc.pHmax + dif
			
			actorData._lastChroCharge = actorData._chroCharge
		end
	end
end)

local onPlayerDrawCall = function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	-- Watch Metronome
	local metronomeWatch = playerAc.metronomeWatch
	if metronomeWatch and metronomeWatch > 0 and playerData._chroCharge then
		graphics.alpha((playerData._chroCharge / 2.4) * 0.65)
		customBar(player.x - 6, player.y + 11, player.x + 4, player.y + 12, playerData._chroCharge, 2.4, true, Color.LIGHT_BLUE, Color.AQUA)
	end
end

it.WatchMetronome:addCallback("pickup", function(player)
	tcallback.register("onPlayerDraw", onPlayerDrawCall)
end)