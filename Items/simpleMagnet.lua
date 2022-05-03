local path = "Items/Resources/"

it.SimpleMagnet = Item.new("Simple Magnet")
local sSimpleMagnet = Sound.load("SimpleMagnet", path.."magnet")
it.SimpleMagnet.pickupText = "Pull surrounding pickups towards you. Chance to unearth a treasure." 
it.SimpleMagnet.sprite = Sprite.load("SimpleMagnet", path.."Simple Magnet.png", 2, 12, 13)
it.SimpleMagnet.isUseItem = true
it.SimpleMagnet.useCooldown = 20
it.SimpleMagnet:setTier("use")
itp.enigma:add(it.SimpleMagnet)
it.SimpleMagnet:setLog{
	group = "use",
	description = "&b&Pull the surrounding pickups towards you. &y&Chance to unearth a treasure.",
	story = "It doesn't have a strong magnetic effect but it's a pretty interesting magnet nonetheless. It's fun and intriguing to think people of the last century actually used them. Enjoy your purchase!\n\n-Ben's Antiques.",
	destination = "1124\nHill Hills,\nEarth",
	date = "11/08/2056"
}
local r = 400

local pullItems = {pobj.items, pobj.commandCrates, obj.EfGold}

local onPlayerStepCall = function(player)
	local playerData = player:getData()
	if playerData.magnetUse then
		if playerData.magnetUse > 0 then
			for _, obj in ipairs(pullItems) do
				for _, item in ipairs(obj:findAllEllipse(player.x - r, player.y - r, player.x + r, player.y + r)) do
					local difx, dify = item.x - player.x, item.y - player.y
					item.x = math.approach(item.x, player.x, difx * 0.1)
					item.y = math.approach(item.y, player.y, dify * 0.1)
					if playerData.magnetUse == 1 then
						item.y = player.y + 6
					end
					item:set("pVspeeed", 0)
				end
			end
			playerData.magnetUse = playerData.magnetUse - 1
		end
	end
end

local onPlayerDrawAboveCall = function(player)
	if player:getData().magnetUse and player:getData().magnetUse > 0 then
		local radius = math.cos((player:getData().magnetUse % 25) * 0.1) * 50
		
		graphics.color(Color.WHITE)
		graphics.alpha(0.6)
		graphics.circle(player.x, player.y, radius, true)
	end
end

it.SimpleMagnet:addCallback("use", function(player, embryo)
	sSimpleMagnet:play()
	local chance = 10
	if embryo then
		player:getData().magnetUse = 400
		chance = 20
	else
		player:getData().magnetUse = 200
	end
	if net.host and math.chance(chance) then
		local xx = player.x + math.random(-400, 400)
		itp.common:roll():getObject():create(xx, player.y + 8)
		sfx.Coin:play(0.5)
	end
	tcallback.register("onPlayerStep", onPlayerStepCall)
	tcallback.register("onPlayerDrawAbove", onPlayerDrawAboveCall)
end)