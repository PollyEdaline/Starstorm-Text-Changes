local itemRemovalCallback = callback.create("onItemRemoval")

local allItems = {}

callback.register("postLoad", function()
	for n, namespace in pairs(namespaces) do
		for _, item in ipairs(Item.findAll(namespace)) do
			table.insert(allItems, item)
		end
	end
end)

callback.register("onPlayerInit", function(player)
	player:getData().ir_items = {}
end)

table.insert(call.onPlayerStep, function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	if not playerData.lastItemCount then
		playerData.lastItemCount = player:get("item_count_total")
	end
	
	for _, item in ipairs(allItems) do
		local itCount = player:countItem(item)
		
		if playerData.ir_items[item] and itCount < playerData.ir_items[item] then
			local amount = playerData.ir_items[item] - itCount
			--print(item, amount)
			itemRemovalCallback(player, item, amount)
			playerAc.item_count_total = playerAc.item_count_total - amount
		end
		
		if itCount > 0 then
			playerData.ir_items[item] = itCount
		elseif playerData.ir_items[item] then
			playerData.ir_items[item] = nil
		end
	end
end)

local itemData = {
	[it.WickedRing] = {special = function(player, amount)
		player:set("skull_ring", player:get("skull_ring") - amount)
		player:set("critical_chance", player:get("critical_chance") - (6 * amount))
	end},
	[it.ToughTimes] = {var = "armor", mult = 14},
	[it.Warbanner] = {var = "warbanner", mult = 1},
	[it.EnergyCell] = {var = "cell", mult = 1},
	[it.Permafrost] = {var = "freeze", mult = 1},
	[it.Headstompers] = {var = "stompers", mult = 1},
	[it.RedWhip] = {var = "redwhip", mult = 1},
	[it.FiremansBoots] = {var = "fire_trail", mult = 1},
	[it.PhotonJetpack] = {var = "jetpack", mult = 1},
	[it.Infusion] = {var = "hp_after_kill", mult = 1, restoreColor = true},
	[it.GuardiansHeart] = {var = "maxshield", mult = 60},
	[it.HarvestersScythe] = {var = "scythe", mult = 1},
	[it.LegendarySpark] = {var = "spark", mult = 1},
	[it.TeslaCoil] = {var = "tesla", mult = 1},
	[it["WhiteUndershirt(M)"]] = {var = "armor", mult = 3, max = 1},
	[it.IfritsHorn] = {var = "horn", mult = 1},
	[it.SnakeEyes] = {var = "dice", mult = 1},
	[it.ColossalKnurl] = {special = function(player, amount)
		player:set("armor", player:get("armor") - (5 * amount))
		player:set("maxhp_base", player:get("maxhp_base") - (40 * amount))
		player:set("hp_regen", player:get("hp_regen") - (0.02 * amount))
	end},
	[it.PaulsGoatHoof] = {var = "pHmax", mult = 0.15, max = 25},
	[it.RepulsionArmor] = {var = "reflector", mult = 1},
	[it.BarbedWire] = {special = function(player, amount)
		if player:countItem(it.BarbedWire) == 0 then
			for _, o in ipairs(obj.EfThorns:findMatching("parent", player.id)) do
				o:destroy()
			end
		end
	end},
	[it.HermitsScarf] = {var = "scarf", mult = 1},
	[it.CeremonialDagger] = {var = "dagger", mult = 1},
	[it.ImpOverlordsTentacle] = {special = function(player, amount)
		if player:countItem(it.ImpOverlordsTentacle) == 0 then
			for _, o in ipairs(obj.ImpFriend:findMatching("parent", player.id)) do
				o:destroy()
			end
		end
		player:set("tentacle", player:get("tentacle") - amount)
	end},
	[it.SoldiersSyringe] = {var = "attack_speed", mult = 0.15, max = 13},
	[it.TimeKeepersSecret] = {var = "hourglass", mult = 1},
	[it.TheOlLopper] = {var = "axe", mult = 1},
	[it.BeatingEmbryo] = {var = "embryo", mult = 1},
	[it.ConcussionGrenade] = {var = "stun", mult = 1},
	[it.StickyBomb] = {var = "sticky", mult = 1},
	[it.GoldenGun] = {var = "gold_gun", mult = 1},
	[it.ChargefieldGenerator] = {var = "lightning_ring", mult = 1},
	[it.SmartShopper] = {var = "purse", mult = 1},
	[it.Crowbar] = {var = "crowbar", mult = 1},
	[it.FilialImprinting] = {special = function(player, count)
		--if player:countItem(it.FilialImprinting) == 0 then
			local i = 0
			for _, o in ipairs(obj.Sucker:findMatching("master", player.id)) do
				if i >= count then
					break
				else
					o:destroy()
				end
				i = i + 1
			end
		--end
	end},
	[it["AtGMissileMk.1"]] = {var = "missile", mult = 1},
	[it.RapidMitosis] = {var = "use_cooldown", mult = -5}, --??
	[it.PanicMines] = {var = "mine", mult = 1},
	[it.HopooFeather] = {var = "feather", mult = 1},
	[it.ShatteringJustice] = {var = "sunder", mult = 1},
	[it.Taser] = {var = "taser", mult = 1},
	[it.MeatNugget] = {var = "nugget", mult = 1},
	[it.BoxingGloves] = {var = "knockback", mult = 1},
	[it.LaserTurbine] = {var = "laserturbine", mult = 1},
	[it.HeavenCracker] = {var = "drill", mult = 1},
	[it.SproutingEgg] = {var = "egg_regen", mult = 0.04},
	[it.Thallium] = {var = "thallium", mult = 1},
	[it.MonsterTooth] = {var = "heal_after_kill", mult = 1},
	[it.BustlingFungus] = {var = "mushroom", mult = 1},
	[it.RustyBlade] = {var = "bleed", mult = 1},
	[it["AtGMissileMk.2"]] = {var = "missile_tri", mult = 1},
	[it["Will-o-the-wisp"]] = {var = "lava_pillar", mult = 1},
	[it.BundleofFireworks] = {var = "fireworks", mult = 1},
	[it.RustyJetpack] = {special = function(player, count)
		local itemCount = player:countItem(it.RustyJetpack)
		for i = 1, count do
			local c = itemCount + count - i
			if c == 2 then
				player:set("pGravity2", player:get("pGravity2") + 0.02)
			elseif c <= 1 then
				player:set("pGravity2", player:get("pGravity2") + 0.05)
			end
		end
		
		local trueAmount
		
		if itemCount < 15 then
			trueAmount = math.max(math.min(itemCount + count, 15) - itemCount, 0)
		else
			trueAmount = 0
		end
		
		player:set("pVmax", player:get("pVmax") - 0.2 * trueAmount)
	end},
	[it.MortarTube] = {var = "mortar", mult = 1},
	[it.AlienHead] = {special = function(player, count)
		local ac = player:getAccessor()
		for i = 1, count do
			local c = player:countItem(it.AlienHead) + count - i
			if c == 2 then
				ac.cdr = ac.cdr - 0.09
			elseif c == 1 then
				ac.cdr = ac.cdr - 0.21
			elseif c == 0 then
				ac.cdr = ac.cdr - 0.3
			end
		end
	end},
	[it.LensMakersGlasses] = {var = "critical_chance", mult = 7},
	[it.InterstellarDeskPlant] = {var = "deskplant", mult = 1},
	[it.PlasmaChain] = {var = "plasma", mult = 1},
	[it.BrilliantBehemoth] = {var = "explosive_shot", mult = 1},
	[it.AncientScepter] = {var = "scepter", mult = 1},
	[it.ToxicCentipede] = {special = function(player, count)
		if player:countItem(it.ToxicCentipede) == 0 then
			for _, o in ipairs(obj.EfPoison:findMatching("parent", player.id)) do
				o:destroy()
			end
		end
	end},
	[it.TelescopicSight] = {var = "scope", mult = 1},
	[it["Hyper-Threader"]] = {var = "blaster", mult = 1},
	[it.DiosFriend]	= {special = function(player, amount)
		local data = player:getData()
		for i = 0, amount do
			if data.hippo2 and data.hippo2 > 0 then
				data.hippo2 = data.hippo2 - 1
			else
				player:set("hippo", 0)
			end
		end
	end},
	[it.FirstAidKit] = {var = "medkit", mult = 1},
	[it.TheHitList] = {var = "mark", mult = 1},
	[it.FrostRelic] = {var = "icerelic", mult = 1},
	[it.DeadMansFoot] = {var = "poison_mine", mult = 1},
	[it.BurningWitness] = {var = "worm_eye", mult = 1},
	[it.Gasoline] = {var = "gas", mult = 1},
	[it.PrisonShackles] = {var = "slow_on_hit", mult = 1},
	[it.Spikestrip] = {var = "spikestrip", mult = 1},
	[it.LifeSavings] = {special = function(player, amount)
		local val = math.ceil(amount / 2) * 0.01  -- this isnt accurate, yeet
		player:set("gp5", math.max(player:get("gp5") - val, 0))
	end},
	[it.PredatoryInstincts] = {special = function(player, amount)
		player:set("critical_chance", player:get("critical_chance") - (5 * amount))
		player:set("wolfblood", player:get("wolfblood") - amount)
	end},
	[it.BitterRoot] = {var = "percent_hp", mult = 0.08, max = 38},
	[it.ArmsRace] = {var = "armsrace", mult = 1},
	[it.Ukulele] = {var = "lightning", mult = 1},
	[it.HappiestMask] = {var = "mask", mult = 1},
	[it.MysteriousVial] = {var = "hp_regen", mult = 0.014},
	[it.FireShield] = {var = "fireshield", mult = 1},
	[it["56LeafClover"]] = {var = "clover", mult = 1},
	[it.OldBox] = {var = "jackbox", mult = 1},
	[it.LeechingSeed] = {var = "lifesteal", mult = 1},
}

for iitem, data in pairs(itemData) do
	callback.register("onItemRemoval", function(player, item, amount)
		if item == iitem then
			if not data.special then
				local trueAmount = amount
				if data.max then
					local currentCount = player:countItem(item)
					local preTotal = currentCount + amount
					
					if currentCount < data.max then
						trueAmount = math.max(math.min(preTotal, data.max) - currentCount, 0)
					else
						trueAmount = 0 --math.clamp(data.max - amount, 0, data.max)
					end
				end
				player:set(data.var, player:get(data.var) - (data.mult * trueAmount))
			else
				data.special(player, amount)
			end
			if data.restoreColor then
				if player:countItem(item) == 0 then
					player:set("hud_health_color", Color.fromHex(0x88D367).gml)
				end
			end
		end
	end)
end