-- Relic Shrine

local sprRelicChest = Sprite.load("RelicChest2", "Interactables/Resources/relicChest2.png", 7, 18, 50)

obj.RelicShrine2 = Object.base("MapObject", "RelicShrine2")
obj.RelicShrine2.sprite = sprRelicChest
obj.RelicShrine2.depth = -9

obj.RelicShrine2:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.itemIndex = 1
	selfData.item = itp.relic:roll()
	selfData.timer = 0

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

obj.RelicShrine2:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	selfAc.f = selfAc.f + 0.05
	selfAc.yy = math.cos(selfAc.f)
	
	selfData.timer = (selfData.timer + 1) % 20
	if selfData.timer == 0 and onScreen(self) then
		local relics = itp.relic:toList()
		selfData.itemIndex = math.max((selfData.itemIndex + 1) % #relics, 1)
		selfData.item = relics[selfData.itemIndex]
		if contains(getRule(1, 23), selfData.item) then
			selfData.item = itp.relic:roll()
		end
		--table.irandom(selectableRelics)
	end
	
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
					
					_newInteractables[obj.RelicShrine2].activation(self, player)
					
				end
			end
		end
		if math.chance(70) and global.quality > 1 then
			par.Relic:burst("middle", self.x, self.y + math.random(-30, 0), 1)
		end
	end
	if self.subimage >= 7 then
		self.spriteSpeed = 0
		self.subimage = 7
	end
end)

obj.RelicShrine2:addCallback("draw", function(self)
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

return obj.RelicShrine2