-- ANOINTED

local path = "Survivors/Mercenary/Skins/Anointed/"

local survivor = sur.Mercenary
local sprSelect = Sprite.load("AMercenarySelect", path.."Select", 19, 2, 0)
local AMercenary = SurvivorVariant.new(survivor, "Anointed Mercenary", sprSelect, {
	idle = Sprite.load("AMercenaryIdle", path.."Idle", 2, 3, 8),
	walk = Sprite.load("AMercenaryWalk", path.."Walk", 8, 6, 8),
	jump = Sprite.load("AMercenaryJump", path.."Jump", 1, 3, 8),
	climb = Sprite.load("AMercenaryClimb", path.."Climb", 2, 4, 6),
	death = Sprite.load("AMercenaryDeath", path.."Death", 8, 17, 3),
	decoy = Sprite.load("AMercenaryDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.load("AMercenaryShoot1A", path.."Shoot1_1", 9, 8, 10),
	shoot1_2 = Sprite.load("AMercenaryShoot1B", path.."Shoot1_2", 11, 8, 10),
	shoot2 = Sprite.load("AMercenaryShoot2", path.."Shoot2", 8, 13, 13),
	shoot3 = Sprite.load("AMercenaryShoot3", path.."Shoot3", 8, 8, 8),
	shoot4 = Sprite.load("AMercenaryShoot4", path.."Shoot4", 18, 30, 16),
	shoot5 = Sprite.load("AMercenaryShoot5", path.."Shoot5", 18, 30, 16),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(AMercenary, {{"Strength", 4}, {"Vitality", 5}, {"Toughness", 3}, {"Agility", 4}, {"Difficulty", 4}, {"Charisma", 10}})
SurvivorVariant.setDescription(AMercenary, "With an agitated blade, the elusive slayer is enlightened, as he prepares for one last job.")