-- ANOINTED

local path = "Survivors/HAN-D/Skins/Anointed/"

local survivor = sur.HAND
local sprSelect = Sprite.load("AJanitorSelect", path.."Select", 12, 2, 0)
local AJanitor = SurvivorVariant.new(survivor, "Anointed HAN-D", sprSelect, {
	idle = Sprite.load("AJanitorIdleA", path.."Idle", 1, 11, 19),
	idlehot = Sprite.load("AJanitorIdleB", path.."IdleHot", 1, 11, 19),
	walk = Sprite.load("AJanitorWalkA", path.."Walk", 8, 25, 16),
	walkhot = Sprite.load("AJanitorWalkB", path.."WalkHot", 8, 33, 22),
	jump = Sprite.load("AJanitorJumpA", path.."Jump", 1, 8, 18),
	jumphot = Sprite.load("AJanitorJumpB", path.."JumpHot", 1, 11, 21),
	climb = Sprite.load("AJanitorClimbA", path.."Climb", 2, 8, 6),
	climbhot = Sprite.load("AJanitorClimbB", path.."ClimbHot", 2, 8, 6),
	death = Sprite.load("AJanitorDeathA", path.."Head", 7, 6, 1),
	death_2 = Sprite.load("AJanitorDeathB", path.."Death", 7, 9, 30),
	decoy = Sprite.load("AJanitorDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1 = Sprite.load("AJanitorShoot1A", path.."Shoot1", 12, 14, 16),
	shoot1hot = Sprite.load("AJanitorShoot1B", path.."Shoot1Hot", 12, 17, 19),
	shoot4 = Sprite.load("AJanitorShoot4A", path.."Shoot4", 18, 32, 39),
	shoot4hot = Sprite.load("AJanitorShoot4B", path.."Shoot4Hot", 18, 32, 39),
	shoot5 = Sprite.load("AJanitorShoot5A", path.."Shoot5", 18, 32, 39),
	shoot5hot = Sprite.load("AJanitorShoot5B", path.."Shoot4Hot", 18, 32, 39),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(AJanitor, {{"Strength", 6}, {"Vitality", 8}, {"Toughness", 6}, {"Agility", 5}, {"Difficulty", 4}, {"Hygiene", 10}})
SurvivorVariant.setDescription(AJanitor, "The ever-working robot is enlightened. A new sense covers the metallic plates of the hurrying unit.")
