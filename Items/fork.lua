local path = "Items/Resources/"

it.Fork = Item.new("Fork")
it.Fork.pickupText = "Deal more damage." 
it.Fork.sprite = Sprite.load("Fork", path.."Fork.png", 1, 13, 14)
it.Fork:setTier("common")
it.Fork:setLog{
	group = "common_locked",
	description = "Increases your &y&base damage by 3&!&.",
	story = "Surprise! A fork! Hahaha!!!\nYou said any gift was a good gift, HERE YOU GO! Jokes aside, this fork is magical. Trust me Duncan, I once got to eat a salad with it and later that same day I found a cent!\nAlso uh please come play with us someday soon, we miss destroying your build in SS3 (please tell me you changed your main, lol).",
	destination = "Antima Building - Rooftop,\nBloosom Hills,\nEarth",
	date = "09/24/2056"
}
it.Fork:addCallback("pickup", function(player)
	player:set("damage", player:get("damage") + 3)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.Fork then
		player:set("damage", player:get("damage") - (3 * amount))
	end
end)