-- Pylon

local returnFunc = function()
	local tele = obj.Teleporter:find(1)
	if tele and tele:isValid() then
		tele:set("active", 4)
	end
	local pylon = obj.Pylon:find(1)
	if pylon and pylon:isValid() then
		pylon:set("active", 3)
		pylon:getData().targetSize = 15
	end
end

local pylonEndFunc = function(pylon)
	pylon:getData().dead = true
	sfx.ImpDeath:play(0.6)
	runData.pylonDead = true
	for _, player in ipairs(misc.players) do
		player:kill()
	end
end

local syncReturn 
syncReturn= net.Packet.new("SSReturn", function(sender)
	returnFunc()
	if net.host then
		syncReturn:sendAsHost(net.EXCLUDE, sender)
	end
end)

local syncHp = net.Packet.new("SSPylonHp", function(sender, hp)
	local pylon = obj.Pylon:find(1)
	if pylon and pylon:isValid() then
		pylon:set("hp", hp)
		pylon:set("lasthp", hp)
	end
end)

local syncEnd = net.Packet.new("SSPylonDeath", function(sender)
	local pylon = obj.Pylon:find(1)
	if pylon and pylon:isValid() then
		pylonEndFunc(pylon)
	end
end)

local sprPylon = Sprite.load("Pylon", "Stages/RedPlane/Pylon.png", 1, 84, 103)

obj.Pylon = Object.base("Boss","Pylon")
obj.Pylon.sprite = sprPylon
obj.Pylon.depth = 10
obj.Pylon:addCallback("create", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	selfAc.team = "player"
	selfAc.name = "Pylon"
	selfAc.name2 = "Silver Lining"
	selfAc.maxhp = 3000 * Difficulty.getScaling("hp")
	selfAc.hp = selfAc.maxhp
	selfAc.lasthp = selfAc.hp
	selfAc.parent = self.id
	selfAc.active = 0
	selfAc.myplayer = -4
	selfAc.health_tier_threshold = 0.1
	selfAc.sync = 0
	
	selfData.count = 0
	selfData.size = 5
	selfData.targetSize = 6
	
	selfData.deadPlayers = {}
	selfData.revivedPlayers = {}
end)
obj.Pylon:addCallback("step", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	selfData.xAccel = 0
	selfAc.prefix_type = 0
	
	if selfAc.active > 0 then
		selfData.size = math.approach(selfData.size, selfData.targetSize, 0.1)
	else
		selfData.size = math.approach(selfData.size, 5, 0.1)
	end
	
	if selfData.setQuest then
		Quest.setObjective("Escape the planet", "Find a Silver Lining.", nil, nil, true)
		selfData.setQuest = nil
	end
	
	selfAc.myplayer = -4
	if selfAc.active == 0 then
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 40, self.y - 80,self.x + 40, self.y + 2)) do
			selfAc.myplayer = player.id
			
			if player:isValid() then
				if not net.online or net.localPlayer == player then
					if selfData.count < 10 and player:control("enter") == input.PRESSED then
						if net.online then
							if net.host then
								syncInteractableActivation:sendAsHost(net.ALL, nil, player:getNetIdentity(), self.x, self.y, self:getObject())
							else
								syncInteractableActivation:sendAsClient(player:getNetIdentity(), self.x, self.y, self:getObject())
							end
						end
						_newInteractables[obj.Pylon].activation(self, player)
					elseif selfData.count > 2 and player:control("swap") == input.PRESSED and not runData.visitedUnknown then
						if net.online then
							if net.host then
								syncReturn:sendAsHost(net.ALL, nil)
							else
								syncReturn:sendAsClient()
							end
						end
						returnFunc()
					end
				end
			end
		end
	end
	
	selfData.players = obj.P:findAll()
	selfData.playersCount = 0
	for _, player in ipairs(selfData.players) do
		selfData.playersCount = selfData.playersCount + 1
		if not selfData.deadPlayers[player] and player:get("dead") == 1 then
			selfData.deadPlayers[player] = true
		elseif selfData.deadPlayers[player] and player:get("dead") == 0 then
			selfData.deadPlayers[player] = nil
		end
	end
	selfData.deadPlayersCount = 0
	for _, _ in pairs(selfData.deadPlayers) do
		selfData.deadPlayersCount = selfData.deadPlayersCount + 1
	end
	
	selfAc.hp = math.clamp(selfAc.hp, 0, selfAc.maxhp)
	if selfAc.hp == 0 and net.host and not selfData.dead then
		syncEnd:sendAsHost(net.ALL, nil)
		pylonEndFunc(self)
	end
	if selfAc.lasthp < selfAc.hp then
		selfAc.hp = selfAc.lasthp
	end
	selfAc.lasthp = selfAc.hp
	
	if net.online and net.host and global.timer % 300 == 0 then
		syncHp:sendAsHost(net.ALL, nil, selfAc.hp)
	end
end)
obj.Pylon:addCallback("draw", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	local yy = self.y - 130
	local size1, size2 = selfData.size, (selfData.size * 0.5)
	local var = math.random(10) * 0.1
	if misc.getTimeStop() > 0 then
		var = 0
	end
	
	local color = Color.RED
	if selfAc.active == 3 then
		color = Color.GREEN
	end
	
	graphics.alpha(1)
	graphics.color(color)
	graphics.circle(self.x, yy, size1 + var, false)
	if selfAc.active == 2 then
		graphics.color(color)
		graphics.line(self.x + 1, yy, self.x, 0, size2 + var)
	elseif selfAc.active == 0 then
		local player = Object.findInstance(selfAc.myplayer)
		if player and player:isValid() then
			local player = Object.findInstance(selfAc.myplayer)
			
			local keyStr = "Activate"
			local keyStr2 = "Swap"
			if player and player:isValid() then
				keyStr = input.getControlString("enter", player)
				keyStr2 = input.getControlString("swap", player)
			end
			
			local funcStr = " to activate Pylon"
			if selfData.count > 0 then
				local mp = selfData.playersCount > 1
				local deadps = selfData.deadPlayersCount > 0
				if mp and deadps then
					if selfData.playersCount > 5 then
						funcStr = " to continue charging the Pylon and restore allies"
					else
						funcStr = " to continue charging the Pylon and restore an ally"
					end
				else
					funcStr = " to continue charging the Pylon"
				end
			end
			
			local gamepad = input.getPlayerGamepad(player)
			
			local text = ""
			if selfData.count < 10 then
				local pp = not net.online or player == net.localPlayer
				if gamepad and pp then
					text = "Press ".."'"..keyStr.."'"..funcStr
				else
					text = "Press ".."&y&'"..keyStr.."'&!&"..funcStr
				end
			end
			
			local text2 = ""
			if selfData.count > 2 and not runData.visitedUnknown then
				local pp = not net.online or player == net.localPlayer
				if gamepad and pp then
					text2 = "Press ".."'"..keyStr2.."'".." to leave"
				else
					text2 = "Press ".."&r&'"..keyStr2.."'&!&".." to leave"
				end
			end
			graphics.color(Color.WHITE)
			graphics.printColor(text, self.x - 78, self.y - 57)
			graphics.printColor(text2, self.x - 78, self.y - 57 - 8)
		end
	end
	graphics.color(Color.WHITE)
	graphics.circle(self.x, yy, size2 + var, false)
end)

--[[callback.register("onDamage", function(target, damage, source)
	if target:getObject() == obj.Pylon and source and source:get("team") and source:get("team") == target:get("team") then
		return true
	end
end)]]

return obj.Pylon