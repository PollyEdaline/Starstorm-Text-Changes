-- QOL stuff!

-- Fix position
table.insert(call.onPlayerStep, function(player)
	if player:get("activity") ~= 30 then
		local n = 0
		while player:collidesMap(player.x, player.y) and n < 100 do
			if not player:collidesMap(player.x + 4, player.y) then
				player.x = player.x + 4
			elseif not player:collidesMap(player.x - 4, player.y) then
				player.x = player.x - 4
			elseif not player:collidesMap(player.x, player.y + 5) then
				player.y = player.y + 5
			else
				player.y = player.y - 1
				n = n + 1
			end
		end
	end
end)

-- Fix sounds still playing on main menu
callback.register("onGameEnd", function()
	for n, namespace in pairs(namespaces) do
		for s, sound in ipairs(Sound.findAll(namespace)) do
			if sound:isPlaying() and Sound.getMusic() ~= sound and sound ~= sfx.CutsceneJet and sound ~= specialEndingSound then
				sound:stop()
			end
		end
	end
end)

--[[ Exponential Scaling -- This was not good but I may use it in the future.
local scalePercent = 0
table.insert(call.onStep, function()
	local director = misc.director
	local directorAc = director:getAccessor()
	local difficulty = Difficulty.getActive()
	if directorAc.time_start > 1800 and director:getAlarm(0) == 1 then
		if directorAc.time_start % 600 == 0 then
			scalePercent = scalePercent + 0.1
		end
		directorAc.enemy_buff = directorAc.enemy_buff + (difficulty.scale * scalePercent)
	end
end)
callback.register("onGameStart", function()
	scalePercent = 0
end)]]  

-- Fix enemies spawning after teleport charge? this is old i forgot if it is even useful at all
table.insert(call.onStep, function()
	for _, teleporter in ipairs(obj.Teleporter:findAll()) do
		if teleporter:get("active") > 1 then
			misc.director:setAlarm(1, -1)
			break
		end
	end
	if obj.CommandFinal:find(1) then -- this does work, though
		misc.director:set("points", 0)
		misc.director:setAlarm(1, -1)
	end
end)

-- Crates
local savedCrates = {}
local objCrateUse = obj.Artifact8BoxUse
local openCrate = {}
if not global.rormlflag.ss_disable_bettercrates then
	table.insert(call.onStep, function()	
		for _, crate in ipairs(pobj.commandCrates:findAll()) do
			local crateAc = crate:getAccessor()
			if crateAc.active > 0 then
				local owner = crateAc.owner
				if not openCrate[owner] or not openCrate[owner]:isValid() then
					openCrate[owner] = nil
				end
				if crateAc.active == 1 then
					crateAc.fade_alpha = 0.3
					crate:setAlarm(0, -1)
				end
				if owner then
					if not openCrate[owner] or openCrate[owner]:getObject() == crate:getObject() then
						if not openCrate[owner] and not crate:getData().used then
							openCrate[owner] = crate
						end
						if not savedCrates[crateAc.owner] then
							savedCrates[crateAc.owner] = {}
						end
						if savedCrates[crateAc.owner][crate:getObject()] and not crate:getData().open then
							crate:getData().open = true
							crateAc.selection = savedCrates[crateAc.owner][crate:getObject()]
						end
						if crateAc.active == 3 and not crate:getData().used then
							crate:getData().used = true
							savedCrates[crateAc.owner][crate:getObject()] = crateAc.selection
						end
					elseif not crate:getData().used then
						if net.online and Object.findInstance(owner) == net.localPlayer then
							if net.host then
								syncInstanceVar:sendAsHost(net.ALL, nil, crate:getNetIdentity(), "active", 0)
								syncInstanceVar:sendAsHost(net.ALL, nil, crate:getNetIdentity(), "fade_alpha", 0)
							else
								syncInstanceVar:sendAsClient(crate:getNetIdentity(), "active", 0)
								syncInstanceVar:sendAsClient(crate:getNetIdentity(), "fade_alpha", 0)
							end
						end
						crateAc.active = 0
						crateAc.fade_alpha = 0
					end
					
					local ownerInst = Object.findInstance(owner)
					if ownerInst and ownerInst:isValid() then
						local check = (net.online and ownerInst:get("force_z") == 1 or ownerInst:get("force_x") == 1 or ownerInst:get("force_c") == 1 or ownerInst:get("force_v") == 1) or (ownerInst:get("z_skill") == 1 or ownerInst:get("x_skill") == 1 or ownerInst:get("c_skill") == 1 or ownerInst:get("v_skill") == 1)
						if check then
							crateAc.owner = 3
							crateAc.active = 0
							crateAc.fade_alpha = 0
							crateAc.activator = 0
							ownerInst:set("activity", 0)
							ownerInst:set("activity_type", 0)
							openCrate[owner] = nil
						end
					end
				end
			end
			if crate:getObject() == objCrateUse then
				if getRule(1, 22) == true then
					if not crate:getData().life then
						crate:getData().life = 2700
					else
						if crateAc.active <= 0 then
							crate:getData().life = crate:getData().life - 1
							if crate:getData().life <= 0 then
								crate:delete()
							end
						end
					end
				end
			end
		end
	end)
end

export("SSCrate")
SSCrate.getSelection = function(player, crate)
	if not isa(player, "PlayerInstance") then typeCheckError("SSCrate.getSelection", 1, "player", "PlayerInstance", player) end
	if not isa(crate, "Instance") then typeCheckError("SSCrate.getSelection", 2, "crate", "Instance", crate) end
	
	local playerid = player.id
	local crateObject = crate:getObject()
	
	if savedCrates[playerid] and savedCrates[playerid][crateObject] then
		return savedCrates[playerid][crateObject]
	end
end
SSCrate.setSelection = function(player, crate, selection)
	if not isa(player, "PlayerInstance") then typeCheckError("SSCrate.getSelection", 1, "player", "PlayerInstance", player) end
	if not isa(crate, "Instance") then typeCheckError("SSCrate.getSelection", 2, "crate", "Instance", crate) end
	if not isa(selection, "number") then typeCheckError("SSCrate.getSelection", 3, "selection", "Instance", selection) end
	
	local playerid = player.id
	local crateObject = crate:getObject()
	
	if not savedCrates[playerid] then
		savedCrates[playerid] = {[crateObject] = selection}
	else
		savedCrates[playerid][crateObject] = selection
	end
end

-- Item Batching
if not global.rormlflag.ss_disable_betterpickups then
table.insert(call.onStep, function()
	for _, item in pairs(pobj.items:findAll()) do
		if item:isValid() then
			
			if item:getData().amount == nil then
				item:getData().amount = 1
				item:getData().originalText1 = item:get("text1")
			elseif item:getData().amount > 1 then
				item:set("text1", item:getData().originalText1.." (x"..item:getData().amount..")")
			end
			
			if item:get("used") == 1 then
				item:set("yo", item:get("yo") + 0.02)
				for _, item2 in pairs(pobj.items:findAllEllipse(item.x - 200, item.y - 100, item.x + 200, item.y + 100)) do
					if item2.id ~= item.id and item2:get("used") == 1 and item2:get("owner") == item:get("owner") then
						if item2:getData().originalText1 == item:getData().originalText1 and item2:get("text2") == item:get("text2") then
							item:getData().amount = item:getData().amount + item2:getData().amount
							if item:getData().amount < item2:getData().amount then
								item2.x = item.x
								item2.y = item.y
							else
								item.x = item2.x
								item.y = item2.y
							end
							item:set("yo", 0) 
							if item2:get("sound_played") == 0 then
								item2:set("sound_played", 1)
								sfx.Pickup:play(1, 0.25)
							end
							item2:destroy()
						end
					end
				end
				local owner = Object.findInstance(item:get("owner"))
				if owner and owner:isValid() then
					if not item:getData().setOwner then
						item:getData().setOwner = owner
						owner:getData().pickedUpItem = item
					end
					item.mask = spr.EfBlank
					item.x = owner.x
					item.y = owner.y - 20
					if owner:getData().pickedUpItem ~= item then
						item:destroy()
					end
				end
			end
		end
	end
end)
end

-- Faster Gold
table.insert(call.onStep, function()
	if not ar.Gathering or not ar.Gathering.active then
		for _, gold in ipairs(obj.EfGold:findAll()) do
			if gold:getAlarm(1) ~= 1 then
				if not gold:getData().alarm then
					gold:getData().alarm = 60
				else
					gold:getData().alarm = gold:getData().alarm - 1
					if gold:getData().alarm <= 0 then
						gold:setAlarm(1, 1)
					end
				end
			end
		end
	end
end)

-- Glass Rebalance
table.insert(call.onStep, function()
	if getRule(5, 14) == true then
		if ar.Glass.active then
			for _, dagger in ipairs(obj.EfMissileMagic:findAll()) do
				if not dagger:getData()._glassModified then
					dagger:getData()._glassModified = true
					dagger:set("damage", math.ceil(dagger:get("damage") / 3))
				end
			end
			for _, heal in ipairs(obj.EfHeal:findAll()) do
				if not heal:getData()._glassModified then
					heal:getData()._glassModified = true
					local hp = heal:get("value") * 0.2
					if ar.Multitude and ar.Multitude.active then
						hp = hp * 0.7
					end
					heal:set("value", hp)
				end
			end
		end
	end
end)
table.insert(call.preHit, function(damager)
	local parent = damager:getParent()
	if parent and parent:isValid() and isaDrone(parent) and getRule(5, 14) == true then
		damager:set("damage_fake", damager:get("damage_fake") * 0.5)
		damager:set("damage", damager:get("damage") * 0.5)
	end
end)

-- Stackable Unstackables
callback.register("onItemPickup", function(item, player)
	if getRule(5, 9) == true and item:isValid() then
		if item:getObject() == it.RedWhip:getObject() then
			if player:getData().whipboosted then
				player:set("pHmax", player:get("pHmax") - (0.35 * player:getData().whipboosted))
				player:getData().whipboosted = nil
			end
		end
	end
end)
table.insert(call.onPlayerStep, function(player)
	if getRule(5, 9) ~= false then
		local diocount = player:countItem(it.DiosFriend)
		local data = player:getData()
		local ac = player:getAccessor()
		
		if not data.lastDioCount or data.lastDioCount ~= diocount then
			if data.lastDioCount then
				local dif = diocount - data.lastDioCount
				if diocount > data.lastDioCount then
					if ac.hippo > 1 then
						local last = data.hippo2 or 0
						data.hippo2 = last + ac.hippo - 1
						ac.hippo = 1
					end
					
					player:setItemSprite(it.DiosFriend, spr.Hippo)
				end
			end
			
			data.lastDioCount = diocount
		end
		
		if ac.hippo == 0 then
			if data.hippo2 and data.hippo2 > 0 then
				ac.hippo = 1
				data.hippo2 = data.hippo2 - 1
				player:setItemSprite(it.DiosFriend, spr.Hippo)
			end
		end
		
		
		
		local redWhip = math.min(player:countItem(it.RedWhip), 14)
		local redWhipEnabled = false
		if redWhip > 1 and player:get("combat_timer") == 0 then
			redWhipEnabled = true
		end
		if redWhipEnabled and not player:getData().whipboosted then
			player:getData().whipboosted = redWhip
			player:set("pHmax", player:get("pHmax") + (0.35 * redWhip))
		elseif player:getData().whipboosted and not redWhipEnabled then
			player:set("pHmax", player:get("pHmax") - (0.35 * player:getData().whipboosted))
			player:getData().whipboosted = nil
		end
	end
end)

-- Force Teleport
-- this sucks but im afraid removing it will break something
table.insert(call.onStep, function()
	for _, tele in ipairs(obj.Teleporter:findAll()) do
		if tele:isValid() and net.host then
			if tele:get("active") == 4 or tele:get("active") == 6 then
				if not tele:getData().countdown then
					tele:getData().countdown = 600
					
					for _, tele2 in ipairs(obj.Teleporter:findAll()) do
						if tele2 ~= tele then
							par.FloatingRocks:burst("above", tele2.x, tele2.y, 10)
							tele2:destroy()
						end
					end

				else
					tele:getData().countdown = tele:getData().countdown - 1
				end
				
				if tele:getData().countdown <= 0 then
					local players = obj.P:findAll() 
					local xpInstances = obj.EfExp:findAll()
					
					if #xpInstances == 0 and #obj.P:findMatching("ready", 1) >= #players then
						if tele:get("active") == 4 then
							tele:set("active", 5)
						else
							tele:set("active", 7)
						end
					else
						tele:getData().countdown = 100
						if tele:getData().chance then
							if tele:getData().chance < 3 then
								tele:getData().chance = tele:getData().chance + 1
							else
								for _, player in ipairs(players) do
									player:set("ready", 1)
									player:set("activity", 99)
									misc.setGold(0)
								end
							end
						else
							tele:getData().chance = 1
						end
					end
				end
			elseif tele:get("active") == 2 then
				local amount = 0
				for _, enemy in ipairs(pobj.enemies:findAll()) do
					if enemy:get("ghost") == 0 and enemy:get("team") == "enemy" and not enemy:get("tamed") then
						amount = amount + 1
					end
				end
				if amount == 0 then
					tele:set("active", 3)
				end
			elseif tele:get("active") > 4 then
				misc.setGold(0)
			end
		end
	end
	local players = obj.P:findAll()
	local ready = 0
	for _, player in ipairs(players) do
		if player:get("ready") == 1 then
			ready = ready + 1
		end
	end
	if #players == ready then
		local tele = obj.Teleporter:find(1)
		if tele and tele:isValid() and tele:get("active") < 4 then
			tele:set("active", 4)
		end
	end
end)

-- Sync Passed Stages
local syncPassedStages = net.Packet.new("SSPassedStages", function(player, passedStages)
	if passedStages and misc.director and misc.director:isValid() then
		misc.director:set("stages_passed", passedStages)
	end
end)

table.insert(call.onStep, function()
	if net.online and net.host then
		for _, tele in ipairs(obj.Teleporter:findAll()) do
			if tele:get("active") > 2 and not tele:getData().synced then
				syncPassedStages:sendAsHost(net.ALL, nil, misc.director:get("stages_passed"))
				tele:getData().synced = true
			end
		end
	end
end)


local htimer = 0
local restore = false

local noDebugTest = {
	[obj.B] = true,
	[obj.BNoSpawn] = true,
	[obj.BossSpawn] = true,
	[obj.BossSpawn2] = true,
	[obj.Rope] = true
}

table.insert(call.onStep, function()
	if net.host then
		if input.checkKeyboard("shift") == input.HELD then
			if input.checkKeyboard("r") == input.HELD then
				htimer = htimer + 1
				
				if htimer == 180 then
					Stage.transport(Stage.getCurrentStage())
					if runData.adversityStageCount then
						runData.adversityStageCount = runData.adversityStageCount - 1
					end
					misc.director:set("stages_passed", misc.director:get("stages_passed") - 1)
					syncPassedStages:sendAsHost(net.ALL, nil, misc.director:get("stages_passed"))
					restore = true
				end
			elseif input.checkKeyboard("t") == input.HELD then
				htimer = htimer + 1
				
				if htimer == 180 then
					log("INSTANCES:")
					for _, object in ipairs(Object.findAll()) do
						if not noDebugTest[object] then
							local t = object:findAll()
							if #t > 0 then
								log(t)
							end
						end
					end
					log("RUN DATA:")
					for key, value in pairs(runData) do
						log(key, value)
					end
					sfx.achievement:play(2)
					log("PLAYER DATA:")
					for _, player in ipairs(obj.P:findAll()) do
						log(player:getData())
						log("activity", player:get("activity"))
					end
				end
			else
				htimer = 0
			end
		else
			htimer = 0
		end
	end
end)
table.insert(call.onStageEntry, function()
	if restore then
		restore = false
		for _, player in ipairs(misc.players) do
			player.mask = spr.PMask
		end
	end
end)

-- Limit FX
--local fxTypes = {obj.EfFireworkBurst}
local limit = 200
table.insert(call.postStep, function()
	--for _, fx in ipairs(fxTypes) do
		for i, instance in ipairs(obj.EfFireworkBurst:findAll()) do
			if i > limit or global.quality == 1 then
				instance:destroy()
			end
		end
	--end
end)

-- Cremator Fix
local sprTurtleShellMask =  Sprite.load("TurtleShellMask", "Actors/Turtle/shellMask", 1, 73, 35)
obj.TurtleShell.sprite = sprTurtleShellMask

-- Main Menu Back Button
local backRooms = {
	[rm.Select] = true,
	[rm.SelectCoop] = true
}
local backButtonHighlight = false
local goBack = false
local function drawBackButton()
	local w, h = graphics.getGameResolution()
	local s = obj.Select:find(1) or obj.SelectCoop:find(1)
	if h >= 400 and s and s:get("using_mouse") == 1 then
		if backButtonHighlight then
			graphics.color(Color.WHITE)
		else
			graphics.color(Color.fromHex(0x808080))
		end
		graphics.print("Back", w * 0.85, h - 48, graphics.FONT_LARGE)
	end
end
callback.register("globalRoomStart", function(room)
	if backRooms[room] then
		graphics.bindDepth(-99, drawBackButton)
		createFromId(obj.Highscore.id, 0, 0)
	end
end)
callback.register("globalPostStep", function(room)
	if backRooms[room] then
		local w, h = graphics.getGameResolution()
		
		local mx, my = input.getMousePos(true)
		
		local b = obj.Highscore:find(1)
		local s = obj.Select:find(1) or obj.SelectCoop:find(1)
		
		if b and b:isValid() then
			b.visible = false
			b:set("choice", 1)
			b:set("gamepad_y", 2)
			if not backButtonHighlight then
				b:set("choice", 0)
				b:set("gamepad_y", 1)
			end
		end
		
		local xx = w * 0.75
		local yy = h - 60
		local hh = h * global.scale
		if hh <= 800 then
			yy = h - 50
		end
		
		if h >= 400 and s and s:get("using_mouse") == 1 then
			local hovering = my >= yy and  mx >= xx
			if hovering and s and s:get("temp_choice") == -1 then
				backButtonHighlight = true
				
				--if input.checkMouse("left") == input.PRESSED then
				--end
			else
				backButtonHighlight = false
			end
		end
	end
end)

-- Last Stage Softlock Prevention
table.insert(call.onStep, function()
	local stage = Stage.getCurrentStage()
	if stage == stg.RiskofRain then
		local command = obj.Command:find(1)
		if command and command:isValid() and command:get("active") == 2 then
			for _, actor in ipairs(pobj.actors:findAll()) do
				if actor:isClassic() then
					if actor.x < 4275 or actor.y < 1050 or actor.y > 1450 then
						actor.x = 4790
						actor.y = 1230
					end
				end
			end
		end
	end
end)

-- Mush jump sprite swap
obj.Mush:addCallback("create", function(self)
	self:setAnimation("jump", self:getAnimation("idle"))
end)

-- Ancient Wisp mask
local sprWispBMask = Sprite.load("WispBMask", "Actors/Ancient Wisp/Mask", 1, 21, 43)
obj.WispB:addCallback("create", function(self)
	self.mask = sprWispBMask
end)

-- Healing for other actors
table.insert(call.postStep, function()
	for _, actor in ipairs(pobj.actors:findMatchingOp("hp_regen", ">", "0")) do
		if not isa(actor, "PlayerInstance") then
			actor:set("hp", math.min(actor:get("hp") + actor:get("hp_regen"), actor:get("maxhp")))
		end
	end
end)

-- Funny typo, hopoo.
it.FirstAidKit.pickupText = "Receive a delayed heal after being hit."
-- i cant fix these it seems
--local dollAchievement = Achievement.find("unlock_doll", "Vanilla")
--dollAchievement.description = "Survive a boss with less than 20% health."

-- Wurm Subtitles (RoRML bug fix)
table.insert(call.preHUDDraw, function()
	if obj.WurmController:find(1) then
		local w, h = graphics.getGameResolution()
		graphics.alpha(1)
		graphics.color(Color.fromHex(0xC0C0C0))
		graphics.print("Hands of Providence", w * 0.5, 36, 1, 1, 0)
	end
end)

-- Timer Sync
local syncTimer = net.Packet.new("SSTime", function(player, tstart, second, minute, alarm)
	misc.director:set("time_start", tstart)
	misc.hud:set("second", second)
	misc.hud:set("minute", minute)
	misc.director:setAlarm(0, alarm)
end)
table.insert(call.onStep, function()
	if net.host and misc.director:get("time_start") % 50 == 0 and misc.director:get("time_start") > 10 then
		syncTimer:sendAsHost(net.ALL, nil, misc.director:get("time_start"), misc.hud:get("second"), misc.hud:get("minute"), misc.director:getAlarm(0))
	end
end)

-- Weird RoRML Toxic Beast Bug?
--[[obj.BoarCorpse:addCallback("create", function(self)
	if not net.host then
		self.y = self.y + 30
	end
end)]]

-- Ghost Removal
local clientClearActor = net.Packet.new("SSClearActor", function(player, netInstance)
	local instance = netInstance:resolve()
	if instance and instance:isValid() then
		pcall(instance.destroy, instance)
	end
end)
local checkHostActor = net.Packet.new("SSCheckActor", function(player, netInstance)
	if not global.rormlflag.ss_disable_hardsync then
		local instance = netInstance:resolve()
		if instance == nil or not instance:isValid() then
			clientClearActor:sendAsHost(net.DIRECT, player, netInstance)
		else
			syncInstanceVar:sendAsHost(net.DIRECT, player, netInstance, "hp", instance:get("hp"))
		end
	end
end)
local checkHostActorMaxhp = net.Packet.new("SSCheckActorMaxhp", function(player, netInstance)
	local instance = netInstance:resolve()
	if instance and instance:isValid() then
		syncInstanceVar:sendAsHost(net.ALL, nil, netInstance, "maxhp", instance:get("maxhp"))
	end
end)

local syncBlacklist = {
	[obj.WormBody] = true,
	[obj.WormHead] = true,
	[obj.WurmBody] = true,
	[obj.WurmHead] = true,
	[obj.POI] = true,
	[obj.Drone1] = true,
	[obj.Drone2] = true,
	[obj.Drone3] = true,
	[obj.Drone4] = true,
	[obj.Drone5] = true,
	[obj.Drone6] = true,
	[obj.Drone7] = true,
	[obj.DroneDisp] = true,
	[obj.ImpFriend] = true
}
if not global.rormlflag.ss_disable_enemies then
	syncBlacklist[obj.SquallElver] = true
end

callback.register("onActorStep", function(actor)
	if net.online and not net.host and global.timer % 50 == 0 and actor:isValid() then
		local actorAc = actor:getAccessor()
		local data = actor:getData()
		if not isa(actor, "PlayerInstance") and not syncBlacklist[actor:getObject()] then
			local pass, netIdentity = pcall(actor.getNetIdentity, actor)
			if pass then
				if actorAc.hp and actorAc.hp <= 0 or actor:isClassic() and actor.y > global.currentStageHeight then
					checkHostActor:sendAsClient(netIdentity)
				elseif actorAc.hp > actorAc.maxhp then
					checkHostActorMaxhp:sendAsClient(netIdentity)
				end
			end
		end
	end
end)

-- Wurm Title Overlap Fix
callback.register("onActorStep", function(actor)
	if actor:isValid() and actor:get("show_boss_health") == 1 and obj.WurmController:find(1) then
		actor:set("show_boss_health", 0)
	end
end)

-- Teleporter EXP Optimization
table.insert(call.onStep, function()
	if net.online then
		for _, tele in ipairs(obj.Teleporter:findAll()) do
			if net.localPlayer:get("dead") == 1 then
				if tele:get("active") > 3 then
					for _, expr in ipairs(obj.EfExp:findAll()) do
						expr.x = net.localPlayer.x
						expr.y = net.localPlayer.y
					end
					break
				end
			end
		end
	end
end)

-- Cremator Position Sync
table.insert(call.onStep, function()
	if net.online and net.host and global.timer % 600 == 0 then
		for _, turtle in ipairs(obj.Turtle:findAll()) do
			syncInstancePosition:sendAsHost(net.ALL, nil, turtle:getNetIdentity(), turtle.x, turtle.y)
		end
	end
end)


-- Player Activity Fix and Invincibility on Tele
local cratePools = {}
callback.register("postLoad", function()
	for _, pool in ipairs(ItemPool.findAll()) do
		local crate = pool:getCrate()
		cratePools[crate] = pool
	end
end)
table.insert(call.onPlayerStep, function(player)
	if player:get("activity") == 95 then
		local matchingCrates = pobj.commandCrates:findMatching("owner", player.id)
		
		if #matchingCrates > 0 then
			if not global.rormlflag.ss_unlock_all then
				for _, crate in ipairs(matchingCrates) do
					local obj = crate:getObject()
					local pool = cratePools[obj]
					
					local t = pool:toList()
					reverseTable(t)
					local itemSelection = t[crate:get("selection") + 1]
					
					if global.itemAchievements[itemSelection] and not global.itemAchievements[itemSelection]:isComplete() then
						crate:set("pressed", 0)
						crate:set("active", 1)
					end
				end
			end
		else
			player:set("activity", 0)
			player:set("activity_type", 0)
		end
	elseif player:get("activity") == 99 and player.visible == false and not global.rormlflag.ss_disable_teleport_immunity then
		player:set("invincible", 2)
	end
end)
-- Locked Command Items
if not global.rormlflag.ss_unlock_all then
table.insert(call.onDraw, function()
	for _, player in ipairs(misc.players) do
		if not net.online or net.localPlayer == player then
			local matchingCrates = pobj.commandCrates:findMatching("owner", player.id)
			if matchingCrates then
				for _, crate in ipairs(matchingCrates) do
					local obj = crate:getObject()
					local pool = cratePools[obj]
					
					local t = pool:toList()
					reverseTable(t)
					
					local width = 393
					local halfWidth = width * 0.5
					local xoffset = crate.x - halfWidth - 19
					local yoffset = crate.y - 146
					local separation = 7
					local boxSize = 33
					local alphaMult = crate:get("fade_alpha") / 0.33
					for i, item in ipairs(t) do
						if global.itemAchievements[item] and not global.itemAchievements[item]:isComplete() then
							local ii = (i) % 10
							if ii > 0 then
								local row = math.floor((i) / 10)
								local x = xoffset + ii * (boxSize + separation)
								local y = yoffset + row * (boxSize + separation)
								graphics.drawImage{
									image = item.sprite,
									x = x + 16,
									y = y + 16,
									subimage = 1,
									solidColor = Color.BLACK,
									alpha = alphaMult
								}
								graphics.drawImage{
									image = spr.Random,
									x = x + 16,
									y = y + 16,
									subimage = 2,
									alpha = alphaMult
								}
								graphics.color(Color.fromHex(0xC74849))
								graphics.alpha(1 * alphaMult)
								graphics.rectangle(x, y, x + boxSize - 1, y + boxSize - 1, true)
							end
						end
					end
				end
			end
		end
	end
end)
end

table.insert(call.onStep, function()
	local teleReady = false
	for _, tele in ipairs(obj.Teleporter:findAll()) do
		if tele:get("active") > 3 then
			teleReady = true
			break
		end
	end
	if teleReady and not obj.EfExp:find(1) then
		for _, player in ipairs(misc.players) do
			if player.visible == false then
				player:set("activity", 99)
				player:set("invincible", 2)
			end
		end
	end
end)

-- lol typos
ar.Spirit.displayName = "Spirit"
sur.HAND:addCallback("init", function(player)
	player:setSkill(4,
	"FORCED_REASSEMBLY",
	"APPLY GREAT FORCE TO ALL COMBATANTS FOR 500% DAMAGE, KNOCKING THEM IN THE AIR.",
	Sprite.find("JanitorSkills", "Vanilla"), 3,
	5 * 60)
end)

-- invinci fix
callback.register("onActorStep", function(actor)
	if actor:isValid() and not actor:isClassic() then
		if actor:get("invincible") and actor:get("invincible") > 0 then
			actor:set("invincible", actor:get("invincible") - 1)
		end
	end
end)

--[[ Multiplayer Survivor Displays (doesnt work oops)
if not global.rormlflag.ss_disable_survivors then
local survivors = survivorList()

local drawOverlay = function()
	local w, h = graphics.getGameResolution()
	local midx, midy = w / 2, h / 2
	
	local startx = midx - 200
end

callback.register("globalRoomStart", function(room)

end)
callback.register("globalStep", function(room)
	if room == rm.SelectCoop then
		local player = obj.PrePlayer:find(1)
		
		if player and player:isValid() then
			local playerAc = player:getAccessor()
			local survivor = survivorFromId(playerAc.class + 1)
			
			if survivor then
				
			end
		end
	end
end)
end]]

-- artifact of glass fix, wew
if not modloader.checkMod("glassFix") then
local baseSurvivorDamage = {}
local levelupSurvivorDamage = {}
callback.register("onPlayerInit", function(player)
	baseSurvivorDamage[player:getSurvivor()] = player:get("damage")
end)
callback.register("onPlayerLevelUp", function(player)
	if ar.Glass.active then
		local survivor = player:getSurvivor()
		if survivor:getOrigin() ~= "Vanilla" then
			if not levelupSurvivorDamage[survivor] then
				levelupSurvivorDamage[survivor] = player:get("damage") - baseSurvivorDamage[survivor]
			end
			player:set("damage", player:get("damage") + levelupSurvivorDamage[survivor] * 2/3)
		end
	end
end)
end

-- Knockback Immunity
table.insert(call.preHit, function(damager, hit)
	if hit:getData().knockbackImmune then
		damager:set("knockback", 0)
		damager:set("knockup", 0)
		damager:set("knockback_glove", 0)
		damager:set("stun", 0)
	elseif hit:getData().affixImmune then
		damager:set("knockback", 0)
		damager:set("knockup", 0)
		damager:set("knockback_glove", 0)
		damager:set("stun", 0)
		damager:set("fear", 0)
		damager:set("freeze", 0)
	end
end)

-- aeiou
par.Dust2:life(90, 240)

-- dumb
obj.Imp:addCallback("create", function(self)
	self:set("name", "Black Imp") -- for some reason modloader renamed them to "Portal Imp"
end)

-- kill out of map enemies
table.insert(call.onStep, function()
	local _, stageHeight = Stage.getDimensions()
	for _, enemy in ipairs(pobj.enemies:findMatchingOp("y", ">", stageHeight - 2)) do
		if enemy:isClassic() and not enemy:getData().noFallDeath then
			enemy:kill()
		end
	end
end)

-- difficulty display text getting out of the box looks weeeeeird
if not global.rormlflag.ss_disable_reskin then
	table.insert(call.onHUDDraw, function()
		if misc.hud:get("show_time") ~= 0 then
			local diffString = misc.hud:get("difficulty")
			local width = graphics.textWidth(diffString, graphics.FONT_DEFAULT)
			if width > 60 then
				local w, _ = graphics.getHUDResolution()
				local ww = width - 60
				
				local xoff, yoff = 31, 42
				graphics.alpha(0.32)
				graphics.color(Color.fromHex(0x1A1A1A))
				graphics.rectangle(w - xoff - width - 1, yoff, w - xoff - 61, yoff + 14, false)
				graphics.alpha(1)
				graphics.color(Color.fromHex(0xC0C0C0))
				graphics.print(diffString, w - xoff + 4, yoff + 3, graphics.FONT_DEFAULT, graphics.ALIGN_RIGHT, graphics.ALIGN_TOP)
			end
		end
	end)
end
--[[table.insert(call.postStep, function()  -- seems like this makes the game scream. HOPOOOOOOOOOO
	if misc.hud:get("difficulty") == "IM COMING FOR YOU" then
		misc.hud:set("difficulty", "I'M COMING FOR YOU")
	end
end)]]

-- Skill description fix
sur.Loader:setLoadoutSkill(1, "Knuckleboom",
[[Batter nearby enemies for &y&120%&!&. Every third hit deals
&y&240 and knocks up enemies.]]) -- nitpicky me

-- Cooldown reset on stage entry
table.insert(call.onStageEntry, function()
	for _, player in ipairs(misc.players) do
		player:setAlarm(2, 0)
		player:setAlarm(3, 0)
		player:setAlarm(4, 0)
		player:setAlarm(5, 0)
	end
end)

-- Fix Direseeker despawn
table.insert(call.onStep, function()
	for _, actor in ipairs(obj.LizardGS:findAll()) do
		actor:set("death_timer", 3000)
	end
end)

-- Less item pickup delay on singleplayer
callback.register("onItemInit", function(item)
	if #misc.players == 1 then
		item:setAlarm(0, item:getAlarm(0) * 0.5)
	end
end)

-- Tp and door sync
table.insert(call.onStep, function()
	if net.online and net.host and global.timer % 300 == 0 then
		for _, tele in ipairs(obj.Teleporter:findAll()) do
			local t = tele:get("time")
			if t < tele:get("maxtime") then
				syncInstanceVar:sendAsHost(net.ALL, nil, tele:getNetIdentity(), "time", t)
			end
		end
		for _, door in ipairs(obj.BlastdoorPanel:findAll()) do
			local t = door:get("time")
			if t < door:get("maxtime") then
				syncInstanceVar:sendAsHost(net.ALL, nil, door:getNetIdentity(), "time", t)
			end
		end
	end
end)

-- Fix hyper-threader angle
obj.EfBlaster:addCallback("create", function(self)
	local nearPlayer = obj.P:findNearest(self.x, self.y)
	if nearPlayer then
		self:getData().redirect = nearPlayer:getFacingDirection()
	end
end)
table.insert(call.onStep, function()
	for _, self in ipairs(obj.EfBlaster:findAll()) do
		if self:getData().redirect then
			self:set("direction", self:getData().redirect)
			self:getData().redirect = nil
		end
	end
end)

-- muh pronouns
callback.register("onItemPickup", function(item, player)
	if item:isValid() and item:getItem() == it.Ukulele then
		local survivor = player:getSurvivor()
		if survivor.endingQuote:find("she left") then
			item:set("text2", "..and her music was electric.")
		elseif survivor.endingQuote:find("they left") then
			item:set("text2", "..and their music was electric.")
		elseif survivor.endingQuote:find("it left") then
			item:set("text2", "..and its music was electric.")
		end
	end
end)

-- Multiplayer interactable scaling
if not global.rormlflag.ss_disable_mp_chest_scaling then
	local interactables = {}
	callback.register("postLoad", function()
		for _, interactable in ipairs(Interactable.findAll()) do
			interactables[interactable] = interactable.spawnCost
		end
	end)

	local playerCount = 1

	callback.register("globalRoomEnd", function(room)
		if not misc.getIngame() then
			local count = 1
			if room == rm.SelectMult then
				count = #obj.PrePlayer:findAll()
			elseif room == rm.SelectCoop then
				local sCoop = obj.SelectCoop:find(1)
				if sCoop and sCoop:isValid() then
					count = sCoop:get("player_max_chosen")
				end
			end
			if count > 0 then
				playerCount = count
			end
		end
	end)

	callback.register("onGameStart", function()
		for interactable, spawnCost in pairs(interactables) do
			interactable.spawnCost = spawnCost / math.max(playerCount * 0.7, 1)
		end
	end)
end

--[[ Shield display
table.insert(call.onPlayerStep, function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	if not playerData.shieldDis and playerAc.maxshield > 0 and playerAc.shield > 0 then
		playerData.shieldDis = obj.EfOutline:create(0, 0):set("persistent", 1):set("parent", player.id):set("rate", 0)
		playerData.shieldDis.blendColor = Color.fromHex(0x44AA73)
	elseif playerData.shieldDis then
		if playerData.shieldDis:isValid() then
			playerData.shieldDis:destroy()
		end
		playerData.shieldDis = nil
	end
end)]]

-- Jelly Force Sync
local syncJelly = net.Packet.new("SSSJ", function(player, actorId, x, y)
	local actor = actorId:resolve()
	if actor and actor:isValid() then
		actor.x = x
		actor.y = y
	end
end)
table.insert(call.onStep, function()
	if net.online and net.host and global.timer % 90 then
		local r = 100
		for _, player in ipairs(misc.players) do
			if player ~= net.localPlayer then
				for _, jelly in ipairs(obj.Jelly:findAllRectangle(player.x - r, player.y - r, player.x + r, player.y + r)) do
					syncJelly:sendAsHost(net.ALL, nil, jelly:getNetIdentity(), jelly.x, jelly.y)
				end
			end
		end
	end	
end)


-- MP profile flag warning
local desyncFlags = {
	"ss_disable_survivors",
	"ss_disable_enemies",
	"ss_disable_drones",
	"ss_disable_items",
	"ss_disable_relics",
	"ss_disable_artifacts",
	"ss_disable_submenu",
	"ss_disable_skins",
	"ss_disable_bettercrates",
	"ss_og_spikestrip",
	"ss_og_snakeeyes",
	"ss_og_repairkit",
	"ss_og_headstompers",
	"ss_og_lantern",
	"ss_classic_weakening_elites",
	"ss_april_fools",
	"ss_halloween",
	"ss_april_fools_2020"
}
local drawWarning = false
local foundFlagString = ""
for _, flag in ipairs(desyncFlags) do
	if global.rormlflag[flag] then
		drawWarning = true
		foundFlagString = foundFlagString.."-'"..flag.."'\n"
	end
end
local drawWarningScreenHost = function()
	local hostStr = "The following flags might be clientside only.\nMake sure others have them too!\n"
	graphics.alpha(0.5)
	graphics.color(Color.YELLOW)
	graphics.print(hostStr..foundFlagString, 6, 6, graphics.FONT_SMALL)
end
local drawWarningScreenClient = function()
	local clientStr = "The following flags might be clientside only.\nMake sure the host has them too!\n"
	graphics.alpha(0.5)
	graphics.color(Color.GRAY)
	graphics.print(clientStr..foundFlagString, 6, 6, graphics.FONT_SMALL)
end
if drawWarning then
	callback.register("globalRoomStart", function(room)
		if room == rm.SelectMult then
			if obj.PrePlayer:find(1) then
				graphics.bindDepth(-99, drawWarningScreenHost)
			else
				graphics.bindDepth(-99, drawWarningScreenClient)
			end
		end
	end)
end

-- Taller Baby Imp Mask
local sprImpMask = Sprite.load("ImpMMask", "Actors/ImpM/mask", 1, 3, 10)
obj.ImpM:addCallback("create", function(self)
	self.mask = sprImpMask
end)

--[[ Sound List (debug)
callback.register("onHUDDraw", function()
	local playingSounds = {}
	for _, sound in ipairs(Sound.findAll()) do
		if sound:isPlaying() then
			table.insert(playingSounds, sound)
		end
	end
	graphics.color(Color.WHITE)
	graphics.alpha(1)
	for i, sound in ipairs(playingSounds) do
		graphics.print(sound:getName(), 10, 10 * i)
	end
end)]]

-- Force Item Share removal
if not global.rormlflag.ss_restore_item_share then
	callback.register("globalRoomStart", function()
		local f = obj.FairItemButton:find(1)
		if f then 
			f:set("speed", 9999)
		end
	end)
end

-- Fire, why do you do this
obj.FireTrail:addCallback("create", function(self)
	for _, i in ipairs(obj.FireTrail:findAllLine(self.x - 1, self.y - 1, self.x + 1, self.y + 1)) do
		if i ~= self then
			self:getData().destroy = true
			break
		end
	end
end)
callback.register("postStep", function()
	for _, i in ipairs(obj.FireTrail:findAll()) do
		if i:getData().destroy then
			i:destroy()
		end
	end
end)

local destroyedObjects = {obj.EfDamage, obj.EfCircle, obj.EfFireworkBurst, obj.EfSparks}
callback.register("postStep", function()
	for _, object in ipairs(destroyedObjects) do
		for _, instance in ipairs(object:findAll()) do
			if not onScreenPos(instance.x, instance.y) then
				instance:destroy()
			end
		end
	end
end)

-- sync ss_stable
local tempStable = false
local evolvedLemStages = {}
local syncStable = net.Packet.new("SSstable", function()
	if not global.rormlflag.ss_stable then
		global.rormlflag.ss_stable = true
		tempStable = true
	end
end)
callback.register("onGameStart", function()
	if net.host then
		syncStable:sendAsHost(net.ALL, nil)
	end
end)
callback.register("onGameEnd", function()
	if tempStable then
		global.rormlflag.ss_stable = false
		for stage, _ in pairs(evolvedLemStages) do
			stage.enemies:add(mcard["Evolved Lemurian"])
			evolvedLemStages[stage] = nil
		end
	end
end)

callback.register("postSelection", function()
	if global.rormlflag.ss_stable then
		for _, stage in ipairs(Stage.findAll()) do
			if stage.enemies:contains(mcard["Evolved Lemurian"]) then
				stage.enemies:remove(mcard["Evolved Lemurian"])
				evolvedLemStages[stage] = true
			end
		end
	end
end)

-- Locked item rolling fix (rorml bug)
local items = {}
for _, item in ipairs(Item.findAll("Vanilla")) do
	items[item.sprite] = item
end

local achievementItems = {}
for _, achievement in ipairs(Achievement.findAll("Vanilla")) do
	if items[achievement.sprite] then
		achievementItems[items[achievement.sprite]] = achievement
	end
end
items = nil

--[[local removedFromPools = {}
callback.register("onGameStart", function()
	for item, achievement in pairs(achievementItems) do
		if achievement:isComplete() then --or ar.Command.active then
			if removedFromPools[item] then
				for _, pool in ipairs(removedFromPools[item]) do
					pool:add(item)
				end
				removedFromPools[item] = nil
			end
		else
			for _, pool in ipairs(ItemPool.findAll()) do
				if pool:contains(item) then
					if not removedFromPools[item] then
						removedFromPools[item] = {}
					end
					table.insert(removedFromPools[item], pool)
					pool:remove(item)
				end
			end
		end
	end
end)]]
do
local fixedPools = {}
callback.register("onGameStart", function()
	for _, pool in ipairs(ItemPool.findAll("vanilla")) do
		fixedPools[pool] = {}
		for _, item in ipairs(pool:toList()) do
			if not achievementItems[item] or achievementItems[item]:isComplete() then
				table.insert(fixedPools[pool], item)
			end
		end
	end
end)
callback.register("onItemRoll", function(pool, item)
	if achievementItems[item] then
		if not achievementItems[item]:isComplete() and fixedPools[pool] then -- doesnt account for modded pools atm hmmmmmmm
			return table.irandom(fixedPools[pool])
		end
	end
end)
end

-- um, electricity friendly fire fix...............
callback.register("postStep", function()
	for _, lightning in ipairs(obj.ChainLightning:findAll()) do
		if not lightning:getData().fix then
			lightning:getData().fix = true
			lightning:set("team", string.gsub(lightning:get("team"), "proc", ""))
		end
	end
end)
--[[callback.register("onDamage", function(target, damage, source)
	if source and source:get("team") == (target:get("team") or "").."proc" then
		return true
	end
end)]]

-- lol
obj.GolemG:addCallback("create", function(self)
	self:set("point_value", 760)
end)