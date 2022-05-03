local path = "Items/Resources/"

	it.CommonBoar = Item.new("Common Boar")
	it.CommonBoar.pickupText = "Boar timeeeeeeeee"
	it.CommonBoar.sprite = Sprite.load("CommonBoar", path.."Holidays/boar1.png", 1, 11, 6)
	it.CommonBoar:setTier("common")
	it.CommonBoar:setLog{
		group = "common",
		description = "Boars shall rise.",
		story = "",
		destination = "B,\nO,\nAR",
		date = "1/4/2057"
	}
	it.CommonBoar:addCallback("pickup", function(player)
		sfx.BoarDeath:play(0.8)
	end)
	
	it.UncommonBoar = Item.new("Shirted Boar")
	it.UncommonBoar.pickupText = "Boar timeeeeeeeeeeeeeeee"
	it.UncommonBoar.sprite = Sprite.load("UncommonBoar", path.."Holidays/boar2.png", 1, 11, 6)
	it.UncommonBoar:setTier("uncommon")
	it.UncommonBoar:setLog{
		group = "uncommon",
		description = "Boars shall stand.",
		story = "",
		destination = "B,\nO,\nAR",
		date = "1/4/2057"
	}
	it.UncommonBoar:addCallback("pickup", function(player)
		sfx.BoarDeath:play(0.7)
	end)
	
	it.CoolBoar = Item.new("Coolest Boar")
	it.CoolBoar.pickupText = "Boar timeeeeeeeeeeeeeeeeeeeeee"
	it.CoolBoar.sprite = Sprite.load("RareBoar", path.."Holidays/boar3.png", 1, 11, 6)
	it.CoolBoar:setTier("rare")
	it.CoolBoar:setLog{
		group = "rare",
		description = "Boars shall persist.",
		story = "",
		destination = "B,\nO,\nAR",
		date = "1/4/2057"
	}
	it.CoolBoar:addCallback("pickup", function(player)
		sfx.BoarDeath:play(0.6)
	end)
	
	it.CrownBoar = Item.new("Crowned Boar")
	it.CrownBoar.pickupText = "Boar timeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee"
	it.CrownBoar.sprite = Sprite.load("LegendaryBoar", path.."Holidays/boar4.png", 1, 11, 7)
	itp.legendary:add(it.CrownBoar)
	it.CrownBoar.color = "y"
	it.CrownBoar:setLog{
		group = "boss",
		description = "Boars shall reign.",
		story = "",
		destination = "B,\nO,\nAR",
		date = "1/4/2057"
	}
	it.CrownBoar:addCallback("pickup", function(player)
		sfx.BoarDeath:play(0.5)
	end)