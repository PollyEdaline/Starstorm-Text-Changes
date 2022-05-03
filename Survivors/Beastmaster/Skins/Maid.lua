-- Maid

local path = "Survivors/Beastmaster/Skins/Maid/"

local survivor = Survivor.find("Chirr", "Starstorm")
local sprSelect = Sprite.load("MaidSelect", path.."Select", 15, 2, 0)

local Maid = SurvivorVariant.new(survivor, "Maid", sprSelect, {
	idle = Sprite.load("Maid_Idle", path.."idle", 1, 12, 11),
	walk = Sprite.load("Maid_Walk", path.."walk", 8, 13, 13),
	jump_2 = Sprite.load("Maid_Jump", path.."jump", 1, 11, 13),
	flight = Sprite.load("Maid_Flight", path.."flight", 1, 11, 15),
	wings = Sprite.load("Maid_Wings", path.."wings", 3, 11, 15),
	climb = Sprite.load("Maid_Climb", path.."climb", 2, 11, 10),
	death = Sprite.load("Maid_Death", path.."death", 8, 16, 11),
	decoy = Sprite.load("Maid_Decoy", path.."decoy", 1, 9, 10),
	
	shoot1 = Sprite.load("Maid_Shoot1", path.."shoot1", 5, 17, 11),
	shoot2 = Sprite.load("Maid_Shoot2", path.."shoot2", 7, 23, 11),
	shoot3 = Sprite.load("Maid_Shoot3", path.."shoot3", 13, 19, 27),
	shoot4 = Sprite.load("Maid_Shoot4", path.."shoot4", 10, 3, 4),
}, Color.fromHex(0x96B161))
SurvivorVariant.setInfoStats(Maid, {{"Strength", 4}, {"Vitality", 5}, {"Toughness", 2}, {"Agility", 8}, {"Difficulty", 5}, {"Healing", 10}, {"Cleanliness", 10}})
SurvivorVariant.setDescription(Maid, "&y&Maid Chirr&!& is eager to serve!")

local sprSkills = Sprite.load("MaidSkills", path.."Skills", 2, 0, 0)

Maid.endingQuote = "..and so she left, pleased to be of service."

local halloweenSave = save.read("hday1")
if not global.halloween and not global.rormlflag.ss_enable_maid and not halloweenSave then
	Maid.hidden = true
end

callback.register("onSkinInit", function(player, skin)
	if skin == Maid then
		local playerData = player:getData()
		
		playerData.skill4IconOverride = {sprite = sprSkills, index = 1}
		player:setSkillIcon(4, sprSkills, 1)
	end
end)