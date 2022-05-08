-- NEMESIS ACRID

local path = "Survivors/Acrid/Skins/Nemesis/"

local survivor = sur.Acrid
local sprSelect = Sprite.load("NemesisAcridSelect", path.."Select", 14, 2, 0)
local NemesisAcrid = SurvivorVariant.new(survivor, "Nemesis Acrid", sprSelect, {
	idle = Sprite.load("NemesisAcridIdle", path.."Idle", 1, 15, 8),
	walk = Sprite.load("NemesisAcridWalk", path.."Walk", 9, 30, 11),
	jump = Sprite.load("NemesisAcridJump", path.."Jump", 1, 9, 11),
	climb = Sprite.load("NemesisAcridClimb", path.."Climb", 2, 7, 15),
	death = Sprite.load("NemesisAcridDeath", path.."Death", 15, 12, 16),
	decoy = Sprite.load("NemesisAcridDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.load("NemesisAcridShoot1A", path.."Shoot1_1", 6, 15, 15),
	shoot1_2 = Sprite.load("NemesisAcridShoot1B", path.."Shoot1_2", 6, 15, 22),
	shoot2 = Sprite.load("NemesisAcridShoot2", path.."Shoot2", 9, 15, 15),
	shoot4 = Sprite.load("NemesisAcridShoot4", path.."Shoot4", 7, 15, 15),
	shoot5 = Sprite.load("NemesisAcridShoot5", path.."Shoot5", 7, 15, 15),
}, Color.fromHex(0xFF703D))
SurvivorVariant.setInfoStats(NemesisAcrid, {{"Strength", 5}, {"Vitality", 8}, {"Toughness", 1}, {"Agility", 6}, {"Difficulty", 6}, {"Natural Order", 1}})
SurvivorVariant.setDescription(NemesisAcrid, "rawr.")

local sprSkills = Sprite.load("NemesisAcridSkill", path.."Skills", 1, 0, 0)
--local sShoot = Sound.load("NemesisAcridShoot1", path.."Shoot1")
local sprSparks = spr.Sparks5

SurvivorVariant.setLoadoutSkill(NemesisAcrid, "Corroding Spit", "Shoot corrosive matter, dealing &y&140% corrosive damage&!&.", sprSkills)

NemesisAcrid.endingQuote = "..and so he left, with a new thirst: foreign blood."

callback.register("onSkinInit", function(player, skin)
	if skin == NemesisAcrid then
		player:set("armor", player:get("armor") - 15)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(124, 12, 0.065)
		else
			player:survivorSetInitialStats(74, 12, 0.035)
		end
		player:setSkill(1,
		"Corrosion",
		"Shoot corrosive matter, dealing 140% corrosive damage.",
		sprSkills, 1, 40)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == NemesisAcrid then
		player:survivorLevelUpStats(-12, 0, 0.003, -1)
	end
end)
SurvivorVariant.setSkill(NemesisAcrid, 3, function(player)
	SurvivorVariant.activityState(player, 3, player:getAnimation("shoot1_1"), 0.25, true, true)
end)
callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
	if variant == NemesisAcrid then
		local playerAc = player:getAccessor()
		if skill == 1 then
			if relevantFrame == 4 then
				if onScreen(player) then
					misc.shakeScreen(1)
				end
				--sShoot:play(math.random(8, 11)/10)
				if not player:survivorFireHeavenCracker(1.4) then
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 340, 1.4, sprSparks)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			end
		end
		
	end
end)