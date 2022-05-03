local path = "Items/Resources/"

it.LifetimeFortune = Item.new("Lifetime Fortune")
it.LifetimeFortune.displayName = "Scavenger's Fortune"
it.LifetimeFortune.pickupText = "Gain a buff every 10000 gold earned." 
it.LifetimeFortune.sprite = Sprite.load("Scavenger's Fortune", path.."Scavenger's Fortune.png", 1, 15, 15)
itp.legendary:add(it.LifetimeFortune)
it.LifetimeFortune.color = "y"
it.LifetimeFortune:setLog{
	group = "boss",
	description = "Every 10000 gold collected, &y&earn a damage and health buff&!& for 30 seconds.",
	story = "I never cared much about wealth, the poison of the powerful. But I have to admit it brought me opportunities, higher chances at survival in ways I would have assumed were useless.\nI am left thankful for the legacy of those who lurk and hoard.",
	priority = "&b&Field-Found&!&",
	destination = "R#2,\nYacks St.,\nEarth",
	date = "Unknown"
}
local buffWealth = Buff.new("wealth")
buffWealth.subimage = 63
buffWealth:addCallback("start", function(actor)
	local actorAc = actor:getAccessor()
	local actorData = actor:getData()
	local addedDamage = actorAc.damage * 0.5
	local addedHealth = actorAc.maxhp_base * 0.5
	actorAc.damage = actorAc.damage + addedDamage
	actorAc.maxhp_base = actorAc.maxhp_base + addedHealth
	actorData.lifetimeFortuneBuff = {damage = addedDamage, health = addedHealth, hcolor = actorAc.hud_health_color}
	actorAc.hud_health_color = Color.fromHex(0xF5C548).gml
	Sound.find("MidasUse", "Starstorm"):play(0.8)
end)
buffWealth:addCallback("end", function(actor)
	local actorData = actor:getData()
	if actorData.lifetimeFortuneBuff then
		local actorAc = actor:getAccessor()
		local addedDamage = actorData.lifetimeFortuneBuff.damage
		local addedHealth = actorData.lifetimeFortuneBuff.health
		actorAc.damage = actorAc.damage - addedDamage
		actorAc.maxhp_base = actorAc.maxhp_base - addedHealth
		actorAc.hud_health_color = actorData.lifetimeFortuneBuff.hcolor
		actorData.lifetimeFortuneBuff = nil
	end
end)

NPC.addBossItem(obj.Scavenger, it.LifetimeFortune)

local onPlayerStepCall = function(player)
	local count = player:countItem(it.LifetimeFortune)
	if count > 0 then
		if not net.online or player == net.localPlayer then
			local playerData = player:getData()
			local gold = misc.getGold()
			
			local last = playerData.lfLastGold or 0
			local dif = gold - last
			
			if dif > 0 then
				local lastCount = playerData.lfGoldCount or 0
				playerData.lfGoldCount = lastCount + dif
				
				if playerData.lfGoldCount >= 10000 then
					player:applyBuff(buffWealth, (30 * count) * 60)
					playerData.lfGoldCount = playerData.lfGoldCount - 10000
				end
			end
			playerData.lfLastGold = gold
		end
	end
end

it.LifetimeFortune:addCallback("pickup", function(player)
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)