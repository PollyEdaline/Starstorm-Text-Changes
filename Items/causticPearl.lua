local path = "Items/Resources/"

it.CausticPearl = Item.new("Caustic Pearl")
local sCausticPearl = Sound.load("CausticPearl", path.."causticPearl")
it.CausticPearl.pickupText = "You feel a burning pain..." 
it.CausticPearl.sprite = Sprite.load("CausticPearl", path.."Caustic Pearl.png", 2, 10, 10)
it.CausticPearl.isUseItem = true
it.CausticPearl.useCooldown = 0
it.CausticPearl.color = "or"
itp.elite:add(it.CausticPearl)
it.CausticPearl:setLog{
	group = "use_locked",
	description = "&y&Become an aspect of corrosion.",
	story = "Once I took the pearl I could not let go, it melted into my body leaving an endless, burning pain. Ever since that moment I was cursed, for I can no longer live the life I had. Everything I touch is gone, as I become entropy itself.",
	priority = "&b&Field-Found&!&",
	destination = "Unknown",
	date = "Unknown"
}
table.insert(specialUseItems, it.CausticPearl)
it.CausticPearl:addCallback("use", function(player)
	sfx.Pickup:stop()
end)
local postPlayerStepCall = function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	if player.useItem == it.CausticPearl or contains(playerData.mergedItems, it.CausticPearl) then
		if not playerData.causticPearlEf then
			if sCausticPearl then 
				sCausticPearl:play()
			end
			playerAc.corrosion = 1
			playerAc.pHmax = playerAc.pHmax + 0.4
			playerData.causticPearlEf = true
		end
	elseif playerData.causticPearlEf then
		playerData.causticPearlEf = nil
		playerAc.corrosion = nil
		playerAc.pHmax = playerAc.pHmax - 0.4
	end
end
itp.use:remove(it.CausticPearl)

it.CausticPearl:addCallback("pickup", function(player)
	tcallback.register("postPlayerStep", postPlayerStepCall)
end)