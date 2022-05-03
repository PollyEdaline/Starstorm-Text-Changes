local path = "Items/Resources/"

it.GoldMedal = Item.new("Gold Medal")
it.GoldMedal.pickupText = "Spending gold heals you."
it.GoldMedal.sprite = Sprite.load("GoldMedal", path.."Gold Medal.png", 1, 15, 15)
it.GoldMedal:setTier("uncommon")
it.GoldMedal:setLog{
	group = "uncommon_locked",
	description = "Spending gold &g&heals you for 5 seconds.",
	story = "My hard work hasn't felt the same to me, but maybe you can do more with this than I can.\nIt's always rewarding to be the winner but I no longer feel fulfilled by collecting little rewards and trophies, so as an act of solidarity I give this to you. Do as you will.",
	destination = "The Lighthouse,\nAmstem,\nEarth",
	date = "02/02/2056"
}

local onPlayerStepCall = function(player)
	if not net.online or player == net.localPlayer then
		local goldMedal = player:countItem(it.GoldMedal)
		
		if goldMedal > 0 then
			
			local tp = obj.Teleporter:findMatchingOp("active", ">", 3)
			
			if #tp == 0 then -- Leaving the stage takes your gold, so uh...
				
				local data = player:getData()
				local gold = misc.getGold()
				
				if not data.lastGold then
					data.lastGold = gold
				elseif gold ~= data.lastGold then
					if gold < data.lastGold then
						local val = player:get("hp") * 0.12 * goldMedal
						player:set("hp", math.min(player:get("hp") + val, player:get("maxhp")))
						
						applySyncedBuff(player, buff.burstHealth, 380 + 120 * goldMedal)
						
						if net.online then
							if net.host then
								syncInstanceVar:sendAsHost(net.ALL, nil, player:getNetIdentity(), "hp", player:get("hp"))
							else
								syncInstanceVar:sendAsClient(player:getNetIdentity(), "hp", player:get("hp"))
							end
						end
						if global.showDamage then
							misc.damage(val, player.x, player.y - 4, false, Color.DAMAGE_HEAL)
							if onScreen(player) then
								sfx.Coin:play(0.6)
							end
						end
					end
					data.lastGold = gold
				end
			end
		end
	end
end

it.GoldMedal:addCallback("pickup", function(player)
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)
