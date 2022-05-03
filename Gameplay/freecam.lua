-- Freecam
local freecam = {x = 0, y = 0, active = false}
local followcam = {x = 0, y = 0}
local lastFollowIndex = 1

local lastJoystick = 0

callback.register("onGameStart", function()
	freecam.active = false
end)

table.insert(call.postStep, function()
	local players = obj.P:findAll()
	
	if net.online then
		local player = net.localPlayer
		if not isa(player, "PlayerInstance") then
			return
		end
		local gamepad = input.getPlayerGamepad(player)
		
		if player:get("dead") == 1 then
			local cSpace = false
			
			if gamepad == nil then
				if player:control("jump") == input.PRESSED then
					cSpace = true
				end
			else
				if input.checkGamepad("face1", gamepad) == input.PRESSED  then
					cSpace = true
				end
			end
			
			if not player:getData().deathTimer then
				player:getData().deathTimer = 100
			elseif player:getData().deathTimer > 0 then
				player:getData().deathTimer = player:getData().deathTimer - 1
			end
			
			if cSpace then
				
				local followingId = player:get("following_player")
				local tplayer = Object.findInstance(followingId)
				
				if freecam.active then
					freecam.active = false
					
					if tplayer and tplayer:isValid() then
						freecam.x = tplayer.x
						freecam.y = tplayer.y
					end
					
					followcam.x = misc.camera.x
					followcam.y = misc.camera.y
					
				else
					freecam.active = true
					
					freecam.x = misc.camera.x
					freecam.y = misc.camera.y
					
				end
			end
			
			if freecam.active then
				
				local speed = 5
				local deadzone = 0.1
				
				if gamepad == nil then
					if player:control("left") == input.HELD then
						freecam.x = freecam.x - speed
					elseif player:control("right") == input.HELD then
						freecam.x = freecam.x + speed
					end
					if player:control("up") == input.HELD then
						freecam.y = freecam.y - speed
					elseif player:control("down") == input.HELD then
						freecam.y = freecam.y + speed
					end
				else
					-- DPAD
					if input.checkGamepad("padl", gamepad) == input.HELD  then
						freecam.x = freecam.x - speed
					elseif input.checkGamepad("padr", gamepad) == input.HELD  then
						freecam.x = freecam.x + speed
					end
					if input.checkGamepad("padu", gamepad) == input.HELD  then
						freecam.y = freecam.y - speed
					elseif input.checkGamepad("padd", gamepad) == input.HELD  then
						freecam.y = freecam.y + speed
					end
					-- L JOYSTICK
					if input.getGamepadAxis("lh", gamepad) ~= 0 then
						if input.getGamepadAxis("lh", gamepad) > 0.1 or input.getGamepadAxis("lh", gamepad) < - 0.1 then
							freecam.x = freecam.x + (speed * input.getGamepadAxis("lh", gamepad))
						end
					end
					if input.getGamepadAxis("lv", gamepad) ~= 0 then
						if input.getGamepadAxis("lv", gamepad) > 0.1 or input.getGamepadAxis("lv", gamepad) < - 0.1 then
							freecam.y = freecam.y + (speed * input.getGamepadAxis("lv", gamepad))
						end
					end
				end
				
				local difoffx = 0
				local difoffy = 0
				
				local swidth, sheight = Stage.getDimensions()
				
				local xLimit = swidth - misc.camera.width
				local yLimit = sheight - misc.camera.height
				
				if misc.camera.width > swidth then
					difoffx = misc.camera.width - swidth
					xLimit = difoffx
				end
				if misc.camera.height > sheight then
					difoffy = misc.camera.height - sheight
					yLimit = difoffy
				end
				
				freecam.x = math.clamp(freecam.x, difoffx, xLimit)
				freecam.y = math.clamp(freecam.y, difoffy, yLimit)
				
			else
				local cLeft = false
				local cRight = false
				
				--lastJoystick = 0
				
				if gamepad == nil then
					if player:control("left") == input.PRESSED then
						cLeft = true
					elseif player:control("right") == input.PRESSED then
						cRight = true
					end
				else
					-- DPAD
					if input.checkGamepad("padl", gamepad) == input.PRESSED  then
						cLeft = true
					elseif input.checkGamepad("padr", gamepad) == input.PRESSED  then
						cRight = true
					end
					-- L JOYSTICK
					if input.getGamepadAxis("lh", gamepad) ~= 0 then
						if lastJoystick ~= math.sign(math.round(input.getGamepadAxis("lh", gamepad))) then
							if math.round(input.getGamepadAxis("lh", gamepad)) < 0 then
								cLeft = true
							elseif math.round(input.getGamepadAxis("lh", gamepad)) > 0 then
								cRight = true
							end
						end
					end
					lastJoystick = math.sign(math.round(input.getGamepadAxis("lh", gamepad)))
				end
				
				if not player:getData().deathFollowingPlayer then player:getData().deathFollowingPlayer = player end
				
				local following = player:getData().deathFollowingPlayer
				
				local followingIndex = 1
				
				local alivePlayers = {}
				
				for i, player in ipairs(misc.players) do
					if player:get("dead") == 0 then
						if player == following then
							followingIndex = i
						end
						table.insert(alivePlayers, player)
					end
				end
				
				for i, pplayer in ipairs(alivePlayers) do
					if pplayer == following then
						followingIndex = i
						player:set("following_player", pplayer.id)
					end
				end
				
				if #alivePlayers > 0 then 
					if cLeft then
						local newIndex = followingIndex - 1
						if newIndex < 1 then newIndex = #alivePlayers end
						player:getData().deathFollowingPlayer = alivePlayers[newIndex]
					elseif cRight then
						local newIndex = followingIndex + 1
						if newIndex > #alivePlayers then newIndex = 1 end
						player:getData().deathFollowingPlayer = alivePlayers[newIndex]
					end
				else
					player:getData().deathFollowingPlayer = player
				end
				
				if player:getData().deathTimer == 1 and #alivePlayers > 0 then player:getData().deathFollowingPlayer = alivePlayers[1] end
				
				local difoffx = 0
				local difoffy = 0
				
				local swidth, sheight = Stage.getDimensions()
				
				local xLimit = swidth - misc.camera.width
				local yLimit = sheight - misc.camera.height
				
				--print(followingIndex)
				if following:isValid() and player:getData().deathTimer <= 0 then
				
					local newCamX = following.x - (misc.camera.width / 2)
					local newCamY = following.y - (misc.camera.height / 2)
					
					local difx = followcam.x - newCamX
					local dify = followcam.y - newCamY
					
					if misc.camera.width > swidth then
						difoffx = misc.camera.width - swidth
						xLimit = -difoffx
					end
					if misc.camera.height > sheight then
						difoffy = misc.camera.height - sheight
						yLimit = -difoffy
					end
					
					followcam.x = math.round(math.clamp(math.approach(followcam.x, newCamX, difx * 0.1), -difoffx, xLimit))
					followcam.y = math.round(math.clamp(math.approach(followcam.y, newCamY, dify * 0.1), -difoffy, yLimit))
				else
					local newCamX = net.localPlayer.x - (misc.camera.width / 2)
					local newCamY = net.localPlayer.y - (misc.camera.height / 2)
					
					if misc.camera.width > swidth then
						difoffx = misc.camera.width - swidth
						xLimit = -difoffx
					end
					if misc.camera.height > sheight then
						difoffy = misc.camera.height - sheight
						yLimit = -difoffy
					end
					
					followcam.x = math.round(math.clamp(newCamX, -difoffx, xLimit))
					followcam.y = math.round(math.clamp(newCamY, -difoffy, yLimit))
				end
			end
		else
			player:getData().deathTimer = 100
		end
	end
	for _, deadEf in ipairs(obj.EfPlayerDead:findAll()) do
		deadEf:set("following", 0)
	end
end)

table.insert(call.onHUDDraw, function()
	if net.online then
		if net.localPlayer:get("dead") == 1 then
			if net.localPlayer:getData().deathTimer and net.localPlayer:getData().deathTimer <= 0 then
				local followingPlayer = net.localPlayer:getData().deathFollowingPlayer
				
				local sSpace = input.getControlString("jump", net.localPlayer)
				
				local followingPlayerName = "Player"
				if followingPlayer and followingPlayer:isValid() then followingPlayerName = "'"..followingPlayer:get("user_name").."'" end
				
				local w, h = graphics.getHUDResolution()
				
				local ww = w / 2
				local hh = h / 2
				
				graphics.color(Color.WHITE)
				graphics.alpha(0.8)
				if freecam.active == false then
					graphics.print("Following "..followingPlayerName.."\nPress "..sSpace.." to toggle free-cam", ww, h * 0.8, 1, 1, 0)
				else
					graphics.print("Press "..sSpace.." to toggle free-cam", ww, h * 0.8, 1, 1, 0)
				end
			end
		else
			freecam.active = false
		end
	end
end)

callback.register("onCameraUpdate", function()
	if freecam.active == true then
		camera.x = freecam.x
		camera.y = freecam.y
	elseif net.online and net.localPlayer:get("dead") == 1 then
		camera.x = followcam.x
		camera.y = followcam.y
	end
end)