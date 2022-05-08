-- PIRATE

local path = "Survivors/Loader/Skins/Pirate/"

local survivor = sur.Loader
local sprSelect = Sprite.load("PirateSelect", path.."Select", 17, 2, 0)
local Pirate = SurvivorVariant.new(survivor, "Pirate", sprSelect, {
	idle = Sprite.load("PirateIdle", path.."Idle", 1, 7, 10),
	walk = Sprite.load("PirateWalk", path.."Walk", 8, 10, 12),
	jump = Sprite.load("PirateJump", path.."Jump", 1, 7, 10),
	climb = Sprite.load("PirateClimb", path.."Climb", 2, 4, 9),
	death = Sprite.load("PirateDeath", path.."Death", 5, 14, 7),
	decoy = Sprite.load("PirateDecoy", path.."Decoy", 1, 9, 18),
	
	travel = Sprite.load("PirateTravel", path.."Travel", 1, 8, 10),
	shoot11 = Sprite.load("PirateShoot1A", path.."Shoot1_1", 6, 7, 12),
	shoot12 = Sprite.load("PirateShoot1B", path.."Shoot1_2", 6, 7, 12),
	shoot13 = Sprite.load("PirateShoot1C", path.."Shoot1_3", 10, 8, 12),
	shoot2 = Sprite.load("PirateShoot3", path.."Hook", 10, 8, 10),
	shoot4 = Sprite.load("PirateShoot4", path.."Shoot4", 6, 8, 10)
}, Color.fromHex(0x87705D))
SurvivorVariant.setInfoStats(Pirate, {{"Strength", 7}, {"Vitality", 5}, {"Toughness", 4}, {"Agility", 7}, {"Difficulty", 4}, {"ARRR!", 12}})
SurvivorVariant.setDescription(Pirate, "WIP.")

local sprSkills = Sprite.load("PirateSkills", path.."Skills", 6, 0, 0)
SurvivorVariant.setLoadoutSkill(Pirate, "Sabotage", "Attack for &y&130% damage&!&. Tap once for a kick, twice for a light shot and thrice for a heavy shot dealing &y&190% damage&!&.", sprSkills, 1)
SurvivorVariant.setLoadoutSkill(Pirate, "No Mercy", "For 3 seconds, &y&all Sabotage attacks are heavy cannon shots. Allows primary to be held.", sprSkills, 2)
SurvivorVariant.setLoadoutSkill(Pirate, "Feed the Shaarv", "Summon a Shaarv, attacking an enemy and &y&dealing up to 100%x10 damage&!&.", sprSkills, 3)


Pirate.endingQuote = "..and so he left, with ages worth of treasure."

callback.register("onSkinInit", function(player, skin)
	if skin == Pirate then
		--player:set("pHmax", player:get("pHmax") - 0.15)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(166, 10, 0.045)
		else
			player:survivorSetInitialStats(116, 10, 0.015)
		end
		player:setSkill(1,
		"Sabotage",
		"Tap once for a kick dealing 100% damage, twice for a light shot dealing 100% damage and thrice for a heavy shot dealing &y&160% damage to all hit enemies.",
		sprSkills, 1, 10)
		player:setSkill(2,
		"No Mercy",
		"For 3 seconds, all Sabotage attacks are heavy cannon shots. Allows primary to be held.",
		sprSkills, 2, 5 * 60)
		player:setSkill(4,
		"Feed the Shaarv",
		"Summon a Shaarv, attacking an enemy and dealing up to 100%x10 damage.",
		sprSkills, 3, 5 * 60)
		player:getData().combo = 0
		player:getData().comboTimer = 0
		player:getData().startComboCount = 1
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Pirate then
		player:survivorLevelUpStats(1, 0, 0, -0.001)
	end
end)

survivor:addCallback("scepter", function(player)
	if SurvivorVariant.getActive(player) == Pirate then
		player:setSkill(4,
		"Feed the Cyber-Shaarv",
		"Summon a Cyber-Shaarv, firing a laser and dealing up to 100%x20 damage.",
		sprSkills, 3, 9 * 60)
	end
end)

SurvivorVariant.setSkill(Pirate, 1, function(player)
	--[[local step = player:getData().z_step
	if step == 1 then
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot11"), 0.2, true, true)
	elseif step == 2 then
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot12"), 0.2, true, true)
	else
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot13"), 0.2, true, true)
	end
	player:getData().z_step = (step % 3) + 1
	player:getData().z_stepTimer = 60
	]]
	
	player:getData().combo = player:getData().startComboCount
	player:getData().comboTimer = 0
	if player:getData().startComboCount == 1 then
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot11"), 0.2, true, true)
	else
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot13"), 0.2, true, true)
	end
end)

SurvivorVariant.setSkill(Pirate, 4, function(player)
	SurvivorVariant.activityState(player, 4, player:getAnimation("shoot11"), 0.2, true, true)
end)

--[[survivor:addCallback("step", function(player, skillIndex)
	if SurvivorVariant.getActive(player) == Pirate then
		if player:getData().z_stepTimer then
			if player:get("activity") >= 2 then
				player:getData().z_stepTimer = 0
			end			
			if player:getData().z_stepTimer > 0 then
				player:getData().z_stepTimer = player:getData().z_stepTimer - 1
			else
				player:getData().z_stepTimer = nil
				player:getData().z_step = 1
			end
		end
	end
end)]]

local buffPirate = Buff.new("pirate")
buffPirate.sprite = Sprite.load("PirateBuff", path.."Buff", 1, 9, 9)
buffPirate:addCallback("start", function(actor)
	actor:getData().startComboCount = 3
end)
buffPirate:addCallback("step", function(actor)
	actor:set("z_released", 1)
end)
buffPirate:addCallback("end", function(actor)
	actor:getData().startComboCount = 1
end)

survivor:addCallback("useSkill", function(player, skillIndex)
	if SurvivorVariant.getActive(player) == Pirate then
		if skillIndex == 2 then
			player:set("shield_dur", 0)
			player:removeBuff(buff.burstSpeed2)
			player:applyBuff(buffPirate, 150)
			for _, spark in ipairs(obj.EfSparks:findAllRectangle(player.x - 10, player.y - 10, player.x + 10, player.y + 10)) do
				if spark.sprite == spr.LoaderExplode then
					spark:destroy()
					break
				end
			end
			sfx.BubbleShield:stop()
			--[[if not player:getData().variantSkillUse then
				player:getData().skillReplace = 
			end]]
			local spark = obj.EfSparks:create(player.x, player.y + 6)
			spark.sprite = spr.EfMineExplode2
			spark.depth = player.depth + 1
			spark.yscale = 1
			sfx.WormExplosion:play(1.9 + math.random() * 0.2)
		elseif skillIndex == 4 then
			sfx.JanitorShoot1_1:stop()
			for _, obj in ipairs (obj.ConsRod:findMatching("parent", player.id)) do
				obj:destroy()
			end
			if not player:getData().variantSkillUse then
				player:getData().skillReplace = {index = 4, sprite = player:getAnimation("shoot4"), speed = 0.2}
			end
			if player:get("activity") ~= 0 then
				player:setAlarm(5,  5)
			end
		end
	end
end)


local objCannonBall = Object.new("PirateCannonBall")
objCannonBall.depth = 5
objCannonBall.sprite = Sprite.load("PirateCannonBall", path.."CannonBall", 1, 6, 6)
objCannonBall:addCallback("create", function(self)
	local selfData = self:getData()
	
	selfData.team = "player"
	selfData.hits = {}
	selfData.life = 90
end)
objCannonBall:addCallback("step", function(self)
	local selfData = self:getData()
	
	local angle = 0
	if self.xscale < 0 then angle = 180 end
	for _, actor in ipairs(pobj.actors:findAllRectangle(self.x - 2, self.y - 2, self.x + 2, self.y + 2)) do
		if actor:get("team") ~= selfData.team and not selfData.hits[actor] then
			if selfData.parent and selfData.parent:isValid() then
				if onScreen(self) then
					misc.shakeScreen(1)
				end
				local bullet = selfData.parent:fireBullet(actor.x, actor.y, angle, 2, 1.9, spr.EfMissileExplosion)
				bullet:set("knockback", 4)
				bullet:set("knockback_direction", self.xscale)
				bullet:set("specific_target", actor.id)
				selfData.hits[actor] = true
			end
			break
		end
	end
	
	if self:collidesMap(self.x, self.y) then
		selfData.life = 0
		local sparks = obj.EfSparks:create(self.x, self.y)
		sparks.sprite = spr.EfMissileExplosion
	end
	
	if selfData.life > 0 then
		self.x = self.x + self.xscale * 4
		selfData.life = selfData.life - 1
		self.alpha = selfData.life * 0.1
	else
		self:destroy()
	end
end)


local objShark = Object.new("PirateShark")
objShark.depth = 5
objShark.sprite = Sprite.load("PirateShark", path.."Shark", 2, 38, 11)
local sprShark2 = Sprite.load("PirateShark2", path.."Shark2", 2, 38, 11)
objShark:addCallback("create", function(self)
	local selfData = self:getData()
	
	selfData.team = "player"
	selfData.life = 90
	self.spriteSpeed = 0.1
	selfData.timer = 0
	selfData.scepter = 0
end)
objShark:addCallback("step", function(self)
	local selfData = self:getData()
	
	local angle = 0
	if self.xscale < 0 then angle = 180 end
	if selfData.hit and selfData.hit:isValid() then
		selfData.hit.x = self.x + selfData.offset.x
		selfData.hit.y = self.y + selfData.offset.y
		selfData.hit:set("pVspeed", 0)
		if selfData.life % 30 == 0 and selfData.life > 0 then
			local bullet = selfData.parent:fireBullet(selfData.hit.x, selfData.hit.y, angle, 2, 1, spr.Sparks2)
			bullet:set("specific_target", selfData.hit.id)
		end
	else
		if selfData.timer == 0 then
			for _, actor in ipairs(pobj.actors:findAllRectangle(self.x - 2, self.y - 2, self.x + 2, self.y + 2)) do
				if actor:get("team") ~= selfData.team and actor:isClassic() then
					if selfData.parent and selfData.parent:isValid() then
						if onScreen(self) then
							misc.shakeScreen(1)
						end
						local bullet = selfData.parent:fireBullet(actor.x, actor.y, angle, 2, 2, spr.Sparks8)
						bullet:set("knockback", 4)
						bullet:set("knockback_direction", self.xscale)
						bullet:set("specific_target", actor.id)
						selfData.hit = actor
						selfData.offset = {x = actor.x - self.x, y = actor.y - self.y}
						self.depth = actor.depth - 1
						selfData.timer = 15
					end
					break
				end
			end
		else
			selfData.timer = selfData.timer - 1
		end
	end
	
	if selfData.scepter > 0 then
		if selfData.life % 30 == 0 and selfData.life > 0 then
			local bullet = selfData.parent:fireBullet(self.x, self.y, angle, 300, 1, spr.Sparks1)
			addBulletTrailLine(bullet, Color.RED, 2, 20, false, false)
		end
	end
	
	if selfData.life > 0 then
		if selfData.hit and selfData.hit:isValid() then
			if not selfData.hit:collidesMap(selfData.hit.x + 3 * self.xscale, selfData.hit.y) then
				self.x = self.x + self.xscale * 3
			end
		else
			if not Stage.collidesPoint(self.x + 3 * self.xscale, self.y) then
				self.x = self.x + self.xscale * 3
			end
		end
		selfData.life = selfData.life - 1
		self.alpha = selfData.life * 0.1
	else
		self:destroy()
	end
end)

sur.Loader:addCallback("step", function(player)
	if SurvivorVariant.getActive(player) == Pirate then
		if player:getData().resetSkillFix and player.subimage >= player.sprite.frames then
			player:set("activity", 0)
			player:set("activity_type", 0)
			player:getData().resetSkillFix = nil
		end
		--[[if player:get("scepter") > 0 then
			player:setSkillIcon(4, sprSkills, 4)
		else
			player:setSkillIcon(4, sprSkills, 3)
		end]]
		
		if player:getData().skillReplace then
			local playerAc = player:getAccessor()
			local playerData = player:getData()
			local index = playerData.skillReplace.index
			local iindex = index + 0.01
			local sprite
			sprite = playerData.skillReplace.sprite
			local scaleSpeed = false
			local resetHSpeed = true
			local speed = playerData.skillReplace.speed
			
			if playerAc.dead == 0 then
				playerAc.activity = iindex
				playerAc.activity_type = 1
				
				playerData.variantSkillUse = {index = index, sprite = sprite, speed = speed, scaleSpeed = scaleSpeed, resetHSpeed = resetHSpeed}--, frame = 1}
				
				player.sprite = sprite
				player.subimage = 1
				
				if resetHSpeed and playerAc.free == 0 then
					playerAc.pHspeed = 0
				end
			end
			player:getData().skillReplace = nil
		end
	end
end)
callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
	if variant == Pirate then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		if skill == 1 then
			if playerData.combo == 1 and relevantFrame == 3 then
				local bullet = player:fireExplosion(player.x + 10 * player.xscale, player.y, 20 / 19, 14 / 4, 1.3)
				bullet:set("knockback", 10)
				bullet:set("knockback_direction", player.xscale)
				if onScreen(player) then
					misc.shakeScreen(1)
				end
				sfx.Boss1Shoot2:play(1.8 + math.random() * 0.2)
			elseif playerData.combo == 2 and relevantFrame == 3 then
				local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 250, 1.3)
				bullet:set("knockback", 2)
				bullet:set("stun", 0.5)
				if onScreen(player) then
					misc.shakeScreen(2)
				end
				sfx.Bullet2:play(0.8 + math.random() * 0.2)
			elseif playerData.combo >= 3 and relevantFrame == 4 then
				local ball = objCannonBall:create(player.x + 6 * player.xscale, player.y)
				ball:getData().team = playerAc.team
				ball:getData().parent = player
				ball.xscale = player.xscale
				if onScreen(player) then
					misc.shakeScreen(5)
				end
				sfx.CowboyShoot1:play(0.5 + math.random() * 0.2)
			end
			
			if relevantFrame == 3 then
				playerAc.force_z = 0
			end
			
			local restFrame = 5
			local floorFrame = math.floor(player.subimage)
			
			if floorFrame >= restFrame then
				local resetSpeed
				if playerData.combo <= 2 then
					playerData.comboTimer = playerData.comboTimer + 1
					--if player.subimage >= restFrame then
						player.subimage = restFrame
						player.spriteSpeed = 0
						resetSpeed = true
					--end
				end
				
				if playerData.comboTimer > 20 then
					playerAc.activity = 0
					playerAc.activity_type = 0
				elseif ((playerAc.z_skill > 0 and playerAc.z_released > 0) or playerAc.force_z > 0) and playerData.combo <= playerData.startComboCount + 1 then
					
					if playerData.startComboCount == 1 then
						playerAc.z_released = 0
					end
					
					if playerData.combo == 1 then
						SurvivorVariant.activityState(player, 1, player:getAnimation("shoot12"), 0.2, true, true)
					elseif playerData.combo == 2 then
						SurvivorVariant.activityState(player, 1, player:getAnimation("shoot13"), 0.2, true, true)
					end
					playerData.combo = playerData.combo + 1
					playerData.comboTimer = 0
				end
			end
		--[[elseif skill == 2 then
			if relevantFrame == 3 then

			end]]
		elseif skill == 4 then
			if relevantFrame == 4 then
				sfx.WispBShoot1:play(0.9 + math.random() * 0.2)
				local shark = objShark:create(player.x, player.y)
				shark:getData().parent = player
				shark:getData().team = playerAc.team
				shark.xscale = player.xscale
				if playerAc.scepter > 0 then
					shark.sprite = sprShark2
					shark:getData().scepter = playerAc.scepter
				end
			end
		end
	end
end)