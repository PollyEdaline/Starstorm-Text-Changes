local path = "Items/Resources/"

it.PressurizedPropeller = Item.new("Pressurized Canister")
local sPressurizedPropeller = Sound.load("PressurizedCanister", path.."pressurizedPropeller")
it.PressurizedPropeller.pickupText = "Launch yourself high in the air." 
it.PressurizedPropeller.sprite = Sprite.load("PressurizedPropeller", path.."Pressurized Propeller.png", 2, 8, 14)
it.PressurizedPropeller.isUseItem = true
it.PressurizedPropeller.useCooldown = 15
it.PressurizedPropeller:setTier("use")
itp.enigma:add(it.PressurizedPropeller)
it.PressurizedPropeller:setLog{
	group = "use",
	description = "&b&Launch yourself high in the air.",
	story = "'A swift, highly pressurized canister that makes sure nothing is too heavy for any machine to lift!' Does this sound good for the ad? You do you, but ya gotta sell it real good if we want some $ our way this summer... Also, friendly reminder to handle it carefully and all that jazz.",
	destination = "Joe,\nMaL,\nIgma",
	date = "01/02/2056"
}
local onPlayerStepCall = function(player)
	if player:getData().propeller then
		if player:getData().propeller > 0 then
			player:set("pVspeed", math.approach(player:get("pVspeed"), - 4, player:getData().propeller * 0.01))
			player:getData().propeller = player:getData().propeller - 1
		else
			player:getData().propeller = nil
		end
		if global.quality > 1 then
			par.JellyDust:burst("middle", player.x, player.y, 1)
		end
	end
end

it.PressurizedPropeller:addCallback("use", function(player, embryo)
	if embryo then
		player:getData().propeller = 140
	else
		player:getData().propeller = 70
	end
	sPressurizedPropeller:play()
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)