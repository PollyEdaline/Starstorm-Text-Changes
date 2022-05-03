local path = "Items/Resources/"

it.CursePoverty = Item.new("Curse of Poverty")
it.CursePoverty.pickupText = "Lose gold every second." 
it.CursePoverty.sprite = Sprite.load("CursePoverty", path.."Curse of Poverty.png", 1, 15, 15)
itp.curse:add(it.CursePoverty)
it.CursePoverty.color = "dk"

local onPlayerStepCall = function(player)
	local playerData = player:getData()
	if not net.online or player == net.localPlayer then
		local curse = player:countItem(it.CursePoverty)
		if curse > 0 then
			if global.timer % 60 == 0 then
				local cGold = misc.getGold()
				misc.setGold(math.max(cGold - math.ceil(cGold * (0.002 + 0.004 * curse)), 0))
			end
		end
	end
end

it.CursePoverty:addCallback("pickup", function(player)
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)