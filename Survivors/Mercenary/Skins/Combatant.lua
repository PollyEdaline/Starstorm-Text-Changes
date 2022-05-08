-- Combatant (Comission)

local path = "Survivors/Mercenary/Skins/Combatant/"

local efColor = Color.fromHex(0xC45050)


local survivor = sur.Mercenary
local sprSelect = Sprite.load("CombatantSelect", path.."Select", 24, 2, 0)
local Combatant = SurvivorVariant.new(survivor, "Combatant", sprSelect, {
	idle = Sprite.load("CombatantIdle", path.."Idle", 1, 4, 6),
	idle_2 = Sprite.load("CombatantIdle_2", path.."Idle_2", 1, 4, 6),
	walk = Sprite.load("CombatantWalk", path.."Walk", 8, 4, 6),
	walk_2 = Sprite.load("CombatantWalk_2", path.."Walk_2", 8, 4, 6),
	jump = Sprite.load("CombatantJump", path.."Jump", 1, 4, 6),
	jump_2 = Sprite.load("CombatantJump_2", path.."Jump_2", 1, 4, 6),
	climb = Sprite.load("CombatantClimb", path.."Climb", 2, 4, 7),
	climb_2 = Sprite.load("CombatantClimb_2", path.."Climb_2", 2, 4, 7),
	death = Sprite.load("CombatantDeath", path.."Death", 9, 8, 10),
	decoy = Sprite.load("CombatantDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.load("CombatantShoot1_1", path.."Shoot1_1", 2, 4, 6),
	shoot1_2 = Sprite.load("CombatantShoot1_2", path.."Shoot1_2", 10, 10, 14),
	shoot2 = Sprite.load("CombatantShoot2", path.."Shoot2", 10, 7, 14),
	shoot3 = Sprite.load("CombatantShoot3", path.."Shoot3", 8, 10, 8),
	shoot4 = Sprite.load("CombatantShoot4", path.."Shoot4", 10, 7, 14),
	shoot5 = Sprite.load("CombatantShoot5", path.."Shoot5", 18, 30, 16),
}, efColor)
SurvivorVariant.setInfoStats(Combatant, {{"Strength", 6}, {"Vitality", 4}, {"Toughness", 5}, {"Agility", 4}, {"Difficulty", 4}, {"Deviance", 5}})
SurvivorVariant.setDescription(Combatant, "The &y&Combatant&!& is a highly armed swordsman trained against any threat known to man.")
Combatant.tag = "Comission"

local sprSkills = Sprite.load("CombatantSkills", path.."Skills", 5, 0, 0)
local sShoot1_2 = Sound.load("CombatantShoot1", path.."Shoot1")
local sShoot2Return = Sound.load("CombatantShoot2Return", path.."Shoot2Return")
local sShoot4 = Sound.load("CombatantShoot4", path.."Shoot4")

 
SurvivorVariant.setLoadoutSkill(Combatant, "PDW", "Fire a high firerate weapon for &y&25% damage&!&.", sprSkills)
SurvivorVariant.setLoadoutSkill(Combatant, "Unsheathe", "Ready up your sword, changing your primary skill for 5 seconds.", sprSkills, 2)
SurvivorVariant.setLoadoutSkill(Combatant, "Marking Blades", "Materialize 3 marking blades. Enemies hit by the blades take guaranteed Critical Strikes for 4 seconds.", sprSkills, 4)

Combatant.endingQuote = "..and so she left, sheating her weapon for the last time."

survivor:addCallback("scepter", function(player)
	if SurvivorVariant.getActive(player) == Combatant then
		player:setSkill(4,
		"Sealing Blades",
		"Materialize 6 marking blades. Enemies hit by the blades take guaranteed Critical Strikes for 4 seconds.",
		sprSkills, 5, 60 * 10)
	end
end)

-- secureCrit
buff.secureCrit = Buff.new("SecureCrit")
buff.secureCrit.sprite = Sprite.load("CombatantBuff", path.."Buff", 1, 9, 9)
buff.secureCrit:addCallback("start", function()
	--sNeedles:play(0.9 + math.random() * 0.2)
end)
local preHitCall = function(damager, hit)
	if damager:get("critical") == 0 and hit:hasBuff(buff.secureCrit) then
		damager:set("critical", 1)
		damager:set("damage", damager:get("damage") * 2)
	end
end

local objCombatantSword = Object.new("CombatantSword")
objCombatantSword.depth = 0.1
objCombatantSword.sprite = Sprite.load("CombatantShoot4Ef", path.."Shoot4Ef", 1, 3, 2)
objCombatantSword:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	selfAc.speed = 5
	selfData.life = 120
	selfData.timer = 10
	self.subimage = 1
	self.spriteSpeed = 0
	selfData.buffDuration = 240
	selfData.particle = par.Smoke3
end)
objCombatantSword:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local data = self:getData()
	
	--selfAc.speed = selfAc.speed + 0.02
	
	self.angle = selfAc.direction
	
	if global.quality > 1 then 
		data.particle:burst("middle", self.x, self.y, 1)
	end
	
	if data.timer > 0 then
		data.timer = data.timer - 1
	else
		if data.target and data.target:isValid() and not data.target:hasBuff(buff.secureCrit) or data.target and data.target:isValid() and data.t_any then
			if data.parent and data.parent:isValid() then
				data.team = data.parent:get("team")
			end
			if data.lastTarget ~= data.target then
				data.life = 80
				data.lastTarget = data.target
			end
			
			local target = data.target
			
			local angle = posToAngle(self.x, self.y, target.x, target.y)
			
			local dif = selfAc.direction - angle
			
			selfAc.direction = selfAc.direction + (angleDif(selfAc.direction, angle) * -0.115 * (selfAc.speed / 3))
			
			
			if self:collidesWith(target, self.x, self.y) then
				data.destroy = true
			end
		else
			local nearestInstance = nil
			for _, enemy in ipairs(pobj.actors:findAll()) do
				if data.team ~= enemy:get("team") and not enemy:hasBuff(buff.secureCrit) then
					if not enemy:get("dead") or enemy:get("dead") == 0 then
						if not enemy:getData()._pbtargetted or enemy:getData()._pbtargetted == self or not enemy:getData()._pbtargetted:isValid() then
							local dis = distance(self.x, self.y, enemy.x, enemy.y)
							if dis < 400 then
								if not nearestInstance or dis < nearestInstance.dis then
									nearestInstance = {inst = enemy, dis = dis}
								end
							end
						end
					end
				end
			end
			if nearestInstance then
				data.target = nearestInstance.inst
			else
				local inst = nearestMatchingOp(self, pobj.actors, "team", "~=", data.team)
				--local inst = pobj.enemies:findNearest(self.x, self.y)
				data.target = inst
				data.t_any = true
				if inst and inst:isValid() then
					inst:getData()._pbtargetted = self
				end
			end
		end
	end
	
	--[[if self:collidesMap(self.x, self.y) then
		data.destroy = true
		sPyroBullet:play(0.9 + math.random() * 0.2)
		local damager = data.parent:fireExplosion(self.x, self.y, 4 / 19, 4 / 4, 0.5, sprBulletExplosion)
		DOT.addToDamager(damager, DOT_FIRE, data.parent:get("damage") * 0.3, 10, "pyro_fire", false)
	end]]
	
	if data.life <= 0 or data.destroy then
		if data.parent and data.parent:isValid() then
			if data.target and data.target:isValid() then
				data.target:applyBuff(buff.secureCrit, data.buffDuration)
				sShoot4:play(0.9 + math.random() * 0.2)
			end
		end
		local sparks = obj.EfSparks:create(self.x, self.y)
		sparks.sprite = spr.Sparks6
		self:destroy()
	else
		data.life = data.life - 1
	end
end)

callback.register("onSkinInit", function(player, skin)
	if skin == Combatant then
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(167, 12.5, 0.043)
		else
			player:survivorSetInitialStats(117, 12.5, 0.013)
		end
		player:setSkill(1,
		"PDW",
		"Fire a high firerate weapon for 30% damage.",
		sprSkills, 1, 2)
		player:setSkill(2,
		"Unsheathe",
		"Ready up your sword, changing your primary skill for 5 seconds.",
		sprSkills, 2, 10 * 60)
		player:setSkill(4,
		"Marking Blades",
		"Materialize 3 marking blades. Enemies hit by the blades get guaranteed critical hits for 4 seconds.",
		sprSkills, 4, 10 * 60)
		
		player:setAnimation("idle_1", player:getAnimation("idle"))
		player:setAnimation("walk_1", player:getAnimation("walk"))
		player:setAnimation("climb_1", player:getAnimation("climb"))
		player:setAnimation("jump_1", player:getAnimation("jump"))
		tcallback.register("preHit", preHitCall)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Combatant then
		player:survivorLevelUpStats(3, 0.3, -0.002, 1)
	end
end)
SurvivorVariant.setSkill(Combatant, 1, function(player)
	if player:getData().xtimer and player:getData().xtimer > 0 then
		SurvivorVariant.activityState(player, 1.1, player:getAnimation("shoot1_2"), 0.25, true, true)
	else
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_1"), 0.25, true, true)
	end
end)
SurvivorVariant.setSkill(Combatant, 2, function(player)
	player:set("pVspeed", 0)
	SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2"), 0.25, true, true)
end)
SurvivorVariant.setSkill(Combatant, 4, function(player)
	SurvivorVariant.activityState(player, 4, player:getAnimation("shoot4"), 0.25, true, true)
end)
callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
	if variant == Combatant then
		local playerAc = player:getAccessor()
		if skill == 1 then
			if relevantFrame == 1 then
				sfx.Bullet1:play(1.1 + math.random() * 0.2)
				if not player:survivorFireHeavenCracker(0.4) then
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 310, 0.25, spr.Sparks1)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			end
		elseif skill == 1.1 then
			if relevantFrame == 1 then
				sfx.SamuraiShoot1:play(0.8 + math.random() * 0.2)
				for i = 0, playerAc.sp do
					local chain = obj.ChainLightning:create(player.x + 10 * player.xscale, player.y)
					chain:set("blend", efColor.gml)
					chain:set("parent", player.id)
					chain:set("team", playerAc.team)
					chain:set("damage", math.ceil(playerAc.damage))
					local bullet = player:fireExplosion(player.x + player.xscale * 8, player.y, 20 / 19, 5 / 4, 1.5)
					--bullet:set("knockback", 6)
					bullet:set("stun", 1)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
		elseif skill == 2 then
			if relevantFrame == 6 then
				player:setAnimation("idle", player:getAnimation("idle_2"))
				player:setAnimation("walk", player:getAnimation("walk_2"))
				player:setAnimation("climb", player:getAnimation("climb_2"))
				player:setAnimation("jump", player:getAnimation("jump_2"))
				player:setSkill(1,
				"Saturnian Katana",
				"Slash a katana for 250% lightning damage. Stuns enemies.",
				sprSkills, 3, 10)
				--local outline = obj.EfOutline:create(0, 0)
				--outline:set("parent", player.id)
				--outline.blendColor = efColor
				player:getData().xtimer = 300
				sShoot1_2:play(0.7 + math.random() * 0.2)
			end
		elseif skill == 4 then
			if relevantFrame == 2 then
				local b = objCombatantSword:create(player.x, player.y)
				b:getData().parent = player
				b:getData().team = playerAc.team
				b:set("direction", player:getFacingDirection() + 20 * (player.xscale))
				sShoot1_2:play(1.1 + math.random() * 0.2)
				if playerAc.scepter > 0 then
					b:getData().particle = par.FireIce
				end
			elseif relevantFrame == 6 then
				local b = objCombatantSword:create(player.x, player.y)
				b:getData().parent = player
				b:getData().team = playerAc.team
				b:set("direction", player:getFacingDirection() + 45 * (player.xscale))
				sShoot1_2:play(1.1 + math.random() * 0.2)
				if playerAc.scepter > 0 then
					b:getData().particle = par.FireIce
				end
			elseif relevantFrame == 9 then
				local b = objCombatantSword:create(player.x, player.y)
				b:getData().parent = player
				b:getData().team = playerAc.team
				b:set("direction", player:getFacingDirection() + 10 * (player.xscale))
				sShoot1_2:play(1.1 + math.random() * 0.2)
				if playerAc.scepter > 0 then
					b:getData().particle = par.FireIce
				end
			end
			if playerAc.scepter > 0 then
				if relevantFrame == 4 or relevantFrame == 7 or relevantFrame == 10 then
					for i = 0, playerAc.scepter do
						local b = objCombatantSword:create(player.x, player.y)
						b:getData().parent = player
						b:getData().team = playerAc.team
						b:set("direction", player:getFacingDirection() + (15 + i * 5) * (player.xscale))
						b:getData().particle = par.FireIce
					end
					sShoot1_2:play(1.2 + math.random() * 0.2)
				end
			end
		end
	end
end)
survivor:addCallback("step", function(player)
	if SurvivorVariant.getActive(player) == Combatant then
		local data = player:getData()
		if data.xtimer then
			if data.xtimer > 0 then
				data.xtimer = data.xtimer - 1
			else
				player:setAnimation("idle", player:getAnimation("idle_1"))
				player:setAnimation("walk", player:getAnimation("walk_1"))
				player:setAnimation("climb", player:getAnimation("climb_1"))
				player:setAnimation("jump", player:getAnimation("jump_1"))
				data.xtimer = nil
				player:setSkill(1,
				"PDW",
				"Fire a high firerate weapon for 25% damage.",
				sprSkills, 1, 2)
				sShoot2Return:play(0.9 + math.random() * 0.2)
			end
		end
	end
end)