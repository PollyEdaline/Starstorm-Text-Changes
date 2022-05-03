-- ANOINTED

local path = "Survivors/Acrid/Skins/Anointed/"

local survivor = sur.Acrid
local sprSelect = Sprite.load("AAcridSelect", path.."Select", 21, 2, 0)
local AAcrid = SurvivorVariant.new(survivor, "Anointed Acrid", sprSelect, {
	idle = Sprite.load("AAcridIdle", path.."Idle", 1, 15, 8),
	walk = Sprite.load("AAcridWalk", path.."Walk", 9, 30, 11),
	jump = Sprite.load("AAcridJump", path.."Jump", 1, 9, 11),
	climb = Sprite.load("AAcridClimb", path.."Climb", 2, 8, 15),
	death = Sprite.load("AAcridDeath", path.."Death", 15, 12, 18),
	decoy = Sprite.load("AAcridDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.load("AAcridShoot1A", path.."Shoot1_1", 6, 15, 15),
	shoot1_2 = Sprite.load("AAcridShoot1B", path.."Shoot1_2", 6, 15, 22),
	shoot2 = Sprite.load("AAcridShoot2", path.."Shoot2", 9, 15, 15),
	shoot4 = Sprite.load("AAcridShoot4", path.."Shoot4", 7, 15, 15),
	shoot5 = Sprite.load("AAcridShoot5", path.."Shoot5", 7, 15, 15),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(AAcrid, {{"Strength", 5}, {"Vitality", 5}, {"Toughness", 6}, {"Agility", 6}, {"Difficulty", 5}, {"Hunger", 10}})
SurvivorVariant.setDescription(AAcrid, "The restless creature is enlightened, eternally bound by it's everlasting will.")