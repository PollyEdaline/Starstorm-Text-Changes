-- Quest Shrine

local sprSwordShrine = Sprite.load("Shrine7", "Interactables/Resources/shrine7", 5, 21, 67)
local sprSwordShrineDeath = Sprite.load("Shrine7Death", "Interactables/Resources/shrine7Death", 6, 25, 75)
--local sSwordShrineComplete = Sound.load("Shrine7Complete", "Interactables/Resources/shrine6Complete")

obj.SwordShrine = Object.base("MapObject", "Shrine7")
obj.SwordShrine.sprite = sprSwordShrine
obj.SwordShrine.depth = -9

obj.SwordShrine:addCallback("create", function(self)
	local selfData = self:getData()
	self.spriteSpeed = 0
	self:set("active", 0)
	self:set("myplayer", -4)
	self:set("activator", 3)
	self:set("cost", 0)
	selfData._draw = {}
	selfData.timer = 0
	selfData.useCount = 0
	for i = 0, 500 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i - 1 
			break
		end
	end
end)

--

obj.SwordShrine:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 16, self.y - 30,self.x + 16, self.y + 2)) do
			selfAc.myplayer = player.id
			
			local itd = {}
			local items = getTrueItems(player) or {}
			for i, item in ipairs(items) do
				for ii = 1, item.count do
					table.insert(itd, item.item)
				end
			end
			
			local amount = math.floor(#itd / 4)
			selfAc.cost = amount
			
			if player:isValid() and player:get("dead") == 0 and player:control("enter") == input.PRESSED then
				if amount > 0 then
					if not net.online or net.localPlayer == player then
						
						if net.online then
							if net.host then
								syncInteractableActivation:sendAsHost(net.ALL, nil, player:getNetIdentity(), self.x, self.y, self:getObject())
							else
								syncInteractableActivation:sendAsClient(player:getNetIdentity(), self.x, self.y, self:getObject())
							end	
						end
						
						_newInteractables[obj.SwordShrine].activation(self, player)
						
					end
				else
					sfx.Error:play()
				end
			end
		end
	end
	if self.subimage >= self.sprite.frames then
		self.spriteSpeed = 0
		self.subimage = self.sprite.frames
	end
	
	if selfData.timer > 0 then
		selfData.timer = selfData.timer - 1
	elseif selfData.input then
		if net.host then
			local item = nil
			while item == nil do
				item = rollItemPool(5, 0, 70, 100)
				if item then item = item:roll() end
			end
			for i = 1, #selfData.input do
				item:create(self.x, self.y - 50)
			end
		end
		selfData.input = nil
		self.subimage = 1
		if selfData.useCount < 3 then
			selfAc.active = 0
			self.spriteSpeed = 0
		else
			self.spriteSpeed = 0.15
			self.sprite = sprSwordShrineDeath
			sfx.WormExplosion:play(1.1)
		end
	end
end)

obj.SwordShrine:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		if obj.P:findRectangle(self.x - 16, self.y - 30, self.x + 16, self.y + 2) and selfAc.myplayer ~= -4 then
			local player = Object.findInstance(selfAc.myplayer)
			
			local keyStr = "Activate"
			if player and player:isValid() then
				keyStr = input.getControlString("enter", player)
			end
			
			local text = ""
			local pp = not net.online or player == net.localPlayer
			if input.getPlayerGamepad(player) and pp then
				text = "Press ".."'"..keyStr.."'".." to offer an exchange"
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to offer an exchange"
			end
			graphics.color(Color.WHITE)
			graphics.alpha(1)
			graphics.printColor(text, self.x - 80, self.y - 77)
			
			if selfAc.active == 0 and selfAc.cost > 0 then
				local plural = ""
				if selfAc.cost > 1 then plural = "S" end
				graphics.alpha(0.8 - (math.random(0, 15) * 0.01))
				graphics.color(Color.fromHex(0xEDE6D5))
				graphics.print(selfAc.cost.." ITEM"..plural, self.x - 3, self.y + 6, FONT_DAMAGE2, graphics.ALIGN_MIDDLE, graphics.ALIGN_TOP)
			end
		end
	end
	if selfData.input then
		local t = selfData.timer
		local d = selfData.input
		
		--local yOffset = -40
		
		if selfData.timer > 0 then
			for i = 1, #selfData._draw do
				if not selfData._draw[i] then
					local xx, yy = self.x, self.y
					selfData._draw[i] = {x = xx, y = yy}
				end
				
				if selfData.timer > 45 then
					local size = 10
					local xOffset = (((size * (i - 1))) + (i - 1)) - ((size / 2) * #selfData._draw)
					local xx = self.x + xOffset
					local yy = self.y - 30
					local xdif = (selfData._draw[i].x - xx) * 0.1
					local ydif = (selfData._draw[i].y - yy) * 0.1
					
					selfData._draw[i].x = math.approach(selfData._draw[i].x, xx, xdif)
					selfData._draw[i].y = math.approach(selfData._draw[i].y, yy, ydif)
				else
					local xx = self.x
					local yy = self.y - 50
					local xdif = (selfData._draw[i].x - xx) * 0.1
					local ydif = (selfData._draw[i].y - yy) * 0.1
					
					selfData._draw[i].x = math.approach(selfData._draw[i].x, xx, xdif)
					selfData._draw[i].y = math.approach(selfData._draw[i].y, yy, ydif)
				end
				
				graphics.drawImage{
					image = selfData._draw[i].item.sprite,
					x = selfData._draw[i].x,
					y = selfData._draw[i].y,
					alpha = 0.6
				}
			end
		else
			graphics.drawImage{
				image = d[1].sprite,
				x = self.x,
				y = self.y - 50,
				alpha = 0.8
			}
		end
	end
end)

return obj.SwordShrine