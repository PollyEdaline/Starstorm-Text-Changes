-- VoidYielder

local sprVoidYielder = Sprite.load("VoidYielder", "Interactables/Resources/VoidYielder", 5, 29, 20)

local sVoidYielder = Sound.load("VoidYielder", "Interactables/Resources/VoidYielder")

obj.VoidYielder = Object.base("MapObject", "VoidYielder")
obj.VoidYielder.sprite = sprVoidYielder
obj.VoidYielder.depth = -6

local syncItem = net.Packet.new("SSkItem", function(player, actor, item)
	local actorI = actor:resolve()
	if actorI and actorI:isValid() then
		NPCItems.giveItem(actorI, item, 1)
	end
end)

--local callbacked = {}

local keyHolderFunc = setFunc(function(actor)
	if net.host and getRule(5, 6) == true then
		actor:getData()._ultradelay = 120
	end
	
	if net.host then
		for i = 1, misc.director:get("enemy_buff") * 2 do
			local item = itp.npc:roll()
			if net.online then
				syncItem:sendAsHost(net.ALL, nil, actor:getNetIdentity(), item)
			end
			NPCItems.giveItem(actor, item, 1)
		end
	end
	
	actor:getData()._ItemDrop = it.VoidKey
	
	local outline = obj.EfOutline:create(0, 0)
	outline:set("rate", 0)
	outline:set("parent", actor.id)
	outline.blendColor = Color.fromHex(0xFF00B6)
	outline.alpha = 0.8
	outline.depth = actor.depth + 1
end)

obj.VoidYielder:addCallback("create", function(self)
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
	
	local tele = obj.Teleporter:find(1)
	if tele and tele:isValid() then
		tele:set("locked", 1)
		selfData.teleporter = tele
		selfData.yieldAdd = (tele:getData().yielded or 0)
		tele:getData().yielded = (tele:getData().yielded or 0) + 1
	end
	
	if net.host then
		--local validMcards = {}
		--for _, card in ipairs(Stage.getCurrentStage().enemies:toTable()) do
			--if card ~= mcard.Wyvern then
				--table.insert(validMcards, card)
			--end
		--end
		local monsterCard = table.irandom(Stage.getCurrentStage().enemies:toTable()) or mcard.Lemurian
		local grounds = {}
		local base = obj.TeleporterFake:find(1) or obj.P:find(1)
		for _, ground in ipairs(obj.B:findAll()) do
			if distance(ground.x, ground.y, self.x, self.y) > 400 and distance(ground.x, ground.y, base.x, base.y) > 500 then
				table.insert(grounds, ground)
			end
		end
		local chosenGround = table.irandom(grounds)
		local groundL = chosenGround.x - (chosenGround.sprite.boundingBoxLeft * chosenGround.xscale)
		local groundR = chosenGround.x + (chosenGround.sprite.boundingBoxRight * chosenGround.xscale)
		local x = math.random(groundL, groundR)
		local y = chosenGround.y
		
		local obj = monsterCard.object
		--[[if not callbacked[obj] then
			obj:addCallback("destroy", function(self)
				it.VoidKey:create(self.x, self.y - 14)
			end)
			callbacked[obj] = true
		end]]
		createSynced(obj, x, y - (obj.sprite.height + obj.sprite.yorigin) * 2, keyHolderFunc)
	end
end)

obj.VoidYielder:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 and not selfData.takenItem then
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 22, self.y - 30,self.x + 22, self.y + 2)) do
			selfAc.myplayer = player.id
			
			if player:isValid() and player:control("enter") == input.PRESSED then
				if not net.online or net.localPlayer == player then
					if player:countItem(it.VoidKey) > 0 then
						
						if net.online then
							if net.host then
								syncInteractableActivation:sendAsHost(net.ALL, nil, player:getNetIdentity(), self.x, self.y, self:getObject())
							else
								syncInteractableActivation:sendAsClient(player:getNetIdentity(), self.x, self.y, self:getObject())
							end	
						end
						
						_newInteractables[obj.VoidYielder].activation(self, player)
					else
						sfx.Error:play()
					end
				end
			end
		end
		
		if selfData.teleporter and selfData.teleporter:isValid() and global.quality > 1 and math.chance(5) then
			par.VoidLines:burst("middle", selfData.teleporter.x, selfData.teleporter.y - 15, 1)
		end
	elseif selfAc.active == 2 then
		if self.subimage >= 5 then
			self.spriteSpeed = 0
			self.subimage = 5
		end
	end
	if selfData.timer then
		if selfData.timer > 0 then
			selfData.timer = selfData.timer - 1
		else
			sVoidYielder:play()
			selfData.timer = nil
			selfAc.active = 2
			self.spriteSpeed = 0.15
			misc.shakeScreen(10)
			misc.hud:set("objective_text", "Activate the Teleporter.")
			if selfData.teleporter and selfData.teleporter:isValid() then
				selfData.teleporter:getData().yielded = selfData.teleporter:getData().yielded - 1
				if selfData.teleporter:getData().yielded <= 0 then
					selfData.teleporter:set("locked", 0)
				end
				local c = obj.EfCircle:create(selfData.teleporter.x, selfData.teleporter.y - 15)
				c:set("radius", 20)
				local color = Color.fromHex(0xFF00B6)
				c.blendColor = color
			end
		end
	end
end)

obj.VoidYielder:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfData.takenItem and selfData.timer then
		local xx, yy
		local player = Object.findInstance(selfAc.activator)
		if player and player:isValid() then
			local newy = self.y - 35
			local ratio = distance(player.x, player.y, self.x, newy) * math.clamp((20 - (selfData.timer - 40)) / 20, 0, 1)
			xx, yy = pointInLine(player.x, player.y, self.x, newy, ratio)
		else
			xx, yy = self.x, self.y - 35
		end
		
		local image = selfData.takenItem.sprite
		graphics.drawImage{
			image = image,
			x = xx,
			y = yy,
			alpha = 0.8,
			subimage = 2
		}
	end
	
	if selfAc.active == 0 then
		if obj.P:findRectangle(self.x - 22, self.y - 30, self.x + 22, self.y + 2) and selfAc.myplayer ~= -4 then
			local player = Object.findInstance(selfAc.myplayer)
			
			local keyStr = "Activate"
			if player and player:isValid() then
				keyStr = input.getControlString("enter", player)
			end
			
			local costStr = " &y&(1 Void Key)"
			
			local text = ""
			local pp = not net.online or player == net.localPlayer
			if input.getPlayerGamepad(player) and pp then
				text = "Press ".."'"..keyStr.."'".." to deactivate the &p&Void Yielder"..costStr
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to deactivate the &p&Void Yielder"..costStr
			end
			graphics.color(Color.WHITE)
			graphics.alpha(1)
			graphics.printColor(text, self.x - 148, self.y - 57)
		end
		--[[graphics.alpha(0.85 - (math.random(0, 15) * 0.01))
		graphics.color(Color.fromHex(0xEDE6D5))
		graphics.print("1 ITEM", self.x - 3, self.y + 6, FONT_DAMAGE2, graphics.ALIGN_MIDDLE, graphics.ALIGN_TOP)]]
		
		graphics.color(Color.fromHex(0xFF00B6))
		graphics.alpha(0.8 + math.sin(global.timer * 0.05) * 0.1)
		local sizeJitter = math.random(-1, 1)
		graphics.line(self.x, self.y, self.x, self.y - 19, 2 + table.random{0, 2})
		graphics.circle(self.x, self.y - 19, 8 + sizeJitter, false)
		graphics.color(Color.WHITE)
		graphics.circle(self.x, self.y - 19, 4, false)
		
		if selfData.teleporter and selfData.teleporter:isValid() then
			graphics.color(Color.fromHex(0xFF00B6))
			local add = selfData.yieldAdd
			local size = 24 + (4 * add) + math.sin(global.timer * 0.02) * 2
			graphics.circle(selfData.teleporter.x - 1, selfData.teleporter.y - 15, size, true)
			
			local angle = posToAngle(selfData.teleporter.x, self.y, self.x, selfData.teleporter.y - 15, true)
			local xx = selfData.teleporter.x + math.cos(angle) * size
			local yy = selfData.teleporter.y - 15 + math.sin(angle) * size
			graphics.line(xx, yy, self.x, self.y - 19, 2 + table.random{0, 2})
			
			graphics.alpha(0.2 + math.sin(global.timer * 0.05 - add * 0.01) * 0.1)
			graphics.circle(selfData.teleporter.x - 1, selfData.teleporter.y - 15, size, false)
		end
	end
end)

return obj.VoidYielder