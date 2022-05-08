-- ASSASSIN

local path = "Survivors/Sniper/Skins/Assassin/"

local survivor = sur.Sniper
local sprSelect = Sprite.load("AssassinSelect", path.."Select", 23, 2, 0)
local Assassin = SurvivorVariant.new(survivor, "Assassin", sprSelect, {
	idle = Sprite.load("AssassinIdle", path.."Idle", 1, 6, 4),
	walk = Sprite.load("AssassinWalk", path.."Walk", 8, 18, 16),
	jump = Sprite.load("AssassinJump", path.."Jump", 1, 3, 5),
	climb = Sprite.load("AssassinClimb", path.."Climb", 2, 5, 6),
	death = Sprite.load("AssassinDeath", path.."Death", 7, 14, 6),
	decoy = Sprite.load("AssassinDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.load("AssassinShoot1A", path.."Shoot1_1", 6, 4, 10),
	shoot1_2 = Sprite.load("AssassinShoot1B", path.."Shoot1_2", 7, 7, 5),
	shoot3_2 = Sprite.load("AssassinShoot2", path.."Shoot2", 6, 66, 42),
	shoot3_1 = Sprite.load("AssassinShoot3", path.."Shoot3", 11, 7, 15),
	
	drone_idle = Sprite.load("AssassinDroneIdle", path.."Drone_Idle", 1, 8, 6),
	drone_shoot = Sprite.load("AssassinDroneShoot", path.."Drone_Shoot", 6, 8, 8),
	drone_warp = Sprite.load("AssassinDroneWarp", path.."Drone_Warp", 17, 7, 6),
	drone_zap = Sprite.load("AssassinDroneZap", path.."Drone_Zap", 2, 8, 6),
	drone_turn = Sprite.load("AssassinDroneTurn", path.."Drone_Turn", 7, 8, 6)
}, Color.fromHex(0xFC7E95))
SurvivorVariant.setInfoStats(Assassin, {{"Strength", 10}, {"Vitality", 4}, {"Toughness", 3}, {"Agility", 5}, {"Difficulty", 5}, {"Psychosis", 6}})
SurvivorVariant.setDescription(Assassin, "The &y&Assassin&!& is a cold-blooded, merciless soldier who often murders for his own entertainment.")

local sprSkill = Sprite.load("AssassinSkill", path.."Skill", 1, 0, 0)
local sprSparks = spr.Sparks10r

local sShoot1_1 = {
	Sound.load("AssassinShoot1_1A", path.."Shoot1_1_1"),
	Sound.load("AssassinShoot1_1B", path.."Shoot1_1_2"),
	Sound.load("AssassinShoot1_1C", path.."Shoot1_1_3")
}
local sShoot1_2 = Sound.load("AssassinShoot1_2", path.."Shoot1_2")

SurvivorVariant.setLoadoutSkill(Assassin, "Stab", "Pierce through enemies at very close range for &y&200% bleeding damage&!&.", sprSkill)

Assassin.endingQuote = "..and so he left, laughing maniacally."

local onPlayerStepCall = function(player)
	if SurvivorVariant.getActive(player) == Assassin then
		if player:get("bullet_ready") == 1 then
			player:setSkill(1,
			"Stab",
			"Pierce through enemies at very close range for 200% bleeding damage.",
			sprSkill, 1, 55)
		end
	end
end

callback.register("onSkinInit", function(player, skin)
	if skin == Assassin then
		player:getData().vanillaDamageOverride = true
		player:getData().skin_replacesSound = sfx.SniperShoot3
		player:getData().skin_skill1Override = true
		player:set("armor", player:get("armor") + 5)
		player:set("pHmax", player:get("pHmax") + 0.05)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(155, 12.5, 0.043)
		else
			player:survivorSetInitialStats(105, 12.5, 0.013)
		end
		player:setSkill(1,
		"Stab",
		"Pierce through enemies at very close range for 200% bleeding damage.",
		sprSkill, 1, 55)
		
		tcallback.register("onPlayerStep", onPlayerStepCall)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Assassin then
		player:survivorLevelUpStats(-3, 0.3, 0, 1)
	end
end)
--[[SurvivorVariant.setSkill(Assassin, 1, function(player)
	if player:get("bullet_ready") == 0 then
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_1"), 0.2, true, true)
	end
end)]]

survivor:addCallback("onSkill", function(player, skill, relevantFrame)
	if SurvivorVariant.getActive(player) == Assassin then
		local playerAc = player:getAccessor()
		if skill == 1.1 then
			player:getData().skill1 = true
			if relevantFrame == 1 and not player:getData().skin_onActivity then
				player:getData().removeBar = true
				table.irandom(sShoot1_1):play(1 + math.random() * 0.2)
				if not skinFireHeavenCracker(player, 0.8) then
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x - 4 * player.xscale, player.y, player:getFacingDirection(), 25, 2, nil, DAMAGER_BULLET_PIERCE)
						bullet:getData().skin_newDamager = true
						bullet:set("bleed", 1)
						bullet:set("damage_degrade", 0.6)
						bullet:getData().impactSound = sShoot1_2
						bullet:getData().skin_spark = sprSparks
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end

				player:getData().skin_stopSound = 1
				player:getData().skin_onActivity = true
			elseif relevantFrame ~= 1 then
				player:getData().skin_onActivity = nil
			end
		end
		if skill == 2.1 then
			player.sprite = Assassin.animations.shoot1_2
			player.subimage = 1
		end
		
	end
end)