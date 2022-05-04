-- ANOINTED

local path = "Survivors/Beastmaster/Skins/Anointed/"

local survivor = Survivor.find("Chirr", "Starstorm")
local sprSelect = Sprite.load("AChirrSelect", path.."Select", 15, 2, 0)
local AChirr = SurvivorVariant.new(survivor, "Anointed Chirr", sprSelect, {
	idle = Sprite.load("AChirrIdle", path.."idle", 1, 12, 11),
	walk = Sprite.load("AChirrWalk", path.."walk", 8, 13, 13),
	jump_2 = Sprite.load("AChirrJump", path.."jump", 1, 11, 14),
	flight = Sprite.load("AChirrFlight", path.."flight", 1, 11, 15),
	wings = Sprite.load("AChirrWings", path.."wings", 3, 11, 15),
	climb = Sprite.load("AChirrClimb", path.."climb", 2, 11, 10),
	death = Sprite.load("AChirrDeath", path.."death", 8, 16, 11),
	decoy = Sprite.load("AChirrDecoy", path.."decoy", 1, 9, 13),
	
	shoot1 = Sprite.load("AChirrShoot1", path.."shoot1", 5, 17, 11),
	shoot2 = Sprite.load("AChirrShoot2", path.."shoot2", 7, 23, 13),
	shoot3 = Sprite.load("AChirrShoot3", path.."shoot3", 13, 19, 27),
	shoot4 = Sprite.load("AChirrShoot4", path.."shoot4", 10, 3, 4),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(AChirr, {{"Strength", 4}, {"Vitality", 5}, {"Toughness", 2}, {"Agility", 8}, {"Difficulty", 5}, {"Healing", 10}, {"Essence", 10}})
SurvivorVariant.setDescription(AChirr, "The spirited creature is enlightened, held by unlikely circumstance, ready to make necessary changes.")