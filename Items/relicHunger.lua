
local path = "Items/Resources/"
itRelicForce = Item.new("Relic of Hunger")
itRelicForce.pickupText = "--." 
itRelicForce.sprite = Sprite.load("relicHunger", path.."Relic Of Hunger", 1, 15, 15)
ItemPool.find("relic", "Starstorm"):add(itRelicForce)
itRelicForce:setLog{
	group = "end",
	description = "--.",
	story = "Eventually, the need to kill took over, and I felt as if I were to stop, that I'd collapse and perish.",
	priority = "&b&Field-Found&!&",
	destination = "Unknown",
	date = "Unknown"
}

HungerExplosion = ParticleType.new("HungerExplosion")
HungerExplosion:color(Color.LIGHT_RED, nil, nil)
HungerExplosion:alpha(0.75, 0, 0.5)
HungerExplosion:direction(0, 360, 0, 30)
HungerExplosion:speed(1, 2, 0, 0.5)
HungerExplosion:life(30, 60)

