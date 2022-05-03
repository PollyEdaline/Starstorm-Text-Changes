-- ANOINTED

local path = "Survivors/Engineer/Skins/Anointed/"

local survivor = sur.Engineer
local sprSelect = Sprite.load("AEngiSelect", path.."Select", 10, 2, 0)
local ACommando = SurvivorVariant.new(survivor, "Anointed Engineer", sprSelect, {
	idle = Sprite.load("AEngiIdle", path.."Idle", 1, 10, 11),
	walk = Sprite.load("AEngiWalk", path.."Walk", 8, 19, 28),
	jump = Sprite.load("AEngiJump", path.."Jump", 1, 9, 8),
	climb = Sprite.load("AEngiClimb", path.."Climb", 2, 11, 8),
	death = Sprite.load("AEngiDeath", path.."Death", 11, 16, 19),
	decoy = Sprite.load("AEngiDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1 = Sprite.load("AEngiShoot1", path.."Shoot1", 4, 29, 45),
	shoot3 = Sprite.load("AEngiShoot3", path.."Shoot3", 21, 10, 17),
	
	turretBase1 = Sprite.load("AEngiTurretBase1", path.."Turret1Base", 1, 10, 7),
	turretRotate1 = Sprite.load("AEngiTurretRotate1", path.."Turret1Turn", 7, 13, 7),
	turretShoot1 = Sprite.load("AEngiTurretShoot1", path.."Turret1Shoot", 3, 13, 7),
	turretSpawn1 = Sprite.load("AEngiTurretSpawn1", path.."Turret1Spawn", 11, 10, 7),
	
	turretBase2 = Sprite.load("AEngiTurretBase2", path.."Turret2Base", 1, 10, 7),
	turretRotate2 = Sprite.load("AEngiTurretRotate2", path.."Turret2Turn", 7, 13, 7),
	turretShoot2 = Sprite.load("AEngiTurretShoot2", path.."Turret2Shoot", 3, 13, 7),
	turretSpawn2 = Sprite.load("AEngiTurretSpawn2", path.."Turret2Spawn", 11, 10, 7),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(ACommando, {{"Strength", 5}, {"Vitality", 5}, {"Toughness", 3}, {"Agility", 5}, {"Difficulty", 3}, {"Integrity", 10}})
SurvivorVariant.setDescription(ACommando, "The resting inventor is enlightened, becoming the architect of an eternity.")