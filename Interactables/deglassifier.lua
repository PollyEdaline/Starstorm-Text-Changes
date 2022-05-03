-- De-glassifier

local sprDeglassifier = Sprite.load("Deglassifier", "Interactables/Resources/deglassifier.png", 5, 13, 44)

local sprDeglassifierUse = Sprite.load("DeglassifierUse", "Interactables/Resources/deglassifierUse", 5, 15, 44)

obj.Deglassifier = Object.base("MapObject", "De-Glassifier")
obj.Deglassifier.sprite = sprDeglassifier
obj.Deglassifier.depth = -9

obj.Deglassifier:addCallback("create", function(self)
	local selfData = self:getData()
	
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
end)

obj.Deglassifier:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	selfAc.f = selfAc.f + 0.05
	selfAc.yy = math.cos(selfAc.f) * 2
	
	if selfAc.active == 0 then
		self.sprite = sprDeglassifier
		self.spriteSpeed = 0.2
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 14, self.y - 42,self.x + 14, self.y + 2)) do
			selfAc.myplayer = player.id
			
			if player:isValid() and player:get("dead") == 0 and player:control("enter") == input.PRESSED then
				if not net.online or net.localPlayer == player then
					if not player:getData().setting_deglassified and ar.Glass.active then
						
						if net.online then
							if net.host then
								syncInteractableActivation:sendAsHost(net.ALL, nil, player:getNetIdentity(), self.x, self.y, self:getObject())
							else
								syncInteractableActivation:sendAsClient(player:getNetIdentity(), self.x, self.y, self:getObject())
							end	
						end
						
						_newInteractables[obj.Deglassifier].activation(self, player)
					else
						sfx.Error:play()
					end
				end
			end
		end
	elseif selfAc.active == 2 then
		self.sprite = sprDeglassifierUse
		if self.subimage >= 5 then
			self.spriteSpeed = 0
			self.subimage = 5
		end
	end
end)

local sprDeglassifierDisplay = Sprite.load("DeglassifierDisplay", "Interactables/Resources/deglassifierDisplay.png", 1, 10, 10)

obj.Deglassifier:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		local image = sprDeglassifierDisplay
		graphics.drawImage{
			image = image,
			x = self.x,
			y = self.y - 27 + self:get("yy"),
			alpha = 0.7
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
				text = "Press ".."'"..keyStr.."'".." to de-glassify yourself"
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to de-glassify yourself"
			end
			graphics.color(Color.WHITE)
			graphics.alpha(1)
			graphics.printColor(text, self.x - 84, self.y - 57)
		end
	end
	
	if selfAc.active == 2 then
		if selfData.timer > 0 then
			selfData.timer = selfData.timer - 1
		else
			selfAc.active = 0
		end
	end
end)

return obj.Deglassifier