
-- All MULE data

local path = "Survivors/MULE/"

local mule = Survivor.new("MULE")

-- Particles
local parSkill = par.Fire4
local parDust = par.Debris

-- Sounds
local sMuleSkill1a = Sound.load("MuleSkill1A", path.."skill1a")
local sMuleSkill1b = Sound.load("MuleSkill1B", path.."skill1b")
local sMuleSkill1c = Sound.load("MuleSkill1C", path.."skill1c")
local sMuleSkill2a = Sound.load("MuleSkill2A", path.."skill2a")
local sMuleSkill2b = Sound.load("MuleSkill2B", path.."skill2b")
local sMuleSkill3 = Sound.load("MuleSkill3", path.."skill3")
local sMuleSkill4a = Sound.load("MuleSkill4A", path.."skill4a")
local sMuleSkill4b = Sound.load("MuleSkill4B", path.."skill4b")
local sMuleSkill4c = Sound.load("MuleSkill4C", path.."skill4c")
local sMuleSkill4d = Sound.load("MuleSkill4D", path.."skill4d")
local sMuleSkill4e = Sound.load("MuleSkill4E", path.."skill4e")

-- Buffs
local trappedEnemies = {}
buff.mulesnare = Buff.new("mulesnare")
buff.mulesnare.sprite = spr.Buffs
buff.mulesnare.subimage = 48
buff.mulesnare:addCallback("start", function(actor)
	actor:set("pHmax", actor:get("pHmax") - 2)
	if not actor:isBoss() then
		if actor:getAnimation("idle") then
			actor.sprite = actor:getAnimation("idle")
		end
		actor:set("activity", 46)
		actor:set("pHspeed", 0)
	end
	trappedEnemies[actor] = true
end)
buff.mulesnare:addCallback("step", function(actor)
	if actor:isValid() then
		if not actor:isBoss() then
			actor:set("activity", 46)
			actor:set("pHspeed", 0)
		end
	end
end)
buff.mulesnare:addCallback("end", function(actor)
	actor:set("pHmax", actor:get("pHmax") + 2)
	if not actor:isBoss() then
		actor:set("activity", 0)
	end
	trappedEnemies[actor] = nil
end)

buff.trap = Buff.new("trap")
buff.trap.sprite = Sprite.load("Trap_Debuff", path.."trapdebuff", 8, 9, 9)
buff.trap.frameSpeed = 0.25
buff.trap:addCallback("start", function(actor)
	sMuleSkill2b:play(0.9 + math.random() * 0.2, 1)
	if isa(actor, "PlayerInstance") then
		actor:setAlarm(7, 60)
	end
	for _, v in ipairs(pobj.enemies:findAllEllipse(actor.x - 140, actor.y - 100, actor.x + 140, actor.y + 100)) do
		if v:get("team") == actor:get("team") then
			v:applyBuff(buff.mulesnare, 3 * 60)
			v:getData().trapParent = actor
		end
	end
	trappedEnemies[actor] = true
end)
buff.trap:addCallback("end", function(actor)
	trappedEnemies[actor] = nil
end)
local onDrawCall = function()
	for actor, _ in pairs(trappedEnemies) do
		if actor:isValid() then
			local parent = actor:getData().trapParent
			if parent and parent:isValid() and global.quality > 1 then
				if not actor:getData().trapOffset then
					actor:getData().trapOffset = {a = math.random(-4, 4), b = actor.x + math.random(-8, 8)}
					
					local yy = 0
					while yy < 100 and not Stage.collidesPoint(actor.x, actor.y + yy) do
						yy = yy + 2
					end
					if yy < 100 and not actor:getData().trapOffset.c then
						actor:getData().trapOffset.c = actor.y + yy
					else
						actor:getData().trapOffset.c = nil
					end
				end
				
				graphics.alpha(0.8)
				graphics.color(Color.fromRGB(205, 205, 205))
				graphics.line(actor.x, actor.y, parent.x, parent.y + actor:getData().trapOffset.a, 1.5)
				
				if actor:getData().trapOffset.c then
					graphics.line(actor.x, actor.y, actor:getData().trapOffset.b, actor:getData().trapOffset.c, 1.5)
				end
			end
		else
			trappedEnemies[actor] = nil
		end
	end
end

-- Table sprites
local sprites = {
	idle = Sprite.load("Mule_Idle", path.."idle", 1, 6, 11),
	walk = Sprite.load("Mule_Walk", path.."walk", 8, 9, 13),
	jump = Sprite.load("Mule_Jump", path.."jump", 1, 6, 11),
	climb = Sprite.load("Mule_Climb", path.."climb", 2, 5, 9),
	death = Sprite.load("Mule_Death", path.."death", 6, 9, 12),
	decoy = Sprite.load("Mule_Decoy", path.."decoy", 1, 9, 13),
	
	shoot1_1 = Sprite.load("Mule_Shoot1A", path.."shoot1a", 6, 9, 11),
	shoot1_2_1 = Sprite.load("Mule_Shoot1B1", path.."shoot1b1", 6, 6, 11),
	shoot1_2_2 = Sprite.load("Mule_Shoot1B2", path.."shoot1b2", 6, 6, 11),
	shoot1_3 = Sprite.load("Mule_Shoot1C", path.."shoot1c", 6, 6, 11),
	shoot2 = Sprite.load("Mule_Shoot2", path.."shoot2", 7, 10, 11),
	shoot3 = Sprite.load("Mule_Shoot3", path.."shoot3", 15, 15, 12),
	shoot4_1 = Sprite.load("Mule_Shoot4", path.."shoot4", 15, 13, 18),
	shoot4_2 = Sprite.load("Mule_Shoot5", path.."shoot5", 15, 13, 18),
	
	drone1_1 = Sprite.load("Mule_DroneA", path.."dronea", 4, 5, 5),
	drone1_2 = Sprite.load("Mule_DroneA_Repair", path.."droneaRegen", 2, 5, 5),
	drone2_1 = Sprite.load("Mule_DroneB", path.."droneb", 4, 6, 6),
	drone2_2 = Sprite.load("Mule_DroneB_Repair", path.."dronebRegen", 2, 6, 6)
}
-- Hit sprites
local sprMuSparks1 = Sprite.load("Mule_Sparks1", path.."sparks1", 3, 5, 8)
local sprMuSparks2 = Sprite.load("Mule_Sparks2", path.."sparks2", 4, 7, 5)
local sprMuSparks3 = Sprite.load("Mule_Sparks3", path.."sparks3", 4, 4, 8)
-- Skill sprites
local sprSkills = Sprite.load("Mule_Skills", path.."skills", 5, 0, 0)

-- Selection sprite
mule.loadoutSprite = Sprite.load("Mule_Select", path.."select", 16, 2, 0)

-- Selection description
mule:setLoadoutInfo(
[[EVERY &y&MULE&!& UNIT IS ADEQUATELY EQUIPPED AND READY FOR DUTY.
BUILT WITH HIGH QUALITY MATERIALS FOR MAXIMUM WORK PERFORMANCE.
THIS MODEL INCLUDES THE &y&FORAGER SET OF TOOLS&!&, PERFECT FOR &r&HUNTING&!&, &b&EXPLORATION&!&,
AND OTHER TASKS DANGEROUS FOR THE COMMON USER.
IN ORDER TO INITIALIZE, PLEASE STATE A DIRECTIVE ON SYSTEM BOOT.]], sprSkills)

-- Skill descriptions
mule:setLoadoutSkill(1, "INTERFERENCE REMOVAL",
[[PUNCH COMBATANTS FOR &y&260% DAMAGE&!&.
HOLD TO CHARGE AND SMASH THE GROUND FOR &y&1200% DAMAGE&!&.]])

mule:setLoadoutSkill(2, "IMMOBILIZE",
[[FIRE A TRAP WHICH DEALS &y&125% DAMAGE&!&.
THE TRAP &b&SNARES&!& ALL COMBATANTS IN THE AREA.]])

mule:setLoadoutSkill(3, "TORQUE CALIBRATION",
[[&y&SPIN FORWARD&!& INFLICTING &y&4X100% DAMAGE&!&.
THE LAST HIT &y&STUNS&!&.]])

mule:setLoadoutSkill(4, "FAIL-SAFE ASSISTANCE",
[[DEPLOY A PERSONAL REPAIR DRONE FOR 8 SECONDS.
THE DRONE &g&HEALS 5X7% OF YOUR TOTAL HEALTH&!&.
AT FULL HEALTH, &y&GRANTS A TEMPORARY SHIELD INSTEAD&!&.]])

-- Color of highlights during selection
mule.loadoutColor = Color.fromRGB(211,176,122)

-- Misc. menus sprite
mule.idleSprite = sprites.idle

-- Main menu sprite
mule.titleSprite = sprites.walk

-- Endquote
mule.endingQuote = "..and so it left, pistons creaking, directive unstated."

local onHitCall = function(bullet, hit)
	local parent = bullet:getParent()
	local team = "player"
	if parent and parent:isValid() then
		team = parent:get("team")
	end
	
	if hit:get("team") ~= team and bullet:getData().immobilize then
		hit:applyBuff(buff.trap, 3*60)
	end
end

-- Stats & Skills
mule:addCallback("init", function(player)
	local playerAc = player:getAccessor()
	playerAc.skill1Attack = 0
	playerAc.attackSide = 0	
	playerAc.pHmax = playerAc.pHmax + 0.05
	
	player:setAnimations(sprites)
	
	if Difficulty.getActive() == dif.Drizzle then
		player:survivorSetInitialStats(165, 11, 0.042)
	else
		player:survivorSetInitialStats(115, 11, 0.012)
	end
	
	player:setSkill(1,
		"INTERFERENCE REMOVAL",
		"PUNCH COMBATANTS FOR 260% DAMAGE. HOLD TO CHARGE AND SMASH THE GROUND FOR 1200% DAMAGE.",
		sprSkills, 1,
		10
	)
	player:setSkill(2,
		"IMMOBILIZE",
		"FIRE A TRAP AT A GROUP OF COMBATANTS, SNARING THEM.",
		sprSkills, 2,
		4 * 60
	)
	player:setSkill(3,
		"TORQUE CALIBRATION",
		"SPIN FORWARD FOR 100%X4 DAMAGE. THE LAST HIT STUNS.",
		sprSkills, 3,
		4 * 60
	)
	player:setSkill(4,
		"FAIL-SAFE ASSISTANCE",
		"LAUNCH A HEALING DRONE LASTING 8 SECONDS, HEALING YOU 5X7% OF YOUR TOTAL HEALTH. AT FULL HEALTH, GRANTS SHIELD INSTEAD.",
		sprSkills, 4,
		20 * 60
	)
	tcallback.register("onDraw", onDrawCall)
	tcallback.register("onHit", onHitCall)
end)



local objMuleShockwave = Object.new("MuleShockwave")
objMuleShockwave.sprite = spr.Nothing
objMuleShockwave.depth = 1
objMuleShockwave:addCallback("create", function(self)
	local selfData = self:getData()
	
	selfData.timer = 140
	selfData.range = 8
	selfData.team = "player" 
	selfData.damage = 25
	selfData.speed = 2.4
	selfData.dir = 1
	
	selfData._EfColor = Color.fromHex(0xE7967E)
end)
objMuleShockwave:addCallback("step", function(self)
	local selfData = self:getData()
	
	local newx = self.x + selfData.speed * selfData.dir
	if Stage.collidesPoint(newx, self.y) and Stage.collidesPoint(newx, self.y - 16) then
		selfData.timer = -1
		selfData.boom = true
	else
		self.x = newx
	end
	
	local parent = selfData.parent
	local r = selfData.range
	if parent and parent:isValid() then
		for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - r, self.y - r, self.x + r, self.y + r)) do
			if actor:get("team") ~= parent:get("team") then
				selfData.boom = true
				break
			end
		end
	end
	
	if selfData.timer < 0 or selfData.boom then
		r = r + 6
		if parent and parent:isValid() then
			local damager = parent:fireExplosion(self.x, self.y, r / 19, r / 4, selfData.damage / parent:get("damage")):set("knockup", 4)
			damager:set("climb", 6)
		else
			local damager = misc.fireExplosion(self.x, self.y, (r * 0.8) / 19, (r * 0.8) / 4, selfData.damage, selfData.team):set("knockup", 4)
			damager:set("climb", 6)
		end
		if selfData.boom then
			if onScreen(self) then
				misc.shakeScreen(4)
				local sparks = obj.EfSparks:create(self.x, self.y - 5):set("depth", -12)
				sparks.sprite = spr.TotemShockwave
				sparks.yscale = 1
			end
			sfx.Smite:play(1.3 + math.random() * 0.2, 0.5)
		end
		self:destroy()
	else
		selfData.timer = selfData.timer - 1
		
		if selfData.timer % 7 == 0 then
			local sparks = obj.EfSparks:create(self.x, self.y - 8):set("depth", -12)
			sparks.sprite = spr.MinerShoot2Dust2--spr.TotemShockwave
			sparks.xscale = selfData.dir
			sparks.yscale = 1
		end
		
		local destroy = true
		for i = -4, 25 do
			local ii = (i * 4)
			if Stage.collidesPoint(self.x, self.y + ii) then
				self.y = self.y + ii
				destroy = false
				break
			end
		end
		if destroy then
			selfData.timer = -1
		end
	end
end)


-- Called when the player levels up
mule:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(37, 3, 0.0018, 3)
end)

-- Called when the player picks up the Ancient Scepter
mule:addCallback("scepter", function(player)
	player:setSkill(4,
		"FAIL-SAFE ASSISTANCE 2.0",
		"LAUNCH A HEALING DRONE LASTING 8 SECONDS, HEALING YOU 5X10% OF YOUR TOTAL HEALTH. AT FULL HEALTH, GRANTS SHIELD INSTEAD.",
		sprSkills, 5,
		14 * 60
	)
end)

-- Skills
mule:addCallback("useSkill", function(player, skill)
	local playerAc = player:getAccessor()
	if playerAc.activity == 0 then
		if skill == 1 then
			-- Z skill
			player:survivorActivityState(1, player:getAnimation("shoot1_1"), 0.06, true, true)
		elseif skill == 2 then
			-- X skill
			player:survivorActivityState(2, player:getAnimation("shoot2"), 0.25, true, true)
		elseif skill == 3 then
			-- C skill
			player:survivorActivityState(3, player:getAnimation("shoot3"), 0.25, false, false)
		elseif skill == 4 then
			-- V skill
			if playerAc.scepter > 0 then
				player:survivorActivityState(4, player:getAnimation("shoot4_2"), 0.27, false, true)
			elseif playerAc.scepter == 0 then
				player:survivorActivityState(4, player:getAnimation("shoot4_1"), 0.27, false, true)
			end
		end
		player:activateSkillCooldown(skill)
	end
end)

-- SKILLS

-- V (DRONE)

local sDroneDeath = Sound.load("MuleDroneDeath", path.."droneDeath")
local objDrone = Object.new("MULEDrone")
objDrone.sprite = sprites.drone1_1

objDrone:addCallback("create", function(mDrone)
	mDroneAc = mDrone:getAccessor()
	mDrone.spriteSpeed = 0.5
	mDrone.depth = 2
	mDrone:getData().timer = 0
end)

objDrone:addCallback("step", function(mDrone)
	local data = mDrone:getData()
	if data.parent then
		local parent = data.parent
		local parentAc = parent:getAccessor()
		local float = math.sin(misc.director:getAlarm(0) * 0.1) * 4
		local xx = mDrone.x + ((parent.x + (12 * (parent.xscale * -1))) - mDrone.x) * 0.1
		local yy = mDrone.y + (parent.y - 24 - float - mDrone.y) * 0.1
		if data.timer > 84 and data.regenVal and parentAc.hp > 0 then
			mDrone.sprite = data.healSprite
			xx = mDrone.x + ((parent.x + (3 * (parent.xscale * -1))) - mDrone.x) * 0.1
			yy = mDrone.y + (parent.y - 2 - float - mDrone.y) * 0.1
		else
			mDrone.sprite = data.baseSprite
		end
		mDrone.x = xx 
		mDrone.y = yy
		mDrone.xscale = parent.xscale
		if data.timer >= 95 then
			data.timer = 0
			if data.regenVal then
				if global.quality > 1 then
					par.Spark:burst("middle", parentAc.x + 4 * parent.xscale, parentAc.y - 3, 3)
				end
				local sparkSound = table.random({sMuleSkill4b, sMuleSkill4c, sMuleSkill4d, sMuleSkill4e})
				sparkSound:play(0.9 + math.random() * 0.2, 1)
				if parentAc.maxhp > parentAc.hp then
					parentAc.hp = parentAc.hp + data.regenVal
					if global.showDamage then
						misc.damage(data.regenVal, parentAc.x, parentAc.y -8, false, Color.DAMAGE_HEAL)
					end
				else
					local regen = math.ceil(data.regenVal * 0.7)
					if not parent:getData().tempShield then 
						parent:getData().tempShield = regen
					else
						parent:getData().tempShield = parent:getData().tempShield + regen
					end
					if global.showDamage then
						misc.damage(regen, parentAc.x, parentAc.y -8, false, Color.ROR_BLUE)
					end
				end
			end
		else
			data.timer = data.timer + 1
		end
	end
	if data.life and data.life > 0 then
		data.life = data.life - 1
	else
		obj.EfSparks:create(mDrone.x, mDrone.y).sprite = spr.DroneDeath
		sDroneDeath:play(0.9 + math.random() * 0.2, 1)
		mDrone:destroy()
	end
end)

mule:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	
	if skill == 1 and not player:getData().skin_skill1Override then
		-- INTERFERENCE REMOVAL 
		
		if syncControlRelease(player, "ability1") then

			
			if relevantFrame < 5 then
				if relevantFrame == 0 then
					playerAc.skill1Attack = 1.6
				elseif relevantFrame == 1 then
					playerAc.skill1Attack = 2.15
				elseif relevantFrame == 2 then
					playerAc.skill1Attack = 2.65
				elseif relevantFrame == 3 then
					playerAc.skill1Attack = 3.35
				elseif relevantFrame == 4 then
					playerAc.skill1Attack = 4
				end
				playerAc.activity = 0
				if playerAc.attackSide == 0 then
					player:survivorActivityState(2, player:getAnimation("shoot1_2_1"), 0.25, true, true)
				else
					player:survivorActivityState(2, player:getAnimation("shoot1_2_2"), 0.25, true, true)
				end
				player:activateSkillCooldown(1)
				if onScreen(player) then
					misc.shakeScreen(2)
				end
			else
				playerAc.skill1Attack = 6
				playerAc.activity = 0
				player:survivorActivityState(2, player:getAnimation("shoot1_3"), 0.2, true, true)
				player:activateSkillCooldown(1)
				if onScreen(player) then
					misc.shakeScreen(7)
				end
			end
		else
			if relevantFrame == 1 then
				sMuleSkill1a:play((0.9 + math.random() * 0.2), 0.4)
			end
		end
		if playerAc.skill1Attack == 0 then
			if relevantFrame > 4 then
				playerAc.skill1Attack = 6
				playerAc.activity = 0
				player:survivorActivityState(2, player:getAnimation("shoot1_3"), 0.2, true, true)
				player:activateSkillCooldown(1)
			end
		end	

	elseif skill == 2 and not player:getData().skin_skill2Override then
		-- IMMOBILIZE
		
		if playerAc.skill1Attack == 0 then
			if relevantFrame == 3 then
				sMuleSkill2a:play(0.9 + math.random() * 0.2, 1)
			elseif relevantFrame == 4 then
				local bullet = player:fireBullet(player.x, player.y-2, player:getFacingDirection(), 650, 1.25, sprMuSparks3)
				bullet:getData().immobilize = true
			end
		end
		
		if playerAc.skill1Attack > 0 then	
			if relevantFrame == 1 then
				sMuleSkill1a:stop()
				if playerAc.skill1Attack > 4 then
					sMuleSkill1c:play(0.9 + math.random() * 0.2, 1)
				else
					sMuleSkill1b:play(0.9 + math.random() * 0.2, 1)
				end
				if playerAc.free == 1 then
					--playerAc.pHspeed = (0.4 * playerAc.skill1Attack) * player.xscale
				else
					playerAc.pHspeed = (1.6 * playerAc.skill1Attack) * player.xscale
				end
				misc.shakeScreen(playerAc.skill1Attack)
				if player:survivorFireHeavenCracker(1.7 * playerAc.skill1Attack) == nil then
					for i = 0, playerAc.sp do
						local dmg
						if playerAc.free == 0 then
							dmg = math.min(1.7 * playerAc.skill1Attack, 7)
						else
							dmg = 1.7 * playerAc.skill1Attack
						end
						local bullet = player:fireExplosion(player.x + 10.5 * player.xscale, player.y, 0.35 * playerAc.skill1Attack, 3, dmg, nil, sprMuSparks1)
						bullet:set("knockback", bullet:get("knockback") + (1.5 * playerAc.skill1Attack))
						bullet:set("knockback_direction", player.xscale)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
						if playerAc.skill1Attack > 4 then
							bullet:set("knockup", 3)
							if global.quality == 3 then
								parSkill:burst("middle", playerAc.x + 20 * player.xscale, playerAc.y + 4, 2)
								parDust:burst("middle", playerAc.x + 20 * player.xscale, playerAc.y + 4, 2)
							end
							
							if playerAc.free == 0 then
								local shockwave = objMuleShockwave:create(player.x + 3 * player.xscale, player.y)
								shockwave:getData().parent = player
								shockwave:getData().dir = player.xscale
								shockwave:getData().damage = playerAc.damage * 4.1
							end
						end
					end
				end
			end	
			if relevantFrame == 4 then
				if playerAc.attackSide == 0 then
					playerAc.attackSide = 1
				else
					playerAc.attackSide = 0
				end
				playerAc.skill1Attack = 0
			end
		end
		
	elseif skill == 3 and not player:getData().skin_skill3Override then
        -- TORQUE CALIBRATION
		if relevantFrame == 2 or relevantFrame == 4 or relevantFrame == 6 or relevantFrame == 8 then
			local bullet = player:fireExplosion(player.x, player.y, 1.7, 1.1, 1, nil, sprMuSparks2)
			bullet:set("knockback", 5)
			bullet:set("knockback_direction", player.xscale)
			if relevantFrame == 8 then
				bullet:set("stun", 1)
			end
		end
		if relevantFrame == 3 then
			sMuleSkill3:play(1, 1)
			if not player:getData()._lowerGravDone then
				player:getData()._lowerGravDone = true
				playerAc.pGravity1 = playerAc.pGravity1 - 0.2
			end
		end
		if relevantFrame > 2 and relevantFrame < 8 then
			playerAc.pHspeed = playerAc.pHmax * 2.2 * player.xscale
        elseif relevantFrame > 7 and playerAc.free == 0 then
			playerAc.pHspeed = playerAc.pHspeed / 2
		end
		if relevantFrame == 8 then
			player:getData()._lowerGravDone = false
			player:getData()._lowerGravReset = true
		end
		
	elseif skill == 4 and not player:getData().skin_skill4Override then
 		-- FAIL-SAFE ASSISTANCE
		if player.subimage >= 1 and player.subimage < 9 then
			playerAc.invincible = playerAc.invincible + 2
		end
		if relevantFrame == 1 then
			sMuleSkill4a:play(0.9 + math.random() * 0.2, 1)
			
		elseif relevantFrame == 9 then
			local drone = objDrone:create(player.x - (3 * player.xscale * -1), player.y - 12)
			local droneData = drone:getData()
			local regenVal = 0
			if playerAc.scepter > 0 then
				droneData.scepter = 1
				regenVal = playerAc.maxhp * 0.07 + (0.03 * playerAc.scepter)
				drone.sprite = player:getAnimation("drone2_1")
				droneData.baseSprite = drone.sprite
				droneData.healSprite = player:getAnimation("drone2_2")
			else
				regenVal = playerAc.maxhp * 0.07
				drone.sprite = player:getAnimation("drone1_1")
				droneData.baseSprite = drone.sprite
				droneData.healSprite = player:getAnimation("drone1_2")
			end
			if ar.Command.active then
				regenVal = regenVal + 2
			end
			droneData.parent = player
			droneData.life = 500
			droneData.regenVal = regenVal
		end
	end
end)

mule:addCallback("step", function(player)
	local playerAc = player:getAccessor()
	player:set("attack_speed", math.min(player:get("attack_speed"), 16)) -- Higher attack speeds break it :(
	if player:getData()._lowerGravReset then
		player:getData()._lowerGravReset = nil
		playerAc.pGravity1 = playerAc.pGravity1 + 0.2
	end
end)

sur.MULE = mule