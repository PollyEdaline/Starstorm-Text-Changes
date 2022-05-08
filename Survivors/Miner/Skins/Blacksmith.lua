-- BLACKSMITH

local path = "Survivors/Miner/Skins/Blacksmith/"

local survivor = sur.Miner
local sprSelect = Sprite.load("BlacksmithSelect", path.."Select", 15, 2, 0)
local Blacksmith = SurvivorVariant.new(survivor, "Blacksmith", sprSelect, {
	idle = Sprite.load("BlacksmithIdle", path.."Idle", 1, 6, 5),
	walk = Sprite.load("BlacksmithWalk", path.."Walk", 8, 6, 6),
	jump = Sprite.load("BlacksmithJump", path.."Jump", 1, 5, 6),
	climb = Sprite.load("BlacksmithClimb", path.."Climb", 2, 4, 6),
	death = Sprite.load("BlacksmithDeath", path.."Death", 5, 14, 11),
	decoy = Sprite.load("BlacksmithDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1 = Sprite.load("BlacksmithShoot1", path.."Shoot1", 8, 6, 16),
	shoot2 = Sprite.load("BlacksmithShoot2", path.."Shoot2", 6, 23, 6),
	shoot3 = Sprite.load("BlacksmithShoot3", path.."Shoot3", 11, 7, 6),
	shoot4 = Sprite.load("BlacksmithShoot4", path.."Shoot4", 8, 24, 4),
}, Color.fromHex(0x872F2A))
SurvivorVariant.setInfoStats(Blacksmith, {{"Strength", 8}, {"Vitality", 6}, {"Toughness", 4}, {"Agility", 9}, {"Difficulty", 4}, {"Burns", 10}})
SurvivorVariant.setDescription(Blacksmith, "The &y&Blacksmith&!&'s durability and strength make him feared by creatures and humans alike. Nobody knows who is behind the mask anymore. Each one of his attacks deal &y&blazing damage&!&.")

local sprSkill = Sprite.load("BlacksmithSkill", path.."Skill", 1, 0, 0)
local sprSparks = spr.Sparks7
local sShoot = Sound.load("BlacksmithShoot1", path.."Shoot1")

SurvivorVariant.setLoadoutSkill(Blacksmith, "Forged Slash", "Cut through enemies for &y&180% damage&!&.", sprSkill)

Blacksmith.endingQuote = "..and so he left, scarred for eternity."

local onFireSetProcsCall = function(damager, parent)
	if parent and parent:isValid() and isa(parent, "PlayerInstance") and SurvivorVariant.getActive(parent) == Blacksmith then
		damager:getData().skinFireDamage = 3
	end
end

callback.register("onSkinInit", function(player, skin)
	if skin == Blacksmith then
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(169, 11.5, 0.05)
		else
			player:survivorSetInitialStats(119, 11.5, 0.02)
		end
		player:set("pHmax", player:get("pHmax") - 0.1)
		player:setSkill(1,
		"Forged Slash",
		"Cut through enemies for 180% damage.",
		sprSkill, 1, 50)
		tcallback.register("onFireSetProcs", onFireSetProcsCall)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Blacksmith then
		player:survivorLevelUpStats(2, -0.2, 0, 0)
		player:set("attack_speed", player:get("attack_speed") - 0.025)
	end
end)
SurvivorVariant.setSkill(Blacksmith, 1, function(player)
	SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1"), 0.2, true, true)
end)
callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
	if variant == Blacksmith then
		local playerAc = player:getAccessor()
		if skill == 1 then
			if relevantFrame == 4 then
				sShoot:play(1 + math.random() * 0.2)
				if not skinFireHeavenCracker(player) then
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x + (-3 * player.xscale), player.y, player:getFacingDirection(), 45, 1.8, nil, DAMAGER_BULLET_PIERCE)
						bullet:getData().skin_spark = sprSparks
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			end
		end
	end
end)