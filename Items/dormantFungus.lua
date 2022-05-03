local path = "Items/Resources/"

it.DormFungus = Item.new("Dormant Fungus")
local sDormFungus = Sound.load("DormantFungus", path.."dormantFungus")
it.DormFungus.pickupText = "Regenerate health while moving." 
it.DormFungus.sprite = Sprite.load("DormantFungus", path.."Dormant Fungus.png", 1, 10, 14)
it.DormFungus:setTier("common")
it.DormFungus:setLog{
	group = "common",
	description = "Regenerates 2% of your total health every second while moving.",
	story = "When you commanded me to explore the fungal caves all I expected to find was... well, fungi, of course. Though I wasn't excited by any means, this specimen caught my eye.\nIt seems to only grow around flowing water, and ever since I collected and contained this sample, both the colouration and the smell faded out quickly.\n\nI hope you can study it further.",
	priority = "&g&Priority&!&",
	destination = "Gate 1,\nModule 13,\nGea Station",
	date = "11/01/2056"
}
it.DormFungus:addCallback("pickup", function(player)
	player:set("mushroom2", (player:get("mushroom2") or 0) + 1)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.DormFungus then
		player:set("mushroom2", player:get("mushroom2") - amount)
	end
end)

callback.register("onActorStep", function(actor)
	local actorAc = actor:getAccessor()
	local actorData = actor:getData()
	
	local dormFungus = actor:get("mushroom2")
	if dormFungus and dormFungus > 0 then
		if actorAc.pHspeed ~= 0 or actorAc.pVspeed ~= 0 then
			if not actorData.dFTimer then
				actorData.dFTimer = 0
			end
			if actorData.dFTimer >= 120 and actorAc.hp < actorAc.maxhp then
				actorData.dFTimer = 0
				sDormFungus:play(0.9 + math.random() * 0.2)
				local dFRegen = math.ceil(actorAc.maxhp * (1 - 1 / (0.02 * dormFungus + 1)))
				actorAc.hp = actorAc.hp + dFRegen
				if global.showDamage then
					misc.damage(dFRegen, actor.x, actor.y - 5, false, Color.DAMAGE_HEAL)
				end
			else
				actorData.dFTimer = actorData.dFTimer + 1
			end
		end
	end
end)

callback.register("onDamage", function(target, damage, source)
	if damage > 0 and target and target:isValid() then
		target:getData().dFTimer = 0
	end
end)