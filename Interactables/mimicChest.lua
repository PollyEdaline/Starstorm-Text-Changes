-- Mimic Chest

obj.MimicChest = Object.base("MapObject", "MimicChest")
obj.MimicChest.sprite = spr.Chest1
obj.MimicChest.depth = -9

obj.MimicChest:addCallback("create", function(self)
	local selfData = self:getData()
	
	local command = ar.Command.active and ar.Sacrifice.active
	
	if command then
		self.sprite = spr.Artifact8Boxes
	end
	
	self.spriteSpeed = 0
	if misc.director and misc.director:isValid() then
		local cost = 0
		if not command then
			cost = math.ceil((misc.director:get("enemy_buff") - 0.5) * 50)
		end
		self:set("cost", cost)
	end
	self:set("active", 0)
	
	for i = 0, 500 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i - 1 
			break
		end
	end
end)

obj.MimicChest:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 70, self.y - 42,self.x + 70, self.y + 2)) do
			if player:isValid() and player:get("dead") == 0 then
				if net.host then
					if net.online then
						syncInteractableActivation:sendAsHost(net.ALL, nil, player:getNetIdentity(), self.x, self.y, self:getObject())
					end
					_newInteractables[obj.MimicChest].activation(self, player)
				end
			end
		end
	end
	if self:isValid() and self.subimage >= 8 then
		self.spriteSpeed = 0
		self.subimage = 8
	end
end)


obj.MimicChest:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	
	if selfAc.cost > 0 then
		graphics.alpha(0.85 - (math.random(0, 15) * 0.01))
		graphics.color(Color.fromHex(0xEFD27B))
		graphics.print("&y&$"..selfAc.cost, self.x - 3, self.y + 6, graphics.FONT_DAMAGE, graphics.ALIGN_MIDDLE, graphics.ALIGN_TOP)
	end
end)

return obj.MimicChest