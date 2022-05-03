local path = "Items/Resources/"

it["3DVisor"] = Item.new("3D Visor")
local s3DVisor = Sound.load("3DVisor", path.."toys")
it["3DVisor"].pickupText = "."
it["3DVisor"].sprite = Sprite.load("3DVisor", path.."3D Visor.png", 1, 15, 15)
it["3DVisor"]:setTier("rare")
it["3DVisor"]:setLog{
	group = "rare_locked",
	description = "",
	story = "",
	destination = "431,\nGolden Shore,\nEarth",
	date = "06/07/2056"
}
callback.register("onItemRemoval", function(player, item, amount)
	if item == it["3DVisor"] then
		
	end
end)

local drawCall = function()
	graphics.setBlendMode("additive")
	local off = math.sin(global.timer * 0.1) * 0.7 + 1.5--2
	local alpha = 0.5--math.sin(global.timer * 0.1) * 0.2 + 0.2
	for _, enemy in ipairs(pobj.enemies:findAll()) do
		if onScreen(enemy) then
			graphics.drawImage{
				image = enemy.sprite,
				subimage = enemy.subimage,
				x = enemy.x - off,
				y = enemy.y,
				solidColor = Color.fromHex(0x00FFFF),
				xscale = enemy.xscale,
				yscale = enemy.yscale,
				angle = enemy.angle,
				alpha = enemy.alpha * alpha
			}
			graphics.drawImage{
				image = enemy.sprite,
				subimage = enemy.subimage,
				x = enemy.x + off,
				y = enemy.y,
				solidColor = Color.RED,
				xscale = enemy.xscale,
				yscale = enemy.yscale,
				angle = enemy.angle,
				alpha = enemy.alpha * alpha
			}
		end
	end
	graphics.setBlendMode("normal")
end

it["3DVisor"]:addCallback("pickup", function(player)
	--tcallback.register("onDraw", drawCall)
	graphics.bindDepth(-6, drawCall)
end)
