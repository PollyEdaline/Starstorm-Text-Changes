-- VoidKey

local sprVoidKey = Sprite.load("VoidKey", "Interactables/Resources/VoidKey", 1, 17, 22)
local sprVoidKeyIdle = Sprite.load("VoidKeyIdle", "Interactables/Resources/VoidKeyIdle", 4, 15, 20)
local sprVoidKeyActivate = Sprite.load("VoidKeyActivate", "Interactables/Resources/VoidKeyActivate", 16, 25, 30)
local sprVoidSigil = Sprite.load("VoidSigil", "Interactables/Resources/VoidSigil", 5, 13, 13)

local sVoidSafeActivate = Sound.load("VoidSafeActivate", "Interactables/Resources/VoidSafeActivate")
local sVoidSafeIdle = Sound.load("VoidSafeIdle", "Interactables/Resources/VoidSafeIdle")
local sVoidSafeEnd = Sound.load("VoidSafeEnd", "Interactables/Resources/VoidSafeEnd")

local paths = {
	[1] = {
		name = "Path of The Exiled",
		subimage = 1,
		onStep = function()
			if misc.director:getAlarm(0) == 59 then
				for _, player in ipairs(misc.players) do
					if not player:getData().exileMoved then
						if player:get("pHmax") ~= 0 then
							player:getData().exileMoved = true
						end
					else
						local smite = obj.EfSmite:create(player.x, player.y)
						smite:set("team", "enemy")
						smite:set("damage", 40 * Difficulty.getScaling("damage"))
						smite:setAlarm(0, 60)
						smite.blendColor = Color.PINK
						local outline = obj.EfOutline:create(0, 0)
						outline:set("rate", 0.02)
						outline:set("parent", smite.id)
						outline.blendColor = Color.fromHex(0xFF00B6)
						outline.alpha = 1
						outline.depth = smite.depth + 1
					end
				end
			end
		end,
	},
	[2] = {
		name = "Path of The Ruined",
		subimage = 2,
		onEntry = function()
			for i, player in ipairs(misc.players) do
				if not runData["lostItems"..i] then
					runData["lostItems"..i] = {}
				end
				local allItems = getTrueItems(player)
				for _, itemData in ipairs(allItems) do
					local toRemove = math.min(itemData.count, 1)
					runData["lostItems"..i][itemData.item:getName()] = toRemove
					player:removeItem(itemData.item, toRemove)
				end
			end
		end,
		onExit = function()
			--if Stage.getCurrentStage() ~= stg.VoidPaths then
				for i, player in ipairs(misc.players) do
					for itemName, count in pairs(runData["lostItems"..i]) do
						local item = Item.find(itemName)
						player:set("item_count_total", player:get("item_count_total") + count)
						player:giveItem(item, count)
						runData["lostItems"..i][itemName] = nil
					end
					runData["lostItems"..i] = nil
				end
			--end
		end
	},
	[3] = {
		name = "Path of The Cursed",
		subimage = 3,
		onEntry = function()
			if net.host then
				runData.curseChoice = itp.curse:roll()
				syncInstanceData:sendAsHost(net.ALL, nil, "curseChoice", runData.curseChoice)
			end
		end,
		onExit = function()
			for _, player in ipairs(misc.players) do
				local playerData = player:getData()
				local item = playerData.pendingCurse
				player:removeItem(item, 1)
				playerData.pendingCurse = nil
			end
		end,
		onStep = function()
			if runData.curseChoice then
				local item = runData.curseChoice
				for _, player in ipairs(misc.players) do
					player:giveItem(item, 1)
					local playerData = player:getData()
					if not net.online or player == net.localPlayer then
						runData.cursePickupDisplay = 180
						playerData.cursePickupDisplay = {title = item.displayName, text = item.pickupText, i = 520}
						sfx.CursePickup:play()
					end
					playerData.pendingCurse = item
				end
				runData.curseChoice = nil
			end
		end
	},
	[4] = {
		name = "Path of The Blighted",
		subimage = 4,
		onStep = function()
			for _, spawn in ipairs(obj.Spawn:findAll()) do
				spawn.blendColor = Color.BLACK
			end
			for _, actor in ipairs(pobj.actors:findAll()) do
				if not actor:getData().pathBlight then
					actor:getData().pathBlight = true
					--[[actor:set("maxhp", actor:get("maxhp") * 2)
					actor:set("prefix_type", 2)
					actor:set("blight_type", t[(misc.hud:get("second") % 4) + 1])
					local t = {3, 5, 7, 11, 13}]]
					actor:makeBlighted(0)
				end
			end
		end
	},
	--[[[5] = {
		name = "Path of The Fallen",
		subimage = 5
	},]]
}

local guardSpawnFunc = setFunc(function(spawn, id)
	if id == 1 then
		if global.rormlflag.ss_disable_enemies then
			spawn:set("child", 44)
			spawn:set("sound_spawn", 100068)
			spawn.sprite = spr.GuardGSpawn
			spawn:set("elite_type", elt.Void.id)
			spawn:set("prefix_type", 1)
		else
			spawn:set("child", obj.VoidGuard.id)
			spawn:set("sound_spawn", Sound.find("VoidGuardSpawn").id)
			spawn.sprite = Sprite.find("VoidGuardSpawn")
		end
	else
		if global.rormlflag.ss_disable_enemies then
			spawn:set("child", 44)
			spawn:set("sound_spawn", 100068)
			spawn.sprite = spr.GuardGSpawn
			spawn:set("elite_type", elt.Void.id)
			spawn:set("prefix_type", 1)
		else
			spawn:set("child", obj.Gatekeeper.id)
			spawn:set("sound_spawn", Sound.find("GatekeeperSpawn").id)
			spawn.sprite = Sprite.find("GatekeeperSpawn")
			spawn.depth = -8
			spawn:set("elite_type", elt.Void.id)
			spawn:set("prefix_type", 1)
		end
	end
end)

obj.VoidSigil = Object.new("VoidSigil")
obj.VoidSigil.sprite = sprVoidSigil
obj.VoidSigil.depth = -10
obj.VoidSigil:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.timer = 180
	local flash = obj.EfFlash:create(0,0):set("parent", self.id):set("rate", 0.05)
	flash.depth = self.depth - 1
	self.spriteSpeed = 0
	
	selfData.path = paths[1]
	
	selfData.id = 1
	selfData.accel = 0
end)
obj.VoidSigil:addCallback("step", function(self)
	local selfData = self:getData()
	if selfData.timer > 0 then
		selfData.timer = selfData.timer - 1
	else
		if selfData.accel < 1 then
			selfData.accel = selfData.accel + 0.0005
		end
		local t = obj.VoidGate:findMatching("gateId", selfData.id)
		if t[1] and t[1]:isValid() then
			t = t[1]
			if distance(self.x, self.y, t.x, t.y - 30) < 10 and not t:getData().path then
				t:getData().path = selfData.path
				t:getData().firstFrame = true
				t.subimage = 2
				createSynced(obj.Spawn, t.x, t.y + 80, guardSpawnFunc, 2)
				misc.hud:set("objective_text", "Traverse a Void Gate.")
			end
			local difx = t.x - self.x
			local dify = t.y - 30 - self.y
			self.x = math.approach(self.x, t.x, difx * 0.03 * selfData.accel)
			self.y = math.approach(self.y, t.y - 30, dify * 0.03 * selfData.accel)
			if math.chance((global.quality - 1) * 15) then
				par.VoidSigil:burst("middle", self.x, self.y, 1, Color.fromHex(0xFF00B6))
			end
		end
	end
end)
obj.VoidSigil:addCallback("draw", function(self)
	local selfData = self:getData()
	if selfData.timer > 0 and selfData.timer < 150 then
		graphics.alpha(math.min(selfData.timer * 0.05, (150 - selfData.timer) * 0.06))
		graphics.color(Color.WHITE)
		outlinedPrint(selfData.path.name, self.x, self.y - 40, Color.DARK_GRAY, nil, graphics.ALIGN_MIDDLE)
	end
end)

obj.VoidKey = Object.base("MapObject", "VoidKey")
obj.VoidKey.sprite = sprVoidKey
obj.VoidKey.depth = -5


local syncVoidKeyPath = net.Packet.new("SSVoidKeyId", function(player, x, y, id)
	local instanceI = obj.VoidKey:findNearest(x, y)
	if instanceI and instanceI:isValid() and id then
		instanceI:getData().path = paths[id]
	end
end)

obj.VoidKey:addCallback("create", function(self)
	local selfData = self:getData()
	local validPaths = {}
	for _, path in ipairs(paths) do
		if not runData.chosenPaths or not runData.chosenPaths[path.subimage] then
			table.insert(validPaths, path)
		end
	end
	selfData.path = table.irandom(validPaths)
	if not runData.chosenPaths then runData.chosenPaths = {} end
	runData.chosenPaths[selfData.path.subimage] = true
	self.spriteSpeed = 0
	self:set("active", 0)
	if misc.director and misc.director:isValid() then
		self:set("cost", 0)--math.ceil((misc.director:get("enemy_buff") - 0.5) * 40))
	end
	self:set("myplayer", -4)
	self:set("activator", 3)
	for i = 0, 500 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i - 1 
			break
		end
	end
	
	selfData.time = 0
	selfData.maxTime = 40 * 60
	selfData.syncTimer = 1
end)

obj.VoidKey:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfData.syncTimer then
		if selfData.syncTimer > 0 then
			selfData.syncTimer = selfData.syncTimer - 1
		else
			if net.online and net.host then
				syncVoidKeyPath:sendAsHost(net.ALL, nil, self.x, self.y, selfData.path.subimage)
			end
			selfData.firstStep = nil
		end
	end
	
	if selfAc.active == 0 then
		self.spriteSpeed = 0
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 25, self.y - 10, self.x + 25, self.y + 20)) do
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
						
						_newInteractables[obj.VoidKey].activation(self, player)
					else
						sfx.Error:play()
					end
				end
			end
		end
	elseif selfAc.active == 1 then
		if not sVoidSafeIdle:isPlaying() then
			sVoidSafeIdle:loop()
		end
		self.sprite = sprVoidKeyIdle
		self.spriteSpeed = 0.2
		if selfData.time < selfData.maxTime then
			selfData.time = selfData.time + 1
			
			if misc.director:getAlarm(1) > 1 then
				misc.director:setAlarm(1, misc.director:getAlarm(1) - 1)
			end
			
			if not selfData.firstFrameActive then
				selfData.firstFrameActive = true
				sVoidSafeActivate:play()
				
				if net.host then
					for i = 1, 4 do
						local w, h = 300, 300
						local ground = table.irandom(obj.B:findAllRectangle(self.x - w, self.y - h, self.x + w, self.y + 100))
						local groundL = ground.x - (ground.sprite.boundingBoxLeft * ground.xscale)
						local groundR = ground.x + (ground.sprite.boundingBoxRight * ground.xscale)
						local x, y = math.random(groundL, groundR), ground.y - 15
						createSynced(obj.Spawn, x, y, guardSpawnFunc, 1)
					end
				end
				
				local rope = obj.Rope:findRectangle(self.x + 155, self.y + 10, self.x + 158, self.y + 60)
				if rope and rope:isValid() then
					rope.y = rope.y + 16
				end
			end
		else
			selfAc.active = 2
			self.sprite = sprVoidKeyActivate
			for _, barrier in ipairs(obj.VoidBarrier:findAllRectangle(self.x - 500, self.y - 500, self.x + 500, self.y + 500)) do
				barrier:getData().active = false
			end
			
			local rope = obj.Rope:findRectangle(self.x + 155, self.y + 10, self.x + 158, self.y + 60)
			if rope and rope:isValid() then
				rope.y = rope.y - 16
			end
		end
	elseif selfAc.active == 2 then
		if not selfData.playedSound then
			selfData.playedSound = true
			sVoidSafeIdle:stop()
			sVoidSafeEnd:play()
		end
		if self.subimage >= 16 then
			if not selfData.createdSigil then
				misc.shakeScreen(3)
				selfData.createdSigil = true
				local sigil = obj.VoidSigil:create(self.x, self.y - 5)
				sigil:getData().path = selfData.path
				sigil:getData().id = selfData.id
				sigil.subimage = selfData.path.subimage
			end
			self.spriteSpeed = 0
			self.subimage = 16
		end
	end
end)

obj.VoidKey:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
	
		if obj.P:findRectangle(self.x - 25, self.y - 10, self.x + 25, self.y + 20) and selfAc.myplayer ~= -4 then
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
				text = "Press ".."'"..keyStr.."'".." to activate the &p&Void Safe"..costStr
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to activate the &p&Void Safe"..costStr
			end
			graphics.color(Color.WHITE)
			graphics.alpha(1)
			graphics.printColor(text, self.x - 88, self.y - 40)
		end
	elseif selfAc.active == 1 then
		graphics.color(Color.WHITE)
		graphics.alpha(1)
		local str = math.ceil(selfData.time / 60).."/"..math.ceil(selfData.maxTime / 60).." seconds"
		graphics.print(str, self.x, self.y - 50, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE)
	end
	
	if selfAc.cost > 0 and selfAc.active == 0 then
		graphics.alpha(0.85 - (math.random(0, 15) * 0.01))
		graphics.color(Color.fromHex(0xEFD27B))
		graphics.print("&y&$"..selfAc.cost, self.x - 3, self.y + 26, graphics.FONT_DAMAGE, graphics.ALIGN_MIDDLE, graphics.ALIGN_TOP)
	end
end)

return obj.VoidKey