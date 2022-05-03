local relicColor = Color.fromHex(0xC649AD)

itp.relic = ItemPool.new("Relic")

local path = "Items/"

require(path.."relicForce")

require(path.."relicTermination")

require(path.."relicMass")

require(path.."relicVitality")

require(path.."relicDuality")

require(path.."relicExtinction")

require(path.."relicEchelon")

require(path.."relicEntropy")

--require(path.."relicHunger")

local itRelicofUh = Item.new("Relic of uuuh")
itRelicofUh.pickupText = "new relic" 
itRelicofUh.sprite = Sprite.load("RelicUuuh", "Items/Resources/Relic of uuuh.png", 1, 15, 15)
itRelicofUh.color = relicColor
itRelicofUh:addCallback("pickup", function(player)
	runData.inSpanishPlease = true
end)

if global.rormlflag.ss_april_fools_2020 then
	itRelicBoar = Item.new("Relic Boar")
	itRelicBoar.pickupText = "Boar time BUT Boar time."
	itRelicBoar.sprite = Sprite.load("RelicBoar", "Items/Resources/Holidays/boar5.png", 1, 11, 9)
	itp.relic:add(itRelicBoar)
	itRelicBoar.color = relicColor
	itRelicBoar:setLog{
		group = "boss_locked",
		description = "Boars shall control.",
		story = "",
		destination = "B,\nO,\nAR",
		date = "01/04/2057"
	}
	itRelicBoar:addCallback("pickup", function(player)
		sfx.BoarDeath:play(0.4)
	end)
end