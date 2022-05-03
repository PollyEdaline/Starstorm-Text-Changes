-- VoidCatalyst

local sprVoidCatalyst = Sprite.load("VoidCatalyst", "Interactables/Resources/VoidCatalyst", 10, 30, 45)

local sVoidCatalyst = Sound.load("VoidCatalyst", "Interactables/Resources/VoidCatalyst")

obj.VoidCatalyst = Object.base("MapObject", "VoidCatalyst")
obj.VoidCatalyst.sprite = sprVoidCatalyst
obj.VoidCatalyst.depth = 5

obj.VoidCatalyst:addCallback("create", function(self)
	local selfData = self:getData()
	self.spriteSpeed = 0
	self:set("active", 0)
	
	selfData.timer2 = 0
	
	self:set("myplayer", -4)
	self:set("activator", 3)
	for i = 0, 500 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i - 1 
			break
		end
	end
	
	if (runData.catalysts or 0) >= 3 then
		self:destroy() -- byeeeeeeeee
	end
end)

obj.VoidCatalyst:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 and not selfData.takenItem then
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 22, self.y - 35, self.x + 22, self.y + 2)) do
			selfAc.myplayer = player.id
			
			if player:isValid() and player:control("enter") == input.PRESSED then
				if not net.online or net.localPlayer == player then
					if #(getTrueItems(player) or {}) > 0 then
						
						if net.online then
							if net.host then
								syncInteractableActivation:sendAsHost(net.ALL, nil, player:getNetIdentity(), self.x, self.y, self:getObject())
							else
								syncInteractableActivation:sendAsClient(player:getNetIdentity(), self.x, self.y, self:getObject())
							end	
						end
						
						_newInteractables[obj.VoidCatalyst].activation(self, player)
					else
						sfx.Error:play()
					end
				end
			end
		end
	elseif selfAc.active == 2 then
		if self.subimage >= 10 then
			self.spriteSpeed = 0
			self.subimage = 10
		end
	end
	if selfData.timer then
		if selfData.timer > 0 then
			selfData.timer = selfData.timer - 1
		else
			sVoidCatalyst:play()
			selfData.timer = nil
			selfData.timer2 = 180
			selfAc.active = 2
			self.spriteSpeed = 0.2
			misc.shakeScreen(60)
			local flash = obj.WhiteFlash:create(0, 0)
			flash.depth = flash.depth - 1
			flash.blendColor = Color.fromHex(0xFF00B6)
			flash.alpha = 0.4
			flash:set("rate", 0.05)
			local flash = obj.WhiteFlash:create(0, 0)
			flash.depth = 100
			flash.blendColor = Color.BLACK
			flash.alpha = 0.4
			flash:set("rate", 0.0018)
		end
	end
	if selfData.timer2 > 0 then
		 selfData.timer2 = selfData.timer2 - 1
	end
end)

obj.VoidCatalyst:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfData.takenItem and selfData.timer then
		local xx, yy
		local player = Object.findInstance(selfAc.activator)
		if player and player:isValid() then
			local newy = self.y - 45
			local ratio = distance(player.x, player.y, self.x, newy) * math.clamp((20 - (selfData.timer - 40)) / 20, 0, 1)
			xx, yy = pointInLine(player.x, player.y, self.x, newy, ratio)
		else
			xx, yy = self.x, self.y - 45
		end
		
		local image = selfData.takenItem.sprite
		graphics.drawImage{
			image = image,
			x = xx,
			y = yy,
			alpha = 0.8,
			subimage = 2
		}
	end
	
	if selfAc.active == 0 then
		if obj.P:findRectangle(self.x - 22, self.y - 35, self.x + 22, self.y + 2) and selfAc.myplayer ~= -4 then
			local player = Object.findInstance(selfAc.myplayer)
			
			local keyStr = "Activate"
			if player and player:isValid() then
				keyStr = input.getControlString("enter", player)
			end
			
			local progress = " ("..(runData.catalysts or 0).."/3)"
			local costStr = ""--" &y&(1 Item)"
			
			local text = ""
			local pp = not net.online or player == net.localPlayer
			if input.getPlayerGamepad(player) and pp then
				text = "Press ".."'"..keyStr.."'".." to wake the &p&Void Catalyst"..progress..costStr
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to wake the &p&Void Catalyst"..progress..costStr
			end
			graphics.color(Color.WHITE)
			graphics.alpha(1)
			graphics.printColor(text, self.x - 118, self.y - 57)
			graphics.alpha(0.85 - (math.random(0, 15) * 0.01))
			graphics.color(Color.fromHex(0xEDE6D5))
			graphics.print("1 ITEM", self.x - 3, self.y + 6, FONT_DAMAGE2, graphics.ALIGN_MIDDLE, graphics.ALIGN_TOP)
		end
		
	elseif selfAc.active == 2 and self.subimage >= 10 then
		local mult = selfData.timer2 / 180
		graphics.color(Color.fromHex(0xFF00B6))
		graphics.alpha((mult * 0.2) + math.cos(selfData.timer2 * 0.05) * mult)
		graphics.line(self.x  + 2, 0, self.x + 2, self.y - 39, 1)
		graphics.alpha((mult * 0.2) + math.cos(selfData.timer2 * 0.06) * mult)
		graphics.line(self.x + 25, 0, self.x + 25, self.y - 25, 1)
		graphics.alpha((mult * 0.2) + math.cos(selfData.timer2 * 0.04) * mult)
		graphics.line(self.x - 20, 0, self.x - 20, self.y - 25, 1)
	end
end)

return obj.VoidCatalyst