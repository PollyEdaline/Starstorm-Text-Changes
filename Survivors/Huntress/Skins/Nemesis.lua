if not global.rormlflag.ss_disable_enemies then

-- NEMESIS HUNTRESS

local path = "Survivors/Huntress/Skins/Nemesis/"

local survivor = sur.Huntress
local sprSelect = Sprite.load("NemesisHuntresSelect", path.."Select", 18, 2, 0)
local sprShoot1 = Sprite.find("NemesisHuntressShoot1", "Starstorm")
local NemesisHuntress = SurvivorVariant.new(survivor, "Nemesis Huntress", sprSelect, {
	idle = Sprite.find("NemesisHuntressIdle", "Starstorm"),
	idlehalf = Sprite.find("NemesisHuntressIdleHalf", "Starstorm"),
	walk = Sprite.find("NemesisHuntressWalk", "Starstorm"),
	walkhalf = Sprite.find("NemesisHuntressWalkHalf", "Starstorm"),
	jump = Sprite.find("NemesisHuntressJump", "Starstorm"),
	jumpHalf = Sprite.find("NemesisHuntressJumpHalf", "Starstorm"),
	climb = Sprite.find("NemesisHuntressClimb", "Starstorm"),
	death = Sprite.find("NemesisHuntressDeath", "Starstorm"),
	decoy = Sprite.load("NemesisHuntressDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1 = sprShoot1, -- spr.Nothing,
	shoot2 = Sprite.find("NemesisHuntressShoot2", "Starstorm"),
	shoot4 = Sprite.find("NemesisHuntressShoot4", "Starstorm"),
	shoot5 = Sprite.find("NemesisHuntressShoot5", "Starstorm"),
}, Color.fromHex(0x4DF9DD))
SurvivorVariant.setInfoStats(NemesisHuntress, {{"Strength", 8}, {"Vitality", 3.5}, {"Toughness", 2}, {"Agility", 7}, {"Difficulty", 5}, {"Style", 7}})
SurvivorVariant.setDescription(NemesisHuntress, "The &y&Nemesis Huntress&!& engages enemies slowly but ruthlessly with her deadly longbow and double headed hatchet.")
NemesisHuntress.forceApply = true

NemesisHuntress.endingQuote = "..and so she left, finding a new home far away."

local sprSkill = Sprite.load("NemesisHuntressSkill", path.."Skills", 5, 0, 0)
local sprOriginalSkills = spr.Huntress1Skills
local sShootCharged = Sound.load("NemesisHuntressChargedShot", path.."chargedShot")
local sCharge = Sound.load("NemesisHuntressCharge", path.."charge")

local sprCape = Sprite.find("NemesisHuntressCape", "Starstorm")

SurvivorVariant.setLoadoutSkill(NemesisHuntress, "Packed Bolt", "&y&Hold to charge&!&, releasing to fire up to 7 bolts for &y&7x140% damage&!&.", sprSkill)
SurvivorVariant.setLoadoutSkill(NemesisHuntress, "Laser Hatchet", "Throw a &y&piercing hatchet&!& towards the nearest enemy, dealing &y&600% damage&!&.", sprSkill, 2)

callback.register("onSkinInit", function(player, skin)
	if skin == NemesisHuntress then
		player:set("pHmax", player:get("pHmax") - 0.05)
		player:set("attack_speed", player:get("attack_speed") - 0.4)
		player:getData().chargeLvl = 0
		player:getData().hold = nil
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(144, 10.5, 0.05)
		else
			player:survivorSetInitialStats(94, 10.5, 0.02)
		end
		player:setSkill(1,
		"Packed Bolt",
		"Hold to charge relasing to fire up to 7 bolts for 7x140% damage. You can shoot while moving.",
		sprSkill, 1, 25)
		player:setSkill(2,
		"Laser Hatchet",
		"Throw a piercing hatchet towards the nearest enemy, dealing 600% damage.",
		sprSkill, 2, 60 * 6)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == NemesisHuntress then
		player:survivorLevelUpStats(3, -0.5, 0, -0.5)
		player:set("attack_speed", player:get("attack_speed") - 0.025)
	end
end)

local objNHuntressHatchet = Object.find("NHuntressHatchet", "Starstorm")

local onPlayerDrawBelowCall = function(player)
	if player:getSurvivor() == survivor and SurvivorVariant.getActive(player) == NemesisHuntress and player:get("activity") ~= 30 then
		local subi = 1
		local yy = 0
		if player:get("free") == 1 then
			if player:get("pVspeed") > 6.5 then
				subi = 4
			elseif player:get("pVspeed") > 3.5 then
				subi = 3
			elseif player:get("pVspeed") > 0.5 then
				subi = 2
			end
		elseif player:get("pHspeed") ~= 0 then
			subi = 2
			--if player.sprite == player:getAnimation("walk") then
				if math.floor((player.subimage + 1) % 4) == 0 or math.floor((player.subimage + 2) % 4) == 0 then
					yy = 1
				end
			--end
		end
		graphics.drawImage{
			image = sprCape,
			x = player.x,
			y = player.y + yy,
			xscale = player.xscale,
			yscale = player.yscale,
			alpha = player.alpha,
			color = player.blendColor,
			angle = player.angle,
			subimage = subi
		}
	end
end
survivor:addCallback("step", function(player)
	if SurvivorVariant.getActive(player) == NemesisHuntress then
		for _, boomerang in ipairs(obj.HuntressBoomerang:findMatching("parent", player.id)) do
			if not boomerang:getData()._skinCheck then
				boomerang:set("speed", boomerang:get("speed") + 1)
				local bullet = objNHuntressHatchet:create(boomerang.x, boomerang.y)
				bullet:getData().parent = player
				bullet:set("direction", boomerang:get("direction"))
				if boomerang:get("direction") ~= 0 then
					bullet:getData().invertSpin = true
				end
				boomerang.x = 0
				boomerang.y = -300
				boomerang:setAlarm(1, 1)
				boomerang:getData()._skinCheck =  true
			end
		end
	end
end)

local postStepCall = function()
	for _, arrow in ipairs(obj.HuntressBolt1:findAll()) do
		local p = Object.findInstance(arrow:get("parent"))
		if p and p:isValid() and isa(p, "PlayerInstance") and SurvivorVariant.getActive(p) == NemesisHuntress then
			if not arrow:getData().skin_checked then
				arrow:getData().skin_checked = true
				if p:getData().hold then
					arrow:destroy()
					sfx.HuntressShoot1:stop()
					p:getData().missingArrow = true
				else
					arrow:set("speed", arrow:get("speed") + 1)
					local mult = math.floor(p:getData().chargeLvl)
					local doTrail = p:get("free") == 1
					local playerxscale2 = p:get("image_xscale2")
					if mult == 3 then 
						--mult = 4
						sShootCharged:play(0.9 + math.random() * 0.2)
					end
					for i = -mult, mult do
						if i ~= 0 then
							--[[local bullet = obj.HuntressBolt1:create(arrow.x, arrow.y + i * 2)
							bullet:set("parent", p.id)
							bullet:set("direction", arrow:get("direction") + 3 * i * (playerxscale2 * -1))
							bullet:getData().skin_checked = true
							bullet:getData().correct = arrow:get("direction") + 3 * i * (playerxscale2)
							bullet:set("speed", bullet:get("speed") * (1 - 0.1 * i))]]
							
							local bullet = obj.NHuntressArrow:create(arrow.x, arrow.y + i * 2)
							bullet:getData().parent = p
							bullet:set("direction", arrow:get("direction") + 3 * i * (playerxscale2 * -1))
							bullet:getData().targetAngle = arrow:get("direction") + 3 * i * (playerxscale2)
							bullet:getData().doTrail = doTrail
							bullet:set("speed", 10 * (1 - 0.1 * math.abs(i)))
							bullet:getData().climb = i
							--bullet:set("speed", bullet:get("speed") * (1 - 0.1 * i))
						end
					end
					if mult > 0 then
						misc.shakeScreen(4 * mult)
					end
				end
			end
			--arrow.y = arrow.y + math.sin(global.timer) * 0.15
			--if arrow:getData().correct then
			--	arrow:set("direction", arrow:get("direction") + (angleDif(arrow:get("direction"), arrow:getData().correct) * -0.0235))
			--end
		end
	end
end

survivor:addCallback("useSkill", function(player, skill)
	if SurvivorVariant.getActive(player) == NemesisHuntress then
		if skill == 1 then
			player:getData().hold = true
			player:getData().chargeLvl = 0
		end
	end
end)

callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
	if variant == NemesisHuntress then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		if skill == 1 then
			if syncControlRelease(player, "ability1") then
				if playerData.hold then
					playerData.hold = nil
					playerAc.image_index2 = 4
					if playerData.missingArrow then
						playerData.missingArrow = nil
						sfx.HuntressShoot1:play(0.9 + math.random() * 0.2)
						local bullet = obj.HuntressBolt1:create(player.x, player.y)
						bullet:set("parent", player.id)
						local dir = 0
						if playerAc.image_xscale2 < 0 then
							dir = 180
							bullet.xscale = -1
						end
						bullet:set("direction", dir)
					end
				end
			end
			
			if playerAc.image_index2 <= 3 and playerData.hold then
				
				local possibleNearest = nil
				for _, actor in ipairs(pobj.actors:findAllLine(player.x - 500, player.y, player.x + 500, player.y)) do
					if actor:get("team") ~= playerAc.team then
						local actorDistance = distance(actor.x, actor.y, player.x, player.y)
						if not possibleNearest or actorDistance < possibleNearest.distance then
							possibleNearest = {instance = actor, distance = actorDistance}
						end
					end
				end
				
				if possibleNearest and possibleNearest.instance:isValid() and not Stage.collidesRectangle(possibleNearest.instance.x, player.y, player.x, player.y + 1) then
					playerAc.image_xscale2 = math.sign(possibleNearest.instance.x - player.x)
				else
					playerAc.image_xscale2 = player.xscale
				end
				if playerAc.attack_speed <= 3.4 then
					playerAc.image_index2 = playerAc.image_index2 - (0.24 * math.min(playerAc.attack_speed, 3.4))
				end
			end
			if playerData.hold then
				if playerAc.image_index2 > 3 then
					playerAc.image_index2 = 3
				end
				if playerAc.image_index2 >= 0 and math.floor(playerAc.image_index2) > playerData.chargeLvl then
					playerData.chargeLvl = math.floor(playerAc.image_index2)
					if playerData.chargeLvl == 3 then
						--local c = Object.find("EfCircle"):create(player.x, player.y)
						--c:set("radius", 0)
						--c.blendColor = Color.fromHex(0x4DF9DD)
						ParticleType.find("spark"):burst("middle", player.x, player.y, 3)
						--relevantFrame = 4
						sCharge:play(1 + math.random() * 0.2)
					end
				end
			end
		end
	end
end)
callback.register("onSkinInit", function(player, skin)
	if skin == NemesisHuntress then
		tcallback.register("onPlayerDrawBelow", onPlayerDrawBelowCall)
		tcallback.register("postStep", postStepCall)
	end
end)
end