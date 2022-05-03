-- ANOINTED

local path = "Survivors/Seraph/Skins/Anointed/"

local survivor = Survivor.find("Seraph", "Starstorm")
local sprSelect = Sprite.load("ASeraphSelect", path.."Select", 21, 2, 0)
local ASeraph = SurvivorVariant.new(survivor, "Anointed Seraph", sprSelect, {
	idle = Sprite.load("ASeraphIdle", path.."idle", 8, 7, 11),
	walk = Sprite.load("ASeraphWalk", path.."walk", 8, 7, 11),
	jump = Sprite.load("ASeraphJump", path.."jump", 4, 7, 11),
	climb = Sprite.load("ASeraphClimb", path.."climb", 2, 8, 10),
	death = Sprite.load("ASeraphDeath", path.."death", 21, 9, 24),
	decoy = Sprite.load("ASeraphDecoy", path.."decoy", 1, 9, 10),
	
	shoot1 = Sprite.load("ASeraphShoot1", path.."shoot1", 6, 8, 11),
	shoot2 = Sprite.load("ASeraphShoot2", path.."shoot1", 6, 8, 11),
	shoot3_1 = Sprite.load("ASeraphShoot3_1", path.."shoot3_1", 14, 20, 11),
	shoot3_2 = Sprite.load("ASeraphShoot3_2", path.."shoot3_2", 13, 19, 11),
	shoot4 = Sprite.load("ASeraphShoot4", path.."shoot4", 9, 16, 24),
	shoot5 = Sprite.load("ASeraphShoot5", path.."shoot5", 9, 16, 24),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(ASeraph, {{"Strength", 8}, {"Vitality", 3}, {"Toughness", 2}, {"Agility", 3}, {"Difficulty", 4}, {"Absolution", 10}})
SurvivorVariant.setDescription(ASeraph, "The deserted scion is enlightened, a new heir for something it can't yet comprehend.")