-- SEEDS

local seed = nil
local newSeed = nil

function getSeed()
	return seed
end

function setSeed(number)
	newSeed = number
	misc.setRunSeed(number)
end

callback.register ("onLoad", function()
	local flags = modloader.getFlags()
	for _, flag in ipairs(flags) do
		if string.find(flag, "ss_seed_") == 1 then
			local s = string.gsub(flag, "ss_seed_", "")
			if s:gsub("%D+", "") ~= "" then
				s = tonumber(s:gsub("%D+", "") + 0)
				print("Starstorm: Found seed "..s)
				setSeed(s)
				seed = s
				break
			else
				s = math.random(0, 2147483647)
				misc.setRunSeed(s)
				seed = s
				newSeed = nil
				error("Custom seed must be a number! Check ModLoader flags.")
			end
		end
	end
	if newSeed == nil then
		local s = math.random(0, 2147483647)
		misc.setRunSeed(s)
		seed = s
	end
end)

local firstPostEntry = nil
callback.register ("onStageEntry", function()
	firstPostEntry = true
end)
table.insert(call.onStep, function()
	if firstPostEntry and not global.rormlflag.ss_disable_reskin then
		local stage = Stage.getCurrentStage()
		if stageGrounds[stage] then
			save.write("lastStage", stage:getName())
			spr.GroundStrip:replace(stageGrounds[stage])
		end
		firstPostEntry = nil
	end
end)

callback.register ("onGameEnd", function()
	if not newSeed then
		local s = math.random(0, 2147483647)
		misc.setRunSeed(s)
		seed = s
	else
		setSeed(newSeed)
		seed = newSeed
		--newSeed = nil
	end
end)