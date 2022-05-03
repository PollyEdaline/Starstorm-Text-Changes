-- PROSECUTOR

local path = "Survivors/Loader/Skins/Prosecutor/"

local survivor = sur.Loader
local sprSelect = Sprite.load("ProsecutorSelect", path.."Select", 16, 2, 0)
local Prosecutor = SurvivorVariant.new(survivor, "Prosecutor", sprSelect, {
	idle = Sprite.load("ProsecutorIdle", path.."Idle", 1, 6, 8),
	walk = Sprite.load("ProsecutorWalk", path.."Walk", 8, 7, 9),
	jump = Sprite.load("ProsecutorJump", path.."Jump", 1, 6, 9),
	climb = Sprite.load("ProsecutorClimb", path.."Climb", 2, 4, 9),
	death = Sprite.load("ProsecutorDeath", path.."Death", 5, 14, 7),
	decoy = Sprite.load("ProsecutorDecoy", path.."Decoy", 1, 9, 18),
	
	travel = Sprite.load("ProsecutorTravel", path.."Travel", 1, 6, 7),
	shoot11 = Sprite.load("ProsecutorShoot1A", path.."Shoot1_1", 5, 11, 13),
	shoot12 = Sprite.load("ProsecutorShoot1B", path.."Shoot1_2", 5, 11, 13),
	shoot13 = Sprite.load("ProsecutorShoot1C", path.."Shoot1_3", 15, 11, 13),
	shoot2 = Sprite.load("ProsecutorShoot2", path.."Shoot2", 16, 9, 8)
}, Color.fromHex(0xB55E47))
Prosecutor.displayName = "Chaser"
SurvivorVariant.setInfoStats(Prosecutor, {{"Strength", 5}, {"Vitality", 6}, {"Toughness", 6}, {"Agility", 10}, {"Difficulty", 4}, {"Coercion", 6}})
SurvivorVariant.setDescription(Prosecutor, "The &y&Chaser&!& specializes in chasing down threats at all costs, with greater agility but &r&high vulnerability when not moving.")

local sprSkill = Sprite.load("ProsecutorSkill", path.."Skill", 1, 0, 0)
local sShoot1 = Sound.load("ProsecutorShoot1", path.."Shoot1")
local sShootOriginal = sfx.JanitorShoot1_2

SurvivorVariant.setLoadoutSkill(Prosecutor, "Accelerated Jolt", "Kick enemies at close range for &y&130% damage&!&, every third attack &y&knocks back enemies for 200%.", sprSkill)

Prosecutor.endingQuote = "..and so they left, pursuing new goals in life."

callback.register("onSkinInit", function(player, skin)
	if skin == Prosecutor then
		player:getData().skin_replacesSound = sShootOriginal
		player:getData().skin_skill1Override = true
		player:getData().vanillaDamageOverride = true
		player:set("walk_speed_coeff", 0.6)
		player:set("pHmax", player:get("pHmax") + 0.8)
		player:set("attack_speed", player:get("attack_speed") + 0.1)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(159, 11.5, 0.043)
		else
			player:survivorSetInitialStats(109, 11.5, 0.013)
		end
		player:setSkill(1,
		"Accelerated Jolt",
		"Kick enemies at close range for 130% damage, every third attack pushes knocks back for 200%.",
		sprSkill, 1, 15)
		player:getData().moving = false
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Prosecutor then
		player:survivorLevelUpStats(-5, 0.1, 0, 1)
	end
end)
survivor:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	if SurvivorVariant.getActive(player) == Prosecutor then
		if skill == 1 then
			if player.sprite ~= Prosecutor.animations.shoot13 and relevantFrame == 3 or player.sprite == Prosecutor.animations.shoot13 and relevantFrame == 8 then
				if not player:getData().skin_onActivity then
					player:getData().skin_stopSound = 1
					if onScreen(player) then
						misc.shakeScreen(6)
					end
					player:getData().skin_onActivity = true
					--sShoot1_2:play(1 + math.random() * 0.2)
					if player.sprite == Prosecutor.animations.shoot13 then
						sShoot1:play(0.6 + math.random() * 0.2)
						if not skinFireHeavenCracker(player) then
							for i = 0, playerAc.sp do
								local bullet = player:fireBullet(player.x - 4 * player.xscale, player.y - 1, player:getFacingDirection(), 40, 2, nil, DAMAGER_BULLET_PIERCE)
								bullet:getData().skin_newDamager = true
								bullet:set("knockback", 10)
								bullet:set("knockback_direction", player.xscale)
								if i ~= 0 then
									bullet:set("climb", i * 8)
								end
							end
						end
					else
						sShoot1:play(1 + math.random() * 0.2)
						if not skinFireHeavenCracker(player) then
							for i = 0, playerAc.sp do
								local bullet = player:fireExplosion(player.x + 10 * player.xscale, player.y, 21 / 19, 5 / 4, 1.3, nil)
								bullet:set("direction", player:getFacingDirection())
								bullet:getData().skin_newDamager = true
								bullet:set("knockback", 1)
								if i ~= 0 then
									bullet:set("climb", i * 8)
								end
							end
						end
					end
				end
			elseif relevantFrame ~= 3 then
				player:getData().skin_onActivity = nil
			end
			if relevantFrame == player.sprite.frames then
				player:getData().skin_stopSound = 0
			end
		end
		
	end
end)
local onPlayerStepCall = function(player)
	if SurvivorVariant.getActive(player) == Prosecutor then
		local playerAc = player:getAccessor()
		if playerAc.pHspeed == 0 and playerAc.pVspeed < 0.5 then
			player:getData().moving = false
		else
			player:getData().moving = true
		end
		if not player:getData().moving and not player:getData().skin_armorchanged then
			playerAc.armor = playerAc.armor - 50
			player:getData().skin_armorchanged = true
		elseif player:getData().moving and player:getData().skin_armorchanged then
			playerAc.armor = playerAc.armor + 50
			player:getData().skin_armorchanged = false
		end
	end
end
callback.register("onSkinInit", function(player, skin)
	if skin == Prosecutor then
		tcallback.register("onPlayerStep", onPlayerStepCall)
	end
end)