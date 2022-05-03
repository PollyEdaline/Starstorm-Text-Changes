local xoffset = 24
local yoffset = 126
local separation = 7

local currentVals = {}

local stats = {}

callback.register("postLoad", function()
	for _, stat in ipairs(stats) do
		local name = stat.displayName:gsub(" ", "_")
		currentVals[name] = save.read("stat_"..name) or stat.default
	end
end)

callback.register("onGameEnd", function()
	for _, stat in ipairs(stats) do
		local name = stat.displayName:gsub(" ", "_")
		save.write("stat_"..name, currentVals[name])
	end
end)

local function updateStatVars()
	for _, stat in ipairs(stats) do
		local name = stat.displayName:gsub(" ", "_")
		currentVals[name] = save.read("stat_"..name) or stat.default
	end
end

local drawStat = function()
	local statobj = obj.Highscore:find(1)
	if statobj and statobj:isValid() and statobj:get("page") == 1 then
		local w, h = graphics.getGameResolution()
		
		for i, stat in ipairs(stats) do
			graphics.color(Color.fromHex(0xD5D5D8))
			graphics.alpha(1)
			local yy = (h * 0.1) + yoffset + (stat.height or 7) + separation * i
			for ii, istat in ipairs(stats) do
				if ii < i then
					yy = yy + (istat.height or 7)
				else
					break
				end
			end
			graphics.rectangle(xoffset, yy -4, xoffset + 1, yy -3, false)
			graphics.print(stat.displayName..":", xoffset + 13, yy - 8, 1, 0, 0)
			
			local xx = xoffset + 13 + graphics.textWidth(stat.displayName..": ", 1)
			if stat.displayFunc then
				stat.height = stat.displayFunc(xx, yy)
			else
				local name = stat.displayName:gsub(" ", "_")
				graphics.color(Color.fromHex(0xC8B16E))
				graphics.print(currentVals[name], xx, yy - 8, 1, 0, 0)
			end
		end
	end
end

callback.register("globalRoomStart", function(room)
	if room == rm.Highscore then
		graphics.bindDepth(-9999, drawStat)
		updateStatVars()
	end
end)


export("Scores")

Scores.new = function(name)
	if not isa(name, "string") then typeCheckError("Scores.new", 1, "name", "string", name) end
	
	local t = {
		displayName = name,
		default = 0,
		__score = true
	}
	
	table.insert(stats, t)
	return stats[#stats]
end

Scores.updateValue = function(score, value)
	if not score.__score then typeCheckError("Scores.new", 1, "score", "Score", score) end
	if not isa(value, "number") and not isa(value, "string") then typeCheckError("Scores.new", 2, "value", "number or string", value) end
	
	local name = score.displayName:gsub(" ", "_")
	currentVals[name] = value
end

Scores.getValue = function(score)
	if not score.__score then typeCheckError("Scores.new", 1, "score", "Score", score) end
	
	local name = score.displayName:gsub(" ", "_")
	return currentVals[name]
end