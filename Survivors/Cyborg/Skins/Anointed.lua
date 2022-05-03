-- ANOINTED

local path = "Survivors/Cyborg/Skins/Anointed/"

local survivor = Survivor.find("Cyborg", "Starstorm")
local sprSelect = Sprite.load("ACyborgSelect", path.."Select", 17, 2, 0)
local ACyborg = SurvivorVariant.new(survivor, "Anointed Cyborg", sprSelect, {
	idle = Sprite.load("ACyborgIdle", path.."idle", 1, 4, 7),
	walk = Sprite.load("ACyborgWalk", path.."walk", 4, 5, 8),
	jump = Sprite.load("ACyborgJump", path.."jump", 1, 5, 6),
	climb = Sprite.load("ACyborgClimb", path.."climb", 2, 4, 7),
	death = Sprite.load("ACyborgDeath", path.."death", 5, 9, 4),
	decoy = Sprite.load("ACyborgDecoy", path.."decoy", 1, 9, 10),

	shoot1 = Sprite.load("ACyborgShoot1", path.."shoot1", 6, 6, 8),
	shoot2 = Sprite.load("ACyborgShoot2", path.."shoot2", 8, 12, 19),
	shoot3_1 = Sprite.load("ACyborgShoot3A", path.."shoot3a", 3, 11, 16),
	shoot3_2 = Sprite.load("ACyborgShoot3B", path.."shoot3b", 6, 11, 16),
	shoot4 = Sprite.load("ACyborgShoot4", path.."shoot4", 8, 10, 12),
	
	teleport_1 = Sprite.load("ACyborgTeleportA", path.."teleporta", 8, 5, 9),
	teleport_2 = Sprite.load("ACyborgTeleportB", path.."teleportb", 4, 5, 9)
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(ACyborg, {{"Strength", 6}, {"Vitality", 6}, {"Toughness", 3}, {"Agility", 4}, {"Difficulty", 4}, {"Efficiency", 10}})
SurvivorVariant.setDescription(ACyborg, "The living miracle is enlightened, as they calibrate their senses for the incoming challenge.")