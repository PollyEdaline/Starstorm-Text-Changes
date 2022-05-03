-- BUFFS & DEBUFFS

spr.Buffs:replace(Sprite.load("ssbuffs", "Gameplay/buffs", 63, 9, 9))

-- Disease
buff.disease = Buff.new("disease")
local bugGuts = obj.BugGuts
buff.disease.sprite = spr.Buffs
buff.disease.subimage = 47
buff.disease:addCallback("start", function(actor)
	actor:getData().diseaseTimer = 0
end)	
local diseaseDamageColor = Color.fromRGB(187, 211, 91)
buff.disease:addCallback("step", function(actor, timeLeft)
	if actor and actor:isValid() then
		local actorAc = actor:getAccessor()
		local damage = actorAc.maxhp / 21
		if actor:getData().diseaseTimer >= 60 then
			if not actorAc.invincible or actorAc.invincible <= 0 then
				actorAc.hp = actorAc.hp - damage
			end
			if global.showDamage then
				misc.damage(damage, actor.x, actor.y - 10 , false, diseaseDamageColor)
			end
			actor:getData().diseaseTimer = 0
		else
			actor:getData().diseaseTimer = actor:getData().diseaseTimer + 1
		end
	end
end)
	
-- Intoxication
buff.intoxication = Buff.new("intoxication")
buff.intoxication.sprite = spr.Buffs
buff.intoxication.subimage = 49
buff.intoxication:addCallback("start", function(actor)
	actor:getData().toxicTimer = 0
end)
local intoxicationDamageColor = Color.fromRGB(62, 196, 85)
buff.intoxication:addCallback("step", function(actor, timeLeft)
	if actor:isValid() then
		if actor:getData().toxicTimer >= 60 then
			local actorAc = actor:getAccessor()
			local damage = math.ceil((actorAc.hp * 0.03 * timeLeft / 60) * (100 / (100 + actorAc.armor)))
			--local damage = math.ceil((actorAc.hp * 0.015 * timeLeft / 60) * (100 / (100 + actorAc.armor)))
			if not actorAc.invincible or actorAc.invincible <= 0 then
				actorAc.hp = actorAc.hp - damage
			end
			if global.showDamage then
				misc.damage(damage, actor.x, actor.y - 10 , false, intoxicationDamageColor)
			end
			actor:getData().toxicTimer = 0
			if onScreen(actor) then
				for i = 1, 2 do
					bugGuts:create(actor.x, actor.y)
				end
			end
		else
			actor:getData().toxicTimer = actor:getData().toxicTimer + 1
		end
	end
end)

-- Radiation
local sRadiation1 = Sound.load("Radiation1", "Misc/SFX/radiation1")
local sRadiation2 = Sound.load("Radiation2", "Misc/SFX/radiation2")
local sRadiation3 = Sound.load("Radiation3", "Misc/SFX/radiation3")
local actors = pobj.actors
buff.radiation = Buff.new("radiation")
buff.radiation.sprite = spr.Buffs
buff.radiation.subimage = 50
buff.radiation:addCallback("start", function(actor)
	actor:getData().radiate = 1
	--[[if not actor:getData().lastGravity then
		actor:getData().lastGravity = {actor:get("pGravity1"), actor:get("pGravity2")}
		actor:set("pGravity1", 0.15)
		actor:set("pGravity2", 0.15)
	end]]
end)
buff.radiation:addCallback("step", function(actor)
	if misc.director:getAlarm(0) == 30 then
		local explosion = actor:fireExplosion(actor.x, actor.y, 15 / 19, 15 / 4, 0.5)
		if onScreen(actor) then
			if global.quality > 1 then
				par.Nuclear:burst("middle", actor.x, actor.y, 10)
			end
		end
	end
	local actorAc = actor:getAccessor()
	if actorAc.pVspeed > 0 then
		actorAc.pVspeed = math.approach(actorAc.pVspeed, 0, 0.1)
	end
	--[[if actorAc.ropeUp and actorAc.ropeUp == 1 then
		if actorAc.pVspeed > -actorAc.pHmax * 0.6 then
			actorAc.pVspeed = actorAc.pVspeed - 0.2
		end
	end
	if actorAc.ropeDown and actorAc.ropeDown == 1 then
		if actorAc.pVspeed < actorAc.pHmax then
			actorAc.pVspeed = actorAc.pVspeed + 0.2
		end
	end]]
end)
buff.radiation:addCallback("end", function(actor)
	actor:getData().radiate = 0 
	--[[if actor:getData().lastGravity then
		local g1 = actor:getData().lastGravity[1]
		local g2 = actor:getData().lastGravity[2]
		actor:set("pGravity1", actor:get("pGravity1") + g1 - 0.15)
		actor:set("pGravity2", actor:get("pGravity2") + g2 - 0.15)
		actor:getData().lastGravity = nil
	end]]
end)
table.insert(call.onHit, function(damager, hit)
	local damagerParent = damager:getParent()
	if damagerParent and damagerParent:isValid() then
		if damagerParent:getData().radiate and damagerParent:getData().radiate == 1 or damager:getData().radiate then
			local damage = damager:get("damage") * 0.22
			if hit:getData().radiation then
				if hit:getData().radiationDmg < damage then
					hit:getData().radiationDmg = damage
				end
			else
				hit:getData().radiationDmg = damage
			end
			hit:getData().radiation = 8
			hit:getData().radTimer = 0
		end
	end
end)
callback.register("onActorStep", function(actor)
	local actorAc = actor:getAccessor()
	if actor:getData().radiation and actor:getData().radiation > 0 then
		if actor:getData().radTimer <= 0 then
			actor:getData().radTimer = 100
			local damageDone = actor:getData().radiationDmg * (300 / (300 + actorAc.armor))
			if global.showDamage and math.floor(damageDone) > 0 then
				misc.damage(damageDone, actor.x, actor.y - (actor.sprite.height / 2) - 11, false, Color.YELLOW)
			end
			actorAc.hp = actorAc.hp - damageDone
			actor:getData().radiation = actor:getData().radiation - 1
			if onScreen(actor) then
				table.random({sRadiation1, sRadiation2, sRadiation3}):play(1)
			end
		else
			actor:getData().radTimer = actor:getData().radTimer - 1
		end
		if onScreen(actor) and math.chance(15) then
			par.Nuclear:burst("middle", actor.x, actor.y, 1)
		end
	end
end)

-- Bolster
buff.bolster = Buff.new("bolster")
buff.bolster.sprite = spr.Buffs
buff.bolster.subimage = 51
buff.bolster:addCallback("start", function(actor)
	local hdamage = actor:get("damage") * 0.5
	actor:getData().bDamageAdd = hdamage
	actor:set("damage", actor:get("damage") + hdamage)
	actor:set("pHmax", actor:get("pHmax") + 0.3) 
	actor:set("critical_chance", actor:get("critical_chance") + 30)
end)
buff.bolster:addCallback("step", function(actor)
	par.IceRelic:burst("middle", actor.x, actor.y, 1, Color.GREEN)
end)
buff.bolster:addCallback("end", function(actor)
	local hdamage = actor:getData().bDamageAdd
	actor:set("damage", actor:get("damage") - hdamage)
	actor:set("pHmax", actor:get("pHmax") - 0.3)
	actor:set("critical_chance", actor:get("critical_chance") - 30)
	actor:getData().bDamageAdd = nil 
end)

-- Hydrated 1
buff.hydrated1 = Buff.new("hydrated1")
buff.hydrated1.sprite = spr.Buffs
buff.hydrated1.subimage = 52
buff.hydrated1:addCallback("start", function(actor)
	actor:set("pHmax", actor:get("pHmax") + 0.31) 
	actor:set("attack_speed", actor:get("attack_speed") + 0.34) 
end)
buff.hydrated1:addCallback("end", function(actor)
	actor:set("pHmax", actor:get("pHmax") - 0.31) 
	actor:set("attack_speed", actor:get("attack_speed") - 0.34) 
end)

-- Hydrated 2
buff.hydrated2 = Buff.new("hydrated2")
buff.hydrated2.sprite = spr.Buffs
buff.hydrated2.subimage = 59
buff.hydrated2:addCallback("start", function(actor)
	actor:set("pHmax", actor:get("pHmax") + 0.36) 
	actor:set("attack_speed", actor:get("attack_speed") + 0.36)
	actor:set("critical_chance", actor:get("critical_chance") + 17)
end)
buff.hydrated2:addCallback("end", function(actor)
	actor:set("pHmax", actor:get("pHmax") - 0.36) 
	actor:set("attack_speed", actor:get("attack_speed") - 0.36)
	actor:set("critical_chance", actor:get("critical_chance") - 17)
end)

-- Daze
buff.daze = Buff.new("daze")
buff.daze.sprite = spr.Buffs
buff.daze.subimage = 53
buff.daze:addCallback("step", function(actor)
	if actor:isValid() then
		local actorAc = actor:getAccessor()
		if isa(actor, "PlayerInstance") or misc.director:getAlarm(0) % 30 == 0 then
			if actorAc.moveLeft == 1 then
				actorAc.moveLeft = 0
				actorAc.moveRight = 1
			elseif actorAc.moveRight == 1 then
				actorAc.moveLeft = 1
				actorAc.moveRight = 0
			end
		end
	end
end)

-- Ultra
buff.ultra = Buff.new("ultra")
buff.ultra.sprite = Sprite.load("Ultra_Buff", "Gameplay/ultraBuff", 6, 9, 9)
buff.ultra.frameSpeed = 0.25
buff.ultra:addCallback("start", function(actor)
	actor:set("ultraAspect", 1) 
	
	local hpDif = actor:get("maxhp") * 1.1
	actor:getData().uhpDif = hpDif
	if isa(actor, "PlayerInstance") then
		actor:set("maxhp_base", actor:get("maxhp_base") + hpDif) 
	else
		actor:set("maxhp", actor:get("maxhp") + hpDif) 
	end
	actor:set("hp", actor:get("hp") + hpDif)
	actor:set("pHmax", actor:get("pHmax") - 0.3)
	local dmgDif = actor:get("damage") * 0.6
	actor:getData().dmgDif = dmgDif
	actor:set("damage", actor:get("damage") + dmgDif)
end)
buff.ultra:addCallback("end", function(actor)
	actor:set("ultraAspect", 0) 
	local hpDif = actor:getData().uhpDif
	if isa(actor, "PlayerInstance") then
		actor:set("maxhp_base", actor:get("maxhp_base") - hpDif)
	else
		actor:set("maxhp", actor:get("maxhp") - hpDif)
	end
	actor:set("pHmax", actor:get("pHmax") + 0.3)
	local dmgDif = actor:getData().dmgDif
	actor:set("damage", actor:get("damage") - dmgDif) 
end)

-- Voided
local sVoided = Sound.load("Voided", "Misc/SFX/voided")
local sUnvoided = Sound.load("Unvoided", "Misc/SFX/unvoided")
buff.voided = Buff.new("voided")
buff.voided.sprite = spr.Buffs
buff.voided.subimage = 54
buff.voided:addCallback("start", function(actor)
	if actor:isValid() then
		local actorAc = actor:getAccessor()
		local mult = 0.25
		if Difficulty.getActive().forceHardElites then
			mult = 0.4
		end
		if actorAc.pHmax then
			local deduct = actorAc.pHmax * mult
			actorAc.pHmax = actorAc.pHmax - deduct
			actor:getData().void_slow = deduct
		end
		sVoided:play(0.9 + math.random() * 0.2)
	end
end)
buff.voided:addCallback("step", function(actor)
	if actor:isValid() then
		local actorAc = actor:getAccessor()
		local mult = 0.7
		if Difficulty.getActive().forceHardElites then
			mult = 0.6
		end
		if actorAc.pVspeed and actorAc.pVspeed > 0 then
			actorAc.pVspeed = actorAc.pVspeed * mult
		end
		if math.chance(30) then
			par.PortalPixel:burst("middle", actor.x, actor.y, 1)
		end
	end
end)
buff.voided:addCallback("end", function(actor)
	local actorAc = actor:getAccessor()
	if actorAc.pVspeed and actor:getData().void_slow then
		actorAc.pHmax = actorAc.pHmax + actor:getData().void_slow
		actor:getData().void_slow = nil
	end
	sUnvoided:play(0.9 + math.random() * 0.2)
end)

-- Shell Piece
local shellPieced = {}
buff.shellPiece = Buff.new("shellPiece")
buff.shellPiece.sprite = spr.Buffs
buff.shellPiece.subimage = 55
local shellColor = Color.fromHex(0x856B5C)
buff.shellPiece:addCallback("start", function(actor)
	if actor:isValid() then
		local actorAc = actor:getAccessor()
		actorAc.invincible = actorAc.invincible + 2
		actor:getData().preShellColor = actor.blendColor
		actor.blendColor = shellColor
		shellPieced[actor] = true
	end
end)
buff.shellPiece:addCallback("step", function(actor)
	if actor:isValid() then
		local actorAc = actor:getAccessor()
		actorAc.hp = math.max(actorAc.hp, 1)
		actorAc.invincible = actorAc.invincible + 1
	end
end)
buff.shellPiece:addCallback("end", function(actor)
	if actor:isValid() then
		shellPieced[actor] = nil
	end
end)
table.insert(call.onStageEntry, function()
	shellPieced = {}
end)
buff.shellPiece:addCallback("end", function(actor)
	if actor:isValid() then
		actor.blendColor = actor:getData().preShellColor
		actor:getData().preShellColor = nil
	end
end)

-- Chirr Heal
buff.chirrHeal = Buff.new("chirrHeal")
buff.chirrHeal.sprite = spr.Buffs
buff.chirrHeal.subimage = 7
buff.chirrHeal:addCallback("start", function(actor)
	if actor:isValid() then
		local actorAc = actor:getAccessor()
		local val = actorAc.maxhp * 0.002
		actorAc.hp_regen = actorAc.hp_regen + val
		actor:getData().chirrHealVal = val
	end
end)
buff.chirrHeal:addCallback("end", function(actor)
	if actor:isValid() then
		local actorAc = actor:getAccessor()
		local val = actor:getData().chirrHealVal
		actorAc.hp_regen = actorAc.hp_regen - val
		actor:getData().chirrHealVal = nil
	end
end)

-- Nemesis Bandit Pull
buff.nBanditPull = Buff.new("nbanditPull")
buff.nBanditPull.sprite = spr.Buffs
buff.nBanditPull.subimage = 2
buff.nBanditPull:addCallback("step", function(actor, time)
	if actor:isValid() then
		local dir = actor:getData()._pullDir
		if dir then
			local newX = actor.x + (time * 0.09 * dir)
			if not actor:collidesMap(newX, actor.y) then
				actor.x = newX
			end
		end
	end
end)

-- Needles
buff.needles = Buff.new("needles")
buff.needles.sprite = spr.Buffs
buff.needles.subimage = 57
local sNeedles = Sound.load("Needles", "Items/Resources/needles")
buff.needles:addCallback("start", function()
	sNeedles:play(0.9 + math.random() * 0.2)
end)
table.insert(call.preHit, function(damager, hit)
	if damager:get("critical") == 0 and hit:hasBuff(buff.needles) then
		damager:set("critical", 1)
		damager:set("damage", damager:get("damage") * 2)
	end
end)

-- Weaken
buff.weaken1 = Buff.new("weaken1")
buff.weaken1.sprite = spr.Buffs
buff.weaken1.subimage = 60
if global.rormlflag.ss_classic_weakening_elites then
	buff.weaken1:addCallback("start", function(actor)
		actor:set("armor", actor:get("armor") - 25)
	end)
	buff.weaken1:addCallback("end", function(actor)
		if actor:isValid() then
			actor:set("armor", actor:get("armor") + 25)
		end
	end)
else
	buff.weaken1:addCallback("start", function(actor)
		actor:set("pHmax", actor:get("pHmax") - 0.2)
		actor:set("attack_speed", actor:get("attack_speed") - 0.2)
	end)
	buff.weaken1:addCallback("end", function(actor)
		if actor:isValid() then
			actor:set("pHmax", actor:get("pHmax") + 0.2)
			actor:set("attack_speed", actor:get("attack_speed") + 0.2)
		end
	end)
end

buff.weaken2 = Buff.new("weaken2")
buff.weaken2.sprite = spr.Buffs
buff.weaken2.subimage = 61
if global.rormlflag.ss_classic_weakening_elites then
	buff.weaken2:addCallback("start", function(actor)
		if actor:hasBuff(buff.weaken1) then
			actor:removeBuff(buff.weaken1)
		end
		actor:set("armor", actor:get("armor") - 50)
	end)
	buff.weaken2:addCallback("end", function(actor)
		actor:set("armor", actor:get("armor") + 50)
	end)
else
	buff.weaken2:addCallback("start", function(actor)
		if actor:hasBuff(buff.weaken1) then
			actor:removeBuff(buff.weaken1)
		end
		actor:set("pHmax", actor:get("pHmax") - 0.5)
		actor:set("attack_speed", actor:get("attack_speed") - 0.4)
	end)
	buff.weaken2:addCallback("end", function(actor)
		actor:set("pHmax", actor:get("pHmax") + 0.5)
		actor:set("attack_speed", actor:get("attack_speed") + 0.4)
	end)
end

buff.noteam = Buff.new("noteam")
buff.noteam.sprite = Sprite.load("NoteamBuff", "Items/Resources/".."mindShiftBuff", 1, 9, 9)
buff.noteam:addCallback("start", function(actor)
	if actor and actor:isValid() then
		local actorAc = actor:getAccessor()
		actor:getData().preTeamRemovalTeam = actorAc.team
		actorAc.team = "t"..actor.id
	end
end)
buff.noteam:addCallback("step", function(actor)
	if actor and actor:isValid() and actor:get("target") then
		local target = nearestMatchingOp(actor, pobj.actors, "team", "~=", actor:get("team"))
		if target then
			actor:set("target", target.id)
		end
	end
end)
buff.noteam:addCallback("end", function(actor)
	if actor and actor:isValid() then
		local actorAc = actor:getAccessor()
		actorAc.team = actor:getData().preTeamRemovalTeam
		actor:getData().preTeamRemovalTeam = nil
		
		if actorAc.target then
			actorAc.target = -4
		end
	end
end)