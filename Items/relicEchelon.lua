local relicColor = Color.fromHex(0xC649AD)

local itRelicEchelon = Item.new("Relic of Echelon")
local sprRelicEchelon = Sprite.load("RelicEchelonDisplay", "Items/Resources/EchelonDis.png", 1, 10, 10)
local sEchelon = Sound.load("RelicEchelon", "Items/Resources/relicEchelon")
itRelicEchelon.pickupText = "Activating use items buffs you greatly, BUT the cooldown is increased each time."
itRelicEchelon.sprite = Sprite.load("RelicEchelon", "Items/Resources/Relic of Echelon.png", 1, 15, 15)
itp.relic:add(itRelicEchelon)
itRelicEchelon.color = relicColor
itRelicEchelon:setLog{
	group = "end",
	description = "&y&Activating use items buffs you greatly, &p&BUT &r&the cooldown is increased each time&!&.",
	story = "Holding the handle felt like something was missing. This object had been fractured. All that remains of it seems unstable. Should I keep it? I will take the chance.",
	priority = "&b&Field-Found&!&",
	destination = "Unknown",
	date = "Unknown"
}

local buffEchelon = Buff.new("echelon")
buffEchelon.sprite = Sprite.load("RelicEchelonBuff", "Items/Resources/EchelonBuff.png", 1, 9, 9)
buffEchelon:addCallback("start", function(actor)
	local actorAc = actor:getAccessor()
	local value = 5000
	if ar.glass.active then
		value = 500
	end
	if isa(actor, "PlayerInstance") then
		actorAc.maxhp_base = actorAc.maxhp_base + value
		actor:getData().echelonLastHpColor = actorAc.hud_health_color
	else
		actorAc.maxhp = actorAc.maxhp + value
	end
	actorAc.damage = actorAc.damage + 150
	actorAc.hp = actorAc.hp + value
	actor:getData().echelonHp = value
end)
buffEchelon:addCallback("step", function(actor)
	local actorAc = actor:getAccessor()
	local color = Color.mix(Color.fromHex(0x6600B0), Color.fromHex(0x66B7B0), 0.5 + math.sin(global.timer * 0.07) * 0.5)
	if isa(actor, "PlayerInstance") then
		actorAc.hud_health_color = color.gml
	end
	if global.quality > 1 then
		par.Echelon:burst("above", actor.x, actor.y, 1, color)
	end
	if actor:getData().echelonOutline and actor:getData().echelonOutline:isValid() then
		actor:getData().echelonOutline.blendColor = color
	else
		actor:getData().echelonOutline = obj.EfOutline:create(actor.x, actor.y)
		actor:getData().echelonOutline:set("parent", actor.id)
		actor:getData().echelonOutline:set("rate", 0)
		actor:getData().echelonOutline.blendColor = color
	end
end)
buffEchelon:addCallback("end", function(actor)
	local actorAc = actor:getAccessor()
	local value = actor:getData().echelonHp
	--local preHpMult =  actorAc.hp / actorAc.maxhp
	if isa(actor, "PlayerInstance") then
		actorAc.maxhp_base = actorAc.maxhp_base - value
		actorAc.maxhp = actorAc.maxhp - value
		actorAc.hud_health_color = actor:getData().echelonLastHpColor
	else
		actorAc.maxhp = actorAc.maxhp - value
	end
	--actorAc.hp = actorAc.maxhp * preHpMult
	actorAc.damage = actorAc.damage - 150
	if actor:getData().echelonOutline and actor:getData().echelonOutline:isValid() then
		actor:getData().echelonOutline:destroy()
		actor:getData().echelonOutline = nil
	end
	actor:getData().echelonHp = nil
end)

callback.register("onUseItemUse", function(player, item)
	local echelon = player:countItem(itRelicEchelon)
	if echelon > 0 and item == player.useItem and item.useCooldown > 0 then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		
		player:applyBuff(buffEchelon, 120 + 360 * echelon)
		
		local value = 6.5 * echelon
		
		playerAc.use_cooldown = playerAc.use_cooldown + value
		playerData.echelonAdd = (playerData.echelonAdd or 0) + value
		
		sEchelon:play(0.9 + math.random() * 0.2)
	end
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == itRelicEchelon then
		local playerData = player:getData()
		if player:countItem(item) == 0 and playerData.echelonAdd then
			local playerAc = player:getAccessor()
			playerAc.use_cooldown = playerAc.use_cooldown - playerData.echelonAdd
			playerData.echelonAdd = 0
		end
	end
end)

callback.register("postLoad", function()
	for _, item in ipairs(Item.findAll()) do
		if item.isUseItem then
			item:addCallback("drop", function(player)
				--if player:countItem(itRelicEchelon) > 0 then
					local playerData = player:getData()
					if playerData.echelonAdd and playerData.echelonAdd > 0 then
						local playerAc = player:getAccessor()
						playerAc.use_cooldown = playerAc.use_cooldown - playerData.echelonAdd
						for _, item in ipairs(pobj.items:findMatching("owner", player.id)) do
							item:destroy()
						end
						local drop = item:getObject():findNearest(player.x, player.y)
						if drop and drop:isValid() then
							drop:getData().echelonCd = playerData.echelonAdd
							drop:getData().echelonOutline = obj.EfOutline:create(drop.x, drop.y)
							drop:getData().echelonOutline:set("parent", drop.id)
							drop:getData().echelonOutline:set("rate", 0)
							drop:getData().echelonOutline.alpha = 0.8
							drop:getData().echelonOutline.depth = drop.depth + 1
							drop:getData().echelonOutline.blendColor = Color.fromHex(0x6600B0)
						end
						playerData.echelonAdd = 0
					end
				--end
			end)
		end
	end
end)
callback.register("onItemPickup", function(item, player)
	if item:getData().echelonCd then
		local playerAc = player:getAccessor()
		player:getData().echelonAdd = item:getData().echelonCd
		playerAc.use_cooldown = playerAc.use_cooldown + player:getData().echelonAdd
		if item:getData().echelonOutline and item:getData().echelonOutline:isValid() then
			item:getData().echelonOutline:destroy()
		end
	end
end)

local onPlayerDrawCall = function(player)
	local relicEchelon = player:countItem(itRelicEchelon)
	if relicEchelon > 0 then
		graphics.drawImage{image = sprRelicEchelon, x = player.x, y = player.y, alpha = 0.35}
	end
end

itRelicEchelon:addCallback("pickup", function(player)
	tcallback.register("onPlayerDraw", onPlayerDrawCall)
end)