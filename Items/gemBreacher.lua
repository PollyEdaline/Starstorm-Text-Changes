local path = "Items/Resources/"

it.GemBreacher = Item.new("Gem-Breacher")
--local sGemBreacher = Sound.load("GemBreacher", path.."")
it.GemBreacher.pickupText = "Critical strikes give you temporary shield."
it.GemBreacher.sprite = Sprite.load("GemBreacher", path.."Gem Breacher.png", 1, 15, 16)
it.GemBreacher:setTier("rare")
it.GemBreacher:setLog{
	group = "rare_locked",
	description = "&y&Critical strikes give you &b&+3 temporary shield. &!&Up to 500",
	story = "Your continued correspondence, as always, has been exceptionally helpful in our endeavor. \n\nWith our most recent prototype, the Mark I, gem core stability is up by sixteen percent, and our team estimates that number will double with our next model. \n\nOne major problem still remains; efficiency. Our facilities are no longer equipped to handle the electrical burden of this prototype. Further testing will have to be reserved for the Mark II.\n\nFor now, I’ve sent the Mark I as a keepsake, dedicated to your generosity, forgiveness, and - hopefully - continued support thru grant.\n\nSincerely: Alex Deluca.",
	destination = "Oncorp,\nSchwerin,\nEarth",
	date = "2/02/2056"
}
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.GemBreacher then
		player:getData().hitShield = player:getData().hitShield - 1
	end
end)

local onHitCall = function(damager, hit)
	local parent = damager:getParent()
	if parent and parent:isValid() and parent:getData().hitShield and damager:get("critical") > 0 then
		if not parent:getData().tempShield or parent:getData().tempShield < 500 * parent:getData().hitShield then
			parent:getData().tempShield = (parent:getData().tempShield or 0) + 3 --1 + 2 * parent:getData().hitShield
			if global.quality > 1 then
				par.MagicSquares:burst("above", parent.x, parent.y, 1)
			end
		end
	end
end

local onPlayerStepCall = function(player)
	if player:countItem(it.GemBreacher) > 0 and global.timer % 80 == 0 then
		obj.EfOutline:create(0, 0):set("persistent", 1):set("parent", player.id):set("rate", 0.05).blendColor = Color.fromHex(0x44AA73)
	end
end

it.GemBreacher:addCallback("pickup", function(player)
	player:getData().hitShield = (player:getData().hitShield or 0) + 1
	tcallback.register("onHit", onHitCall)
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)