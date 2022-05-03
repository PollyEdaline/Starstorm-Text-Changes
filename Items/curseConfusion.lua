local path = "Items/Resources/"

it.CurseConfusion = Item.new("Curse of Confusion")
it.CurseConfusion.pickupText = "Controls are temporarily inverted every minute." 
it.CurseConfusion.sprite = Sprite.load("CurseConfusion", path.."Curse of Confusion.png", 1, 15, 16)
itp.curse:add(it.CurseConfusion)
it.CurseConfusion.color = "dk"

callback.register("onItemRemoval", function(player, item, amount)
	if item == it.CurseConfusion and player:countItem(it.CurseConfusion) == 0 then
		player:getData().curseConfusion = nil
	end	
end)

local onPlayerStepCall = function(player)
	local playerData = player:getData()
	if playerData.curseConfusion then
		if playerData.curseConfusion <= 0 then
			local curse = player:countItem(it.CurseConfusion)
			playerData.curseConfusion = 60 * (60 / curse)
			if not player:hasBuff(buff.daze) then
				local sound = Sound.find("Daze", "Starstorm")
				if sound then
					sound:play()
				end
			end
			player:applyBuff(buff.daze, 300 + (360 / curse))
		else
			playerData.curseConfusion = playerData.curseConfusion - 1
		end
	end
end

local onStageEntryCall = function()
	if net.online and net.host then
		for _, player in ipairs(misc.players) do
			local playerData = player:getData()
			if playerData.curseConfusion then
				syncInstanceData:sendAsHost(net.ALL, nil, player:getNetIdentity(), "curseConfusion", playerData.curseConfusion)
			end
		end
	end
end

it.CurseConfusion:addCallback("pickup", function(player)
	player:getData().curseConfusion = 0
	tcallback.register("onPlayerStep", onPlayerStepCall)
	tcallback.register("onStageEntry", onStageEntryCall)
end)