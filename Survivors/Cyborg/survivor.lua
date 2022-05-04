
-- All Cyborg data

local path = "Survivors/Cyborg/"

local cyborg = Survivor.new("Cyborg")

-- Sounds
local sCyborgShoot1 = Sound.load("CyborgShoot1", path.."skill1")
local sCyborgShoot2 = Sound.load("CyborgShoot2", path.."skill2")
local sCyborgSkill3a = Sound.load("CyborgSkill3A", path.."skill3a")
local sCyborgSkill3b = Sound.load("CyborgSkill3B", path.."skill3b")
local sCyborgSkill3c = Sound.load("CyborgSkill3C", path.."skill3c")
local sCyborgSkill4 = Sound.load("CyborgSkill4", path.."skill4")

-- Table sprites
local sprites = {
	idle = Sprite.load("Cyborg_Idle", path.."idle", 1, 4, 7),
	walk = Sprite.load("Cyborg_Walk", path.."walk", 4, 5, 8),
	jump = Sprite.load("Cyborg_Jump", path.."jump", 1, 5, 6),
	climb = Sprite.load("Cyborg_Climb", path.."climb", 2, 4, 7),
	death = Sprite.load("Cyborg_Death", path.."death", 5, 9, 4),
	decoy = Sprite.load("Cyborg_Decoy", path.."decoy", 1, 9, 10),

	shoot1 = Sprite.load("Cyborg_Shoot1", path.."shoot1", 6, 6, 8),
	shoot2 = Sprite.load("Cyborg_Shoot2", path.."shoot2", 8, 12, 19),
	shoot3_1 = Sprite.load("Cyborg_Shoot3A", path.."shoot3a", 3, 11, 16),
	shoot3_2 = Sprite.load("Cyborg_Shoot3B", path.."shoot3b", 6, 11, 16),
	shoot4 = Sprite.load("Cyborg_Shoot4", path.."shoot4", 8, 10, 12),
	
	teleport_1 = Sprite.load("Cyborg_TeleportA", path.."teleporta", 8, 5, 9),
	teleport_2 = Sprite.load("Cyborg_TeleportB", path.."teleportb", 4, 5, 9),
	projectile = Sprite.load("Cyborg_Bullet", path.."bullet", 2, 30, 12)
}
-- Hit sprites
local sprCySparks1 = Sprite.load("Cyborg_Sparks1", path.."sparks1", 4, 13, 8)
local sprCySparks2 = Sprite.load("Cyborg_Sparks2", path.."sparks2", 4, 13, 8)
-- Skill sprites
local sprSkills = Sprite.load("Cyborg_Skills", path.."skills", 6, 0, 0)

-- Selection sprite
cyborg.loadoutSprite = Sprite.load("Cyborg_Select", path.."select", 17, 2, 0)

-- Selection description
cyborg:setLoadoutInfo(
[[The &y&CYBORG&!& is VERSATILE and very TIME EFFICIENT.
Both the &y&UNMAKER&!& and &y&OVERHEAT REDRESS&!& allow it to achieve GREAT DAMAGE OUTPUT.
&y&RISING STAR&!& allows for PRECISE ELIMINATIONS, useful when CONTENDERS are out of reach.
&y&CYBORG&!& can create personal portals he can &y&RECALL&!& to,
opening the door for THOUSANDS of opportunities.]], sprSkills)

-- Skill descriptions
cyborg:setLoadoutSkill(1, "Unmaker",
[[Shoot CONTENDERS with a GAMMA CANNON, 
inflicting &y&185% DAMAGE&!&.]])

cyborg:setLoadoutSkill(2, "Rising Star",
[[Quickly fire THREE shots at CONTENDERS in front of you for
&y&3x240% DAMAGE&!&. Each shot &y&STUNS&!&.]])

cyborg:setLoadoutSkill(3, "Recall",
[[Create a WARP POINT. Once a WARP POINT is set, &b&teleport
&b&to its LOCATION&!&. Teleporting &b&REDUCES SKILL COOLDOWNS.]])

cyborg:setLoadoutSkill(4, "Overheat Redress",
[[&y&Blast yourself backwards&!&, firing a GREATER ENERGY BULLET.
Deals a MAXIMUM of &y&400% DAMAGE PER SECOND&!&.]])

-- Color of highlights during selection
cyborg.loadoutColor = Color.fromHex(0x8AB7A8)

-- Misc. menus sprite
cyborg.idleSprite = sprites.idle

-- Main menu sprite
cyborg.titleSprite = sprites.walk

-- Endquote
cyborg.endingQuote = "..and so it left, with a broken arm and no spare parts."

-- Stats & Skills
cyborg:addCallback("init", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	playerData.teleAvailable = false
	playerData._EfColor = Color.fromHex(0x8BEDE3)
	playerData._EfColor2 = Color.fromHex(0xF4F3B7)
	
	playerData.cHoldTimer = 0
	playerData.cHoldTimer2 = 0
	
	player:setAnimations(sprites)
	
	if Difficulty.getActive() == dif.Drizzle then
		player:survivorSetInitialStats(160, 12, 0.055)
	else
		player:survivorSetInitialStats(110, 12, 0.025)
	end
	
	player:setSkill(1, "Unmaker", "Fire a gamma cannon for 185% damage.",
	sprSkills, 1, 30)
		
	player:setSkill(2, "Rising Star", "Quickly fire three shots for 3x240% damage, stunning enemies.",
	sprSkills, 2, 3 * 60)

	player:setSkill(3, "Recall Point", "Create a personal warp point.",
	sprSkills, 3, 2 * 60)

	player:setSkill(4, "Overheat Redress", "Blast yourself backwards with a greater energy discharge, dealing up to 400% DPS.",
	sprSkills, 4, 6 * 60)
end)

cyborg:addCallback("step", function(player)
	if player:get("activity") == 99 then
		player:getData().teleAvailable = false
	end
end)

-- Called when the player levels up
cyborg:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(26, 3, 0.0025, 3)
end)

-- Called when the player picks up the Ancient Scepter
cyborg:addCallback("scepter", function(player)
	player:setSkill(4, "Gamma Overheat Redress", "Blast yourself backwards with a greater energy discharge, dealing up to 650% DPS.",
	sprSkills, 5, 6 * 60)
end)

-- Skills

local removePoint = function(player)
	sCyborgSkill3c:play(1 + math.random() * 0.2)
	player:setSkill(3, "Recall Point", "Create a personal warp point.",
	sprSkills, 3, 2 * 60)
	if player:getData().activeTele and player:getData().activeTele:isValid() then
		player:getData().activeTele:destroy()
	end
	player:getData().teleAvailable = false
	player:getData().cHoldTimer = 0
	player:getData().holdDone = true
	player:getData().cHoldTimer2 = 1
end

local syncRemovePoint
syncRemovePoint = net.Packet.new("SSCyReP", function(sender, player)
	local pInst = player:resolve()
	if pInst:isValid() then
		removePoint(pInst)
		if net.host then
			syncRemovePoint:sendAsHost(net.EXCLUDE, sender, player)
		end
	end
end)

-- Teleport Object
local objTeleport = Object.new("Cyborg_Teleport")
local sprCTeleportParticle = Sprite.load("Cyborg_TeleportParticle", path.."teleportparticle", 4, 5, 5)

objTeleport.sprite = sprites.teleport_1
objTeleport.depth = 1

par.CyborgTele = ParticleType.new("CyborgTele")
par.CyborgTele:sprite(sprCTeleportParticle, true, true, true)
par.CyborgTele:size(0.5, 1.5, -0.1, 0)
par.CyborgTele:angle(0, 90, 0, 0, false)

objTeleport:addCallback("create", function(self)
	self:getData().timer = 0
	self.spriteSpeed = 0.15
end)

--local teleRange = 1050

objTeleport:addCallback("step", function(self)
	local parent = self:getData().parent
	if parent and parent:isValid() then
		local selfData = self:getData()
		if not self:getData().firstFrame then
			selfData.firstFrame = true
			self.sprite = parent:getAnimation("teleport_1")
		end
		--selfDestroy = true
		--for _, player in ipairs(obj.P:findAllEllipse(self.x - teleRange, self.y - teleRange, self.x + teleRange, self.y + teleRange)) do
			--if player == parent then
				--selfDestroy = false
				--break
			--end
		--end
		
		if selfData.timer == 120 then
			self.sprite = sprites.teleport_2
			if parent and parent:isValid() then
				self.sprite = parent:getAnimation("teleport_2")
			end
		else
			selfData.timer = selfData.timer + 1
		end
		--[[if selfDestroy then
			sCyborgSkill3c:play(1 + math.random() * 0.2)
			parent:getData().teleAvailable = false
			parent:setSkill(3, "Recall Point", "Create a personal warp point.",
			sprSkills, 3, 2 * 60)
			parent:activateSkillCooldown(1)
			self:destroy()
		end]]
	end
end)

--[[objTeleport:addCallback("draw", function(teleport)
	local parent = teleport:getData().parent
	if parent then
		if not net.online or parent == net.localPlayer then
			local distance = distance(teleport.x, teleport.y, parent.x, parent.y)
			graphics.alpha((math.sin(misc.director:getAlarm(0) * 0.05) - 0.5) * (distance / teleRange))
			graphics.color(parent:getData()._EfColor)
			graphics.circle(teleport.x, teleport.y, teleRange, true)
			graphics.alpha((math.sin(misc.director:getAlarm(0) * 0.05) - 0.97) * (distance / teleRange))
			graphics.circle(teleport.x, teleport.y, teleRange, false)
		end
	end
end)]]

-- Bullet Object
local objBullet = Object.new("Cyborg_Bullet")
local sprBulletMask = Sprite.load("CyborgBulletMask", path.."bulletMask", 1, 17, 11)
local enemies = pobj.enemies

objBullet.sprite = sprites.projectile
objBullet.depth = - 5

objBullet:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	selfData.team = "player"
	selfData.rate = 0.008
	selfData._EfColor = Color.fromHex(0xF4F3B7)
	self.spriteSpeed = 0.25
	self.mask = sprBulletMask
end)
objBullet:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	self.x = self.x + math.sign(self.xscale) * 2.3
	
	self.yscale = self.yscale - selfData.rate
	
	if self:getData().parent then
		local parent = self:getData().parent
		if misc.director:getAlarm(0) % math.floor(15 + ((1 - self.yscale) * 15)) == 0 then
			local lightning = obj.ChainLightning:create(self.x, self.y)
			lightning:set("blend", self:getData()._EfColor.gml)
			lightning:set("parent", parent.id)
			local scepter = parent:get("scepter")
			if scepter > 0 then
				lightning:set("bounce", 3)
				lightning:set("damage", math.round((parent:get("damage") * 0.5 + (0.5)) * self.yscale))
			else
				lightning:set("bounce", 1)
				lightning:set("damage", math.round((parent:get("damage") * 0.3) * self.yscale))
			end
		end
		if misc.director:getAlarm(0) % 5 == 0 then
			local xr, yr = 10 * self.xscale, 12 * self.yscale
			local actor = pobj.actors:findRectangle(self.x - xr, self.y - yr, self.x + xr, self.y + yr)
			if actor then
				if actor:get("team") ~= selfData.team and self:collidesWith(actor, self.x, self.y) then
					for i = 0, parent:get("sp") do
						damager = parent:fireExplosion(self.x, self.y, 17 / 19, (13 * self.yscale) / 4, 3.15 * self.yscale, nil, nil)
						damager:set("knockback_direction", self.xscale)
						if i ~= 0 then
							damager:set("climb", i * 8)
						end
					end
				end
			end
		end
	end
	
	if self.yscale <= 0 then
		self:destroy()
	end
end)

cyborg:addCallback("useSkill", function(player, skill)
	local playerAc = player:getAccessor()
	if player:get("activity") == 0 then
		local cd = false
		if skill == 1 then
			-- Z skill
			player:survivorActivityState(1, player:getAnimation("shoot1"), 0.22, true, true)
			cd = true
		elseif skill == 2 then
			-- X skill
			player:survivorActivityState(2, player:getAnimation("shoot2"), 0.2, true, true)
			cd = true
		elseif skill == 3 and not player:getData().holdDone then
			-- C skill
			if not player:getData().teleAvailable then
				player:survivorActivityState(3, player:getAnimation("shoot3_1"), 0.25, false, true)
				cd = true
			end
		elseif skill == 4 then
			-- V skill
			player:survivorActivityState(4, player:getAnimation("shoot4"), 0.25, false, false)
			cd = true
		end
		if cd then
			player:activateSkillCooldown(skill)
		end
	end
end)

cyborg:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	
	if skill == 1 and not player:getData().skin_skill1Override then
		-- Unmaker
		if relevantFrame == 1 then
			sCyborgShoot1:play(1 + math.random() * 0.2,0.6)
			if player:survivorFireHeavenCracker(1.3) == nil then
				for i = 0, playerAc.sp do
					local bullet = player:fireBullet(player.x, player.y-3, player:getFacingDirection(), 500, 1.85, sprCySparks1)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
		end
		
	elseif skill == 2 and not player:getData().skin_skill2Override then
		-- Rising Star
		if relevantFrame == 3 or relevantFrame == 4 or relevantFrame == 5 then
			sCyborgShoot2:play(0.7 + math.random() * 0.2,0.7)
		end
		for i = 0, playerAc.sp do
			if player:getFacingDirection() == 0 then
				if relevantFrame == 3 or relevantFrame == 4 or relevantFrame == 5 then
					
					local offset = 0
					if relevantFrame == 4 then
						offset = 11.2
					elseif relevantFrame == 5 then
						offset = 22.5
					end
					
					local nearestInstance = nil
					for _, instance2 in ipairs(pobj.actors:findAll()) do
						if instance2:get("team") ~= player:get("team") and instance2.x > player.x and instance2.y < player.y + 20 then
							local dis = distance(player.x, player.y, instance2.x, instance2.y)
							if dis < 400 then
								if not nearestInstance or dis < nearestInstance.dis then
									nearestInstance = {inst = instance2, dis = dis}
								end
							end
						end
					end
					if nearestInstance then
						nearestInstance = nearestInstance.inst
					end
					
					local angle = 0
					
					if nearestInstance and nearestInstance:isValid() then
						angle = posToAngle(player.x, player.y, nearestInstance.x, nearestInstance.y)
					else
						angle = 0 + offset
					end
					
					local bullet = player:fireBullet(player.x, player.y - 2, angle, 400, 2.4, sprCySparks1)
					bullet:set("stun", 1)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
					addBulletTrailLine(bullet, player:getData()._EfColor, 2)
				end
			else
				if relevantFrame == 3 or relevantFrame == 4 or relevantFrame == 5 then
					
					local offset = 0
					if relevantFrame == 4 then
						offset = 11.2
					elseif relevantFrame == 5 then
						offset = 22.5
					end
					
					local nearestInstance = nil
					for _, instance2 in ipairs(pobj.actors:findAll()) do
						if instance2:get("team") ~= player:get("team") and instance2.x < player.x and instance2.y < player.y + 20 then
							local dis = distance(player.x, player.y, instance2.x, instance2.y)
							if dis < 400 then
								if not nearestInstance or dis < nearestInstance.dis then
									nearestInstance = {inst = instance2, dis = dis}
								end
							end
						end
					end
					if nearestInstance then
						nearestInstance = nearestInstance.inst
					end
					
					local angle = 180
					
					if nearestInstance and nearestInstance:isValid() then
						angle = posToAngle(player.x, player.y, nearestInstance.x, nearestInstance.y)
					else
						angle = 180 - offset
					end
					
					local bullet = player:fireBullet(player.x, player.y - 2, angle, 400, 2.4, sprCySparks1)
					bullet:set("stun", 1)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
					addBulletTrailLine(bullet, player:getData()._EfColor, 2)
				end
			end
		end

	elseif skill == 3 and not player:getData().skin_skill3Override then
		-- Recall
		
		if player:getData().teleAvailable == false then
			if relevantFrame == 1 then
				sCyborgSkill3a:play(1 + math.random() * 0.2)
			end
			if relevantFrame == 2 then
				player:getData().teleAvailable = true
				player:getData().activeTele = objTeleport:create(player.x, player.y)
				player:getData().activeTele:getData().parent = player
				player:setSkill(3, "Recall", "Teleport back to the personal warp point. Hold to remove.",
				sprSkills, 6, 6 * 60)
				player:activateSkillCooldown(1)
			end
			if global.quality > 1 then
				par.CyborgTele:burst("middle", player.x + math.random(-4,4), player.y + math.random(0,4), 4)
			end
		else
			if player.sprite == player:getAnimation("shoot3_2") and playerAc.invincible < 3 then
				playerAc.invincible = 3
			end
			
			if relevantFrame == 1 then
				sCyborgSkill3b:play(1 + math.random() * 0.2)
			elseif relevantFrame > 1 and global.quality > 1 then
				par.CyborgTele:burst("middle", player.x + math.random(-2,2), player.y + math.random(-1,4), 1)
			end
			
			if relevantFrame == 5 then
				player:setAlarm(3, math.max(player:getAlarm(3) - 120, 1))
				player:setAlarm(5, math.max(player:getAlarm(5) - 120, 1))
				player:getData().teleAvailable = false
				if player:getData().activeTele and player:getData().activeTele:isValid() then
					player:set("x", player:getData().activeTele.x)
					player:set("y", player:getData().activeTele.y)
					player:set("ghost_x", player:getData().activeTele.x)
					player:set("ghost_y", player:getData().activeTele.y)
					if global.quality > 1 then
						par.CyborgTele:burst("middle", player:getData().activeTele.x, player:getData().activeTele.y, 1)
					end
					player:getData().activeTele:destroy()
				end
				player:setSkill(3, "Recall Point", "Create a personal warp point.",
				sprSkills, 3, 2 * 60)
				player:activateSkillCooldown(1)
			end
		end
		
	elseif skill == 4 and not player:getData().skin_skill4Override then
        -- Overheat Redress
        if relevantFrame == 4 then
			misc.shakeScreen(5)
			local bullet = objBullet:create(player.x, player.y)
			bullet.sprite = player:getAnimation("projectile")
			bullet:getData().parent = player
			bullet:getData()._EfColor = player:getData()._EfColor2
			playerAc.pVspeed = playerAc.pVmax * -0.6
			playerAc.pHspeed = playerAc.pHmax * -3 * player.xscale
			sCyborgSkill4:play(1 + math.random() * 0.2)
			if playerAc.scepter > 0 then
				bullet.yscale = 1 + 0.5 * playerAc.scepter
				bullet.xscale = 1 + 0.2 * playerAc.scepter
				bullet:getData().rate = bullet:getData().rate * (1 + 0.5 * (playerAc.scepter - 1))
			end
			bullet.xscale = bullet.xscale * player.xscale
        end
	end
end)

cyborg:addCallback("step", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	local a = not player:getData().skin_skill3Override
	local teleAvailable = player:getData().activeTele and player:getData().activeTele:isValid()
		if syncControlRelease(player, "ability3") then
			if playerData.teleAvailable and playerAc.activity == 0 and not playerData.holdDone then
				if playerData.cHoldTimer <= 15 and player:getAlarm(4) == -1 then
					player:survivorActivityState(3, player:getAnimation("shoot3_2"), 0.25, false, true)
					player:activateSkillCooldown(3)
				--[[elseif playerData.cHoldTimer > 15 then
					sCyborgSkill3c:play(1 + math.random() * 0.2)
					if player:getData().activeTele and player:getData().activeTele:isValid() then
						player:setSkill(3, "Recall Point", "Create a personal warp point.",
						sprSkills, 3, 2 * 60)
						player:getData().activeTele:destroy()
					end]]
				end
			end
			playerData.cHoldTimer = 0
			playerData.holdDone = nil
		end
	if a and teleAvailable and playerAc.c_skill == 1 and not player:getData().skin_skill3Override then
		if playerData.cHoldTimer < 90 then
			playerData.cHoldTimer = playerData.cHoldTimer + 1
		elseif not playerData.holdDone then
			sCyborgSkill3c:play(1 + math.random() * 0.2)
			player:setSkill(3, "Recall Point", "Create a personal warp point.",
			sprSkills, 3, 2 * 60)
			player:getData().activeTele:destroy()
			
			player:getData().teleAvailable = false
			playerData.cHoldTimer = 0
			playerData.holdDone = true
			playerData.cHoldTimer2 = 1
			if net.online then
				if net.host then
					syncRemovePoint:sendAsHost(net.ALL, nil, player:getNetIdentity())
				else
					syncRemovePoint:sendAsClient(player:getNetIdentity())
				end
			end
		end
	end
	
	if playerData.cHoldTimer2 > 0 then
		playerData.cHoldTimer2 = playerData.cHoldTimer2 - 0.1
	end
end)

local onPlayerHUDDrawCall = function(player, x, y)
	if player:getSurvivor() == cyborg then
		if not player:getData().skin_skill3Override then
			if player:getData().cHoldTimer > 0 then
				local mult = player:getData().cHoldTimer / 90
				graphics.alpha(mult)
				graphics.color(Color.RED)
				graphics.rectangle(x + 46, y, x + 46 + 18 * mult, y + 18, false)
			end
			if player:getData().cHoldTimer2 > 0 then
				local mult = player:getData().cHoldTimer2
				graphics.alpha(mult)
				graphics.color(Color.WHITE)
				graphics.rectangle(x + 46, y, x + 46 + 18, y + 18, false)
			end
		end
	end
end

table.insert(call.onStageEntry, function()
	for _, player in ipairs(misc.players) do
		if player:getSurvivor() == cyborg then
			if not SurvivorVariant.getActive(player) then
				player:setSkill(3, "Recall Point", "Create a personal warp point.",
				sprSkills, 3, 2 * 60)
				player:activateSkillCooldown(1)
			end
		end
	end
end)

cyborg:addCallback("init", function(player)
	tcallback.register("onPlayerHUDDraw", onPlayerHUDDrawCall)
end)

sur.Cyborg = cyborg