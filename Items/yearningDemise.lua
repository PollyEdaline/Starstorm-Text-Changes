local path = "Items/Resources/"

it.YearningDemise = Item.new("Yearning Demise")
--local sYearningDemise = Sound.load("YearningDemise", path.."yearningDemise")
it.YearningDemise.pickupText = "It's never enough." 
it.YearningDemise.sprite = Sprite.load("YearningDemise", path.."Yearning Demise.png", 1, 14, 12)
itp.sibylline:add(it.YearningDemise)
it.YearningDemise.color = Color.fromHex(0xFFCCED)
it.YearningDemise:setLog{
	group = "end",
	description = "Picking up items &y&obliterates near enemies.",
	story = "As I fought, I kept looking for more. More things to collect, more power. I had long since become the embodiment of all that contaminates our race.\n...and yet, it wasn't enough.",
	priority = "&"..it.StirringSoul.color.gml.."&Unknown",
	destination = "",
	date = "Unknown"
}
if obj.NemesisBandit then
	NPC.registerBossDrops(obj.NemesisBandit, 100)
	NPC.addBossItem(obj.NemesisBandit, it.YearningDemise)
end
callback.register("onItemPickup", function(item, player)
	if player:countItem(it.YearningDemise) > 0 and item:get("is_use") == 0 then
		local enemy = nearestMatchingOp(player, pobj.actors, "team", "~=", player:get("team"))
		if enemy then
			local smite = obj.EfSmite:create(enemy.x, enemy.y)
			smite:set("team", player:get("team"))
			smite:set("damage", player:get("damage") * 20)
			smite:setAlarm(0, 15)
		end
	end
end)