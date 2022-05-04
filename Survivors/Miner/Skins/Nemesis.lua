-- NEMESIS MINER

local path = "Survivors/Miner/Skins/Nemesis/"

local survivor = sur.Miner
local sprSelect = Sprite.load("NemesisMinerSelect", path.."Select", 25, 2, 0)
local sprIdle = Sprite.find("NemesisMinerIdle", "Starstorm")
local sprWalk = Sprite.find("NemesisMinerWalk", "Starstorm")
local sprJump = Sprite.find("NemesisMinerJump", "Starstorm")
local sprIdleHalf = Sprite.load("NemesisMinerIdle2", path.."IdleBottom", 1, 6, 5)
local sprWalkHalf = Sprite.load("NemesisMinerWalk2", path.."WalkBottom", 8, 8, 5)
local NemesisMiner = SurvivorVariant.new(survivor, "Nemesis Miner", sprSelect, {
	idle = sprIdle,
	walk = sprWalk,
	jump = sprJump,
	idleHalf = sprIdleHalf,
	walkHalf = sprWalkHalf,
	jumpHalf = sprIdleHalf,
	climb = Sprite.find("NemesisMinerClimb", "Starstorm"),
	death = Sprite.find("NemesisMinerDeath", "Starstorm"),
	decoy = Sprite.load("NemesisMinerDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1 = Sprite.load("NemesisMinerShoot1", path.."Shoot1", 3, 6, 5),
	shoot2 = Sprite.find("NemesisMinerShoot2", "Starstorm"),
	shoot3 = Sprite.find("NemesisMinerShoot3", "Starstorm"),
	shoot4 = Sprite.find("NemesisMinerShoot4", "Starstorm")
}, Color.fromHex(0x9F37FF))
SurvivorVariant.setInfoStats(NemesisMiner, {{"Strength", 8}, {"Vitality", 6}, {"Toughness", 4}, {"Agility", 9}, {"Difficulty", 4}, {"Rush", 8}})
SurvivorVariant.setDescription(NemesisMiner, "The &y&Nemesis Miner&!& is a heavy duty underground excavation expert, fully equipped with hand-drills to go through even the hardest rocks.")

local sprSkills = Sprite.load("NemesisMinerSkills", path.."Skills", 4, 0, 0)
local sShoot1 = Sound.find("NemesisMinerShoot1", "Starstorm")
local sShoot3 = Sound.find("NemesisMinerShoot3", "Starstorm")
local sShoot4_1 = Sound.find("NemesisMinerShoot4_1", "Starstorm")
local sShoot4_2 = Sound.find("NemesisMinerShoot4_2", "Starstorm")

SurvivorVariant.setLoadoutSkill(NemesisMiner, "Dig", "Attack forward for &y&60% damage&!&. Drill faster at higher speeds. Can move while attacking.", sprSkills)
SurvivorVariant.setLoadoutSkill(NemesisMiner, "Hyper-Drill", "Transform into a full sized drill, dealing &y&18x40% damage around you.", sprSkills, 2)
SurvivorVariant.setLoadoutSkill(NemesisMiner, "To The Core", "Dive into the ground, creating a shockwave in both directions which deals &y&250% damage each.", sprSkills, 3)

NemesisMiner.endingQuote = "..and so he left, resting for once."

callback.register("onSkinInit", function(player, skin)
	if skin == NemesisMiner then
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(160, 12, 0.06)
		else
			player:survivorSetInitialStats(110, 12, 0.03)
		end
		player:setSkill(1,
		"Dig",
		"Attack forward for 60% damage. Drill faster at higher speeds. Can move while attacking.",
		sprSkills, 1, 20)
		player:setSkill(3,
		"Hyper-Drill",
		"Transform into a full sized drill, dealing 18x40% damage around you.",
		sprSkills, 2, 6 * 60)
		player:setSkill(4,
		"To The Core",
		"Dive into the ground, creating a shockwave in both directions which deal 250% damage each.",
		sprSkills, 3, 6 * 60)
		player:getData().drillDirection = 0
		player:getData().drillTimer = 1
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == NemesisMiner then
		player:survivorLevelUpStats(0, 0.25, 0.001, 0)
		player:set("attack_speed", player:get("attack_speed") - 0.025)
	end
end)
survivor:addCallback("scepter", function(player)
	if SurvivorVariant.getActive(player) == NemesisMiner then
		player:setSkill(4,
		"Corebound",
		"Dive into the ground, creating two shockwaves in both directions which deal 250% damage each.",
		sprSkills, 4, 6 * 60)
	end
end)


local objNemMinerShockwave = Object.find("NemMinerShockwave", "Starstorm")

SurvivorVariant.setSkill(NemesisMiner, 1, function(player)
	player:set("activity", 1.01)
	player:set("activity_type", 0)
	player.sprite = player:getAnimation("idle")
	if net.online and player ~= net.localPlayer then
		player:set("z_skill", 1)
	end
	--SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1"), 0.2, true, false)
end)
SurvivorVariant.setSkill(NemesisMiner, 3, function(player)
	player:getData().drillEff = nil
	SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3"), 0.2, false, true)
end)
SurvivorVariant.setSkill(NemesisMiner, 4, function(player)
	SurvivorVariant.activityState(player, 4, player:getAnimation("shoot4"), 0.2, true, true)
	player:set("pVspeed", -2)
	sShoot4_1:play(0.9 + math.random() * 0.2)
end)
callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
	if variant == NemesisMiner then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		if skill == 1 then
			--[[if relevantFrame == 1 then
				if not player:survivorFireHeavenCracker(1.8) then
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x + (-3 * player.xscale), player.y, player:getFacingDirection(), 45, 1.8, nil, DAMAGER_BULLET_PIERCE)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			end]]
		elseif skill == 3 then
			if global.quality > 1 then
				par.Smoke:burst("middle", player.x, player.y, 1)
			end
			if playerAc.invincible < 2 then
				playerAc.invincible = 2
			end
			
			if not playerData.drillEff then
				sShoot3:play(0.9 + math.random() * 0.2, 0.8)
				playerData.drillDirection = player:getFacingDirection()
				playerData.drillLastXscale = player.xscale
				player.xscale = math.abs(player.xscale)
				playerAc.pHspeed = 0
				playerData.drillEff = true
			end
			if relevantFrame > 1 then
				local damager = player:fireExplosion(player.x, player.y, 11 / 19, 11 / 4, 0.4, nil, nil)
				damager:set("knockback", 3)
			end
			
			if playerAc.moveRight == 1 then
				if playerData.drillDirection < 0 or playerData.drillDirection >= 90 or not player:collidesMap(player.x, player.y + 2) then
					playerData.drillDirection = playerData.drillDirection + math.min(3 + 2 * playerAc.pHmax, 9)
				end
			elseif playerAc.moveLeft == 1 then
				if playerData.drillDirection > 180 or playerData.drillDirection <= 90 or not player:collidesMap(player.x, player.y + 2) then
					playerData.drillDirection = playerData.drillDirection - math.min(3 + 2 * playerAc.pHmax, 9)
				end
			end
			if global.quality > 1 then
				if playerData.drillDirection > 45 and playerData.drillDirection < 135 and player:collidesMap(player.x, player.y + 1) then
					par.Debris:burst("above", player.x, player.y + 6, 1)
				elseif playerData.drillDirection > - 45 and playerData.drillDirection < 45 and player:collidesMap(player.x + 1, player.y) then
					par.Debris:burst("above", player.x + 4, player.y, 1)
				elseif playerData.drillDirection > 135 and playerData.drillDirection < 225 and player:collidesMap(player.x - 1, player.y) then
					par.Debris:burst("above", player.x - 4, player.y, 1)
				end
			end
			
			player.angle = playerData.drillDirection * -1 
			
			local dir = math.rad(playerData.drillDirection)
			local speed = playerAc.pHmax + 0.4
			local xx = math.cos(dir) * speed
			local yy = math.sin(dir) * speed
			if playerData.drillDirection == 180 then yy = 0 end -- damn you game i dont know why i have been forced to do this maybe im just dumb
			
			for i = 0, math.abs(xx * 10) do
				local newx = player.x + math.sign(xx) * 0.1
				if player:collidesMap(newx, player.y) then
					break
				else
					player.x = newx
				end
			end
			for i = 0, math.abs(yy * 10) do
				local newy = player.y + math.sign(yy) * 0.1
				if player:collidesMap(player.x, yy) then
					break
				else
					player.y = newy
					playerAc.ghost_y = newy
				end
			end
			
			playerAc.pVspeed = playerAc.pGravity1 * -1
			
			if player.subimage >= player.sprite.frames - 0.25 then
				player.angle = 0
				player.xscale = player.xscale * math.sign(playerData.drillLastXscale)
			end
		elseif skill == 4 then
			if playerAc.invincible < 3 then
				playerAc.invincible = 3
			end
			if relevantFrame == 4 then
				sShoot4_2:play(0.9 + math.random() * 0.2)
				local yy = 0
				for i = 1, 100 do
					if player:collidesMap(player.x, player.y + i * 8) then
						player.y = player.y + ((i - 1) * 8)
						yy = yy + ((i - 1) * 8)
						break
					end
				end
				for i = 1, 16 do
					if player:collidesMap(player.x, player.y + i) then
						player.y = player.y + (i - 1)
						yy = yy + (i - 1)
						break
					end
				end
				if global.quality > 1 then
					for i = 1, yy do
						par.Smoke:burst("middle", player.x, player.y - i, 1)
					end
				end
				
				local shockwave = objNemMinerShockwave:create(player.x, player.y - 5)
				shockwave:getData().parent = player
				shockwave:getData().dir = 1
				shockwave:getData().damage = playerAc.damage * 2.5
				local shockwave = objNemMinerShockwave:create(player.x, player.y - 5)
				shockwave:getData().parent = player
				shockwave:getData().dir = -1
				shockwave:getData().damage = playerAc.damage * 2.5
				
			elseif relevantFrame == 7 and playerAc.scepter > 0 then
				local scepter = playerAc.scepter
				local shockwave = objNemMinerShockwave:create(player.x, player.y - 5)
				shockwave:getData().parent = player
				shockwave:getData().dir = 1
				shockwave:getData().damage = playerAc.damage * 2.5 * scepter
				local shockwave = objNemMinerShockwave:create(player.x, player.y - 5)
				shockwave:getData().parent = player
				shockwave:getData().dir = -1
				shockwave:getData().damage = playerAc.damage * 2.5 * scepter
			end
		end
	end
end)

sur.Miner:addCallback("step", function(player)
	if SurvivorVariant.getActive(player) == NemesisMiner then
		local playerAc = player:getAccessor()
		if syncControlRelease(player, "ability1") then
			playerAc.z_skill = 0
		end
		if playerAc.z_skill == 1 and playerAc.activity == 1.01 then
			local speed = math.max(math.abs(playerAc.pHspeed), 0.85)
			player:getData().drillTimer = player:getData().drillTimer + (speed * 0.2) * playerAc.attack_speed
			if player:getData().drillTimer >= 4 then
				player:getData().drillTimer = 1
				if not player:survivorFireHeavenCracker(1.8) then
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x + 5 * player.xscale * -1, player.y, player:getFacingDirection(), 25, 0.6, nil, DAMAGER_BULLET_PIERCE)
						bullet:set("knockback", speed * 1.25)
						bullet:set("knockback_direction", player.xscale)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
				if onScreen(player) then
					sShoot1:play(0.9 + math.random() * 0.1, 0.3)
				end
			end
			if not player:getData().animChange then
				player:setAnimation("walk", player:getAnimation("walkHalf"))
				player:setAnimation("idle", player:getAnimation("idleHalf"))
				player:setAnimation("jump", player:getAnimation("jumpHalf"))
				player:getData().animChange = true
			end
		else
			if playerAc.z_skill == 0 and playerAc.activity == 1.01 then
				playerAc.activity = 0
			end
			if player:getData().animChange then
				player:setAnimation("walk", sprWalk)
				player:setAnimation("idle", sprIdle)
				player:setAnimation("jump", sprJump)
				player:getData().animChange = nil
			end
		end
	end
end)

sur.Miner:addCallback("draw", function(player)
	if SurvivorVariant.getActive(player) == NemesisMiner then
		local playerAc = player:getAccessor()
		if playerAc.z_skill == 1 and playerAc.activity == 1.01 then
			graphics.drawImage{
				image = player:getAnimation("shoot1"),
				x = player.x,
				y = player.y,
				subimage = player:getData().drillTimer,
				xscale = player.xscale
			}
		end
	end
end)