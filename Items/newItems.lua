local path = "Items/Resources/"

it.AcuteReflexes = Item.new("Acute Reflexes") -- max stack 12
--local sAcuteReflexes = Sound.load("AcuteReflexes", path.."")
it.AcuteReflexes.pickupText = "Tap a direction twice to dash."
it.AcuteReflexes.sprite = Sprite.load("AcuteReflexes", path.."Acute Reflexes.png", 1, 15, 15)
it.AcuteReflexes:setTier("common")
it.AcuteReflexes:setLog{
	group = "common_locked",
	description = "&b&Tap a direction twice to dash. &!&Recharges every 10 seconds.",
	story = "",
	destination = "A,\nB,\nC",
	date = "06/07/2056"
}
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.AcuteReflexes then
		player:getData().acuteReflexes = player:getData().acuteReflexes - 1
	end
end)
local onPlayerStepCall = function(player)
	if player:getData().acuteReflexes and player:getData().acuteReflexes > 0 then
		local data = player:getData()
		if data.dashTimer then
			if data.dashTimer > 0 then
				data.dashTimer = data.dashTimer - 1
			else
				data.dashTimer = nil
			end
		elseif player:get("activity") < 5 then
			local moveRight, moveLeft = player:get("moveRight", "moveLeft")
			local ctrl, check
			if moveRight == 1 then ctrl = 1 elseif moveLeft == 1 then ctrl = -1 end
			if data.lastCtrl ~= ctrl then
				check = true
				data.lastCtrl = ctrl 
			end
			
			if check and ctrl then
				if data.dashTimer2 then
					if data.dashTimerDir == ctrl then
						--local timeMult = (1 / (0.15 * data.acuteReflexes + 0.85))
						data.dashTimer = math.max(600 - 50 * data.acuteReflexes, 0) --600 * timeMult --60 + math.max(540 - 60 * data.acuteReflexes, 0)
						data.lastCtrl = nil
						
						player:getData().xAccel = 3 * ctrl
						--[[if moveRight == 1 then
							player:getData().xAccel = 3
						elseif moveLeft == 1 then
							player:getData().xAccel = -3
						end]]
						
						data.dashTimerDir = nil
					end
				else
					data.dashTimer2 = 30
					data.dashTimerDir  = ctrl
				end
			end
			
			if data.dashTimer2 then
				if data.dashTimer2 > 0 then
					data.dashTimer2 = data.dashTimer2 - 1
				else
					data.dashTimer2 = nil
				end
			else
				par.MagicLines:burst("middle", player.x, player.y, 1)
			end
			
		end

	end
end

it.AcuteReflexes:addCallback("pickup", function(player)
	player:getData().acuteReflexes = (player:getData().acuteReflexes or 0) + 1
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)




it.R4M = Item.new("R4M")
--local sR4M = Sound.load("R4M", path.."")
it.R4M.pickupText = "Moving in a constant direction knocks back enemies."
it.R4M.sprite = Sprite.load("R4M", path.."R4M.png", 1, 16, 16)
it.R4M:setTier("uncommon")
it.R4M:setLog{
	group = "uncommon_locked",
	description = "Moving in a constant direction deals 50% damage and knocks back enemies.",
	story = "",
	destination = "A,\nB,\nC",
	date = "06/07/2056"
}
local efSprite = Sprite.load("R4MEf", path.."r4mEf.png", 5, 31, 21)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.R4M then
		player:getData().bison = player:getData().bison - 1
	end
end)
local onActorStepCall = function(player)
	if player:getData().bison  and player:getData().bison > 0 then
		local data = player:getData()
		
		local move
		if player:get("moveRight") == 1 then move = 1 elseif player:get("moveLeft") == 1 then move = -1 end
		
		if move and move == data.lastMove then
			if not data.moveTimer or player:get("activity") == 30 then data.moveTimer = 0 end -- sucks
			if data.moveTimer < 120 then
				data.moveTimer = data.moveTimer + 1
			else
				if not player:collidesMap(player.x + 2 * move, player.y) then
					local bullet = misc.fireBullet(player.x + 3 * (move * -1), player.y, player:getFacingDirection(), 6, 0.5 * player:getData().bison, player:get("team"))
					local v2 = (1 - 1 / ( 0.2 * player:getData().bison + 1)) * 5
					bullet:set("knockback", 7 + v2 * 2)
					bullet:set("knockup", 1 + v2)
					bullet:set("stun", 1.4 + v2)
					bullet:set("knockback_direction", player.xscale)
					if global.timer % 10 == 0 then
						local spark = obj.EfSparks:create(player.x, player.y)
						spark.sprite = efSprite
						spark.xscale = player.xscale
						spark.depth = player.depth + 0.1
					end
				end
			end
		else
			data.moveTimer = nil
		end
		
		if data.lastMove ~= move then
			data.lastMove = move
		end
	end
end

it.R4M:addCallback("pickup", function(player)
	player:getData().bison = (player:getData().bison or 0) + 1
	tcallback.register("onActorStep", onActorStepCall)
end)



--[[
it.Ashtray = Item.new("Ashtray") -- phantasms only exist on monsoon+, meh.
--local sAshtray = Sound.load("Ashtray", path.."")
it.Ashtray.pickupText = "Slaying Blighted enemies consumes nearby foes."
--it.Ashtray.sprite = Sprite.load("Ashtray", path..".png", 1, 16, 15)
it.Ashtray:setTier("uncommon")
it.Ashtray:setLog{
	group = "rare_locked",
	description = ".",
	story = "",
	destination = "A,\nB,\nC",
	date = "06/07/2056"
}
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.Ashtray then
		player:getData().ashtray = player:getData().ashtray - 1
	end
end)

local onNPCDeathProcCall = function(npc, player)
	
end

it.Ashtray:addCallback("pickup", function(player)
	player:getData().ashtray = (player:getData().ashtray or 0) + 1
	tcallback.register("onNPCDeathProc", onNPCDeathProcCall)
end)
]]


--[[
it.Thermostat = Item.new("Thermostat")
--local sThermostat = Sound.load("Thermostat", path.."")
it.Thermostat.pickupText = "Events earn you buffs."
--it.Thermostat.sprite = Sprite.load("Thermostat", path..".png", 1, 16, 15)
it.Thermostat:setTier("uncommon")
it.Thermostat:setLog{
	group = "rare_locked",
	description = ".",
	story = "",
	destination = "A,\nB,\nC",
	date = "06/07/2056"
}
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.Thermostat then
		player:getData().thermostat = player:getData().thermostat - 1
	end
end)

it.Thermostat:addCallback("pickup", function(player)
	player:getData().thermostat = (player:getData().thermostat or 0) + 1
end)
]]
