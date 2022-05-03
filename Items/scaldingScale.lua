local path = "Items/Resources/"

it.ScaldingScale = Item.new("Scalding Scale")
it.ScaldingScale.pickupText = "Earn a massive armor boost." 
it.ScaldingScale.sprite = Sprite.load("Scalding Scale", path.."Scalding Scale.png", 1, 15, 15)
itp.legendary:add(it.ScaldingScale)
it.ScaldingScale.color = "y"
it.ScaldingScale:setLog{
	group = "boss",
	description = "&b&Increase your armor by 60.",
	story = "Soil burning, scarce resources and a threat of fortitude meant I had to fight like never before. But I am alive and this scale will serve me as a catalyst for the magnitude that my survival will convey.",
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