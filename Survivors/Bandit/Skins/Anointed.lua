-- ANOINTED

local path = "Survivors/Bandit/Skins/Anointed/"

local survivor = sur.Bandit
local sprSelect = Sprite.load("ABanditSelect", path.."Select", 12, 2, 0)
local ABandit = SurvivorVariant.new(survivor, "Anointed Bandit", sprSelect, {
	idle = Sprite.load("ABanditIdle", path.."Idle", 1, 3, 8),
	walk = Sprite.load("ABanditWalk", path.."Walk", 8, 8, 16),
	jump = Sprite.load("ABanditJump", path.."Jump", 1, 3, 10),
	climb = Sprite.load("ABanditClimb", path.."Climb", 2, 5, 7),
	death = Sprite.load("ABanditDeath", path.."Death", 8, 19, 6),
	decoy = Sprite.load("ABanditDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1 = Sprite.load("ABanditShoot1", path.."Shoot1", 4, 6, 9),
	shoot2 = Sprite.load("ABanditShoot2", path.."Shoot2", 6, 3, 13),
	shoot4 = Sprite.load("ABanditShoot4", path.."Shoot4", 9, 6, 13),
	shoot5 = Sprite.load("ABanditShoot5", path.."Shoot5", 11, 6, 13),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(ABandit, {{"Strength", 6}, {"Vitality", 6}, {"Toughness", 3}, {"Agility", 6}, {"Difficulty", 4}, {"Odor", 10}})
SurvivorVariant.setDescription(ABandit, "With great pride, the lone gunman is enlightened, awaiting his moment to take what he pleases.")