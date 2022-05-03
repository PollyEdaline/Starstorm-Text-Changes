local path = "Items/Resources/"

it.BabyToys = Item.new("Baby's Toys")
local sBabyToys = Sound.load("BabyToys", path.."toys")
it.BabyToys.pickupText = "Lose 3 levels while keeping all stats." 
it.BabyToys.sprite = Sprite.load("BabyToys", path.."Toys.png", 1, 16, 15)
it.BabyToys:setTier("rare")
it.BabyToys:setLog{
	group = "rare_locked",
	description = "Go back 3 levels while keeping all your stats.",
	story = "Hey sweetheart! I'm sorry I couldn't go, but please, please take these for your baby. He's so little but one day he could be the next big UES captain, who knows! I really want to see you two as soon as possible, things have been rough over here since I got ill and I don't want to put your baby in danger. Love you, please, PLEASE take care!",
	destination = "431,\nGolden Shore,\nEarth",
	date = "06/07/2056"
}
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.BabyToys then
		if player:getData().trueLevel then
			local newLevel = player:getData().trueLevel
			
			if player:getData().lastLevels and player:getData().lastLevels[player:get("level")] then
				player:set("maxexp", player:getData().lastLevels[player:get("level")])
			end
		end
	end
end)
callback.register("onPlayerLevelUp", function(player)
	if player:getData().lastLevels then
		player:getData().lastLevels[player:get("level")] = player:get("maxexp")
	else
		player:getData().lastLevels = {20}
		player:getData().lastLevels[player:get("level")] = player:get("maxexp")
	end
	if player:getData().trueLevel then
		player:getData().trueLevel = player:getData().trueLevel + 1
	end
end)
local onPlayerHUDDrawCall = function(player, x, y)
	if player:countItem(it.BabyToys) > 0 and misc.hud:get("show_skills") == 1 then
		graphics.color(Color.GRAY)
		graphics.alpha(1)
		
		local xx = x - 20
		local yy = y
		
		local oldLevel = player:getData().trueLevel or player:get("level")
		local newLevel = player:get("level")
		graphics.print(oldLevel, xx, yy, 2, 1)
		
		graphics.color(Color.WHITE)
		graphics.print(newLevel, xx, yy, 2, 1)
	end
end

it.BabyToys:addCallback("pickup", function(player)
	if not player:getData().noBabyProc then
		sBabyToys:play()
		if player:getData().lastLevels then
			local newLevel = math.max(1, player:get("level") - 3)
			local lastLevel = player:get("level")
			local lastMax = player:get("maxexp")
			
			if not player:getData().trueLevel then
				player:getData().trueLevel = lastLevel
			end
			
			local newMax = player:getData().lastLevels[newLevel]
			
			local expEquiv = (player:get("expr") / lastMax) * newMax
			player:set("expr", expEquiv)
			player:set("maxexp", newMax)
			player:set("level", newLevel)
		end
	end
	tcallback.register("onPlayerHUDDraw", onPlayerHUDDrawCall)
end)