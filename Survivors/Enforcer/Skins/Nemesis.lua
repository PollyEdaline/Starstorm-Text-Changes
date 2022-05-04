if not global.rormlflag.ss_disable_enemies then
-- NEMESIS ENFORCER

local path = "Survivors/Enforcer/Skins/Nemesis/"

local animations = {
	idle_1 = Sprite.find("NemesisEnforcerIdleA", "Starstorm"),
	idle_2 = Sprite.find("NemesisEnforcerIdleB", "Starstorm"),
	walk = Sprite.find("NemesisEnforcerWalkA", "Starstorm"),
	walk_1 = Sprite.find("NemesisEnforcerWalkA", "Starstorm"),
	walk_2 = Sprite.find("NemesisEnforcerWalkB", "Starstorm"),
	jump_1 = Sprite.find("NemesisEnforcerJumpA", "Starstorm"),
	jump_2 = Sprite.find("NemesisEnforcerJumpB", "Starstorm"),
	climb = Sprite.find("NemesisEnforcerClimb", "Starstorm"),
	death = Sprite.find("NemesisEnforcerDeath", "Starstorm"),
	decoy = Sprite.load("NemesisEnforcerDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.find("NemesisEnforcerShoot1A", "Starstorm"),
	shoot1_2 = Sprite.find("NemesisEnforcerShoot1B", "Starstorm"),
	shoot2 = Sprite.find("NemesisEnforcerShoot2", "Starstorm"),
	shoot3_1 = Sprite.find("NemesisEnforcerShoot3A", "Starstorm"),
	shoot3_2 = Sprite.find("NemesisEnforcerShoot3B", "Starstorm"),
}

	-- NEMESIS ENFORCER
	local survivor = sur.Enforcer
	local sprSelect = Sprite.load("NemesisEnforcerSelect", path.."Select", 13, 2, 0)
	local NemesisEnforcer = SurvivorVariant.new(survivor, "Nemesis Enforcer", sprSelect, animations, Color.fromHex(0xCECE5F))
	SurvivorVariant.setInfoStats(NemesisEnforcer, {{"Strength", 8}, {"Vitality", 6}, {"Toughness", 5}, {"Agility", 2}, {"Difficulty", 4.5}, {"Grace", 8}})
	SurvivorVariant.setDescription(NemesisEnforcer, "The &y&Nemesis Enforcer&!& is an incarnation of valiance and strength, a supernatural being who is not to be taken lightly.")

	local sprSparks = spr.Sparks9r
	local sprSkill = Sprite.load("NemesisEnforcerSkill", path.."Skill", 4, 0, 0)
	local sprBullet = Sprite.find("NemesisEnforcerBullet", "Starstorm")
	local sShoot = sfx.Bullet3
	local sShootOriginal = sfx.RiotShoot1

	SurvivorVariant.setLoadoutSkill(NemesisEnforcer, "Golden Hammer", "Bash enemies for &y&500% damage.", sprSkill)
	SurvivorVariant.setLoadoutSkill(NemesisEnforcer, "Golden Minigun", "Fire your minigun for &y&150% damage per second.", sprSkill, 2)
	SurvivorVariant.setLoadoutSkill(NemesisEnforcer, "Dominance", "Slam the Golden Hammer against the ground, &y&knocking enemies back for 210% damage.", sprSkill, 4)
	SurvivorVariant.setLoadoutSkill(NemesisEnforcer, "Destruction / Supression Stance", "&b&Switch your current weapon.", sprSkill, 3)
	
	NemesisEnforcer.endingQuote = "..and so he left, with newfound might to honor."
	
	callback.register("onSkinInit", function(player, skin)
		if skin == NemesisEnforcer then
			player:set("pHmax", player:get("pHmax") - 0.1 - 0.5) -- corrected on first step
			player:set("armor", player:get("armor") + 20)
			
			player:getData().lastMinigunState = false
			
			if Difficulty.getActive() == dif.Drizzle then
				player:survivorSetInitialStats(169, 11.5, 0.0395)
			else
				player:survivorSetInitialStats(119, 11.5, 0.0095)
			end
			player:setSkill(1,
			"Hammer",
			"Bash enemies for 500% damage.",
			sprSkill, 1, 39)
			player:setSkill(2,
			"Dominance",
			"Slam the Golden Hammer against the ground, knocking enemies back for 210% damage.",
			sprSkill, 4, 3 * 60)
			player:setSkill(3,
			"Supression Stance",
			"Switch your weapon.",
			sprSkill, 3, 2 * 60)
		end
	end)
	survivor:addCallback("levelUp", function(player)
		if SurvivorVariant.getActive(player) == NemesisEnforcer then
			player:survivorLevelUpStats(4, 0, -0.001, 0)
		end
	end)
	SurvivorVariant.setSkill(NemesisEnforcer, 1, function(player)
		if player:getData().usingMinigun then
			SurvivorVariant.activityState(player, 1.1, player:getAnimation("shoot1_2"), 1, true, true)
		else
			SurvivorVariant.activityState(player, 1.2, player:getAnimation("shoot1_1"), 0.2, true, true)
		end
	end)
	SurvivorVariant.setSkill(NemesisEnforcer, 3, function(player)
		if player:getData().usingMinigun then
			SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3_1"), 0.2, true, true)
		else
			SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3_2"), 0.2, true, true)
		end
	end)
	survivor:addCallback("onSkill", function(player, skill, relevantFrame)
		local playerAc = player:getAccessor()
		if SurvivorVariant.getActive(player) == NemesisEnforcer then
			if skill == 1.11 then
				if relevantFrame == 1 and not player:getData().skin_onActivity then
					player:getData().skin_onActivity = true
					sShoot:play(1.4)
					if not player:survivorFireHeavenCracker(0.45) then
						for i = 0, playerAc.sp do
							player:getData().skin_onActivity = true
							local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection() + math.random(-1.5, 1.5), 500, 0.45, spr.Sparks1)
							local sparks = obj.EfSparks:create(player.x + (10 * player.xscale), player.y)
							sparks.sprite = sprBullet
							sparks.depth = -9
							sparks.xscale = player.xscale
							bullet:getData().skin_noFakeDamage = true
							bullet:set("knockback_direction", player.xscale)
							if i ~= 0 then
								bullet:set("climb", i * 8)
							end
						end
					end
				else
					player:getData().skin_onActivity = false
				end
			elseif skill == 1.21 then
				if relevantFrame == 1 and not player:getData().skin_onActivity then
					sfx.JanitorShoot1_2:play(1.1, 1)
					player:getData().skin_onActivity = true
					if not player:survivorFireHeavenCracker(1.5) then
						for i = 0, playerAc.sp do
							local bullet = player:fireBullet(player.x + (10 * (player.xscale * -1)) , player.y, player:getFacingDirection(), 50, 5, nil) --DAMAGER_BULLET_PIERCE)
							bullet:getData().skin_spark = sprSparks
							bullet:set("knockback", bullet:get("knockback") + 6)
							bullet:set("knockup", bullet:get("knockup") + 2)
							bullet:set("stun", bullet:get("stun") + 0.5)
							bullet:getData().skin_noFakeDamage = true
							if i ~= 0 then
								bullet:set("climb", i * 8)
							end
						end
					end
				elseif relevantFrame > 1 then
					player:getData().skin_onActivity = nil
				end
			elseif skill == 3.01 then
				if playerAc.free == 0 then
					playerAc.pHspeed = 0
				end
				if relevantFrame == 1 and not player:getData().skin_onActivity then
					--playerAc.pHmax = playerAc.pHmax + 0.7
					if player:getData().usingMinigun then
						--playerAc.attack_speed = playerAc.attack_speed - 5
						
						--playerAc.pHmax = playerAc.pHmax + 0.5
						--playerAc.activity_type = 0
						
						player:getData().usingMinigun = false
						player:setSkill(1,
						"Golden Hammer",
						"Bash enemies for 500% damage.",
						sprSkill, 1, 39)
						player:setSkill(3,
						"Supression Stance",
						"Switch your weapon.",
						sprSkill, 3, 2 * 60)
					else
						--playerAc.attack_speed = playerAc.attack_speed + 5
						--playerAc.pHmax = playerAc.pHmax - 0.5
						--playerAc.activity_type = 4
						
						player:getData().usingMinigun = true
						player:setSkill(1,
						"Golden Minigun",
						"Fire your minigun for 150% damage per second.",
						sprSkill, 2, 0)
						player:setSkill(3,
						"Destruction Stance",
						"Switch your weapon.",
						sprSkill, 3, 2 * 60)
					end
					player:getData().skin_onActivity = true
				elseif relevantFrame == 4 and not player:getData().skin_onActivity then
					if net.online and player == net.localPlayer then
						if net.host then
							syncInstanceData:sendAsHost(net.ALL, nil, player:getNetIdentity(), "usingMinigun", player:getData().usingMinigun)
						else
							syncInstanceData:sendAsClient(player:getNetIdentity(), "usingMinigun", player:getData().usingMinigun)
						end
					end
					player:getData().skin_onActivity = true
				elseif relevantFrame ~= 1 and relevantFrame ~= 4 then
					player:getData().skin_onActivity = false
				end
			end
		end
	end)
	local postPlayerStepCall = function(player)
		local playerAc = player:getAccessor()
		if SurvivorVariant.getActive(player) == NemesisEnforcer then
			--playerAc.bunker = 0
			if player:get("activity") == 0 then
				if player:getData().usingMinigun then
					playerAc.activity_type = 4
				else
					playerAc.activity_type = 0
					playerAc.walk_speed_coeff = 1
				end
			end
		end
	end
	local onPlayerDrawCall = function(player)
		if SurvivorVariant.getActive(player) == NemesisEnforcer then
			if player:getData().usingMinigun then
				player:setAlarm(2, math.max(player:getAlarm(2) - 4 * (0.6 + player:get("attack_speed") * 0.4), -1))
			end
			if player:getData().usingMinigun ~= player:getData().lastMinigunState then
				local playerAc = player:getAccessor()
				if player:getData().usingMinigun then
					player:setAnimation("shoot1", animations.shoot1_2)
					player:setAnimation("shoot3_1", animations.shoot3_1)
					player:setAnimation("shoot3_2", animations.shoot3_2)
					player:setAnimation("idle", animations.idle_2)
					player:setAnimation("walk", animations.walk_2)
					player:setAnimation("jump", animations.jump_2)
					playerAc.pHmax = playerAc.pHmax - 0.5
					playerAc.activity_type = 4
				else
					player:setAnimation("shoot1", animations.shoot1_1)
					player:setAnimation("shoot3_1", animations.shoot3_1)
					player:setAnimation("shoot3_2", animations.shoot3_2)
					player:setAnimation("idle", animations.idle_1)
					player:setAnimation("walk", animations.walk_1)
					player:setAnimation("jump", animations.jump_1)
					playerAc.pHmax = playerAc.pHmax + 0.5
					playerAc.activity_type = 0
				end
				player:getData().lastMinigunState = player:getData().usingMinigun
			end
		end
	end
	callback.register("onSkinInit", function(player, skin)
		if skin == NemesisEnforcer then
			tcallback.register("postPlayerStep", postPlayerStepCall)
			tcallback.register("onPlayerDraw", onPlayerDrawCall)
		end
	end)
end