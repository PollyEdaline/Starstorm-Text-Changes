-- ANOINTED

local path = "Survivors/DU-T/Skins/Anointed/"

local survivor = Survivor.find("DU-T", "Starstorm")
local sprSelect = Sprite.load("ADU-TSelect", path.."Select", 18, 2, 0)
local ADut = SurvivorVariant.new(survivor, "Anointed DU-T", sprSelect, {
	idle = Sprite.load("ADU-T_Idle", path.."idle", 1, 7, 12),
	walk = Sprite.load("ADU-T_Walk", path.."walk", 8, 15, 12),
	jump = Sprite.load("ADU-T_Jump", path.."jump", 1, 7, 15),
	climb = Sprite.load("ADU-T_Climb", path.."climb", 2, 4, 11),
	death = Sprite.load("ADU-T_Death", path.."death", 10, 10, 15),
	decoy = Sprite.load("ADU-T_Decoy", path.."decoy", 1, 9, 14),
	
	shoot1_1 = Sprite.load("ADU-T_Shoot1_1", path.."shoot1_1", 3, 7, 12),
	shoot1_2 = Sprite.load("ADU-T_Shoot1_2", path.."shoot1_2", 3, 7, 12),
	shoot3 = Sprite.load("ADU-T_Shoot3", path.."shoot3", 7, 25, 26),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(ADut, {{"Strength", 5}, {"Vitality", 5}, {"Toughness", 2}, {"Agility", 4}, {"Difficulty", 6}, {"Potential", 10}})
SurvivorVariant.setDescription(ADut, "As the pod shakes, the booting machine is enlightened, changing its purpose forever.")