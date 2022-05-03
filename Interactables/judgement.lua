-- ItemPicker

local sprItemPicker = Sprite.load("ItemPicker", "Interactables/Resources/judgement", 2, 46, 39)

obj.ItemPicker = Object.base("MapObject", "ItemPicker")
obj.ItemPicker.sprite = sprItemPicker
obj.ItemPicker.depth = -6


local intActivity = 24

local ItemPickerSelection = 1
local selectionCd = 0

local sprExit = Sprite.find("CancelCrate")

local exitButton = {item = {sprite = sprExit}}

local syncItem = net.Packet.new("SSJItem", function(sender, x, y, item, count)
	local picker = obj.ItemPicker:findNearest(x, y)
	if picker then
		table.insert(picker:getData().itemOptions, {item = item, count = count})
	end
end)


local syncData
syncData = net.Packet.new("SSJPickerData", function(sender, player, item, count)
	if net.host then
		syncData:sendAsHost(net.EXCLUDE, sender, player, item, count)
	end
	
	local playerI = player:resolve()
	local playerData = playerI:getData()
	local playerAc = playerI:getAccessor()
	
	if isa(item, "Item") then
		--playerI:removeItem(item, 1)
		playerData.activatedTimer2 = 200
		playerData.givingItemPickerItem = item
		playerData._jsitempos2 = {x = playerI.x, y = playerI.y - 35}
		
		if not runData.judgementItems then runData.judgementItems = {} end
		runData.judgementItems[item] = count
		
		--playerData._jsitem = optionChoice
		local picker = obj.ItemPicker:findNearest(playerI.x, playerI.y)
		if picker then
			picker:set("active", 1)
			picker.alpha = 4
		end
	else
		playerAc.activity = 0
		playerAc.activity_type = 0
	end
end)

local function thres(value, low, high)
	local result = math.clamp(value - low, 0, high - low) / (high - low)
	return result
end

obj.ItemPicker:addCallback("create", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	selfAc.active = 0
	selfAc.activator = 2
	selfAc.myplayer = -4
	
	
	selfData.itemData = {}
	
	selfData.itemOptions = {}
	
	local validItems = {}
	
	local blacklist = {
		[it.Balloon] = true,
		[it.X4Stimulant] = true,
		[it.TheOlLopper] = true,
		[it.SwiftSkateboard] = true,
		[it.LegendarySpark] = true,
		[it.RustyJetpack] = true,
		[it.Gasoline] = true,
		[it.BoxingGloves] = true,
		[it.BurningWitness] = true
	} -- these pretty much do nothing on enemies.    except skateboard... that one just makes wyverns break and hilariously have 2 heads (and no body) :)
	
	for _, item in ipairs(itp.npc:toList()) do
		if not blacklist[item] then
			if not global.itemAchievements[item] or global.itemAchievements[item]:isComplete() then
				if not runData.judgementItems or not runData.judgementItems[item] then
					table.insert(validItems, item)
				end
			end
		end
	end
	if #validItems == 0 then validItems = {it.Fork} end -- if for some reason it doesnt have items to roll, get forked to death.
	
	if net.host then
		local rarityWeights = {
			["w"] = 5,
			["g"] = 1,
			["r"] = 0.1,
			["y"] = 0.2
		}
		for i = 1, 4 do
			local itemRollIndex = math.random(1, #validItems)
			local item = validItems[itemRollIndex]
			local countCalc = rarityWeights[item.color] or 1
			table.insert(selfData.itemOptions, {item = item, count = math.min(math.ceil(countCalc * Difficulty.getScaling() * 0.7), 10 * math.max(countCalc, 0.5))})
			table.remove(validItems, itemRollIndex)
		end
	end
	
	selfAc.cost = 0
	
	selfData.syncTimer = 10
	
	for i = 0, 500 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i - 1 
			break
		end
	end
	self.spriteSpeed = 0
end)

obj.ItemPicker:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		for _, player in ipairs(obj.P:findAllRectangle(self.x - 25, self.y - 40, self.x + 25, self.y + 2)) do
			selfAc.myplayer = player.id
			if player:get("activity") == intActivity then
				break
			end
			if player:isValid() and player:control("enter") == input.PRESSED and player:get("activity") ~= intActivity and not selfData.ignoreFrame then
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
						
						_newInteractables[obj.ItemPicker].activation(self, player)
					else
						sfx.Error:play()
					end
				end
			end
		end
	elseif selfAc.active == 1 then
		if self.alpha > 0 then
			self.alpha = self.alpha - 0.03
		else
			self:destroy()
			runData.awaitingPick = nil
		end
	end
	
	if selfData.ignoreFrame then
		if selfData.ignoreFrame > 0 then
			selfData.ignoreFrame = selfData.ignoreFrame - 1
		else
			selfData.ignoreFrame = nil
		end
	end
	
	if selfData.syncTimer and net.host then
		if selfData.syncTimer > 0 then
			selfData.syncTimer = selfData.syncTimer - 1
		else
			for _, itemData in ipairs(selfData.itemOptions) do
				syncItem:sendAsHost(net.ALL, nil, self.x, self.y, itemData.item, itemData.count)
			end
			selfData.syncTimer = nil
		end
	end
end)
obj.ItemPicker:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	if selfAc.active == 0 then
		graphics.color(Color.BLACK)
		
		if obj.P:findRectangle(self.x - 25, self.y - 40, self.x + 25, self.y + 2) and selfAc.myplayer ~= -4 then
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
					text = "Press ".."'"..keyStr.."'".." to bond with the beyond"..costStr
				else
					text = "Press ".."&y&'"..keyStr.."'&!&".." to bond with the beyond"..costStr
				end
				graphics.alpha(1)
				graphics.printColor(text, self.x - 84, self.y - 57)
			end
		end
		
		for _, player in ipairs(misc.players) do
			if not net.online or player == net.localPlayer then
				local angle = posToAngle(player.x, player.y, self.x, self.y)
				local angle2 = math.rad(posToAngle(player.x, self.y, self.x, player.y))
				graphics.drawImage{
					image = spr.Arrow,
					x = player.x + math.cos(angle2) * 11,
					y = player.y + math.sin(angle2) * 11,
					angle = angle,
					subimage = 1,
					scale = 1
				}
			end
		end
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
		local playerData = player:getData()
		local matchingItemPicker = obj.ItemPicker:findNearest(player.x, player.y)
		
		if player:get("activity") == intActivity and matchingItemPicker and matchingItemPicker:isValid() then
			
			local ItemPickerData = matchingItemPicker:getData()
			
			if playerData.activatedTimer2 then
				local givenItem = playerData.givingItemPickerItem
				
				local timerRev = 200 - playerData.activatedTimer2
				
				if isLocalPlayer then
					local backAlpha = thres(playerData.activatedTimer2, 0, 10)
					graphics.color(Color.BLACK)
					graphics.alpha(0.4 * backAlpha)
					graphics.rectangle(player.x - 1000, player.y - 1000, player.x + 1000, player.y + 1000, false)
					
					graphics.alpha(0.5 * backAlpha)
					graphics.color(Color.BLACK)
					graphics.circle(player.x, player.y, (40 + math.cos(global.timer * 0.04) * 10) * thres(playerData.activatedTimer2, 80, 100), false)
					
					if not playerData._jsitempos then playerData._jsitempos = {x = player.x, y = player.y} end -- pog
					
					--local dis = distance(playerData._jsitempos.x, playerData._jsitempos.y, player.x, player.y)
					local disx = playerData._jsitempos.x - player.x
					local disy = playerData._jsitempos.y - player.y
					playerData._jsitempos.x = math.approach(playerData._jsitempos.x, player.x, disx * 0.2)
					playerData._jsitempos.y = math.approach(playerData._jsitempos.y, player.y, disy * 0.2)
					--local disProgress = dis * thres(timerRev, 0, 5)
					--local itemx, itemy = pointInLine(playerData._jsitempos.x, playerData._jsitempos.y, player.x, player.y, disProgress)
					
					graphics.drawImage{
						image = givenItem.sprite,
						x = playerData._jsitempos.x,
						y = playerData._jsitempos.y,
						scale = scale,
						alpha = thres(playerData.activatedTimer2, 80, 100)
					}
					
				else
					
					local playeryy = player.y - 35
					local ItemPickeryy = matchingItemPicker.y - 45
					
					if not playerData._jsitempos2 then playerData._jsitempos2 = {x = player.x, y = player.y - 35} end
					
					if playerData.activatedTimer2 > 100 then
						local disx = playerData._jsitempos2.x - matchingItemPicker.x
						local disy = playerData._jsitempos2.y - ItemPickeryy
						playerData._jsitempos2.x = math.approach(playerData._jsitempos2.x, matchingItemPicker.x, disx * 0.2)
						playerData._jsitempos2.y = math.approach(playerData._jsitempos2.y, ItemPickeryy, disy * 0.2)
					else
						local disx = matchingItemPicker.x - playerData._jsitempos2.x
						local disy = ItemPickeryy - playerData._jsitempos2.y 
						playerData._jsitempos2.x = math.approach(playerData._jsitempos2.x, player.x, disx * 0.2)
						playerData._jsitempos2.y = math.approach(playerData._jsitempos2.y, playeryy, disy * 0.2)
					end
					
					--local itemx, itemy = pointInLine(player.x, playeryy, matchingItemPicker.x, ItemPickeryy, disProgress)
					local scale = thres(playerData.activatedTimer2, 50, 100)
					
					graphics.drawImage{
						image = givenItem.sprite,
						x = playerData._jsitempos2.x,
						y = playerData._jsitempos2.y,
						scale = scale,
						alpha = 1
					}
					if playerData._jsitem and isa(playerData._jsitem, "Item") then
						scale = thres(timerRev, 155, 185)
						graphics.drawImage{
							image = playerData._jsitem.sprite,
							x = playerData._jsitempos2.x,
							y = playerData._jsitempos2.y,
							scale = scale,
							alpha = thres(playerData.activatedTimer2, 0, 5)
						}
					end
					
				end
			elseif isLocalPlayer then
				local allItems = ItemPickerData.itemOptions--getTrueItems(player)
				--table.insert(allItems, exitButton)
				
				local width = (393 / 10) * math.min(#allItems, 10) --393
				local halfWidth = width * 0.5
				local xoffset = matchingItemPicker.x - halfWidth
				local yoffset = matchingItemPicker.y - 146 + 15
				local separation = 7
				local boxSize = 33
				--local alphaMult = 0.33
				
				local yadd = 0
				local scroll = false
				if #allItems > 60 then
					scroll = true
					yadd = -math.floor((ItemPickerSelection - 1) / 10) * boxSize
				end
				
				graphics.color(Color.BLACK)
				graphics.alpha(0.4)
				graphics.rectangle(player.x - 1000, player.y - 1000, player.x + 1000, player.y + 1000, false)
				
				local selItem
				local selxy = {x = 0, y = 0}
				
				for i, item in pairs(allItems) do
					local ii = (i - 1) % 10
					local row = math.floor((i - 1) / 10)
					local x = xoffset + ii * (boxSize + separation)
					local y = yoffset + row * (boxSize + separation) + yadd
					
					local alpha = 1
					
					if scroll then
						local dif = math.floor((ItemPickerSelection - 1) / 10) + 4 - row
						if dif < 0 then
							local change = dif * 0.34
							alpha = 1 + change
						end
					end
					
					graphics.alpha(0.5)
					if i == ItemPickerSelection then
						selItem = item.item
						graphics.color(Color.AQUA)
						graphics.rectangle(x + 2, y + 2, x + boxSize - 3, y + boxSize - 3, false)
						
						selxy.x = x
						selxy.y = y
						
						playerData._jsitempos = {x = x, y = y}
						
						--[[local luckVal = ItemPickerData.itemData[item.item].chance
						local tooltipString = luckVal.."% luck"
						
						local cwidth = graphics.textWidth(tooltipString, graphics.FONT_LARGE)
						local chwidth = cwidth * 0.5
						graphics.rectangle(x + 16 - chwidth, y + 35, x + 16 + chwidth, y + 60, false)
						graphics.color(Color.WHITE)
						graphics.print(tooltipString, x + 16, y + 40, graphics.FONT_LARGE, graphics.ALIGN_MIDDLE)]]
					end
					
					graphics.drawImage{
						image = item.item.sprite,
						x = x + 16,
						y = y + 16,
						subimage = 1,
						--solidColor = Color.BLACK,
						alpha = alpha * (math.random(92, 100) * 0.01)
					}
					if item.count then
						graphics.alpha(1)
						graphics.color(Color.WHITE)
						graphics.print("x"..item.count, x + 16, y + 19, nil, graphics.ALIGN_MIDDLE)
					end
					graphics.alpha(alpha * 0.3)
					if false then --specialExchanges[item.item] then
						graphics.color(Color.fromHex(0xAC72C2))
					else
						graphics.color(Color.WHITE)
					end
					graphics.rectangle(x, y, x + boxSize - 1, y + boxSize - 1, true)
				end
				
				if selItem ~= exitButton.item then
					local tooltipString = string.gsub(string.gsub(string.gsub(string.gsub(string.gsub(selItem.pickupText, "your", "their"), "you", "them"), "Your", "Their"), "enemy", "player"), "enemies", "players") -- hilarious
					
					local cwidth = graphics.textWidth(tooltipString, graphics.FONT_DEFAULT)
					local chwidth = cwidth * 0.5
					
					graphics.alpha(0.5)
					graphics.color(Color.BLACK)
					graphics.rectangle(selxy.x + 16 - 2 - chwidth, selxy.y + 34, selxy.x + 16 + 2 + chwidth, selxy.y + 50, false)
					graphics.color(Color.AQUA)
					graphics.rectangle(selxy.x + 16 - 2 - chwidth, selxy.y + 34, selxy.x + 16 + 2 + chwidth, selxy.y + 50, false)
					graphics.alpha(0.7)
					if false then
						
					else
						graphics.color(Color.WHITE)
					end
					graphics.print(tooltipString, selxy.x + 16 + 2, selxy.y + 38, nil, graphics.ALIGN_MIDDLE)
					graphics.color(Color.AQUA)
					graphics.print("THE ENEMY EVOLVES...", matchingItemPicker.x, yoffset - 20, graphics.FONT_LARGE, graphics.ALIGN_MIDDLE)
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
		local matchingItemPicker = obj.ItemPicker:findNearest(player.x, player.y)
		if matchingItemPicker and matchingItemPicker:isValid() then
			local ItemPickerData = matchingItemPicker:getData()
			
			playerAc.turbinecharge = 0
			
			local items = ItemPickerData.itemOptions --getTrueItems(player)
			--table.insert(items, exitButton)
			
			local activation = false
			
			if not net.online or player == net.localPlayer then
				if selectionCd > 0 then
					selectionCd = selectionCd - 1
				elseif not ItemPickerData.ignoreFrame and not playerData.activatedTimer2 then
					local gamepad = input.getPlayerGamepad(player)
					
					if gamepad then
						activation = player:control("enter") == input.PRESSED
						if not activation then
							for dir, add in pairs(dpadDirs) do
								local key = input.checkGamepad(dir, gamepad)
								if key == input.PRESSED or key == input.HELD then
									--ItemPickerSelection = math.clamp(ItemPickerSelection + add, 1, #items)
									if ItemPickerSelection + add <= #items and ItemPickerSelection + add > 0 then
										ItemPickerSelection = ItemPickerSelection + add
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
							if add ~= 0 and ItemPickerSelection + add <= #items and ItemPickerSelection + add > 0 then
								ItemPickerSelection = ItemPickerSelection + add
								selectionCd = 10
							end
						end
					else
						activation = player:control("enter") == input.PRESSED
						if not activation then
							for dir, add in pairs(keyboardDirs) do
								local key = player:control(dir)
								if key == input.PRESSED or key == input.HELD then
									--ItemPickerSelection = math.clamp(ItemPickerSelection + add, 1, #items)
									if ItemPickerSelection + add <= #items and ItemPickerSelection + add > 0 then
										ItemPickerSelection = ItemPickerSelection + add
										selectionCd = 10
									end
								end
							end
						end
					end
				end
			end
			
			if activation then
				local selectedItem = items[ItemPickerSelection].item
				
				local item = "no_item"
				local count = nil
				if selectedItem == exitButton.item then
					playerAc.activity = 0
					playerAc.activity_type = 0
					ItemPickerData.ignoreFrame = 2
				else
					--playerAc.activity = 0
					--playerAc.activity_type = 0
					--ItemPickerData.ignoreFrame = 2
					
					count = items[ItemPickerSelection].count
					item = selectedItem
					
					if not runData.judgementItems then runData.judgementItems = {} end
					runData.judgementItems[item] = count
					
					--player:removeItem(selectedItem, 1)
					playerData.activatedTimer2 = 200
					playerData.givingItemPickerItem = selectedItem
					playerData._jsitempos2 = {x = player.x, y = player.y - 35}
					
					ItemPickerData.takenItem = selectedItem
					
					matchingItemPicker:set("active", 1)
					matchingItemPicker.alpha = 4
				end
				if net.online then
					if net.host then
						syncData:sendAsHost(net.ALL, nil, player:getNetIdentity(), item, count)
					else
						syncData:sendAsClient(player:getNetIdentity(), item, count)
					end
				end
				ItemPickerSelection = 1
			end
			
		else
			playerAc.activity = 0
			playerAc.activity_type = 0
		end
	end
	if playerData.activatedTimer2 then
		if playerData.activatedTimer2 > 0 then
			playerData.activatedTimer2 = playerData.activatedTimer2 - 2
		else
			playerAc.activity = 0
			playerAc.activity_type = 0
			if playerData._jsitem then
				player:giveItem(playerData._jsitem, 1)
				--if not giveItemCurseCheck(playerData._jsitem, player) then
				player:set("item_count_total", player:get("item_count_total") + 1)
					if not net.online or player == net.localPlayer then
						sfx.Pickup:play()
					end
				--end
				--if net.host then
					--playerData._jsitem:create(player.x, player.y - 10)
				--	spawnItem:sendAsHost(net.ALL, nil, player:getNetIdentity(), playerData._jsitem)
				--else
				--	spawnItem:sendAsClient(player:getNetIdentity(), playerData._jsitem)
				--end
			end
			playerData.activatedTimer2 = nil
		end
	end
end)

return obj.ItemPicker