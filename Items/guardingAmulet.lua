local path = "Items/Resources/"

it.GuardingAmulet = Item.new("Guarding Amulet")
local sGuardingAmulet = Sound.load("GuardingAmulet", path.."guardingAmulet")
it.GuardingAmulet.pickupText = "Reduce damage from behind you." 
it.GuardingAmulet.sprite = Sprite.load("GuardingAmulet", path.."Guarding Amulet.png", 1, 15, 15)
it.GuardingAmulet:setTier("common")
it.GuardingAmulet:setLog{
	group = "common",
	description = "&b&Reduces damage&!& from behind you by 40%.",
	story = "I know he's somewhere out there, I know you can find him.. but you must be persistent. By the time my soul leaves this shell, the words will be spoken and you will take my place. He will be the one to show you the path to the answers you always wanted from me.\nEmbrace this amulet; you will depend on it, and it will keep you from ever looking back.",
	destination = "C8,\nAzure Garden,\nSanctuary",
	date = "03/11/2056"
}
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.GuardingAmulet then
		player:set("guardingAmulet", player:get("guardingAmulet") - amount)
	end
end)

table.insert(call.preHit, function(damager, hit)
	local damagerAc = damager:getAccessor()
	
	local amulet = hit:get("guardingAmulet")
	if amulet and amulet > 0 and damager:getData().originPos then
		local ox = damager:getData().originPos.x
		if ox < hit.x and hit.xscale > 0 or ox > hit.x and hit.xscale < 0 then
			local reduction = (1 - 1 / (0.42 * amulet + 1))
			damagerAc.damage = damagerAc.damage - damagerAc.damage * reduction
			damagerAc.damage_fake = damagerAc.damage_fake - damagerAc.damage_fake * reduction
			hit:getData().guardingAShine = 10
			sGuardingAmulet:play(0.9 + math.random() * 0.2)
		end
	end
end)

local onPlayerDrawCall = function(player)
	local guardingAmulet = player:countItem(it.GuardingAmulet)
	if guardingAmulet > 0 then
		local playerData = player:getData()
		
		local addAlpha, addSize = 0, 0
		if playerData.guardingAShine and playerData.guardingAShine > 0 then
			addAlpha = playerData.guardingAShine * 0.04
			addSize = playerData.guardingAShine * 0.8
			playerData.guardingAShine = playerData.guardingAShine - 1
		end
		
		local alpha = math.cos(global.timer * 0.05) * 0.2
		graphics.alpha(0.4 + alpha + addAlpha)
		graphics.color(Color.fromHex(0xC638FF))
		local xx = player.x + alpha * 7 + 11 * player.xscale * - 1
		graphics.line(xx, player.y - 7, xx, player.y + 5, 2 + addSize)
	end
end
it.GuardingAmulet:addCallback("pickup", function(player)
	player:set("guardingAmulet", (player:get("guardingAmulet") or 0) + 1)
	tcallback.register("onPlayerDraw", onPlayerDrawCall)
end)