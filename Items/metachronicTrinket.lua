local path = "Items/Resources/"

it.Metatrinket = Item.new("Metachronic Trinket")
local sMetatrinket = Sound.load("MetachronicTrinket", path.."metachronicTrinket")
it.Metatrinket.pickupText = "Reduce teleporter charge time." 
it.Metatrinket.sprite = Sprite.load("MetachronicTrinket", path.."Metachronic Trinket.png", 1, 14, 14)
it.Metatrinket:setTier("uncommon")
it.Metatrinket:setLog{
	group = "uncommon_locked",
	description = "Reduce &y&teleporter charge time by 5 seconds.",
	story = [["Time is the most valuable resource of all the universe", my mother used to say, but the more time I spend with this, the more I realize how wrong she was, how naive I've been.
Maybe nothing is what we believe, our strides towards knowledge could be in vain but for all I've done I can tell you, the time echoes your name.]],
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