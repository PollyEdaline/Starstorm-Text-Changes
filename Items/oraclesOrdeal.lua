local path = "Items/Resources/"

it.OraclesOrdeal = Item.new("Oracle's Ordeal")
--local sOraclesOrdeal = Sound.load("OraclesOrdeal", path.."oraclesordeal")
it.OraclesOrdeal.pickupText = "Revelation upon my eyes." 
it.OraclesOrdeal.sprite = Sprite.load("OraclesOrdeal", path.."Oracle's Ordeal.png", 1, 16, 16)
itp.sibylline:add(it.OraclesOrdeal)
it.OraclesOrdeal.color = Color.fromHex(0xFFCCED)
it.OraclesOrdeal:setLog{
	group = "end",
	description = "The location of points of interest is &y&always revealed&!&.",
	story = "It came to my mind as a blinding light at the end of the corridor. It was clear now: where I had to go, what I had to do. Until the light faded.",
	priority = "&"..it.OraclesOrdeal.color.gml.."&Unknown",
	destination = "",
	date = "Unknown"
}
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.OraclesOrdeal then
		player:set("oraclesordeal", player:get("oraclesordeal") - amount)
	end
end)
if obj.NemesisSniper then
	NPC.registerBossDrops(obj.NemesisSniper, 100)
	NPC.addBossItem(obj.NemesisSniper, it.OraclesOrdeal)
end

local sprArrow = Sprite.load("OracleArrow", path.."oracleArrow", 4, 0, 6)
local onPlayerDrawAboveCall = function(player)
	if player:get("oraclesordeal") and player:get("oraclesordeal") > 0 then
		local alpha = math.sin(global.timer * 0.1) * 0.1
		for _, teleporter in ipairs(obj.Teleporter:findMatchingOp("active", "<", 3)) do
			local angle = posToAngle(player.x, player.y, teleporter.x, teleporter.y)
			local angle2 = math.rad(posToAngle(player.x, teleporter.y, teleporter.x, player.y))
			if teleporter:get("isBig") then
				if not teleporter:getData().lock then
					graphics.drawImage{
						image = sprArrow,
						x = player.x + math.cos(angle2) * 13,
						y = player.y + math.sin(angle2) * 13,
						angle = angle,
						subimage = 2,
						scale = 0.8,
						color = Color.fromHex(0x00D6A3),
						alpha = 0.7 + alpha
					}
				end
			elseif teleporter:get("locked") == 0 then
				graphics.drawImage{
					image = sprArrow,
					x = player.x + math.cos(angle2) * 13,
					y = player.y + math.sin(angle2) * 13,
					angle = angle,
					subimage = 1,
					scale = 0.8,
					color = Color.fromHex(0xCE2500),
					alpha = 0.7 + alpha
				}
			end
		end
		for _, artifact in ipairs(pobj.artifacts:findAll()) do
			local angle = posToAngle(player.x, player.y, artifact.x, artifact.y)
			local angle2 = math.rad(posToAngle(player.x, artifact.y, artifact.x, player.y))
			graphics.drawImage{
				image = sprArrow,
				x = player.x + math.cos(angle2) * 13,
				y = player.y + math.sin(angle2) * 13,
				angle = angle,
				subimage = 3,
				scale = 0.8,
				color = Color.fromHex(0xBA0092),
				alpha = 0.7 + alpha
			}
		end
		local nearestItem
		if ar.Command.active then
			nearestItem = pobj.commandCrates:findNearest(player.x, player.y)
		else
			nearestItem = pobj.items:findNearest(player.x, player.y)
		end
		if nearestItem then
			if nearestItem:get("used") ~= 1 then 
				local angle = posToAngle(player.x, player.y, nearestItem.x, nearestItem.y)
				local angle2 = math.rad(posToAngle(player.x, nearestItem.y, nearestItem.x, player.y))
				graphics.drawImage{
					image = sprArrow,
					x = player.x + math.cos(angle2) * 15,
					y = player.y + math.sin(angle2) * 15,
					angle = angle,
					subimage = 4,
					scale = 0.8,
					color = Color.fromHex(0xABD8D4),
					alpha = 0.7 + alpha
				}
			end
		end
	end
end

it.OraclesOrdeal:addCallback("pickup", function(player)
	player:set("oraclesordeal", (player:get("oraclesordeal") or 0) + 1)
	tcallback.register("onPlayerDrawAbove", onPlayerDrawAboveCall)
end)