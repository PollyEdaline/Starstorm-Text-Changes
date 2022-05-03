local relicColor = Color.fromHex(0xC649AD)

local itRelicMass = Item.new("Relic of Mass")
local sprRelicMass = Sprite.load("RelicMassDisplay", "Items/Resources/relicMassdis.png", 1, 10, 10)
itRelicMass.pickupText = "Your health is doubled BUT your movement has momentum." 
itRelicMass.sprite = Sprite.load("RelicMass", "Items/Resources/Relic of Mass.png", 1, 12, 13)
itp.relic:add(itRelicMass)
itRelicMass.color = relicColor
itRelicMass:setLog{
	group = "end",
	description = "&g&Double your total health &p&BUT &r&your movement has momentum.",
	story = "A long-due fatigue led me to the ancient stone, rewarding me with will to endure the pain and outweight my situation.",
	priority = "&b&Field-Found&!&",
	destination = "Unknown",
	date = "Unknown"
}
callback.register("onItemRemoval", function(player, item, amount)
	if item == itRelicMass then
		player:set("percent_hp", player:get("percent_hp") / (2 ^ amount))
		player:set("pHmax", player:get("pHmax") / (0.4 ^ amount))
		if player:countItem(item) == 0 then
			player:set("hud_health_color", Color.fromHex(0x88D367).gml)
		end
	end
end)

local onPlayerStepCall = function(player)
	local relicMass = player:countItem(itRelicMass)
	if relicMass > 0 then
		local playerAc = player:getAccessor()
		local move = 0
		if playerAc.moveLeft == 1 then
			move = 1
		elseif playerAc.moveRight == 1 then
			
			move = 1
		elseif playerAc.ropeUp == 1 and playerAc.activity == 30 then
			move = 1
		elseif playerAc.ropeDown == 1 and playerAc.activity == 30 then
			move = 1
		end

		if move == 1 then
			playerAc.pHmax = playerAc.pHmax + (0.019 / relicMass)
			player:getData().massSpeed = player:getData().massSpeed + (0.019 / relicMass)
		else
			playerAc.pHmax = playerAc.pHmax - player:getData().massSpeed
			player:getData().massSpeed = 0
		end

		if playerAc.pHspeed == 0 and playerAc.activity ~= 30 then
			playerAc.pHmax = playerAc.pHmax - player:getData().massSpeed
			player:getData().massSpeed = 0
		end
		if playerAc.pHmax < 0.2 then playerAc.pHmax = 0.2 end
	end
end

local onPlayerDrawCall = function(player)
	local relicMass = player:countItem(itRelicMass)
	if relicMass > 0 then
		graphics.drawImage{image = sprRelicMass, x = player.x, y = player.y, alpha = 0.35, angle = math.random(0,360)}
	end
end

itRelicMass:addCallback("pickup", function(player)
	player:getData().massSpeed = 0
	player:set("percent_hp", player:get("percent_hp") * (2))
	player:set("pHmax", player:get("pHmax") * 0.4)
	local color = Color.mix(Color.fromGML(player:get("hud_health_color")), Color.fromRGB(183,145,111), 0.5)
	player:set("hud_health_color", color.gml)
	tcallback.register("onPlayerStep", onPlayerStepCall)
	tcallback.register("onPlayerDraw", onPlayerDrawCall)
end)