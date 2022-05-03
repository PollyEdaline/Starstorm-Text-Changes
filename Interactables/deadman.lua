-- Bloated Survivor
local sprDeadman = spr.Deadman
obj.Deadman2 = Object.base("MapObject", "Deadman")
obj.Deadman2.sprite = sprDeadman
obj.Deadman2.depth = 9

obj.Deadman2:addCallback("create", function(self)
	local selfData = self:getData()
	
	self.spriteSpeed = 0
	self:set("active", 0)
	self:set("myplayer", -4)
	self:set("activator", 3)
end)

obj.Deadman2:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		self.sprite = sprDeadman
		self.spriteSpeed = 0
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 22, self.y - 42, self.x + 22, self.y + 2)) do
			selfAc.myplayer = player.id
			
			if player:isValid() and player:control("enter") == input.PRESSED then
				if not net.online or net.localPlayer == player then
					if net.online then
						if net.host then
							syncInteractableActivation:sendAsHost(net.ALL, nil, player:getNetIdentity(), self.x, self.y, self:getObject())
						else
							syncInteractableActivation:sendAsClient(player:getNetIdentity(), self.x, self.y, self:getObject())
						end	
					end
					
					_newInteractables[obj.Deadman2].activation(self, player)
					
				end
			end
		end
	elseif selfAc.active == 2 then
		if self.subimage >= 9 and not selfData.spawned then
			selfData.spawned = true
			createSynced(obj.Bug, self.x, self.y)
		end
		if self.subimage >= self.sprite.frames then
			self.spriteSpeed = 0
			self.subimage = self.sprite.frames
		else
			self.spriteSpeed = 0.25
		end
	end
	if selfData.timer then
		if selfData.timer == 0 then
			selfData.timer = nil
			
		else
			selfData.timer = selfData.timer - 1
		end
	end
end)

obj.Deadman2:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
	
		if obj.P:findRectangle(self.x - 22, self.y - 42, self.x + 22, self.y + 2) and selfAc.myplayer ~= -4 then
			local player = Object.findInstance(selfAc.myplayer)
			
			local keyStr = "Activate"
			if player and player:isValid() then
				keyStr = input.getControlString("enter", player)
			end
			
			local text = ""
			local pp = not net.online or player == net.localPlayer
			if input.getPlayerGamepad(player) and pp then
				text = "Press ".."'"..keyStr.."'".." to inspect.."
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to inspect.."
			end
			graphics.color(Color.WHITE)
			graphics.alpha(1)
			graphics.printColor(text, self.x - 110, self.y - 20)
		end
	end
end)

table.insert(call.onStageEntry, function()
	local room = Room.getCurrentRoom()
	
	if net.online then
		if room == rm["4_2_1"] then
			obj.Deadman2:create(3200, 1040)
		elseif  room == rm["4_2_2old"] then
			obj.Deadman2:create(2956, 432)
		end
	end
end)

return obj.Deadman2