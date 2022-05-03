local path = "Survivors/Mortarman/"

local Mortarman = Survivor.new("Artillerist")

if not global.rormlflag.ss_test and not global.aprilFools then
	Mortarman.disabled = true
end

-- Sounds
--local sMortarmanShoot1 = Sound.load("MortarmanShoot1", path.."skill1")

local sprite = Sprite.load("Mortarman_Idle", path.."idle", 1, 6, 10)
local sprite2 = Sprite.load("Mortarman_Shoot1_", path.."shoot1", 2, 6, 10)

-- Table sprites
local sprites = {
	idle = sprite,
	walk = Sprite.load("Mortarman_Walk", path.."walk", 8, 8, 10),
	jump = Sprite.load("Mortarman_Jump", path.."jump", 1, 6, 10),
	climb = Sprite.load("Mortarman_Climb", path.."climb", 2, 4, 9),
	death = Sprite.load("Mortarman_Death", path.."death", 8, 8, 12),
	decoy = sprite,
	
	shoot1 = Sprite.load("Mortarman_Shoot1", path.."shoot1", 6, 12, 22),
	shoot2 = Sprite.load("Mortarman_Shoot2", path.."shoot2", 4, 6, 10),
	shoot3 = Sprite.load("Mortarman_Shoot3", path.."shoot3", 4, 6, 12),
	
	mortar = Sprite.load("Mortarman_Mortar", path.."Mortar", 1, 2, 3)
}

-- Skill sprites
local sprSkills = Sprite.load("Mortarman_Skills", path.."skills", 6, 0, 0)
local sprSkills2 = Sprite.load("Mortarman_Skills2", path.."skillsCount", 9, 0, 0)

-- Selection sprite
Mortarman.loadoutSprite = Sprite.load("Mortarman_Select", path.."select", 4, 2, 0)

-- Selection description
Mortarman:setLoadoutInfo(
[[The &y&Artillerist&!& is a mid-long ranged mortar wielding soldier focused
on dealing damage at the widest coverage, no enemy is too big to fight.
&y&Low Launch&!& yourself to distance yourself from threats and &y&Load&!&
up to 8 missiles and blast enemies away from afar with &y&Tracking Munition.]], sprSkills)

if global.aprilFools then
	Mortarman.displayName = "Bombardier"
Mortarman:setLoadoutInfo(
[[The &y&Bombardier&!& is a mid-long ranged mortar wielding soldier focused
on dealing damage at the widest coverage, no enemy is too big to fight.
&y&Load&!& up to 8 missiles and blast enemies away from afar with
&y&Tracking Munition&!&, and &y&Low Launch&!& yourself to distance yourself
from threats.]], sprSkills)
end

-- Skill descriptions

Mortarman:setLoadoutSkill(1, "Salvo",
[[Fire all loaded mortar bombs for &y&250% damage each.]])

Mortarman:setLoadoutSkill(2, "Load",
[[Load an &y&extra shell&!& onto the mortar.]])

Mortarman:setLoadoutSkill(3, "Low Launch",
[[Launch a mortar bomb below you that &b&knocks all characters back&!&.
&y&Deals 250% damage.]])

Mortarman:setLoadoutSkill(4, "Tracking Munition",
[[For 4 seconds, launched mortar bombs &y&seek enemies.]])

-- Color of highlights during selection
Mortarman.loadoutColor = Color.fromHex(0xA06EC8)

-- Misc. menus sprite
Mortarman.idleSprite = sprites.idle

-- Main menu sprite
Mortarman.titleSprite = sprites.walk

-- Endquote
Mortarman.endingQuote = "..and so he left, permeated in shrapnel."

Mortarman:addCallback("init", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	playerAc.mortarPellets = 0
	
	playerData.homingMortars = 0
	
	player:setAnimations(sprites)
	
	if Difficulty.getActive() == dif.Drizzle then
		player:survivorSetInitialStats(150, 13, 0.038)
	else
		player:survivorSetInitialStats(100, 13, 0.008)
	end
	
	player:setSkill(1, "Salvo", "Fire all loaded mortar bombs for 250% damage each.",
	sprSkills, 1, 60)
	
	player:setSkill(2, "Load", "Load an extra shell onto the mortar.",
	sprSkills, 2, 2 * 60)
		
	player:setSkill(3, "Low Launch", "Launch a mortar bomb below you that knocks all characters back.",
	sprSkills, 3, 3 * 60)
		
	player:setSkill(4, "Tracking Munition", "For 4 seconds, launched mortar bombs seek enemies.",
	sprSkills, 4, 8 * 60)
end)

-- Called when the player levels up
Mortarman:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(24, 4, 0.0012, 2)
end)

-- Called when the player picks up the Ancient Scepter
Mortarman:addCallback("scepter", function(player)
	player:setSkill(4,
		"AtG Munition",
		"For 4 seconds, fired mortars seek enemies directly, ignoring all ground.",
		sprSkills, 5,
		8 * 60
	)
end)

-- Skills
Mortarman:addCallback("useSkill", function(player, skill)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	if player:get("activity") == 0 then
		local cd = true
		
		if skill == 1 then
			-- Z skill
			player:survivorActivityState(1, player:getAnimation("shoot1"), 0.25, true, true)
			if not playerData.skin_skill2Override then
				player:setSkillIcon(2, sprSkills, 2)
			end
		elseif skill == 2 then
			-- X skill
			if playerAc.mortarPellets < 7 then
				player:survivorActivityState(2, player:getAnimation("shoot2"), 0.25, true, true)
			else
				cd = false
			end
		elseif skill == 3 then
			-- C skill
			player:survivorActivityState(3, player:getAnimation("shoot3"), 0.25, false, false)
		elseif skill == 4 then
			-- V skill
			sfx.JanitorShoot2_1:play(1.3)
			playerData.homingMortars = 240
			--if playerAc.scepter > 0 then
				--player:survivorActivityState(4, player:getAnimation("shoot5"), 0.25, true, false)
			--else
				--player:survivorActivityState(4, player:getAnimation("shoot4"), 0.25, true, false)
			--end
		end
		if cd then
			player:activateSkillCooldown(skill)
		end
	end
end)

local objMortar = Object.new("Mortar")
objMortar.sprite = spr.EfMortar
sprMortarMask = Sprite.load("Mortarman_MortarMask", path.."MortarMask", 1, 2, 3)
objMortar:addCallback("create", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	self.mask = sprMortarMask
	
	selfData.scepter = false
	selfData.vspeed = 0
	selfData.direction = 0
	selfData.speed = 4
	selfData.team = "player"
	selfData.life = 0
	selfData.maxLife = 400
	
	selfData.faceDirection = 0
end)
objMortar:addCallback("step", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	if global.quality > 1 then
		if selfData.homing then
			par.Smoke4:burst("middle", self.x, self.y, 1)
		else
			par.Smoke2:burst("middle", self.x, self.y, 1)
		end
	end
	
	selfData.life = selfData.life + 1
	
	local pCollisionEnabled = false
	
	if selfData.homing then
		selfData.vspeed = 0
		if selfData.life > 3 then
			local turnSpeed = 0.06
			local target = nil
			
			if selfData.scepter then
				turnSpeed = 0.2
				selfData.speed = selfData.speed - 0.005
			end
			
			if selfData.push and selfData.life > 10 then
				target = selfData.parent
				turnSpeed = 0.1052
				pCollisionEnabled = true
				selfData.speed = selfData.speed - 0.02 --aaaaa cringe
			elseif not selfData.push then
				for _, instance2 in ipairs(pobj.actors:findAll()) do
					if instance2:get("team") ~= selfData.team then
						if selfData.faceDirection == 0 or selfData.faceDirection > 0 and instance2.x > self.x - 100 or selfData.faceDirection < 0 and instance2.x < self.x + 100 then
							local dis = distance(self.x, self.y, instance2.x, instance2.y)
							if not target or dis < target.dis then
								target = {inst = instance2, dis = dis}
							end
						end
					end
				end
				if target then
					target = target.inst
				end
			end
			if target and target:isValid() then
				selfData.direction = selfData.direction + (angleDif(selfData.direction, posToAngle(self.x, target.y, target.x, self.y)) * -turnSpeed)
			end
		end
		selfData.speed = selfData.speed + 0.025
	else
		selfData.vspeed = selfData.vspeed + 0.1
		selfData.speed = selfData.speed - 0.05
	end
	
	local radAngle = math.rad(selfData.direction)
	local xx = math.cos(radAngle) * selfData.speed
	local yy =  math.sin(radAngle) * selfData.speed
	self.x = self.x + xx
	self.y = math.max(self.y + yy + selfData.vspeed, -200)
	
	local collidesEnemy = false
	for _, actor in ipairs(pobj.actors:findAllRectangle(self.x - 10, self.y - 10, self.x + 10, self.y + 10)) do
		if actor:get("team") ~= selfData.team and self:collidesWith(actor, self.x, self.y) then
			collidesEnemy = true
			break
		end
	end
	
	self.angle = posToAngle(self.x, self.y, self.x + xx, self.y + yy + selfData.vspeed)
	
	if self:collidesMap(self.x, self.y) and not selfData.scepter or collidesEnemy or pCollisionEnabled and selfData.parent and selfData.parent:isValid() and self:collidesWith(selfData.parent, self.x, self.y) then
		self:destroy()
	elseif selfData.life > selfData.maxLife then
		self:delete()
	end
end)
objMortar:addCallback("destroy", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	if selfData.push then
		local range = 28
		for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - range, self.y - range, self.x + range, self.y + range)) do
			if actor:isClassic() then
				--local angle = posToAngle(self.x, self.y, actor.x, actor.y)
				local xx = math.sign(actor.x - self.x)
				local yy = math.sign(actor.y - self.y)
				actor:getData().xAccel = 4 * xx
				actor:set("pVspeed", 4 * yy)
			end
		end
		if selfData.parent and selfData.parent:isValid() then
			selfData.parent:fireExplosion(self.x, self.y, 26 / 9, 18 / 4, 1, spr.EfExplosive)
		end
		
		sfx.GiantJellyExplosion:play()
	else
		if selfData.parent and selfData.parent:isValid() then
			selfData.parent:fireExplosion(self.x, self.y, 26 / 9, 18 / 4, 2.5, spr.EfExplosive)
		end
		sfx.GiantJellyExplosion:play(1.4)
	end
	
end)

Mortarman:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if skill == 1 and not player:getData().skin_skill1Override then
		-- Mortar
		if relevantFrame == 1 then
			sfx.RiotGrenade:play(1.2)
			if playerData.homingMortars > 0 then
				sfx.MissileLaunch:play(0.8, 0.6)
			end
			local noEnemies = #pobj.actors:findAllRectangle(player.x - 500, 0, player.x + 500, player.y + 1000) <= #misc.players
			for ii = 0, playerAc.sp do
				for i = 0, playerAc.mortarPellets do
					local angle = 45 + (ii * 2) + (i * 4) - playerAc.mortarPellets * 4
					local speed = 4.4 + math.abs(playerAc.pHspeed) + (i * 0.4) - playerAc.mortarPellets * 0.1
					local mortar = objMortar:create(player.x + player.xscale * 2, player.y - 2)
					mortar.sprite = player:getAnimation("mortar")
					mortar:getData().direction = player:getFacingDirection() + angle * player.xscale * -1
					mortar:getData().speed = speed
					mortar:getData().team = playerAc.team
					mortar:getData().parent = player
					if playerData.homingMortars > 0 then
						mortar:getData().scepter = playerAc.scepter
						mortar:getData().homing = true
						mortar:getData().speed = speed - 1
						--if noEnemies then
						--	mortar:getData().direction = 270 + (i * 0.4) - playerAc.mortarPellets * 0.1
						--	mortar:getData().maxLife = 1200
						--else
							mortar:getData().faceDirection = player.xscale
						--end
						
						mortar:getData().scepter = playerAc.scepter > 0
					end
				end
			end
			playerAc.mortarPellets = 0
		end
		
	elseif skill == 2 and not player:getData().skin_skill2Override then
		-- Overcharge
		if relevantFrame == 2 and playerAc.mortarPellets < 7 then
			sfx.GiantJellyHit:play(0.7, 0.5)
			playerAc.mortarPellets = playerAc.mortarPellets + 1
			if playerAc.mortarPellets >= 7 then
				player:setSkillIcon(2, sprSkills, 6)
			end
		end
		
	elseif skill == 3 and not player:getData().skin_skill3Override then
        -- Launch
		if relevantFrame == 1 then
			sfx.RiotGrenade:play(1)
			for i = 0, playerAc.sp do
				local mortar = objMortar:create(player.x, player.y + 1)
				mortar.sprite = player:getAnimation("mortar")
				mortar:getData().direction = player:getFacingDirection() + (2 * i) + 55 * player.xscale
				mortar:getData().push = true
				mortar:getData().team = playerAc.team
				mortar:getData().parent = player
				if playerData.homingMortars > 0 then
					mortar:getData().homing = true
					
					--mortar:getData().scepter = playerAc.scepter > 0
				end
			end
		end
	end
end)

Mortarman:addCallback("step", function(player)
	local playerData = player:getData()
	
	if playerData.homingMortars > 0 then
		playerData.homingMortars = playerData.homingMortars - 1
	end
end)

local onPlayerHUDDrawCall = function(player, x, y)
	if player:getSurvivor() == Mortarman and not player:getData().skin_skill1Override then
		local bullets = player:get("mortarPellets")
		
		graphics.drawImage{
			image = sprSkills2,
			subimage = bullets + 1,
			y = y - 11,
			x = x
		}
	end
end

Mortarman:addCallback("init", function(player)
	tcallback.register("onPlayerHUDDraw", onPlayerHUDDrawCall)
end)

sur.Mortarman = Mortarman