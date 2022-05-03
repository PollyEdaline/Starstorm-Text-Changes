-- ANOINTED

local path = "Survivors/Huntress/Skins/Anointed/"

local survivor = sur.Huntress
local sprSelect = Sprite.load("AHuntressSelect", path.."Select", 18, 2, 0)
local AHuntress = SurvivorVariant.new(survivor, "Anointed Huntress", sprSelect, {
	idle = Sprite.load("AHuntressIdle", path.."Idle", 1, 3, 5),
	idlehalf = Sprite.load("AHuntressIdleHalf", path.."IdleHalf", 1, 3, 5),
	walk = Sprite.load("AHuntressWalk", path.."Walk", 8, 4, 5),
	walkhalf = Sprite.load("AHuntressWalkHalf", path.."WalkHalf", 8, 4, 5),
	jump = Sprite.load("AHuntressJump", path.."Jump", 1, 3, 6),
	climb = Sprite.load("AHuntressClimb", path.."Climb", 2, 2, 6),
	death = Sprite.load("AHuntressDeath", path.."Death", 10, 14, 3),
	decoy = Sprite.load("AHuntressDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1 = Sprite.load("AHuntressShoot1", path.."Shoot1", 9, 6, 6),
	shoot2 = Sprite.load("AHuntressShoot2", path.."Shoot2", 9, 10, 7),
	shoot4 = Sprite.load("AHuntressShoot4", path.."Shoot4", 10, 15, 12),
	shoot5 = Sprite.load("AHuntressShoot5", path.."Shoot5", 10, 15, 12),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(AHuntress, {{"Strength", 6}, {"Vitality", 3}, {"Toughness", 2}, {"Agility", 7}, {"Difficulty", 6}, {"Precision", 10}})
SurvivorVariant.setDescription(AHuntress, "The trained, bow-wielding ace is enlightened, seeing the universe with a new eye.")
AHuntress.forceApply = true