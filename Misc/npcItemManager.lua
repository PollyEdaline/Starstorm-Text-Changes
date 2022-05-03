local objRepulsionDisplay = Object.new("RepulsionDisplay")
objRepulsionDisplay.sprite = spr.EfReflector
objRepulsionDisplay.depth = -2
objRepulsionDisplay:addCallback("create", function(self)
	self.spriteSpeed = 0.3
end)
objRepulsionDisplay:addCallback("step", function(self)
	self.angle = self.angle + 90
	if self:getData().parent and self:getData().parent:isValid() then
		self.x = self:getData().parent.x
		self.y = self:getData().parent.y
		if not self:getData().parent:getData().npcRepulsionTimer then
			self:destroy()
		end
	else
		self:destroy()
	end
end)

local objBarbedWire = Object.new("BarbedWire")
objBarbedWire.sprite = spr.EfThorns
objBarbedWire.depth = -2
objBarbedWire:addCallback("create", function(self)
	self.alpha = 0
	self:getData().timer = 0
	self:getData().damage = 10
	self:getData().team = "enemy"
	self:set("parent", "-4")
end)
objBarbedWire:addCallback("step", function(self)
	local data = self:getData()
	if data.parent and data.parent:isValid() then
		if data.timer >= 29 then
			data.timer = 0
			local size = (self.sprite.width * self.xscale * 0.5) - 5
			misc.fireExplosion(self.x, self.y, size / 19, size / 4, data.damage, data.team)
		else
			data.timer = data.timer + 1
		end
		self.x = data.parent.x
		self.y = data.parent.y
		self.visible = data.parent.visible
		if data.parent:getData().npcBarbedWire <= 0 then
			self:destroy()
		end
	else
		self:destroy()
	end
end)
objBarbedWire:addCallback("draw", function(self)
	local alpha = 0.45 + math.sin(global.timer * 0.04) * 0.2
	graphics.drawImage{
		image = spr.EfThorns,
		alpha = alpha,
		x = self.x,
		y = self.y
	}
	graphics.color(Color.fromHex(0xB8AF92))
	graphics.alpha(alpha)
	graphics.circle(self.x, self.y, (self.sprite.width * self.xscale * 0.5) - 2, true)
end)

local objSticky = Object.new("Sticky")
objSticky.sprite = spr.EfSticky
objSticky.depth = -9
objSticky:addCallback("create", function(self)
	local data = self:getData()
	data.timer = 60
	data.damage = 10
	data.team = "enemy"
	data.x = 0
	data.y = 0
	self.spriteSpeed = 0.2
	sfx.Mine:play(2)
end)
objSticky:addCallback("step", function(self)
	local data = self:getData()
	if data.timer > 0 then
		data.timer = data.timer - 1
		if data.parent and data.parent:isValid() then
			self.x = data.parent.x + data.x
			self.y = data.parent.y + data.y
		else
			self:destroy()
		end
	else
		self:destroy()
	end
end)
objSticky:addCallback("destroy", function(self)
	local data = self:getData()
	misc.fireExplosion(self.x, self.y, 10 / 19, 10 / 4, data.damage, data.team, spr.EfExplosive)
	sfx.MinerShoot4:play(1.3)
end)

local itemData = {
	[it.MortarTube] = {var = "mortar", mult = 1, allyOnly = true, alternate = function(amount, actor)
		actor:getData().npcMortar = (actor:getData().npcMortar or 0) + amount
	end},
	[it.MeatNugget] = {var = "nugget", mult = 1, allyOnly = true},
	[it.Crowbar] = {var = "crowbar", mult = 1},
	[it.PlasmaChain] = {var = "plasma", mult = 1, allyOnly = true},
	[it.LeechingSeed] = {var = "lifesteal", mult = 1},
	[it.Ukulele] = {var = "lightning", mult = 1},
	[it.TheOlLopper] = {var = "axe", mult = 1},
	[it["Hyper-Threader"]] = {var = "blaster", mult = 1, allyOnly = true},
	[it.RustyBlade] = {var = "bleed", mult = 1},
	[it["AtGMissileMk.1"]] = {var = "missile", mult = 1, allyOnly = true, alternate = function(amount, actor)
		actor:getData().npcMissile = (actor:getData().npcMissile or 0) + amount
	end},
	[it["AtGMissileMk.2"]] = {var = "missile_tri", mult = 1, allyOnly = true, alternate = function(amount, actor)
		actor:getData().npcMissileTri = (actor:getData().npcMissileTri or 0) + amount
	end},
	[it.IfritsHorn] = {var = "horn", mult = 1, allyOnly = true},
	[it.Taser] = {var = "taser", mult = 1},
	[it.Thallium] = {var = "thallium", mult = 1},
	[it.StickyBomb] = {var = "sticky", mult = 1, allyOnly = true, alternate = function(amount, actor)
		actor:getData().npcSticky = (actor:getData().npcSticky or 0) + amount
	end},
	[it.Headstompers] = {var = "stompers", mult = 1, allyOnly = true},
	[it.ShatteringJustice] = {var = "sunder", mult = 1},
	[it.BoxingGloves] = {var = "knockback", mult = 0.06},
	[it.TelescopicSight] = {var = "scope", mult = 1},
	[it.BrilliantBehemoth] = {var = "explosive_shot", mult = 1},
	[it.LegendarySpark] = {var = "spark", mult = 1},
	[it.EnergyCell] = {var = "cell", mult = 1},
	[it.FiremansBoots] = {var = "fire_trail", mult = 1},
	[it.WickedRing] = {var = "skull_ring", mult = 1},
	[it.PrisonShackles] = {var = "slow_on_hit", mult = 1},
	[it.FireShield] = {custom = function(amount, actor)
		actor:getData().npcFireShield = (actor:getData().npcFireShield or 0) + amount
	end},
	[it.Permafrost] = {var = "freeze", mult = 0.06},
	[it.AlienHead] = {custom = function(amount, actor)
		local actorAc = actor:getAccessor()
		actorAc.cdr = math.min(actorAc.cdr + 0.3 * amount, 1)
	end},
	[it.BurningWitness] = {var = "worm_eye", mult = 1},
	[it.SproutingEgg] = {var = "egg_regen", mult = 1}, -- probably should be custom
	[it.GuardiansHeart] = {var = "maxshield", mult = 60},
	[it.OldBox] = {var = "jackbox", mult = 1, allyOnly = true},
	[it.TeslaCoil] = {var = "tesla", mult = 1},
	[it.FirstAidKit] = {var = "medkit", mult = 1},
	[it.HermitsScarf] = {var = "scarf", mult = 1},
	[it.Gasoline] = {var = "gas", mult = 1},
	[it["Will-o-the-wisp"]] = {var = "lava_pillar", mult = 1, allyOnly = true},
	[it.PanicMines] = {var = "mine", mult = 1, allyOnly = true},
	[it.BustlingFungus] = {var = "mushroom", mult = 1, allyOnly = true},
	[it.HarvestersScythe] = {var = "scythe", mult = 1},
	[it.RepulsionArmor] = {custom = function(amount, actor)
		actor:getData().npcRepulsion = (actor:getData().npcRepulsion or 0) + amount
	end},
	[it.BarbedWire] = {custom = function(amount, actor)
		actor:getData().npcBarbedWire = (actor:getData().npcBarbedWire or 0) + amount
		local total = actor:getData().npcBarbedWire
		if amount > 0 then
			local actorAc = actor:getAccessor()
			if #objBarbedWire:findMatching("parent", actor.id) == 0 then
				local wire = objBarbedWire:create(actor.x, actor.y)
				wire:set("parent", actor.id)
				wire:getData().parent = actor
				wire:getData().team = actorAc.team
				wire:getData().damage = actorAc.damage * (0.33 + 0.17 * total) * 0.25
				local size = 0.8 + 0.2 * total
				wire.xscale = size
				wire.yscale = size
			else
				local wire = objBarbedWire:findMatching("parent", actor.id)[1]
				wire:getData().damage = actorAc.damage * (0.33 + 0.17 * total) * 0.25
				local size = 0.8 + 0.2 * total
				wire.xscale = size
				wire.yscale = size
			end
		else
			local actorAc = actor:getAccessor()
			if #obj.EfThorns:findMatching("parent", actor.id) > 0 then
				local wire = obj.EfThorns:findMatching("parent", actor.id)[1]
				wire:set("damage", actorAc.damage * (0.33 + 0.17 * total) * 0.25)
				local size = 0.8 + 0.2 * total
				wire.xscale = size
				wire.yscale = size
			end
		end
	end},
	[it.ConcussionGrenade] = {custom = function(amount, actor)
		actor:getData().npcConcussion = (actor:getData().npcConcussion or 0) + amount
	end},
	--[[[it.FilialImprinting] = {custom = function(amount, actor)
		actor:getData().npcFilial = (actor:getData().npcFilial or 0) + amount
	end}, --?]]
	[it.HopooFeather] = {var = "feather", mult = 1},
	--[[[it.ToxicCentipede] = {custom = function(amount, actor)
		actor:getData().npcCentipede = (actor:getData().npcCentipede or 0) + amount
	end},]]
	[it.DeadMansFoot] = {var = "poison_mine", mult = 1, allyOnly = true},
	[it.Spikestrip] = {var = "spikestrip", mult = 1, allyOnly = true},
	[it.PredatoryInstincts] = {var = "wolfblood", mult = 1},
	[it.BitterRoot] = {custom = function(amount, actor)
		local actorAc = actor:getAccessor()
		if actor:getData().items_Held[it.BitterRoot] < 40 then
			if amount > 0 then
				local hp = actorAc.hp / actorAc.maxhp
				actorAc.maxhp = actorAc.maxhp * (1 + (0.08 * amount))
				actorAc.hp = actorAc.maxhp * hp
			elseif amount < 0 then
				actorAc.maxhp = actorAc.maxhp / (1 + (0.08 * (amount * -1)))
			end
		end
	end},
	[it.LensMakersGlasses] = {custom = function(amount, actor)
		local actorAc = actor:getAccessor()
		local amount = math.min(amount, 14)
		actorAc.critical_chance = actorAc.critical_chance + (7 * amount)
	end},
	[it.MysteriousVial] = {custom = function(amount, actor)
		local actorAc = actor:getAccessor()
		actorAc.hp_regen = (actorAc.hp_regen or 0) + (0.014 * amount)
	end},
	[it.PaulsGoatHoof] = {custom = function(amount, actor)
		local actorAc = actor:getAccessor()
		local amount = math.min(amount, 15)
		actorAc.pHmax = actorAc.pHmax + (0.15 * amount)
	end},
	[it.SoldiersSyringe] = {custom = function(amount, actor)
		local actorAc = actor:getAccessor()
		local amount = math.min(amount, 13)
		actorAc.attack_speed = math.min(actorAc.attack_speed + (0.15 * amount), 7)
		actorAc.cdr = math.min(actorAc.cdr + (0.075 * amount), 0.99)
	end},
	[it.RustyJetpack] = {custom = function(amount, actor)
		local actorAc = actor:getAccessor()
		if actorAc.pVmax then
			actorAc.pVmax = actorAc.pVmax + (0.2 * amount)
		end
	end},
	[it.ToughTimes] = {custom = function(amount, actor)
		local actorAc = actor:getAccessor()
		actorAc.armor = actorAc.armor + (14 * amount)
	end},
	[it.ColossalKnurl] = {custom = function(amount, actor)
		local actorAc = actor:getAccessor()
		actorAc.hp_regen = actorAc.hp_regen + (0.02 * amount)
		actorAc.maxhp = actorAc.maxhp + (40 * amount)
		actorAc.hp = actorAc.maxhp
	end},
	[it.DiosFriend] = {custom = function(amount, actor)
		local actorAc = actor:getAccessor()
		actorAc.hippo2 = (actorAc.hippo2 or 0) + amount
	end},
	[it.RedWhip] = {custom = function(amount, actor)
		local actorAc = actor:getAccessor()
		actor:getData().redWhip = (actor:getData().redWhip or 0) + amount
	end},
	[it.Fork] = {custom = function(amount, actor)
		local actorAc = actor:getAccessor()
		actorAc.damage = actorAc.damage + (3 * amount)
	end},
	[it.Balloon] = {custom = function(amount, actor)
		local actorAc = actor:getAccessor()
		for e = 0, amount do
			actorAc.pGravity1 = math.max(actorAc.pGravity1 - 0.1 / amount, 0.06)
			actorAc.pGravity2 = math.max(actorAc.pGravity2 - 0.1 / amount, 0.06)
		end
		if actorAc.pVmax then
			actorAc.pVmax = actorAc.pVmax + (0.08 * amount)
		end
	end},
	[it.AlienHead] = {custom = function(amount, actor)
		local actorAc = actor:getAccessor()
		actorAc.cdr = math.min(actorAc.cdr + 0.3, 1)
	end},
	[it.DeTrematode] = {var = "deTrematode", mult = 1},
	[it.BrassKnuckles] = {var = "brassKnuckles", mult = 1},
	[it.StrangeCan] = {var = "strangeCan", mult = 1},
	[it.Insecticide] = {var = "insecticide", mult = 1},
	[it.DormFungus] = {var = "mushroom2", mult = 1},
	[it.Malice] = {var = "malice", mult = 1},
	[it.ShellPiece] = {var = "shellPiece", mult = 1},
	[it.WatchMetronome] = {var = "metronomeWatch", mult = 1},
	[it.CrypticSource] = {var = "crypticSource", mult = 1},
	[it.UnearthlyLamp] = {var = "unearthlyLamp", mult = 1},
	[it.CoffeeBag] = {var = "pHmax", mult = 0.07},
	[it.HuntersSigil] = {var = "huntersSigil", mult = 1},
	[it.SwiftSkateboard] = {var = "swiftSkateboard", mult = 1},
	--[it.JudderingEgg] = {var = "judderingEgg", mult = 1},
	[it.X4Stimulant] = {var = "stimulant", mult = 1},
	[it.GalvanicCore] = {var = "galvanicCore", mult = 1},
	[it.ArmBackpack] = {var = "gunBackpack", mult = 1},
	[it.Needles] = {var = "needles", mult = 1},
	[it.GreenChocolate] = {var = "greenChocolate", mult = 1},
	[it.LowQualitySpeakers] = {var = "speakers", mult = 1},
	[it.PoisonousGland] = {var = "gland", mult = 1},
	[it.ScaldingScale] = {var = "armor", mult = 60},
	[it.Vaccine] = {var = "vaccine", mult = 60},
	[it.WonderHerbs] = {var = "herbs", mult = 60},
	[it.StickyBattery] = {var = "sticky2", mult = 1},
	[it.Roulette] = {var = "roulette", mult = 1}
}

--local availableItems = {}

itp.npc = ItemPool.new("NPC")
itp.npc.weighted = true

for item, data in pairs(itemData) do
	if not data.allyOnly or data.alternate then
		itp.npc:add(item)
		local weight = 1
		if item.color == "g" then weight = 30 end
		if item.color == "w" then weight = 100 end
		itp.npc:setWeight(item, weight)
	end
	--table.insert(availableItems, item)
end

export("NPCItems")
NPCItems.giveItem = function(actor, item, amount)
	local data = itemData[item]
	if data then
		local actorData = actor:getData()
		if not actorData.items_Held then
			actorData.items_Held = {}
		end
		actorData.items_Held[item] = (actorData.items_Held[item] or 0) + amount
		if data.var then
			local actorAc = actor:getAccessor()
			if not data.allyOnly or actorAc.team ~= "enemy" then 
				actorAc[data.var] = (actorAc[data.var] or 0) + (data.mult * amount)
			elseif data.allyOnly and data.alternate then
				data.alternate(amount, actor)
			end
		elseif data.custom then
			data.custom(amount, actor)
		end
	end
end
NPCItems.removeItem = function(actor, item, amount)
	local data = itemData[item]
	if data then
		local actorData = actor:getData()
		if not actorData.items_Held then
			actorData.items_Held = {}
		end
		local trueAmount = math.min((actorData.items_Held[item] or 0), amount)
		actorData.items_Held[item] = math.max((actorData.items_Held[item] or 0) - trueAmount, 0)
		if trueAmount > 0 then
			if data.var then
				local actorAc = actor:getAccessor()
				if not data.allyOnly or actorAc.team ~= "enemy" then 
					actorAc[data.var] = math.max((actorAc[data.var] or 0) - (data.mult * trueAmount), 0)
				elseif data.allyOnly and data.alternate then
					data.alternate(-trueAmount, actor)
				end
			elseif data.custom then
				data.custom(-trueAmount, actor)
			end
		end
	end
end
NPCItems.countItem = function(actor, item)
	local actorData = actor:getData()
	if actorData.items_Held and actorData.items_Held[item] then
		return actorData.items_Held[item]
	else
		return 0
	end
end
--[[NPCItems.getAvailableItems = function()
	return availableItems
end]]

local itemVars = {"deTrematode", "brassKnuckles", "strangeCan", "insecticide", "mortar", "nugget", "crowbar", "wolfblood", "plasma", "lifesteal",
"lightning", "axe", "blaster", "bleed", "missile", "missile_tri", "horn", "taser", "thallium", "sticky", "stompers", "sunder", "knockback",
"scope", "scythe", "explosive_shot", "spark", "cell", "fire_trail", "skull_ring", "slow_on_hit", "fireshield", "freeze", "cdr", "redwhip", "worm_eye", "egg_regen", "shield", "maxshield", "jackbox", "tesla", "medkit", "scarf", "gas", "lava_pillar", "mine", "mushroom", "mushroom2", "malice", "shellPiece", "crypticSource", "metronomeWatch", "huntersSigil", "stimulant", "galvanicCore"}

function copyParentVariables(actor, parent, toAdd)
	local actorAc = actor:getAccessor()
	if parent then
		for _, var in ipairs(itemVars) do
			if parent:get(var) then
				if actor:get(var) and parent:get(var) > actor:get(var) then
					actor:set(var, parent:get(var))
				elseif not actor:get(var) then
					actor:set(var, parent:get(var))
				end
			end
		end
	end
	--[[elseif toAdd then
		for item, k in pairs(toAdd) do
			if not specialNpcItems[item] then
				local var = npcItems[item]
				if var then
					local amount = var[2] * k
					if not actor:get(var[1]) then
						actor:set(var[1], amount)
					else
						actor:set(var[1], actor:get(var[1]) + amount)
					end
				end
			end
			if not actor:getData().items_Held then
				actor:getData().items_Held = {}
			end
			if not actor:getData().items_Held[item] then
				actor:getData().items_Held[item] = k
			else
				actor:getData().items_Held[item] = actor:getData().items_Held[item] + k
			end
		end
	end
	for item, func in pairs(specialNpcItems) do
		local amount = 0
		if parent then
			amount = parent:countItem(item)
		elseif toAdd then
			for ii, k in pairs(toAdd) do
				if ii == item then amount = k break end
			end
		end
		
		local i = item:getName()
		
		local totalAmount = amount 
		
		if actor:getData()["itvar"..i] then
			amount = amount - actor:getData()["itvar"..i]
		end
		
		actor:getData()["itvar"..i] = totalAmount
		
		if amount > 0 then
			func(amount, actor)
		end
	end]]
	if actor:getData().whipboosted then
		actor:set("pHmax", actor:get("pHmax") - (0.6 * actor:getData().whipboosted))
		actor:getData().whipboosted = nil
	end
end

syncNpcItem = net.Packet.new("SSNPCItem", function(player, actor, item, amount)
	if actor and actor:resolve() and item then
		local actorInstance = actor:resolve()
		NPCItems.giveItem(actorInstance, item, amount)
		--copyParentVariables(actorInstance, nil, {[item] = amount})
	end
end)

function otherNpcItems(actor, parent)	
	if actor:get("team") ~= "enemy" and actor:get("mushroom") and actor:get("mushroom") > 0 then
		if actor:get("pHspeed") == 0 then
			if not actor:getData().still_timer then actor:getData().still_timer = 0 end
			if actor:getData().still_timer == 120 then
				local image = actor.mask or actor.sprite
				actor:getData().mush = obj.EfMushroom:create(actor.x, actor.y - image.yorigin + image.boundingBoxBottom)
				actor:getData().mush:set("parent", actor.id)
				actor:getData().mush:set("value", math.round((actor:get("maxhp") * 0.045) * actor:get("mushroom")))
				sfx.EfMushroom:play()
			end
			actor:getData().still_timer = actor:getData().still_timer + 1
		else
			actor:getData().still_timer = 0
			if actor:getData().mush and actor:getData().mush:isValid() then
				actor:getData().mush:set("dead", 1)
			end
		end
	end
	
	local mushes = obj.EfMushroom:findAll()
	for m, mush in ipairs(mushes) do
		if actor:collidesWith(mush, actor.x, actor.y) then
			if not actor:getData()["mushtimer"..m] then
				actor:getData()["mushtimer"..m] = 50
			else
				if actor:getData()["mushtimer"..m] < 60 then
					actor:getData()["mushtimer"..m] = actor:getData()["mushtimer"..m] + 1
				else
					actor:getData()["mushtimer"..m] = 0
					actor:set("hp", actor:get("hp") + mush:get("value"))
					if global.showDamage == true then
						local image = actor.mask or actor.sprite
						misc.damage(mush:get("value"), actor.x, actor.y - image.yorigin, false, Color.DAMAGE_HEAL)
					end
				end
			end
		end
	end
	
	if actor:get("team") ~= "enemy" then
		local warbanner = obj.EfWarbanner:findNearest(actor.x, actor.y)
		if warbanner and distance(warbanner.x, warbanner.y, actor.x, actor.y) <= warbanner:get("range") and not actor:hasBuff(buff.warbanner) then
			actor:applyBuff(buff.warbanner, 60)
		end
	end
	
	local hippo2 = actor:get("hippo2")
	local hippo1 = actor:get("hippo")
	if hippo2 and hippo2 > 0 then
		if hippo1 == 0 then
			actor:getData()._ItemDrop = nil
			actor:set("hippo", 1)
			actor:set("hippo2", hippo2 - 1)
		end
	end
	if hippo2 and hippo2 > 0 and actor:get("exp_worth") > 0 then
		actor:set("exp_worth", 0)
	end
	
	if not global.rormlflag.ss_disable_betterstacks then
		local redWhip = 0
		if parent and parent:isValid() then
			redWhip = math.min(parent:countItem(it.RedWhip), 14)
		else
			if actor:getData().redWhip then
				redWhip = math.min(actor:getData().redWhip, 14)
			else
				redWhip = 0
			end
		end
		if redWhip == nil then redWhip = 0 end
		local redWhipEnabled = false
		if redWhip > 1 and actor:get("combat_timer") == 0 then
			redWhipEnabled = true
		end
		if redWhipEnabled and not actor:getData().whipboosted then
			actor:getData().whipboosted = redWhip
			actor:set("pHmax", actor:get("pHmax") + (0.6 * redWhip))
		elseif actor:getData().whipboosted and not redWhipEnabled then
			actor:set("pHmax", actor:get("pHmax") - (0.6 * actor:getData().whipboosted))
			actor:getData().whipboosted = nil
		end
	end
end

table.insert(call.onNPCDeathProc, function(actor, player)
	if getAlivePlayer() == player then
		if actor:getData().items_Held then
			local hippo1 = actor:get("hippo")
			local parent = actor:getData().parent
			if hippo1 > 0 then
				local object = actor:getObject()
				if object ~= obj.WurmHead and object ~= obj.TotemController then
					local tamed = actor:get("tamed")
					local items = actor:getData().items_Held
					local hippo2 = actor:get("hippo2")
					
					misc.shakeScreen(4)
					sfx.Revive:play()
					local display = obj.EfSparks:create(actor.x, actor.y)
					display.sprite = spr.EfRevive
					display.xscale = 1
					display.yscale = 1
					
					local newActor = object:create(actor.x, actor.y):set("sync", 0)
					if tamed then
						makeTamed(newActor, parent)
					elseif items then
						for item, c in pairs(items) do
							NPCItems.giveItem(actor, item, c)
						end
					end
					newActor:getData().awaitingBodyRemoval = true
					if hippo2 then
						newActor:set("hippo2", hippo2)
					end
					newActor:set("hp", newActor:get("maxhp") / 2)
					if parent then
						parent:getData().childHippo = hippo2
					end
					newActor:set("m_id", actor:get("m_id"))
				end
			elseif parent then
				parent:getData().childHippo = nil
			end
		end
	end
end)

table.insert(call.onFire, function(damager)
	local parent = damager:getParent()
	if parent and parent:isValid() and parent:getData().items_Held then 
		local parentAc = parent:getAccessor()
		local parentData = parent:getData()
		local mortar = parentData.npcMortar
		if mortar and mortar > 0 then
			if math.chance(9) then
				local image = parent.mask or parent.sprite
				local mortarInst = obj.EfMortar:create(parent.x, parent.y - image.height * 0.8)
				mortarInst:set("critical_chance", parentAc.critical_chance)
				mortarInst:set("team", parentAc.team)
				mortarInst:set("damage", parentAc.damage * 1.7 * mortar)
				mortarInst:set("direction", parent:getFacingDirection() + 40 * parent.xscale)
			end
		end
		local missile = parentData.npcMissile
		if missile and missile > 0 then
			if math.chance(10 * missile) then
				local mortarInst = obj.EfMissileEnemy:create(parent.x, parent.y)
				mortarInst:set("team", parentAc.team)
				mortarInst:set("damage", parentAc.damage * 3)
				mortarInst:set("parent", parent.id)
			end
		end
		local missileTri = parentData.npcMissileTri
		if missileTri and missileTri > 0 then
			if math.chance(7 * missileTri) then
				for i = 1, 3 do
					local mortarInst = obj.EfMissileEnemy:create(parent.x, parent.y)
					mortarInst:set("team", parentAc.team)
					mortarInst:set("damage", parentAc.damage * 3)
					mortarInst:set("parent", parent.id)
				end
			end
		end
		local concussion = parentData.npcConcussion
		if concussion and concussion > 0 then
			if math.chance((1 - 1 / (0.06 * concussion + 1)) * 100) then
				damager:set("stun", 2)
				damager:set("stun_ef", 1)
			end
		end
	end
end)
table.insert(call.onHit, function(damager, hit, x, y)
	local parent = damager:getParent()
	local hitData = hit:getData()
	
	if parent and parent:isValid() and parent:getData().items_Held then 
		local parentAc = parent:getAccessor()
		local parentData = parent:getData()
		local gas = parentAc.gas
		if gas and gas > 0 then
			local fire = obj.FireTrail:create(x, y)
			fire:set("team", parentAc.team)
			fire:set("damage", parentAc.damage * 0.05)
		end
		
		local sticky = parentData.npcSticky
		if sticky and sticky > 0 then
			if math.chance(8) then
				local image = hit.mask or hit.sprite
				local halfWidth, halfHeight = image.width / 2, image.height / 2
				local stickyI = objSticky:create(hit.x, hit.y)
				local stickyData = stickyI:getData()
				stickyData.timer = 1 * 60
				stickyData.damage = parentAc.damage * (1 + 0.4 * sticky)
				stickyData.team = parentAc.team
				stickyData.x = math.random(- halfWidth, halfWidth)
				stickyData.y = math.random(- halfHeight, halfHeight)
				stickyData.parent = hit
			end
		end
	end
	if hit:getData().items_Held then
		local hitAc = hit:getAccessor()
		local fireshield = hitData.npcFireShield
		if fireshield and fireshield > 0 and damager:get("damage") >= hit:get("maxhp") * 0.1 then
			misc.fireExplosion(hit.x, hit.y, 10 / 19, 10 / 4, hitAc.damage * fireshield, hitAc.team, spr.EfBombExplode):set("knockback", 1 * fireshield)
			sfx.MinerShoot4:play(1.1)
		end
		local repulsion = hitData.npcRepulsion
		if repulsion and repulsion > 0 and not hitData.npcRepulsionTimer then
			local precount = hitData.npcRepulsionCount or 0
			hitData.npcRepulsionCount = precount + 1
			if hitData.npcRepulsionCount >= 6 then
				sfx.BubbleShield:play(1.8)
				hitData.npcRepulsionCount = 0
				hitData.npcRepulsionTimer = 60 * (2 + 1 * repulsion)
				hitAc.armor = hitAc.armor + 1000
				local repulsion = objRepulsionDisplay:create(hit.x, hit.y)
				repulsion:getData().parent = hit
			end
		end
	end
end)

callback.register("onActorStep", function(actor)
	local actorData = actor:getData()
	if actorData.npcRepulsionTimer then
		if actorData.npcRepulsionTimer > 0 then
			actorData.npcRepulsionTimer = actorData.npcRepulsionTimer - 1
		else
			local actorAc = actor:getAccessor()
			actorData.npcRepulsionTimer = nil
			actorAc.armor = actorAc.armor - 1000
		end
	end
	if actorData.items_Held then
		if actor.y <= -10 then
			actor.y = 1
			actor:set("pVspeed", 0)
		end
	end
end)