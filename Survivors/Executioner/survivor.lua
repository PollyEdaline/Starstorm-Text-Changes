
-- All Executioner data

local path = "Survivors/Executioner/"

local executioner = Survivor.new("Executioner")

-- Sounds
local sExecutionerShoot1 = Sound.load("ExecutionerShoot1", path.."skill1")
local sExecutionerShoot2 = Sound.load("ExecutionerShoot2", path.."skill2")
local sExecutionerSkill3 = Sound.load("ExecutionerSkill3", path.."skill3")
local sExecutionerSkill4A = Sound.load("ExecutionerSkill4A", path.."skill4a")
local sExecutionerSkill4B = Sound.load("ExecutionerSkill4B", path.."skill4b")

-- Table sprites
local sprites = {
	idle = Sprite.load("Executioner_Idle", path.."idle", 1, 4, 6),
	walk = Sprite.load("Executioner_Walk", path.."walk", 8, 5, 7),
	jump = Sprite.load("Executioner_Jump", path.."jump", 1, 4, 6),
	climb = Sprite.load("Executioner_Climb", path.."climb", 2, 4, 7),
	death = Sprite.load("Executioner_Death", path.."death", 5, 7, 3),
	decoy = Sprite.load("Executioner_Decoy", path.."decoy", 1, 9, 10),
	
	shoot1 = Sprite.load("Executioner_Shoot1", path.."shoot1", 4, 9, 10),
	shoot2 = Sprite.load("Executioner_Shoot2", path.."shoot2", 22, 9, 10),
	shoot3 = Sprite.load("Executioner_Shoot3", path.."shoot3", 8, 24, 20),
	shoot4 = Sprite.load("Executioner_Shoot4", path.."shoot4", 14, 17, 34),
	shoot5 = Sprite.load("Executioner_Shoot5", path.."shoot5", 14, 17, 34),
}

-- Hit sprites
local sprExSparks1 = Sprite.load("Executioner_Sparks1", path.."sparks1", 4, 5, 8)
local sprExSparks2 = Sprite.load("Executioner_Sparks2", path.."sparks2", 4, 5, 8)
local sprExSparks3 = Sprite.load("Executioner_Sparks3", path.."sparks3", 5, 6, 11)
-- Skill sprites
local sprSkills = Sprite.load("Executioner_Skills", path.."skills", 9, 0, 0)
local sprSkills2 = Sprite.load("Executioner_Skills_2", path.."skillsCount", 11, 0, 0)
local sprSkills3 = Sprite.load("Executioner_Skills_3", path.."skillsLoadout", 4, 0, 0)

-- Selection sprite
executioner.loadoutSprite = Sprite.load("Executioner_Select", path.."select", 17, 2, 0)

-- Selection description
executioner:setLoadoutInfo(
[[The &y&Executioner&!& is a mobile fighter who specializes in counting heads.
Using Ion projectors, the Executioner fabricates illusions which cause foes to
run away in fear, while also projecting an axe to take out the strongest enemies. 
Make sure to chain kills with &y&Ion burst&!& and &y&Execution&!& to keep the damage pouring.]], sprSkills3)

-- Skill descriptions

executioner:setLoadoutSkill(1, "Pistol",
[[Shoot enemies for &y&90% damage.]])

executioner:setLoadoutSkill(2, "Ion Burst",
[[Fire ionized bullets for &y&300% damage&!& each.
Every slayed enemy &y&adds a bullet.]])

executioner:setLoadoutSkill(3, "Crowd Dispersion",
[[&y&Dash forward&!& and &y&fear nearby enemies&!&.
You &b&cannot be hit&!& while dashing.]])

executioner:setLoadoutSkill(4, "Execution",
[[Launch into the air, and slam down with a projected axe.
&y&Deals less damage the more enemies are hit.
&y&(Max damage of 1500% on single target).]])

-- Color of highlights during selection
executioner.loadoutColor = Color.fromHex(0xB5D6F2)

-- Misc. menus sprite
executioner.idleSprite = sprites.idle

-- Main menu sprite
executioner.titleSprite = sprites.walk

-- Endquote
executioner.endingQuote = "..and so he left, bloodlust unfulfilled."

executioner:addCallback("init", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	playerData._EfColor = Color.fromHex(0xBFD4FF)
	
	playerData.lastBullets = 0
	
	playerAc.ionBullets = 0

	player:setAnimations(sprites)
	
	if Difficulty.getActive() == dif.Drizzle then
		player:survivorSetInitialStats(145, 14, 0.038)
	else
		player:survivorSetInitialStats(95, 14, 0.008)
	end
	
	player:setSkill(1, "Pistol", "Shoot for 90% damage.",
	sprSkills, 1, 5)
		
	player:setSkill(2, "Ion Burst", "Fire all your ion bullets of 300% damage each.",
	sprSkills, 2, 2 * 60)
		
	player:setSkill(3, "Crowd Dispersion", "Dash causing nearby enemies to become afraid.",
	sprSkills, 7, 7 * 60)
		
	player:setSkill(4, "Execution", "Bash an Ion Axe, dealing a maximum of 1500% damage. The more enemies are hit the lesser damage is dealt. Successful executions reduce all cooldowns by one second.",
	sprSkills, 8, 8 * 60)
end)


-- Called when the player levels up
executioner:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(24, 5, 0.0012, 2)
end)

-- Called when the player picks up the Ancient Scepter
executioner:addCallback("scepter", function(player)
	player:setSkill(4,
		"Crowd Execution",
		"Bash an Ion Axe fearing close enemies while dealing 1500% damage. Successful executions reduce all cooldowns by one second.",
		sprSkills, 9,
		9 * 60
	)
end)

-- Skills
executioner:addCallback("useSkill", function(player, skill)
	local playerAc = player:getAccessor()
	if player:get("activity") == 0 then
		local cd = true
		
		if skill == 1 then
			-- Z skill
			player:survivorActivityState(1, player:getAnimation("shoot1"), 0.2, true, true)
		elseif skill == 2 then
			-- X skill
			if playerAc.ionBullets > 0 then
				player:survivorActivityState(2, player:getAnimation("shoot2"), 0.33, true, true)
				player:getData()._ionFire = playerAc.ionBullets
			else
				cd = false
			end
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

executioner:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	if skill == 1 then
		-- Pistol
		if relevantFrame == 1 and not player:getData().skin_skill1Override then
			sExecutionerShoot1:play(1 + math.random() * 0.2)
			if player:survivorFireHeavenCracker(1.3) == nil then
				for i = 0, playerAc.sp do
					local bullet = player:fireBullet(player.x, player.y-2, player:getFacingDirection(), 500, 0.9, sprExSparks1)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
		end
		
	elseif skill == 2 and not player:getData().skin_skill2Override then
		-- Ion Burst
		local stbullets = player:getData()._ionFire
		if player.subimage <= 20 then
			if (relevantFrame + 1) % 2 == 0 then
				if stbullets > 0 then
					if global.quality == 3 then
						par.Hologram:burst("middle", player.x + 2 * player.xscale, player.y + math.random(-3, 1), 2, playerData._EfColor)
					end
					if onScreen(player) then
						misc.shakeScreen(1)
					end
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x, player.y - 2, player:getFacingDirection(), 650, 3, sprExSparks2)
						bullet:set("knockback", 3)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
					sExecutionerShoot2:play(0.9 + ((20 - player.subimage) * 0.01) + math.random() * 0.2)
					playerAc.ionBullets = playerAc.ionBullets - 1
					player:getData()._ionFire = player:getData()._ionFire - 1
				else
					player.subimage = 21
				end
			end
		end
		
	elseif skill == 3 and not player:getData().skin_skill3Override then
        -- Crowd Dispersion
		if global.quality == 3 then
			par.Hologram:burst("middle", player.x + math.random(-5,5), player.y + math.random(-20,4), 1, playerData._EfColor)
        end
		if relevantFrame == 8 then
            if playerAc.invincible <= 8 then
                playerAc.invincible = 0
            end
        else
            if playerAc.invincible < 8 then
                playerAc.invincible = 8
            end
			if relevantFrame == 1 then
				sExecutionerSkill3:play(1, 1)
                local bullet = player:fireExplosion(player.x, player.y, 6, 4, 0, nil, nil, DAMAGER_NO_PROC)
                bullet:set("knockback", 1)
				bullet:set("fear", 1)
				playerAc.pHspeed = playerAc.pHmax * 2.2 * player.xscale
            end
        end

	elseif skill == 4 and not player:getData().skin_skill4Override then
		-- Execution
		if relevantFrame < 11 then
			if playerAc.moveRight == 1 and not player:collidesMap(player.x + playerAc.pHmax, player.y) and playerAc.pHspeed < playerAc.pHmax then
				playerAc.pHspeed = math.approach(playerAc.pHspeed, playerAc.pHmax, playerAc.pHmax * 0.1)
			elseif playerAc.moveLeft == 1 and not player:collidesMap(player.x - playerAc.pHmax, player.y) and playerAc.pHspeed > -playerAc.pHmax then
				playerAc.pHspeed = math.approach(playerAc.pHspeed, - playerAc.pHmax, playerAc.pHmax * 0.1)
			end
		else
			playerAc.pHspeed = 0 --math.approach(playerAc.pHspeed, 0, 0.5)
		end
		if global.quality == 3 then
			if playerAc.scepter > 0 then
				par.Hologram:burst("middle", player.x + math.random(-6,20) * player.xscale, player.y + math.random(-20,3), 1, Color.fromHex(0xF39DFF))
			else
				par.Hologram:burst("middle", player.x + math.random(-6,20) * player.xscale, player.y + math.random(-20,3), 1, playerData._EfColor)
			end
		end
		if relevantFrame == 1 then
			playerAc.pVspeed = (playerAc.pVmax * -2) * math.min(playerAc.attack_speed, 8)
			sExecutionerSkill4A:play(0.9 + math.random() * 0.2, 1)
		end
		if relevantFrame == 4 or relevantFrame == 5 or relevantFrame == 6 or relevantFrame == 7 or relevantFrame == 8 or relevantFrame == 9 then
			playerAc.pVspeed = 0
		end
		if playerAc.invincible < 5 then
			playerAc.invincible = 5
		end
		if relevantFrame == 10 then
			local n = 0
			while not player:collidesMap(player.x, player.y + 2) and n < 150 do
				player.y = player.y + 2
				n = n + 1
			end
			player:getData().exHeight = n
			--playerAc.pVspeed = (playerAc.pVmax * 3) * playerAc.attack_speed
			sExecutionerSkill4B:play(1, 1)
		end
		if relevantFrame == 11 then
			if onScreen(player) then
				misc.shakeScreen(8)
			end
			local originx = player.x + 17 * player.xscale
			local yadd = player:getData().exHeight
			local npcs = pobj.enemies:findAllRectangle(originx - 40, player.y - 58 - yadd, originx + 40, player.y + 18)
			local npcCount = math.max(1, #npcs)
			for i = 0, playerAc.sp do
				
				local damage
				if playerAc.scepter > 0 then
					damage = 10 + (5 * playerAc.scepter)
				else
					damage = math.max(15 / npcCount, 1.5)
				end
				local addHalf = yadd
				local bullet = player:fireExplosion(originx, player.y - 10 + 2 - addHalf, 40 / 19, (17 + yadd + 10) / 4, damage, nil,sprExSparks3)
				bullet:set("knockback", bullet:get("knockback") + 2)
				--bullet:set("bleed", bullet:get("bleed") + 0.08)
				bullet:getData().isExecution = true
				if playerAc.scepter > 0 then
					bullet:set("fear", 1)
				end
				if i ~= 0 then
					bullet:set("climb", i * 8)
				end
			end
		end
	end
end)

executioner:addCallback("step", function(player)
	local playerData = player:getData()
	local bullets = player:get("ionBullets")
	
	if playerData.lastBullets ~= bullets and not playerData.skin_skill2Override then
		if bullets == 0 then
			player:setSkillIcon(2, sprSkills, 2)
		elseif bullets < 4 then
			player:setSkillIcon(2, sprSkills, 3)
		elseif bullets < 7 then
			player:setSkillIcon(2, sprSkills, 4)
		elseif bullets < 10 then
			player:setSkillIcon(2, sprSkills, 5)
		else
			player:setSkillIcon(2, sprSkills, 6)
		end
		
		playerData.lastBullets = bullets
	end
end)

local onPlayerHUDDrawCall = function(player, x, y)
	if player:getSurvivor() == executioner and not player:getData().skin_skill2Override then
		local bullets = player:get("ionBullets")
		
		graphics.drawImage{
			image = sprSkills2,
			subimage = bullets + 1,
			y = y - 11,
			x = x + 18 + 5
		}
	end
end

local onNPCDeathProcCall = function(npc, player)
	if player:getSurvivor() == executioner and player:get("ionBullets") < 10 then
		if not npc:get("team") or npc:get("team") ~= player:get("team") then
			player:set("ionBullets", player:get("ionBullets") + 1)
		end
	end
end

local preHitCall = function(damager, hit)
	if damager:getData().isExecution then
		if hit:get("hp") <= damager:get("damage") then
			
			local parent = damager:getParent()
			parent:setAlarm(3, math.max(parent:getAlarm(3) - 60, 1))
			parent:setAlarm(4, math.max(parent:getAlarm(4) - 60, 1))
			parent:setAlarm(5, math.max(parent:getAlarm(5) - 60, 1))
		end
	end
end

executioner:addCallback("init", function(player)
	tcallback.register("onPlayerHUDDraw", onPlayerHUDDrawCall)
	tcallback.register("onNPCDeathProc", onNPCDeathProcCall)
	tcallback.register("preHit", preHitCall)
end)

sur.Executioner = executioner