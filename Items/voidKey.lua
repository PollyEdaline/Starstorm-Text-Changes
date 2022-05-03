local path = "Items/Resources/"

it.VoidKey = Item.new("Void Key")
it.VoidKey.pickupText = "Calls for a Void Yielder." 
it.VoidKey.sprite = Sprite.load("VoidKeyItem", path.."Void Key.png", 1, 15, 14)
it.VoidKey.color = Color.fromHex(0xAB62CA)

local voidArrow = Sprite.load("VoidKeyArrow", path.."VoidKeyArrow.png", 1, 0, 6)

local onPlayerDrawCall = function(player)
	if player:countItem(it.VoidKey) > 0 then
		local yielder = nearestMatchingOp(player, obj.VoidYielder, "active", "==", 0)
		if yielder and yielder:isValid() then
			local angle = posToAngle(player.x, player.y, yielder.x, yielder.y)
			graphics.drawImage{
				image = voidArrow,
				x = player.x,
				y = player.y,
				alpha = 0.4 + math.sin(global.timer * 0.05) * 0.1,
				angle = angle
			}
		end
	end
end

it.VoidKey:addCallback("pickup", function(player)
	tcallback.register("onPlayerDraw", onPlayerDrawCall)
	misc.hud:set("objective_text", "Deactivate the Void Yielder.")
end)

callback.register("onPlayerDeath", function(player)
	if net.host and player:countItem(it.VoidKey) > 0 then
		for i = 1, player:countItem(it.VoidKey) do
			local ground = obj.B:findNearest(player.x, player.y)
			local groundL = ground.x - (ground.sprite.boundingBoxLeft * ground.xscale)
			local groundR = ground.x + (ground.sprite.boundingBoxRight * ground.xscale)
			local x = math.clamp(player.x, groundL, groundR)
			it.VoidKey:create(x, ground.y - 15)
		end
		player:removeItem(it.VoidKey, player:countItem(it.VoidKey))
	end
end)