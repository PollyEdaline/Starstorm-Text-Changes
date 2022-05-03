-- Feral Cage

obj.FeralCage = Object.base("MapObject", "FeralCage")
obj.FeralCage.sprite = spr.FeralCage
obj.FeralCage.depth = 9

obj.FeralCage:addCallback("create", function(self)
	local selfData = self:getData()
	
	self.spriteSpeed = 0
	self:set("active", 0)
	self:set("myplayer", -4)
	self:set("activator", 3)
	for i = 0, 500 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i - 1 
			break
		end
	end
end)

obj.FeralCage:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		self.sprite = spr.FeralCage
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
					
					_newInteractables[obj.FeralCage].activation(self, player)
					
				end
			end
		end
	elseif selfAc.active == 2 then
		if self.subimage >= self.sprite.frames then
			self.spriteSpeed = 0
			self.subimage = self.sprite.frames
			if not selfData.spawned then
				selfData.spawned = true
				local acrid = obj.Acrid:create(self.x + (1 * (-self.xscale)), self.y)
				acrid.xscale = self.xscale * -1
			end
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

obj.FeralCage:addCallback("draw", function(self)
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
	
	if room == rm["3_2_1"] and net.online then
		obj.FeralCage:create(2563, 825)
	end
end)

return obj.FeralCage