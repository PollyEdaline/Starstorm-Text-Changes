-- Void Chest

local sprVoidChest = Sprite.load("VoidChest", "Interactables/Resources/voidChest", 15, 24, 24)

local sOpen = Sound.load("VoidChestOpen", "Interactables/Resources/voidChestOpen")

obj.VoidChest = Object.base("MapObject", "VoidChest")
obj.VoidChest.sprite = sprVoidChest
obj.VoidChest.depth = -9

obj.VoidChest:addCallback("create", function(self)
	local selfData = self:getData()
	
	self:set("active", 0)
	
	self:set("time", 0)
	self:set("maxtime", 30 * 60)
	self:set("myplayer", -4)
	self:set("activator", 3)
	for i = 0, 500 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i - 1 
			break
		end
	end
	self.spriteSpeed = 0
end)

local guardSpawnFunc = setFunc(function(spawn)
	if  global.rormlflag.ss_disable_enemies then
		spawn:set("child", 44)
		spawn:set("sound_spawn", 100068)
		spawn.sprite = spr.GuardGSpawn
	else
		spawn:set("child", obj.VoidGuard.id)
		spawn:set("sound_spawn", Sound.find("VoidGuardSpawn").id)
		spawn.sprite = Sprite.find("VoidGuardSpawn")
	end
end)

obj.VoidChest:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 14, self.y - 42,self.x + 14, self.y + 2)) do
			selfAc.myplayer = player.id
			
			if player:isValid() and player:control("enter") == input.PRESSED then
				if not net.online or net.localPlayer == player then
					--if misc.getGold() >= selfAc.cost then
						
						if net.online then
							if net.host then
								syncInteractableActivation:sendAsHost(net.ALL, nil, player:getNetIdentity(), self.x, self.y, self:getObject())
							else
								syncInteractableActivation:sendAsClient(player:getNetIdentity(), self.x, self.y, self:getObject())
							end	
						end
						
						_newInteractables[obj.VoidChest].activation(self, player)
					--else
					--	sfx.Error:play()
					--end
				end
			end
		end
	elseif selfAc.active == 2 then
		if self.subimage >= 3 then
			self.spriteSpeed = 0
			self.subimage = 3
		end
		if selfAc.time < selfAc.maxtime then
			if net.host then
				local sTime = math.ceil(60 / math.max(#obj.P:findMatching("dead", 0) * 0.8, 1))
				local chance = 8 + math.max(misc.director:get("enemy_buff") * 1, 1)
				if selfAc.time == 0 or selfAc.time % sTime == 0 and math.chance(chance) then
					local w, h = 300, 150
					local ground = table.irandom(obj.B:findAllRectangle(self.x - w, self.y - h, self.x + w, self.y + h))
					local groundL = ground.x - (ground.sprite.boundingBoxLeft * ground.xscale)
					local groundR = ground.x + (ground.sprite.boundingBoxRight * ground.xscale)
					local x, y = math.random(groundL, groundR), ground.y - 15
					createSynced(obj.Spawn, x, y, guardSpawnFunc)
				end
			end
			selfAc.time = selfAc.time + 1
		else
			selfAc.active = 3
			self.spriteSpeed = 0.2
			self.subimage = 3
			sOpen:play(0.7)
		end
	elseif selfAc.active == 3 then
		if self.subimage >= 6 and not selfData.spawnedItems then
			selfData.spawnedItems = true
			misc.shakeScreen(14)
			if net.host then
				for i = 1, #misc.players do
					local xx = (i - (#misc.players / 2)) * 35
					if ar.Command.active then
						itp.rare:getCrate():create(self.x + xx, self.y - 15)
					else
						itp.rare:roll():getObject():create(self.x + xx, self.y - 20)
					end
				end
			end
		end
		if self.subimage >= self.sprite.frames then
			self.spriteSpeed = 0
			self.subimage = self.sprite.frames
		end
	end
end)



obj.VoidChest:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	graphics.color(Color.WHITE)
	
	if selfAc.active == 0 then
		if obj.P:findRectangle(self.x - 14, self.y - 42, self.x + 14, self.y + 2) and selfAc.myplayer ~= -4 then
			local player = Object.findInstance(selfAc.myplayer)
			
			local keyStr = "Activate"
			if player and player:isValid() then
				keyStr = input.getControlString("enter", player)
			end
			
			local text = ""
			local pp = not net.online or player == net.localPlayer
			if input.getPlayerGamepad(player) and pp then
				text = "Press ".."'"..keyStr.."'".." to activate the &p&Void Chest"
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to activate the &p&Void Chest"
			end
			graphics.alpha(1)
			graphics.printColor(text, self.x - 82, self.y - 57)
		end
	end
	
	if selfAc.active == 2 then
		graphics.alpha(1)
		local str = tostring(math.ceil(selfAc.time / 60)).."/"..tostring(selfAc.maxtime / 60).." seconds"
		graphics.print(str, self.x + 1, self.y - 60, graphics.FONT_DAMAGE2, graphics.ALIGN_MIDDLE, graphics.ALIGN_TOP)
	end
end)

return obj.VoidChest