-- ANOINTED

local path = "Survivors/Nucleator/Skins/Anointed/"

local survivor = Survivor.find("Nucleator", "Starstorm")
local sprSelect = Sprite.load("ANucleatorSelect", path.."Select", 16, 2, 0)
local ANucleator = SurvivorVariant.new(survivor, "Anointed Nucleator", sprSelect, {
	idle = Sprite.load("ANucleatorIdle", path.."idle", 1, 7, 9),
	walk = Sprite.load("ANucleatorWalk", path.."walk", 8, 7, 9),
	jump = Sprite.load("ANucleatorJump", path.."jump", 1, 6, 10),
	climb = Sprite.load("ANucleatorClimb", path.."climb", 2, 4, 9),
	death = Sprite.load("ANucleatorDeath", path.."death", 5, 5, 9),
	decoy = Sprite.load("ANucleatorDecoy", path.."decoy", 1, 9, 10),
	
	shoot1 = Sprite.load("ANucleatorShoot1", path.."shoot1", 19, 10, 26),
	shoot2 = Sprite.load("ANucleatorShoot2", path.."shoot2", 23, 10, 12),
	shoot2_2 = Sprite.load("ANucleatorShoot2B", path.."shoot2_2", 6, 10, 12),
	shoot3 = Sprite.load("ANucleatorShoot3", path.."shoot3", 16, 15, 24),
	shoot4_1 = Sprite.load("ANucleatorShoot4", path.."shoot4", 6, 11, 12),
	shoot4_2 = Sprite.load("ANucleatorShoot5", path.."shoot5", 6, 11, 12),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(ANucleator, {{"Strength", 8}, {"Vitality", 5}, {"Toughness", 4}, {"Agility", 5.5}, {"Difficulty", 4}, {"Radiation", 10}})
SurvivorVariant.setDescription(ANucleator, "The valiant scientist is enlightened. As he puts on the suit, a bright reflection values his sacrifice.")