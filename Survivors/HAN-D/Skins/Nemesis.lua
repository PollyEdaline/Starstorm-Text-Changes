if not global.rormlflag.ss_disable_enemies then
	
	-- NEMESIS HAN-D
	
	local path = "Survivors/HAN-D/Skins/Nemesis/"

	local survivor = sur.HAND
	local sprSelect = Sprite.load("NemJanitorSelect", path.."Select", 13, 0, 0)
	local NemesisHAND = SurvivorVariant.new(survivor, "Nemesis HAN-D", sprSelect, {
		idle = Sprite.find("NemJanitorIdleA"),
		walk = Sprite.find("NemJanitorWalkA"),
		jump = Sprite.find("NemJanitorJumpA"),
		climb = Sprite.find("NemJanitorClimbA"),
		death = Sprite.load("NemJanitorDeathA", path.."Death", 7, 6, 1),
		death_2 = Sprite.find("NemJanitorDeathB"),
		decoy = Sprite.load("NemJanitorDecoy", path.."Decoy", 1, 9, 18),
		
		shoot1 = Sprite.find("NemJanitorShoot1A"),
		shoot4 = Sprite.find("NemJanitorShoot4A"),
		shoot4Run = Sprite.load("NemJanitorShoot4B", path.."Shoot4_1Run", 20, 50, 29),
		shoot5 = Sprite.load("NemJanitorShoot5A", path.."Shoot5_1", 20, 50, 29),
		shoot5Run = Sprite.load("NemJanitorShoot5B", path.."Shoot5_1Run", 20, 50, 29)
	}, Color.fromHex(0xC13E67))
	SurvivorVariant.setInfoStats(NemesisHAND, {{"Strength", 8}, {"Vitality", 5}, {"Toughness", 10}, {"Agility", 4}, {"Difficulty", 4.5}, {"Care", 5}})
	SurvivorVariant.setDescription(NemesisHAND, "The &y&Nemesis HAN-D&!& makes use of its different gardening tools to prove itself the most efficient at its job.")
	
	local sprSkills = Sprite.load("RMORSkills", path.."Skills", 4, 0, 0)
	local sShoot1 = Sound.find("NemJanitorShoot1")
	local sShoot4 = Sound.find("NemJanitorShoot4")
	local sprSparks = spr.Sparks6
	
	SurvivorVariant.setLoadoutSkill(NemesisHAND, "SHEAR", "CUT THROUGH COMBATANTS FOR &y&120% DAMAGE.", sprSkills)
	SurvivorVariant.setLoadoutSkill(NemesisHAND, "FOCUS", "TEMPORARILY &b&REDUCE YOUR MOVEMENT SPEED&!& WHILE DEALING &y&50% EXTRA DAMAGE.", sprSkills, 2)
	SurvivorVariant.setLoadoutSkill(NemesisHAND, "DOUBLE SHAVE", "SAW NEARBY COMBATANTS FOR &y&12x75% DAMAGE.", sprSkills, 3)

	NemesisHAND.endingQuote = "..and so it left, rebooting itself for once."
	
	--[[buff.slowStrength = Buff.new("slowStrength")
	buff.slowStrength.subimage = 4
	buff.slowStrength:addCallback("start", function(actor)
		local actorAc = actor:getAccessor()
		actorAc.pHmax = actorAc.pHmax - 0.2
		actor:getData().slowStrengthBuffDamage = actorAc.damage * 0.4
		actorAc.damage = actorAc.damage + actor:getData().slowStrengthBuffDamage
	end)
	buff.slowStrength:addCallback("end", function(actor)
		local actorAc = actor:getAccessor()
		actorAc.pHmax = actorAc.pHmax + 0.2
		if actor:getData().slowStrengthBuffDamage then
			actorAc.damage = actorAc.damage - actor:getData().slowStrengthBuffDamage
		end
	end)]]
	local postPlayerStepCall = function(player)
		if SurvivorVariant.getActive(player) == NemesisHAND then
			local gauge = Object.findInstance(player:get("gauge"))
			if gauge and gauge:isValid() then
				local playerData = player:getData()
				gauge:destroy()
				player:removeBuff(buff.burstSpeed)
				--player:applyBuff(buff.slowStrength, 200)
				if playerData.gaugeChild and playerData.gaugeChild:isValid() then
					playerData.gaugeChild:destroy()
				end
				playerData.gaugeChild = obj.NemJanitorGauge:create(player.x, player.y - 30)
				playerData.gaugeChild:getData().parent = player
			end
			
			player:setAnimation("shoot1", NemesisHAND.animations.shoot1)
			player:setAnimation("shoot4", NemesisHAND.animations.shoot4)
			player:setAnimation("walk", NemesisHAND.animations.walk)
			player:setAnimation("idle", NemesisHAND.animations.idle)
			player:setAnimation("jump", NemesisHAND.animations.jump)
			player:setAnimation("climb", NemesisHAND.animations.climb)
			player:setAnimation("death", NemesisHAND.animations.death)
		end
	end
	callback.register("onSkinInit", function(player, skin)
		if skin == NemesisHAND then
			if Difficulty.getActive() == dif.Drizzle then
				player:survivorSetInitialStats(175, 13, 0.035)
			else
				player:survivorSetInitialStats(125, 13, 0.005)
			end
			player:setSkill(1,
			"SHEAR",
			"CUT THROUGH COMBATANTS FOR 120% DAMAGE.",
			sprSkills, 1, 40)
			player:setSkill(3,
			"FOCUS",
			"TEMPORARILY REDUCE YOUR MOVEMENT SPEED WHILE DEALING 50% EXTRA DAMAGE.",
			sprSkills, 2, 60 * 8)
			player:setSkill(4,
			"DUAL SHAVE",
			"SAW NEARBY COMBATANTS FOR 12x75%DAMAGE.",
			sprSkills, 3, 60 * 6)
			tcallback.register("postPlayerStep", postPlayerStepCall)
		end
	end)
	survivor:addCallback("scepter", function(player)
		if SurvivorVariant.getActive(player) == NemesisHAND then
			player:setSkill(4,
			"DUAL SHAVE",
			"SAW NEARBY CONTENDERS FOR 75%x12 BLEEDING DAMAGE.",
			sprSkills, 4, 60 * 6)
		end
	end)
	survivor:addCallback("levelUp", function(player)
		if SurvivorVariant.getActive(player) == NemesisHAND then
			player:survivorLevelUpStats(3, 0, -0.003, 0)
		end
	end)
	survivor:addCallback("draw", function(player)
		local playerData = player:getData()
		if playerData.gaugeChild and SurvivorVariant.getActive(player) == NemesisHAND then
			graphics.setBlendMode("additive")
			graphics.drawImage{
				image = player.sprite,
				subimage = player.subimage,
				x = player.x,
				y = player.y,
				color = Color.RED,
				alpha = 0.8,
				angle = player.angle,
				xscale = player.xscale + math.random(0, 10) * 0.02,
				yscale = player.yscale + math.random(0, 10) * 0.02
			}
			graphics.setBlendMode("normal")
		end
	end)
	SurvivorVariant.setSkill(NemesisHAND, 1, function(player)
		SurvivorVariant.activityState(player, 1, NemesisHAND.animations.shoot1, 0.22, true, true)
	end)
	SurvivorVariant.setSkill(NemesisHAND, 4, function(player)
		if player:get("scepter") > 0 then
			SurvivorVariant.activityState(player, 4, NemesisHAND.animations.shoot5, 0.2, true, false)
		else
			if player:get("pHspeed") == 0 then
				SurvivorVariant.activityState(player, 4, NemesisHAND.animations.shoot4, 0.2, true, false)
			else
				SurvivorVariant.activityState(player, 4, NemesisHAND.animations.shoot4Run, 0.2, true, false)
			end
		end
	end)
	callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
		if variant == NemesisHAND then
			local playerAc = player:getAccessor()
			if skill == 1 then
				if relevantFrame == 4 then
					sShoot1:play(0.9 + math.random() * 0.2, 0.9)
					if not player:survivorFireHeavenCracker(1.2) then
						for i = 0, playerAc.sp do
							local bullet = player:fireExplosion(player.x + 20 * player.xscale, player.y, 28 / 19, 15 / 4, 1.2)
							if i ~= 0 then
								bullet:set("climb", i * 8)
							end
						end
					end
				end
				
			elseif skill == 4 then
				--[[if playerAc.invincible < 2 then
					playerAc.invincible = 2
				end]]
				
				if playerAc.moveRight == 1 then
					playerAc.pHspeed = playerAc.pHmax
				elseif playerAc.moveLeft == 1 then
					playerAc.pHspeed = playerAc.pHmax * -1
				else
					playerAc.pHspeed = 0
				end
				
				if relevantFrame == 6 then
					sShoot4:play(0.9 + math.random() * 0.2, 0.9)
				end
				if relevantFrame >= 8 and relevantFrame <= 19 then
					-- i made a sin
					--player:getData().skin_onActivity = true
					for i = 0, playerAc.sp do
						local bullet = player:fireExplosion(player.x, player.y, 28 / 19, 15 / 4, 0.75)
						if playerAc.scepter > 0 then
							bullet:set("bleed", playerAc.scepter * 2)
						end
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
						bullet:set("stun", 0.2)
					end
					
					if global.quality > 1 then
						par.Spark:burst("middle", player.x - 15, player.y, 1)
						par.Spark:burst("middle", player.x + 15, player.y, 1)
					end
					
					local r1, r2, sp = 60, 40, 3
					if playerAc.scepter > 0 then
						r1, r2 = 120, 80, 4
						
						if onScreen(player) then
							misc.shakeScreen(1)
						end
					end
					for _, actor in ipairs(pobj.actors:findAllRectangle(player.x - r1, player.y - r2, player.x + r1, player.y + r2)) do
						if actor:get("team") ~= player:get("team") and not actor:isBoss() then
							local xx, yy = pointInLine(actor.x, actor.y, player.x, player.y - 3, sp)
							if not actor:collidesMap(xx, yy) then
								actor.x = xx
								actor.y = yy
							end
						end
					end
				end
				
			end
		end
	end)
end