local path = "Items/Resources/"

it.FracturedCrown = Item.new("Fractured Crown")
local sFracturedCrown = Sound.load("FracturedCrown", path.."fracturedCrown")
it.FracturedCrown.pickupText = "You feel a great power grow inside you.." 
it.FracturedCrown.sprite = Sprite.load("FracturedCrown", path.."Fractured Crown.png", 2, 13, 13)
it.FracturedCrown.isUseItem = true
it.FracturedCrown.useCooldown = 0
it.FracturedCrown.color = "or"
itp.elite:add(it.FracturedCrown)
it.FracturedCrown:setLog{
	group = "use_locked",
	description = "&y&Become an aspect of gold&!&.",
	story = "It came to me in an unexpected onset of events. A crown, a broken gilded crown which brings unreal strength and fortitude to those who take hold of it.\nHowever, what it gave me is a growing sense of danger. I am not the true heir.",
	priority = "&b&Field-Found&!&",
	destination = "Unknown",
	date = "Unknown"
}
table.insert(specialUseItems, it.FracturedCrown)
it.FracturedCrown:addCallback("use", function(player)
	sfx.Pickup:stop()
end)
local postPlayerStepCall = function(player)
	local playerAc = player:getAccessor()
	if player.useItem == it.FracturedCrown or contains(player:getData().mergedItems, it.FracturedCrown) then
		if not player:getData().fracturedCrown then
			if sFracturedCrown then 
				sFracturedCrown:play(0.7)
			end
			playerAc.gilded = 1
			player:getData().gilded_cooldown = 100
			player:getData().gilded_charge = 0
			player:getData().fracturedCrown = true
		end
	elseif player:getData().fracturedCrown then
		player:getData().fracturedCrown = nil
		playerAc.gilded = nil
		player:getData().gilded_cooldown = 0
		player:getData().gilded_aim = nil
		player:getData().gilded_charge = 0
	end
end
itp.use:remove(it.FracturedCrown)

it.FracturedCrown:addCallback("pickup", function(player)
	tcallback.register("postPlayerStep", postPlayerStepCall)
end)