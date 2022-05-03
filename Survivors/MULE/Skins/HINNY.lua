-- HINNY

local path = "Survivors/MULE/Skins/HINNY/"

local survivor = Survivor.find("MULE", "Starstorm")
local sprSelect = Sprite.load("HINNYSelect", path.."Select", 16, 2, 0)
local HINNY = SurvivorVariant.new(survivor, "HINNY", sprSelect, {
	idle = Sprite.load("HINNYIdle", path.."Idle", 1, 7, 10),
	walk = Sprite.load("HINNYWalk", path.."Walk", 8, 9, 13),
	jump = Sprite.load("HINNYJump", path.."Jump", 1, 6, 11),
	climb = Sprite.load("HINNYClimb", path.."Climb", 2, 5, 9),
	death = Sprite.load("HINNYDeath", path.."Death", 6, 9, 12),
	decoy = Sprite.load("HINNYDecoy", path.."Decoy", 1, 9, 13),
	
	shoot1_1 = Sprite.load("HINNYShoot1A", path.."Shoot1_1", 6, 9, 11),
	shoot1_2_1 = Sprite.load("HINNYShoot1B1", path.."Shoot1_2_1", 6, 6, 11),
	shoot1_2_2 = Sprite.load("HINNYShoot1B2", path.."Shoot1_2_2", 6, 6, 11),
	shoot1_3 = Sprite.load("HINNYShoot1C", path.."Shoot1_3", 6, 6, 11),
	shoot2 = Sprite.load("HINNYShoot2", path.."Shoot2", 7, 10, 11),
	shoot3 = Sprite.load("HINNYShoot3", path.."Shoot3", 15, 15, 12),
	shoot4 = Sprite.load("HINNYShoot4", path.."Shoot4", 15, 13, 18),
	shoot4 = Sprite.load("HINNYShoot5", path.."Shoot5", 15, 13, 18),
	
	drone1_1 = Sprite.load("HINNY_DroneA", path.."dronea", 4, 5, 5),
	drone1_2 = Sprite.load("HINNY_DroneA_Repair", path.."droneaRegen", 2, 5, 5),
	drone2_1 = Sprite.load("HINNY_DroneB", path.."droneb", 4, 6, 6),
	drone2_2 = Sprite.load("HINNY_DroneB_Repair", path.."dronebRegen", 2, 6, 6)
}, Color.fromHex(0x8882C4))
SurvivorVariant.setInfoStats(HINNY, {{"Strength", 8}, {"Vitality", 5}, {"Toughness", 4}, {"Agility", 6}, {"Difficulty", 4}, {"Social Skills", 0}})
SurvivorVariant.setDescription(HINNY, ".")

local sprSkill = Sprite.load("HINNYSkill", path.."Skill", 1, 0, 0)
local sShoot = Sound.load("HINNYShoot1", path.."Shoot1")
local sShootOriginal = Sound.find("MULEShoot1", "Starstorm")

SurvivorVariant.setLoadoutSkill(HINNY, "", ".", sprSkill)

callback.register("onSkinInit", function(player, skin)
	if skin == HINNY then
		player:getData().skin_skill1Override = true
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(152, 12, 0.042)
		else
			player:survivorSetInitialStats(102, 12, 0.012)
		end
		player:setSkill(1,
		"",
		".",
		sprSkill, 1, 23)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == HINNY then
		player:survivorLevelUpStats(5, -2, 0.002, 1)
	end
end)
survivor:addCallback("onSkill", function(player, skill, relevantFrame)
	if SurvivorVariant.getActive(player) == HINNY then
		local playerAc = player:getAccessor()
		if skill == 1 then
			if relevantFrame == 1 then
				
			end
		end
		
	end
end)