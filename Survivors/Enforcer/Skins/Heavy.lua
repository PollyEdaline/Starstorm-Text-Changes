-- HEAVY

local path = "Survivors/Enforcer/Skins/Heavy/"

local survivor = sur.Enforcer
local sprSelect = Sprite.load("HeavySelect", path.."Select", 18, 2, 0)
local Heavy = SurvivorVariant.new(survivor, "Heavy", sprSelect, {
	idle_1 = Sprite.load("HeavyIdleA", path.."Idle_1", 1, 5, 10),
	idle_2 = Sprite.load("HeavyIdleB", path.."Idle_2", 1, 5, 10),
	walk_1 = Sprite.load("HeavyWalkA", path.."Walk_1", 8, 12, 10),
	walk_2 = Sprite.load("HeavyWalkB", path.."Walk_2", 8, 12, 10),
	jump = Sprite.load("HeavyJump", path.."Jump", 1, 5, 8),
	climb = Sprite.load("HeavyClimb", path.."Climb", 2, 5, 9),
	death = Sprite.load("HeavyDeath", path.."Death", 5, 14, 9),
	decoy = Sprite.load("HeavyDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.load("HeavyShoot1A", path.."Shoot1_1", 6, 8, 9),
	shoot1_2 = Sprite.load("HeavyShoot1B", path.."Shoot1_2", 6, 7, 9),
	shoot2_1 = Sprite.load("HeavyShoot2", path.."Shoot2", 9, 7, 10),
	shoot3_1 = Sprite.load("HeavyShoot3A", path.."Shoot3_1", 8, 7, 10),
	shoot3_2 = Sprite.load("HeavyShoot3B", path.."Shoot3_2", 6, 6, 11),
}, Color.fromHex(0x619A73))
SurvivorVariant.setInfoStats(Heavy, {{"Strength", 6}, {"Vitality", 6}, {"Toughness", 6}, {"Agility", 4}, {"Difficulty", 3}, {"Training", 9}})
SurvivorVariant.setDescription(Heavy, "The &y&Heavy&!& is a tactical unit carrying a threatening pump shotgun to keep any situation under control. While initially slower, the Heavy is faster than the Enforcer while shielded.")
--Heavy.forceApply = true

Heavy.endingQuote = "..and so he left, overestimating his rightfulness."

local sprSkill = Sprite.load("HeavySkill", path.."Skill", 1, 0, 0)
local sprOriginalSkill = spr.RiotSkills
local sShoot = sfx.HeavyShoot1
local sprSparks = Sprite.load("HeavyShootSparks", path.."Sparks", 5, 8, 4)

SurvivorVariant.setLoadoutSkill(Heavy, "Pump Shotgun", "Fire 4 bullets at a medium range for &y&280% total damage.", sprSkill)

SurvivorVariant.setLoadoutSkill(Heavy, "Shield Charge", "&b&Dash forward a small distance&!&, smashing enemies in your path for &y&200% damage and knocking them back.", sprOriginalSkill, 2)

SurvivorVariant.setLoadoutSkill(Heavy, "Protect and Serve", "Take a &b&defensive stance, blocking all damage from the front. &y&Increases attack speed, reducing movement minimally.", sprOriginalSkill, 3)

callback.register("onSkinInit", function(player, skin)
	if skin == Heavy then
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(164, 12, 0.045)
		else
			player:survivorSetInitialStats(114, 12, 0.015)
		end
		player:set("pHmax", player:get("pHmax") - 0.2)
		player:setSkill(1,
		"Pump Shotgun",
		"Fire 4 bullets at a medium range for 280% total damage.",
		sprSkill, 1, 32)
		player:setSkill(2,
		"Shield Charge",
		"Dash forward, smashing enemies for 200% damage and knocking them back.",
		sprOriginalSkill, 2, 5 * 60)
		player:setSkill(3,
		"Protect and Serve",
		"Take a defensive stance, blocking all damage from the front. Increases attack speed, reducing movement minimally.",
		sprOriginalSkill, 3, 5 * 60)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Heavy then
		player:survivorLevelUpStats(-2, 0, -0.001, 1)
	end
end)
local onPlayerDrawCall = function(player)
	if SurvivorVariant.getActive(player) == Heavy then
		if player:get("bunker") == 0 then
			player:setAnimation("idle", Heavy.animations.idle_1)
		else
			player:setAnimation("idle", Heavy.animations.idle_2)
			player:set("walk_speed_coeff", 1)
		end
	end
end
SurvivorVariant.setSkill(Heavy, 1, function(player)
	if player:get("bunker") == 0 then
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_1"), 0.2, true, true)
	else
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_2"), 0.2, true, true)
	end
end)
SurvivorVariant.setSkill(Heavy, 2, function(player)
	SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2_1"), 0.2, true, true)
end)
survivor:addCallback("onSkill", function(player, skill, relevantFrame)
	if SurvivorVariant.getActive(player) == Heavy then
		local playerAc = player:getAccessor()
		if skill == 1.01 then
			if relevantFrame == 1 and not player:getData().skin_onActivity then
				player:getData().skin_onActivity = true
				sShoot:play(1, 0.6)
				if not player:survivorFireHeavenCracker(2) then
					for i = 0, playerAc.sp + 3 do
						local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection() + math.random(-12, 12), 220, 0.7, sprSparks, DAMAGER_BULLET_PIERCE)
						bullet:set("damage_degrade", 0.2)
						bullet:getData().skin_noFakeDamage = true
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			elseif relevantFrame > 1 then
				player:getData().skin_onActivity = nil
			end
			
		elseif skill == 2.01 then
			if relevantFrame == 2 and not player:getData().skin_onActivity then
				player:getData().skin_onActivity = true
				sfx.JanitorShoot1_2:play(1, 1)
				--player:set("pHspeed", player.xscale * 3)
				player:getData().xAccel = 2 * player.xscale
				for i = 0, playerAc.sp do
					local bullet = player:fireBullet(player.x + player.xscale * -5, player.y, player:getFacingDirection(), 50, 2, spr.Sparks5, DAMAGER_BULLET_PIERCE)
					bullet:set("knockback", 4)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			elseif relevantFrame ~= 2 then
				player:getData().skin_onActivity = nil
			end
			
		elseif skill == 3.1 then
			if relevantFrame == 6 and not player:getData().skin_onActivity then
				player:getData().skin_onActivity = true

				playerAc.pHmax = playerAc.pHmax + 0.45
				
			elseif relevantFrame ~= 6 then
				player:getData().skin_onActivity = nil
			end
			
		elseif skill == 3.2 then
			if relevantFrame == 4 and not player:getData().skin_onActivity then
				player:getData().skin_onActivity = true
				
				playerAc.pHmax = playerAc.pHmax - 0.45
				
			elseif relevantFrame ~= 4 then
				player:getData().skin_onActivity = nil
			end
			
		end
	end
end)

local onPlayerStepCall = function(player)
	if SurvivorVariant.getActive(player) == Heavy then
		local playerData = player:getData()
		if player:get("bunker") == 0 then
			player:setAnimation("walk", Heavy.animations.walk_1)
			player:setAnimation("shoot1", Heavy.animations.shoot1_1)
			playerData.lastXscaleFix = nil
		else
			if playerData.lastXscaleFix then
				if playerData.lastXscaleFix ~= player.xscale then
					player.xscale = playerData.lastXscaleFix
				end
			else
				playerData.lastXscaleFix = player.xscale
			end
			player:setAnimation("walk", Heavy.animations.walk_2)
			player:setAnimation("shoot1", Heavy.animations.shoot1_2)
			if player:get("activity") == 0 then
				player:set("activity_type", 4)
			end
		end
		player:setAnimation("shoot2", Heavy.animations.shoot2_1)
	end
end

callback.register("onSkinInit", function(player, skin)
	if skin == Heavy then
		tcallback.register("onPlayerDraw", onPlayerDrawCall)
		tcallback.register("onPlayerStep", onPlayerStepCall)
	end
end)