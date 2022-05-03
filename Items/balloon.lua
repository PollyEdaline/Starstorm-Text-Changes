local path = "Items/Resources/"

it.Balloon = Item.new("Balloon")
local balloonDis = Sprite.load("BalloonDisplay", path.."balloondis.png", 6, 2, 5)
it.Balloon.pickupText = "Lower your gravity." 
it.Balloon.sprite = Sprite.load("Balloon", path.."Balloon.png", 1, 10, 14)
it.Balloon:setTier("uncommon")
it.Balloon:setLog{
	group = "uncommon",
	description = "&b&Lower your gravity by 30%&!&.",
	story = "When I was younger I used to love balloons. They're' quite fun to watch in places with an atmosphere. However, this one is of special value to me, as it was of the first ones to be made out of reinforced rubber, back in the '22s. I hope you take care of it, it might cost a fortune in a few more years (if it's still floating, of course!).",
	priority = "&g&Priority/Fragile&!&",
	destination = "55 Mo.,\nPaare Plaza,\nEarth",
	date = "06/31/2056"
}
local onPlayerStepCall = function(player)
	local playerAc = player:getAccessor()
	
	local balloon = player:countItem(it.Balloon)
	if balloon > 0 then
		if playerAc.free == 1 and playerAc.ropeDown == 1 then
			playerAc.pVspeed = playerAc.pVspeed + (playerAc.pGravity1 * balloon)
		end
	end
end
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.Balloon then
		amount = math.min(amount, 40)
		player:set("pGravity1", math.max(player:get("pGravity1") + 0.1 * amount, 0.06))
		player:set("pGravity2", math.max(player:get("pGravity2") + 0.1 * amount, 0.06))
		player:set("pVmax", player:get("pVmax") - (amount * 0.08))
	end
end)


local onPlayerDrawBelowCall = function(player)
	local balloon = player:countItem(it.Balloon)
	if balloon > 0 and global.quality > 1 then
		local bdata = player:getData().balloonData
		for i = 1, balloon do
			if not bdata[i] then bdata[i] = {x = player.x, y = player.y} end
			
			local t = global.timer + i
			
			local xnew = player.x + (math.cos(i * (math.tan(i) * 0.2)) * (i * 0.4))
			local xdif = bdata[i].x - xnew
			local ynew = player.y - 7.6 + (math.sin(i * (math.tan(i) * 0.2)) * (i * 0.4)) + math.sin((t + i) * 0.05)
			local ydif = bdata[i].y - ynew
			
			bdata[i].x = math.approach(bdata[i].x, xnew, xdif * ((math.cos(i * 0.8) * 0.06) + 0.12))
			bdata[i].y = math.approach(bdata[i].y, ynew, ydif * ((math.cos(i * 0.8) * 0.06) + 0.14))
			
			graphics.drawImage{
				image = balloonDis,
				x = bdata[i].x,
				y = bdata[i].y,
				subimage = i % 6,
				alpha = 0.62
			}
			if global.quality == 3 then
				graphics.color(Color.GRAY)
				graphics.alpha(0.3)
				graphics.line(bdata[i].x, bdata[i].y, player.x, player.y, 0.8)
			end
		end
	end
end

it.Balloon:addCallback("pickup", function(player)
	local balloon = player:countItem(it.Balloon)
	if balloon <= 40 then
		player:set("pGravity1", math.max(player:get("pGravity1") - 0.1 / balloon, 0.06))
		player:set("pGravity2", math.max(player:get("pGravity2") - 0.1 / balloon, 0.06))
		player:set("pVmax", player:get("pVmax") + 0.08)
	end
	player:getData().balloonData = {}
	tcallback.register("onPlayerStep", onPlayerStepCall)
	tcallback.register("onPlayerDrawBelow", onPlayerDrawBelowCall)
end)