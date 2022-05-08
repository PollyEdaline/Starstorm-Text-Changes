if not global.rormlflag.ss_disable_enemies then

	-- NEMESIS BANDIT
	
	local path = "Survivors/Bandit/Skins/Nemesis/"
	
	local survivor = sur.Bandit
	local sprSelect = Sprite.load("NemesisBanditSelect", path.."Select", 19, 2, 0)
	local NemesisBandit = SurvivorVariant.new(survivor, "Nemesis Bandit", sprSelect, {
		idle = Sprite.find("NemesisBanditIdle", "Starstorm"),
		walk = Sprite.find("NemesisBanditWalk", "Starstorm"),
		jump = Sprite.find("NemesisBanditJump", "Starstorm"),
		climb = Sprite.find("NemesisBanditClimb", "Starstorm"),
		death = Sprite.find("NemesisBanditDeath", "Starstorm"),
		decoy = Sprite.load("NemesisBanditDecoy", path.."Decoy", 1, 9, 18),
		
		shoot1 = Sprite.find("NemesisBanditShoot1", "Starstorm"),
		shoot2a = Sprite.find("NemesisBanditShoot2a", "Starstorm"),
		shoot2b = Sprite.find("NemesisBanditShoot2b", "Starstorm"),
		shoot4 = Sprite.find("NemesisBanditShoot4", "Starstorm"),
		shoot5 = Sprite.load("NemesisBanditShoot5", path.."Shoot5", 11, 7, 13),
	}, Color.fromHex(0xEA4F2C))
	SurvivorVariant.setInfoStats(NemesisBandit, {{"Strength", 7}, {"Vitality", 6}, {"Toughness", 3}, {"Agility", 6}, {"Difficulty", 5}, {"Curse", 6}})
	SurvivorVariant.setDescription(NemesisBandit, "The &y&Nemesis Bandit&!& doesn't care for pleas, for he only brings misery to those who dare step in his way.")

	local sprSparks = spr.Sparks9r
	local sprSkills = Sprite.load("NemesisBanditSkills", path.."Skills", 3, 0, 0)
	local sShoot = Sound.find("NemesisBanditGun", "Starstorm")
	local sShoot2a = Sound.find("NemesisBanditWhipA", "Starstorm")
	local sShoot2b = Sound.find("NemesisBanditWhipB", "Starstorm")
	local sShootOriginal = sfx.CowboyShoot1
	local sShoot2Original = sfx.CowboyShoot2

	SurvivorVariant.setLoadoutSkill(NemesisBandit, "Gunslinger", "Fire a bullet for &y&220% damage&!&.", sprSkills)
	SurvivorVariant.setLoadoutSkill(NemesisBandit, "Restrain", "Throw a lasso to &b&restrain&!& and &b&pull&!& enemies. &y&Restrained enemies can be mounted&!&.", sprSkills, 2)
	SurvivorVariant.setLoadoutSkill(NemesisBandit, "Lights Out", "Fire your shotgun, dealing &y&600% damage&!&. If the ability kills all enemies struck, &b&all cooldowns are reset to 0&!&.", spr.CowboySkills, 7)
	
	NemesisBandit.endingQuote = "..and so he left, with absolutely no regrets."
	
	local onHitCall = function(damager, hit)
		local data = damager:getData()
		if data.killRefresh then
			if not data.kRL then
				data.kRL = {}
				table.insert(data.kRL, hit)
			else
				table.insert(data.kRL, hit)
			end
		end
	end
	
	obj.Bullet:addCallback("destroy", function(self)
		local data = self:getData()
		if data.killRefresh and data.kRL then
			local c = 0
			for _, a in ipairs(data.kRL) do
				if a:get("hp") <= 0 then
					c = c + 1
				end
			end
			if c >= #data.kRL then
				local p = self:getParent()
				if p and p:isValid() then
					p:setAlarm(5, 1)
					p:setAlarm(4, 1)
					p:setAlarm(3, 1)
				end
			end
		end
	end)

	callback.register("onSkinInit", function(player, skin)
		if skin == NemesisBandit then
			player:getData().skin_skill4Override = true
			player:set("pHmax", player:get("pHmax") + 0.1)
			if Difficulty.getActive() == dif.Drizzle then
				player:survivorSetInitialStats(165, 12, 0.048)
			else
				player:survivorSetInitialStats(115, 12, 0.018)
			end
			player:setSkill(1,
				"Gunslinger",
				"Fire a bullet for 220% damage.",
				sprSkills, 1, 
				39
			)
			player:setSkill(2,
				"Restrain",
				"Throw a lasso to restrain an enemy in front of you. Enemies can be ridden.",
				sprSkills, 2,
				1 * 60
			)
			player:setSkill(4,
				"Lights Out",
				"Fire your shotgun for 600% damage. If the ability kills all enemies struck, all cooldowns are reset to 0.",
				spr.CowboySkills, 7,
				8 * 60
			)
			player:setAnimation("shoot2", player:getAnimation("shoot2a"))
		end
	end)
	survivor:addCallback("levelUp", function(player)
		if SurvivorVariant.getActive(player) == NemesisBandit then
			player:survivorLevelUpStats(4, 0, -0.001, 0)
		end
	end)
	survivor:addCallback("scepter", function(player)
		if SurvivorVariant.getActive(player) == NemesisBandit then
			player:setSkill(4,
				"Assassinate",
				"Fire your shotgun for 2x600% damage. If the ability kills all enemies struck, all cooldowns are reset to 0.",
				spr.CowboySkills, 5,
				8 * 60
			)
		end
	end)
	local whipBlacklist = {
		[obj.Boss1] = true,
		[obj.Boss3Fake] = true,
		[obj.Boss3] = true,
		[obj.WormHead] = true,
		[obj.WurmHead] = true,
		[obj.WormBody] = true,
		[obj.WurmBody] = true,
		[obj.Bug] = true,
		[obj.Jelly] = true,
		[obj.JellyG2] = true,
		[obj.GiantJelly] = true,
		[obj.LizardF] = true,
	}
	callback.register("postLoad", function()
		if not global.rormlflag.ss_disable_enemies then
			whipBlacklist[obj.Wyvern] = true
			whipBlacklist[obj.WyvernHead] = true
			whipBlacklist[obj.WyvernTail] = true
			whipBlacklist[obj.SquallElver] = true
			whipBlacklist[obj.Arraign1] = true
			whipBlacklist[obj.Arraign2] = true
		end
	end)
	
	SurvivorVariant.setSkill(NemesisBandit, 1, function(player)
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1"), 0.2, true, true)
	end)
	SurvivorVariant.setSkill(NemesisBandit, 4, function(player)
		if player:get("scepter") > 0 then
			SurvivorVariant.activityState(player, 4, player:getAnimation("shoot5"), 0.2, true, true)
		else
			SurvivorVariant.activityState(player, 4, player:getAnimation("shoot4"), 0.2, true, true)
		end
	end)
	survivor:addCallback("onSkill", function(player, skill, relevantFrame)
		if SurvivorVariant.getActive(player) == NemesisBandit then
			local playerAc = player:getAccessor()
			local playerData = player:getData()
			if skill == 1.01 then
				if relevantFrame == 1 and not playerData.skin_onActivity then
					playerAc.darksight_timer = 0
					playerData.skin_onActivity = true
					sShoot:play(1 + math.random() * 0.2)
					if not player:survivorFireHeavenCracker(2.2) then
						for i = 0, playerAc.sp do
							local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 400, 2.2, spr.Sparks1)
							bullet:set("knockback", 2)
							if i ~= 0 then
								bullet:set("climb", i * 8)
							end
						end
					end
					
					if playerData.whipChild and playerData.whipChild:isValid() and playerData.riding then
						playerData.whipChild:set("z_skill", 1)
					end
				elseif relevantFrame ~= 1 then
					playerData.skin_onActivity = nil
				end
			elseif skill == 2 then
				if player.sprite == player:getAnimation("shoot2b") then
					local child = playerData.whipChild
					if child and child:isValid() and not playerData.riding then
						if child.x < player.x then
							player.xscale = -1
						else
							player.xscale = 1
						end
					end
					if relevantFrame == 4 and not playerData.skin_onActivity then
						if child and child:isValid() then
							if child:getData().resetTeam then
								child:set("team", child:getData().resetTeam )
							end
							for i = 0, playerAc.sp do
								local damage = 0.5
								if child:get("hp") - (playerAc.damage * damage * 2) <= 0 then
									damage = 0
								end
								local bullet = player:fireBullet(child.x - 2, child.y, 0, 6, damage, nil)
								--bullet:set("specific_target", child.id)
								if i ~= 0 then
									bullet:set("climb", i * 8)
								end
							end
							child:setAlarm(7, 60)
							if child:isClassic() then
								if child.y > player.y then
									child:set("pVspeed", -2.2)
								else
									child:set("pVspeed", -1)
								end
								child.y = child.y - 1
							end
							if playerData.riding then
								child:getData()._pullDir = player.xscale
								playerAc.pVspeed = -3
							else
								if child.x < player.x then
									child:getData()._pullDir = 1
								else
									child:getData()._pullDir = -1
								end
							end
							child:applyBuff(buff.nBanditPull, 60)
						end
					elseif relevantFrame == 7 then
						playerData.whipChild = nil
					elseif relevantFrame ~= 4 then
						playerData.skin_onActivity = nil
					end
				elseif player.sprite == player:getAnimation("shoot2a") then
					if relevantFrame == 8 and not playerData.skin_onActivity then
						playerData.skin_onActivity = true
						local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 400, 0.8, nil)
						bullet:getData().isNBanditWhip = true
					elseif relevantFrame ~= 8 then
						playerData.skin_onActivity = nil
					end
					if relevantFrame > 8 and playerData.whipChild and playerData.whipChild:isValid() then
						player.subimage = player.sprite.frames
					end
				end
			elseif skill == 4.01 then
				if relevantFrame == 6 and not playerData.skin_onActivity then
					sfx.CowboyShoot4_2:play(1 + math.random() * 0.2)
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 110, 6, spr.Sparks4, DAMAGER_BULLET_PIERCE)
						bullet:set("knockback", 3)
						--bullet:set("refresh_x", 1)
						bullet:getData().killRefresh = true
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
					playerData.skin_onActivity = true
				elseif playerAc.scepter > 0 and relevantFrame == 8 and not playerData.skin_onActivity then
					sfx.CowboyShoot4_2:play(1 + math.random() * 0.2)
					playerData.skin_onActivity = true
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 110, 6, spr.Sparks4, DAMAGER_BULLET_PIERCE)
						bullet:set("knockback", 3)
						bullet:set("refresh_x", 1)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				elseif relevantFrame ~= 6 and relevantFrame ~= 8 then
					playerData.skin_onActivity = nil
				end
			end
		end
	end)
	local onPlayerStepCall = function(player)
		if SurvivorVariant.getActive(player) == NemesisBandit then
			local playerData = player:getData()
			local playerAc = player:getAccessor()
			local whipChild = playerData.whipChild
			if player:get("activity") ~= 2 or player.sprite == player:getAnimation("shoot2b") and player.subimage < 3 then
				playerAc.canrope = 1
				if whipChild then
					if whipChild:isValid() then
						if playerAc.activity ~= 1.01 then
							whipChild:setAlarm(2, 2)
						end
						whipChild:setAlarm(3, 10)
						whipChild:setAlarm(4, 10)
						whipChild:setAlarm(5, 10)
						
						local riding = playerData.riding
						
						if riding and riding:isValid() then
							local image = riding.mask or riding.sprite
							local childPointY = riding.y - image.yorigin + (image.height * 0.1)
							player.y = childPointY
							player.x = riding.x
							
							for _, drone in ipairs(pobj.drones:findMatching("master", player.id)) do
								local target = drone:get("target")
								if target > 0 and Object.findInstance(target) == riding then
									drone:set("target", -4)
								end
							end
							
							local e = nearestMatchingOp(player, pobj.actors, "team", "~=", playerAc.team)
							if e then
								whipChild:set("target", e.id)
							end
							
							playerAc.pVspeed = 0
							playerAc.free = 0
							
							if not playerData.preDepth then
								playerData.preDepth = player.depth
								playerAc.armor = playerAc.armor + 100
							end
							
							player.depth = riding.depth + 1
							
							if not riding:getData().resetTeam then
								riding:getData().resetTeam = riding:get("team")
							end
							riding:set("team", playerAc.team)
							
							riding:setAlarm(6, -1)
							
							if playerAc.activity == 0 then
								player.subimage = 1
							end
							riding:set("ghost_x", riding.x)
							riding:set("ghost_y", riding.y)
							
							riding:set("moveRight", playerAc.moveRight)
							riding:set("moveLeft", playerAc.moveLeft)
							riding:set("moveUp", playerAc.moveUp)
							playerAc.canrope = 0
							
						else
							playerData.riding = nil
							if whipChild:getData().resetTeam then
								whipChild:set("team", whipChild:getData().resetTeam)
								whipChild:set("target", -4)
							end
							whipChild:setAlarm(7, 10)
							
							if playerAc.pVspeed > 0.5 and player.x > whipChild.x - 10 and player.x < whipChild.x + 10 and player:collidesWith(whipChild, player.x, player.y) then
								local proceed = true
								
								local image = whipChild.mask or whipChild.sprite
								local yy = whipChild.y - image.yorigin + (image.height * 0.1)
								local ydif = player.y - yy
								
								for i = 1, ydif do
									if player:collidesMap(whipChild.x, player.y - i) then
										proceed = false
										break
									end
								end
								
								if proceed then
									playerData.riding = whipChild
								end
							end
						end
					end
					if whipChild:isValid() == false or whipChild.y > player.y + 80 or whipChild.y < player.y - 80 then
						playerData.whipChild = nil
						player:setAnimation("shoot2", player:getAnimation("shoot2a"))
						player:setSkill(2,
							"Restrain",
							"Throw a lasso to restrain an enemy in front of you.",
							sprSkills, 2,
							1 * 60
						)
					else
						player:setAnimation("shoot2", player:getAnimation("shoot2b"))
						player:setSkill(2,
							"Pull",
							"Pull the restrained enemy towards you, dealing 50% damage.",
							sprSkills, 3,
							3 * 60
						)
					end
				else
					playerData.riding = nil
					player:setAnimation("shoot2", player:getAnimation("shoot2a"))
					player:setSkill(2,
						"Restrain",
						"Throw a lasso to restrain an enemy in front of you.",
						sprSkills, 2,
						1 * 60
					)
				end
			end
			if not whipChild or whipChild:isValid() == false or not playerData.riding then
				if playerData.preDepth then
					player.depth = playerData.preDepth
					playerAc.armor = playerAc.armor - 100
					playerData.preDepth = nil
				end
			end
			if playerData.whipChildTimer then
				if playerData.whipChildTimer > 0 then
					playerData.whipChildTimer = playerData.whipChildTimer - 1
				else
					if whipChild and whipChild:isValid() and whipChild:getData().resetTeam then
						whipChild:set("team", whipChild:getData().resetTeam )
					end
					playerData.whipChild = nil
				end
			end
		end
	end

	local postStepCall = function()
		for _, dynamite in ipairs(obj.CowboyDynamite:findAll()) do
			local data = dynamite:getData()
			if not data.skin_checked then
				data.skin_checked = true
				local parentid = dynamite:get("parent")
				local parent = Object.findInstance(parentid)
				if parent and parent:isValid() then
					if SurvivorVariant.getActive(parent) == NemesisBandit then
						dynamite:delete()
						sShoot2Original:stop()
						if parent:getData().whipChild then
							sShoot2b:play(1 + math.random() * 0.2)
						else
							sShoot2a:play(1 + math.random() * 0.2)
						end
					end
				end
			end
		end
	end
	
	local onHitCall2 = function(damager, hit)
		if damager:getData().isNBanditWhip then
			local parent = damager:getParent()
			if parent and parent:isValid() and not whipBlacklist[hit:getObject()] then
				parent:getData().whipChild = hit
				parent:getData().whipChildTimer = 1400
				if hit:isBoss() then
					parent:getData().whipChildTimer = 400
				end
			end
		end
	end
	
	local onPlayerDrawCall = function(player)
		local child = player:getData().whipChild
		if child and child:isValid() then
			graphics.alpha(1)
			graphics.color(Color.fromHex(0xB59C77))
			local image = child.mask or child.sprite
			local childPointX = child.x - image.xorigin + (image.width * 0.5)
			local childPointY = child.y - image.yorigin + (image.height * 0.2)
			graphics.line(player.x, player.y - 1, childPointX, childPointY)
		end
	end
	
	local preHitCall = function(damager, hit)
		local parent = damager:getParent()
		if parent and parent:isValid() and parent:getData().whipChild == hit then
			damager:set("damage", damager:get("damage") * 1.25)
		end
	end
	
	callback.register("onSkinInit", function(player, skin)
		if skin == NemesisBandit then
			tcallback.register("postStep", postStepCall)
			tcallback.register("onPlayerStep", onPlayerStepCall)
			tcallback.register("onPlayerDraw", onPlayerDrawCall)
			tcallback.register("preHit", preHitCall)
			tcallback.register("onHit", onHitCall)
			tcallback.register("onHit", onHitCall2)
		end
	end)
	
	callback.register("onPlayerDeath", function(player)
		if player:getSurvivor() == sur.Bandit then
			local playerData = player:getData()
			if playerData.riding and playerData.riding:isValid() then
				playerData.riding:set("team", playerData.riding:getData().resetTeam or "enemy")
			end
			playerData.riding = nil
			playerData.whipChild = nil
		end
	end)
end