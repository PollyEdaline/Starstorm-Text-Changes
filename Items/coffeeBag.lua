local path = "Items/Resources/"

it.CoffeeBag = Item.new("Coffee Bag")
it.CoffeeBag.pickupText = "Move and attack faster." 
it.CoffeeBag.sprite = Sprite.load("CoffeBag", path.."Coffee Bag", 1, 15, 15)
it.CoffeeBag:setTier("common")
it.CoffeeBag:setLog{
	group = "common",
	description = "Increases &b&movement speed by 10%&!& and &y&attack speed by 7%." ,
	story = "Sleeeeeeeeeeepyheaaaaaaaaaaaaaaad idk why u say u dont like coffee its so gooooood for staying up. Ik ik theres other other ways to get hyped but oh boy I think u will dig this one, its my favorite!!! give it a try before yelling at me mmkay?",
	destination = "n1,\nThe Capital,\nUES PRIME",
	date = "05/22/2056"
}
it.CoffeeBag:addCallback("pickup", function(player)
	player:set("pHmax", player:get("pHmax") + 0.09)
	player:set("attack_speed", player:get("attack_speed") + 0.075)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.CoffeeBag then
		player:set("pHmax", player:get("pHmax") - (0.09 * amount))
		player:set("attack_speed", player:get("attack_speed") - (0.075 * amount))
	end
end)