local path = "Survivors/Brawler/"

local Brawler = Survivor.new("Brawler")

if not global.rormlflag.ss_test then
	Brawler.disabled = true
end

-- Sounds
--local sBrawlerShoot1 = Sound.load("BrawlerShoot1", path.."skill1")

local sprite = Sprite.load("Brawler_Idle", path.."idle", 1, 9, 9)

-- Table sprites
local sprites = {
	idle = sprite,
	walk = Sprite.load("Brawler_Walk", path.."walk", 8, 10, 9),
	jump = Sprite.load("Brawler_Jump", path.."jump", 1, 9, 9),
	climb = Sprite.load("Brawler_Climb", path.."climb", 2, 5, 10),
	death = Sprite.load("Brawler_Death", path.."death", 8, 10, 9),
	decoy = sprite,
	
	shoot1 = Sprite.load("Brawler_Shoot1", path.."shoot1", 4, 6, 9),
	shoot2 = Sprite.load("Brawler_Shoot2", path.."shoot2", 4, 10, 14),
	shoot3 = Sprite.load("Brawler_Shoot3", path.."shoot3", 4, 7, 9),
	shoot4 = Sprite.load("Brawler_Shoot4", path.."shoot4", 7, 10, 32),
	shoot5 = Sprite.load("Brawler_Shoot5", path.."shoot4", 7, 10, 32),
}

-- Skill sprites
local sprSkills = Sprite.load("Brawler_Skills", path.."skills", 5, 0, 0)

-- Selection sprite
Brawler.loadoutSprite = Sprite.load("Brawler_Select", path.."select", 4, 2, 0)

-- Selection description
Brawler:setLoadoutInfo(
[[The &y&Brawler&!& is an agile melee fighter.]], sprSkills)

-- Skill descriptions

Brawler:setLoadoutSkill(1, "Punch",
[[Punch enemies at close range for &y&100% damage.]])

Brawler:setLoadoutSkill(2, "Throw",
[[Throw enemies upwards for &y&250% damage.]])

Brawler:setLoadoutSkill(3, "Pounce",
[[Launch yourself towards the nearest enemy in front of you.
Deal &y&250% damage&!& on impact with the enemy.]])

Brawler:setLoadoutSkill(4, "Dive Drop",
[[Leap up and drop to the ground, dealing up to &y&1000% damage.&!&
Deals more damage the higher the drop is executed. Stuns enemies.]])

-- Color of highlights during selection
Brawler.loadoutColor = Color.fromHex(0xEAB779)

-- Misc. menus sprite
Brawler.idleSprite = sprites.idle

-- Main menu sprite
Brawler.titleSprite = sprites.walk

-- Endquote
Brawler.endingQuote = "..and so he left, wrestling with his past."

Brawler:addCallback("init", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	playerAc.armor = playerAc.armor + 30
	
	player:setAnimations(sprites)
	
	if Difficulty.getActive() == dif.Drizzle then
		player:survivorSetInitialStats(150, 13, 0.038)
	else
		player:survivorSetInitialStats(100, 13, 0.008)
	end
	
	player:setSkill(1, "", "",
	sprSkills, 1, 25)
		
	player:setSkill(2, "", "",
	sprSkills, 2, 3 * 60)
		
	player:setSkill(3, "", "",
	sprSkills, 3, 4 * 60)
		
	player:setSkill(4, "", "",
	sprSkills, 4, 4 * 60)
end)


-- Called when the player levels up
Brawler:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(24, 4, 0.0012, 2)
end)

-- Called when the player picks up the Ancient Scepter
Brawler:addCallback("scepter", function(player)
	player:setSkill(4,
		"",
		"",
		sprSkills, 9,
		9 * 60
	)
end)

-- Skills
Brawler:addCallback("useSkill", function(player, skill)
	local playerAc = player:getAccessor()
	if player:get("activity") == 0 then
		local cd = true
		
		if skill == 1 then
			-- Z skill
			player:survivorActivityState(1, player:getAnimation("shoot1"), 0.2, true, true)
		elseif skill == 2 then
			-- X skill
			player:survivorActivityState(2, player:getAnimation("shoot2"), 0.25, true, true)
		elseif skill == 3 then
			-- C skill
			player:survivorActivityState(3, player:getAnimation("shoot3"), 0.25, false, false)
		elseif skill == 4 then
			-- V skill
			if playerAc.scepter > 0 then
				player:survivorActivityState(4, player:getAnimation("shoot5"), 0.25, true, false)
			else
				player:survivorActivityState(4, player:getAnimation("shoot4"), 0.25, true, false)
			end
		end
		if cd then
			player:activateSkillCooldown(skill)
		end
	end
end)

Brawler:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	
	if skill == 1 and not player:getData().skin_skill1Override then
		-- Punch
		if relevantFrame == 1 then
			sfx.PodHit:play(0.8)
			for i = 0, playerAc.sp do
				local bullet = player:fireExplosion(player.x + player.xscale * 6, player.y, 15 / 19, 5 / 4, 1)
				bullet:set("stun", 0.25)
				bullet:getData().shakeScreen = 1
				bullet:getData().pushSide = 1.2 * player.xscale
				player:getData().xAccel = 1 * player.xscale
				if i ~= 0 then
					bullet:set("climb", i * 8)
				end
			end
		end
		
	elseif skill == 2 and not player:getData().skin_skill2Override then
		-- Throw
		if relevantFrame == 1 then
			if onScreen(player) then
				misc.shakeScreen(2)
			end
			sfx.Reflect:play(0.8)
			for i = 0, playerAc.sp do
				local bullet = player:fireExplosion(player.x + player.xscale * 6, player.y, 15 / 19, 5 / 4, 2.5)
				bullet:set("stun", 1)
				bullet:set("knockup", 7)
				bullet:getData().pushSide = 4 * player.xscale * -1
				if i ~= 0 then
					bullet:set("climb", i * 8)
				end
				player:set("pVspeed", -2.5)
			end
		end
		
	elseif skill == 3 and not player:getData().skin_skill3Override then
        -- Pounce
		if player:get("invincible") < 30 then
			player:set("invincible", 30)
		end
		if relevantFrame == 1 then
			sfx.PodDeath:play(1.3)
			local target = nil
			for _, instance2 in ipairs(pobj.actors:findAll()) do
				if instance2:get("team") ~= playerAc.team then
					if player.xscale > 0 and instance2.x > player.x - 10 or player.xscale < 0 and instance2.x < player.x + 10 then
						local dis = distance(player.x, player.y, instance2.x, instance2.y)
						if not target or dis < target.dis then
							if dis < 200 then
								target = {inst = instance2, dis = dis}
							end
						end
					end
				end
			end
			local xx = 4 * player.xscale
			local yy = 0
			if target then
				target = target.inst
				if target:isValid() then
					local angle = posToAngle(player.x, target.y, target.x, player.y)
					local angleRad = math.rad(angle)
					xx = math.cos(angleRad) * 5
					yy = math.sin(angleRad) * 5
				end
			end
			
			player:getData().awaitingContact = target
			player:getData().awaitingContactTimer = 30
			player:getData().xAccel = xx * 0.75
			player:set("pVspeed", yy)
		end
		
	elseif skill == 4 and not player:getData().skin_skill4Override then
		-- Dive Drop
		
		playerAc.pHspeed = math.approach(playerAc.pHspeed, 0, 0.025)
		if playerAc.moveRight == 1 then
			playerAc.pHspeed = playerAc.pHmax
		elseif playerAc.moveLeft == 1 then
			playerAc.pHspeed = -playerAc.pHmax
		end
		
		if relevantFrame == 1 then
			player:set("pVspeed", math.min(player:get("pVspeed") -3, -2))
		end
		if relevantFrame == 4 then
			player:getData().awaitingGroundImpact = 300
			--[[if not player:getData()._ogJumpBk then
				player:getData()._ogJumpBk = player:getAnimation("jump")
			end
			player:setAnimation("jump", player:getAnimation("shoot4_2"))]]
		end
		if player.subimage > 4 and player:getData().awaitingGroundImpact then
			player.subimage = 4
		end
	end
end)

Brawler:addCallback("step", function(player)
	local playerData = player:getData()
	
	if playerData.awaitingContact and playerData.awaitingContact:isValid() then
		if player:get("pVspeed") == 0 and not player:getData().xAccel then
			playerData.awaitingContact = nil
		elseif player:collidesWith(playerData.awaitingContact, player.x, player.y) then
			if onScreen(player) then
				misc.shakeScreen(2)
			end
			sfx.RiotGrenade:play(1.2)
			for i = 0, player:get("sp") do
				local bullet = player:fireExplosion(player.x + player.xscale * 10, player.y, 20 / 19, 5 / 4, 2.5)
				bullet:set("stun", 1)
				bullet:getData().pushSide = playerData.xAccel
				bullet:set("knockup", 1)
				playerData.awaitingContact = nil
				if i ~= 0 then
					bullet:set("climb", i * 8)
				end
			end
		end
	end
	if playerData.awaitingGroundImpact then
		if playerData.awaitingGroundImpact > 0 then
			player:set("invincible", math.max(player:get("invincible"), 5))
			playerData.awaitingGroundImpact = playerData.awaitingGroundImpact - 1
		end
		if playerData.midAirDamageTimer then
			if playerData.midAirDamageTimer > 0 then
				playerData.midAirDamageTimer = playerData.midAirDamageTimer - 1
			else
				playerData.midAirDamageTimer = nil
			end
		else
			local r = 25
			for _, actor in ipairs(pobj.actors:findAllRectangle(player.x - r, player.y - r, player.x + r, player.y + r)) do
				if actor:get("team") ~= player:get("team") and player:collidesWith(actor, player.x, player.y) and not actor:collidesMap(actor.x, actor.y + 1) then
					player:fireExplosion(player.x, player.y, 27 / 19, 27 / 4, 1)
					playerData.midAirDamageTimer = 8
				end
			end
		end
		if player:collidesMap(player.x, player.y + 1) then
			local lastVspeed = playerData.lastVerticalSpeed or 0
			if onScreen(player) then
				misc.shakeScreen(3 + lastVspeed)
			end
			
			local mult = lastVspeed * 0.5
			for i = 0, player:get("sp") do
				local bullet = player:fireExplosion(player.x, player.y, 30 / 19, 5 / 4, math.min(1 + mult, 10))
				bullet:set("stun", 1)
				bullet:set("knockup", mult)
				bullet:set("knockback", mult)
				if i ~= 0 then
					bullet:set("climb", i * 8)
				end
			end
			playerData.awaitingGroundImpact = nil
			sfx.RiotGrenade:play(0.9)
			--player:setAnimation("jump", player:getData()._ogJumpBk)
			player.subimage = 5
			player:set("pVspeed", -2)
		end
		playerData.lastVerticalSpeed = player:get("pVspeed")
	end
end)

local onHitCall = function(damager, hit)
	if damager:getData().shakeScreen then
		if onScreen(hit) then
			misc.shakeScreen(damager:getData().shakeScreen)
		end
	end
end

Brawler:addCallback("init", function(player)
	tcallback.register("onHit", onHitCall)
end)

sur.Brawler = Brawler