-- EscapePod

local sprEscapePod = Sprite.load("EscapePod", "Interactables/Resources/escapePod", 5, 56, 57)
local sprEscapePodUse1 = Sprite.load("EscapePodUse1", "Interactables/Resources/escapePodUse1", 5, 56, 57)
local sprEscapePodUse2 = Sprite.load("EscapePodUse2", "Interactables/Resources/escapePodUse2", 5, 56, 57)
local sprEscapePodUse3 = Sprite.load("EscapePodUse3", "Interactables/Resources/escapePodUse3", 5, 56, 57)
local sprEscapePodUse4 = Sprite.load("EscapePodUse4", "Interactables/Resources/escapePodUse4", 5, 56, 57)
local sprEscapePodUse5 = Sprite.load("EscapePodUse5", "Interactables/Resources/escapePodUse5", 5, 56, 57)

obj.EscapePod = Object.base("MapObject", "EscapePod")
obj.EscapePod.sprite = sprEscapePod
obj.EscapePod.depth = 2

local podEnemyFunc = setFunc(function(actor, eliteType)
	local n = 0
	while actor:collidesMap(actor.x, actor.y) and n < 100 do
		if not actor:collidesMap(actor.x + 4, actor.y) then
			actor.x = actor.x + 4
		elseif not actor:collidesMap(actor.x - 4, actor.y) then
			actor.x = actor.x - 4
		elseif not actor:collidesMap(actor.x, actor.y + 5) then
			actor.y = actor.y + 5
		else
			actor.y = actor.y - 1
		end
		n = n + 1
	end
	
	if eliteType then
		actor:makeElite(EliteType.find(eliteType))
	end
end)


local syncEscapePodEnemy = net.Packet.new("SSEscapePodEnemy", function(player, x, y, enemyObject, amount, ids, sound)
	
	local resolvedIds = {}
	for str in string.gmatch(ids, "([^".."_".."]+)") do
		table.insert(resolvedIds, str)
	end
	
	local yOffset = 0
	local xOffset = 0 - (amount / 2)
	for i = 1, amount do
		if enemyObject.sprite then
			local n = 0
			while Stage.collidesPoint(x + xOffset, y - 20 - enemyObject.sprite.yorigin + enemyObject.sprite.height - yOffset) and n < 50 do
				yOffset = yOffset + 1
				n = n + 1
			end
		end
		
		if ar.Honor.active then
			
		end
		
		createSynced(enemyObject, x + xOffset, y - 20 - yOffset, podEnemyFunc, eliteType)
		
		xOffset = xOffset + 1
	end
	if sound then
		sound:play()
	end
end)

obj.EscapePod:addCallback("create", function(self)
	local selfData = self:getData()
	
	self.spriteSpeed = 0
	local frame = math.random(1, self.sprite.frames)
	self.subimage = frame
	selfData.frame = frame
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

obj.EscapePod:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		self.sprite = sprEscapePod
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
					
					_newInteractables[obj.EscapePod].activation(self, player)
					
				end
			end
		end
	elseif selfAc.active == 2 then
		local frame = selfData.frame
		if frame then
			self.subimage = 1
			if frame == 1 then
				self.sprite = sprEscapePodUse1
			elseif frame == 2 then
				self.sprite = sprEscapePodUse2
			elseif frame == 3 then
				self.sprite = sprEscapePodUse3
			elseif frame == 4 then
				self.sprite = sprEscapePodUse4
			else
				self.sprite = sprEscapePodUse5
			end
			selfData.frame = nil
		end
		if self.subimage >= 5 then
			self.spriteSpeed = 0
			self.subimage = 5
		else
			self.spriteSpeed = 0.2
		end
	end
	if selfData.timer then
		if selfData.timer == 0 then
			selfData.timer = nil
			if not net.online or net.host then
				if math.chance(15) then
					spawnItem(1, 15, 30, 100, self.x, self.y - 20)
					
				elseif math.chance(70) then
					local dif = Difficulty.getScaling()
					local stage = Stage:getCurrentStage()
					
					local difMult = dif * 35
					
					local enemies = stage.enemies:toTable()
					local spawnableEnemies = {}
					for _, enemy in ipairs(enemies) do
						if enemy.cost <= difMult and enemy.type ~= "origin" and enemy.type ~= "player" then
							table.insert(spawnableEnemies, {card = enemy, cost = enemy.cost})
						end
					end
					if #spawnableEnemies > 0 then
						local enemyRoll = table.irandom(spawnableEnemies)
						local enemyObject = enemyRoll.card.object
						local enemyCount = math.clamp(math.round(((difMult - enemyRoll.cost) / enemyRoll.cost)), 1, 25)
						
						local yOffset = 0
						local xOffset = 0 - (enemyCount / 2)
						
						local ids = ""
						
						for i = 1, enemyCount do
							if enemyObject.sprite then
								local n = 0
								while Stage.collidesPoint(self.x + xOffset, self.y - 20 - enemyObject.sprite.yorigin + enemyObject.sprite.height - yOffset) and n < 50 do
									yOffset = yOffset + 1
									n = n + 1
								end
							end
							
							--local enemyInst = enemyObject:create(self.x + xOffset, self.y - 20 - yOffset)
							--enemyInst:set("sync", 1)
							--local id = setID(enemyInst)
							--local next = "_"
							--if i == enemyCount then next = "" end
							--ids = ids..id..next
							
							local eliteType
							if ar.Honor.active then
								eliteType = table.irandom(enemyRoll.card.eliteTypes:toTable())
							end
							if eliteType then eliteType = eliteType:getName() end
							
							createSynced(enemyObject, self.x + xOffset, self.y - 20 - yOffset, podEnemyFunc, eliteType)
							
							xOffset = xOffset + 1
						end
						
						local sound = nil
						if enemyRoll.card.sound then
							sound = enemyRoll.card.sound
							enemyRoll.card.sound:play()
						end
						
						if net.online then
							--syncEscapePodEnemy:sendAsHost(net.ALL, nil, self.x, self.y, enemyObject, enemyCount, ids, sound)
							syncSound:sendAsHost(net.ALL, nil, sound)
						end
					end
					
				elseif math.chance(30) then
					local corpse = obj.Corpse:create(self.x, self.y - 6)
					corpse.sprite = spr.GManDeath
				end
			end
		else
			selfData.timer = selfData.timer - 1
		end
	end
end)

obj.EscapePod:addCallback("draw", function(self)
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
				text = "Press ".."'"..keyStr.."'".." to open the Escape Pod"
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to open the Escape Pod"
			end
			graphics.color(Color.WHITE)
			graphics.alpha(1)
			graphics.printColor(text, self.x - 88, self.y - 57)
		end
	end
end)

return obj.EscapePod