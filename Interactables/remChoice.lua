-- Remuneration Choice

obj.RemChoice = Object.base("MapObject", "RemChoice")
obj.RemChoice.sprite = spr.Chest3
obj.RemChoice.depth = -9

obj.RemChoice:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.item = 2
	selfData.sprite = spr.Rem2
	self.spriteSpeed = 0.2
	self:set("f", 0)
	self:set("yy", 0)
	self:set("active", 0)
	self:set("myplayer", -4)
	self:set("activator", 3)
	for i = 0, 500 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i - 1 
			break
		end
	end
	
	selfData.firstStep = true
end)

obj.RemChoice:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfData.firstStep then
		local c1 = obj.RemChoice:create(self.x - 30, self.y)
		c1:getData().item = 1
		c1:getData().sprite = spr.Rem1
		c1:getData().firstStep = nil
		local c2
		if Stage.getCurrentStage() ~= stg.RiskofRain and getRule(5, 20) ~= false and getRule(5, 24) == true then
			c2 = obj.RemChoice:create(self.x + 30, self.y)
			c2:getData().item = 3
			c2:getData().sprite = spr.Rem3
			c2:getData().firstStep = nil
		end
		
		c1:getData().children = {self, c2}
		if c2 then
			c2:getData().children = {self, c1}
		end
		selfData.children = {c1, c2}
		selfData.firstStep = nil
	end
	
	selfAc.f = selfAc.f + 0.05
	selfAc.yy = math.cos(selfAc.f) * 2
	
	if selfAc.active == 0 then
		self.sprite = spr.Chest3
		self.spriteSpeed = 0.2
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 14, self.y - 42,self.x + 14, self.y + 2)) do
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
					
					_newInteractables[obj.RemChoice].activation(self, player)
				end
			end
		end
	elseif selfAc.active == 2 then
		self.sprite = spr.Chest3Open
		if self.subimage >= 5 then
			self.spriteSpeed = 0
			self.subimage = 5
		end
	end
end)

obj.RemChoice:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		local image = selfData.sprite or spr.Random
		graphics.drawImage{
			image = image,
			x = self.x,
			y = self.y - 20 + self:get("yy"),
			alpha = 0.7,
			subimage = 2
		}
	
		if obj.P:findRectangle(self.x - 14, self.y - 42, self.x + 14, self.y + 2) and selfAc.myplayer ~= -4 then
			local player = Object.findInstance(selfAc.myplayer)
			
			local keyStr = "Activate"
			if player and player:isValid() then
				keyStr = input.getControlString("enter", player)
			end
			
			local text = ""
			local pp = not net.online or player == net.localPlayer
			if input.getPlayerGamepad(player) and pp then
				text = "Press ".."'"..keyStr.."'".." to make your choice"
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to make your choice"
			end
			graphics.color(Color.WHITE)
			graphics.alpha(1)
			graphics.printColor(text, self.x - 78, self.y - 57)
		end
	end
end)

return obj.RemChoice