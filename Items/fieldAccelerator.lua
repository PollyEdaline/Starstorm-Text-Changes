local path = "Items/Resources/"

it.FieldAccelerator = Item.new("Field Accelerator")
it.FieldAccelerator.pickupText = "Teleporters charge faster when no enemies are around."
it.FieldAccelerator.sprite = Sprite.load("FieldAccelerator", path.."Field Accelerator.png", 1, 15, 15)
it.FieldAccelerator:setTier("uncommon")
it.FieldAccelerator:setLog{
	group = "uncommon",
	description = "Increases teleporter &y&charge speed by 100%&!& while no enemies are nearby.",
	story = "After extensive testing the product is now ready to be shipping by the holidays, please contact our sponsors, I'll be away during the lockdown.\nRefrain from mentioning my cooperation with Dannah to the leads, we need to make sure we get the investment as soon as possible.\n\nReply with auth.",
	destination = "Room 14,\nBay 2,\nUES Gamma",
	date = "12/10/2056"
}

local fieldAccRange = 280

local onDrawCall = function()
	for _, tp in ipairs(obj.Teleporter:findAll()) do
		if tp:get("active") == 1 then
			local r = fieldAccRange
			local enemyFound = false
			
			for _, actor in ipairs(pobj.enemies:findAllEllipse(tp.x - r, tp.y - r, tp.x + r, tp.y + r)) do
				if actor:get("team") == "enemy" then
					enemyFound = true
					break
				end
			end
			
			local draw
			
			for _, player in ipairs(misc.players) do
				local c = player:countItem(it.FieldAccelerator)
				if c > 0 and player:get("dead") == 0 then
					if not enemyFound then
						tp:set("time", tp:get("time") + 1 * c)
					end
					draw = true
				end
			end
			
			if not enemyFound then
				if tp.visible and draw then
					par.SporeOld:burst("middle", tp.x, tp.y - 2, 1, Color.fromHex(0x93E1B2))
					graphics.setBlendMode("additive")
					graphics.drawImage{
						image = tp.sprite,
						x = tp.x,
						y = tp.y,
						xscale = tp.xscale,
						yscale = tp.yscale,
						solidColor = Color.fromHex(0x93E1B2),
						alpha = 0.3 * tp.alpha,
						angle = tp.angle
					}
					graphics.setBlendMode("normal")
				end
				
				graphics.color(Color.fromHex(0x93E1B2))
			else
				graphics.color(Color.RED)
			end
			
			if draw then
				graphics.alpha(0.3 + math.sin(global.timer * 0.05) * 0.2)
				graphics.circle(tp.x, tp.y, r, true)
			end
		end
	end
end

it.FieldAccelerator:addCallback("pickup", function(player)
	tcallback.register("onDraw", onDrawCall)
end)