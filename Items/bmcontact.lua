local path = "Items/Resources/"

it.BlackMarketContact = Item.new("Black Market Contact")
it.BlackMarketContact.pickupText = "Sell a kidney." 
it.BlackMarketContact.sprite = spr.Keycard--Sprite.load("", path.."White.png", 2, 15, 14)
it.BlackMarketContact.isUseItem = true
it.BlackMarketContact.useCooldown = 45
it.BlackMarketContact.color = "or"

it.BlackMarketContact:addCallback("use", function(player)
	misc.hud:set("gold", misc.hud:get("gold") + 800000)
	if player:getData().soldAKidney then
		player:kill()
	else
		player:getData().soldAKidney = true
	end
end)