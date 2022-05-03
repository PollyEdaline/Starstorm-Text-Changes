local path = "Items/Resources/"

it.ScaldingScale = Item.new("Scalding Scale")
it.ScaldingScale.pickupText = "Gain a massive Armor boost." 
it.ScaldingScale.sprite = Sprite.load("Scalding Scale", path.."Scalding Scale.png", 1, 15, 15)
itp.legendary:add(it.ScaldingScale)
it.ScaldingScale.color = "y"
it.ScaldingScale:setLog{
	group = "boss",
	description = "&b&Increase Armor by 60.",
	story = "Burning soil, scarce resources and a resilient threat meant I had to fight like never before. But I am alive, and this scale will serve as proof of my achievement.",
	priority = "&b&Field-Found&!&",
	destination = "STAR Museum,\nLone Summit,\nEarth",
	date = "Unknown"
}
NPC.addBossItem(obj.Turtle, it.ScaldingScale)
it.ScaldingScale:addCallback("pickup", function(player)
	player:set("armor", player:get("armor") + 60)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.ScaldingScale then
		player:set("armor", player:get("armor") - (60 * amount))
	end
end)