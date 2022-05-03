local path = "Items/Resources/"

it.BackThruster = Item.new("Back Thruster")
--local sBackThruster = Sound.load("BackThruster", path.."backThruster")
it.BackThruster.pickupText = "Gain a temporary acceleration boost." 
it.BackThruster.sprite = Sprite.load("BackThruster", path.."Back Thruster.png", 2, 15, 15)
it.BackThruster.isUseItem = true
it.BackThruster.useCooldown = 45
it.BackThruster:setTier("use")
itp.enigma:add(it.BackThruster)
it.BackThruster:setLog{
	group = "use",
	description = "&b&Gain an acceleration boost for 5 seconds.",
	story = "What to do, what to do? I know what I must do but I don't know if I should. Anyhow, This goes right into the back of the mainframe, model Epsilon-2. The problem is that I couldn't get it to do anything past the installation process so maybe you can install it for me, sent the mainframe in another shipment.",
	destination = "#55,\nAce Home,\nMars",
	date = "05/15/2056"
}
local onPlayerStepCall = function(player)
	if player:getData().thruster then
		local playerData = player:getData()
		local playerAc = player:getAccessor()
		if player:getData().thruster > 0 then
			if playerAc.moveRight == 1 then
				playerData.xAccel = math.min((playerData.xAccel or 0) + 0.15, 3.8)
			end
			if playerAc.moveLeft == 1 then
				playerData.xAccel = math.max((playerData.xAccel or 0) + -0.15, -3.8)
			end
			player:getData().thruster = player:getData().thruster - 1
		else
			player:getData().thruster = nil
			playerAc.walk_speed_coeff = playerData._thrusterWalkCoeff
		end
		if global.quality > 1 then
			par.FireIce:burst("middle", player.x + 2 * player.xscale * -1, player.y - 2, 1)
		end
	end
end
it.BackThruster:addCallback("use", function(player, embryo)
	if embryo then
		player:getData().thruster = 600
	else
		player:getData().thruster = 300
	end
	player:getData().xAccel = 1 * player.xscale
	sfx.MissileLaunch:play(1.2)
	player:getData()._thrusterWalkCoeff = player:get("walk_speed_coeff")
	player:set("walk_speed_coeff", 0.5)
	
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)