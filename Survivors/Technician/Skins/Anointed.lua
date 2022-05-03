-- ANOINTED

local path = "Survivors/Technician/Skins/Anointed/"

local survivor = Survivor.find("Technician", "Starstorm")
local sprSelect = Sprite.load("ATechnicianSelect", path.."Select", 15, 2, 0)
local ATechnician = SurvivorVariant.new(survivor, "Anointed Technician", sprSelect, {
	-- Right
	idle_1 = Sprite.load("ATechnicianIdleR", path.."idler", 1, 4, 7),
	walk_1 = Sprite.load("ATechnicianWalkR", path.."walkr", 8, 5, 7),
	jump_1 = Sprite.load("ATechnicianJumpR", path.."jumpr", 1, 4, 7),
	shoot1_1 = Sprite.load("ATechnicianShoot1R", path.."shoot1r", 6, 6, 7),
	shoot2_1 = Sprite.load("ATechnicianShoot2R", path.."shoot2r", 6, 6, 7),
	shoot3_1_1 = Sprite.load("ATechnicianShoot3R", path.."shoot3r", 12, 6, 7),
	shoot3_1_2 = Sprite.load("ATechnicianShoot3RW", path.."shoot3rw", 12, 6, 7),
	shoot4_1 = Sprite.load("ATechnicianShoot4R", path.."shoot4r", 6, 4, 7),
	
	-- Left
	idle_2 = Sprite.load("ATechnicianIdleL", path.."idlel", 1, 4, 7),
	walk_2 = Sprite.load("ATechnicianWalkL", path.."walkl", 8, 4, 7),
	jump_2 = Sprite.load("ATechnicianJumpL", path.."jumpl", 1, 4, 7),
	shoot1_2 = Sprite.load("ATechnicianShoot1L", path.."shoot1l", 6, 6, 7),
	shoot2_2 = Sprite.load("ATechnicianShoot2L", path.."shoot2l", 6, 6, 7),
	shoot3_2_1 = Sprite.load("ATechnicianShoot3L", path.."shoot3l", 12, 6, 7),
	shoot3_2_2 = Sprite.load("ATechnicianShoot3LW", path.."shoot3lw", 12, 6, 7),
	shoot4_2 = Sprite.load("ATechnicianShoot4L", path.."shoot4l", 6, 4, 7),
	
	death = Sprite.load("ATechnicianDeath", path.."death", 5, 6, 7),
	climb = Sprite.load("ATechnicianClimb", path.."climb", 2, 3, 7),
	decoy = Sprite.load("ATechnicianDecoy", path.."decoy", 1, 9, 12),
	
	turret1_1 = Sprite.load("ATechnicianTurretA", path.."turreta", 2, 7, 7),
	turret1_2 = Sprite.load("ATechnicianTurretA_Shoot", path.."turretashoot", 4, 7, 7),
	
	turret2_1 = Sprite.load("ATechnicianTurretB", path.."turretb", 2, 8, 9),
	turret2_2 = Sprite.load("ATechnicianTurretB_Shoot", path.."turretbshoot", 4, 9, 9),
	
	turret3_1 = Sprite.load("ATechnicianTurretC", path.."turretc", 2, 8, 9),
	turret3_2 = Sprite.load("ATechnicianTurretC_Shoot", path.."turretcshoot", 4, 9, 9),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(ATechnician, {{"Strength", 4}, {"Vitality", 5}, {"Toughness", 3}, {"Agility", 4}, {"Difficulty", 6}, {"Service", 10}})
SurvivorVariant.setDescription(ATechnician, "The cutting edge artisan is enlightened, pushing all known sciences to the sde.")