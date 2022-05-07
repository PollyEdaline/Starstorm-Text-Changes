local path = "Items/Resources/"

it.Needles = Item.new("Needles")
it.Needles.pickupText = "Chance on hit to mark enemies for guaranteed Critical Strikes." 
it.Needles.sprite = Sprite.load("Needles", path.."Needles.png", 1, 15, 15)
it.Needles:setTier("common")
it.Needles:setLog{
	group = "common_locked",
	description = "4% chance on hit to &y&mark enemies&!& for 100% &y&Critical Strike chance against them.",
	story = "Uh.. madre dice que si puedes leer esto, es porque no eres tan torpe como pensaba, y pues eso. Esperamos que te sirvan estas agujas. Me temo que no son las que pediste, pero no hace mucha diferencia, pienso.\nNo recuerdo si los enviamos bien embalados. Ten cuidado.",
	priority = "&y&Piercing&!&",
	destination = "E2,\nOren's Loop,\nVenus",
	date = "[REDACTED]"
}
it.Needles:addCallback("pickup", function(player)
	player:set("needles", (player:get("needles") or 0) + 1)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.Needles then
		player:set("needles", player:get("needles") - amount)
	end
end)

table.insert(call.onFireSetProcs, function(damager, parent)
	if parent:isValid() then
		local needles = parent:get("needles")
		if needles and needles > 0 then
			damager:set("needles", needles)
		end
	end
end)

table.insert(call.preHit, function(damager, hit)
	local needles = damager:get("needles")
	if needles and needles > 0 then
		if math.chance(2 + 2 * needles) then
			applySyncedBuff(hit, buff.needles, 190, true)
		end
	end
end)