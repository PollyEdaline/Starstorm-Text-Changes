-- ACERBID

local path = "Survivors/Acrid/Skins/Acerbid/"

local survivor = sur.Acrid
local sprSelect = Sprite.load("AcerbidSelect", path.."Select", 14, 2, 0)
local Acerbid = SurvivorVariant.new(survivor, "Acerbid", sprSelect, {
	idle = Sprite.load("AcerbidIdle", path.."Idle", 1, 15, 10),
	walk = Sprite.load("AcerbidWalk", path.."Walk", 8, 10, 14),
	jump = Sprite.load("AcerbidJump", path.."Jump", 1, 9, 11),
	climb = Sprite.load("AcerbidClimb", path.."Climb", 2, 7, 15),
	death = Sprite.load("AcerbidDeath", path.."Death", 15, 12, 16),
	decoy = Sprite.load("AcerbidDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.load("AcerbidShoot1A", path.."Shoot1A", 6, 15, 15),
	shoot1_2 = Sprite.load("AcerbidShoot1B", path.."Shoot1B", 6, 15, 15),
	shoot2 = Sprite.load("AcerbidShoot2", path.."Shoot2", 9, 15, 15),
	shoot4 = Sprite.load("AcerbidShoot4", path.."Shoot4", 7, 15, 15),
	shoot5 = Sprite.load("AcerbidShoot5", path.."Shoot5", 7, 15, 15),
}, Color.fromHex(0x5A38C1))
SurvivorVariant.setInfoStats(Acerbid, {{"Strength", 5}, {"Vitality", 8}, {"Toughness", 1}, {"Agility", 6}, {"Difficulty", 6}, {"Natural Order", 1}})
SurvivorVariant.setDescription(Acerbid, "The &y&Acerbid&!& is a mysterious, acid-spitting creature. It is thought to be nearly immortal, due to its incredible regenerative ability.")

local sprSkill = Sprite.load("AcerbidSkill", path.."Skill", 1, 0, 0)
local sShoot = Sound.load("AcerbidShoot1", path.."Shoot1")
local sprSparks = spr.Sparks5

SurvivorVariant.setLoadoutSkill(Acerbid, "Corroding Spit", "Shoot corrosive matter, dealing &y&140% corrosive damage&!&.", sprSkill)

Acerbid.endingQuote = "..and so it left, leaving a trail of what it once was."

callback.register("onSkinInit", function(player, skin)
	if skin == Acerbid then
		player:set("armor", player:get("armor") - 15)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(124, 12, 0.065)
		else
			player:survivorSetInitialStats(74, 12, 0.035)
		end
		player:setSkill(1,
		"Corrosion",
		"Shoot corrosive matter, dealing 140% corrosive damage.",
		sprSkill, 1, 40)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Acerbid then
		player:survivorLevelUpStats(-12, 0, 0.003, -1)
	end
end)
SurvivorVariant.setSkill(Acerbid, 1, function(player)
	SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_1"), 0.25, true, true)
end)
callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
	if variant == Acerbid then
		local playerAc = player:getAccessor()
		if skill == 1 then
			if relevantFrame == 4 then
				if onScreen(player) then
					misc.shakeScreen(1)
				end
				sShoot:play(math.random(8, 11)/10)
				if not player:survivorFireHeavenCracker(1.4) then
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 340, 1.4, sprSparks)
						DOT.addToDamager(bullet, DOT_CORROSION, player:get("damage") * 0.5, 4, "acerbid", false)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			end
		end
		
	end
end)