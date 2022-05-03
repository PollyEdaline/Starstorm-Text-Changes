-- ANOINTED

local path = "Survivors/CHEF/Skins/Anointed/"

local survivor = sur.CHEF
local sprSelect = Sprite.load("ACHEFSelect", path.."Select", 4, 2, 0)
local ACHEF = SurvivorVariant.new(survivor, "Anointed CHEF", sprSelect, {
	idle = Sprite.load("ACHEFIdle", path.."Idle", 1, 6, 17),
	walk = Sprite.load("ACHEFWalk", path.."Walk", 7, 6, 18),
	jump = Sprite.load("ACHEFJump", path.."Jump", 1, 5, 17),
	climb = Sprite.load("ACHEFClimb", path.."Climb", 2, 5, 11),
	death = Sprite.load("ACHEFDeath", path.."Death", 5, 14, 13),
	decoy = Sprite.load("ACHEFDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.load("ACHEFShoot1A", path.."Shoot1_1", 8, 14, 17),
	shoot2_1 = Sprite.load("ACHEFShoot2A", path.."Shoot2_1", 9, 16, 17),
	shoot2_2 = Sprite.load("ACHEFShoot2B", path.."Shoot2_2", 9, 11, 17),
	shoot3_1 = Sprite.load("ACHEFShoot3A", path.."Shoot3_1", 10, 13, 25),
	shoot3_2 = Sprite.load("ACHEFShoot3B", path.."Shoot3_2", 16, 15, 25),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(ACHEF, {{"Strength", 5}, {"Vitality", 5}, {"Toughness", 3}, {"Agility", 5}, {"Difficulty", 5}, {"Cuisine", 10}})
SurvivorVariant.setDescription(ACHEF, "The attendant is enlightened, from a kitchen to an unexpected place in the universe, locked in.")