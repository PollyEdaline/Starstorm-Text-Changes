-- ANOINTED

local path = "Survivors/Loader/Skins/Anointed/"

local survivor = sur.Loader
local sprSelect = Sprite.load("ALoaderSelect", path.."Select", 15, 2, 0)
local ALoader = SurvivorVariant.new(survivor, "Anointed Loader", sprSelect, {
	idle = Sprite.load("ALoaderIdle", path.."Idle", 1, 6, 7),
	walk = Sprite.load("ALoaderWalk", path.."Walk", 8, 7, 7),
	jump = Sprite.load("ALoaderJump", path.."Jump", 1, 6, 7),
	climb = Sprite.load("ALoaderClimb", path.."Climb", 2, 4, 9),
	death = Sprite.load("ALoaderDeath", path.."Death", 5, 14, 7),
	decoy = Sprite.load("ALoaderDecoy", path.."Decoy", 1, 9, 18),
	
	travel = Sprite.load("ALoaderTravel", path.."Travel", 1, 6, 7),
	shoot11 = Sprite.load("ALoaderShoot1A", path.."Shoot1_1", 5, 11, 13),
	shoot12 = Sprite.load("ALoaderShoot1B", path.."Shoot1_2", 4, 11, 13),
	shoot13 = Sprite.load("ALoaderShoot1C", path.."Shoot1_3", 9, 11, 13),
	shoot2 = Sprite.load("ALoaderShoot2", path.."Shoot2", 11, 9, 8),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(ALoader, {{"Strength", 6}, {"Vitality", 5}, {"Toughness", 7}, {"Agility", 7}, {"Difficulty", 4}, {"Reflex", 10}})
SurvivorVariant.setDescription(ALoader, "The unparalleled carrier is enlightened, now holding the intangible weight of the universe.")