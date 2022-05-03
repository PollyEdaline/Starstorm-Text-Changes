local survivorIds = {sur.Commando, sur.Enforcer, sur.Bandit, sur.Huntress, sur.HAND, sur.Engineer, sur.Miner, sur.Sniper, sur.Acrid, sur.Mercenary, sur.Loader, sur.CHEF}

function survivorFromId(id)
	return survivorIds[id]
end
function survivorList()
	return survivorIds
end

local survivors = {}
local survivorAchievements = {}

callback.register("postLoad", function()
	--local eS = #Survivor.findAll("Vanilla") + #Survivor.findAll("Starstorm")
	
	survivors = Survivor.findAll()
	
	--local doAll = true
	
	--if #survivors > eS then
	--	doAll = false
	--end
	
	local namespaces = modloader.getMods()
	for _, namespace in ipairs(namespaces) do
		if namespace == "Starstorm" then
			table.insert(survivorIds, sur.Executioner)
			table.insert(survivorIds, sur.MULE)
			table.insert(survivorIds, sur.Cyborg)
			table.insert(survivorIds, sur.Technician)
			table.insert(survivorIds, sur.Nucleator)
			table.insert(survivorIds, sur.Baroness)
			table.insert(survivorIds, sur.Chirr)
			table.insert(survivorIds, sur.Pyro)
			table.insert(survivorIds, sur.DUT)
			table.insert(survivorIds, sur.Knight)
			table.insert(survivorIds, sur.Seraph)
		else
			for _, sur in ipairs(Survivor.findAll(namespace)) do
				table.insert(survivorIds, sur)
			end
		end
	end
	
	local acs = Achievement.findAll()
	
	for _, survivor in ipairs(survivors) do
		for _, achievement in ipairs(acs) do
			if achievement.sprite == survivor.idleSprite or achievement.sprite == survivor.titleSprite then
				survivorAchievements[survivor] = achievement
				break
			end
		end
	end
end)

local hovered, mx, my = nil, 0, 0

callback.register("globalStep", function(room)
	if room == rm.Select then
		local oSelect = obj.Select:find(1)
		
		if oSelect and oSelect:isValid() then
			
			hovered = nil
			
			local ac = oSelect:getAccessor()
			
			mx, my = input.getMousePos(true)
			
			local choice = ac.temp_choice + 1
			
			if survivorIds[choice] then
				local achievement = survivorAchievements[survivorIds[choice]]
				if achievement and not achievement:isComplete() then
					hovered = survivorAchievements[survivorIds[choice]]
				end
			end
		end
	end
end)

local function drawTips()
	local w, h = graphics.getGameResolution()
	
	if hovered then
		local txt = "&r&-LOCKED-&!&\n"..hovered.description
		local off = 2
		local off2 = 4
		local off3 = 6
		local twidth = graphics.textWidth(txt, graphics.FONT_DEFAULT)
		local theight = graphics.textHeight(txt, graphics.FONT_DEFAULT)
		local xx = math.min(mx - twidth, w - twidth - 6)
		local yy = my - theight
		graphics.color(Color.BLACK)
		graphics.alpha(0.85)
		graphics.rectangle(xx - off, yy - off, xx + twidth + off2, yy + theight + off2, false)
		graphics.rectangle(xx - off2, yy - off2, xx + twidth + off3, yy + theight + off3, true)
		graphics.color(Color.WHITE)
		graphics.alpha(1)
		graphics.printColor(txt, xx + off2, yy + off2 - 1, graphics.FONT_DEFAULT)
	end
end

callback.register("globalRoomStart", function(room)
	if room == rm.Select then
		graphics.bindDepth(-9999, drawTips)
	end
end)