local path = "Items/Resources/"

it.NucleusGems = Item.new("Nucleus Gems")
--local sNucleusGems = Sound.load("NucleusGems", path.."nucleusGems")
local sprGemDrop = Sprite.load("NucleusGemsDrop", path.."gemDrop.png", 4, 11, 9)
it.NucleusGems.pickupText = "Sharp, bright, incalculable value."
it.NucleusGems.sprite = Sprite.load("NucleusGems", path.."Nucleus Gems.png", 1, 15, 15)
itp.sibylline:add(it.NucleusGems)
it.NucleusGems.color = Color.fromHex(0xFFCCED)
it.NucleusGems:setLog{
	group = "end",
	description = "Gold drops become sharp gems, &y&dealing damage to enemies on contact.",
	story = "Finding treasure, a rush of excitement. My weakness? Taking it all.",
	priority = "&"..it.NucleusGems.color.gml.."&Unknown",
	destination = "",
	date = "Unknown"
}
local onStepCall = function()
	if runData.nucleusGems then
		for _, gold in ipairs(obj.EfGold:findAll()) do
			local target = gold:get("target")
			if runData.nucleusGems[target] then
				if gold:getData().nucleusGem == nil then
					gold:getData().nucleusGem = true
					gold.sprite = sprGemDrop
				else
					local targetI = Object.findInstance(target)
					if targetI and targetI:isValid() then
						if global.timer % 10 == 0 then
							misc.fireExplosion(gold.x, gold.y, 5 / 19, 5 / 4, targetI:get("damage") * 0.25, targetI:get("team"), nil, spr.Sparks11)
						end
					end
				end
			end
		end
	end
end
it.NucleusGems:addCallback("pickup", function(player)
	if runData.nucleusGems then
		runData.nucleusGems[player.id] = true
	else
		runData.nucleusGems = {}
		runData.nucleusGems[player.id] = true
	end
	tcallback.register("onStep", onStepCall)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.NucleusGems and player:countItem(item) == 0 then
		runData.nucleusGems[player.id] = nil
	end
end)
if obj.NemesisMiner then
	NPC.registerBossDrops(obj.NemesisMiner, 100)
	NPC.addBossItem(obj.NemesisMiner, it.NucleusGems)
end