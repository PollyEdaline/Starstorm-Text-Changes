local path = "Items/Resources/"

it.RegurgitatedRock = Item.new("Regurgitated Rock")
--local sRegurgitatedRock = Sound.load("RegurgitatedRock", path.."RegurgitatedRock")
it.RegurgitatedRock.pickupText = "Burrow underground after standing idle for 3 seconds." 
local sprRegurgitatedRock = Sprite.load("Regurgitated Rock", path.."Regurgitated Rock.png", 1, 15, 15)
it.RegurgitatedRock.sprite = sprRegurgitatedRock
itp.legendary:add(it.RegurgitatedRock)
it.RegurgitatedRock.color = "y"
it.RegurgitatedRock:setLog{
	group = "boss",
	description = "After standing idle for 3 seconds, burrow underground, &b&becoming invincible briefly.",
	story = "The towering creature collapsed, like a demolished column of stone.\nYet in its last breath, it had one final struggle, to spit something out.\nA rock. not a huge rock, but a rock hard enough to trouble any specimen that tries to swallow it.\n\nNot like I needed any reminders to not ingest the soil.",
	priority = "&b&Field-Found&!&",
	destination = "Menon Exhibit,\nPlora,\nEarth",
	date = "Unknown"
}

local onPlayerStepCall = function(player)
	local itCount = player:countItem(it.RegurgitatedRock)
	if itCount > 0 then
		local data = player:getData()
		local ac = player:getAccessor()
		if data.timer then
			if ac.activity == 0 and ac.pHspeed == 0 and ac.free == 0 then
				if not data.burrowed then
					if data.timer >= 3 * 60 then
						data.burrowed = true
						player.yscale = 0.2
						for i = 1, 10 do
							if player:collidesMap(player.x, player.y + 1) then
								break
							else
								player.y = player.y + 1
							end
						end
						data.previousVis = player.visible
						player.visible = false
						local dur = 60 * 2.5 * itCount
						if ac.invincible < dur then
							ac.invincible = dur
						end
						par.Rubble2:burst("middle", player.x, player.y + 3, 3)
						par.Debris2:burst("middle", player.x, player.y + 3, 5)
						local sound = Sound.find("SquallEelShoot1_1") or sfx.WispSpawn
						sound:play(2 + math.random() * 0.2, 0.8)
					else
						data.timer = data.timer + 1
					end
				end
			else
				data.timer = 0
				if data.burrowed then
					player.yscale = 1
					player.visible = data.previousVis
					data.burrowed = nil
					local dur = 60 * 2.5 * itCount
					if ac.invincible <= dur then
						ac.invincible = 0
					end
					par.Rubble2:burst("middle", player.x, player.y, 1)
					par.Debris2:burst("middle", player.x, player.y, 5)
					local sound = Sound.find("SquallEelShoot1_1") or sfx.WispSpawn
					sound:play(2.2 + math.random() * 0.2, 0.8)
				end
			end
		else
			data.timer = 0
		end
	end
end

it.RegurgitatedRock:addCallback("pickup", function(player)
	--player:set("regurgitatedRock", (player:get("regurgitatedRock") or 0) + 1)
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)
--[[callback.register("onItemRemoval", function(player, item, amount)
	if item == it.RegurgitatedRock then
		player:set("regurgitatedRock", player:get("regurgitatedRock") - amount)
	end
end)]]
if obj.SquallEel then
	NPC.registerBossDrops(obj.SquallEel)
	NPC.addBossItem(obj.SquallEel, it.RegurgitatedRock)
end
