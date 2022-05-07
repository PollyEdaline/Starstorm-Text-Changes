local path = "Items/Resources/"

it.IceTool = Item.new("Ice Tool")
local sIceTool = Sound.load("IceTool", path.."iceTool")
local parIceTool = ParticleType.find("Debris2", "Starstorm")
it.IceTool.pickupText = "Gain a jump while in contact with a wall and climb faster." 
it.IceTool.sprite = Sprite.load("Spring", path.."Ice Tool.png", 1, 12, 13)
it.IceTool:setTier("common")
it.IceTool:setLog{
	group = "common_locked",
	description = "&b&Gain a jump&!& while in &y&contact with a wall&!&. Increases your &b&speed while climbing&!&.",
	story = "Good day fellow hiking friend, I found the ice tool you lost last time we went to Mt. [REDACTED]. Please keep an eye out for the snow next time!\nI wonder if the ice tool is still usable though, it's been through so much!",
	destination = "Mon's Tower #33,\nSolei Shore,\nEarth",
	date = "03/12/2056"
}

local onPlayerStepCall = function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	-- Ice Tool
	local iceTool = player:countItem(it.IceTool)
	if iceTool > 0 then
		if playerAc.free == 1 then
			if playerAc.wallJump < iceTool and player:get("moveUp") == 1 then
				local jc = playerAc.jump_count or 0
				local feather = playerAc.feather or playerAc.feather
				if jc >= feather then
					if player:collidesMap(player.x + 1, player.y) or player:collidesMap(player.x - 1, player.y) then
						sIceTool:play(1 + math.random() * 0.2)
						if global.quality > 1 then
							par.Spark:burst("above", player.x + (5 * player.xscale), player.y - 1, 1)
						end
						parIceTool:burst("above", player.x + (5 * player.xscale), player.y - 1, 5)
						playerAc.pVspeed = -playerAc.pVmax - 1.9
						playerAc.wallJump = playerAc.wallJump + 1
					end
				end
			end
		else
			playerAc.wallJump = 0
		end
		if playerAc.activity == 30 and playerData.iceTool == nil then
			local newSpeed = (0.5 * iceTool)
			playerAc.pHmax = playerAc.pHmax + newSpeed
			playerData.iceTool = newSpeed
		elseif playerAc.activity ~= 30 and playerData.iceTool then
			playerAc.pHmax = playerAc.pHmax - playerData.iceTool
			playerData.iceTool = nil
		end
	end
end

it.IceTool:addCallback("pickup", function(player)
	if not player:get("wallJump") then
		player:set("wallJump", 0)
	end
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)