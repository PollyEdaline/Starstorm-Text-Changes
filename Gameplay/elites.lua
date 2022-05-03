-- All elite data

-- Sprite changes for better palette support
spr.TurtleIdle:replace(Sprite.load("TurtleIdle_fix", "Actors/Turtle/idle", 7, 73, 35))
spr.ChildPal:replace(Sprite.load("ChildPalette", "Gameplay/Palettes/childPalette", 1, 0, 0))
spr.ChildWalk:replace(Sprite.load("ChildWalk_fix", "Actors/Child/walk", 4, 7, 12))


-- Poisoning
elt.Poisoning = EliteType.new("Poisoning")
elt.Poisoning.displayName = "Poisoning"
elt.Poisoning.color = Color.fromHex(0x5A34CF)
elt.Poisoning.palette = Sprite.load("PoisonElitePalette", "Gameplay/Elites/poisonElite", 1, 0, 0)
local sPoison = Sound.load("Poison", "Misc/SFX/poison")
local sPoisonCloud = Sound.load("PoisonCloud", "Misc/SFX/poisonCloud")

-- Weakening
elt.Weakening = EliteType.new("Weakening")
if global.rormlflag.ss_classic_weakening_elites then
	elt.Weakening.displayName = "Weakening"
	elt.Weakening.palette = Sprite.load("WeakeningElitePalette", "Gameplay/Elites/weakeningElite", 1, 0, 0)
else
	elt.Weakening.displayName = "Kinetic"
	elt.Weakening.palette = Sprite.load("KineticElitePalette", "Gameplay/Elites/kineticElite", 1, 0, 0)
	par.Assassin:shape("Disc")
	par.Assassin:direction(0, 360, 0, 0)
	par.Assassin:speed(0, 0.1, 0.001, 0.001)
	par.Assassin:color(Color.BLACK, Color.fromHex(0xFFA0DC), Color.fromHex(0xFFA0DC))
end
elt.Weakening.color = Color.fromHex(0x373746)
local sWeaken = Sound.load("Weaken", "Misc/SFX/weaken")

-- Dazing
elt.Dazing = EliteType.new("Dazing")
elt.Dazing.displayName = "Dazing"
elt.Dazing.color = Color.fromHex(0xFFFFEE)
elt.Dazing.palette = Sprite.load("DazingElitePalette", "Gameplay/Elites/dazingElite", 1, 0, 0)
local sDaze = Sound.load("Daze", "Misc/SFX/daze")
local dazeTime = 80
local objDazeTimer = Object.new("DazeTimer")
objDazeTimer.sprite = Sprite.load("DazeTimer", "Gameplay/Elites/DazeTimer", 15, 10, 10)
objDazeTimer:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.duration = 60
	selfData.life = dazeTime
end)
objDazeTimer:addCallback("step", function(self)
	local selfData = self:getData()
	if selfData.parent and selfData.parent:isValid() then
		self.subimage = (((dazeTime - selfData.life) / dazeTime) * self.sprite.frames) + 1 
		if self.subimage >= 12 and not selfData.applied then
			--if net.online and net.localPlayer == selfData.parent then
				--applySyncedBuff(selfData.parent, buff.daze, selfData.duration)
			--elseif not net.online or selfData.parent:getObject() ~= obj.P then
				selfData.parent:applyBuff(buff.daze, selfData.duration)
			--end
			if onScreen(selfData.parent) then
				sDaze:play(0.9 + math.random() * 0.2)
			end
			selfData.applied = true
		end
		if selfData.life > 0 then
			selfData.life = selfData.life - 1
			self.x = selfData.parent.x
			self.y = selfData.parent.y - 30
		else
			self:destroy()
		end
	else
		self:destroy()
	end
end)
local syncDaze
syncDaze = net.Packet.new("SSDaze", function(sender, actor, dur)
	local actorInst = actor:resolve()
	if actorInst:isValid() then
		local dazeTimer = objDazeTimer:create(actorInst.x, actorInst.y - 30)
		dazeTimer:getData().duration = dur
		dazeTimer:getData().parent = actorInst
		if net.host then
			syncDaze:sendAsHost(net.EXCLUDE, sender, actor, dur)
		end
	end
end)
local function dazeActorSynced (actor, duration)
	if net.host then
		syncDaze:sendAsHost(net.ALL, nil, actor:getNetIdentity(), duration)
	else
		syncDaze:sendAsClient(actor:getNetIdentity(), duration)
	end
	local dazeTimer = objDazeTimer:create(actor.x, actor.y - 30)
	dazeTimer:getData().duration = duration
	dazeTimer:getData().parent = actor
end

-- Tamed
elt.Tamed = EliteType.new("Tamed")
elt.Tamed.displayName = "Tamed"
elt.Tamed.color = Color.fromHex(0x9CB837)
elt.Tamed.palette = Sprite.load("TamedElitePalette", "Gameplay/Elites/tamedElite", 1, 0, 0)

-- Negative (Cognate)
elt.Negative = EliteType.new("Negative")
elt.Negative.displayName = "Negative"
elt.Negative.color = Color.fromHex(0x686868)
elt.Negative.palette = Sprite.load("NegativeElitePalette", "Gameplay/Elites/negativeElite", 1, 0, 0)

-- Void
elt.Void = EliteType.new("Void")
elt.Void.displayName = "Void"
elt.Void.color = Color.fromHex(0xC34CFF)--0xD43EAE)
elt.Void.palette = Sprite.load("VoidElitePalette", "Gameplay/Elites/voidElite", 1, 0, 0)

-- Gilded
elt.Gilded = EliteType.new("Gilded")
elt.Gilded.displayName = "Gilded"
elt.Gilded.color = Color.fromHex(0xA8F2CB)
elt.Gilded.palette = Sprite.load("GuildedElitePalette", "Gameplay/Elites/gildedElite", 1, 0, 0)
local sGildedLaser = Sound.load("GildedLaser", "Misc/SFX/gildedLaser")
local sGildedLaserHit = Sound.load("GildedLaserHit", "Misc/SFX/gildedLaserHit")

-- Corrosive
elt.Corrosive = EliteType.new("Corrosive")
elt.Corrosive.displayName = "Corrosive"
elt.Corrosive.color = Color.fromHex(0xD4FF00)
elt.Corrosive.palette = Sprite.load("CorrosiveElitePalette", "Gameplay/Elites/corrosiveElite", 1, 0, 0)
local sCorrode = Sound.load("Corrode", "Misc/SFX/corrode")

-- Aeonian
elt.Aeonian = EliteType.new("Aeonian")
elt.Aeonian.displayName = "Aeonian"
elt.Aeonian.color = Color.fromHex(0x516372)
elt.Aeonian.palette = Sprite.load("AeonianElitePalette", "Gameplay/Elites/aeonianElite", 1, 0, 0)

-- Ethereal
elt.Ethereal = EliteType.new("Ethereal")
elt.Ethereal.displayName = "Ethereal"
elt.Ethereal.color = Color.fromHex(0x17FFAC)
elt.Ethereal.palette = Sprite.load("EtherealElitePalette", "Gameplay/Elites/etherealElite", 1, 0, 0)

-- Empyrean
elt.Empyrean = EliteType.new("Empyrean")
elt.Empyrean.displayName = "Empyrean"
elt.Empyrean.color = Color.fromHex(0xFFFFFF)
callback.register("onStep", function()
	elt.Empyrean.color = Color.fromHSV(global.timer % 255, 255, 255)
end)
elt.Empyrean.palette = Sprite.load("EmpyreanElitePalette", "Gameplay/Elites/empyreanElite", 1, 0, 0)

-- Relic
elt.Relic = EliteType.new("Relic")
elt.Relic.displayName = "Relic"
elt.Relic.color = Color.fromHex(0xF7D7E3)
elt.Relic.palette = Sprite.load("RelicElitePalette", "Gameplay/Elites/relicElite", 1, 0, 0)

callback.register("postStep", function()
	for _, scope in ipairs(obj.EfScope:findAll()) do
		if not scope:getData().eliteCheck then
			scope:getData().eliteCheck = true
			local target = Object.findInstance(scope:get("target"))
			if target and target:isValid() then
				if target:get("elite_type") == elt.Empyrean.id then
					scope:destroy()
				end
			end
		end
	end
end)

local empyreanMissileFunc = setFunc(function(missile, parent)
	if parent and parent:isValid() then
		missile:set("parent", parent.id):set("lifesteal", 1):set("explosive_shot", 1)
	end
end)

originalElites = {
	elt.Blazing,
	elt.Overloading,
	elt.Frenzied,
	elt.Leeching,
	elt.Volatile
}

newBaseElites = {
	elt.Poisoning,
	elt.Weakening,
	elt.Dazing
}

newHardElites = {
	elt.Void,
	elt.Gilded,
	elt.Corrosive
}

-- New valid elites --------

local newValidElites = {
	[obj.Bug] = {
		mcard = mcard["Archer Bug"],
		palette = Sprite.load("BugPalette", "Gameplay/Palettes/bugPalette", 1, 0, 0),
		eliteTypes = originalElites,
		setOnCreate = true
	},
	[obj.WispB] = {
		mcard = mcard["Ancient Wisp"],
		palette = Sprite.load("WispVPalette", "Gameplay/Palettes/wispbPalette", 1, 0, 0),
		setOnCreate = true
	},
	[obj.Turtle] = {
		mcard = mcard["Cremator"],
		palette = Sprite.load("TurtlePalette", "Gameplay/Palettes/turtlePalette", 1, 0, 0),
		eliteTypes = originalElites,
		setOnCreate = true
	},
	[obj.Jelly] = {
		mcard = mcard["Jellyfish"],
		palette = Sprite.load("JellyPalette", "Gameplay/Palettes/jellyPalette", 1, 0, 0),
		eliteTypes = originalElites,
		setOnCreate = true
	},
	[obj.GiantJelly] = {
		mcard = mcard["Wandering Vagrant"],
		palette = Sprite.load("JellyGPalette", "Gameplay/Palettes/jellygPalette", 1, 0, 0),
		setOnCreate = true
	},
	[obj.LizardF] = {
		mcard = mcard["Evolved Lemurian"],
		palette = Sprite.load("LizardFPalette", "Gameplay/Palettes/lizardfPalette", 1, 0, 0),
		setOnCreate = true
	},
	[obj.LizardFG] = {
		palette = Sprite.find("LizardFPalette", "Starstorm"),
		setOnCreate = true
	},
	[obj.BoarM] = {
		palette = Sprite.load("BoarMPalette", "Gameplay/Palettes/boarmPalette", 1, 0, 0),
		setOnCreate = true
	},
	[obj.GuardG] = {
		palette = Sprite.load("GuardGPalette", "Gameplay/Palettes/guardgPalette", 1, 0, 0),
		setOnCreate = true
	},
	[obj.ChildG] = {
		palette = Sprite.load("ChildGPalette", "Gameplay/Palettes/childgPalette", 1, 0, 0),
		setOnCreate = true
	},
	[obj.WormHead] = {
		palette = Sprite.load("WormHPalette", "Gameplay/Palettes/wormPalette", 1, 0, 0),
		setOnCreate = true
	},
	[obj.WormBody] = {
		palette = Sprite.load("WormBPalette", "Gameplay/Palettes/wormPalette", 1, 0, 0),
		setOnCreate = true
	}
}

for object, eliteData in pairs(newValidElites) do
	if eliteData.palette then
		EliteType.registerPalette(eliteData.palette, object)
	end
	
	if eliteData.eliteTypes then
		for _, eliteType in ipairs(eliteData.eliteTypes) do
			if not eliteData.mcard.eliteTypes:contains(eliteType) then
				eliteData.mcard.eliteTypes:add(eliteType)
			end
		end
	end
	
	if eliteData.setOnCreate and eliteData.palette then
		object:addCallback("create", function(self)
			self:set("sprite_palette", eliteData.palette.id)
		end)
	end
end

--------------------------------

local originalEliteCards = {}
for _, monsterCard in pairs(mcard) do
	local eliteTable = monsterCard.eliteTypes:toTable()
	originalEliteCards[monsterCard] = eliteTable
end

local normallyEliteEnemies = {}
for _, monsterCard in pairs(mcard) do
	if #monsterCard.eliteTypes:toTable() > 1 then
		table.insert(normallyEliteEnemies, monsterCard)
	end
end

local wormElites = {
	[elt.Void] = true
}
local wyvernElites = {
	[elt.Void] = true
}

function toggleElites(eliteTypes, boolean, includeOthers)
	for _, monsterCard in ipairs(normallyEliteEnemies) do
		if eliteTypes == originalElites or includeOthers then
			for _, eliteType in ipairs(originalEliteCards[monsterCard]) do
				if boolean == true then
					if not monsterCard.eliteTypes:contains(eliteType) then
						monsterCard.eliteTypes:add(eliteType)
					end
				elseif monsterCard.eliteTypes:contains(eliteType) then
					monsterCard.eliteTypes:remove(eliteType)
				end
			end
		else
			for _, eliteType in ipairs(eliteTypes) do
				if boolean == true then
					if not monsterCard.eliteTypes:contains(eliteType) then
						monsterCard.eliteTypes:add(eliteType)
					end
				elseif monsterCard.eliteTypes:contains(eliteType) then
					monsterCard.eliteTypes:remove(eliteType)
				end
			end
		end
	end
	for eliteType, data in pairs(wormElites) do
		if contains(eliteTypes, eliteType) then
			local magmaWorm = mcard["Magma Worm"]
			if magmaWorm.eliteTypes:contains(eliteType) and boolean == false then
				magmaWorm.eliteTypes:remove(eliteType)
			elseif magmaWorm.eliteTypes:contains(eliteType) == false and boolean == true then
				magmaWorm.eliteTypes:add(eliteType)
			end
		end
	end
	for eliteType, data in pairs(wyvernElites) do
		if contains(eliteTypes, eliteType) then
			local wyvern = mcard.Wyvern
			if wyvern.eliteTypes:contains(eliteType) and boolean == false then
				wyvern.eliteTypes:remove(eliteType)
			elseif wyvern.eliteTypes:contains(eliteType) == false and boolean == true then
				wyvern.eliteTypes:add(eliteType)
			end
		end
	end
end
mcard["Magma Worm"].canBlight = true

toggleElites(newBaseElites, true)

table.insert(call.onStep, function()
	if getRule(5, 2) ~= false then
		if not runData.addedHardElites and misc.director:get("enemy_buff") > 10 then
			runData.addedHardElites = true
			toggleElites(newHardElites, true)
		end
		if not runData.removedNormalElites and misc.director:get("enemy_buff") > 13 then
			runData.removedNormalElites = true
			toggleElites(originalElites, false)
		end
		if not runData.removedNewElites and misc.director:get("enemy_buff") > 16 then
			runData.removedNewElites = true
			toggleElites(newBaseElites, false)
		end
	end
end)

--[[callback.register("onGameEnd", function()
	toggleElites(newHardElites, false)
	toggleElites(originalElites, true)
end)]]
callback.register("onGameStart", function()
	toggleElites(newHardElites, false)
	toggleElites(originalElites, true)
end)

local eliteInits = {
	[elt.Poisoning] = function(actor)
		actor:set("poison", 1)
	end,
	[elt.Weakening] = function(actor)
		local actorAc = actor:getAccessor()
		actorAc.pHmax = actorAc.pHmax * 0.82
		actorAc.weaken = 1
	end,
	[elt.Dazing] = function(actor)
		actor:set("daze", 1)
	end,
	[elt.Void] = function(actor)
		local actorAc = actor:getAccessor()
		actorAc.void = 1
		actorAc.hit_pitch = 0.5
		actorAc.armor = actorAc.armor + 50
		actorAc.malice = 1
		actorAc.name2 = "Ascending Desperation"
	end,
	[elt.Gilded] = function(actor)
		local actorAc = actor:getAccessor()
		actorAc.gilded = 1
		actor:getData().gilded_cooldown = 100
		actor:getData().gilded_charge = 0
		actorAc.damage = actorAc.damage * 1.25
		actorAc.name2 = "Child of Providence"
	end,
	[elt.Corrosive] = function(actor)
		local actorAc = actor:getAccessor()
		actorAc.corrosion = 1
		actorAc.pHmax = actorAc.pHmax + 0.4
		actorAc.can_jump = 1
		actorAc.can_drop = 1
		actorAc.name2 = "Inert Impairment"
	end,
	[elt.Ethereal] = function(actor)
		local actorAc = actor:getAccessor()
		actorAc.ethereal = 1
		actorAc.maxhp = actorAc.maxhp * 3
		actorAc.exp_worth = actorAc.exp_worth * 5
		actorAc.hit_pitch = 0.9
		actorAc.taser = 1
		actorAc.cdr = 0.2
		actorAc.slow_on_hit = 2
		actorAc.hp = actorAc.maxhp
		actorAc.pHmax = actorAc.pHmax - 0.4
		actorAc.can_jump = 1
		actorAc.can_drop = 1
		actorAc.name2 = "Transcending Witness"
	end
}

local nonClassicEliteInits = {
	[elt.Blazing] = function(actorAc)
		actorAc.fire_trail = 1
	end,
	[elt.Overloading] = function(actorAc)
		actorAc.lightning = 1
	end,
	[elt.Frenzied] = function(actorAc)
		actorAc.pHmax = actorAc.pHmax + 0.4
	end,
	[elt.Leeching] = function(actorAc)
		actorAc.lifesteal = 1
	end,
	[elt.Volatile] = function(actorAc)
		actorAc.explosive_shot = 1
	end
}

callback.register("onEliteInit", function(actor)
	local actorAc = actor:getAccessor()
	if actorAc.prefix_type == 1 then
		local elite = actor:getElite()
		
		if eliteInits[elite] then
			eliteInits[elite](actor)
		end
		
		if not actor:isClassic() then
			if Difficulty.getActive().forceHardElites then
				actorAc.elite_is_hard = 1
			end
			actorAc.maxhp = actorAc.maxhp * 1.5
			actorAc.hp = actorAc.maxhp
			
			if nonClassicEliteInits[elite] then
				nonClassicEliteInits[elite](actorAc)
			end
		end
	end
end)

local function makeEmpyrean(actor)
	local actorAc = actor:getAccessor()
	obj.EfFlash:create(0,0):set("parent", actor.id):set("rate", 0.08)
	actorAc.maxhp = actorAc.maxhp * 10
	actorAc.hp = actorAc.maxhp
	obj.WhiteFlash:create(0, 0).alpha = 0.5
	sfx.WormExplosion:play(0.6)
	sfx.JarSouls:play(0.6)
	for _, elt in ipairs(EliteType.findAll()) do
		if elt.id == actorAc.elite_type then
			actorAc.name = actorAc.name:gsub(elt.displayName.." ", "")
			break
		end
	end
	actorAc.show_boss_health = 1
	actorAc.name = "Empyrean "..actorAc.name
	actorAc.name2 = "The Planet's Harbinger"
	actorAc.explosive_shot = 1
	actorAc.lifesteal = 1
	actorAc.lightning = 1
	actorAc.fire_trail = 1
	actorAc.slow_on_hit = 1
	actorAc.hit_pitch = 0.65
	actorAc.gilded = 1
	actorAc.corrosion = 1
	actorAc.void = 1
	actorAc.daze = 1
	actorAc.weaken = 1
	actorAc.poison = 1
	actor:getData().gilded_cooldown = 100
	actor:getData().gilded_charge = 0
	actorAc.malice = 1 -- all in one :)
	if actorAc.exp_worth then
		actorAc.exp_worth = math.min(actorAc.exp_worth * 15, 5000000)
	end
	
	actorAc.empyrean = 1
	
	actorAc.elite_type = elt.Empyrean.id
	
	local chudboss = Object.findInstance(misc.hud:get("boss_id"))
	if not chudboss or chudboss:isValid() and not chudboss:get("empyrean") and not chudboss:getData().isNemesis and not chudboss:get("name") == "Pylon" or chudboss:isValid() and chudboss:get("empyrean") and not chudboss:isBoss() then
		misc.hud:set("boss_id", actor.id)
		misc.hud:set("boss_text1", actorAc.name)
		misc.hud:set("boss_text2", actorAc.name2)
	end
end

local empyreanBlacklist = {
	[obj.LizardF] = true,
	[obj.LizardFG] = true
}
if not global.rormlflag.ss_disable_enemies then
	empyreanBlacklist[obj.TotemPart] = true
	empyreanBlacklist[obj.SquallElver] = true
	empyreanBlacklist[obj.SquallElverC] = true
end

local syncEmpyrean = net.Packet.new("SSEmpyrean", function(player, actor)
	local actorInst = actor:resolve()
	if actorInst and actorInst:isValid() then
		makeEmpyrean(actorInst)
	end
end)

callback.register("onEliteInit", function(actor)
	local b = misc.director:get("enemy_buff")
	if net.host and b > 15 and math.chance((b - 15) * 0.5) and math.chance(25) and not empyreanBlacklist[ actor:getObject()] and getRule(5, 2) ~= false then
		makeEmpyrean(actor)
		if net.host then syncEmpyrean:sendAsHost(net.ALL, nil, actor:getNetIdentity()) end
	end
end)

table.insert(call.onStep, function()
	for _, wormHead in ipairs(obj.WormHead:findMatchingOp("elite_type", "==", elt.Void.id)) do
		for _, actor in pairs(pobj.actors:findAllEllipse(wormHead.x - 150, wormHead.y - 150, wormHead.x + 150, wormHead.y + 150)) do
			if actor:get("team") ~= wormHead:get("team") and actor:get("void") == nil then
				if not isaDrone(actor) then
					actor:applyBuff(buff.voided, 50)
					if misc.director:getAlarm(0) % 10 == 0 and misc.getTimeStop() == 0 then
						local damager = wormHead:fireBullet(actor.x - 2, actor.y, 0, 4, 0.1)
						damager:set("specific_target", actor.id)
					end
				end
			end
		end
		if wormHead:get("dead") == 0 then
			local target = wormHead:get("target")
			local targetI = Object.findInstance(target)
			if targetI and targetI:isValid() then
				local fangle =  posToAngle(wormHead.x, wormHead.y, targetI.x, targetI.y)
				local odir = wormHead:get("direction")
				local dif = odir - fangle
				
				if targetI.x < wormHead.x then fangle = fangle - 360 end
				
				wormHead:set("direction", odir + (angleDif(odir, fangle) * -0.01))
			end
		end
	end
end)

table.insert(call.onDraw, function()
	for _, wormHead in ipairs(obj.WormHead:findMatchingOp("elite_type", "==", elt.Void.id)) do
		graphics.color(Color.fromHex(0xD1DDFF))
		local size = math.random(22, 25)
		for _, actor in pairs(pobj.actors:findAllEllipse(wormHead.x - 150, wormHead.y - 150, wormHead.x + 150, wormHead.y + 150)) do
			if actor:get("team") ~= wormHead:get("team") and actor:get("void") == nil then
				graphics.line(wormHead.x, wormHead.y, actor.x, actor.y, width, size * 1.5)
			end
		end
		graphics.circle(wormHead.x, wormHead.y, size, false)
		graphics.alpha(1)
		graphics.setBlendMode("additive")
		graphics.color(Color.fromHex(0xA534AF))
		graphics.alpha(math.random(40, 80) / 100)
		graphics.circle(wormHead.x, wormHead.y, size * 1.3, false)
		graphics.setBlendMode("normal")
		par.FloatingRocks:burst("middle", wormHead.x, wormHead.y, 3, Color.fromHex(0xA534AF))
	end
	for _, actor in ipairs(pobj.actors:findAll()) do
		if actor:get("ethereal") then
			local data = actor:getData()
			
			if math.chance(40) and actor:collidesMap(actor.x, actor.y + 1) then
				local sprite = actor.sprite
				if actor.mask then sprite = actor.mask end
				local hwidth = sprite.width / 2
				local xx = actor.x + math.random(-hwidth, hwidth)
				local yy = actor.y - sprite.yorigin + sprite.height
				par.Fire4:burst("below", xx, yy, 1, Color.fromHex(0x4EB2A0))
			end
			actor.alpha = math.random(20, 45) / 100
			graphics.setChannels(true, true, false, true)
			--graphics.setBlendMode("additive")
			local var = math.sin(misc.director:getAlarm(0) * 0.015) * 0.8
			graphics.drawImage{
				image = actor.sprite,
				subimage = actor.subimage,
				x = actor.x,
				y = actor.y,
				color = Color.mix(Color.BLUE, Color.BLACK, var),
				alpha = var,
				angle = actor.angle,
				xscale = actor.xscale,
				yscale = actor.yscale
			}
			graphics.resetChannels(false, false, true, false)
			--graphics.setBlendMode("normal")
			
			if data.ethEXCooldown and data.ethEXCooldown < 100 then
				local b = data.ethEXCooldown / 80
				local a = 1 - b
				
				local size = 90
				if actor:isBoss() then
					size = 130
				end
				
				graphics.alpha(a * 0.8)
				graphics.color(Color.BLACK)
				graphics.circle(actor.x, actor.y, b * size, false)
			end
		end
	end
end)

local function createPoisonCloud(actor)
	local actorAc = actor:getAccessor()
	if onScreen(actor) then
		sPoisonCloud:play(0.9 + math.random() * 0.2)
	end
	local yy = actor.y - actor.sprite.yorigin + actor.sprite.height - 10
	local poisonCloud
	if actorAc.team == "player" then
		poisonCloud = obj.poisonCloud:create(actor.x, yy)
		poisonCloud:getData().parent = actor
		poisonCloud:getData().height = 7
		poisonCloud:getData().width = 30
		poisonCloud:getData().damage = 0.3
	else
		poisonCloud = obj.MushDust:create(actor.x, yy)
		poisonCloud:set("team", actorAc.team or "enemy")
		poisonCloud:setAlarm(0, 300)
		poisonCloud:set("damage", math.floor(actorAc.damage * 0.3))
	end
end

local syncCloud = net.Packet.new("SSPoisonCloud", function(player, actor)
	if actor then
		local actorI = actor:resolve()
		if actorI and actorI:isValid() then
			actorI:getData().poisonCloudTimer = 30
		end
	end
end)

obj.etherealBomb = Object.new("Ethereal Bomb")
obj.etherealBomb:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	selfAc.damage = 50
	selfAc.range = 150
	selfAc.i = 5
	selfAc.team = "enemy"
	selfAc.color = Color.WHITE.gml
end)
obj.etherealBomb:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	local range = selfAc.range
	
	for i = 1, selfAc.i	do
		if selfData["animStep"..i] then
			if i == 1 or selfData["animStep"..i - 1] == 1 then
				if selfData["animStep"..i] < 1 then
					selfData["animStep"..i] = math.approach(selfData["animStep"..i], 1, (1.1 - selfData["animStep"..i]) * ((0.05 + (0.04 * i)) / i))
				elseif selfData["animStep"..i] == 1 then
					if selfData["animStep2"..i] then
						if selfData["animStep2"..i] < 60 then
							if selfData["animStep2"..i] == 0 then
								local stepRange = (selfAc.range / selfAc.i) * i
								for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - stepRange, self.y - stepRange, self.x + stepRange, self.y + stepRange)) do
									local actorAc = actor:getAccessor()
									
									if selfAc.team ~= actorAc.team then
										if not actorAc.invincible or actorAc.invincible <= 0 then
											local damage = (selfAc.damage / selfAc.i) * i
											if not procShell(actor, damage) then
												actorAc.hp = actorAc.hp - damage
												if global.showDamage then
													if selfAc.team == "enemy" then
														misc.damage(damage, actor.x, actor.y, false, Color.DAMAGE_ENEMY)
													else
														misc.damage(damage, actor.x, actor.y, false, Color.WHITE)
													end
												end
											end
										end
									end
								end
								misc.shakeScreen(2 * i)
								sfx.RiotGrenade:play(0.5 + math.random() * 0.2)
								--if selfData.parent and selfData.parent:isValid() then
								--	selfData.parent:fireExplosion(self.x, self.y, ((selfAc.range / selfAc.i) * i) / 19, ((selfAc.range / selfAc.i) * i) / 4, selfAc.damage / selfData.parent:get("damage"), nil, spr.Sparks10)
								--else
								--	misc.fireExplosion(self.x, self.y, ((selfAc.range / selfAc.i) * i) / 19, ((selfAc.range / selfAc.i) * i) / 4, selfAc.damage, selfAc.team, nil, spr.Sparks10)
								--end
							end
							selfData["animStep2"..i] = math.approach(selfData["animStep2"..i], 60, (65 - selfData["animStep2"..i]) * (0.25 / i))
						elseif selfAc.i == i then
							self:destroy()
						end
					else
						selfData["animStep2"..i] = 0
					end
				end
			end
		else
			selfData["animStep"..i] = 0
		end
	end

end)
obj.etherealBomb:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	local range = selfAc.range
	
	for i = 1, selfAc.i do
		if selfData["animStep"..i] then
			if not selfData["animStep2"..i] or selfData["animStep2"..i] < 60 then
				if selfData["animStep2"..i] then
					graphics.alpha(0.4 + (selfData["animStep2"..i] / 60))
				else
					graphics.alpha(0.4)
				end
				graphics.color(Color.fromGML(selfAc.color))
				graphics.circle(self.x, self.y, (selfAc.range / selfAc.i) * i * selfData["animStep"..i], true)
				if selfData["animStep2"..i] then
					graphics.alpha(1 - (selfData["animStep2"..i] / 60))
					graphics.circle(self.x, self.y, (selfAc.range / selfAc.i) * i * selfData["animStep"..i], false)
				end
			end
		end
	end

end)

callback.register("onActorStep", function(actor)
	local actorAc = actor:getAccessor()
	local data = actor:getData()
	if actorAc.poison then
		if actorAc.elite_is_hard and misc.getTimeStop() == 0 then
			if not net.online or net.host then
				if math.chance(1) and math.chance(20) then
					data.poisonCloudTimer = 30
					if net.online then
						syncCloud:sendAsHost(net.ALL, nil, actor:getNetIdentity())
					end
				end
			end
		end
		if global.quality > 1 and onScreen(actor) and math.chance(15) and actorAc.prefix_type == 1 then
			par.Lightning:burst("middle", actor.x, actor.y, 1, Color.PURPLE)
		end
	end
	if data.poisonCloudTimer then
		if data.poisonCloudTimer > 0 then
			data.poisonCloudTimer = data.poisonCloudTimer - 1
		else
			createPoisonCloud(actor)
			data.poisonCloudTimer = nil
		end
	end
	if actorAc.weaken then
		if actorAc.elite_is_hard == 1 and misc.getTimeStop() == 0 then
			for _, actor2 in pairs(pobj.actors:findAllEllipse(actor.x - 100, actor.y - 100, actor.x + 100, actor.y + 100)) do
				if actor2:get("team") ~= actor:get("team") then
					if misc.director:getAlarm(0) == 1 and not actor2:hasBuff(buff.weaken2) then
						if global.rormlflag.ss_classic_weakening_elites then
							if not isaDrone(actor2) then
								actor2:applyBuff(buff.weaken1, 60.5)
							end
						else
							actor2:getData().xAccel = (actor2:getData().xAccel or 0) + 1.2 * math.sign(actor.x - actor2.x)
						end
					end
				end
			end
		end
		if global.quality > 1 and onScreen(actor) and math.chance(10) and actorAc.prefix_type == 1 then
			par.FloatingRocks:burst("middle", actor.x, actor.y, 1, Color.fromRGB(29, 29, 31))
		end
	end
	if actorAc.daze then
		if global.quality > 1 and onScreen(actor) and math.chance(10) and actorAc.prefix_type == 1 then
			par.PixelDust:burst("middle", actor.x, actor.y, 1, Color.WHITE)
		end
	end
	if actorAc.void then
		if global.quality > 1 and onScreen(actor) and math.chance(4) then
			par.VoidPortal:burst("middle", actor.x, actor.y, 1)
		end
		for _, actor2 in pairs(pobj.actors:findAllEllipse(actor.x - 100, actor.y - 100, actor.x + 100, actor.y + 100)) do
			if actor2:get("team") ~= actor:get("team") and actor2:get("void") == nil and actor2.y < actor.y then
				if not isaDrone(actor2) then
					actor2:applyBuff(buff.voided, 30)
				end
			end
		end
	end
	if actorAc.gilded and misc.getTimeStop() == 0 or actorAc.gilded and isa(actor, "PlayerInstance") then
		local isPlayer = isa(actor, "PlayerInstance")
		local sprite = actor.sprite
		if actor.mask then sprite = actor.mask end
		local size = (((sprite.width + sprite.height) / 1.7) * 0.15) + 5
		local target = nil
		if isPlayer then
			local nearEnemies = pobj.actors:findAllEllipse(actor.x - 700, actor.y - 700, actor.x + 700, actor.y + 700)
			for _, enemy in ipairs(nearEnemies) do
				if enemy:get("team") ~= actor:get("team") then
					target = enemy
					break
				end
			end
		elseif actorAc.target then
			target = Object.findInstance(actorAc.target)
		end
		
		if not data.gilded_shield then
			if actorAc.hp > 0 and actorAc.hp <= actorAc.maxhp * 0.3 then
				actor:applyBuff(buff.superShield, 300)
				obj.Boss1Shield:create(actor.x, actor.y - 25)
				data.gilded_shield = true
			end
		elseif isPlayer and actorAc.hp >= actorAc.maxhp then
			data.gilded_shield = false
		end
		
		if actorAc.elite_is_hard == 1 or isPlayer then
			if target and target:isValid() then
				if target.x > actor.x - 700 and target.x < actor.x + 700 and target.y > actor.y - 400 and target.y < actor.y + 400 then
					if data.gilded_cooldown <= 0 then
						if data.gilded_charge < 190 then
							if data.gilded_charge == 0 then
								sGildedLaser:play(0.9 + math.random() * 0.2)
							end
							data.gilded_charge = data.gilded_charge + 1
							--if data.gilded_charge < 170 then
								if data.gilded_aim then
									local xdif = math.abs(data.gilded_aim.x - target.x)
									local ydif = math.abs(data.gilded_aim.y - target.y)
									local p = (190 - data.gilded_charge) / 190
									data.gilded_aim = {x = math.approach(data.gilded_aim.x, target.x, xdif * 0.15 * p), y = math.approach(data.gilded_aim.y, target.y, ydif * 0.15 * p)}
								else
									data.gilded_aim = {x = actor.x, y = actor.y - 20}
								end
							--end
							if misc.director:getAlarm(0) % 10 == 0 then
								local laser = actor:fireExplosion(data.gilded_aim.x, data.gilded_aim.y, size / 19, size / 4, 0.14, nil, spr.Sparks10)
								laser:getData().gildedLaser = true
							end
						else
							data.gilded_aim = nil
							data.gilded_cooldown = 800
							data.gilded_charge = 0
						end
					else
						data.gilded_cooldown = data.gilded_cooldown - 1
					end
				elseif data.gilded_charge > 0 then
					data.gilded_aim = nil
					data.gilded_charge = 0
					data.gilded_cooldown = 120
				end
			else
				data.gilded_aim = nil
				data.gilded_charge = 0
				data.gilded_cooldown = 120
			end
		end
	end
	if actorAc.relic then
		if global.quality > 1 and math.chance(10) then
			par.Relic:burst("middle", actor.x, actor.y, 1)
		end
		if actorAc.activity == 1 and data.lastActiv ~= actorAc.activity then
			local target = Object.findInstance(actorAc.target or -4)
			if target and target:isValid() then
				for i = -1, 1 do
					local skill = obj.BossSkill2old:create(target.x + i * 15, target.y)
					skill:set("team", actorAc.team)
					skill:set("damage", actorAc.damage * 1.6)
				end
				sfx.BossSkill2:play(1.1 + math.random() * 0.2, 0.8)
			end
		end
		data.lastActiv = actorAc.activity
	end
	if actorAc.corrosion then
		local sprite = actor.sprite
		if actor.mask then sprite = actor.mask end
		if global.quality > 1 and onScreen(actor) and math.chance(35) then
			par.Radioactive:burst("middle", math.random(actor.x - sprite.xorigin + sprite.boundingBoxLeft, actor.x - sprite.xorigin + sprite.boundingBoxRight), math.random(actor.y - sprite.yorigin + sprite.boundingBoxTop, actor.y - sprite.yorigin + sprite.boundingBoxBottom), 1)
		end
		if not obj.CorrosiveTrail:findRectangle(actor.x - 3, actor.y - 3, actor.x + 3, actor.y + 97) then
			local trail = obj.CorrosiveTrail:create(actor.x, actor.y - sprite.yorigin + sprite.boundingBoxBottom)
			trail:getData().parent = actor
			trail:getData().team = actorAc.team
			trail:getData().damage = actorAc.damage * 0.04
		end
	end
	if actorAc.ethereal then
		if actorAc.target then
			if actor:isClassic() and not actor:isBoss() then
				if not data.ethTPCooldown then
					data.ethTPCooldown = 120
				elseif data.ethTPCooldown <= 0 then
					data.ethTPCooldown = 600
					data.doEthTP = true
				else
					data.ethTPCooldown = data.ethTPCooldown - 1
				end
			end
			local target = Object.findInstance(actorAc.target)
			if target and target:isValid() then
					
				if not data.ethEXCooldown then
					data.ethEXCooldown = 350
				elseif data.ethEXCooldown <= 0 then
					data.ethEXCooldown = 800
					local bomb = obj.etherealBomb:create(actor.x, actor.y)
					local damage
					if actor:isBoss() then
						damage = 55 * Difficulty.getScaling("damage")
					else
						damage = 35 * Difficulty.getScaling("damage")
						bomb:set("i", 3)
						bomb:set("range", 70)
					end
					bomb:set("damage", damage)
					bomb:getData().parent = actor
					bomb:set("color", Color.fromHex(0x7DC4A6).gml)
					bomb:set("team", actorAc.team)
					
				else
					data.ethEXCooldown = data.ethEXCooldown - 1
				end
				
				if data.doEthTP then
					data.doEthTP = false
					local xOffset = target.x
					local yOffset = target.y
					
					local newX = xOffset
					local newY = yOffset
					
					if target.mask and actor.mask then
						yOffset = target.y - target.mask.yorigin + target.mask.height
						
						newY = yOffset - actor.mask.height + actor.mask.yorigin
					end
					if not actor:collidesMap(xOffset, newY) then
						actor.x = newX
						actor.y = newY
					end
					
					if actor:isClassic() and not actor:collidesMap(actor.x, actor.y + 1) then
						local n = 0
						while not actor:collidesMap(actor.x, actor.y + 3) and n < 50 do
							actor.y = actor.y + 2
							n = n + 1
						end
					end
				end
			end
		end
	end
	if actorAc.empyrean then
		if global.quality > 2 and onScreen(actor) then
			local c = Color.fromHSV( (global.timer + actor.y * (0.75)) % 255, 200, 200)
			par.Dusty:burst("middle", actor.x, actor.y, 1, c)
			par.Electric:burst("middle", actor.x, actor.y, 1, c)
		end
		
		if net.host then
			if not data.empyreanMissileCd then data.empyreanMissileCd = 300 end
			if data.empyreanMissileCd == 0 then
				data.empyreanMissileCd = math.random(100, 500)
			else
				if data.empyreanMissileCd < 6 then
					createSynced(obj.EfMissileEnemy, actor.x, actor.y - 8, empyreanMissileFunc, actor)
				end
				data.empyreanMissileCd = data.empyreanMissileCd - 1
			end
		end
	end
	
	if not actor:isClassic() and not actor:isBoss() then
		--[[if actorAc.fire_trail > 0 then
			if actor:collidesWith(obj.P, actor.x, actor.y) and misc.director:getAlarm(0) == 30 then
				local damager = actor:fireExplosion(actor.x, actor.y, 10 / 19, 10 / 4, 0)
				DOT.addToDamager(damager, DOT_FIRE, actorAc.damage * 0.5, 6, "elite_fire", true)
			end
		end]]
		if actorAc.lightning > 0 then
			if actor:collidesWith(obj.P, actor.x, actor.y) and misc.director:getAlarm(0) == 30 then
				local lightning = obj.ChainLightning:create(actor.x, actor.y)
				lightning:set("damage", math.round(actorAc.damage))
				lightning:set("bounce", 2)
				lightning:set("team", actorAc.team)
				lightning:set("parent", actor.id)
				if actorAc.critical_chance and math.chance(actorAc.critical_chance) then
					lightning:set("critical", 1)
					lightning:set("damage", lightning:get("damage") * 2)
				end
			end
		end
		if actorAc.lifesteal > 0 then
			
		end
		if actorAc.explosive_shot > 0 then
			if actor:collidesWith(obj.P, actor.x, actor.y) and misc.director:getAlarm(0) == 30 then
				local damager = actor:fireExplosion(actor.x, actor.y, 30 / 19, 30 / 4, 0.5)
			end
		end
	end
end)

local sVoidSpawn = Sound.load("VoidSpawn", "Misc/SFX/voidSpawn")
local sGildedSpawn = Sound.load("GildedSpawn", "Misc/SFX/gildedSpawn")
local sCorrosiveSpwan = Sound.load("CorrosiveSpawn", "Misc/SFX/corrosiveSpawn")
local sEtherealSpawn = Sound.load("EtherealSpawn", "Misc/SFX/etherealSpawn")

table.insert(call.postStep, function()
	for _, spawn in ipairs(obj.Spawn:findAll())do
		if onScreen(spawn) and not spawn:getData().elite_check then
			local eliteType = spawn:get("elite_type")
			if eliteType == elt.Void.id then
				sVoidSpawn:play(0.9 + math.random() * 0.2)
			elseif eliteType == elt.Gilded.id then
				sGildedSpawn:play(0.9 + math.random() * 0.2)
			elseif eliteType == elt.Corrosive.id then
				sCorrosiveSpwan:play(0.9 + math.random() * 0.2)
			elseif eliteType == elt.Ethereal.id then
				sEtherealSpawn:play(0.9 + math.random() * 0.2)
				par.Fire4:burst("above", spawn.x, spawn.y, 10, Color.fromHex(0x4EB2A0))
			end
			spawn:getData().elite_check = true
		end
	end
end)

table.insert(call.onHit, function(damager, hit, x, y)
	local damagerParent = damager:getParent()
	
	if damagerParent and damagerParent:isValid() and not damager:getData().cancelDamage then
		local parentAc = damagerParent:getAccessor()
		
		if parentAc.poison then
			if onScreen(hit) then
				sPoison:play(0.9 + math.random() * 0.2)
			end
			DOT.applyToActor(hit, DOT_POISON, damager:get("damage") * 0.25, 4, "poison_elite", true)
		elseif parentAc.weaken then
			if onScreen(hit) then
				sWeaken:play(0.9 + math.random() * 0.2)
			end
			if global.rormlflag.ss_classic_weakening_elites then
				if not isaDrone(hit) then
					hit:applyBuff(buff.weaken2, 240)
				end
			else
				hit:getData().xAccel = 3 * math.sign(damagerParent.x - hit.x)
				hit:set("pVspeed", -4)
			end
		elseif parentAc.daze then
			if not isaDrone(hit) then
				local duration = 120
				if damagerParent:get("elite_is_hard") then
					duration = 180
				end
			--[[	if hit:getObject() == obj.P then
					if onScreen(hit) then
						sDaze:play(1.7 + math.random() * 0.2)
					end
					local dazeTimer = objDazeTimer:create(hit.x, hit.y - 30)
					dazeTimer:getData().duration = duration
					dazeTimer:getData().parent = hit
				else
					if onScreen(hit) then
						sDaze:play(0.9 + math.random() * 0.2)
					end
					hit:applyBuff(buff.daze, duration)
				end]]
				if net.online and net.localPlayer == hit then
					dazeActorSynced(hit, duration)
				elseif not net.online or hit:getObject() ~= obj.P then
					local dazeTimer = objDazeTimer:create(hit.x, hit.y - 30)
					dazeTimer:getData().duration = duration
					dazeTimer:getData().parent = hit
				end
			end
		elseif parentAc.corrosion and not damager:getData().corrosive then
			if onScreen(hit) then
				sCorrode:play(0.9 + math.random() * 0.2)
			end
			if Difficulty.getActive().forceHardElites and not hit:hasBuff(buff.weaken2) then
				if not isaDrone(hit) then
					hit:applyBuff(buff.weaken1, 280)
				end
			end
			DOT.applyToActor(hit, DOT_CORROSION, math.max(damager:get("damage") * 0.25, 1), 5, "corrosive_elite", true)
		elseif parentAc.relic then
			for i = -1, 1 do
				local skill = obj.BossSkill2old:create(hit.x + i * 15, hit.y)
				skill:set("team", parentAc.team)
				skill:set("damage", parentAc.damage * 1.6)
			end
			sfx.BossSkill2:play(1.1 + math.random() * 0.2, 0.8)
		end
	end
	
	if damager:getData().gildedLaser then
		if onScreen(hit) then
			sGildedLaserHit:play(0.9 + math.random() * 0.2)
		end
		local sparks = obj.EfSparks:create(x, y)
		sparks.sprite = spr.JellyMissile
	end
end)

table.insert(call.onDraw, function()
	if misc.getTimeStop() == 0 then
		for _, actor in pairs(pobj.actors:findAll()) do
			local data = actor:getData()
			if actor:get("weaken") and actor:get("elite_is_hard") == 1 then
				for a, actor2 in pairs(pobj.actors:findAllEllipse(actor.x - 100, actor.y - 100, actor.x + 100, actor.y + 100)) do
					if actor2:get("team") ~= actor:get("team") and actor2:get("name") ~= "Drone" then
						if not actor2:get("dead") or actor2:get("dead") == 0 then
							if global.quality > 1 then
								if global.quality > 2 and math.chance(35) or math.chance(10) then
									local randomRatio = math.random(15, distance(actor.x, actor.y, actor2.x, actor2.y))
									local x, y = pointInLine(actor.x, actor.y, actor2.x, actor2.y, randomRatio)
									par.Assassin:burst("middle", x, y, 1)
								end
							else
								graphics.setBlendMode("subtract")
								graphics.alpha(0.75)
								graphics.color(Color.fromRGB(29, 29, 31))
								graphics.line(actor2.x, actor2.y, actor.x, actor.y, 3)
								graphics.alpha(0.25)
								graphics.line(actor2.x, actor2.y, actor.x, actor.y, 6)
								graphics.setBlendMode("normal")
							end
						end
					end
				end
			end
			if actor:get("void") then
				if actor.visible then
					local trail = obj.EfTrail:create(actor.x + math.random(-1, 1), actor.y)
					trail:set("parent", actor.id)
					trail.depth = actor.depth + 1
					trail.xscale = actor.xscale
					trail.yscale = actor.yscale
					trail.angle = actor.angle
					trail.alpha = actor.alpha
					trail.sprite = actor.sprite
					trail.subimage = actor.subimage
					trail.blendColor = Color.fromHex(0x6C4F77)
				end
			end
			if data.poisonCloudTimer then
				local t = 30 - data.poisonCloudTimer
				graphics.drawImage{
					solidColour = Color.fromHex(0xC075EF),
					x = actor.x,
					y = actor.y,
					xscale = actor.xscale,
					yscale = actor.yscale,
					angle = actor.angle,
					image = actor.sprite,
					subimage = actor.subimage,
					alpha = 0.8,
					alpha = t / 30
				}
			end
		end
	end
	for _, actor in pairs(pobj.actors:findMatchingOp("gilded", "==", 1)) do
		local sprite = actor.mask or actor.sprite
		local size = (sprite.width + sprite.height) / 1.7
		
		local hsize = size / 2
		local tsize = size * 0.1
		
		graphics.setBlendMode("additive")
		graphics.alpha(1)
		graphics.color(Color.fromHex(0x83CDCD))
		graphics.circle(actor.x, actor.y - sprite.yorigin - 10, tsize, false)
		graphics.circle(actor.x - hsize, actor.y - sprite.yorigin - 8, tsize, false)
		graphics.circle(actor.x + hsize, actor.y - sprite.yorigin - 8, tsize, false)
		graphics.alpha(math.random(40, 60) / 100)
		local ssize = math.random(10, 30) / 10
		graphics.circle(actor.x, actor.y - sprite.yorigin - 10, (tsize) + ssize, false)
		graphics.circle(actor.x - hsize, actor.y - sprite.yorigin - 8, (tsize) + ssize, false)
		graphics.circle(actor.x + hsize, actor.y - sprite.yorigin - 8, (tsize) + ssize, false)
		local aim = actor:getData().gilded_aim
		if aim then
			graphics.alpha(0.7)
			graphics.line(aim.x + 1, aim.y + 1, actor.x, actor.y - sprite.yorigin - 9, math.ceil(tsize))
			graphics.alpha(math.random(40, 60) / 100)
			graphics.line(aim.x + 1, aim.y + 1, actor.x, actor.y - sprite.yorigin - 9, math.ceil(tsize) + 1)
			local sssize = (size * 0.1) * (actor:getData().gilded_charge * 0.01)
			graphics.circle(aim.x, aim.y, sssize + ssize, false)
		end
		graphics.setBlendMode("normal")
	end
end)

callback("onDraw", function()
	graphics.setBlendMode("additive")
	for _, i in ipairs(pobj.actors:findMatching("prefix_type", 1, "elite_type", elt.Empyrean.id)) do
		graphics.drawImage{i.sprite, i.x, i.y, i.subimage, angle = i.angle, xscale = i.xscale, yscale = i.yscale, solidColour = Colour.fromHSV((global.timer + i.y * (0.75)) % 255, 200, 200), alpha = 0.8}
	end
	graphics.setBlendMode("normal")
end)
table.insert(call.onHUDDraw, function()
	local bid = misc.hud:get("boss_id")
	local binst = Object.findInstance(bid)
	if binst and binst:isValid() and binst:get("empyrean") then
		local w, h = graphics.getGameResolution()
		graphics.alpha(1)
		graphics.color(Color.WHITE)
		local str = binst:get("name")
		misc.hud:set("boss_text1", str)
		local halfW = graphics.textWidth(str, 2) / 2
		graphics.printColor(rainbowStr(str, 70, 0.5), math.ceil(w * 0.5 - halfW), 19, 2)
	end
end)

local eliteDrops
callback.register("onLoad", function()
eliteDrops = {
	[elt.Void.id] = it.EclipsingShard,
	[elt.Gilded.id] = it.FracturedCrown,
	[elt.Corrosive.id] = it.CausticPearl,
	[elt.Ethereal.id] = it.AgelessTotem
}
end)

onNPCDeath.elitedrop = function(npc)
	if net.host and npc:get("prefix_type") == 1 then
		local eliteType = npc:get("elite_type")
		if eliteDrops[eliteType] and math.chance(1) and math.chance(10) then
			eliteDrops[eliteType]:create(npc.x, npc.y)
		end
	end
end