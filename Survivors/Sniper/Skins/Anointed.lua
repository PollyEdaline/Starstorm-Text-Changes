-- ANOINTED

local path = "Survivors/Sniper/Skins/Anointed/"

local survivor = sur.Sniper
local sprSelect = Sprite.load("ASniperSelect", path.."Select", 24, 2, 0)
local ASniper = SurvivorVariant.new(survivor, "Anointed Sniper", sprSelect, {
	idle = Sprite.load("ASniperIdle", path.."Idle", 1, 2, 5),
	walk = Sprite.load("ASniperWalk", path.."Walk", 8, 18, 16),
	jump = Sprite.load("ASniperJump", path.."Jump", 1, 4, 7),
	climb = Sprite.load("ASniperClimb", path.."Climb", 2, 5, 6),
	death = Sprite.load("ASniperDeath", path.."Death", 7, 14, 6),
	decoy = Sprite.load("ASniperDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.load("ASniperShoot1A", path.."Shoot1_1", 6, 4, 10),
	shoot1_2 = Sprite.load("ASniperShoot1B", path.."Shoot1_2", 7, 4, 5),
	shoot3_2 = Sprite.load("ASniperShoot2", path.."Shoot2", 6, 66, 42),
	shoot3_1 = Sprite.load("ASniperShoot3", path.."Shoot3", 12, 7, 15),
	
	drone_idle = Sprite.load("ASniperDroneIdle", path.."DroneIdle", 1, 8, 6),
	drone_shoot = Sprite.load("ASniperDroneShoot", path.."DroneShoot", 6, 8, 8),
	drone_warp = Sprite.load("ASniperDroneWarp", path.."DroneWarp", 17, 7, 6),
	drone_zap = Sprite.load("ASniperDroneZap", path.."DroneZap", 2, 8, 6),
	drone_turn = Sprite.load("ASniperDroneTurn", path.."DroneTurn", 7, 8, 6)
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(ASniper, {{"Strength", 10}, {"Vitality", 6}, {"Toughness", 3}, {"Agility", 3}, {"Difficulty", 4}, {"Awareness", 10}})
SurvivorVariant.setDescription(ASniper, "The immaculate soldier is enlightened, as they ready their equipment for a flawless operation.")