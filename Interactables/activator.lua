-- Activator

local sprActivator = Sprite.load("Activator", "Interactables/Resources/activator", 5, 13, 44)
local sprActivatorUse = Sprite.load("ActivatorUse", "Interactables/Resources/activatorUse", 5, 15, 44)

obj.Activator = Object.base("MapObject", "Activator")
obj.Activator.sprite = sprActivator
obj.Activator.depth = -9

local blacklistItems = {
	[it.CarraraMarble] = true,
	[it.DynamitePlunger] = true,
	[it.RottenBrain] = true,
	[Item.find("Counterfeit Teleporter", "Starstorm")] = true,
	[Item.find("Deicide", "Starstorm")] = true,
	[Item.find("Black Market Contact", "Starstorm")] = true,
	[Item.find("G-Hook", "Starstorm")] = true
}

itp.activator = ItemPool.new("Activator")
for _, item in ipairs(itp.use:toList()) do
	if not blacklistItems[item] then
		itp.activator:add(item)
	end
end


local syncActivatorItem = net.Packet.new("SSActivatorItem", function(player, x, y, item)
	local instanceI = obj.Activator:findNearest(x, y)
	if instanceI and instanceI:isValid() and item then
		instanceI:getData().item = item
	end
end)

obj.Activator:addCallback("create", function(self)
	local selfData = self:getData()
	local item
	if ar.Enigma.active then
		item = table.irandom(itp.activator:toList())
	else
		item = itp.activator:roll()
	end
	selfData.item = item
	self.spriteSpeed = 0.2
	self:set("f", 0)
	self:set("yy", 0)
	self:set("active", 0)
	if misc.director and misc.director:isValid() then
		self:set("cost", math.ceil((misc.director:get("enemy_buff") - 0.5) * 40))
	end
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

obj.Activator:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfData.firstStep then
		if net.online and net.host then
			syncActivatorItem:sendAsHost(net.ALL, nil, self.x, self.y, selfData.item)
		end
		selfData.firstStep = nil
	end
	
	selfAc.f = selfAc.f + 0.05
	selfAc.yy = math.cos(selfAc.f) * 2
	
	if selfAc.active == 0 then
		self.sprite = sprActivator
		self.spriteSpeed = 0.2
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
						
						_newInteractables[obj.Activator].activation(self, player)
					else
						sfx.Error:play()
					end
				end
			end
		end
	elseif selfAc.active == 2 then
		self.sprite = sprActivatorUse
		if self.subimage >= 5 then
			self.spriteSpeed = 0
			self.subimage = 5
		end
		
		if selfData.timer > 0 then
			selfData.timer = selfData.timer - 1
		else
			selfAc.active = 0
		end
	end
end)

obj.Activator:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		local image = selfData.item.sprite
		graphics.drawImage{
			image = image,
			x = self.x,
			y = self.y - 27 + self:get("yy"),
			alpha = 0.7,
			subimage = 2
		}
	
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
				text = "Press ".."'"..keyStr.."'".." to activate item"..costStr
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to activate item"..costStr
			end
			graphics.color(Color.WHITE)
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

return obj.Activator