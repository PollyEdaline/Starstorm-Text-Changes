-- VoidPortal

spr.VoidPortal = Sprite.load("VoidPortal", "Interactables/Resources/voidPortal", 4, 12, 45)
spr.VoidPortal2 = Sprite.load("VoidPortal2", "Interactables/Resources/voidPortal2", 4, 12, 45)

local sVoidPortalSpawn = Sound.load("VoidPortalSpawn", "Interactables/Resources/voidPortalSpawn")

obj.VoidPortal = Object.base("MapObject", "VoidPortal")
obj.VoidPortal.sprite = spr.VoidPortal
obj.VoidPortal.depth = -9

obj.VoidPortal:addCallback("create", function(self)
	local selfData = self:getData()
	self.spriteSpeed = 0.13
	self:set("active", 0)
	self:set("myplayer", -4)
	self:set("activator", 3)
	-- spawn go wheeeew
	for i = 0, 500 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i - 1 
			break
		end
	end
	
	self.visible = false
	selfData.sprite = spr.VoidPortal
	selfData.stage = stg.Void
	selfData.color = Color.fromHex(0xEB4AF9)
	selfData.particles = par.VoidPortal
	selfData.colBoxMult = 1
	
	selfData.firstFrame = true
end)

obj.VoidPortal:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfData.firstFrame then
		sVoidPortalSpawn:play()
		local flash = obj.WhiteFlash:create(0, 0)
		flash.blendColor = selfData.color
		flash.alpha = 0.5
		flash:set("rate", 0.01)
		local flash = obj.WhiteFlash:create(0, 0)
		flash.depth = flash.depth + 1
		flash.blendColor = Color.BLACK
		flash.alpha = 0.3
		flash:set("rate", 0.0009)
		self.visible = true
		self.sprite = selfData.sprite
		
		selfData.firstFrame = nil
	end
	
	if self.visible and selfData.particles and math.chance(30) and global.quality > 1 then
		selfData.particles:burst("below", self.x, self.y - 23, 1)
	end
	
	if selfAc.active == 0 then
		self.spriteSpeed = 0.13
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 15 * selfData.colBoxMult, self.y - 20 * selfData.colBoxMult, self.x + 15 * selfData.colBoxMult, self.y + 14 * selfData.colBoxMult)) do
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
					
					_newInteractables[obj.VoidPortal].activation(self, player)
					
				end
			end
		end
	end
end)

obj.VoidPortal:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		if obj.P:findRectangle(self.x - 15 * selfData.colBoxMult, self.y - 20 * selfData.colBoxMult, self.x + 15 * selfData.colBoxMult, self.y + 14 * selfData.colBoxMult) and selfAc.myplayer ~= -4 then
			local player = Object.findInstance(selfAc.myplayer)
			
			local keyStr = "Activate"
			if player and player:isValid() then
				keyStr = input.getControlString("enter", player)
			end
			
			local text = ""
			local pp = not net.online or player == net.localPlayer
			if input.getPlayerGamepad(player) and pp then
				text = "Press ".."'"..keyStr.."'".." to enter the &p&Void Portal"
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to enter the &p&Void Portal"
			end
			graphics.color(Color.WHITE)
			graphics.alpha(1)
			graphics.printColor(text, self.x - 88, self.y - 57)
		end
	end
end)

return obj.VoidPortal