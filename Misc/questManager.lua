
-- All quest and objective data

local quests = {}
local sprObjectives = Sprite.load("Objectives", "Gameplay/HUD/objectives", 1, 79, 0)
local sprObjectivebk = Sprite.load("ObjectivesBack", "Gameplay/HUD/objectivesList", 1, 7, 7)

export("Quest")
function Quest.set(name)
	for q, quest in pairs(quests) do
		print(quest.name, name)
		if quest.name == name then
			return q
		end
	end
	table.insert(quests, {name = name, objectives = {}})
	return table.maxn(quests)
end

function Quest.getActive()
	return quests
end

function Quest.setObjective(questname, objectivetxt, progress, requirement, isfinished, additionalData)
	for q, quest in pairs(quests) do
		local compar = nil
		if isa(questname, "string") then
			compar = quest.name
		else
			compar = q
		end
		local noresult = nil
		if compar == questname then
			for o, objective in pairs(quest.objectives) do
				if isa(objectivetxt, "string") then
					if objective.title == objectivetxt then
						objective.title = objectivetxt
						if isfinished ~= nil then
							objective.finished = isfinished
						end
						if progress ~= nil then
							objective.progress = progress
						end
						if requirement ~= nil then
							objective.requirement = requirement
						end
						if additionalData ~= nil then
							objective.additionalData = additionalData
						end
						return o
					end
				else
					if o == objectivetxt then
						if isfinished ~= nil then
							objective.finished = isfinished
						end
						if progress ~= nil then
							objective.progress = progress
						end
						if requirement ~= nil then
							objective.requirement = requirement
						end
						if additionalData ~= nil then
							objective.additionalData = additionalData
						end
						return objective.title
					else
						noresult = 1
					end
				end
			end
			if noresult then
				return nil
			end
			table.insert(quest.objectives, {title = objectivetxt})
			if isfinished ~= nil then
				quest.objectives[table.maxn(quest.objectives)].finished = isfinished
			else
				quest.objectives[table.maxn(quest.objectives)].finished = false
			end
			if progress ~= nil then
				quest.objectives[table.maxn(quest.objectives)].progress = progress
			end
			if requirement ~= nil then
				quest.objectives[table.maxn(quest.objectives)].requirement = requirement
			end
			if additionalData ~= nil then
				quest.objectives[table.maxn(quest.objectives)].additionalData = additionalData
			end
			return table.maxn(quest.objectives)
		end
	end
end

callback.register("onGameStart", function()
	quests = {{}}
end)

table.insert(call.onStageEntry, function()
	quests[1] = {name = "Escape the planet", objectives = {}}
	for _, quest in pairs(quests) do
		if quest.objectives then
			for o, objective in pairs(quest.objectives) do
				if objective.finished == true then
					table.remove(quest.objectives, o)
				end
			end
		end
	end
end)

table.insert(call.onStep, function()
	for _, quest in pairs(quests) do
		local finished = 0
		for i, objective in pairs(quest.objectives) do
			if objective.finished == true then
				finished = finished + 1
			end
		end
		if finished == table.maxn(quest.objectives) and table.maxn(quest.objectives) > 0 then
			quest.finished = true
			if quest.fx == nil then
				quest.fx = 5
			end
		end
	end
end)

table.insert(call.preHUDDraw, function()
	local hudObjective = misc.hud:get("objective_text")
	if hudObjective == "Go to the teleporter to advance to the next level!" then
		hudObjective = "Advance to the next level!"
	elseif hudObjective == "Kill remaining enemies" then
		hudObjective = "Kill the remaining enemies."
	elseif string.match(hudObjective, " seconds") then
		local newString = (string.gsub(hudObjective, " seconds", ""))
		local slashPos = string.find(newString, "/")
		local number1 = string.sub(newString, 0, slashPos - 1)
		local number2 = string.sub(newString, slashPos + 1)
		Quest.setObjective(1, "Find the Teleporter.", nil, nil, true)
		Quest.setObjective(1, "Stay alive!", number1, number2)
		hudObjective = ""
	elseif string.match(hudObjective, "Remaining enemies: ") then
		local colonPos = string.find(hudObjective, ":")
		local number = string.sub(hudObjective, colonPos + 2)
		Quest.setObjective(1, "Stay alive!", nil, nil, true)
		Quest.setObjective(1, "Kill the remaining enemies:", number)
		hudObjective = ""
	end
	if hudObjective ~= "" then
		local add = true
		if quests[1] then
			for i, objective in pairs(quests[1].objectives) do
				if objective.title == hudObjective then
					add = false
				end
			end
			if add then
				for i, objective in pairs(quests[1].objectives) do
					objective.finished = true
				end
				table.insert(quests[1].objectives, {title = hudObjective, finished = false})
			end
		end
	end
	misc.hud:set("objective_text", "")
end)

table.insert(call.onHUDDraw, function()
	if misc.hud:get("show_time") == 1 then
		local width, height = graphics.getHUDResolution()
		graphics.drawImage{
		image = sprObjectives,
		x = width + 1,
		y = 150}
		graphics.color(Color.fromRGB(192, 192, 192))
		
		local yy = 151
		local xx = 23
		
		for q, quest in pairs(quests) do
			local yoffsetAdd = 0
			for i, qquest in pairs(quests) do
				if i < q then
					yoffsetAdd = yoffsetAdd + (10 * table.maxn(quests[i].objectives))
				end
			end
			local yoffset = yoffsetAdd + (q * 13)

			xx = 13
			
			if quest.finished then
				quest.fx = quest.fx - 0.05
				graphics.alpha(quest.fx)
				xx = xx + (math.min(quest.fx, 1) * 2)
			else
				graphics.alpha(1)
			end
			
			local strLen =  graphics.textWidth(quest.name, graphics.FONT_DEFAULT)

			-- Quest Title Circle 
			graphics.color(Color.fromRGB(51, 43, 60))
			graphics.circle(width - xx - strLen - 5, yy + yoffset - 0.5 - 1, 1.5, false)--+ 3, yy + yoffset - 0.5, 1.5, false)
			-- Quest Title Shadow
			graphics.print(quest.name, width - xx + 1 + 2, yy + 1 + yoffset, graphics.FONT_DEFAULT, graphics.ALIGN_RIGHT ,graphics.ALIGN_CENTER)
			-- Quest Title
			if quest.finished then
				graphics.color(Color.fromRGB(122, 122, 122))
			else
				graphics.color(Color.fromRGB(192, 192, 192))
			end
			graphics.circle(width - xx - strLen - 6, yy + yoffset - 1.5 - 1, 1.5, false)
			graphics.print(quest.name, width - xx + 2, yy + yoffset, graphics.FONT_DEFAULT, graphics.ALIGN_RIGHT ,graphics.ALIGN_CENTER)

			for i, objective in pairs(quest.objectives) do
				local yyy = (i * 8) + yoffset
				
				local title = objective.title
				if objective.progress ~= nil and objective.requirement ~= nil then
					title = objective.title.." ("..objective.progress.."/"..objective.requirement..")"
				elseif objective.progress ~= nil and objective.requirement == nil then
					title = objective.title.." ("..objective.progress..")"
				end
				
				--graphics.drawImage{
				--image = sprObjectivebk,
				--x = width - xx - graphics.textWidth(objective.title, graphics.FONT_DEFAULT),
				--y = yy + yyy}
				--graphics.color(Color.fromRGB(51, 43, 60))
				--graphics.rectangle(width - xx - graphics.textWidth(objective.title, graphics.FONT_DEFAULT), yy + yyy - 7, width - xx, yy + yyy + 7, false)
				
				if objective.finished == false then
					graphics.color(Color.fromRGB(51, 43, 60))
					graphics.print(title, width - xx + 1, yy + yyy + 2, graphics.FONT_SMALL, graphics.ALIGN_RIGHT ,graphics.ALIGN_CENTER)
					graphics.color(Color.fromHex(0xEFD27B))
					graphics.print(title, width - xx, yy + yyy + 1, graphics.FONT_SMALL, graphics.ALIGN_RIGHT ,graphics.ALIGN_CENTER)
				else
					graphics.color(Color.fromRGB(51, 43, 60))
					graphics.line(width - xx - 1 - graphics.textWidth(objective.title, graphics.FONT_SMALL), yy + 0.5 + yyy + 1, width - xx, yy + 0.5 + yyy + 1, 1)
					graphics.print(objective.title, width - xx + 1, yy + yyy + 2, graphics.FONT_SMALL, graphics.ALIGN_RIGHT ,graphics.ALIGN_CENTER)
					
					graphics.color(Color.fromRGB(122, 122, 122))
					graphics.print(objective.title, width - xx, yy + yyy + 1, graphics.FONT_SMALL, graphics.ALIGN_RIGHT ,graphics.ALIGN_CENTER)
					graphics.color(Color.fromRGB(122, 122, 122))
					graphics.line(width - xx - 1 - graphics.textWidth(objective.title, graphics.FONT_SMALL), yy + 0.5 + yyy, width - xx, yy + 0.5 + yyy, 1)
				end
			end
			if quest.finished and quest.fx <= 0 then
				table.remove(quests, q)
			end 
		end
	end
end)