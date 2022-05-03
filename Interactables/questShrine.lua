-- Quest Shrine

-- this is terribly coded.

local sprQuestShrine = Sprite.load("Shrine6", "Interactables/Resources/shrine6", 6, 18, 43)
local sprQuestShrineDeath = Sprite.load("Shrine6Death", "Interactables/Resources/shrine6Death", 6, 18, 43)
local sQuestShrineComplete = Sound.load("Shrine6Complete", "Interactables/Resources/shrine6Complete")

obj.QuestShrine = Object.base("MapObject", "Shrine6")
obj.QuestShrine.sprite = sprQuestShrine
obj.QuestShrine.depth = -9

obj.QuestShrine:addCallback("create", function(self)
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
	
	selfData.firstStep = true
end)

buff.failedTrial = Buff.new("failedTrial")
buff.failedTrial.sprite = Sprite.load("TrialDebuff", "Gameplay/trialDebuff", 1, 9, 5)
buff.failedTrial:addCallback("start", function(actor)
	local actorAc = actor:getAccessor()
	actorAc.pHmax = actorAc.pHmax - 0.3
	actorAc.critical_chance = actorAc.critical_chance - 150
	sfx.ChildGShoot1:play(1.2)
end)
buff.failedTrial:addCallback("end", function(actor)
	local actorAc = actor:getAccessor()
	actorAc.pHmax = actorAc.pHmax + 0.3
	actorAc.critical_chance = actorAc.critical_chance + 150
end)

--

local player = obj.P
local blacklistEnemies = {
	[obj.Worm] = true,
	[obj.WormHead] = true,
	[obj.WormBody] = true,
	[obj.Acrid] = true,
	[obj.Boss1] = true,
	[obj.Boss3Fake] = true,
	[obj.Boss3] = true,
	[obj.WurmController] = true,
	[obj.WurmHead] = true,
	[obj.WurmBody] = true,
	[obj.LizardGS] = true,
	[obj.ImpS] = true,
}


local foundEnemies = {}

table.insert(call.onStageEntry, function()
	foundEnemies = {}
end)

callback.register("onTrueActorInit", function(npc)
	if npc:get("team") == "enemy" then
		if contains(foundEnemies, npc:get("name")) == false and npc:get("exp_worth") ~= nil and npc:get("exp_worth") > 0 then
			if not blacklistEnemies[npc:getObject()] and not npc:getData().isNemesis then
				--if not net.online or npc:get("name") ~= net.localPlayer:get("user_name") then 
					worth = npc:get("exp_worth")
					if npc:get("prefix_type") == 1 then
						worth = worth * 2
					end
					if npc:get("prefix_type") == 2 then
						worth = worth * 7
					end
					if npc:get("isUltra") then
						worth = worth * 25
					end
					table.insert(foundEnemies, {npc:get("name"), worth})
				--end
			end
		end
	end
end)

local irregularPlurals = {{"Mans", "Men"}, {"Childs", "Children"}, {"Jellyfishs", "Jellyfish"}, {"Colossuss", "Colossi"}}
local trialTasks = {
	{
		name = "Kill",
		onGive = function(shrineQuest)
			local enemyRoll = table.irandom(foundEnemies)
			if global.pvp and global.versus then
				local players = {}
				for _, player in ipairs(misc.players) do
					if not net.online or player ~= net.localPlayer then
						table.insert(players, player)
					end
				end
				local roll = table.irandom(players) or misc.players[1]
				enemyRoll = {roll:get("user_name"), 99999999}
			end
			if enemyRoll == nil then
				local stage = Stage.getCurrentStage()
				local stageEnemies = stage.enemies:toTable()
				if #stageEnemies > 0 then
					local monsterCardRoll = stageEnemies[1]
					enemyRoll = {monsterCardRoll:getName(), monsterCardRoll.cost}
				else
					enemyRoll = {"Lemurian", 10}
				end
			end
			
			--local amountCalc = math.max(Difficulty.getScaling() * (3 / enemyRoll[2]), 1)
			local amountCalc = (misc.director:get("time_start") / 160) * (40 / enemyRoll[2])
			local amount = math.max(math.floor(math.random(amountCalc * 0.5, amountCalc + 0.5)), 1)
			--local amount = math.floor(math.random(amountCalc * 0.5, amountCalc) + 0.5)
			amount = math.floor(amount)
			local plural = ""
			if amount > 1 then
				plural = "s"
			end
			
			local name = enemyRoll[1]..plural
			
			-- Fixing the wrong plurals
			for _, str in ipairs(irregularPlurals) do
				name = string.gsub(name, str[1], str[2])
			end
			
			local taskString = ("Kill "..amount.." "..name)
			
			local shrineObjective = nil
			
			
			local quests = Quest.getActive()
			
			local notFound = true
			
			local n = 0
			while notFound and n < 50 do
				notFound = false
				for q, quest in ipairs(quests) do
					if shrineQuest == q then
						for o, objective in ipairs(quest.objectives) do
							if objective.title == taskString and objective.requirement == amount then
								amount = amount + 1
								
								local plural = ""
								if amount > 1 then
									plural = "s"
								end
								
								local name = enemyRoll[1]..plural
								
								-- Fixing the wrong plurals
								for _, str in ipairs(irregularPlurals) do
									name = string.gsub(name, str[1], str[2])
								end
								
								taskString = ("Kill "..amount.." "..name)
								notFound = true
								break --ugly code ugly code ugly code
							end
						end
						break
					end
				end
				n = n + 1
			end
			
			return taskString, 0, amount, enemyRoll[1]
			
		end
	}, 
	{
		name = "Avoid damage",
		onGive = function(shrineQuest)
			local timeRoll = math.random(10, 35)
			
			local amount = timeRoll
			
			local taskString = ("Avoid damage for "..amount.." ".."seconds")
			
			local shrineObjective = nil
			
			local quests = Quest.getActive()
			
			local notFound = true
			
			local n = 0
			while notFound and n < 50 do
				notFound = false
				for q, quest in ipairs(quests) do
					if shrineQuest == q then
						for o, objective in ipairs(quest.objectives) do
							if objective.title == taskString and objective.requirement == amount then
								amount = amount + 1
								
								taskString  = ("Stay alive for "..amount.." seconds")
								notFound = true
								break
							end
						end
						break
					end
				end
				n = n + 1
			end
			
			return taskString, 0, amount, {current = 0, target = amount * 60}
			
		end
	},
	{
		name = "Don't use skills",
		onGive = function(shrineQuest)
			local timeRoll = math.random(8, 17)
			
			local amount = timeRoll
			
			local taskString = ("Don't use skills for "..amount.." ".."seconds")
			
			local shrineObjective = nil
			
			local quests = Quest.getActive()
			
			local notFound = true
			
			local n = 0
			while notFound and n < 50 do
				notFound = false
				for q, quest in ipairs(quests) do
					if shrineQuest == q then
						for o, objective in ipairs(quest.objectives) do
							if objective.title == taskString and objective.requirement == amount then
								amount = amount + 1
								
								taskString  = ("Don't use skills for "..amount.." seconds")
								notFound = true
								break
							end
						end
						break
					end
				end
				n = n + 1
			end
			
			return taskString, 0, amount, {current = 0, target = amount * 60}
			
		end
	},
	{
		name = "Find treasure",
		onGive = function(shrineQuest)
			local amount = 60
			
			local ii = 0
			local taskString = "Find the treasure before time runs out"
			
			local shrineObjective = nil
			
			local quests = Quest.getActive()
			
			local notFound = true
			
			for q, quest in ipairs(quests) do
				if shrineQuest == q then
					for o, objective in ipairs(quest.objectives) do
						if objective.title == taskString then
							ii = ii + 1
							taskString  = "Find the treasure before time runs out ".."x"..ii + 1
							notFound = false
						end
					end
				end
			end
			
			local object = obj.ExpChest
			
			local grounds = obj.B:findAll()
			
			local ground, groundL, groundR, x, y
			
			local ww = object.sprite.width / 2
			
			ground = table.irandom(grounds)
			groundL = ground.x - (ground.sprite.boundingBoxLeft * ground.xscale) + ww
			groundR = ground.x + (ground.sprite.boundingBoxRight * ground.xscale) - ww
			x = math.random(groundL, groundR)
			y = ground.y
			
			local child = object:create(x, y)
			
			return taskString, amount, nil, {current = 0, target = amount * 60, ii = ii, childChest = child}
			
		end
	}
}

obj.QuestShrine:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 16, self.y - 30,self.x + 16, self.y + 2)) do
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
					
					_newInteractables[obj.QuestShrine].activation(self, player)
					
					local shrineQuest = Quest.set("Shrine of Trial")
					
					local type = table.irandom(trialTasks)
					
					local taskString, progress, requirement, data = type.onGive(shrineQuest)
					
					shrineObjective = Quest.setObjective(shrineQuest, taskString, progress, requirement, false, {value = data, type = type, attempt = 0, attempts = 3, giver = self, player = player})
					
					if net.host then
						createFakeItem(self.x, self.y - 20, player.id, "Quest Obtained", taskString)
					else
						syncFakeItem:sendAsClient(self.x, self.y - 20, player:getNetIdentity(), "Quest Obtained", taskString)
					end
					
				end
			end
		end
	end
	if self.subimage >= self.sprite.frames then
		self.spriteSpeed = 0
		self.subimage = self.sprite.frames
	end
end)

obj.QuestShrine:addCallback("draw", function(self)
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
				text = "Press ".."'"..keyStr.."'".." to accept a Quest"
			else
				text = "Press ".."&y&'"..keyStr.."'&!&".." to accept a Quest"
			end
			graphics.color(Color.WHITE)
			graphics.alpha(1)
			graphics.printColor(text, self.x - 70, self.y - 67)
		end
	end
end)

table.insert(call.onStep, function()
	for q, quest in pairs(Quest.getActive()) do
		if quest.name == "Shrine of Trial" then
			for o, objective in pairs(quest.objectives) do
				if objective.requirement and objective.progress >= objective.requirement or objective.requirement == nil and objective.progress == 0 then
					local parent = objective.additionalData.player
					if parent and parent:isValid() and not objective.additionalData.failed then
						local g = objective.additionalData.giver
						if g and g:isValid() and not g:getData().destroyed then
							g.sprite = sprQuestShrineDeath
							g.spriteSpeed = 0.15
							g.subimage = 1
							if onScreen(g) then
								sfx.WormExplosion:play(1.1)
							end
							g:getData().destroyed = true
						end
						if not parent:getData().finishedQuests then
							parent:getData().finishedQuests = 1
						else
							parent:getData().finishedQuests = parent:getData().finishedQuests + 1
						end
						Quest.setObjective(q, o, nil, nil, true)
						sQuestShrineComplete:play()
						local chancePlus = misc.director:get("time_start") / 120
						spawnItem(1 + chancePlus, 15 + chancePlus, 30 + chancePlus, 100, parent.x, parent.y - 20)
						objective.additionalData.player = nil
					else
						if not objective.additionalData.doneCheck then
							objective.additionalData.doneCheck = true
							local go = not net.online or net.localPlayer == parent
							if parent and parent:isValid() and isa(parent, "PlayerInstance") and go then
								applySyncedBuff(parent, buff.failedTrial, 720, false)
								if parent:countItem(it.SnakeEyes) > 0 then
									applySyncedBuff(parent, buff.dice1, 90000000, false)
								end
							end
						end
						local g = objective.additionalData.giver
						if g and g:isValid() and not g:getData().destroyed then
							g.sprite = sprQuestShrineDeath
							g.spriteSpeed = 0.15
							g.subimage = 1
							if onScreen(g) then
								sfx.WormExplosion:play(1.1)
							end
							g:getData().destroyed = true
						end
						Quest.setObjective(q, o, nil, nil, true)
					end
				end
			end
		end
	end
end)

onNPCDeath.shrineoftrial = function(npc)
	for q, quest in pairs(Quest.getActive()) do
		if quest.name == "Shrine of Trial" then
			for o, objective in pairs(quest.objectives) do
				if objective.additionalData.player and objective.additionalData.player:get("dead") == 0 then
					if objective.additionalData.type == trialTasks[1] then
						if string.find(npc:get("name"), objective.additionalData.value) then
							Quest.setObjective(q, o, objective.progress + 1)
						end
					end
				end 
			end
		end
	end
end

table.insert(call.onStep, function()
	for q, quest in pairs(Quest.getActive()) do
		if quest.name == "Shrine of Trial" then
			for o, objective in pairs(quest.objectives) do
				if objective.additionalData.player and objective.additionalData.player:get("dead") == 0 then
					
					if not objective.additionalData.i then
						objective.additionalData.i = false
					end
					
					local player = objective.additionalData.player
					local php = player:get("hp")
					local tookDamage = player:getData().qlastHp and player:getData().qlastHp > php
					
					local usedSkill = player:get("z_skill") == 1 or player:get("x_skill") == 1 or player:get("c_skill") == 1 or player:get("v_skill") == 1
					
					if objective.additionalData.type == trialTasks[2] then
						local refresh = false
						
						if objective.additionalData.i ~= tookDamage then
							refresh = true
							objective.additionalData.i = tookDamage
							--print("____")
						end
						--print(objective.additionalData.i, tookDamage, refresh)
						
						if refresh and tookDamage then
							--print("aaa")
							objective.additionalData.attempt = objective.additionalData.attempt + 1
							if objective.additionalData.attempt >= objective.additionalData.attempts then
								objective.additionalData.failed = true
								objective.progress = objective.requirement
							end
						end
						
						if not objective.additionalData.failed then
							local data = objective.additionalData.value
							if tookDamage then
								objective.additionalData.value.current = 0
							else
								if data.current < data.target then
									objective.additionalData.value.current = data.current + 1
								end
							end
							objective.progress = math.round(data.current / 60)
						end
					elseif objective.additionalData.type == trialTasks[3] then
						local refresh = false
						
						if objective.additionalData.i ~= usedSkill then
							refresh = true
							objective.additionalData.i = usedSkill
						end
						
						if refresh and usedSkill then
							objective.additionalData.attempt = objective.additionalData.attempt + 1
							if objective.additionalData.attempt >= objective.additionalData.attempts then
								objective.additionalData.failed = true
								objective.progress = objective.requirement
							end
						end
						
						
						if not objective.additionalData.failed then
							local data = objective.additionalData.value
							if usedSkill then
								objective.additionalData.value.current = 0
							else
								if data.current < data.target then
									objective.additionalData.value.current = data.current + 1
								end
							end
							objective.progress = math.round(data.current / 60)
						end
					elseif objective.additionalData.type == trialTasks[4] then
						
						local notFound = true
						
						if objective.additionalData.value.childChest:isValid() then
							notFound = objective.additionalData.value.childChest:get("active") == 0
						end
						
						
						if not objective.additionalData.failed then
							local data = objective.additionalData.value
							if notFound then
								if data.current < data.target then
									objective.additionalData.value.current = data.current + 1
									if data.current >= data.target - 31 then
										objective.additionalData.failed = true
										data.current = data.target
										if data.childChest:isValid() then
											data.childChest:destroy()
										end
									end
								end
							else
								data.current = data.target
							end
							objective.progress = 60 - math.round(data.current / 60)
						end
					end
				end 
			end
		end
	end
end)
table.insert(call.onPlayerStep, function(player)
	player:getData().qlastHp = player:get("hp")
end)

return obj.QuestShrine