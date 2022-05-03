-- ACHIEVEMENT MANAGER
local achievementQueue = {}
local currentAchievement = nil
local timer = 0
local maxTimer = 5 * 60

local artifactUnlocks = {}
callback.register("postLoad", function()
	for _, namespace in ipairs(namespaces) do
		for _, artifact in ipairs(Artifact.findAll(namespace)) do
			artifactUnlocks[artifact] = artifact.unlocked
		end
	end
end)
callback.register("onGameStart", function()
	achievementQueue = {}
	currentAchievement = nil
	timer = 0
end)

--[[callback.register("postLoad", function()
	for _, achievement in ipairs(Achievement.findAll()) do
		achievement:addCallback("onComplete", function()
			table.insert(achievementQueue, {text = achievement.description, image = achievement.sprite})
		end)
	end
end)]]

if not global.rormlflag.ss_disable_reskin then
	table.insert(call.postStep, function()
		for _, achievement in ipairs(obj.Achievement:findAll()) do
			if not achievement:getData().checked then
				achievement.visible = false
				table.insert(achievementQueue, {text = achievement:get("text1"), image = achievement.sprite})
				achievement:getData().checked = true
			end
		end
		for _, artifact in ipairs(pobj.artifacts:findAll()) do
			if artifact:get("used") == 1 then
				if not artifact:getData().checked then
					artifact.visible = false
					local aartifact = Artifact.fromObject(artifact:getObject())
					if not artifactUnlocks[aartifact] then
						artifactUnlocks[aartifact] = true
						table.insert(achievementQueue, {text = aartifact.pickupName, title = "ARTIFACT UNLOCKED!", image = aartifact.pickupSprite})
						artifact:getData().checked = true
					end
				end
			end
		end
		for _, logbook in ipairs(obj.BookDrop:findAll()) do
			if logbook:get("used") == 1 and not logbook:getData().checked then
				logbook.visible = false
				sfx.Achievement:play()
				
				local name = ""
				local sprite = spr.Nothing
				
				for _, mlog in ipairs(MonsterLog.findAll()) do
					if mlog.id == logbook:get("unlock_id") then
						name = mlog.displayName
						sprite = mlog.sprite
						break
					end
				end
				
				if sprite == spr.GolemSpawn then sprite = spr.GolemIdle
				elseif sprite == spr.GuardSpawn then sprite = spr.GuardIdle
				elseif sprite == spr.SpiderShoot1 then sprite = spr.SpiderIdle
				elseif sprite == spr.WispBIdleBook then sprite = spr.WispBIdle
				elseif sprite == spr.GatekeeperSpawn then sprite = spr.GatekeeperIdle
				end
				
				table.insert(achievementQueue, {text = "MonsterLog: "..name, title = "INFORMATION UNLOCKED!", image = sprite})
				logbook:getData().checked = true
			end
		end
		if #achievementQueue > 0 then
			if currentAchievement == nil then
				currentAchievement = achievementQueue[1]
				timer = maxTimer
			end
			if timer <= 0 then
				currentAchievement = nil
				table.remove(achievementQueue, 1)
				--[[for i, achievement in pairs(achievementQueue) do
					achievementQueue[i - 1] = achievement
				end]]
			else
				timer = timer - 1
			end
		end
	end)

	table.insert(call.onHUDDraw, function()
		if #achievementQueue > 0 and timer > 0 then
			local w, h = graphics.getHUDResolution()
			
			local achievement = currentAchievement
			
			local yOffset = (math.sin(math.min((maxTimer - timer) / 5, 1.14) * math.min(timer / 100, 1.14)) * 15) - 15
			
			local title = achievement.title or "UNLOCKED!"
			
			t1width = graphics.textWidth(title, 1)
			t2width = graphics.textWidth(achievement.text, 1)
			
			local width = 40 + math.max(t1width, t2width)
			
			local ww = w / 2
			
			local yBorder = 82
			local xBorder = ww - (width / 2) --150
			
			graphics.color(Color.fromHex(0x332B3C))
			local alpha = (math.min((maxTimer - timer) / 5, 1) * math.min(timer / 100, 1))
			graphics.alpha(alpha)
			graphics.rectangle(xBorder, h - 112 + yOffset, w - xBorder, h - yBorder + yOffset, false)
			graphics.color(Color.fromHex(0x1A1A1A))
			graphics.alpha(alpha * 0.32)
			graphics.rectangle(xBorder - 1, h - 112 + yOffset - 1, w - xBorder + 1, h - yBorder + yOffset + 1, true)
			graphics.rectangle(xBorder - 2, h - 112 + yOffset - 2, w - xBorder + 2, h - yBorder + yOffset + 2, true)
			graphics.rectangle(xBorder - 3, h - 112 + yOffset - 3, w - xBorder + 3, h - yBorder + yOffset + 3, true)
			
			graphics.drawImage{
				achievement.image,
				x = xBorder + 17,
				y = h - 112 + 15 + yOffset,
				subImage = 1,
				alpha = alpha
			}
			graphics.color(Color.GRAY)
			graphics.alpha(alpha)
			
			if achievement.text ~= "" then
				graphics.print(title, xBorder + 40 + 1, h - 112 + 17 - 7 + 1 + yOffset, 1, graphics.ALIGN_LEFT, graphics.ALIGN_CENTER)
			end
			graphics.color(Color.WHITE)
			graphics.print(title, xBorder + 40, h - 112 + 17 - 7 + yOffset, 1, graphics.ALIGN_LEFT, graphics.ALIGN_CENTER)
			graphics.print(achievement.text, xBorder + 40, h - 112 + 17 + 7 + yOffset, 1, graphics.ALIGN_LEFT, graphics.ALIGN_CENTER)
			
			local alpha = 1 - (math.min((maxTimer - timer) / 10, 1))
			graphics.alpha(alpha)
			graphics.rectangle(xBorder, h - 112 + yOffset, w - xBorder, h - yBorder + yOffset)
		end
	end)
end


local _toUnlock = {}

-- Hidden achievements

local function createAchievement(name, sprite, unlockText, description, highscoreText, unlockable, dontUnlock)
	if not Achievement.find(name, "Starstorm") then
		--print(name, sprite, unlockText, highscoreText, unlockable.displayName, dontUnlock)
		local real_ac = Achievement.new(name)
		if unlockable._internalid then
			SurvivorVariant.setRequirement(unlockable, real_ac)
			--unlockable.hidden = true
			unlockable.hidden = false
		else
			real_ac:assignUnlockable(unlockable)
		end
		if sprite then
			real_ac.sprite = sprite
		end
		if unlockText then
			real_ac.unlockText = unlockText
		end
		if description then
			real_ac.description = description
		end
		if highscoreText then
			real_ac.highscoreText = highscoreText
		end
		if not dontUnlock then
			real_ac:increment(1)
			--table.insert(_toUnlock, real_ac)
			unlockable.hidden = false
		end
	elseif not dontUnlock then
		Achievement.find(name, "Starstorm"):increment(1)
	end
end

--[[callback.register("globalStep", function()
	for i, ac in ipairs(_toUnlock) do
		ac:increment(1)
		table.remove(_toUnlock, i)
		if ac.unlockable and ac.unlockable.hidden then
			ac.unlockable.hidden = false
		end
	end
end)]]

HiddenAchievement = {}
local hiddenAchievements = {}

HiddenAchievement.new = function(name, unlockable)
	local ach = {name = name, sprite = nil, unlockText = nil, deathReset = nil, description = nil, highscoreText = nil, progress = 0, requirement = 1, unlockable = unlockable, isComplete = function(ac) return ac.progress >= ac.requirement end}
	
	if unlockable._internalid then
		unlockable.hidden = true
	end
	
	local save = save.read("ac_"..name)
	if save then
		ach.progress = save
	end
	
	table.insert(hiddenAchievements, ach)
	return hiddenAchievements[#hiddenAchievements]
end

HiddenAchievement.increment = function(ach, value)
	ach.progress = (ach.progress or 0) + value
	save.write("ac_"..ach.name, ach.progress)
	if ach.progress >= ach.requirement then
		createAchievement(ach.name, ach.sprite, ach.unlockText, ach.description, ach.highscoreText, ach.unlockable)
	end
end

HiddenAchievement.isComplete = function(ach)
	if (ach.progress or 0) >= ach.requirement then
		return true
	end
end

callback.register("postLoad", function()
	--if global.lastVersion and global.lastVersion < 1100 then
	if not save.read("_updated") then
		save.write("_updated", true)
		print("Starstorm: Updating Skin Unlocks")
		for _, ach in ipairs(hiddenAchievements) do
			createAchievement(ach.name, ach.sprite, ach.unlockText, ach.description, ach.highscoreText, ach.unlockable, true)
			
			if Achievement.find(ach.name, "Starstorm") and Achievement.find(ach.name, "Starstorm"):isComplete() then
				save.write("ac_"..ach.name, ach.requirement)
				if ach.unlockable.hidden then
					ach.unlockable.hidden = false
				end
			elseif ach.unlockable and ach.unlockable._internalid then
				ach.unlockable.hidden = true
			end
		end
	end
	
	for _, ach in ipairs(hiddenAchievements) do
		--print( ach.progress, ach.requirement)
		if ach.progress >= ach.requirement then
			createAchievement(ach.name, ach.sprite, ach.unlockText, ach.description, ach.highscoreText, ach.unlockable)
		end
	end
end)