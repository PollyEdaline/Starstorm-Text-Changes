-- ANOINTED

local path = "Survivors/MULE/Skins/Anointed/"

local survivor = Survivor.find("MULE", "Starstorm")
local sprSelect = Sprite.load("AMULESelect", path.."Select", 16, 2, 0)
local AMULE = SurvivorVariant.new(survivor, "Anointed MULE", sprSelect, {
	idle = Sprite.load("AMULEIdle", path.."idle", 1, 6, 12),
	walk = Sprite.load("AMULEWalk", path.."walk", 8, 9, 13),
	jump = Sprite.load("AMULEJump", path.."jump", 1, 6, 12),
	climb = Sprite.load("AMULEClimb", path.."climb", 2, 5, 9),
	death = Sprite.load("AMULEDeath", path.."death", 6, 9, 12),
	decoy = Sprite.load("AMULEDecoy", path.."decoy", 1, 9, 13),
	
	shoot1_1 = Sprite.load("AMULEShoot1A", path.."shoot1a", 6, 9, 12),
	shoot1_2_1 = Sprite.load("AMULEShoot1B1", path.."shoot1b1", 6, 6, 12),
	shoot1_2_2 = Sprite.load("AMULEShoot1B2", path.."shoot1b2", 6, 6, 12),
	shoot1_3 = Sprite.load("AMULEShoot1C", path.."shoot1c", 6, 6, 12),
	shoot2 = Sprite.load("AMULEShoot2", path.."shoot2", 7, 10, 12),
	shoot3 = Sprite.load("AMULEShoot3", path.."shoot3", 15, 15, 13),
	shoot4_1 = Sprite.load("AMULEShoot4", path.."shoot4", 15, 13, 18),
	shoot4_2 = Sprite.load("AMULEShoot5", path.."shoot5", 15, 13, 18),
	
	drone1_1 = Sprite.load("AMULEDroneA", path.."dronea", 4, 5, 5),
	drone1_2 = Sprite.load("AMULEDroneA_Repair", path.."droneaRegen", 2, 5, 5),
	drone2_1 = Sprite.load("AMULEDroneB", path.."droneb", 4, 6, 6),
	drone2_2 = Sprite.load("AMULEDroneB_Repair", path.."dronebRegen", 2, 6, 6)
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(AMULE, {{"Strength", 6}, {"Vitality", 7}, {"Toughness", 5}, {"Agility", 4}, {"Difficulty", 5}, {"Directive", 10}})
SurvivorVariant.setDescription(AMULE, "The rustic transporter is enlightened, with unimaginable effort yet to come.")

