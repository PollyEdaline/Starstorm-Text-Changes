-- Item Chest

local sprExpChest = Sprite.load("ExpChest", "Interactables/Resources/ExpChest", 7, 21, 24)

obj.ExpChest = Object.base("MapObject", "ExpChest")
obj.ExpChest.sprite = sprExpChest
obj.ExpChest.depth = -9

obj.ExpChest:addCallback("create", function(self)
	local selfData = self:getData()
	
	self:set("f", 0)
	self:set("yy", 0)
	self:set("active", 0)
	
	
	self:set("cost", 0)
	selfData.amount = misc.director:get("enemy_buff") * 8
	self:set("myplayer", -4)
	self:set("activator", 3)
	for i = 0, 500 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i - 1 
			break
		end
	end
	self.spriteSpeed = 0
end)

obj.ExpChest:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	selfAc.f = selfAc.f + 0.05
	selfAc.yy = math.cos(selfAc.f) * 2
	
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
						
						_newInteractables[obj.ExpChest].activation(self, player)
					else
						sfx.Error:play()
					end
				end
			end
		end
	elseif selfAc.active == 2 then
		if self.subimage >= 6 then
			self.spriteSpeed = 0
			self.subimage = 7
		end
	end
end)

obj.ExpChest:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		graphics.color(Color.WHITE)
	
		if obj.P:findRectangle(self.x - 14, self.y - 42, self.x + 14, self.y + 2) and selfAc.myplayer ~= -4 then
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
				text = "Press ".."'"..keyStr.."'".." to open"..costStr
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to open"..costStr
			end
			graphics.alpha(1)
			graphics.printColor(text, self.x - 48, self.y - 57)
		end
	end
	
	if selfAc.cost > 0 and selfAc.active == 0 then
		graphics.alpha(0.85 - (math.random(0, 15) * 0.01))
		graphics.color(Color.fromHex(0xEFD27B))
		graphics.print("&y&$"..selfAc.cost, self.x - 3, self.y + 6, graphics.FONT_DAMAGE, graphics.ALIGN_MIDDLE, graphics.ALIGN_TOP)
	end
end)

return obj.ExpChest