local path = "Items/Resources/"

it.PeculiarRock = Item.new("Suspicious Stone")
it.PeculiarRock.pickupText = "Not useful to me.." 
it.PeculiarRock.sprite = Sprite.load("PeculiarRock", path.."Peculiar Rock.png", 1, 15, 15)
it.PeculiarRock.color = "p"

--it.PeculiarRock:addCallback("pickup", function(player)
	-- hi
	-- hello!
--end)