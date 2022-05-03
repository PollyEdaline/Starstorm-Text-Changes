local enabled = global.rormlflag.ss_enable_spectator

local spectator = Survivor.new("Spectator")

if not enabled then spectator.disabled = true end

-- Selection sprite
spectator.loadoutSprite = Sprite.load("Spectator_Select", "Misc/Menus/selectRandom", 4, 2, 0)

-- Selection description
spectator:setLoadoutInfo(
[[Watch it all!]], spr.Nothing)

-- Color of highlights during selection
spectator.loadoutColor = Color.fromHex(0x0A0505)

local sprIdle = Sprite.load("Spectator_Idle", "Survivors/Spectator/sprite", 1, 5, 3)

-- Misc. menus sprite
spectator.idleSprite = sprIdle

-- Main menu sprite
spectator.titleSprite = sprIdle

-- Endquote
spectator.endingQuote = "And so it left, watching from afar..."

local anims = {
	idle = sprIdle,
	walk = sprIdle,
	jump = sprIdle,
	death = spr.Nothing
}

-- Stats & Skills
spectator:addCallback("init", function(player)
	local playerAc = player:getAccessor()
	
	player:survivorSetInitialStats(999, 0, 0) -- meme
	player.mask = spr.Pixel
	playerAc.pGravity1 = 0
	playerAc.pGravity2 = 0
	player:setAnimations(anims)
	playerAc.pHmax = 2
	player.alpha = 0.1
	player:setSkill(1, "Nothing", "No skill.",
	spr.Nothing, 1, 10)
	player:setSkill(2, "Nothing", "No skill.",
	spr.Nothing, 1, 10)
	player:setSkill(3, "Nothing", "No skill.",
	spr.Nothing, 1, 10)
	player:setSkill(4, "Nothing", "No skill.",
	spr.Nothing, 1, 10)
end)

spectator:addCallback("step", function(player)
	local playerAc = player:getAccessor()
	
	if playerAc.ropeUp == 1 then
		player.y = player.y - playerAc.pHmax
	elseif playerAc.ropeDown == 1 then
		player.y = player.y + playerAc.pHmax
	end
	
	local poi = Object.findInstance(playerAc.child_poi)
	if poi and poi:isValid() then
		poi:destroy()
		--playerAc.child_poi = -1
	end
	
	playerAc.pVspeed = 0
	
	local ps = obj.P:findAll()
	local pc = 0
	for _, p in ipairs(ps) do
		if p:get("dead") == 1 then
			pc = pc + 1
		end
	end
	if #ps > 1 and pc == #ps - 1 then
		playerAc.hp = -9999
		--playerAc.hp_regen = -1000
		--playerAc.pGravity1 = 0.5
	end
end)