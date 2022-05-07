local relicColor = Color.fromHex(0xC649AD)

local itRelicEntropy = Item.new("Relic of Entropy")
local sRelicEntropy = Sound.load("RelicEntropy", "Items/Resources/relicEntropy")
itRelicEntropy.pickupText = "Roll a random effect, BUT the outcome can be detrimental." 
itRelicEntropy.sprite = Sprite.load("RelicEntropy", "Items/Resources/Relic of Entropy.png", 2, 13, 14)
itp.relic:add(itRelicEntropy)
itRelicEntropy.isUseItem = true
itRelicEntropy.color = relicColor
itRelicEntropy:setLog{
	group = "end",
	description = "&y&Roll a random effect, &p&BUT &r&the outcome can be detrimental&!&.",
	story = [[Not unlike ancient mythologies. The so called "Pandora's Box": full of mysteries, full of chances at survival, and full of chances at my own death.]],
	priority = "&b&Field-Found&!&",
	destination = "Unknown",
	date = "Unknown"
}
local enemyFunc = setFunc(function(actor)
	for i = 1, 32 do
		if actor:collidesMap(actor.x, actor.y) then
			actor.y = actor.y - 2
		else
			break
		end
	end
end)
local outcomes = {
	function(player, embryo)
		local enemyCards = Stage.getCurrentStage().enemies:toTable()
		local card = enemyCards[4] or enemyCards[1] or mcard["Stone Golem"]
		createSynced(card.object, player.x - 25, player.y, enemyFunc)
		createSynced(card.object, player.x + 25, player.y, enemyFunc)
		if embryo then
			createSynced(card.object, player.x - 50, player.y, enemyFunc)
			createSynced(card.object, player.x + 50, player.y, enemyFunc)
		end
	end,
	function(player, embryo)
		local r = 250
		local dur = 300
		if embryo then dur = 600 end
		for _, actor in ipairs(pobj.actors:findAllRectangle(player.x - r, player.y - r, player.x + r, player.y + r)) do
			if actor:get("team") ~= player:get("team") then
				actor:applyBuff(buff.voided, dur)
			end
		end
		par.VoidPortal:burst("above", player.x, player.y, 3 * global.quality)
	end,
	function(player, embryo)
		local value = 3 * Difficulty.getScaling()
		local amount = 25
		if embryo then amount = 50 end
		for i = 1, amount do
			obj.EfGold:create(player.x, player.y - 20):set("direction", math.random(180)):set("speed", math.random(0.5, 3)):set("target", player.id):set("value", value)
		end
	end,
	function(player, embryo)
		local dur = 480
		if embryo then dur = 960 end
		player:applyBuff(buff.daze, dur)
		sfx.Daze:play(0.9 + math.random() * 0.2)
	end,
	function(player, embryo)
		local r = 400
		local dur = 8
		if embryo then dur = 14 end
		for _, actor in ipairs(pobj.actors:findAllRectangle(player.x - r, player.y - r, player.x + r, player.y + r)) do
			DOT.applyToActor(actor, DOT_FIRE, player:get("maxhp") * 0.025, dur, "entropy", true)
		end
	end,
	function(player, embryo)
		local base = obj.TeleporterFake:find(1) or obj.Base:find(1)
		if base and base:isValid() and player:get("activity") ~= 30 then
			player.x = base.x
			player.y = base.y
			local s = obj.EfSparks:create(player.x, player.y)
			s.sprite = spr.EfRecall
			s.yscale = 1
			sfx.Teleporter:play()
		else
			sfx.Squeaky:play()
		end
	end,
	function(player, embryo)
		local tele = obj.Teleporter:find(1)
		if tele and tele:isValid() and player:get("activity") ~= 30 then
			player.x = tele.x
			player.y = tele.y
			local s = obj.EfSparks:create(player.x, player.y)
			s.sprite = spr.EfRecall
			s.yscale = 1
			sfx.Teleporter:play()
		else
			sfx.Squeaky:play()
		end
	end,
	function(player, embryo)
		for _, actor in ipairs(pobj.actors:findAll()) do
			if actor:get("team") ~= player:get("team") and not actor:isBoss() then
				actor:set("hp", 0)
			end
		end
		sfx.JarSouls:play(0.5)
	end,
	function(player, embryo)
		if net.host then
			itp.common:roll():getObject():create(player.x, player.y - 10)
			if embryo then
				itp.common:roll():getObject():create(player.x, player.y - 15)
			end
		end
	end
}

local syncOutcome = net.Packet.new("SSREntropy", function(player, activator, outcomeId, embryo)
	local activatorI = activator:resolve()
	if activatorI and activatorI:isValid() then
		outcomes[outcomeId](activatorI, embryo)
	end
end)

itRelicEntropy:addCallback("use", function(player, embryo)	
	par.Relic:burst("middle", player.x, player.y, 3 * global.quality)
	sRelicEntropy:play(0.9 + math.random() * 0.2)
	if net.host then
		local playerAc = player:getAccessor()
		
		local outcomeId = math.random(1, #outcomes)
		outcomes[outcomeId](player, embryo)
		if net.online then
			syncOutcome:sendAsHost(net.ALL, nil, player:getNetIdentity(), outcomeId, embryo)
		end
	end
end)

--[[callback.register ("onPlayerDraw", function(player)
	if player.useItem == itRelicEntropy then
		graphics.drawImage{image = spr.Nothing, x = player.x, y = player.y, alpha = 0.35, angle = math.random(0,360)}
	end
end)]]