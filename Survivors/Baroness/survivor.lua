
-- All Baroness data

local path = "Survivors/Baroness/"

local baroness = Survivor.new("Baroness")

-- Sounds
local sSkill1a = Sound.load("Baroness_Shoot1A", path.."skill1a")
local sSkill1b = Sound.load("Baroness_Shoot1B", path.."skill1b")
local sSkill2a = Sound.load("Baroness_Shoot2A", path.."skill2a")
local sSkill2b = Sound.load("Baroness_Shoot2B", path.."skill2b")
local sSkill3a = Sound.load("Baroness_Shoot3A", path.."skill3a")
local sSkill3b = Sound.load("Baroness_Shoot3B", path.."skill3b")
local sSkill3c = Sound.load("Baroness_Shoot3C", path.."skill3c")
local sSkill4a = Sound.load("Baroness_Shoot4A", path.."skill4a")
local sSkill4b = Sound.load("Baroness_Shoot4B", path.."skill4b")
local sSkill4c = Sound.load("Baroness_Shoot4C", path.."skill4c")

-- Sprite Table
local sprites = {
	idle_1 = Sprite.load("Baroness_Idle", path.."idle", 1, 5, 7),
	walk_1 = Sprite.load("Baroness_Walk", path.."walk", 8, 7, 8),
	jump_1 = Sprite.load("Baroness_Jump", path.."jump", 1, 6, 10),
	climb = Sprite.load("Baroness_Climb", path.."climb", 2, 4, 9),
	death = Sprite.load("Baroness_Death", path.."death", 8, 30, 8),
	decoy = Sprite.load("Baroness_Decoy", path.."decoy", 1, 9, 10),
	
	idle_2 = Sprite.load("Baroness_Idle_Bike", path.."idleBike", 1, 9, 8),
	walk_2 = Sprite.load("Baroness_Walk_Bike", path.."walkBike", 8, 19, 8),
	jump_2 = Sprite.load("Baroness_Jump_Bike", path.."jumpBike", 1, 9, 8),
	
	shoot1 = Sprite.load("Baroness_Shoot1", path.."shoot1", 3, 6, 7),
	shoot2_1 = Sprite.load("Baroness_Shoot2A", path.."shoot2a", 7, 5, 14),
	shoot2_2 = Sprite.load("Baroness_Shoot2B", path.."shoot2b", 7, 15, 15),
	shoot3_1 = Sprite.load("Baroness_Shoot3A", path.."shoot3a", 6, 8, 10),
	shoot3_2 = Sprite.load("Baroness_Shoot3B", path.."shoot3b", 8, 19, 18),
	shoot4_1 = Sprite.load("Baroness_Shoot4A", path.."shoot4a", 7, 7, 9),
	shoot4_2 = Sprite.load("Baroness_Shoot4B", path.."shoot4b", 7, 16, 15)
	--shoot4_1 = Sprite.load("Baroness_Shoot4A", path.."shoot4a", 7, 5, 14),
	--shoot4_2 = Sprite.load("Baroness_Shoot4B", path.."shoot4b", 7, 16, 15),
}
-- Hit sprites
local sprSparks = Sprite.load("Baroness_Sparks", path.."sparks", 3, 13, 8)
local sprSparks2 = Sprite.load("Baroness_Sparks_Laser", path.."sparks2", 3, 12, 8)
local sprSparks3 = Sprite.load("Baroness_Sparks_BombA", path.."sparks3", 3, 15, 8)
local sprSparks4 = Sprite.load("Baroness_Sparks_BombB", path.."sparks4", 5, 56, 30)
local sprSparks5 = Sprite.load("Baroness_Sparks_BombC", path.."sparks5", 5, 56, 30)

-- Skill sprites
local sprSkills = Sprite.load("Baroness_Skills", path.."skills", 7, 0, 0)

-- Selection sprite
baroness.loadoutSprite = Sprite.load("Baroness_Select", path.."select", 23, 2, 0)

-- Selection description
baroness:setLoadoutInfo(
[[Trained for the front lines, and packing enough heat for crowd control.
Able to wipe out crowds with grenades and relocate enemies wherever she pleases,
the &y&Baroness&!& has the tools for the job. 
&y&Don’t let it get personal.]], sprSkills)

-- Skill descriptions
baroness:setLoadoutSkill(1, "Pulling the Trigger",
[[Hurl MG rounds for &y&95% damage&!&.
&lt&Vehicle:&!& Fire a laser &y&increasing in damage the longer it hits enemies.]])

baroness:setLoadoutSkill(2, "Steady Target",
[[Pick up an enemy, dealing &y&100% damage&!& and disabling them.
Lasts 4 seconds.]])

baroness:setLoadoutSkill(3, "Active Relocation",
[[Summon a hovering vehicle that &b&increases movement speed&!&,
&r&but strips the ability to jump or climb. &b&Can attack while moving.]])

baroness:setLoadoutSkill(4, "Saturated O-Charge",
[[Throw a grenade which seeks enemies and &y&explodes for 3x320% damage.]])

-- Color of highlights during selection
baroness.loadoutColor = Color.fromRGB(117, 135, 119)

-- Misc. menus sprite
baroness.idleSprite = sprites.idle_1

-- Main menu sprite
baroness.titleSprite = sprites.walk_1

-- Endquote
baroness.endingQuote = "..and so she left, a defiant noble, expurgated."

-- Stats & Skills
baroness:addCallback("init", function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	playerData.vehicle = false
	playerData.firingSlow = 0
	playerData.firingAnimTimer = 0
	playerData.vehicleSpeed = 0
	playerData.focusTimer = 0
	playerData._EfColor = Color.fromHex(0x61C3CD)
	playerData._SteadyDistance = 75
	playerData._SteadyDuration = 240
	playerData._SpeedBoost = 1.7
	
	playerData.sounds = {
		skill1_1 = sSkill1a,
		skill1_2 = sSkill1b,
		skill2_1 = sSkill2a,
		skill2_2 = sSkill2b,
		skill3_1 = sSkill3a,
		skill3_2 = sSkill3b,
		skill3_3 = sSkill3c,
		skill4_1 = sSkill4a
	}
	
	player:setAnimations(sprites)
	
	if Difficulty.getActive() == dif.Drizzle then
		player:survivorSetInitialStats(150, 12, 0.04)
	else
		player:survivorSetInitialStats(100, 12, 0.01)
	end
	
	player:setSkill(1, "Pulling the Trigger", "Hurl MG rounds for 95% damage.",
	sprSkills, 1, 5)
		
	player:setSkill(2, "Steady Target", "Pick up and disable an enemy, dealing 100% damage",
	sprSkills, 2, 6 * 60)
		
	player:setSkill(3, "Active Relocation", "Summon a hovering vehicle, increasing your movement speed.",
	sprSkills, 3, 60)
		
	player:setSkill(4, "Saturated O-Charge", "Throw a grenade which seeks enemies and explodes for 3x320% damage.",
	sprSkills, 4, 8 * 60)
end)

-- Called when the player levels up
baroness:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(30, 3, 0.002, 2)
end)

-- Called when the player picks up the Ancient Scepter
baroness:addCallback("scepter", function(player)
	player:setSkill(4,
	"Bursting O-Charge", "Throw a grenade which seeks enemies and explodes for 5x320% damage.", 
	sprSkills, 7, 8 * 60)
end)

-- Skills

-- Bomb
local objGrenade = Object.new("BaronessGrenade")
objGrenade.depth = -9
objGrenade.sprite = spr.Pixel
objGrenade:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.travelTime = 20
	selfData.life = 150
	sSkill4c:play(1.5 + math.random() * 0.07)
	selfData.scepter = 0
	selfData.sp = 0
	selfData.attackSpeed = 1
	selfData.yaccel = 0
	selfData.xaccel = 0
	selfData.team = "player"
	self.spriteSpeed = 0
	self.subimage = 2
	self.blendColor = Color.RED
end)
objGrenade:addCallback("step", function(self)
	local selfData = self:getData()
	if selfData.life > 0 then
		if selfData.stuck and selfData.stuck:isValid() then
			self.x = selfData.stuck.x
			self.y = selfData.stuck.y
		else
			selfData.yaccel = selfData.yaccel + 0.1
			for i = 1, math.abs(selfData.yaccel * 10) do
				local newy =  self.y + math.sign(selfData.yaccel) * 0.1
				if self:collidesMap(self.x, newy) then
					if math.sign(selfData.yaccel) > 0 then
						selfData.xaccel = math.approach(selfData.xaccel, 0, 0.4)
					end
					selfData.yaccel = selfData.yaccel * -0.6
					--selfData.xaccel = math.approach(selfData.xaccel, 0, 0.02)
					break
				else
					self.y = newy
				end				
			end
			
			
			selfData.xaccel = math.approach(selfData.xaccel, 0, 0.015)
			for i = 1, math.abs(selfData.xaccel) * 10 do
				local newx =  self.x + math.sign(selfData.xaccel) * 0.1
				if self:collidesMap(newx, self.y) then
					selfData.xaccel = selfData.xaccel * -0.8
					break
				else
					self.x = newx
				end				
			end
			
			if selfData.life <  140 then
				local r = 40
				for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - r, self.y - r, self.x + r, self.y + r)) do
					if actor:get("team") ~= selfData.team then
						selfData.stuck = actor
						selfData.travel = 40
						selfData.travelx = self.x
						selfData.travely = self.y
						selfData.travelx2 = actor.x
						selfData.travely2 = actor.y
						selfData.yaccel = -2
						selfData.xaccel = 0
						break
					end
				end
			end
		end
		
		if selfData.travel and selfData.travel > 0 then
			selfData.travel = selfData.travel - 1
		end
		
		
		local lastLife = selfData.life
		
		selfData.life = selfData.life - selfData.attackSpeed
		
		
		local explosions = 3 + selfData.scepter * 2
		for i = 1, explosions do
			local ii = (i - 1) * 20
			if selfData.life <= ii and lastLife > ii then
				if selfData.parent and selfData.parent:isValid() then
					for i = 0, selfData.sp do
						local explosion
						if selfData.scepter > 0 then
							explosion = selfData.parent:fireExplosion(self.x, self.y, 30 / 14, 30 / 4, 3.2, sprSparks5, spr.Sparks6, nil)
						else
							explosion = selfData.parent:fireExplosion(self.x, self.y, 30 / 14, 30 / 4, 3.2, sprSparks4, spr.Sparks5, nil)
						end
						explosion:set("knockback", 6)
						if i ~= 0 then
							explosion:set("climb", i * 8)
						end
					end
					if onScreen(self) then
						misc.shakeScreen(5)
					end
					sSkill4b:play(2 + math.random() * 0.08, 0.7)
				end
				break
			end
		end
		if global.quality > 1 and selfData.life < 120 then
			par.PixelDust:burst("middle", self.x, self.y, 1, self.blendColor)
		end
	else
		self:destroy()
	end
end)
objGrenade:addCallback("draw", function(self)
	local selfData = self:getData()
	if selfData.travel then
		local mult = selfData.travel / 40
		graphics.alpha(mult)
		graphics.color(self.blendColor)
		graphics.line(selfData.travelx, selfData.travely, selfData.travelx2, selfData.travely2, mult * 2)
	end
end)
--[[local objBomb = Object.new("Baroness Bomb")
objBomb.depth = -10
objBomb:addCallback("create", function(self)
	self:getData().life = 150
	sSkill4c:play(1 + math.random() * 0.07)
	self:getData().speed = 1
end)
objBomb:addCallback("step", function(self)
	local follow = self:getData().follow
	local parent = self:getData().parent
	if follow and follow:isValid() and isa(follow, "PlayerInstance") == false and follow:getObject() ~= obj.actorDummy then
		self.x = follow.x
		self.y = follow.y
	end
	if self:getData().life > 0 then
		self:getData().life = self:getData().life - (1 * self:getData().speed)
	else
		if parent and parent:isValid() then
			for i = 0, parent:get("sp") do
				local explosion = nil
				local scepter = parent:get("scepter")
				if scepter > 0 then
					explosion = parent:fireExplosion(self.x, self.y, 50 / 14, 30 / 4, 10 + (7 * scepter), sprSparks5, nil, nil)
				else
					explosion = parent:fireExplosion(self.x, self.y, 70 / 14, 50 / 4, 10, sprSparks4, nil, nil)
				end
				explosion:set("knockback", 6)
				misc.shakeScreen(15)
				if i ~= 0 then
					explosion:set("climb", i * 8)
				end
			end
		end
		sSkill4b:play(1 + math.random() * 0.07)
		self:destroy()
	end
end)
objBomb:addCallback("draw", function(self)
	local parent = self:getData().parent
	if parent and parent:isValid() and self:getData().life > 0 then
		local v = (self:getData().life / 100)
		local vv = math.cos(v * (math.pi / 2))
		graphics.alpha(vv - 0.3)
		graphics.setBlendMode("additive")
		graphics.color(Color.mix(Color.WHITE, Color.fromHex(0x7FFFFF), v))
		graphics.circle(self.x, self.y, self:getData().life / 3)
		local size = 1
		local xx = self.x + 1
		local lineCount = 1
		if parent:get("scepter") > 0 then
			graphics.color(Color.YELLOW)
			size = 2
			lineCount = 2
			xx = self.x - 1000
		else
			graphics.color(Color.RED)
			size = 1
		end
		for i = 1, lineCount do
			local xxx = xx
			if i > 1 then xxx = self.x + 1000 end
			graphics.alpha(vv * 1.5 - 0.3)
			graphics.line(self.x + 1, self.y, xxx, self.y - (vv * 1000), 1.5 * size)
		end
		graphics.alpha(0.75)
		graphics.circle(self.x, self.y, 2 * size)
		graphics.setBlendMode("normal")
	end
end)]]

-- Skill Activation
local sprVehicleMask = Sprite.load("Baroness_VehicleMask", path.."vehicleMask", 1, 6, 5)

baroness:addCallback("useSkill", function(player, skill)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	if player:get("activity") == 0 then
		if skill == 1 then
			-- Z skill
			if playerData.vehicle == false or playerData.skin_skill1Override then
				player:survivorActivityState(1, player:getAnimation("shoot1"), 0.21, true, true)
			else
				playerData.firingSlow = math.min(playerData.firingSlow + 1, 2) 
				local bullet = nil
				for i = 0, playerAc.sp do
					if playerData.firingAnimTimer  > 0 then
						playerData.sounds.skill1_2:play(1 + math.random() * 0.07)
						bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 200, 0.2, sprSparks2, DAMAGER_BULLET_PIERCE)
					else
						bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 200, 0.2, nil, DAMAGER_NO_PROC + DAMAGER_BULLET_PIERCE)
					end
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
				if playerData.shockChild and playerData.shockChild:isValid() and playerData.shockChild:getData().isShocked then
					bullet:set("specific_target", playerData.shockChild.id)
				end
				bullet:getData().isLaser = true
				bullet:getData().laserC = 0
				bullet:set("knockback_direction", player.xscale)
			end
		elseif skill == 2 then
			-- X skill
			if playerData.vehicle == false then
				player:survivorActivityState(2, player:getAnimation("shoot2_1"), 0.25, true, true)
			else
				player:survivorActivityState(2, player:getAnimation("shoot2_2"), 0.25, true, true)
			end
		elseif skill == 3 then
			-- C skill
			if playerData.vehicle == false then
				player:survivorActivityState(3, player:getAnimation("shoot3_1"), 0.2, false, true)
			else
				player:survivorActivityState(3, player:getAnimation("shoot3_2"), 0.22, false, true)
			end
		elseif skill == 4 then
			-- V skill
			if playerData.vehicle == false then
				player:survivorActivityState(4, player:getAnimation("shoot4_1"), 0.25, true, true)
			else
				player:survivorActivityState(4, player:getAnimation("shoot4_2"), 0.25, true, true)
			end
		end
		player:activateSkillCooldown(skill)
	end
end)

baroness:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	if skill == 1 and not playerData.skin_skill1Override then
		-- Pulling the Trigger
		if relevantFrame == 1 then
			playerData.sounds.skill1_1:play(1 + math.random() * 0.07, 0.93)
			if not player:survivorFireHeavenCracker() then
				for i = 0, playerAc.sp do
					local bullet = player:fireBullet(player.x, player.y + math.random(-5, 1), player:getFacingDirection(), 480, 0.95, sprSparks)
					
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
		end
		
	elseif skill == 2 and not playerData.skin_skill2Override then
		-- Steady Target
		if relevantFrame == 3 then
			playerData.sounds.skill2_1:play(1 + math.random() * 0.2)
			local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 200, 1)
			bullet:getData().shock = true
			bullet:set("stun", 0.5 + playerData._SteadyDuration * 0.01)
		end
		if playerData.vehicle then
			if player:hasBuff(buff.daze) then
				if playerAc.moveRight == 1 and playerAc.moveLeft == 0 then
					playerAc.pHspeed = playerAc.pHmax * -1
				elseif playerAc.moveLeft == 1 and playerAc.moveRight == 0 then
					playerAc.pHspeed = playerAc.pHmax
				end
			else
				if playerAc.moveRight == 1 and playerAc.moveLeft == 0 then
					playerAc.pHspeed = playerAc.pHmax
				elseif playerAc.moveLeft == 1 and playerAc.moveRight == 0 then
					playerAc.pHspeed = playerAc.pHmax * -1
				end
			end
		end
		
	elseif skill == 3 and not playerData.skin_skill3Override then
        -- Vehicle
        if relevantFrame == 1 then
			if playerData.vehicle == true then
				playerData.vehicle = false
				player.mask = spr.PMask
				player:set("pHmax", player:get("pHmax") - playerData._SpeedBoost)
				playerAc.canrope = 1
				--if playerData.lastSpeed then
					--playerAc.pHmax = playerData.lastSpeed
					--playerData.lastSpeed = nil
				--end
				playerData.sounds.skill3_2:play(1 + math.random() * 0.2)
				playerAc.walk_speed_coeff = 1

				player:setSkill(1, "Pulling the Trigger", "Hurl MG rounds for 95% damage.",
				sprSkills, 1, 5)
				
				player:setSkill(3, "Active Relocation", "Summon a hovering vehicle, increasing your movement speed.",
				sprSkills, 3, 60)
			else
				playerData.sounds.skill3_1:play(1 + math.random() * 0.2)
				playerData.vehicle = true
				player.mask = sprVehicleMask
				player:set("pHmax", player:get("pHmax") + playerData._SpeedBoost)
				playerAc.canrope = 0
				playerAc.walk_speed_coeff = 0.4 * (1.7 / playerData._SpeedBoost)
				
				player:setSkill(1, "Focusing Beam", "Fire a constant laser, dealing more damage the longer it hits.",
				sprSkills, 6, 6)
				
				player:setSkill(3, "Face to Face", "Exit the vehicle.",
				sprSkills, 5, 5 * 60)
			end
		end
		playerAc.pHspeed = playerAc.pHmax * player.xscale

	elseif skill == 4 and not playerData.skin_skill4Override then
		-- Orbital Strike
		if relevantFrame == 5 then
			local grenade = objGrenade:create(player.x, player.y)
			local grenadeData = grenade:getData()
			grenadeData.xaccel = player.xscale * 4
			grenadeData.yaccel = -3
			grenadeData.attackSpeed = math.min(playerAc.attack_speed, 3)
			grenadeData.sp = playerAc.sp
			grenadeData.scepter = playerAc.scepter
			grenadeData.team = playerAc.team
			grenadeData.parent = player
			if playerAc.scepter > 0 then
				grenade.blendColor = Color.YELLOW
			end
			--[[playerData.sounds.skill4_1:play(1 + math.random() * 0.07)
			local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 400, 1)
			bullet:set("knockup", 2)
			bullet:getData().isBomb = true]]
		end
		if playerData.vehicle then
			if player:hasBuff(buff.daze) then
				if playerAc.moveRight == 1 and playerAc.moveLeft == 0 then
					playerAc.pHspeed = playerAc.pHmax * -1
				elseif playerAc.moveLeft == 1 and playerAc.moveRight == 0 then
					playerAc.pHspeed = playerAc.pHmax
				end
			else
				if playerAc.moveRight == 1 and playerAc.moveLeft == 0 then
					playerAc.pHspeed = playerAc.pHmax
				elseif playerAc.moveLeft == 1 and playerAc.moveRight == 0 then
					playerAc.pHspeed = playerAc.pHmax * -1
				end
			end
		end
	end
end)

baroness:addCallback("step", function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	if playerData.firingSlow > 0 then
		playerAc.activity_type = 4
		if not playerData.speedChanged then
			playerData.speedChanged = true
			playerAc.pHmax = playerAc.pHmax - 0.9
		end
		playerData.firingSlow = math.max(playerData.firingSlow - 0.1, 0)
	elseif playerAc.activity_type == 4 then
		playerAc.activity_type = 0
	end
	if playerData.firingSlow <= 0 and playerData.speedChanged then
		playerData.speedChanged = nil
		playerAc.pHmax = playerAc.pHmax + 0.9
	end
	if playerData.focusUseTimer  and playerData.focusUseTimer > 0 then
		playerData.focusUseTimer = playerData.focusUseTimer - 1
	else
		playerData.focusTimer = 0
		playerData.focusUseTimer = nil
	end
	
	if playerData.addJumpCount then
		playerData.addJumpCount = false
		playerAc.jump_count = playerAc.jump_count + 1
	end
	
	if playerData.vehicle then
		if misc.director:getAlarm(0) == 30 and onScreen(player) and not playerData._EnableJump then
			playerData.sounds.skill3_3:play((1 + math.random() * 0.2), math.min(0 + (math.abs(playerAc.pHspeed) * 0.13), 0.7))
		end
		
		if playerAc.moveUp == 1 and not playerData._EnableJump then
			local feathered = playerAc.feather > 0 and playerAc.jump_count < playerAc.feather
			
			if not feathered then
				playerAc.moveUp = 0
			elseif playerAc.free == 0 then
				playerData.addJumpCount = true
				local sparks = obj.EfSparks:create(player.x, player.y)
				sparks.sprite = spr.EfFeather
				sparks.yscale = 1
			end
			--if not playerData._EnableJump then
				if playerAc.jetpack > 0 and playerAc.jetpack_fuel > 0 then
					player.y = player.y - 1
				end
			--end
		end
		
		if global.quality > 1 and playerAc.free == 0 and player.sprite ~= player:getAnimation("shoot3_1") and not playerData._EnableJump then
			if playerAc.moveLeft > 0 or playerAc.moveRight > 0 then
				par.Baroness:burst("middle", player.x - 10 * player.xscale, player.y + math.random(1, 2), 2, playerData._EfColor)
			end
		end
	end
	if playerData.lastvehicle ~= playerData.vehicle then
		if playerData.vehicle then
			player:setAnimation("idle", player:getAnimation("idle_2"))
			player:setAnimation("walk", player:getAnimation("walk_2"))
			player:setAnimation("jump", player:getAnimation("jump_2"))
		else
			player:setAnimation("idle", player:getAnimation("idle_1"))
			player:setAnimation("walk", player:getAnimation("walk_1"))
			player:setAnimation("jump", player:getAnimation("jump_1"))
		end
	end
	
	--[[if global.timer % (60 * 10) and net.online and player == net.localPlayer then
		if net.host then
			syncInstanceData:sendAsHost(net.ALL, nil, player:getNetIdentity(), "vehicle", playerData.vehicle)
		else
			syncInstanceData:sendAsClient(player:getNetIdentity(), "vehicle", playerData.vehicle)
		end
	end]]
end)

table.insert(call.onImpact, function(damager, x, y)
	if damager:getData().isLaser then
		local parent = damager:getParent()
		if parent and parent:isValid() then
			parent:getData().laserPos = {x, y}
			parent:getData().firingAnimTimer = 2
		end
	--[[elseif damager:getData().isBomb then
		local parent = damager:getParent()
		local bomb = objBomb:create(x, y)
		bomb:getData().parent = parent
		if parent and parent:isValid() then
			bomb:getData().speed = parent:get("attack_speed")
		end
		local enemy = pobj.enemies:findEllipse(x - 10, y - 5, x + 10, y + 5)
		bomb:getData().follow = enemy]]
	end
end)

local preHitCall = function(damager, hit)
	local parent = damager:getParent()
	if parent and parent:isValid() then
		if damager:getData().isLaser then
			local multiplier = 1
			damager:getData().laserC = damager:getData().laserC + 1
			multiplier = 1 / damager:getData().laserC
			local damage = math.min(damager:get("damage") * 0.25 + (0.4 * parent:getData().focusTimer), parent:get("damage") * 2) * multiplier
			damager:set("damage", damage)
			damager:set("damage_fake", damage)
			if not damager:getData().focusincreased then
				local increase = 0.4
				if hit:getData().isShocked then
					increase = 0.9
				end
				parent:getData().focusUseTimer = 120
				parent:getData().focusTimer = parent:getData().focusTimer + increase + 0.1 * parent:get("attack_speed")   --+ increase - math.min(3, parent:get("attack_speed") * 0.1)
				damager:getData().focusincreased = true
				if parent:getData().focusTimer > 50 then
					sSkill1b:play(0.5 + math.random() * 0.07)
					misc.shakeScreen(1)
				end
			end
		elseif damager:getData().shock and not hit:isBoss() then
			hit:set("activity", 52)
			hit:getData().isShocked = parent:getData()._SteadyDuration
			hit:getData()._shockColor = parent:getData()._EfColor
			hit:getData().shockParent = parent
			hit:setAlarm(7, 100)
			parent:getData().shockChild = hit
		end
	end
end

baroness:addCallback("draw", function(player)
	local playerAc = player:getAccessor()
	if player:getData().firingAnimTimer > 0 then
		--local xx, yy = player.x + (200 * player.xscale), player.y
		if player:getData().laserPos then
			xx, yy = player:getData().laserPos[1], player:getData().laserPos[2]
			graphics.color(Color.mix(Color.RED, Color.WHITE, player:getData().firingAnimTimer / 2))
			graphics.alpha(player:getData().firingAnimTimer)
			graphics.line(player.x + 8 * player.xscale, player.y + 1, xx, player.y + 1, 1 * (player:getData().focusTimer / 50))
		end
	end
	if player:getData().firingAnimTimer and player:getData().firingAnimTimer > 0 then
		player:getData().firingAnimTimer = math.max(player:getData().firingAnimTimer - 0.1, 0)
		if player:getData().firingAnimTimer == 0 then 
			player:getData().laserPos = nil
		end
	end
end)

local onStepCall = function()
	for _, enemy in ipairs(pobj.actors:findAll()) do
		local enemyData = enemy:getData()
		if enemyData.isShocked then
			enemy:setAlarm(7, 60)
			enemy:setAlarm(2, 100)
			
			enemy:set("pVspeed", enemyData.shockParent:get("pVspeed"))
			local n = 0
			local xx = enemyData.shockParent:getData()._SteadyDistance
			while Stage.collidesRectangle(enemyData.shockParent.x, enemyData.shockParent.y,
			enemyData.shockParent.x + (xx * enemyData.shockParent.xscale), enemyData.shockParent.y) 
			and n < 60 do
				n = n + 1 
				xx = xx - 2
			end
			enemy.x = enemy.x + ((enemyData.shockParent.x + (xx * enemyData.shockParent.xscale)) - enemy.x) * 0.2
			enemy.y = enemyData.shockParent.y - 4
			enemyData.isShocked = enemyData.isShocked - 1
			if enemyData.isShocked <= 0 or enemyData.shockParent:get("activity") == 30 and enemy:collidesMap(enemy.x, enemy.y - 5) then 
				enemy:set("activity", 0)
				sSkill2b:play(1 + math.random() * 0.2)
				local n = 0
				while enemy:collidesMap(enemy.x, enemy.y) and n < 200 do
					if not enemy:collidesMap(enemy.x + 5, enemy.y) then
						enemy.x = enemy.x + 5
					elseif not enemy:collidesMap(enemy.x - 5, enemy.y) then
						enemy.x = enemy.x - 5
					else
						enemy.y = enemy.y - 1
						n = n + 1
					end
				end
				enemyData.isShocked = nil
				enemyData.shockParent = nil
			end
			enemy:set("ghost_x", enemy.x)
			enemy:set("ghost_y", enemy.y)
		end
	end
end

local onDrawCall = function()
	for _, enemy in ipairs(pobj.actors:findAll()) do
		if enemy:getData().isShocked then
			local preSize = enemy:getData()._shockSize
			
			local image = nil
			if enemy.mask then
				image = enemy.mask
			else
				image = enemy.sprite
			end
			
			local targetSize = (image.width + image.height) / 2
			if preSize then
				enemy:getData()._shockSize = math.approach(preSize, targetSize, (targetSize - preSize) * 0.2)
			else
				enemy:getData()._shockSize = 0
			end
			local size = enemy:getData()._shockSize
			local amount = global.quality - 1
			for i= 1, amount * 3 do
				local aa = (math.random(0, 360000) / 1000)
				local xx = math.cos(aa) * size
				local yy = math.sin(aa) * size
				if global.quality > 1 then
					par.Baroness:burst("above", enemy.x + xx + 1, enemy.y + yy + 1, 1, enemy:getData()._shockColor)
				end
			end
			graphics.color(enemy:getData()._shockColor)
			graphics.alpha(0.75)
			graphics.circle(enemy.x, enemy.y, size, true)
		end
	end
end

baroness:addCallback("init", function()
	tcallback.register("onStep", onStepCall)
	tcallback.register("onDraw", onDrawCall)
	tcallback.register("preHit", preHitCall)
end)

sur.Baroness = baroness