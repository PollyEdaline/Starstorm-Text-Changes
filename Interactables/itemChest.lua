-- Item Chest

local sprItemChest = Sprite.load("ItemChest", "Interactables/Resources/itemChest", 15, 21, 24)

obj.ItemChest = Object.base("MapObject", "ItemChest")
obj.ItemChest.sprite = sprItemChest
obj.ItemChest.depth = -9

--[[local syncItemChestItem = net.Packet.new("SSItemChestItem", function(player, x, y, item, cost, amount)
	local instanceI = obj.ItemChest:findNearest(x, y)
	if instanceI and instanceI:isValid() and item then
		instanceI:getData().item = item
		instanceI:getData().amount = amount
		instanceI:set("cost", cost)
	end
end)]]

local syncItemChest
syncItemChest = net.Packet.new("SSItemChest", function(sender, id, item, cost, count)
	runData["traderChest"..id] = {item = item:getName(), cost = cost, count = count, set  = false}
	if net.host then
		syncItemChest:sendAsHost(net.EXCLUDE, sender, id, item, cost, count)
	end
end)

local rarityCosts = {
	[itp.common] = 200,
	[itp.uncommon] = 500,
	[itp.rare] = 1500
}
local rarityMults = {
	[itp.common] = 0.8,
	[itp.uncommon] = 0.65,
	[itp.rare] = 0.4
}

local chestCount = 3

local function setChestData(i, uses, sync)
	local pool = table.irandom({itp.common, itp.uncommon, itp.rare})
	local item = pool:roll()
	
	local difPoint = math.random(2, 60)
	
	local valueMult = 1
	--[[if pool == itp.uncommon then 
		valueMult = 3
	elseif pool == itp.rare then 
		valueMult = 11
	end]]
	
	local difVal = difPoint * valueMult
	
	local count = math.ceil(difPoint * rarityMults[pool])
	
	local cost = math.max(math.ceil((difVal * rarityCosts[pool]) * getRule(1, 16), 0)) * math.min(misc.director:get("enemy_buff") * 0.65, 1)
	if runData["traderChest"..i] then
		runData["traderChest"..i].item = item:getName()
		runData["traderChest"..i].cost = cost
		runData["traderChest"..i].count = count
		runData["traderChest"..i].uses = uses
	else
		runData["traderChest"..i]  = {item = item:getName(), cost = cost, count = count, uses = uses}
	end
	if sync and net.online then
		if net.host then
			syncItemChest:sendAsHost(net.ALL, nil, i, item, cost, count)
		else
			syncItemChest:sendAsClient(i, item, cost, count)
		end	
	end
end

callback.register("postSelection", function()
	if net.host then
		for i = 1, chestCount do
			setChestData(i, 3, true)
		end
	end
end)

obj.ItemChest:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.id = 1
	selfData.item = itp.common:roll()
	
	self:set("f", 0)
	self:set("yy", 0)
	self:set("active", 0)
	
	self:set("cost", 25)
	selfData.amount = 1
	selfData.uses = 3
	self:set("myplayer", -4)
	self:set("activator", 3)
	for i = 0, 500 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i - 1 
			break
		end
	end
	self.spriteSpeed = 0
	
	selfData.synctimer = 20
	selfData.yoffset = 0
end)

obj.ItemChest:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	local data = runData["traderChest"..selfData.id]
	
	if not data.set then
		data.set = true
		
		selfData.item = Item.find(data.item)
		selfData.amount = data.count
		selfAc.cost = data.cost
	end
	
	
	--[[if selfData.synctimer and net.online and net.host then
		if selfData.synctimer > 0 then
			selfData.synctimer = selfData.synctimer - 1
		else
			syncItemChestItem:sendAsHost(net.ALL, nil, self.x, self.y, selfData.item, selfAc.cost, selfData.amount)
			selfData.synctimer = nil
		end
	end]]
	
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
						
						_newInteractables[obj.ItemChest].activation(self, player)
					else
						sfx.Error:play()
					end
				end
			end
		end
	elseif selfAc.active == 2 then
		if not selfData.func then
			if net.host then
				setChestData(selfData.id, selfData.uses, true)
			end
			data.set = false
			selfData.func = true
		end
		if selfData.uses > 0 then
			if self.subimage < 2 then
				selfAc.active = 0
				self.spriteSpeed = 0
				self.subimage = 1
			end
		else
			if self.subimage >= 9 then
				self.spriteSpeed = 0
				self.subimage = 9
			end
		end
	end
end)



obj.ItemChest:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		graphics.color(Color.WHITE)
		local image = selfData.item.sprite
		local yy = self:get("yy")
		graphics.drawImage{
			image = image,
			x = self.x,
			y = self.y - 37 + yy,
			alpha = 0.7,
			subimage = 2
		}
		
		if selfData.amount > 1 then
			graphics.alpha(0.7)
			graphics.print("x"..selfData.amount, self.x - 11, math.round(self.y - 31 + yy), nil, graphics.ALIGN_LEFT)
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
				text = "Press ".."'"..keyStr.."'".." to purchase item"..costStr
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to purchase item"..costStr
			end
			graphics.alpha(1)
			graphics.printColor(text, self.x - 78, self.y - 57)
		end
	end
	
	if selfAc.cost > 0 and selfAc.active == 0 then
		graphics.alpha(0.85 - (math.random(0, 15) * 0.01))
		graphics.color(Color.fromHex(0xEFD27B))
		local _, _, minus, int, fraction = tostring(selfAc.cost):find('([-]?)(%d+)([.]?%d*)')
		int = int:reverse():gsub("(%d%d%d)", "%1,")
		costStr = minus .. int:reverse():gsub("^,", "") .. fraction
		graphics.print("$"..costStr, self.x - 2, self.y + 6 + selfData.yoffset, FONT_DAMAGE2, graphics.ALIGN_MIDDLE, graphics.ALIGN_TOP)
	end
end)

return obj.ItemChest