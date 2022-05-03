-- ANOINTED

local path = "Survivors/Knight/Skins/Anointed/"

local survivor = Survivor.find("Knight", "Starstorm")
local sprSelect = Sprite.load("KnightSelect", path.."Select", 19, 2, 0)
local AKnight = SurvivorVariant.new(survivor, "Anointed Knight", sprSelect, {
	idle = Sprite.load("AKnight_Idle", path.."idle", 1, 8, 12),
	walk = Sprite.load("AKnight_Walk", path.."walk", 8, 8, 12),
	jump = Sprite.load("AKnight_Jump", path.."jump", 1, 8, 12),
	climb = Sprite.load("AKnight_Climb", path.."climb", 2, 4, 8),
	death = Sprite.load("AKnight_Death", path.."death", 9, 9, 11),
	decoy = sprite,
	
	shoot1_1 = Sprite.load("AKnight_Shoot1_1", path.."shoot1_1", 4, 8, 14),
	shoot1_2 = Sprite.load("AKnight_Shoot1_2", path.."shoot1_2", 4, 8, 16),
	shoot1_3 = Sprite.load("AKnight_Shoot1_3", path.."shoot1_3", 6, 8, 12),
	shoot2 = Sprite.load("AKnight_Shoot2", path.."shoot2", 5, 8, 12),
	shoot3 = Sprite.load("AKnight_Shoot3", path.."shoot3", 7, 10, 22),
	shoot4 = Sprite.load("AKnight_Shoot4", path.."shoot4", 18, 17, 19),
	shoot4ef = Sprite.load("AKnight_Shoot4Ef", path.."shoot4ef", 5, 76, 19)
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(AKnight, {{"Strength", 6}, {"Vitality", 4}, {"Toughness", 5}, {"Agility", 5}, {"Difficulty", 5}, {"Fealty", 10}})
SurvivorVariant.setDescription(AKnight, "The honorable warrior is enlightened, as he readies his sword for another battle.")