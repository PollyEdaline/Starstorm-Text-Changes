local path = "Items/Resources/"

it.CurseAffliction = Item.new("Curse of Affliction")
it.CurseAffliction.pickupText = "Falling below 50% health gives negative regeneration."
it.CurseAffliction.sprite = Sprite.load("CurseAffliction", path.."Curse of Affliction.png", 1, 15, 15)
itp.curse:add(it.CurseAffliction)
it.CurseAffliction.color = "dk"

local afflictionColor = Color.fromHex(0xFF006E)

callback.register("onItemRemoval", function(player, item, amount)
	if item == it.CurseAffliction and player:countItem(it.CurseAffliction) == 0 then
		local playerData = player:getData()
		local playerAc = player:getAccessor()
		if playerData.curseAffliction then
			playerAc.hp_regen = playerAc.hp_regen + playerData.curseAffliction
			playerData.curseAffliction = nil
		end
	end	
end)

local onPlayerStepCall = function(player)
	local curseAffliction = player:countItem(it.CurseAffliction)
	if curseAffliction > 0 then
		local playerData = player:getData()
		local playerAc = player:getAccessor()
		if playerAc.hp < playerAc.maxhp * math.min((0.35 + 0.15  * curseAffliction), 0.99) then
			if not playerData.curseAffliction then
				local negRegen = 0.25
				playerData.curseAffliction = {negRegen, playerAc.hud_health_color}
				playerAc.hp_regen = playerAc.hp_regen - negRegen
				playerAc.hud_health_color = afflictionColor.gml
			end
		elseif playerData.curseAffliction then
			playerAc.hp_regen = playerAc.hp_regen + playerData.curseAffliction[1]
			playerAc.hud_health_color = playerData.curseAffliction[2]
			playerData.curseAffliction = nil
		end
	end
end

it.CurseAffliction:addCallback("pickup", function(player)
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)