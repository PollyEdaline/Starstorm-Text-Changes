-- VoidChestSmall

local sprVoidChestSmall = Sprite.load("VoidChestSmall", "Interactables/Resources/VoidChestSmall", 9, 15, 15)

obj.VoidChestSmall = Object.base("MapObject", "VoidChestSmall")
obj.VoidChestSmall.sprite = sprVoidChestSmall
obj.VoidChestSmall.depth = -9

obj.VoidChestSmall:addCallback("create", function(self)
	local selfData = self:getData()
	self.spriteSpeed = 0
	self:set("active", 0)
	if misc.director and misc.director:isValid() then
		self:set("cost", math.ceil((misc.director:get("enemy_buff") - 0.5) * 280))
	end
	self:set("myplayer", -4)
	self:set("activator", 3)
	for i = 0, 500 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i - 1 
			break
		end
	end
end)

obj.VoidChestSmall:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 14, self.y - 42,self.x + 14, self.y + 2)) do
			selfAc.myplayer = player.id
			
			if player:isValid() and player:control("enter") == input.PRESSED then
				if not net.online or net.localPlayer == player then
					if misc.getGold() >= selfAc.cost then
						
						if net.online then
							if net.host then
								syncInteractableActivation:sendAsHost(net.ALL, nil, player:getNetIdentity(), self.x, self.y, self:getObject())
							else
								syncInteractableActivation:sendAsClient(player:getNetIdentity(), self.x, self.y, self:getObject())
							end	
						end
						
						misc.setGold(misc.getGold() - selfAc.cost)
						
						_newInteractables[obj.VoidChestSmall].activation(self, player)
					else
						sfx.Error:play()
					end
				end
			end
		end
	elseif selfAc.active == 2 then
		if self.subimage >= 9 then
			self.spriteSpeed = 0
			self.subimage = 9
		end
		if selfData.timer then
			if selfData.timer > 0 then
				selfData.timer = selfData.timer - 1
			else
				if net.host then
					for i = 1, 2 do
						local itemPool = itp.uncommon
						if ar.Command.active then
							createdItem = itemPool:getCrate():create(self.x - 45 + 30 * i, self.y - 14)
						else
							createdItem = itemPool:roll():create(self.x - 45 + 30 * i, self.y - 14)
						end
					end
				end
				selfData.timer = nil
			end
		end
	end
end)

obj.VoidChestSmall:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		if obj.P:findRectangle(self.x - 13, self.y - 30, self.x + 13, self.y + 2) and selfAc.myplayer ~= -4 then
			local player = Object.findInstance(selfAc.myplayer)
			
			local keyStr = "Activate"
			if player and player:isValid() then
				keyStr = input.getControlString("enter", player)
			end
			
			local costStr = ""
			if selfAc.cost > 0 then
				costStr = " &y&($"..selfAc.cost..")"
			end
			
			local text = ""
			local pp = not net.online or player == net.localPlayer
			if input.getPlayerGamepad(player) and pp then
				text = "Press ".."'"..keyStr.."'".." to purchase chest"..costStr
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to purchase chest"..costStr
			end
			graphics.color(Color.WHITE)
			graphics.alpha(1)
			graphics.printColor(text, self.x - 78, self.y - 47)
		end
	end
	
	if selfAc.cost > 0 and selfAc.active == 0 then
		graphics.alpha(0.85 - (math.random(0, 15) * 0.01))
		graphics.color(Color.fromHex(0xEFD27B))
		graphics.print("&y&$"..selfAc.cost, self.x - 3, self.y + 6, graphics.FONT_DAMAGE, graphics.ALIGN_MIDDLE, graphics.ALIGN_TOP)
	end
end)

return obj.VoidChestSmall