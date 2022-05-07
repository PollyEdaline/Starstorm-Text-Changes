-- Item Chest

--local itemData = {}


local sibyline = Color.fromHex(0xFFCCED).gml
local relic = Color.fromHex(0xC649AD).gml

local intActivity = 23

local relicColor = Color.fromHex(0xC649AD).gml
local sibylineColor = Color.fromHex(0xFFCCED).gml

local rarityWeights = {
	["w"] = 10,
	["g"] = 30,
	[relicColor] = 15,
	["r"] = 50,
	["y"] = 60,
	[sibylineColor] = 100
}

global.seraphCount = 0

local seraphCountSave = save.read("seraphCount")
if seraphCountSave then
	global.seraphCount = seraphCountSave
end

local artifactRollArtifact
callback.register("postLoad", function() artifactRollArtifact = Artifact.find("Havoc", "Starstorm") end)

local SERAPH_ROLL = "I am dumb"
local SWORD_ROLL = it.GildedOrnament
local ARTIFACT_ROLL = "Havoc"
local NOTHING = "Too bad"

local rollChoices = {
	--SWORD_ROLL,
	ARTIFACT_ROLL,
	itp.legendary,
	itp.rare,
	itp.uncommon,
	SERAPH_ROLL,
	itp.common,
	NOTHING
	--itp.curse
}

local choiceChances = {
	--[SWORD_ROLL] = -1,
	[ARTIFACT_ROLL] = -30,
	[itp.rare] = -10,
	[itp.legendary] = 2,
	[SERAPH_ROLL] = 20,
	[itp.uncommon] = 25,
	[itp.common] = 45,
	[NOTHING] = 90
	--[itp.curse] = 90
}
local rarityColors = {
	["w"] = Color.WHITE,
	["bl"] = Color.BLACK,
	["g"] = Color.fromHex(0x93E180),
	["r"] = Color.fromHex(0xE7543A),
	["or"] = Color.fromHex(0xFF8000),
	["y"] = Color.fromHex(0xFFFF00),
	["p"] = Color.fromHex(0xEC5ED3),
	["lt"] = Color.fromHex(0xC0C0C0),
	["dk"] = Color.fromHex(0x4040400),
	["b"] = Color.fromHex(0x319AD2)
}

local specialExchanges = {
	[it.PeculiarRock] = {it.GildedOrnament},
	[it.VoidKey] = {it.Eggplant}
}

local crystalSelection = 1
local selectionCd = 0

local sprMask = Sprite.load("TraderMask", "Actors/Trader/Mask", 1, 10, 20)

local sprites = {
	idle = Sprite.load("TraderIdle", "Actors/Trader/Idle", 1, 16, 30),
	death = Sprite.load("TraderDeath", "Actors/Trader/Death", 10, 24, 41),
	walk = Sprite.load("TraderWalk", "Actors/Trader/Walk", 4, 15, 31),
}

local dialogue = {
	entry = {
		"Gate bring...",
		"Greeting.",
		"Stranger, exchange?",
		"Gate traveler... Offer?",
		"Ego, perplex... Stranger...",
		"Ego, gelid... Stranger, warms...",
		"Stranger, breath... Ego, breath..."
	},
	idle = {
		"Gate, bring. gate, take...",
		"Stranger, breath... Gelid...",
		"Stranger, company...",
		"Stranger, presence, warm...",
		"Mischief... Consequence...",
		"Entangle, growth, exchange?",
		"Exchange, good...",
		"Fortuitious condition, probable.",
		"Mutual welfare... Offer?",
		"Gate, perplex.",
		"Gate, paradox.",
		"Twisted lost, ego breath.",
		"Ruse. Ego, parcel.",
		"...",
		"Gilded king... Disdain... Ego...",
		"Gilded king... Ruse...",
		"Gilded kind... Power, false...",
		"Ornament... Gelid...",
		"Time, steady..."
	}
}

local sprCrystal = Sprite.load("SeraphShard", "Items/Resources/Seraph's Shard", 1, 15, 15)
local sprExit = Sprite.load("CancelCrate", "Misc/Menus/cancelCrate", 1, 15, 15)

local exitButton = {item = {sprite = sprExit}}

obj.Crystal = Object.base("BossClassic", "Trader")
obj.Crystal.sprite = sprites.idle
obj.Crystal.depth = 2

local syncSwordRolled
syncSwordRolled = net.Packet.new("SSSwordRoll", function(sender)
	runData.rolledSword = true
	if net.host then
		syncSwordRolled:sendAsHost(net.EXCLUDE, sender)
	end
end)
local hostSyncArtifactRolled = net.Packet.new("SSArtifactRoll", function(sender, x, y)
	artifactRollArtifact:getObject():create(x, y)
end)
--[[local spawnItem = net.Packet.new("SSCrystalItem", function(sender, player, item)
	local playerI = player:resolve()
	playerI:giveItem(item, 1)
	playerI:set("item_count_total", playerI:get("item_count_total") + 1)
	if net.host then
		spawnItem:sendAsHost(net.EXCLUDE, sender, player, item)
	end
end)]]
local syncData
syncData = net.Packet.new("SSCrystalData", function(sender, player, item, optionChoice)
	if net.host then
		syncData:sendAsHost(net.EXCLUDE, sender, player, item, optionChoice)
	end
	
	local playerI = player:resolve()
	local playerData = playerI:getData()
	local playerAc = playerI:getAccessor()
	
	if isa(item, "Item") then
		playerI:removeItem(item, 1)
		playerData.activatedTimer = 200
		playerData.givingCrystalItem = item
		playerData._csitempos2 = {x = playerI.x, y = playerI.y - 35}
		
		playerData._csitem = optionChoice
	else
		playerAc.activity = 0
		playerAc.activity_type = 0
	end
end)

--[[local function giveItemCurseCheck(item, player)
	player:set("item_count_total", player:get("item_count_total") + 1)
	if itp.curse:contains(item) then
		local playerData = player:getData()
		if not net.online or player == net.localPlayer then
			runData.cursePickupDisplay = 180
			playerData.cursePickupDisplay = {title = item.displayName, text = item.pickupText, i = 520}
		end
		sfx.CursePickup:play()
		return true
	end
end]]

local syncText = net.Packet.new("SSCrystalText", function(sender, text, duration)
	local crystal = obj.Crystal:find(1)
	if crystal and crystal:isValid() then
		crystal:getData().textDuration = duration
		crystal:getData().textString = text
	end
end)

local syncWanted = net.Packet.new("SSCrystalWanted", function(sender, item)
	local crystal = obj.Crystal:find(1)
	if crystal and crystal:isValid() then
		crystal:getData().wantedItem = item
	end
end)

local function generateRollOptions(luck, wantedItem, givenItem)
	local trueRollChoices = {}
	
	for _, i in ipairs(rollChoices) do
		if i ~= SERAPH_ROLL or not runData.rolledSeraphPiece then
			if i ~= ARTIFACT_ROLL or artifactRollArtifact and getRule(1, 14) == true and not artifactRollArtifact.unlocked then
				if i ~= SWORD_ROLL or not runData.rolledSword then
					--if i ~= itp.curse or luck <= 10 then
					if i ~= NOTHING or luck <= 10 then
						table.insert(trueRollChoices, i)
					end
				end
			end
		end
	end
	
	local t = {}
	
	for i = 1, 4 do
		local choice = itp.common
		
		for _, option in ipairs(trueRollChoices) do
			if math.chance(choiceChances[option] + ((luck - 10) / 1.3)) then
				choice = option
				break
			end
		end
		
		if choice == SERAPH_ROLL then
			--runData.rolledSeraphPiece = true
			for o, option in ipairs(trueRollChoices) do
				if option == SERAPH_ROLL then
					table.remove(trueRollChoices, o)
				end
			end
		elseif choice == SWORD_ROLL then
			for o, option in ipairs(trueRollChoices) do
				if option == SWORD_ROLL then
					table.remove(trueRollChoices, o)
				end
			end
		elseif choice == ARTIFACT_ROLL then
			for o, option in ipairs(trueRollChoices) do
				if option == ARTIFACT_ROLL then
					table.remove(trueRollChoices, o)
				end
			end
		elseif choice == NOTHING then
			for o, option in ipairs(trueRollChoices) do
				if option == ARTIFACT_ROLL then
					table.remove(trueRollChoices, o)
				end
			end
		elseif isa(choice, "ItemPool") then
			local poolItems = {}
			for _, item in ipairs(choice:toList()) do
				if item ~= wantedItem and item ~= givenItem and not item.isUseItem then
					if not global.itemAchievements[item] or global.itemAchievements[item]:isComplete() then
						table.insert(poolItems, item)
					end
				end
			end
			choice = table.irandom(poolItems)
		end
		if choice then
			table.insert(t, choice)
		end
	end
	
	
	return t
end

local function thres(value, low, high)
	local result = math.clamp(value - low, 0, high - low) / (high - low)
	return result
end

--[[local function trigger(player, crystal, item) -- unused, yikes
	local playerData = player:getData()
	local crystalData = crystal:getData()
	
	player:removeItem(item, 1)
	playerData.activatedTimer = 200
	playerData.givingCrystalItem = item
	if specialExchanges[item] then
		crystalData.options = specialExchanges[item]
		crystalData.optionChoice = table.irandom(crystalData.options)
		playerData._csitem = crystalData.optionChoice
	else
		local luck = crystalData.itemData[item].chance
		crystalData.options = generateRollOptions(luck, crystalData.wantedItem, item)
		crystalData.optionChoice = table.irandom(crystalData.options)
		if crystalData.optionChoice == SERAPH_ROLL then
			--runData.rolledSeraphPiece = true
		elseif crystalData.optionChoice == SWORD_ROLL then
			runData.rolledSword = true
			playerData._csitem = crystalData.optionChoice
		elseif crystalData.optionChoice == NOTHING then
			-- poop
		else
			playerData._csitem = crystalData.optionChoice
		end
		crystalData.itemData[item].chance = math.max(crystalData.itemData[item].chance - 4, 1)
	end
end]]

local validWantedPools = {itp.common, itp.uncommon, itp.rare}

obj.Crystal:addCallback("create", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	self.mask = sprMask
	
	selfAc.f = 0
	selfAc.yy = 0
	selfAc.active = 0
	selfAc.maxhp = 132000
	selfAc.hp = selfAc.maxhp
	selfAc.damage = 1000
	selfAc.pHmax = 0.6
	selfAc.team = "player"
	selfAc.sync = 0
	selfAc.name = "Zanzan the Faded"
	selfAc.name2 = "Stranded Stranger"
	
	self:setAnimations(sprites)
	self:setAnimation("jump", sprites.idle)
	
	selfAc.sound_hit = sfx.ScavengerHit.id
	selfAc.sound_death = sfx.LizardDeath.id
	
	selfData.itemData = {}
	selfData.options = {}
	
	local validWantItems = {}
	
	for _, item in ipairs(Item.findAll()) do
		local color = item.color
		if isa(color, "Color") then
			color = color.gml
		end
		local itemRarityChance = rarityWeights[color] or 20
		local chance = math.min(math.round(math.random(itemRarityChance * 0.45, itemRarityChance + 5)), 100)
		selfData.itemData[item] = {
			item = item,
			chance = chance,
			rarityValue = itemRarityChance
		}
	end
	
	for _, pool in ipairs(validWantedPools) do
		for _, item in ipairs(pool:toList()) do
			if not global.itemAchievements[item] or global.itemAchievements[item]:isComplete() then
				table.insert(validWantItems, item)
			end
		end
	end
	
	local wantedItem = table.irandom(validWantItems)
	selfData.itemData[wantedItem].chance = math.min(selfData.itemData[wantedItem].rarityValue + 35, 100)
	selfData.wantedItem = wantedItem
	
	selfAc.cost = 0
	
	selfData.syncTimer = 120
	
	selfAc.myplayer = -4
	selfAc.activator = 3
	for i = 0, 500 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i - 1 
			break
		end
	end
	self.spriteSpeed = 0
	
	if global.rormlflag.ss_unlock_all or acSeraph:isComplete() then
		runData.rolledSeraphPiece = true
	end
end)

obj.Crystal:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 14, self.y - 42,self.x + 14, self.y + 2)) do
			selfAc.myplayer = player.id
			
			if player:isValid() and player:control("enter") == input.PRESSED and player:get("activity") ~= intActivity and not selfData.ignoreFrame then
				if not net.online or net.localPlayer == player then
					if misc.getGold() >= selfAc.cost and #player:getData().items > 0 then
						
						if net.online then
							if net.host then
								syncInteractableActivation:sendAsHost(net.ALL, nil, player:getNetIdentity(), self.x, self.y, self:getObject())
							else
								syncInteractableActivation:sendAsClient(player:getNetIdentity(), self.x, self.y, self:getObject())
							end	
						end
						
						misc.setGold(misc.getGold() - selfAc.cost)
						
						_newInteractables[obj.Crystal].activation(self, player)
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
	
	if selfData.ignoreFrame then
		if selfData.ignoreFrame > 0 then
			selfData.ignoreFrame = selfData.ignoreFrame - 1
		else
			selfData.ignoreFrame = nil
		end
	end
	
	if #obj.P:findMatching("activity", intActivity) == 0 then
		selfAc.pHmax = 0.6
	else
		selfAc.pHmax = 0
	end
	
	if selfData.syncTimer and net.host then
		if selfData.syncTimer > 0 then
			selfData.syncTimer = selfData.syncTimer - 1
		else
			syncWanted:sendAsHost(net.ALL, nil, selfData.wantedItem)
			selfData.syncTimer = nil
		end
	end
	
	if misc.getTimeStop() == 0 then
		if self.x < 635 then
			selfAc.moveRight = 1
		elseif self.x > 932 then
			selfAc.moveLeft = 1
		end
		if selfData.textDuration then
			if selfData.textDuration > 0 then
				selfData.textDuration = selfData.textDuration - 1
			else
				selfData.textDuration = nil
			end
		else
			if net.host then
				local text, duration
				if not selfData.saluted then
					local r = 100
					if obj.P:findEllipse(self.x - r, self.y - r, self.x + r, self.y + r) then
						selfData.saluted = true
						text = table.irandom(dialogue.entry)
						duration = 280
					end
				else
					if math.chance(1) and math.chance(10) then
						text = table.irandom(dialogue.idle)
						duration = 260
					end
				end
				if text then
					syncText:sendAsHost(net.ALL, nil, text, duration)
					selfData.textString = text
					selfData.textDuration = duration
				end
			end
		end
	end
end)
obj.Crystal:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		graphics.color(Color.WHITE)
		
	
		if obj.P:findRectangle(self.x - 14, self.y - 42, self.x + 14, self.y + 2) and selfAc.myplayer ~= -4 then
			local player = Object.findInstance(selfAc.myplayer)
			
			local pp = not net.online or player == net.localPlayer
			if pp and player:get("activity") ~= intActivity then
				
				local keyStr = "Activate"
				if player and player:isValid() then
					keyStr = input.getControlString("enter", player)
				end
				
				local costStr = ""
				if selfAc.cost > 0 then
					costStr = " &y&($"..selfAc.cost..")"
				end
				
				local text = ""
				if input.getPlayerGamepad(player) then
					text = "Press ".."'"..keyStr.."'".." to trade with The Stranger"..costStr
				else
					text = "Press ".."&y&'"..keyStr.."'&!&".." to trade with The Stranger"..costStr
				end
				graphics.alpha(1)
				graphics.printColor(text, self.x - 78, self.y - 57)
			end
		end
	end
	if selfData.textDuration then
		local length = graphics.textWidth(selfData.textString, 1) * 0.5
		graphics.printColor(selfData.textString, self.x - length, self.y - 45)
	end
	
	if selfAc.cost > 0 and selfAc.active == 0 then
		graphics.alpha(0.85 - (math.random(0, 15) * 0.01))
		graphics.color(Color.fromHex(0xEFD27B))
		graphics.print("&y&$"..selfAc.cost, self.x - 3, self.y + 6, graphics.FONT_DAMAGE, graphics.ALIGN_MIDDLE, graphics.ALIGN_TOP)
	end
end)
table.insert(call.onDraw, function()
	for _, player in ipairs(misc.players) do
		local isLocalPlayer = not net.online or net.localPlayer == player
		if true then
			local playerData = player:getData()
			local matchingCrystal = obj.Crystal:findNearest(player.x, player.y)
			
			if player:get("activity") == intActivity and matchingCrystal and matchingCrystal:isValid() then
				
				local crystalData = matchingCrystal:getData()
				
				if playerData.activatedTimer then
					local givenItem = playerData.givingCrystalItem
					
					local timerRev = 200 - playerData.activatedTimer
					
					if isLocalPlayer then
						local backAlpha = thres(playerData.activatedTimer, 0, 10)
						graphics.color(Color.BLACK)
						graphics.alpha(0.4 * backAlpha)
						graphics.rectangle(player.x - 1000, player.y - 1000, player.x + 1000, player.y + 1000, false)
						
						graphics.alpha(0.5 * backAlpha)
						graphics.color(Color.BLACK)
						graphics.circle(player.x, player.y, (40 + math.cos(global.timer * 0.04) * 10) * thres(playerData.activatedTimer, 80, 100), false)
						
						graphics.color(Color.PINK)
						local wobble = math.sin(global.timer * 0.031) * 5
						graphics.circle(player.x, player.y, 130 + wobble, true)
						graphics.circle(player.x, player.y, 125 + wobble, true)
						graphics.circle(player.x, player.y, 135 + wobble, true)
						
						if not playerData._csitempos then playerData._csitempos = {x = player.x, y = player.y} end -- pog
						
						--local dis = distance(playerData._csitempos.x, playerData._csitempos.y, player.x, player.y)
						local disx = playerData._csitempos.x - player.x
						local disy = playerData._csitempos.y - player.y
						playerData._csitempos.x = math.approach(playerData._csitempos.x, player.x, disx * 0.2)
						playerData._csitempos.y = math.approach(playerData._csitempos.y, player.y, disy * 0.2)
						--local disProgress = dis * thres(timerRev, 0, 5)
						--local itemx, itemy = pointInLine(playerData._csitempos.x, playerData._csitempos.y, player.x, player.y, disProgress)
						
						graphics.drawImage{
							image = givenItem.sprite,
							x = playerData._csitempos.x,
							y = playerData._csitempos.y,
							scale = scale,
							alpha = thres(playerData.activatedTimer, 80, 100)
						}
						
						local r = 360 / #crystalData.options
						local radius = 130
						
						--local aalpha = thres(timerRev, 30, 60) - thres(timerRev, 150, 180)
						local f = false
						
						for i, option in ipairs(crystalData.options) do
							
							local ii = i * 4
							local aalpha = thres(timerRev, 15 + ii, 40 + ii) --- thres(timerRev, 180, 190)
							
							local iii = (r * (i - 1)) - 90 + (90 * thres(playerData.activatedTimer, 100, 200))
							local xx = player.x + (math.cos(math.rad(iii)) * radius)
							local yy = player.y + (math.sin(math.rad(iii)) * radius)
							
							local scale = 1
							if crystalData.optionChoice == option and timerRev > 80 and not f then
								scale = 1 + thres(timerRev, 110, 200) * 0.5
								f = true
							else
								aalpha = aalpha - thres(timerRev, 110, 120)
							end
							
							local image
							local ccolor = Color.PINK
							
							if isa(option, "Item") then
								image = option.sprite
								if isa(option.color, "Color") then
									ccolor = option.color
								else
									ccolor = rarityColors[option.color] or Color.WHITE
								end
							elseif option == ARTIFACT_ROLL then
								image = artifactRollArtifact.pickupSprite
							elseif option == SERAPH_ROLL then
								image = sprCrystal
							elseif option == NOTHING then
								image = sprExit
							else
								image = spr.Random
							end
							
							graphics.alpha(0.4 * aalpha)
							graphics.color(ccolor)
							graphics.circle(xx, yy, 30 + math.cos((global.timer + ii) * 0.023) * 5, false)
							
							graphics.drawImage{
								image = image,
								x = xx,
								y = yy,
								scale = scale,
								alpha = aalpha
							}
						end
						
					else
						
						local playeryy = player.y - 35
						local crystalyy = matchingCrystal.y - 45
						
						if not playerData._csitempos2 then playerData._csitempos2 = {x = player.x, y = player.y - 35} end
						
						if playerData.activatedTimer > 100 then
							local disx = playerData._csitempos2.x - matchingCrystal.x
							local disy = playerData._csitempos2.y - crystalyy
							playerData._csitempos2.x = math.approach(playerData._csitempos2.x, matchingCrystal.x, disx * 0.2)
							playerData._csitempos2.y = math.approach(playerData._csitempos2.y, crystalyy, disy * 0.2)
						else
							local disx = matchingCrystal.x - playerData._csitempos2.x
							local disy = crystalyy - playerData._csitempos2.y 
							playerData._csitempos2.x = math.approach(playerData._csitempos2.x, player.x, disx * 0.2)
							playerData._csitempos2.y = math.approach(playerData._csitempos2.y, playeryy, disy * 0.2)
						end
						
						--local itemx, itemy = pointInLine(player.x, playeryy, matchingCrystal.x, crystalyy, disProgress)
						local scale = thres(playerData.activatedTimer, 50, 100)
						
						graphics.drawImage{
							image = givenItem.sprite,
							x = playerData._csitempos2.x,
							y = playerData._csitempos2.y,
							scale = scale,
							alpha = 1
						}
						if playerData._csitem and isa(playerData._csitem, "Item") then
							scale = thres(timerRev, 155, 185)
							graphics.drawImage{
								image = playerData._csitem.sprite,
								x = playerData._csitempos2.x,
								y = playerData._csitempos2.y,
								scale = scale,
								alpha = thres(playerData.activatedTimer, 0, 5)
							}
						end
						
					end
				elseif isLocalPlayer then
					local allItems = getTrueItems(player)
					table.insert(allItems, exitButton)
					
					local width = 393
					local halfWidth = width * 0.5
					local xoffset = matchingCrystal.x - halfWidth
					local yoffset = matchingCrystal.y - 146
					local separation = 7
					local boxSize = 33
					--local alphaMult = 0.33
					
					local yadd = 0
					local scroll = false
					if #allItems > 60 then
						scroll = true
						yadd = -math.floor((crystalSelection - 1) / 10) * boxSize
					end
					
					graphics.color(Color.BLACK)
					graphics.alpha(0.4)
					graphics.rectangle(player.x - 1000, player.y - 1000, player.x + 1000, player.y + 1000, false)
					
					local selItem
					local selxy = {x = 0, y = 0}
					
					local wantedItem = crystalData.wantedItem
					
					for i, item in pairs(allItems) do
						local ii = (i - 1) % 10
						local row = math.floor((i - 1) / 10)
						local x = xoffset + ii * (boxSize + separation)
						local y = yoffset + row * (boxSize + separation) + yadd
						
						local alpha = 1
						
						if scroll then
							local dif = math.floor((crystalSelection - 1) / 10) + 4 - row
							if dif < 0 then
								local change = dif * 0.34
								alpha = 1 + change
							end
						end
						
						graphics.alpha(0.5)
						if i == crystalSelection then
							selItem = item.item
							graphics.color(Color.PINK)
							graphics.rectangle(x + 2, y + 2, x + boxSize - 3, y + boxSize - 3, false)
							
							selxy.x = x
							selxy.y = y
							
							playerData._csitempos = {x = x, y = y}
							
							--[[local luckVal = crystalData.itemData[item.item].chance
							local luckString = luckVal.."% luck"
							
							local cwidth = graphics.textWidth(luckString, graphics.FONT_LARGE)
							local chwidth = cwidth * 0.5
							graphics.rectangle(x + 16 - chwidth, y + 35, x + 16 + chwidth, y + 60, false)
							graphics.color(Color.WHITE)
							graphics.print(luckString, x + 16, y + 40, graphics.FONT_LARGE, graphics.ALIGN_MIDDLE)]]
						end
						
						graphics.drawImage{
							image = item.item.sprite,
							x = x + 16,
							y = y + 16,
							subimage = 1,
							--solidColor = Color.BLACK,
							alpha = alpha * (math.random(92, 100) * 0.01)
						}
						graphics.alpha(alpha * 0.3)
						if specialExchanges[item.item] then
							graphics.color(Color.fromHex(0xAC72C2))
						elseif crystalData.itemData[item.item] and crystalData.itemData[item.item].chance <= 10 then
							graphics.color(Color.RED)
						elseif wantedItem == item.item then
							graphics.color(Color.YELLOW)
							graphics.alpha(alpha * 0.6)
						else
							graphics.color(Color.WHITE)
						end
						graphics.rectangle(x, y, x + boxSize - 1, y + boxSize - 1, true)
						if wantedItem == item.item then
							graphics.rectangle(x - 3, y - 3, x + boxSize - 1 + 3, y + boxSize - 1 + 3, true)
						end
					end
					
					local wantedx = matchingCrystal.x - 255
					local wantedy = matchingCrystal.y
					local circleSize = 43 + math.sin(global.timer * 0.05) * 5
					local circlexadd = math.cos(global.timer * 0.0097) * 8
					local circleyadd = math.sin(global.timer * 0.013) * 8
					
					graphics.alpha(0.4)
					graphics.color(Color.BLACK)
					graphics.circle(wantedx + circlexadd, wantedy - 12 + circleyadd, circleSize, false)
					
					if selItem ~= exitButton.item then
						local luckString = ""
						if specialExchanges[selItem] then
							luckString = "Special"
						else
							local luckVal = crystalData.itemData[selItem].chance
							luckString = luckVal.."% Value"
						end
						
						local cwidth = graphics.textWidth(luckString, graphics.FONT_LARGE)
						local chwidth = cwidth * 0.5
						
						graphics.alpha(0.5)
						graphics.color(Color.BLACK)
						graphics.rectangle(selxy.x + 16 - 2 - chwidth, selxy.y + 35, selxy.x + 16 + 2 + chwidth, selxy.y + 57, false)
						graphics.color(Color.PINK)
						graphics.rectangle(selxy.x + 16 - 2 - chwidth, selxy.y + 35, selxy.x + 16 + 2 + chwidth, selxy.y + 57, false)
						graphics.alpha(0.7)
						if specialExchanges[selItem] then
							graphics.color(Color.fromHex(0xE7ADFF))
						elseif crystalData.itemData[selItem] and crystalData.itemData[selItem].chance <= 10 then
							graphics.color(Color.RED)
						elseif wantedItem == selItem then
							graphics.color(Color.YELLOW)
							--graphics.print(luckString, selxy.x + 16 + 2, selxy.y + 40 + 1, graphics.FONT_LARGE, graphics.ALIGN_MIDDLE)
						else
							graphics.color(Color.WHITE)
						end
						graphics.print(luckString, selxy.x + 16 + 2, selxy.y + 40, graphics.FONT_LARGE, graphics.ALIGN_MIDDLE)
					end
					
					graphics.alpha(0.7)
					graphics.color(Color.YELLOW)
					graphics.rectangle(wantedx - 17, wantedy - 17, wantedx + 17, wantedy + 17, true)
					graphics.alpha(0.3)
					graphics.rectangle(wantedx - 17 + 2, wantedy - 17 + 2, wantedx + 17 - 2, wantedy + 17 - 2, false)
					graphics.alpha(0.8)
					graphics.print("Wanted", wantedx, wantedy - 42, graphics.FONT_LARGE, graphics.ALIGN_MIDDLE)
					graphics.drawImage{
						image = wantedItem.sprite,
						x = wantedx,
						y = wantedy,
						subimage = 1,
						--solidColor = Color.BLACK,
						alpha = (math.random(92, 100) * 0.01)
					}
				end
			end
		end
	end
end)

local keyboardDirs = {
	left = -1,
	right = 1,
	up = -10,
	down = 10
}
local dpadDirs = {
	padl = -1,
	padr = 1,
	padu = -10,
	padd = 10
}

table.insert(call.onPlayerStep, function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if playerAc.activity == intActivity then
		local matchingCrystal = obj.Crystal:findNearest(player.x, player.y)
		if matchingCrystal and matchingCrystal:isValid() then
			local crystalData = matchingCrystal:getData()
			
			playerAc.turbinecharge = 0
			
			local items = getTrueItems(player)
			table.insert(items, exitButton)
			
			local activation = false
			
			if not net.online or player == net.localPlayer then
				if selectionCd > 0 then
					selectionCd = selectionCd - 1
				elseif not crystalData.ignoreFrame and not playerData.activatedTimer then
					local gamepad = input.getPlayerGamepad(player)
					
					if gamepad then
						activation = player:control("enter") == input.PRESSED
						if not activation then
							for dir, add in pairs(dpadDirs) do
								local key = input.checkGamepad(dir, gamepad)
								if key == input.PRESSED or key == input.HELD then
									--crystalSelection = math.clamp(crystalSelection + add, 1, #items)
									if crystalSelection + add <= #items and crystalSelection + add > 0 then
										crystalSelection = crystalSelection + add
										selectionCd = 10
									end
								end
							end
							local add = 0
							local lh = input.getGamepadAxis("lh", gamepad)
							if lh < -0.5 then
								add = -1
							elseif lh > 0.5 then
								add = 1
							end
							local lv = input.getGamepadAxis("lv", gamepad)
							if lv < -0.5 then
								add = add - 10
							elseif lv > 0.5 then
								add = add + 10
							end
							if add ~= 0 and crystalSelection + add <= #items and crystalSelection + add > 0 then
								crystalSelection = crystalSelection + add
								selectionCd = 10
							end
						end
					else
						activation = player:control("enter") == input.PRESSED
						if not activation then
							for dir, add in pairs(keyboardDirs) do
								local key = player:control(dir)
								if key == input.PRESSED or key == input.HELD then
									--crystalSelection = math.clamp(crystalSelection + add, 1, #items)
									if crystalSelection + add <= #items and crystalSelection + add > 0 then
										crystalSelection = crystalSelection + add
										selectionCd = 10
									end
								end
							end
						end
					end
				end
			end
			
			if activation then
				local selectedItem = items[crystalSelection].item
				
				local item1, item2 = "no_item", "no_item"
				if selectedItem == exitButton.item then
					playerAc.activity = 0
					playerAc.activity_type = 0
					crystalData.ignoreFrame = 2
				else
					player:removeItem(selectedItem, 1)
					playerData.activatedTimer = 200
					playerData.givingCrystalItem = selectedItem
					playerData._csitempos2 = {x = player.x, y = player.y - 35}
					
					local tradeCall = onStrangerTradeCallback(selectedItem, player)
					
					if specialExchanges[selectedItem] then
						crystalData.options = specialExchanges[selectedItem]
						crystalData.optionChoice = table.irandom(crystalData.options)
						
						playerData._csitem = crystalData.optionChoice
						item1 = selectedItem
						item2 = crystalData.optionChoice
					else
						local luck = crystalData.itemData[selectedItem].chance
					
						crystalData.options = generateRollOptions(luck, crystalData.wantedItem, selectedItem)
						crystalData.optionChoice = table.irandom(crystalData.options)
						if crystalData.optionChoice == SERAPH_ROLL then
							runData.rolledSeraphPiece = true
							global.seraphCount = global.seraphCount + 1
							save.write("seraphCount", global.seraphCount)
							if global.seraphCount >= 6 then
								acSeraph:increment(1)
							end
							--sfx.Frozen:play(0.6, 0.8)
						elseif crystalData.optionChoice == SWORD_ROLL then
							runData.rolledSword = true
							playerData._csitem = crystalData.optionChoice
							item1 = selectedItem
							item2 = crystalData.optionChoice
							--sfx.Frozen:play(0.6, 0.8)
						elseif crystalData.optionChoice == ARTIFACT_ROLL then
							if net.host then
								artifactRollArtifact:getObject():create(player.x, player.y)
							end
						elseif crystalData.optionChoice == NOTHING then
							playerData._csitem = crystalData.optionChoice
							item1 = selectedItem
							item2 = crystalData.optionChoice
						else
							playerData._csitem = crystalData.optionChoice
							item1 = selectedItem
							item2 = crystalData.optionChoice
						end
						crystalData.itemData[selectedItem].chance = math.max(crystalData.itemData[selectedItem].chance - 5, 1)
					end
				end
				if net.online then
					if net.host then
						syncData:sendAsHost(net.ALL, nil, player:getNetIdentity(), item1, item2)
						if item2 == SWORD_ROLL then
							syncSwordRolled:sendAsHost(net.ALL, nil)
						end
					else
						syncData:sendAsClient(player:getNetIdentity(), item1, item2)
						if item2 == SWORD_ROLL then
							syncSwordRolled:sendAsClient()
						elseif crystalData.optionChoice == ARTIFACT_ROLL then
							hostSyncArtifactRolled:sendAsClient(player.x, player.y)
						end
					end
				end
				crystalSelection = 1
			end
			
		else
			playerAc.activity = 0
			playerAc.activity_type = 0
		end
	end
	if playerData.activatedTimer then
		if playerData.activatedTimer > 0 then
			playerData.activatedTimer = playerData.activatedTimer - 1
		else
			playerAc.activity = 0
			playerAc.activity_type = 0
			if playerData._csitem and playerData._csitem ~= NOTHING then
				player:giveItem(playerData._csitem, 1)
				--if not giveItemCurseCheck(playerData._csitem, player) then
				player:set("item_count_total", player:get("item_count_total") + 1)
					if not net.online or player == net.localPlayer then
						sfx.Pickup:play()
					end
				--end
				--if net.host then
					--playerData._csitem:create(player.x, player.y - 10)
				--	spawnItem:sendAsHost(net.ALL, nil, player:getNetIdentity(), playerData._csitem)
				--else
				--	spawnItem:sendAsClient(player:getNetIdentity(), playerData._csitem)
				--end
			end
			playerData.activatedTimer = nil
		end
	end
end)

callback.register("onDamage", function(target, damage, source)
	if target:getObject() == obj.Crystal then-- and source and source:get("team") and source:get("team") == target:get("team") then
		return true
	end
end)

return obj.Crystal