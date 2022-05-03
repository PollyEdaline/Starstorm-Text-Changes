
-- All main Interactable Manager data

local SSinteractables = {}

export("SSInteractable")

local cid = 1
SSInteractable.new = function(object, name)
	if not isa(object, "GMObject") then typeCheckError("SSInteractable.new", 1, "object", "GMObject", object) end
	if not isa(name, "string") then typeCheckError("SSInteractable.new", 2, "name", "string", name) end
	
	for _, int in pairs(SSinteractables) do
		if int.object == object then
			error("a Starstorm Interactable already exists with the GMObject "..object:getName())
		end
	end
	
	local interactable = {
		id = cid,
		displayName = name,
		object = object,
		stages = {},
		chance = 100,
		min = 1,
		max = 1,
		mpScale = 0,
		chanceScaling = 0,
		ignoreSacrifice = false
	}
	cid = cid + 1
	SSinteractables[name] = interactable
	return SSinteractables[name]
end

SSInteractable.find = function(name)
	if not isa(name, "string") then typeCheckError("SSInteractable.find", 1, "name", "string", name) end
	return SSinteractables[name]
end

SSInteractable.findAll = function()
	local ints = {}
	for i, int in pairs(SSinteractables) do
		table.insert(ints, int)
	end
	return ints
end

SSInteractable.fromObject = function(object)
	if not isa(object, "GMObject") then typeCheckError("SSInteractable.fromObject", 1, "object", "GMObject", object) end
	
	for _, int in pairs(SSinteractables) do
		if int.object == object then
			return int
		end
	end
end


-- Spawns

local enabledInteractables = SSinteractables

local ftimer = nil

table.insert(call.onStageEntry, function()
	ftimer = 7
end)

local droneObjects = {obj.Drone1Item, obj.Drone2Item, obj.Drone3Item, obj.Drone4Item, obj.Drone5Item, obj.Drone6Item, obj.Drone7Item}
--local droneInteractables = {}

local vanillaSync = {}

callback.register("postLoad", function()
	if obj.HackDroneItem then
		table.insert(droneObjects, obj.HackDroneItem)
		table.insert(droneObjects, obj.ShockDroneItem)
		table.insert(droneObjects, obj.DupDroneItem)
		vanillaSync[obj.HackDroneItem] = true
		vanillaSync[obj.ShockDroneItem] = true
		vanillaSync[obj.DupDroneItem] = true
	end
	for _, droneObject in ipairs(droneObjects) do
		local int = Interactable.fromObject(droneObject)
		
		local ssInteractable = {
			id = cid,
			displayName = int:getName(),
			object = droneObject,
			stages = {},
			chance = 3500 / int.spawnCost,
			min = 1,
			max = 4,
			mpScale = 0.3,
			chanceScaling = 0,
			ignoreSacrifice = true,
			sacrificeOnly = true
		}
		cid = cid + 1
		
		for _, stage in ipairs(Stage.findAll()) do
			if stage.interactables:contains(int) then
				table.insert(ssInteractable.stages, stage)
			end
		end
		
		vanillaSync[droneObject] = true
		table.insert(enabledInteractables, ssInteractable)
		--table.insert(droneInteractables, ssInteractable)
	end
end)

--[[callback.register("postSelection", function()
	local sacrificeDrones = getRule(1, 26)
	
	for _, droneInt in ipairs(droneInteractables) do
		droneInt.ignoreSacrifice = sacrificeDrones
	end
end)]]

table.insert(call.onStep, function()
	if ftimer and ftimer <= 0 then
		if not net.online or net.host then
			for _, interactable in pairs(enabledInteractables) do
				if not ar.Sacrifice.active or interactable.ignoreSacrifice then
					if not interactable.sacrificeOnly or ar.Sacrifice.active then
						if not interactable.achievementRequirement or interactable.achievementRequirement:isComplete() then
							if contains(interactable.stages, Stage:getCurrentStage()) then
								local mult = 1
								if interactable.mpScale ~= 0 then mult = math.ceil((1 - interactable.mpScale) + (interactable.mpScale * #misc.players)) end
								for i = 1, math.random(interactable.min, interactable.max) * mult do
								
									local chance = interactable.chance
									
									if interactable.chanceScaling then
										chance = math.max(interactable.chance + (interactable.chanceScaling * misc.director:get("stages_passed")), 0)
									end
									
									local firstChance = math.max(chance, 1)
									local secondChance = chance * 100
									
									if math.chance(firstChance) and math.chance(secondChance) then
										local grounds = {}
										
										for _, ground in ipairs(obj.B:findAll()) do
											if ground.sprite.width * ground.xscale > interactable.object.sprite.width and not ground:collidesWith(obj.Base, ground.x, ground.y - 1) and not ground:collidesWith(obj.TeleporterFake, ground.x, ground.y - 1) then
												table.insert(grounds, ground)
											end
										end
										
										if #grounds > 0 then
											local ground, groundL, groundR, x, y
											
											local ww = interactable.object.sprite.width / 2
											
											ground = table.irandom(grounds)
											groundL = ground.x - (ground.sprite.boundingBoxLeft * ground.xscale) + ww
											groundR = ground.x + (ground.sprite.boundingBoxRight * ground.xscale) - ww
											x = math.random(groundL, groundR)
											y = ground.y
											
											for i = 0, 20 do
												if pobj.mapObjects:findRectangle(x - ww, y - 20, x + ww, y + 10) then
													ground = table.irandom(grounds)
													groundL = ground.x - (ground.sprite.boundingBoxLeft * ground.xscale) + ww
													groundR = ground.x + (ground.sprite.boundingBoxRight * ground.xscale) - ww
													x = math.random(groundL, groundR)
													y = ground.y
												else
													break
												end
											end
											
											if vanillaSync[interactable.object] then
												createSynced(interactable.object, x, y)
											else
												interactable.object:create(x, y)
												
												if net.online then
													syncInteractableSpawn:sendAsHost(net.ALL, nil, interactable.object, x, y)
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
		ftimer = nil
	elseif ftimer and ftimer > 0 then
		ftimer = ftimer - 1
	end
end)