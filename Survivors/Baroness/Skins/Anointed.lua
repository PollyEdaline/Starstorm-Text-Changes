-- ANOINTED

local path = "Survivors/Baroness/Skins/Anointed/"

local survivor = Survivor.find("Baroness", "Starstorm")
local sprSelect = Sprite.load("ABaronessSelect", path.."Select", 23, 2, 0)
local ABaroness = SurvivorVariant.new(survivor, "Anointed Baroness", sprSelect, {
	idle_1 = Sprite.load("ABaronessIdle", path.."idle", 1, 5, 7),
	walk_1 = Sprite.load("ABaronessWalk", path.."walk", 8, 7, 8),
	jump_1 = Sprite.load("ABaronessJump", path.."jump", 1, 6, 10),
	climb = Sprite.load("ABaronessClimb", path.."climb", 2, 4, 9),
	death = Sprite.load("ABaronessDeath", path.."death", 8, 30, 8),
	decoy = Sprite.load("ABaronessDecoy", path.."decoy", 1, 9, 10),
	
	idle_2 = Sprite.load("ABaronessIdle_Bike", path.."idleBike", 1, 9, 8),
	walk_2 = Sprite.load("ABaronessWalk_Bike", path.."walkBike", 8, 19, 8),
	jump_2 = Sprite.load("ABaronessJump_Bike", path.."jumpBike", 1, 9, 8),
	
	shoot1 = Sprite.load("ABaronessShoot1", path.."shoot1", 3, 6, 7),
	shoot2_1 = Sprite.load("ABaronessShoot2A", path.."shoot2a", 7, 5, 14),
	shoot2_2 = Sprite.load("ABaronessShoot2B", path.."shoot2b", 7, 15, 15),
	shoot3_1 = Sprite.load("ABaronessShoot3A", path.."shoot3a", 6, 8, 10),
	shoot3_2 = Sprite.load("ABaronessShoot3B", path.."shoot3b", 8, 19, 18),
	shoot4_1 = Sprite.load("ABaronessShoot4A", path.."shoot4a", 7, 5, 14),
	shoot4_2 = Sprite.load("ABaronessShoot4B", path.."shoot4b", 7, 16, 15),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(ABaroness, {{"Strength", 7}, {"Vitality", 5}, {"Toughness", 3}, {"Agility", 8}, {"Difficulty", 4}, {"Versatility", 10}})
SurvivorVariant.setDescription(ABaroness, "The grizzled noble is enlightened, as she loads her weapon and sets a goal: find survivors.")