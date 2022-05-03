-- VoidGate

spr.VoidGate = Sprite.load("VoidGate", "Interactables/Resources/VoidGate", 3, 51, 0)
spr.VoidPortalBig = Sprite.load("VoidPortalBig", "Interactables/Resources/VoidPortalBig", 5, 40, 50)

local sVoidGateActive = Sound.load("VoidGateActive", "Interactables/Resources/VoidGateActive")

obj.VoidGate = Object.base("MapObject", "VoidGate")
obj.VoidGate.sprite = spr.VoidGate
obj.VoidGate.depth = 8---7

obj.VoidGate:addCallback("create", function(self)
	local selfData = self:getData()
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
	
	selfData.sprite = spr.VoidGate
	selfData.stage = stg.VoidPaths
	selfData.color = Color.fromHex(0xEB4AF9)
	selfData.particles = par.VoidGate
	
	selfData.firstFrame = false
	self.spriteSpeed = 0
	
	selfData.life = 0
	selfData.countDown = 120
end)

obj.VoidGate:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	selfData.life = selfData.life + 1
	
	if selfData.firstFrame then
		sVoidGateActive:play()
		local flash = obj.WhiteFlash:create(0, 0)
		flash.blendColor = selfData.color
		flash.alpha = 0.5
		flash:set("rate", 0.01)
		local flash = obj.WhiteFlash:create(0, 0)
		flash.depth = flash.depth + 1
		flash.blendColor = Color.BLACK
		flash.alpha = 0.3
		flash:set("rate", 0.0009)
		self.sprite = selfData.sprite
		
		selfData.firstFrame = nil
	end
	
	if self.visible and selfData.particles and math.chance(30) and global.quality > 1 then
		selfData.particles:burst("below", self.x, self.y - 23, 1)
	end
	
	if selfAc.active == 0 and selfData.path and #obj.VoidGate:findMatchingOp("active", ">", 0) == 0 then
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 35, self.y + 20, self.x + 35, self.y + 87)) do
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
					
					_newInteractables[obj.VoidGate].activation(self, player)
					
				end
			end
		end
	elseif selfAc.active == 2 then
		if selfData.countDown > 0 then
			selfData.countDown = selfData.countDown - 1
		else
			Sound.find("VoidPortal"):play(0.6)
			if net.host then
				Stage.transport(selfData.stage or stg.VoidPaths)
			end
		end
	end
end)

obj.VoidGate:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfData.path then
		graphics.drawImage{
			image = spr.VoidPortalBig,
			x = self.x,
			y = self.y + 30,
			subimage = ((selfData.life * 0.2) % 5) + 1
		}
	end
	
	if selfAc.active == 0 and selfData.path then
		if obj.P:findRectangle(self.x - 35, self.y + 20, self.x + 35, self.y + 87) and selfAc.myplayer ~= -4 then
			local player = Object.findInstance(selfAc.myplayer)
			
			local keyStr = "Activate"
			if player and player:isValid() then
				keyStr = input.getControlString("enter", player)
			end
			
			local text = ""
			local pp = not net.online or player == net.localPlayer
			if input.getPlayerGamepad(player) and pp then
				text = "Press ".."'"..keyStr.."'".." to enter the &p&"..selfData.path.name
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to enter the &p&"..selfData.path.name
			end
			graphics.color(Color.WHITE)
			graphics.alpha(1)
			graphics.printColor(text, self.x - 118, self.y - 17)
		end
	elseif selfAc.active == 2 and #misc.players > 1 then
		for _, player in ipairs(misc.players) do
			if not net.online or player == net.localPlayer or net.localPlayer:get("dead") == 1 then
				graphics.color(Color.WHITE)
				graphics.alpha(1)
				local text = math.ceil(selfData.countDown / 60).." seconds to leave"
				graphics.print(text, player.x, player.y - 20, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE)
			end
		end
	end
end)

return obj.VoidGate