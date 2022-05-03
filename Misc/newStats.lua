sco = {}

sco.games = Scores.new("Total Games Beaten")
callback.register("onGameBeat", function()
	Scores.updateValue(sco.games, Scores.getValue(sco.games) + 1)
end)
sco.ethereal = Scores.new("Total Ethereals Activated")

sco.void = Scores.new("Total Void Survivals")

local nemesisList = {}

local savestr = save.read("stat_Nemesis")
if savestr then
	for str in string.gmatch(savestr, "([^".."&&".."]+)") do
		local t = {}
		for str2 in string.gmatch(str, "([^".."=".."]+)") do
			table.insert(t, str2)
		end
		
		nemesisList[tonumber(t[1])] = tonumber(t[2]) -- Wow i suck
	end
end

sco.nemesis = Scores.new("Nemesis")
sco.nemesis.displayFunc = function(x, y)
	if Scores.getValue(sco.nemesis) then
		for str in string.gmatch(Scores.getValue(sco.nemesis), "([^".."&&".."]+)") do
			local t = {}
			for str2 in string.gmatch(str, "([^".."=".."]+)") do
				table.insert(t, str2)
			end
			
			nemesisList[tonumber(t[1])] = tonumber(t[2])
		end
		
		local top
		for id, count in pairs(nemesisList) do
			if not top or top.count < count then
				top = {id = id, count = count}
			end
		end
		
		if top then
			local obj = Object.fromID(top.id)
			
			local xx = obj.sprite.xorigin + x
			
			graphics.drawImage{
				image = obj.sprite,
				x = xx,
				y = y,
				alpha = 1
			}
			
			return math.max(7, obj.sprite.yorigin)
		end
	end
end
sco.nemesis.default = nil

callback.register("onPlayerDeath", function(player)
	if not net.online and player == misc.players[1] or net.online and player == net.localPlayer then
		local id = player:get("last_hit")
		local lastHit = Object.fromID(id)
		if lastHit then
			
			if nemesisList[id] then
				nemesisList[id] = nemesisList[id] + 1
			else
				nemesisList[id] = 1
			end
			
			local str = ""
			for id, count in pairs(nemesisList) do
				str = str..id.."="..count.."&&"
			end
			Scores.updateValue(sco.nemesis, str)
		end
	end
end)


-- I'm hungry brb