local path = "Items/Resources/"

it.Metatrinket = Item.new("Metachronic Trinket")
local sMetatrinket = Sound.load("MetachronicTrinket", path.."metachronicTrinket")
it.Metatrinket.pickupText = "Teleporters charge faster." 
it.Metatrinket.sprite = Sprite.load("MetachronicTrinket", path.."Metachronic Trinket.png", 1, 14, 14)
it.Metatrinket:setTier("uncommon")
it.Metatrinket:setLog{
	group = "uncommon_locked",
	description = "Reduces &y&Teleporter charge time by 10 seconds.",
	story = [["Time is the most valuable resource in the universe", my mother used to say. But the more time I spend with this, the more I realize how wrong she was, and how naive I've been.
Maybe nothing is what we think it is. Our quest for knowledge could be in vain, but there's one thing I can tell you': Time echoes your name.]],
	destination = "P2592323,\nSagooj,\nEarth",
	date = "11/11/2056"
}

local onStepCall = function()
	for _, teleporter in pairs(obj.Teleporter:findAll()) do
		if teleporter:get("active") > 0 and teleporter:get("maxtime") > 900 and not teleporter:getData().started and Stage.getCurrentStage() ~= stg.BoarBeach then
			local metaTrinketed = false
			for p, player in ipairs(misc.players) do
				local metaTrinket = player:countItem(it.Metatrinket)
				if metaTrinket > 0 then
					metaTrinketed = true
					teleporter:set("maxtime", math.max(teleporter:get("maxtime") - (metaTrinket * 600), 900))
				end
			end
			if onScreen(teleporter) and metaTrinketed == true then 
				sMetatrinket:play()
			end
			teleporter:getData().started = true
		end
	end
end

it.Metatrinket:addCallback("pickup", function(player)
	tcallback.register("onStep", onStepCall)
end)