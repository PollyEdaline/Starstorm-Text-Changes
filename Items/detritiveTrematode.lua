local path = "Items/Resources/"

it.DeTrematode = Item.new("Detritive Trematode")
it.DeTrematode.pickupText = "Low health enemies receive damage over time." 
it.DeTrematode.sprite = Sprite.load("DetritiveTrematode", path.."Detritive Trematode.png", 1, 12, 11)
it.DeTrematode:setTier("common")
it.DeTrematode:setLog{
	group = "common",
	description = "Enemies with critical health become &y&infected&!&, receiving &y&damage over time.",
	story = "Eh, this is yours.\nDon't send one of those weird microscopic egg hatcheries EVER again, please.",
	destination = "112,\nNeaus 2,\nMars",
	date = "03/11/2057"
}
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.DeTrematode then
		player:set("deTrematode", player:get("deTrematode") - amount)
	end
end)

table.insert(call.onFireSetProcs, function(damager, parent)
	local deTrematode = parent:get("deTrematode")
	if deTrematode then
		damager:set("deTrematode", deTrematode)
	end
end)

table.insert(call.onHit, function(damager, hit)
	local damagerAc = damager:getAccessor()
	
	if damagerAc.deTrematode then
		local hitAc = hit:getAccessor()
		local deTrematode = damagerAc.deTrematode
		if deTrematode and deTrematode > 0 then
			if hitAc.hp - damager:get("damage") <= hitAc.maxhp * ((0.9 + deTrematode / 1.2) * 0.033) and hitAc.hp > damager:get("damage") then
				applySyncedBuff(hit, buff.disease, 420, true)
			end
		end
	end
end)

local onPlayerDrawCall = function(player)
	local deTrematode = player:countItem(it.DeTrematode)
	if deTrematode > 0 then
		graphics.drawImage{image = player.sprite, subimage = player.subimage, color = Color.fromHSV(60,190,230), x = player.x, y = player.y, alpha = 0.25, xscale = player.xscale, yscale = player.yscale}
	end
end

it.DeTrematode:addCallback("pickup", function(player)
	player:set("deTrematode", (player:get("deTrematode") or 0) + 1)
	tcallback.register("onPlayerDraw", onPlayerDrawCall)
end)