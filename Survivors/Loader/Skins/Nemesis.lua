-- NEMESIS LOADER

local path = "Survivors/Loader/Skins/Nemesis/"

local survivor = sur.Loader
local sprSelect = Sprite.load("NemesisLoaderSelect", path.."Select", 18, 2, 0)
local NemesisLoader = SurvivorVariant.new(survivor, "Nemesis Loader", sprSelect, {
	idle = Sprite.find("NemesisLoaderIdle", "Starstorm"),
	walk = Sprite.find("NemesisLoaderWalk", "Starstorm"),
	jump = Sprite.find("NemesisLoaderJump", "Starstorm"),
	climb = Sprite.find("NemesisLoaderClimb", "Starstorm"),
	death = Sprite.find("NemesisLoaderDeath", "Starstorm"),
	decoy = Sprite.load("NemesisLoaderDecoy", path.."Decoy", 1, 9, 18),
	
	shoot11 = Sprite.find("NemesisLoaderShoot1A", "Starstorm"),
	shoot12 = Sprite.find("NemesisLoaderShoot1B", "Starstorm"),
	shoot13 = Sprite.find("NemesisLoaderShoot1C", "Starstorm"),
	shoot2 = Sprite.find("NemesisLoaderShoot3", "Starstorm"),
	shoot4 = Sprite.find("NemesisLoaderShoot4", "Starstorm"),
	shoot5 = Sprite.load("NemesisLoaderShoot5", path.."Shoot5", 7, 13, 11)
}, Color.fromHex(0x829951))
SurvivorVariant.setInfoStats(NemesisLoader, {{"Strength", 7}, {"Vitality", 5}, {"Toughness", 3}, {"Agility", 4}, {"Difficulty", 5}, {"selfishness", 8}})
SurvivorVariant.setDescription(NemesisLoader, "With a total of 4 mechanical arms, the &y&Nemesis Loader&!& carries the heaviest of military cargo while making sure nobody carries him.")

local sprSkills = Sprite.load("NemesisLoaderSkill", path.."Skills", 4, 0, 0)
SurvivorVariant.setLoadoutSkill(NemesisLoader, "Hydraulic Catch", "Grab an enemy in front of you and keep it in range.", sprSkills, 1)
SurvivorVariant.setLoadoutSkill(NemesisLoader, "Integrated Conduit", "Fire a gauntlet. After hitting a foe, lightning surges, dealing 80% damage per second for 7 seconds. Sticks to the last enemy in range.", sprSkills, 4)

NemesisLoader.endingQuote = "..and so he left, exhausted of his profession."

local sShoot3 = Sound.find("NemesisLoaderShoot3", "Starstorm")
local sShoot4 = Sound.find("NemesisLoaderShoot4", "Starstorm")

callback.register("onSkinInit", function(player, skin)
	if skin == NemesisLoader then
		--player:set("pHmax", player:get("pHmax") - 0.15)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(166, 10, 0.045)
		else
			player:survivorSetInitialStats(116, 10, 0.015)
		end
		player:setSkill(3,
		"Hydraulic Catch",
		"Grab an enemy in front of you and keep it in range.",
		sprSkills, 1, 4 * 60)
		player:setSkill(4,
		"Integrated Conduit",
		"Fire a gauntlet. After hitting a foe, lightning surges, dealing 80% damage per second for 7 seconds.",
		sprSkills, 3, 10 * 60)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == NemesisLoader then
		player:survivorLevelUpStats(1, 0, 0, -0.001)
	end
end)

survivor:addCallback("scepter", function(player)
	if SurvivorVariant.getActive(player) == NemesisLoader then
		player:setSkill(4,
		"Radiance Mk.2 Conduit",
		"Fire a gauntlet. After hitting a foe, lightning surges, dealing 80% damage per second for 7 seconds.",
		sprSkills, 3, 9 * 60)
	end
end)

SurvivorVariant.setSkill(NemesisLoader, 3, function(player)
	player:set("activity_var1", -1)
	player:getData().resetSkillFix = true
	--SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3"), 0.25, false, true)
	--player:set("activity_var1", -1)
end)

sur.Loader:addCallback("useSkill", function(player, skill)
	if SurvivorVariant.getActive(player) == NemesisLoader and skill == 4 then
		if player:get("activity") ~= 4.01 then
			player:setAlarm(5, math.ceil((1 - player:get("cdr")) * (10 * 60)))
			local playerAc = player:getAccessor()
			local playerData = player:getData()
			local index = 4
			local iindex = index + 0.01
			local sprite
			if player:get("scepter") > 0 then
				sprite = player:getAnimation("shoot5")
			else
				sprite = player:getAnimation("shoot4")
			end
			local scaleSpeed = false
			local resetHSpeed = true
			local speed = 0.25
			
			if playerAc.dead == 0 then
				playerAc.activity = iindex
				playerAc.activity_type = 1
				
				playerData.variantSkillUse = {index = index, sprite = sprite, speed = speed, scaleSpeed = scaleSpeed, resetHSpeed = resetHSpeed}--, frame = 1}
				
				player.sprite = sprite
				player.subimage = 1
				
				if resetHSpeed and playerAc.free == 0 then
					playerAc.pHspeed = 0
				end
			end
		end
		
		for _, obj in ipairs (obj.ConsRod:findMatching("parent", player.id)) do
			obj:destroy()
			sfx.JanitorShoot1_1:stop()
		end
	end
end)

local objNemLoaderGrapple = Object.find("NemLoaderGrapple", "Starstorm")
local objNemLoaderRod = Object.find("NemLoaderRod", "Starstorm")

sur.Loader:addCallback("step", function(player)
	if SurvivorVariant.getActive(player) == NemesisLoader then
		if player:getData().resetSkillFix and player.subimage >= player.sprite.frames then
			player:set("activity", 0)
			player:set("activity_type", 0)
			player:getData().resetSkillFix = nil
		end
		for _, obj in ipairs (obj.ConsRod:findMatching("parent", player.id)) do
			obj:destroy()
		end
	end
end)
callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
	if variant == NemesisLoader then
		if skill == 3 then
			player.spriteSpeed = math.min(0.25 * player:get("attack_speed"), 1)
			if relevantFrame == 1 then
				sShoot3:play(0.9 + math.random() * 0.2)
			end
			if relevantFrame == 7 then
				local rod = objNemLoaderGrapple:create(player.x, player.y - 4)
				rod:set("direction", player:getFacingDirection())
				rod.xscale = player.xscale
				rod:getData().parent = player
				rod:getData().team = player:get("team")
			end
		elseif skill == 4 then
			if relevantFrame == 4 then
				local rod = objNemLoaderRod:create(player.x, player.y - 4)
				rod:set("direction", player:getFacingDirection())
				rod.xscale = player.xscale
				rod:getData().parent = player
				rod:getData().team = player:get("team")
				if player:get("scepter") > 0 then
					rod:getData().color = Color.fromHex(0xDE5BFF)
					rod:getData().rate = 15
				end
				sShoot4:play(0.9 + math.random() * 0.2)
			end
		end
	end
end)