-- Peculiar Rock
local path = "Interactables/Resources/"

local sprPeculiarRock = Sprite.load("PeculiarRockInt", path.."peculiarRock.png", 1, 13, 19)
obj.PeculiarRock = Object.new("PeculiarRock")
obj.PeculiarRock.sprite = sprPeculiarRock
obj.PeculiarRock.depth = 9

obj.PeculiarRock:addCallback("create", function(self)
	local selfData = self:getData()
	
	self.spriteSpeed = 0
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

obj.PeculiarRock:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		self.sprite = sprPeculiarRock
		self.spriteSpeed = 0
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 22, self.y - 42, self.x + 22, self.y + 2)) do
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
					
					_newInteractables[obj.PeculiarRock].activation(self, player)
					
				end
			end
		end
	end
end)

obj.PeculiarRock:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
	
		if obj.P:findRectangle(self.x - 22, self.y - 42, self.x + 22, self.y + 2) and selfAc.myplayer ~= -4 then
			local player = Object.findInstance(selfAc.myplayer)
			
			local keyStr = "Activate"
			if player and player:isValid() then
				keyStr = input.getControlString("enter", player)
			end
			
			local text = ""
			local pp = not net.online or player == net.localPlayer
			if input.getPlayerGamepad(player) and pp then
				text = "Press ".."'"..keyStr.."'".." to inspect.."
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to inspect.."
			end
			graphics.color(Color.WHITE)
			graphics.alpha(1)
			graphics.printColor(text, self.x - 50, self.y - 25)
		end
	end
end)

table.insert(call.onStageEntry, function()
	local room = Room.getCurrentRoom()
	
	if room == rm.void1_1 then
		obj.PeculiarRock:create(1820, 832)
	elseif room == rm.void1_2 then
		obj.PeculiarRock:create(2188, 992)
	end
end)

return obj.PeculiarRock