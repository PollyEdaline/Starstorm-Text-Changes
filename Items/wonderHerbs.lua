local path = "Items/Resources/"

it.WonderHerbs = Item.new("Wonder Herbs")
it.WonderHerbs.pickupText = "Slightly increase all healing effects." 
it.WonderHerbs.sprite = Sprite.load("WonderHerbs", path.."Wonder Herbs.png", 1, 15, 15)
it.WonderHerbs:setTier("common")
it.WonderHerbs:setLog{
	group = "common_locked",
	description = "Increases all &g&healing effects by 12%.",
	story = "Rikka! I heard you're working with the EC in making a new recipe. Here at the farm we've been growing some special herbs which we think may come handy as they are known for being very, very useful for treating physical and emotional wounds.\nIf you need some more don't hesitate to call me! XOXO\n- Eden",
	destination = "2342,\nPlot 3,\nEarth",
	date = "11/07/2056"
}
it.WonderHerbs:addCallback("pickup", function(player)
	player:set("herbs", (player:get("herbs") or 0) + 1)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.WonderHerbs then
		player:set("herbs", player:get("herbs") - amount)
	end
end)

callback.register("onActorStep", function(actor)
	local actorAc = actor:getAccessor()
	local wonderHerbs = actorAc.herbs
	if wonderHerbs and wonderHerbs > 0 then
		if (actor:getData().wlastHp or actorAc.hp) < actorAc.hp then
			local dif = actorAc.hp - actor:getData().wlastHp
			local add = dif * (0.12 * wonderHerbs)
			actorAc.hp = actorAc.hp + add
			if math.chance(3 + wonderHerbs) then
				par.SporeOld:burst("below", actor.x, actor.y, 1, Color.GREEN)
			end
		end
		actor:getData().wlastHp = actorAc.hp
	end
end)