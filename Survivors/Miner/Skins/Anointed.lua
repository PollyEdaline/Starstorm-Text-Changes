-- ANOINTED

local path = "Survivors/Miner/Skins/Anointed/"

local survivor = sur.Miner
local sprSelect = Sprite.load("AMinerSelect", path.."Select", 16, 2, 0)
local AMiner = SurvivorVariant.new(survivor, "Anointed Miner", sprSelect, {
	idle = Sprite.load("AMinerIdle", path.."Idle", 1, 6, 5),
	walk = Sprite.load("AMinerWalk", path.."Walk", 8, 6, 6),
	jump = Sprite.load("AMinerJump", path.."Jump", 1, 5, 6),
	climb = Sprite.load("AMinerClimb", path.."Climb", 2, 4, 6),
	death = Sprite.load("AMinerDeath", path.."Death", 5, 14, 11),
	decoy = Sprite.load("AMinerDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1 = Sprite.load("AMinerShoot1", path.."Shoot1", 8, 6, 6),
	shoot2 = Sprite.load("AMinerShoot2", path.."Shoot2", 6, 23, 6),
	shoot3 = Sprite.load("AMinerShoot3", path.."Shoot3", 11, 7, 6),
	shoot4 = Sprite.load("AMinerShoot4", path.."Shoot4", 8, 24, 4),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(AMiner, {{"Strength", 6}, {"Vitality", 6}, {"Toughness", 4}, {"Agility", 9}, {"Difficulty", 5}, {"Scars", 10}})
SurvivorVariant.setDescription(AMiner, "The overworked excavator is enlightened, finding value in more than precious minerals.")