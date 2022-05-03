if not global.rormlflag.ss_disable_enemies then
	-- NEMESIS ENGINEER
	
	local path = "Survivors/Engineer/Skins/Nemesis/"
	
	local survivor = sur.Engineer
	local sprSelect = Sprite.load("NemesisEngineerSelect", path.."Select", 4, 2, 0)
	local NemesisEngineer = SurvivorVariant.new(survivor, "Nemesis Engineer", sprSelect, {
	idle = Sprite.load("NemesisEngineerIdle", path.."Idle", 1, 10, 11),
	walk = Sprite.load("NemesisEngineerWalk", path.."Walk", 8, 20, 28),
	jump = Sprite.load("NemesisEngineerJump", path.."Jump", 1, 9, 8),
	climb = Sprite.load("NemesisEngineerClimb", path.."Climb", 2, 11, 8),
	death = Sprite.load("NemesisEngineerDeath", path.."Death", 11, 16, 18),
	decoy = Sprite.load("NemesisEngineerDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1 = Sprite.load("NemesisEngineerShoot1", path.."Shoot1", 4, 29, 45),
	shoot3 = Sprite.load("NemesisEngineerShoot3", path.."Shoot3", 21, 10, 17),
	}, Color.fromHex(0xFC4E45))
	SurvivorVariant.setInfoStats(NemesisEngineer, {{"Strength", 7}, {"Vitality", 6}, {"Toughness", 3}, {"Agility", 6}, {"Difficulty", 3}, {"Mercy", 1}})
	SurvivorVariant.setDescription(NemesisEngineer, ".")
	
	NemesisEngineer.endingQuote = "..and so he left, followed by his machines."
	
	local sprSparks = spr.Sparks9r
	local sprSkills = Sprite.load("NemesisEngineerSkill", path.."Skills", 2, 0, 0)
	local sShoot1 = Sound.find("NemesisEngineerShoot1", "Starstorm")
	local sShoot2 = Sound.find("NemesisEngineerShoot2", "Starstorm")

	SurvivorVariant.setLoadoutSkill(NemesisEngineer, "", "", sprSkills)
	SurvivorVariant.setLoadoutSkill(NemesisEngineer, "", "", sprSkills, 2)
	
	callback.register("onSkinInit", function(player, skin)
		if skin == NemesisEngineer then
			player:set("pHmax", player:get("pHmax") + 0.1)
			if Difficulty.getActive() == dif.Drizzle then
				player:survivorSetInitialStats(165, 11, 0.041)
			else
				player:survivorSetInitialStats(115, 11, 0.011)
			end
			player:setSkill(1,
			"",
			"",
			sprSkills, 1, 39)
			player:setSkill(2,
			"",
			"",
			sprSkills, 2, 3 * 60)
		end
	end)
	survivor:addCallback("levelUp", function(player)
		if SurvivorVariant.getActive(player) == NemesisEngineer then
			player:survivorLevelUpStats(4, 0, -0.001, 0)
		end
	end)
	SurvivorVariant.setSkill(NemesisEngineer, 1, function(player)
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1"), 0.2, true, true)
	end)
	SurvivorVariant.setSkill(NemesisEngineer, 2, function(player)
		SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2_1"), 0.2, true, true)
	end)
	survivor:addCallback("onSkill", function(player, skill, relevantFrame)
		local playerAc = player:getAccessor()
		if SurvivorVariant.getActive(player) == NemesisEngineer then
			if skill == 1.01 then
				if relevantFrame == 1 and not player:getData().skin_onActivity then
					player:getData().skin_onActivity = true
					sShoot1:play(1 + math.random() * 0.2)
					if not player:survivorFireHeavenCracker(2.2) then
						for i = 0, playerAc.sp do
							local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 25, 2.3, nil, DAMAGER_BULLET_PIERCE)
							bullet:getData().skin_spark = sprSparks
							bullet:set("bleed", bullet:get("bleed") + 0.2)
							if i ~= 0 then
								bullet:set("climb", i * 8)
							end
						end
					end
				elseif relevantFrame ~= 1 then
					player:getData().skin_onActivity = nil
				end
			elseif skill == 2.01 then
				if relevantFrame == 1 and not player:getData().skin_onActivity then
					player:getData().skin_onActivity = true
					sShoot2:play(0.9 + math.random() * 0.2)
					local slash = obj.NemesisSlash:create(player.x + player.xscale * 3, player.y + 6)
					slash:getData().direction = player.xscale
					slash:getData().parent = player
				elseif relevantFrame ~= 1 then
					player:getData().skin_onActivity = nil
				end
			end
		end
	end)
end