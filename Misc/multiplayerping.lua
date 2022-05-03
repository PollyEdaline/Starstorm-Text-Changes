
-- All Ping data

local names = {
	Teleporter = {obj.Teleporter, "Teleporter"},
	
	MimicChest = {obj.MimicChest, "Small Chest"},
	
	Chest1 = {obj.Chest1, "Small Chest"},
	Chest2 = {obj.Chest2, "Large Chest"},
	Chest3 = {obj.Chest3, "Item Shop"},
	Chest4 = {obj.Chest4, "Roulette Shop"},
	Chest5 = {obj.Chest5, "Golden Chest"},
	Barrel1 = {obj.Barrel1, "Small Canister"},
	Barrel2 = {obj.Barrel2, "Large Canister"},
	
	Activator = {obj.Activator, "Activator"},
	["De-Glassifier"] = {obj.Deglassifier, "De-Glassifier"},
	EscapePod = {obj.EscapePod, "Broken Escape Pod"},
	VoidPortal = {obj.VoidPortal, "Void Portal"},
	
	PeculiarRock = {obj.PeculiarRock, "???"},
	
	Shrine1 = {obj.Shrine1, "Chance Shrine"},
	Shrine2 = {obj.Shrine2, "Health Shrine"},
	Shrine3 = {obj.Shrine3, "Imp Shrine"},
	Shrine4 = {obj.Shrine4, "Chance Shrine"},
	Shrine5 = {obj.Shrine5, "Health Shrine"},
	Shrine6 = {obj.Shrine6, "Trial Shrine"},
	Shrine7 = {obj.SwordShrine, "Sword Shrine"},
	
	RelicShrine = {obj.RelicShrine, "Relic Shrine"},
	
	Command = {obj.Command, "Command Console"},
	CommandFinal = {obj.CommandFinal, "Command Console"},
	
	Drone1Item = {obj.Drone1Item, "Broken Drone"},
	Drone2Item = {obj.Drone2Item, "Broken Attack Drone"},
	Drone3Item = {obj.Drone3Item, "Broken Missile Drone"},
	Drone4Item = {obj.Drone4Item, "Broken Healing Drone"},
	Drone5Item = {obj.Drone5Item, "Broken Laser Drone"},
	Drone6Item = {obj.Drone6Item, "Broken Flamethrower Drone"},
	Drone7Item = {obj.Drone7Item, "Broken Medical Drone"},
	
	Geyser = {obj.Geyser, "Geyser"},
	
	Artifact8Box1 = {obj.Artifact8Box1, "Common Crate"},
	Artifact8Box2 = {obj.Artifact8Box2, "Uncommon Crate"},
	Artifact8Box3 = {obj.Artifact8Box3, "Rare Crate"},
	Artifact8BoxUse = {obj.Artifact8BoxUse, "Use Crate"},
	
	Starstorm_pool_Relic = {Object.find("Starstorm_pool_Relic"), "Relic Crate"},
	Starstorm_pool_Legendary = {Object.find("Starstorm_pool_Legendary"), "Legendary Crate"},
	Starstorm_pool_Sibylline = {Object.find("Starstorm_pool_Sibylline"), "Sibylline Crate"},
}

local function getName(instance)
	if instance and instance:isValid() then
		local instobject = instance:getObject()
		local txt = instobject:getName()
		if isa(instance, "ActorInstance") then txt = instance:get("name") end
		if names[instobject:getName()] then txt = names[instobject:getName()][2] end
		if txt == "Teleporter" and instance:get("isBig") then txt = "Ethereal Teleporter" end
		if string.find(instobject:getName(), "Artifact") and instobject ~= obj.Artifact6Mini and not string.find(instobject:getName(), "Box") then
			txt = Artifact.fromObject(instobject).displayName
		end
		if instance:get("text1") and instance:get("is_use") then
			txt = "Item\n("..instance:get("text1")..")"
		end
		
		if instance:getData().item and isa(instance:getData().item, "Item") then
			txt = txt.."\n("..instance:getData().item.displayName..")"
		end
		
		if instobject ~= obj.SwordShrine and instance:get("cost") and instance:get("cost") > 0 then
			txt = txt.."\n$"..instance:get("cost")
		end
		if instobject == names.Chest3[1] then
			if instance:get("item_id") > 0 then
				txt = txt.."\n("..Item.fromObject(Object.fromID(instance:get("item_id"))).displayName..")"
			else
				txt = txt.."\n(?)"
			end
		end
		return txt
	end
end


local syncPing = net.Packet.new("SSPing", function(player, player, object, x, y, name)
	if player and player:resolve() then
		local playerInstance = player:resolve()
		if isa(object, "GMObject") then
			local instance = object:findNearest(x, y)
			playerInstance:getData().pingedObject = {instance, name}
		else
			if object:resolve() and object:resolve():isValid() then
				playerInstance:getData().pingedObject = {object:resolve(), name}
			end
		end
	end
end)

local hostSyncPing = net.Packet.new("SSPing2", function(sender, player, object, x, y)
	if player and player:resolve() then
		local playerInstance = player:resolve()
		if isa(object, "GMObject") then
			local instance = object:findNearest(x, y)
			local name = getName(instance)
			playerInstance:getData().pingedObject = {instance, name}
			syncPing:sendAsHost(net.ALL, nil, player, object, x, y, name)
		else
			if object:resolve() and object:resolve():isValid() then
				local name = getName(object:resolve())
				playerInstance:getData().pingedObject = {object:resolve(), name}
				syncPing:sendAsHost(net.ALL, nil, player, object, x, y, name)
			end
		end
	end
end)


local range = 80

local bind = "shift"

callback.register ("onLoad", function()
	local flags = modloader.getFlags()
	for _, flag in ipairs(flags) do
		if string.find(flag, "ss_pingbind_") == 1 then
			local s = string.gsub(flag, "ss_pingbind_", "")
			if type(s) == "string" then
				print("Starstorm: Found ping bind key: "..s)
				bind = s
			else
				error("Invalid ping bind key! Check ModLoader flags!")
			end
			break
		end
	end
end)

local otherInteractables = {
	obj.VoidPortal,
	obj["De-Glassifier"]
}

--[[callback.register("postLoad", function()
	otherInteractables = {
		obj.Activator,
		obj.QuestShrine,
		obj.RelicShrine,
		obj.Deglassifier,
		obj.VoidPortal,
		obj.EscapePod,
		obj.SwordShrine,
		obj.MimicChest
	}
end)]]

for _, int in ipairs(SSInteractable.findAll()) do
	table.insert(otherInteractables, int.object)
	if not names[int.object:getName()] then
		names[int.object:getName()] = {int.object, int.displayName}
	end
end

table.insert(call.onPlayerStep, function(player)
	if not net.online or player == net.localPlayer and player:get("dead") == 0 then
	
		local bbind = bind
		if net.online and bind == "shift" then
			bbind = "control"
		end
		
		local altInput = nil
		local gamepad = input.getPlayerGamepad(player)
		if gamepad then
			altInput = input.checkGamepad("stickl", gamepad)
		end
	
		if input.checkKeyboard(bbind) == input.RELEASED or altInput == input.RELEASED then
			if player:getData().highlightedPing then
				local object = player:getData().highlightedPing.obj
				local txt = nil
				
				if not net.online or net.host then
					txt = getName(object)
				end
				
				if net.online then
					local toSend = nil
					if contains(otherInteractables, object:getObject()) then
						toSend = object:getObject()
					else
						toSend = object:getNetIdentity()
					end
					if net.host then
						syncPing:sendAsHost(net.ALL, nil, player:getNetIdentity(), toSend, object.x, object.y, txt)
					else
						hostSyncPing:sendAsClient(player:getNetIdentity(), toSend, object.x, object.y)
					end	
				end
				
				player:getData().pingedObject = {player:getData().highlightedPing.obj, txt}
			end
		end
		if input.checkKeyboard(bbind) == input.HELD or altInput == input.HELD then
			player:getData().highlightedPing = nil
			local nearInteractables = pobj.mapObjects:findAllEllipse(player.x - range, player.y - range, player.x + range, player.y + range)
			local nearEnemies = pobj.enemies:findAllEllipse(player.x - range, player.y - range, player.x + range, player.y + range)
			local nearItems = pobj.items:findAllEllipse(player.x - range, player.y - range, player.x + range, player.y + range)
			local nearArtifacts = pobj.artifacts:findAllEllipse(player.x - range, player.y - range, player.x + range, player.y + range)
			local nearOtherInteractables = {}
			for _, otherInt in pairs(otherInteractables) do
				local toAdd = otherInt:findAllEllipse(player.x - range, player.y - range, player.x + range, player.y + range)
				for _, i in ipairs(toAdd) do
					table.insert(nearOtherInteractables, i)
				end
			end
			
			local allNearObjects = {}
			
			for _, interactable in ipairs(nearInteractables) do
				local name = interactable:getObject():getName()
				if name ~= "TeleporterFake" and name ~= "Geyser" then
					if name == "Teleporter" or interactable:get("active") and interactable:get("active") <= 0 or interactable:get("used") and interactable:get("used") <= 0 then	
						table.insert(allNearObjects, interactable)
					end
				end
			end
			for _, enemy in ipairs(nearEnemies) do
				if enemy:get("team") ~= "player" and enemy:getObject() ~= obj.actorDummy then
					table.insert(allNearObjects, enemy)
				end
			end
			for _, item in ipairs(nearItems) do
				table.insert(allNearObjects, item)
			end
			for _, artifact in ipairs(nearArtifacts) do
				table.insert(allNearObjects, artifact)
			end
			for _, otherInteractable in ipairs(nearOtherInteractables) do
				table.insert(allNearObjects, otherInteractable)
			end
			
			local currentNearest = nil
			
			if not currentNearest or currentNearest.obj:isValid() then
				for _, object in ipairs(allNearObjects) do
					if currentNearest then
						local dis = distance(object.x, object.y, player.x, player.y)
						if dis < currentNearest.dis then
							currentNearest = {obj = object, dis = dis}
						end
					else
						currentNearest = {obj = object, dis =  distance(object.x, object.y, player.x, player.y)}
					end
				end
				
				player:getData().highlightedPing = currentNearest
			end
		else
			player:getData().highlightedPing = nil
		end

		if player:getData().pingedObject then
			if not player:getData().pingTimeout then
				player:getData().pingTimeout = 4000
			end
			if player:getData().pingTimeout > 0 then
				player:getData().pingTimeout = player:getData().pingTimeout - 1
			else
				player:getData().pingedObject = nil
			end
		else
			if not player:getData().pingTimeout then
				player:getData().pingTimeout = 4000
			end
			if player:getData().pingTimeout < 4000 then
				player:getData().pingTimeout = 4000
			end
		end
	end
	
	if player:getData().pingedObject and player:getData().pingedObject[1] and player:getData().pingedObject[1]:isValid() and player:getData().pingedObject[1]:getObject() ~= names.Teleporter[1] then
		local pingedObject = player:getData().pingedObject[1]
		if pingedObject:get("active") and pingedObject:get("active") > 0 or pingedObject:get("used") and pingedObject:get("used") > 0 then
			player:getData().pingedObject = nil
		end
	end
end)

table.insert(call.onDraw, function()
	for p, player in ipairs(misc.players) do
		if player:getData().highlightedPing and player:getData().highlightedPing.obj:isValid() then
			local object = player:getData().highlightedPing.obj
			graphics.setBlendMode("additive")
			
			local image = object.sprite
			if object.mask then
				image = object.mask
			end
			
			graphics.drawImage{
				image = object.sprite,
				x = object.x,
				y = object.y,
				subimage = object.subimage,
				color = Color.WHITE,
				alpha = 0.8,
				angle = object.angle,
				xscale = object.xscale,
				yscale = object.yscale
			}
		elseif player:getData().pingedObject and player:getData().pingedObject[1] and player:getData().pingedObject[1]:isValid() then
			local object = player:getData().pingedObject[1]
			
			local image = object.sprite
			local divide = 3
			if object.mask then
				image = object.mask
				divide = 2.6
			end
			
			graphics.color(playerColor(player, p))
			graphics.circle(object.x, object.y - image.yorigin + (image.height / 2), (image.height + image.width) / divide, true)
		end
	end
end)

table.insert(call.onHUDDraw, function()
	for p, player in ipairs(misc.players) do
		if player:getData().pingedObject and player:getData().pingedObject[1] and player:getData().pingedObject[1]:isValid() then
			local object = player:getData().pingedObject[1]
			local txt = player:getData().pingedObject[2]
			
			graphics.color(playerColor(player, p))
			drawOutOfScreen(object, txt)
		end
	end
end)