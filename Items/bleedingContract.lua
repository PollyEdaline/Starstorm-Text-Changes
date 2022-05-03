local path = "Items/Resources/"

it.BleedingContract = Item.new("Bleeding Contract")
local sBleedingContract = Sound.load("BleedingContract", path.."bleedingContract")
it.BleedingContract.pickupText = "Deal settled." 
it.BleedingContract.sprite = Sprite.load("BleedingContract", path.."Bleeding Contract.png", 1, 16, 16)
itp.sibylline:add(it.BleedingContract)
it.BleedingContract.color = Color.fromHex(0xFFCCED)
it.BleedingContract:setLog{
	group = "end",
	description = "Dying &y&restarts the stage. Consumed on activation.",
	story = "I knew what I had given up, in the end what only mattered was my prevalence, everything else was secondary, even if that meant I had to leave a husk of me behind.",
	priority = "&"..it.BleedingContract.color.gml.."&Unknown",
	destination = "",
	date = "Unknown"
}
if obj.NemesisExecutioner then
	NPC.registerBossDrops(obj.NemesisExecutioner, 100)
	NPC.addBossItem(obj.NemesisExecutioner, it.BleedingContract)
end

local onStepCall = function()
	if runData.bleedingContractTimer then
		if runData.bleedingContractTimer > 0 then
			for _, player in ipairs(obj.EfPlayerDead:findAll()) do
				par.Gravitational:burst("above", player.x, player.y, 1, Color.fromHex(0xC42323))
			end
			runData.bleedingContractTimer = runData.bleedingContractTimer - 1
		elseif net.host then
			if it.DivineRight:getObject():find(1) then
				runData.bleedingContractDivineRight = true
			end
			Stage.transport(Stage.getCurrentStage())
			sBleedingContract:play()
			if net.online then
				syncSound:sendAsHost(net.ALL, nil, sBleedingContract)
			end
			misc.director:set("stages_passed", misc.director:get("stages_passed") - 1)
		end
	else
		local players = obj.P:findAll()
		deadPlayers = 0
		
		for _, player in ipairs(players) do
			local bHcount = player:countItem(it.BeatingHeart)
			local bHuses = player:getData().beatingHeartUsed or 0
			if player:get("dead") == 1 and bHcount >= bHuses then
				deadPlayers = deadPlayers + 1
			end
		end
		if #players == deadPlayers and Stage.getCurrentStage() ~= stg.RedPlane then
			for _, player in ipairs(players) do
				if (player:get("bleedingcontract") or 0) > 0 then
					runData.bleedingContractTimer = 200
					
					if Stage.getCurrentStage() == stg.Unknown and not runData.resetAeonianEnd then
						local foundArraign1 = obj.Arraign1 and obj.Arraign1:find(1)
						local foundArraign2 = obj.Arraign2 and obj.Arraign2:find(1)
						if foundArraign1 or foundArraign2 then
							runData.resetAeonianEnd = true
							if foundArraign1 then
								runData.aonianArraignBackup = obj.Arraign1
							else
								runData.aonianArraignBackup = obj.Arraign2
							end
						end
					end
					
					if player:countItem(it.BleedingContract) > 0 then
						player:removeItem(it.BleedingContract, 1)
					end
					break
				end
			end
		end
	end
end
it.BleedingContract:addCallback("pickup", function(player)
	player:set("bleedingcontract", (player:get("bleedingcontract") or 0) + 1)
	tcallback.register("onStep", onStepCall)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.BleedingContract then
		player:set("bleedingcontract", player:get("bleedingcontract") - amount)
		tcallback.unregister("onStep", onStepCall)
	end
end)

table.insert(call.onStageEntry, function()
	if runData.bleedingContractTimer then
		runData.bhtimer = nil
		runData.bleedingContractTimer = nil
		if runData.bleedingContractDivineRight then
			runData.bleedingContractDivineRight = nil
			local player = misc.players[1]
			it.DivineRight:create(player.x, player.y - 18)
		end
		for _, player in ipairs(misc.players) do
			player:set("hp", player:get("maxhp"))
			player.mask = spr.PMask
		end
	end
end)