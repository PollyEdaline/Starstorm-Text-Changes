-- ANOINTED

local path = "Survivors/Commando/Skins/Anointed/"

local survivor = sur.Commando
local sprSelect = Sprite.load("ACommandoSelect", path.."Select", 13, 2, 0)
local ACommando = SurvivorVariant.new(survivor, "Anointed Commando", sprSelect, {
	idle = Sprite.load("ACommandoIdle", path.."Idle", 1, 6, 6),
	walk = Sprite.load("ACommandoWalk", path.."Walk", 8, 5, 6),
	jump = Sprite.load("ACommandoJump", path.."Jump", 1, 5, 6),
	climb = Sprite.load("ACommandoClimb", path.."Climb", 2, 4, 6),
	death = Sprite.load("ACommandoDeath", path.."Death", 5, 14, 3),
	decoy = Sprite.load("ACommandoDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1 = Sprite.load("ACommandoShoot1", path.."Shoot1", 5, 8, 6),
	shoot2 = Sprite.load("ACommandoShoot2", path.."Shoot2", 5, 5, 6),
	shoot3 = Sprite.load("ACommandoShoot3", path.."Shoot3", 9, 6, 9),
	shoot4_1 = Sprite.load("ACommandoShoot4A", path.."Shoot4_1", 15, 19, 7),
	shoot4_2 = Sprite.load("ACommandoShoot4B", path.."Shoot4_2", 15, 19, 7),
	shoot5_1 = Sprite.load("ACommandoShoot5A", path.."Shoot5_1", 23, 38, 20),
	shoot5_2 = Sprite.load("ACommandoShoot5B", path.."Shoot5_2", 24, 19, 7),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(ACommando, {{"Strength", 5}, {"Vitality", 5}, {"Toughness", 3}, {"Agility", 5}, {"Difficulty", 3}, {"Integrity", 10}})
SurvivorVariant.setDescription(ACommando, "The improbable pawn is enlightened, inadvertently walking into the unknown.")