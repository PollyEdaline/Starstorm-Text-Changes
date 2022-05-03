-- DIFFICULTIES

--dif.Monsoon.description = "&r&-MONSOON-&!&\nFor hardcore players.\nEvery bend introduces pain and horrors of the planet.\nYou might die."

dif.Typhoon = Difficulty.new("Typhoon")
dif.Typhoon.displayName = "Typhoon"
dif.Typhoon.icon = Sprite.load("Difficulty_Typhoon2", "Gameplay/HUD/difTyphoonMenu", 3, 13, 11)
dif.Typhoon.scale = 0.2
dif.Typhoon.scaleOnline = 0.026
local color = tostring(Color.fromHex(0xE550A7).gml)
dif.Typhoon.description = "&"..color.."&-TYPHOON-&!&\n&r&The maximum challenge.&!&\nThe planet is a nightmare, survival is merely an illusion.\nNobody has what it takes."
dif.Typhoon.enableMissileIndicators = false
dif.Typhoon.forceHardElites = true
dif.Typhoon.enableBlightedEnemies = true

local cataclysmEnabled = global.rormlflag["23"]

if cataclysmEnabled then
dif.Cataclysm = Difficulty.new("Cataclysm")
dif.Cataclysm.displayName = "Cataclysm"
dif.Cataclysm.icon = Sprite.load("Difficulty_Cataclysm2", "Gameplay/HUD/difCataclysmMenu", 3, 13, 14)
dif.Cataclysm.scale = 0.23
dif.Cataclysm.scaleOnline = 0.03
dif.Cataclysm.description = "&dl&-CATACLYSM-&!&\nCock and ball torture." -- so true!
dif.Cataclysm.enableMissileIndicators = false
dif.Cataclysm.forceHardElites = true
dif.Cataclysm.enableBlightedEnemies = true
end

local selRooms = {
	[rm.Select] = true,
	[rm.SelectCoop] = true,
	[rm.SelectMult] = true
}

local harderDifficulties = {
	[dif.Typhoon] = true,
	--[dif.Cataclysm] = true
}

if cataclysmEnabled then
	harderDifficulties[dif.Cataclysm] = true
end

if cataclysmEnabled then
callback.register("globalStep", function(room)
	if selRooms[room] then
		dif.Cataclysm.description = "&lt&"..corruptStr("-CATACLYSM-", 3).."&!&\n&r&"..corruptStr("THIS IS A NIGHTMARE.", 5).."\n&lt&"..corruptStr("PLANET INHABITABLE, ATMOSPHERE AT A CRITICAL STATE.", 5).."\n                                                              "
	end
end)
end

obj.Teleporter:addCallback("create", function(self)
	if harderDifficulties[Difficulty.getActive()] and Stage.getCurrentStage() ~= stg.BoarBeach then
		self:set("maxtime", 7200)
	end
end)
obj.BlastdoorPanel:addCallback("create", function(self)
	if harderDifficulties[Difficulty.getActive()] then
		self:set("maxtime", 2700)
	end
end)

table.insert(call.onPlayerStep, function(player)
	if harderDifficulties[Difficulty.getActive()] then
		if misc.director:getAlarm(0) == 30 then
			if player:collidesWith(obj.Lava, player.x, player.y) then
				DOT.applyToActor(player, DOT_FIRE, player:get("maxhp") * 0.05, 5, "lava", false)
			end
		end
		
		local sw, sh = Stage.getDimensions()
		
		if player.y > sh then
			if not player:getData().fallen then
				player:getData().fallen = true
				player:set("hp", player:get("hp") - player:get("hp") * 0.5)
			end
		elseif player:getData().fallen then
			player:getData().fallen = nil
		end
	end
end)

local syncCataclysm = net.Packet.new("SS23", function(player)
	if not cataclysmEnabled then
		cataclysmEnabled = true
		dif.Cataclysm = Difficulty.new("Cataclysm")
		dif.Cataclysm.displayName = "Cataclysm"
		dif.Cataclysm.icon = Sprite.load("Difficulty_Cataclysm2", "Gameplay/HUD/difCataclysmMenu", 3, 13, 14)
		dif.Cataclysm.scale = 0.23
		dif.Cataclysm.scaleOnline = 0.03
		dif.Cataclysm.description = "&dl&-CATACLYSM-&!&\nCock and ball torture." -- so true!
		dif.Cataclysm.enableMissileIndicators = false
		dif.Cataclysm.forceHardElites = true
		dif.Cataclysm.enableBlightedEnemies = true
		
		callback.register("globalStep", function(room)
			if selRooms[room] then
				dif.Cataclysm.description = "&lt&"..corruptStr("-CATACLYSM-", 3).."&!&\n&r&"..corruptStr("THIS IS A NIGHTMARE.", 5).."\n&lt&"..corruptStr("PLANET UNHABITABLE, ATMOSPHERE AT A CRITICAL STATE.", 5).."\n                                                   "
			end
		end)
		
		if cataclysmEnabled then
			harderDifficulties[dif.Cataclysm] = true
		end
		
		Difficulty.setActive(dif.Cataclysm)
	end
end) -- disgusting.............

callback.register("postStageEntry", function()
	if Difficulty.getActive() == dif.Cataclysm then
		if getRule(5, 2) ~= false then
			if not runData.addedHardElites then
				runData.addedHardElites = true
				toggleElites(newHardElites, true)
			end
		end
		runData.canSpawnNemesis = true
		if cataclysmEnabled and net.host and net.online then
			syncCataclysm:sendAsHost(net.ALL, nil)
		end
	end
end)