
if not global.rormlflag.ss_disable_enemies then
	-- NEMESIS MERCENARY
	
	local path = "Survivors/Mercenary/Skins/Nemesis/"
	
	
	local survivor = sur.Mercenary
	local sprSelect = Sprite.load("NemesisMercenarySelect", path.."Select", 19, 2, 0)
	local NemesisMercenary = SurvivorVariant.new(survivor, "Nemesis Mercenary", sprSelect, {
		idle = Sprite.find("NemesisMercenaryIdle", "Starstorm"),
		idle_2 = Sprite.find("NemesisMercenaryIdle_2", "Starstorm"),
		walk = Sprite.find("NemesisMercenaryWalk", "Starstorm"),
		jump = Sprite.find("NemesisMercenaryJump", "Starstorm"),
		climb = Sprite.find("NemesisMercenaryClimb", "Starstorm"),
		death = Sprite.find("NemesisMercenaryDeath", "Starstorm"),
		decoy = Sprite.load("NemesisMercenaryDecoy", path.."Decoy", 1, 9, 18),
		
		shoot1_1 = Sprite.find("NemesisMercenaryShoot1_1", "Starstorm"),
		shoot1_2 = Sprite.find("NemesisMercenaryShoot1_2", "Starstorm"),
		shoot2_1 = Sprite.find("NemesisMercenaryShoot2_1", "Starstorm"),
		shoot2_2 = Sprite.find("NemesisMercenaryShoot2_2", "Starstorm"),
		shoot4 = Sprite.find("NemesisMercenaryShoot4", "Starstorm"),
		shoot5 = Sprite.load("NemesisMercenaryShoot5", path.."Shoot5", 18, 30, 16),
		shoot3 = Sprite.find("NemesisMercenaryShoot3", "Starstorm"),
	}, Color.fromHex(0xFC4E45))
	SurvivorVariant.setInfoStats(NemesisMercenary, {{"Strength", 7}, {"Vitality", 6}, {"Toughness", 3}, {"Agility", 6}, {"Difficulty", 3}, {"Mercy", 1}})
	SurvivorVariant.setDescription(NemesisMercenary, "&y&Nemesis Mercenary&!& is an agile hunter who acts without any trace of honor, holding a powerful shotgun and a sword stolen from an unnamed warrior.")
	
	NemesisMercenary.endingQuote = "..and so he left, loaded up for more."
	
	local sprSkills = Sprite.load("NemesisMercenarySkills", path.."Skills", 7, 0, 0)
	local sShoot2_1 = Sound.find("NemesisMercenaryShoot2_1", "Starstorm")
	local sShoot2_2 = Sound.find("NemesisMercenaryShoot2_2", "Starstorm")
	local sShoot4 = Sound.find("NemesisMercenaryShoot4", "Starstorm")
	local sprSparks = Sprite.find("NemesisMercenarySlash", "Starstorm")
	local sprSparks2 = Sprite.load("NemesisMercenarySlash2", path.."Slash2", 5, 26, 25)

	SurvivorVariant.setLoadoutSkill(NemesisMercenary, "Quick Trigger", "Fire a shotgun forward dealing &y&500% damage&!&.", sprSkills, 2)
	SurvivorVariant.setLoadoutSkill(NemesisMercenary, "Blinding Slide", "Quickly slide forwards. &b&You can attack while sliding&!&.", sprSkills, 3)
	SurvivorVariant.setLoadoutSkill(NemesisMercenary, "Devitalize", "Target the nearest enemy, attacking them for &y&850% damage&!&. &b&You &b&cannot be hit for the duration&!&.", sprSkills, 5)
	
	callback.register("onSkinInit", function(player, skin)
		if skin == NemesisMercenary then
			if Difficulty.getActive() == dif.Drizzle then
				player:survivorSetInitialStats(165, 11, 0.07)
			else
				player:survivorSetInitialStats(115, 11, 0.04)
			end
			player:setSkill(2,
			"Quick Trigger",
			"Fire a shotgun forward dealing 500% damage.",
			sprSkills, 2, 3 * 60)
			player:setSkill(3,
			"Blinding Slide",
			"Quickly slide forwards. You can attack while sliding.",
			sprSkills, 3, 3 * 60)
			player:setSkill(4,
			"Devitalize",
			"Target the nearest enemy, attacking them for 850% damage. You cannot be hit for the duration.",
			sprSkills, 5, 6 * 60)
			
			player:getData().preCd = 0
			
			player:setAnimation("walk_1", player:getAnimation("walk"))
			player:setAnimation("idle_1", player:getAnimation("idle"))
			player:setAnimation("jump_1", player:getAnimation("jump"))
			player:setAnimation("shoot1_1_1", player:getAnimation("shoot1_1"))
		end
	end)
	survivor:addCallback("scepter", function(player)
		if SurvivorVariant.getActive(player) == NemesisMercenary then
			player:setSkill(4,
			"Absolute Devitalization",
			"Target the nearest enemy, attacking them for 1100% damage. You cannot be hit for the duration.",
			sprSkills, 6, 6 * 60)
		end
	end)
	survivor:addCallback("levelUp", function(player)
		if SurvivorVariant.getActive(player) == NemesisMercenary then
			player:survivorLevelUpStats(2, 0, -0.001, 0)
		end
	end)
	SurvivorVariant.setSkill(NemesisMercenary, 1, function(player)
		if player:getData().sliding then
			player.subimage = player.subimage + 3
		end
	end)
	SurvivorVariant.setSkill(NemesisMercenary, 2, function(player)
		if player:getData().sliding then
			SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2_2"), 0.2, true, true)
		else
			SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2_1"), 0.2, true, true)
		end
		player:set("pVspeed", player:getData().vSpeedStored)
	end)
	SurvivorVariant.setSkill(NemesisMercenary, 3, function(player)
		SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3"), 1, true, true)
		player:setAnimation("idle", player:getAnimation("idle_2"))
		player:setAnimation("walk", player:getAnimation("idle_2"))
		player:setAnimation("jump", player:getAnimation("idle_2"))
		player:setAnimation("shoot1_1", player:getAnimation("shoot1_2"))
		player:getData().xAccel = (2 + 1 * player:get("pHmax") ) * player.xscale
		player:getData().sliding = true
		
		if player:get("free") == 0 then
			local ef = obj.EfSparks:create(player.x, player.y)
			ef.sprite = spr.MinerShoot2Dust1
			ef.yscale = 1
			ef.xscale = player.xscale
		end
		
		if player:get("invincible") < 20 then
			player:set("invincible", player:get("invincible") + 20)
		end
		player:getData().preCd = math.max(180 - (180 * player:get("cdr")), 1)
	end)
	SurvivorVariant.setSkill(NemesisMercenary, 4, function(player)
		if player:get("scepter") > 0 then
			SurvivorVariant.activityState(player, 4, player:getAnimation("shoot5"), 0.3, true, true)
		else
			SurvivorVariant.activityState(player, 4, player:getAnimation("shoot4"), 0.3, true, true)
		end
		player:set("pVspeed", player:getData().vSpeedStored)
	end)
	callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
		if variant == NemesisMercenary then
			local playerAc = player:getAccessor()
			if skill == 2 then
				if relevantFrame == 1 then
					sShoot2_1:play(0.9 + math.random() * 0.2)
					if onScreen(player) then
						misc.shakeScreen(3)
					end
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 100, 5, spr.Sparks4, DAMAGER_BULLET_PIERCE)
						bullet:set("damage_degrade", 0.4)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
				if relevantFrame == player.sprite.frames - 2 then
					sShoot2_2:play(0.9 + math.random() * 0.2, 0.6)
				end
			elseif skill == 4 then
				if playerAc.invincible < 5 then
					playerAc.invincible = 5
				end
				if relevantFrame == 6 then
					local nearestEnemy = nearestMatchingOp(player, pobj.actors, "team", "~=", playerAc.team)
					if nearestEnemy and distance(player.x, player.y, nearestEnemy.x, nearestEnemy.y) <= 100 then
						sShoot4:play(0.9 + math.random() * 0.2)
						if onScreen(player) then
							misc.shakeScreen(5)
						end
						for i = 0, playerAc.sp do
							if playerAc.scepter > 0 then
								local bullet = player:fireBullet(nearestEnemy.x, nearestEnemy.y, player:getFacingDirection(), 5, 11, sprSparks2)
								bullet:set("specific_target", nearestEnemy.id)
								bullet:set("knockback", 10)
								bullet:set("knockback_direction", player.xscale)
								if i ~= 0 then
									bullet:set("climb", i * 8)
								end
							else
								local bullet = player:fireBullet(nearestEnemy.x, nearestEnemy.y, player:getFacingDirection(), 5, 8.5, sprSparks)
								bullet:set("specific_target", nearestEnemy.id)
								bullet:set("knockback", 4)
								bullet:set("knockback_direction", player.xscale)
								if i ~= 0 then
									bullet:set("climb", i * 8)
								end
							end
						end
					end
				end
			end
		end
	end)
	survivor:addCallback("step", function(player)
		if SurvivorVariant.getActive(player) == NemesisMercenary then
			local playerData = player:getData()
			if playerData.sliding then
				if player:get("dash_again") > 0 then
					player:set("dash_again",  0)
					player:setAlarm(4, playerData.preCd)
				else
					playerData.preCd = player:getAlarm(4)
				end
				if not playerData.xAccel then
					playerData.sliding = nil
					
					player:setAnimation("idle", player:getAnimation("idle_1"))
					player:setAnimation("walk", player:getAnimation("walk_1"))
					player:setAnimation("jump", player:getAnimation("jump_1"))
					player:setAnimation("shoot1_1", player:getAnimation("shoot1_1_1"))
				end
			end
			playerData.vSpeedStored = player:get("pVspeed")
		end
	end)
end