if not global.rormlflag.ss_disable_enemies then
	-- NEMESIS COMMANDO
	
	local path = "Survivors/Commando/Skins/Nemesis/"
	
	local survivor = sur.Commando
	local sprSelect = Sprite.load("NemesisCommandoSelect", path.."Select", 18, 2, 0)
	local NemesisCommando = SurvivorVariant.new(survivor, "Nemesis Commando", sprSelect, {
		idle = Sprite.find("NemesisCommandoIdle", "Starstorm"),
		walk = Sprite.find("NemesisCommandoWalk", "Starstorm"),
		jump = Sprite.find("NemesisCommandoJump", "Starstorm"),
		climb = Sprite.find("NemesisCommandoClimb", "Starstorm"),
		death = Sprite.find("NemesisCommandoDeath", "Starstorm"),
		decoy = Sprite.load("NemesisCommandoDecoy", path.."Decoy", 1, 9, 18),
		
		shoot1 = Sprite.find("NemesisCommandoShoot1", "Starstorm"),
		shoot2_1 = Sprite.find("NemesisCommandoShoot2_1", "Starstorm"),
		shoot2_2 = Sprite.find("NemesisCommandoShoot2_2", "Starstorm"),
		shoot3 = Sprite.find("NemesisCommandoShoot3", "Starstorm"),
		shoot4_1 = Sprite.load("NemesisCommandoShoot4A", path.."Shoot4A", 15, 19, 7),
		shoot4_2 = Sprite.find("NemesisCommandoShoot4B", "Starstorm"),
		shoot5_1 = Sprite.load("NemesisCommandoShoot5A", path.."Shoot5A", 23, 38, 20),
		shoot5_2 = Sprite.load("NemesisCommandoShoot5B", path.."Shoot5B", 24, 19, 7),
	}, Color.fromHex(0xFC4E45))
	SurvivorVariant.setInfoStats(NemesisCommando, {{"Strength", 7}, {"Vitality", 6}, {"Toughness", 3}, {"Agility", 6}, {"Difficulty", 3}, {"Mercy", 1}})
	SurvivorVariant.setDescription(NemesisCommando, "The &y&Nemesis Commando&!&'s origins are unknown, but something is clear: he is no longer who he once was.")
	
	NemesisCommando.endingQuote = "..and so he left, carrying a new sense of humanity within."
	
	local sprSparks = spr.Sparks9r
	local sprSkills = Sprite.load("NemesisCommandoSkill", path.."Skill", 2, 0, 0)
	local sShoot1 = Sound.find("NemesisCommandoShoot1", "Starstorm")
	local sShoot2 = Sound.find("NemesisCommandoShoot2", "Starstorm")

	SurvivorVariant.setLoadoutSkill(NemesisCommando, "Blade of Cessation", "Cut through close enemies for &y&230% bleeding damage&!&.", sprSkills)
	SurvivorVariant.setLoadoutSkill(NemesisCommando, "Distant Gash", "Slash forward in a line for &y&180% bleeding damage&!&.", sprSkills, 2)
	
	callback.register("onSkinInit", function(player, skin)
		if skin == NemesisCommando then
			player:set("pHmax", player:get("pHmax") + 0.1)
			if Difficulty.getActive() == dif.Drizzle then
				player:survivorSetInitialStats(165, 11, 0.041)
			else
				player:survivorSetInitialStats(115, 11, 0.011)
			end
			player:setSkill(1,
			"Blade of Cessation",
			"Cut through close enemies for 230% bleeding damage.",
			sprSkills, 1, 39)
			player:setSkill(2,
			"Distant Gash",
			"Slash forward in a line for 180% bleeding damage.",
			sprSkills, 2, 3 * 60)
		end
	end)
	survivor:addCallback("levelUp", function(player)
		if SurvivorVariant.getActive(player) == NemesisCommando then
			player:survivorLevelUpStats(4, 0, -0.001, 0)
		end
	end)
	SurvivorVariant.setSkill(NemesisCommando, 1, function(player)
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1"), 0.2, true, true)
	end)
	SurvivorVariant.setSkill(NemesisCommando, 2, function(player)
		SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2_1"), 0.2, true, true)
	end)
	callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
		if variant == NemesisCommando then
			local playerAc = player:getAccessor()
			if skill == 1 then
				if relevantFrame == 1 then
					sShoot1:play(1 + math.random() * 0.2)
					if not player:survivorFireHeavenCracker(2.3) then
						for i = 0, playerAc.sp do
							local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 25, 2.3, nil, DAMAGER_BULLET_PIERCE)
							bullet:getData().skin_spark = sprSparks
							bullet:set("bleed", bullet:get("bleed") + 0.2)
							if i ~= 0 then
								bullet:set("climb", i * 8)
							end
						end
					end
				end
			elseif skill == 2 then
				if relevantFrame == 1 then
					sShoot2:play(0.9 + math.random() * 0.2)
					local slash = obj.NemesisSlash:create(player.x + player.xscale * 3, player.y + 6)
					slash:getData().direction = player.xscale
					slash:getData().parent = player
					slash:getData().team = player:get("team")
				end
			end
		end
	end)
end