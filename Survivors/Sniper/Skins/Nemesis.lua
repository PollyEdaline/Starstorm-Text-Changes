-- Nemesis Sniper

local path = "Survivors/Sniper/Skins/Nemesis/"

local efColor = Color.fromHex(0xFFFF5E)
local efColor2 = Color.fromHex(0xE57E24)

local jumpTime = 35

local vdescription = "Send SPOT to distract the most dangerous enemy nearby for 3 seconds, shocking it for 4x100% damage."
local vdescriptionScepter = "Send SPOT to distract the most dangerous enemy nearby for 6 seconds, shocking it for 8x100% damage."

local survivor = sur.Sniper
local sprSelect = Sprite.load("NemesisSniperSelect", path.."Select", 14, 2, 0)
local NemesisSniper = SurvivorVariant.new(survivor, "Nemesis Sniper", sprSelect, {
	idle = Sprite.find("NemesisSniperIdle", "Starstorm"),
	walk = Sprite.find("NemesisSniperWalk", "Starstorm"),
	jump = Sprite.find("NemesisSniperJump", "Starstorm"),
	climb_1 = Sprite.find("NemesisSniperClimbA", "Starstorm"),
	climb_2 = Sprite.find("NemesisSniperClimbB", "Starstorm"),
	death = Sprite.find("NemesisSniperDeath", "Starstorm"),
	decoy = Sprite.load("NemesisSniperDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.find("NemesisSniperShoot1A", "Starstorm"),
	shoot1_2 = Sprite.find("NemesisSniperShoot1B", "Starstorm"),
	shoot1_3 = Sprite.find("NemesisSniperShoot1C", "Starstorm"),
	shoot2_1 = Sprite.find("NemesisSniperShoot2A", "Starstorm"),
	shoot2_2 = Sprite.find("NemesisSniperShoot2B", "Starstorm"),
	shoot3_1 = Sprite.find("NemesisSniperShoot3", "Starstorm"),
	
	drone_idle = Sprite.find("NemesisSniperDroneIdle", "Starstorm"),
	drone_jump = Sprite.find("NemesisSniperDroneJump", "Starstorm"),
	drone_walk = Sprite.find("NemesisSniperDroneWalk", "Starstorm"),
	drone_mask = Sprite.find("NemesisSniperDroneMask", "Starstorm"),
	drone_signal = Sprite.find("NemesisSniperDroneSignal", "Starstorm")
}, efColor)
SurvivorVariant.setInfoStats(NemesisSniper, {{"Strength", 9}, {"Vitality", 4}, {"Toughness", 3}, {"Agility", 3}, {"Difficulty", 4}, {"Tactics", 8}})
SurvivorVariant.setDescription(NemesisSniper, "The &y&Nemesis Sniper&!& arrived without invitation, determined to take out targets with a railgun and a state of the art support drone. &r&Overheating causes the weapon to be unusable temporarily&!&.")

local sprSkills = Sprite.load("NemesisSniperSkills", path.."Skills", 5, 0, 0)
local sprSparks = spr.Sparks10r

local sShoot1_1 = Sound.find("NemesisSniperShoot1_1", "Starstorm")
local sShoot1_2 = Sound.find("NemesisSniperShoot1_2", "Starstorm")
local sShoot2_1 = Sound.find("NemesisSniperShoot2_1", "Starstorm")

SurvivorVariant.setLoadoutSkill(NemesisSniper, "Take Out", "Shoot an enemy for &y&175% damage&!&. &r&Heats up the weapon&!&.", sprSkills, 1)
SurvivorVariant.setLoadoutSkill(NemesisSniper, "Steady Discharge", "Release all the captured heat from the weapon, &y&increasing damage the higher the heat level&!& for &y&up to 1400% damage&!&.", sprSkills, 2)
SurvivorVariant.setLoadoutSkill(NemesisSniper, "SPOT: CONDUIT", "Send SPOT to &y&distract the most dangerous enemy nearby&!& for 3 seconds, shocking it for &y&4x100% damage&!&.", sprSkills, 3)

NemesisSniper.endingQuote = "..and so they left, finding a home amongst the stars."

callback.register("onSkinInit", function(player, skin)
	if skin == NemesisSniper then
		player:getData().gunheat = 0
		player:getData().gunrefresh = 0
		
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(149, 14.5, 0.045)
		else
			player:survivorSetInitialStats(99, 14.5, 0.015)
		end
		player:setSkill(1,
		"Take Out",
		"Shoot an enemy for 175% damage. Heats up the weapon.",
		sprSkills, 1, 55)
		player:setSkill(2,
		"Steady Discharge",
		"Release all the captured heat from the weapon, increasing damage the higher the heat level for up to 1400% damage.",
		sprSkills, 2, 6 * 60)
		player:setSkill(4,
		"SPOT: CONDUIT",
		"Send SPOT to distract the most dangerous enemy nearby for 3 seconds, shocking it for 4x100% damage.",
		sprSkills, 3, 12 * 60)
		player:getData().correctVindex = 3
		
		for _, drone in ipairs(obj.SniperDrone:findMatching("master", player.id)) do
			drone:destroy()
		end
		local drone = obj.NemesisSniperDrone:create(player.x, player.y)
		drone:getData().parent = player
		player:getData().childDrone = drone
		player:setAnimation("climb", NemesisSniper.animations.climb_1)
	end
end)
table.insert(call.onStageEntry, function()
	for _, player in ipairs(misc.players) do
		if player:getData().gunrefresh then -- cheap way to check it's nemsniper hehe
			player:getData().removeDrone = true
		end
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == NemesisSniper then
		player:survivorLevelUpStats(-7, 0, 0, 0)
	end
end)
SurvivorVariant.setSkill(NemesisSniper, 1, function(player)
	if player:getData().gunoverheat then
		SurvivorVariant.activityState(player, 1.2, player:getAnimation("shoot1_3"), 0.2, false, true)
		sShoot1_2:play(0.95 + math.random() * 0.1)
	else
		--if player:getData().gunheat > 75 then
			if player:getData().gunheat > 84 then
				player:getData().gunoverheat = true
			end
			--SurvivorVariant.activityState(player, 1.1, player:getAnimation("shoot1_2"), 0.2, true, true)
		--else
			SurvivorVariant.activityState(player, 1.1, player:getAnimation("shoot1_1"), 0.2, true, true)
		--end
	end
end)
SurvivorVariant.setSkill(NemesisSniper, 2, function(player)
	if player:getData().gunheat > 0 then
		SurvivorVariant.activityState(player, 2.1, player:getAnimation("shoot2_1"), 0.2, false, true)
		player:activateSkillCooldown(2)
	else
		SurvivorVariant.activityState(player, 2.2, player:getAnimation("shoot2_2"), 0.2, true, true)
		sShoot1_2:play(0.95 + math.random() * 0.1)
	end
end)
SurvivorVariant.setSkill(NemesisSniper, 4, function(player)
	local drone, lookForEnemy, scepter = nil, true, player:get("scepter")
	--print("checking drone")
	if player:getData().childDrone:isValid() then
		drone = player:getData().childDrone
		--print("valid drone")
		if drone:getData().attacking and drone:getData().attacking:isValid() and drone:getData().attackingTimer > 0 or drone:getData().jumpToAttack and drone:getData().jumping > 0 then
			--print("bring back")
			drone:getData().jumpToAttack = nil
			drone:getData().attacking = nil
			drone:getData().jumping = 0
			lookForEnemy = false
			
			for _, poi in ipairs(obj.POI:findMatching("parent", drone.id)) do
				poi:destroy()
			end
			
			local title, desc, sindex = "SPOT: CONDUIT", vdescription, 3
			if scepter > 0 then
				title = "SPOT: OUTBURST"
				desc = vdescriptionScepter
				sindex = 5
			end
			player:setSkill(4,
			title,
			desc,
			sprSkills, sindex, 12 * 60)
			player:getData().correctVindex = sindex
			player:activateSkillCooldown(4)
		end
	else
		--print("invalid drone, creating")
		drone = obj.NemesisSniperDrone:create(player.x, player.y)
		drone:getData().parent = player
		player:getData().childDrone = drone
		player:setAnimation("climb", NemesisSniper.animations.climb_1)
		if player:get("activity") == 30 then
			player.sprite = NemesisSniper.animations.climb_1
		end
	end
	
	if lookForEnemy then
		--print("looking for enemy")
		local priorityEnemy = {instance = nil, damage = nil}
		for _, actor in ipairs(pobj.actors:findAll()) do
			if actor:get("team") and actor:get("team") ~= player:get("team") then
				if actor.x > player.x - 400 and actor.x < player.x + 400 and actor.y > player.y - 250 and actor.y < player.y + 250 then
					local actorDamage = actor:get("damage")
					if not priorityEnemy.instance or actorDamage and not priorityEnemy.damage or actorDamage and priorityEnemy.damage and actorDamage > priorityEnemy.damage then
						priorityEnemy.instance = actor
						priorityEnemy.damage = actorDamage
					end
				end
			end
		end
		
		if priorityEnemy.instance then
			--print("enemy found")
			drone:getData().jumping = jumpTime
			drone:getData().jumpToAttack = priorityEnemy.instance
			drone:getData().ogx = drone.x
			drone:getData().yy = drone.y
			drone:getData().jumpingTarget = priorityEnemy.instance
			drone:getData().jumpingTargetx = priorityEnemy.instance.x
			drone:getData().jumpingTargety = priorityEnemy.instance.y
			
			local title, desc = "SPOT: CONDUIT", vdescription
			if scepter > 0 then
				title = "SPOT: OUTBURST"
				desc = vdescriptionScepter
			end
			player:setSkill(4,
			title,
			desc,
			sprSkills, 4, 60)
			player:getData().correctVindex = 4
			--player:setSkillIcon(4, sprSkills, 4)
			player:activateSkillCooldown(4)
			sfx.Error:stop()
			sfx.JanitorShoot2_2:play(2, 0.7)
		else
			--print("not enemy found")
			if not net.online or player == net.localPlayer then
				sfx.Error:play()
				local title, desc, sindex = "SPOT: CONDUIT", vdescription, 3
				if scepter > 0 then
					title = "SPOT: OUTBURST"
					desc = vdescriptionScepter
					sindex = 5
				end
				player:setSkill(4,
				title,
				desc,
				sprSkills, sindex, 30)
				player:getData().correctVindex = sindex
			end
			player:activateSkillCooldown(4)
		end
	end
end)

callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
	if variant == NemesisSniper then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		if skill == 1.1 then
			if relevantFrame == 1 then
				sShoot1_1:play(1 + math.random() * 0.2)
				if not player:survivorFireHeavenCracker(1.5) then
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x, player.y + 3, player:getFacingDirection(), 500, 1.75, nil) --, DAMAGER_BULLET_PIERCE)
						addBulletTrailLine(bullet, efColor, 1.5, 30, false, true)
						
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
				playerData.gunheat = math.min(playerData.gunheat + 15, 100)
			end
		elseif skill == 2.1 then
			if relevantFrame == 1 then
				sShoot2_1:play(0.9 + math.random() * 0.2)
				local damageMult = playerData.gunheat / 100
				for i = 0, playerAc.sp do
					local bullet = player:fireBullet(player.x, player.y + 3, player:getFacingDirection(), 2000, 14 * damageMult, nil, DAMAGER_BULLET_PIERCE)
					addBulletTrailLine(bullet, efColor2, 2, 50, true, true)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
				playerData.gunrefresh = 50
			end
		end
		if skill > 2 and skill < 3 then
			for _, bar in ipairs(obj.CustomBar:findAll()) do
				if bar.id == playerAc.activity_var2 then
					bar:destroy()
					playerAc.bullet_ready = 1
				end
			end
			for _, bar in ipairs(obj.SniperBar:findMatching("parent", player.id)) do
				bar:destroy()
			end
		end
	end
end)
local onPlayerStepCall = function(player)
	if SurvivorVariant.getActive(player) == NemesisSniper then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		
		playerAc.bullet_ready = 1
		
		if player:getData().removeDrone then
			for _, drone in ipairs(obj.SniperDrone:findMatching("master", player.id)) do
				drone:destroy()
				player:getData().removeDrone = nil
			end
		end
		
		if not playerData.childDrone:isValid() then
			if playerAc.activity ~= 30 then
				local drone = obj.NemesisSniperDrone:create(player.x, player.y)
				drone:getData().parent = player
				player:getData().childDrone = drone
				player:setAnimation("climb", NemesisSniper.animations.climb_1)
			end
		end
		
		if playerData.gunrefresh > 0 then
			local downValue = math.min(playerData.gunrefresh / 40, 1)
			playerData.gunheat = math.max(playerData.gunheat - 2 * downValue, 0)
			playerData.gunrefresh = playerData.gunrefresh - 1
		end
		if playerData.gunheat > 0 then
			if playerData.gunoverheat then
				playerData.gunheat = playerData.gunheat - 0.3
			else
				playerData.gunheat = playerData.gunheat - 0.15
			end
			
			if #obj.CustomBar:findMatching("parent", player.id) == 0 then
				local bar = obj.CustomBar:create(player.x, player.y)
				bar:set("parent", player.id)
				bar:set("maxtime", 100)
				bar:set("time", 100)
				bar:set("barColor", efColor.gml)
				bar:set("charge", 1)
				bar:getData().isSniperHeat = true
				bar.subimage = 5
			else
				for _, bar in ipairs(obj.CustomBar:findMatching("parent", player.id)) do
					if bar:getData().isSniperHeat then
						bar:set("time", math.max(100 - player:getData().gunheat, 0))
						if playerData.gunoverheat then
							bar:set("barColor", efColor2.gml)
						end
					end
				end
			end
		else
			if playerData.gunoverheat then
				playerData.gunoverheat = false
			end
			for _, bar in ipairs(obj.CustomBar:findMatching("parent", player.id)) do
				if bar:getData().isSniperHeat then
					bar:destroy()
				end
			end
		end
		
		player:setSkillIcon(4, sprSkills, player:getData().correctVindex)
		
		--player:getData().skill1 = true
	end
end

callback.register("onPlayerDeath", function(player)
	if player:getData().gunheat then
		player:getData().gunheat = 0
		for _, bar in ipairs(obj.CustomBar:findMatching("parent", player.id)) do
			if bar:getData().isSniperHeat then
				bar:destroy()
			end
		end
	end
end)

survivor:addCallback("scepter", function(player)
	if player:getData().gunheat then
		par.SporeOld:burst("middle", player.x + math.random(-1, 1), player.y, 1, Color.RED)
		player:setSkill(4,
		"SPOT: OUTBURST",
		vdescriptionScepter,
		sprSkills, 5, 12 * 60)
		player:getData().correctVindex = 5
	end
end)


callback.register("onSkinInit", function(player, skin)
	if skin == NemesisSniper then
		tcallback.register("onPlayerStep", onPlayerStepCall)
	end
end)