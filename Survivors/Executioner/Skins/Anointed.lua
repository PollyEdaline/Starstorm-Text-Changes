-- ANOINTED

local path = "Survivors/Executioner/Skins/Anointed/"

local survivor = Survivor.find("Executioner", "Starstorm")
local sprSelect = Sprite.load("AExecutionerSelect", path.."Select", 17, 2, 0)
local AExecutioner = SurvivorVariant.new(survivor, "Anointed Executioner", sprSelect, {
	idle = Sprite.load("AExecutionerIdle", path.."idle", 1, 4, 6),
	walk = Sprite.load("AExecutionerWalk", path.."walk", 8, 5, 7),
	jump = Sprite.load("AExecutionerJump", path.."jump", 1, 4, 6),
	climb = Sprite.load("AExecutionerClimb", path.."climb", 2, 4, 7),
	death = Sprite.load("AExecutionerDeath", path.."death", 5, 7, 3),
	decoy = Sprite.load("AExecutionerDecoy", path.."decoy", 1, 9, 10),
	
	shoot1 = Sprite.load("AExecutionerShoot1", path.."shoot1", 4, 9, 10),
	shoot2 = Sprite.load("AExecutionerShoot2", path.."shoot2", 22, 9, 10),
	shoot3 = Sprite.load("AExecutionerShoot3", path.."shoot3", 8, 24, 20),
	shoot4 = Sprite.load("AExecutionerShoot4", path.."shoot4", 14, 17, 34),
	shoot5 = Sprite.load("AExecutionerShoot5", path.."shoot5", 14, 17, 34),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(AExecutioner, {{"Strength", 9}, {"Vitality", 3}, {"Toughness", 2}, {"Agility", 6}, {"Difficulty", 4}, {"Emotion", 0}})
SurvivorVariant.setDescription(AExecutioner, "The despaired warrior is enlightened, wielding energy of a new kind.")

callback.register("onSkinInit", function(player, skin)
	if skin == AExecutioner then
		player:getData()._EfColor = Color.fromHex(0x668EFF)
	end
end)