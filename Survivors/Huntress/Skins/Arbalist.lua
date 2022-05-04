-- ARBALIST

local path = "Survivors/Huntress/Skins/Arbalist/"

local survivor = sur.Huntress
local sprSelect = Sprite.load("ArbalistSelect", path.."Select", 16, 2, 0)
local Arbalist = SurvivorVariant.new(survivor, "Arbalist", sprSelect, {
	idle = Sprite.load("ArbalistIdle", path.."Idle", 1, 3, 5),
	idlehalf = Sprite.load("ArbalistIdleHalf", path.."IdleHalf", 1, 3, 5),
	walk = Sprite.load("ArbalistWalk", path.."Walk", 8, 4, 5),
	walkhalf = Sprite.load("ArbalistWalkHalf", path.."WalkHalf", 8, 4, 5),
	jump = Sprite.load("ArbalistJump", path.."Jump", 1, 3, 6),
	climb = Sprite.load("ArbalistClimb", path.."Climb", 2, 2, 6),
	death = Sprite.load("ArbalistDeath", path.."Death", 10, 14, 3),
	decoy = Sprite.load("ArbalistDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1 = Sprite.load("ArbalistShoot1", path.."Shoot1", 9, 6, 6),
	shoot2 = Sprite.load("ArbalistShoot2", path.."Shoot2", 9, 10, 7),
	shoot4 = Sprite.load("ArbalistShoot4", path.."Shoot4", 10, 15, 12),
	shoot5 = Sprite.load("ArbalistShoot5", path.."Shoot5", 10, 15, 12),
}, Color.fromHex(0x9851AA))
SurvivorVariant.setInfoStats(Arbalist, {{"Strength", 6.5}, {"Vitality", 4}, {"Toughness", 1.5}, {"Agility", 6}, {"Difficulty", 6.5}, {"Temperament", 6.5}})
SurvivorVariant.setDescription(Arbalist, "A lower firerate with an extra arrow every attack makes the &y&Arbalist&!& a highly versatile alternative to common archery.")
Arbalist.forceApply = true

Arbalist.endingQuote = "..and so she left, unwilling to relive the catastrophe."

local sprSkill = Sprite.load("ArbalistSkill", path.."Skill", 1, 0, 0)
local sprOriginalSkills = spr.Huntress1Skills
local sShoot = sfx.HuntressShoot1

SurvivorVariant.setLoadoutSkill(Arbalist, "Dual Serving", "Each &b&attack ability &y&fires an extra shot in front of you.", sprSkill)

callback.register("onSkinInit", function(player, skin)
	if skin == Arbalist then
		player:set("pHmax", player:get("pHmax") - 0.05)
		player:set("pVmax", player:get("pVmax") + 0.5)
		player:set("attack_speed", player:get("attack_speed") - 0.4)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(148, 10.5, 0.05)
		else
			player:survivorSetInitialStats(98, 10.5, 0.02)
		end
		player:setSkill(1,
		"Dual Serving",
		"Fire two arrows for 120% damage. You can shoot while moving.",
		sprSkill, 1, 43)
		player:setSkill(2,
		"Laser Glaives",
		"Throw two glaives that bounce to up to 4 enemies for 300% damage. Damage increases by 30% per bounce.",
		sprOriginalSkills, 2, 60 * 4)
		player:setSkill(4,
		"Dual Serving",
		"Fire two explosive arrows for 320% damage. The arrows drop bomblets that detonate for 6x80%.",
		sprOriginalSkills, 4, 60 * 7)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Arbalist then
		player:survivorLevelUpStats(3, -0.5, 0, -0.5)
		player:set("attack_speed", player:get("attack_speed") - 0.025)
	end
end)
survivor:addCallback("useSkill", function(player, skill)
	local playerAc = player:getAccessor()
	if SurvivorVariant.getActive(player) == Arbalist then
		local bullet = nil
		if skill == 1 then
			bullet = obj.HuntressBolt1:create(player.x + 12 * player.xscale, player.y)
		elseif skill == 2 then
			bullet = obj.HuntressBoomerang:create(player.x + 12 * player.xscale, player.y)
		elseif skill == 4 then
			if player:get("scepter") > 0 then
				bullet = obj.HuntressBolt3:create(player.x + 12 * player.xscale, player.y)
			else
				bullet = obj.HuntressBolt2:create(player.x + 12 * player.xscale, player.y)
			end
		end
		if bullet then
			sShoot:play(0.9 + math.random() * 0.2)
			bullet:set("parent", player.id)
			bullet:set("direction", player:getFacingDirection())
		end
	end
end)