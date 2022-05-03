-- Relic Shrine

local sprRelicChest = Sprite.load("RelicChest", "Interactables/Resources/relicChest.png", 8, 14, 50)

obj.RelicShrine = Object.base("MapObject", "RelicShrine")
obj.RelicShrine.sprite = sprRelicChest
obj.RelicShrine.depth = -9

obj.RelicShrine:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.item = itp.relic:roll()

	self.spriteSpeed = 0
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

local syncRelicItem = net.Packet.new("SSRelicItem", function(player, x, y, item)
	local instanceI = obj.RelicShrine:findNearest(x, y)
	if instanceI and instanceI:isValid() and item then
		instanceI:getData().item = item
	end
end)

obj.RelicShrine:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfData.firstStep then
		if net.online and net.host then
			syncRelicItem:sendAsHost(net.ALL, nil, self.x, self.y, selfData.item)
		end
		selfData.firstStep = nil
	end
	
	selfAc.f = selfAc.f + 0.05
	selfAc.yy = math.cos(selfAc.f)
	
	if selfAc.active == 0 then
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 14, self.y - 42,self.x + 14, self.y + 2)) do
			selfAc.myplayer = player.id
			
			if player:isValid() and player:get("dead") == 0 and player:control("enter") == input.PRESSED then
				if not net.online or net.localPlayer == player then
					
					if net.online then
						if net.host then
							syncInteractableActivation:sendAsHost(net.ALL, nil, player:getNetIdentity(), self.x, self.y, self:getObject())
						else
							syncInteractableActivation:sendAsClient(player:getNetIdentity(), self.x, self.y, self:getObject())
						end	
					end
					
					_newInteractables[obj.RelicShrine].activation(self, player)
					
				end
			end
		end
		if math.chance(50) and global.quality > 1 then
			par.Relic:burst("middle", self.x, self.y + math.random(-30, 0), 1)
		end
	end
	if self.subimage >= 8 then
		self.spriteSpeed = 0
		self.subimage = 8
	end
end)

obj.RelicShrine:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		local image = selfData.item.sprite
		graphics.drawImage{
			image = image,
			x = self.x,
			y = self.y - 58 + self:get("yy"),
			alpha = 0.9,
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
				text = "Press ".."'"..keyStr.."'".." to accept the &p&"..selfData.item.displayName
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to accept the &p&"..selfData.item.displayName
			end
			graphics.color(Color.WHITE)
			graphics.alpha(1)
			graphics.printColor(text, self.x - 105, self.y - 82)
		end
	end
end)

return obj.RelicShrine