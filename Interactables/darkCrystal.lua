-- Item Chest

local sprDarkCrystal = Sprite.load("DarkCrystal", "Interactables/Resources/darkCrystal", 15, 20, 67)

obj.DarkCrystal = Object.base("MapObject", "DarkCrystal")
obj.DarkCrystal.sprite = sprDarkCrystal
obj.DarkCrystal.depth = 2 --9

local syncDarkCrystalItems = net.Packet.new("SSDarkCrystalItem", function(player, x, y, item, curseItem, cost)
	local instanceI = obj.DarkCrystal:findNearest(x, y)
	if instanceI and instanceI:isValid() and item then
		instanceI:getData().item = item
		instanceI:getData().curseItem = curseItem
		instanceI:set("cost", cost)
	end
end)

obj.DarkCrystal:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.item = itp.rare:roll()
	selfData.curseItem = itp.curse:roll()
	self:set("f", 0)
	self:set("yy", 0)
	self:set("active", 0)
	
	local dif = misc.director:get("enemy_buff")
	
	self:set("cost", 0)
	
	selfData.uses = 5
	self:set("myplayer", -4)
	self:set("activator", 3)
	for i = 0, 500 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i - 1 
			break
		end
	end
	self.spriteSpeed = 0
	
	selfData.synctimer = 15
end)

obj.DarkCrystal:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfData.synctimer and net.online and net.host then
		if selfData.synctimer > 0 then
			selfData.synctimer = selfData.synctimer - 1
		else
			syncDarkCrystalItems:sendAsHost(net.ALL, nil, self.x, self.y, selfData.item, selfData.curseItem, selfAc.cost)
			selfData.synctimer = nil
		end
	end
	
	selfAc.f = selfAc.f + 0.05
	selfAc.yy = math.cos(selfAc.f) * 2
	
	if selfAc.active == 0 then
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 14, self.y - 42,self.x + 14, self.y + 2)) do
			selfAc.myplayer = player.id
			
			if player:isValid() and player:control("enter") == input.PRESSED then
				if not net.online or net.localPlayer == player then
					if misc.getGold() >= selfAc.cost and selfData.uses > 0 then
						
						if net.online then
							if net.host then
								syncInteractableActivation:sendAsHost(net.ALL, nil, player:getNetIdentity(), self.x, self.y, self:getObject())
							else
								syncInteractableActivation:sendAsClient(player:getNetIdentity(), self.x, self.y, self:getObject())
							end	
						end
						
						misc.setGold(misc.getGold() - selfAc.cost)
						
						_newInteractables[obj.DarkCrystal].activation(self, player)
					else
						sfx.Error:play()
					end
				end
			end
		end
	elseif selfAc.active == 2 then
		if self.subimage < 2 then
			selfAc.active = 0
			self.spriteSpeed = 0
			self.subimage = 1
		end
	end
end)

obj.DarkCrystal:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		if selfData.uses > 0 then
			graphics.color(Color.WHITE)
			local image = selfData.item.sprite
			local yy = self:get("yy")
			graphics.drawImage{
				image = image,
				x = self.x,
				y = self.y - 57 + yy,
				alpha = 0.7,
				subimage = 2
			}
		end
	
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
				text = "Press ".."'"..keyStr.."'".." to exchange for a curse"..costStr
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to exchange for a curse"..costStr
			end
			graphics.alpha(1)
			graphics.printColor(text, self.x - 78, self.y - 57)
		end
	end
	
	if selfAc.cost > 0 and selfAc.active == 0 then
		graphics.alpha(0.85 - (math.random(0, 15) * 0.01))
		graphics.color(Color.fromHex(0xEFD27B))
		graphics.print("&y&$"..selfAc.cost, self.x - 3, self.y + 6, graphics.FONT_DAMAGE, graphics.ALIGN_MIDDLE, graphics.ALIGN_TOP)
	end
end)

return obj.DarkCrystal