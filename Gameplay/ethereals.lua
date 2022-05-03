

local difficultySprites = {
	Drizzle = spr.DifficultyDrizzle,
	Rainstorm = spr.DifficultyRainstorm,
	Monsoon = spr.DifficultyMonsoon
}

local vanillaSprites = {
	Drizzle = Sprite.clone(spr.DifficultyDrizzle),
	Rainstorm = Sprite.clone(spr.DifficultyRainstorm),
	Monsoon = Sprite.clone(spr.DifficultyMonsoon)
}

local newSprites = {
	Drizzle = Sprite.load("Difficulty_Drizzle", "Gameplay/HUD/difDrizzle", 3, 13, 11),
	Rainstorm = Sprite.load("Difficulty_Rainstorm", "Gameplay/HUD/difRainstorm", 3, 13, 11),
	Monsoon = Sprite.load("Difficulty_Monsoon", "Gameplay/HUD/difMonsoon", 3, 13, 11),
	TyphoonMenu = Sprite.load("Difficulty_TyphoonMenuO", "Gameplay/HUD/difTyphoonMenu", 3, 13, 11),
	Typhoon = Sprite.load("Difficulty_Typhoon", "Gameplay/HUD/difTyphoon", 3, 13, 11),
}

local ethSprites = {
	Deluge = Sprite.load("Difficulty_Deluge", "Gameplay/HUD/difDeluge", 3, 13, 11),
	Tempest = Sprite.load("Difficulty_Tempest", "Gameplay/HUD/difTempest", 3, 13, 11),
	Cyclone = Sprite.load("Difficulty_Cyclone", "Gameplay/HUD/difCyclone", 3, 13, 11),
	SuperTyphoon = Sprite.load("Difficulty_SuperTyphoon", "Gameplay/HUD/difSTyphoon", 3, 14, 11)
}

local ultraBlacklist = {
	[obj.Worm] = true,
	[obj.WormHead] = true,
	[obj.WormBody] = true,
	[obj.WurmController] = true,
	[obj.WurmHead] = true,
	[obj.WurmBody] = true,
	[obj.BoarM] = true,
	[obj.LizardF] = true,
	[obj.LizardFG] = true
}
if not global.rormlflag.ss_disable_enemies then
	ultraBlacklist[obj.TotemPart] = true
	ultraBlacklist[obj["Squall Elver Body"]] = true
	ultraBlacklist[obj["Squall Elver"]] = true
	ultraBlacklist[obj.Arraign1] = true
	ultraBlacklist[obj.WyvernHead] = true
	ultraBlacklist[obj.WyvernTail] = true
end

local ultraProvidence = {
	[obj.Boss1] = true,
	[obj.Boss3] = true
}

local objFlash = obj.EfLaserBlast
local sUltraSpawn = Sound.load("UltraSpawn", "Misc/SFX/ultraSpawn")
local sprUltraSpawn = Sprite.load("Ultra_Spawn", "Gameplay/ultraSpawn", 6, 22, 190)
local parUltraMain = ParticleType.find("UltraMain", "Starstorm")
local buffUltra = Buff.find("ultra", "Starstorm")


local hardmode = 0

local doTitle
local titleTimer = 0

local function updateHardmode()
	if hardmode > 0 then
		sfx.Difficulty:play()
		
		difficultySprites.Drizzle:replace(ethSprites.Deluge)
		difficultySprites.Rainstorm:replace(ethSprites.Tempest)
		difficultySprites.Monsoon:replace(ethSprites.Cyclone)
		dif.Typhoon.icon:replace(ethSprites.SuperTyphoon)
		for _, player in ipairs(misc.players) do
			if player:get("maxhpcap") == 9999 then
				player:set("maxhpcap", 99999)
			end
		end
		
		doTitle = 1
		titleTimer = 280
	else
		difficultySprites.Drizzle:replace(newSprites.Drizzle)
		difficultySprites.Rainstorm:replace(newSprites.Rainstorm)
		difficultySprites.Monsoon:replace(newSprites.Monsoon)
		dif.Typhoon.icon:replace(newSprites.Typhoon)
		
		doTitle = -1
		titleTimer = 280
	end
	if hardmode > 0 and getRule(5, 2) ~= false then
		toggleElites({elt.Ethereal}, true)
	else
		toggleElites({elt.Ethereal}, false)
	end
	
	extraDifficultyUpdateCallback(hardmode)
end
callback.register("onGameStart", function()
	toggleElites({elt.Ethereal}, false)
end)


local etherealRooms = {
	[rm["1_1_2"]] = {x = 1201, y = 1552},
	[rm["1_2_1"]] = {x = 3569, y = 892},
	[rm["2_2_1"]] = {x = 401, y = 1216},
	[rm["2_1_1"]] = {x = 3105, y = 224, depth = 13},
	[rm["3_1_1"]] = {x = 512, y = 3440},
	[rm["3_2_2"]] = {x = 2577, y = 2064},
	[rm["4_1_2"]] = {x = 129, y = 1168},
	[rm["4_2_2"]] = {x = 3201, y = 144},
	[rm.Overgrowth] = {x = 176, y = 666},
	[rm["5_1_1"]] = {x = 2449, y = 2046},
	[rm.UnchartedMountain] = {x = 2817, y = 3360},
	[rm.StrayTarn] = {x = 4194, y = 1920},
	[rm.SlateMinesVariant] = {x = 314, y = 432},
	[rm.TorridOutlands] = {x = 966, y = 1040},
	[rm.WhistlingBasinVariant] = {x = 2208, y = 1008}
}

export("ExtraDifficulty")
function ExtraDifficulty.set(number)
	if type(number) == "number" then
		hardmode = math.max(number, 0)
		updateHardmode()
	else
		error("Invalid value, number expected, got "..type(number), 2)
	end
end

function ExtraDifficulty.getCurrent()
	return hardmode
end

function ExtraDifficulty.setRoomTeleporter(room, x, y)
	if isa(room) == "Room" then
		if type(x) == "number" then
			if type(y) == "number" then
				etherealRooms[room] = {x = x, y = y}
			else
				error("Invalid value, number expected, got "..type(y), 2)
			end
		else
			error("Invalid value, number expected, got "..type(x), 2)
		end
	else
		error("Invalid value, Room expected, got "..type(room), 2)
	end
end


local objPlayer = obj.P

local sprBigTeleporter = Sprite.load("Teleporter_Big", "Interactables/Resources/bigTeleporter", 2, 53, 60)
local sBigTeleporter = Sound.load("BigTeleporter", "Misc/SFX/bigTeleporter")
obj.BigTeleporter = Object.new("BigTeleporter")
obj.BigTeleporter.sprite = sprBigTeleporter
obj.BigTeleporter.depth = 12.5

function makeEthereal(teleporter)
	teleporter.sprite = sprBigTeleporter
	teleporter.depth = 12.5
	teleporter:set("isBig", 1)
	teleporter:set("locked", 1)
	teleporter:set("maxtime", teleporter:get("maxtime") * (1 + ((1 + hardmode) * 0.25)))
	teleporter:getData().step = 0
end

obj.BigTeleporter:addCallback("create", function(self)
	local teleporter = obj.Teleporter:create(self.x, self.y)
	teleporter:set("m_id", 33)
	makeEthereal(teleporter)
end)

obj.BigTeleporter:addCallback("step", function(self)
	self:destroy()
end)

callback.register("onGameStart", function()
	difficultySprites.Drizzle:replace(newSprites.Drizzle)
	difficultySprites.Rainstorm:replace(newSprites.Rainstorm)
	difficultySprites.Monsoon:replace(newSprites.Monsoon)
	dif.Typhoon.icon:replace(newSprites.Typhoon)
	hardmode = 0
end)

callback.register("onGameEnd", function()
	difficultySprites.Drizzle:replace(vanillaSprites.Drizzle)
	difficultySprites.Rainstorm:replace(vanillaSprites.Rainstorm)
	difficultySprites.Monsoon:replace(vanillaSprites.Monsoon)
	dif.Typhoon.icon:replace(newSprites.TyphoonMenu)
	hardmode = 0
end)


local adversityBlacklist = {
	[stg.Void] = true,
	[stg.VoidShop] = true,
	[stg.PaulsLand] = true,
	[stg.RedPlane] = true,
	[stg.BoarBeach] = true
}

table.insert(call.onStageEntry, function()
	local stage = Stage.getCurrentStage()
	if not adversityBlacklist[stage] then
		if runData.adversityStageCount then runData.adversityStageCount = runData.adversityStageCount + 1 else runData.adversityStageCount = 1 end
	end
	
	local etherealData = etherealRooms[Room.getCurrentRoom()]
	if etherealData and getRule(5, 4) == true then
		if ar.Adversity and not ar.Adversity.active or (runData.adversityStageCount) % 5 ~= 0 and runData.adversityStageCount > 0 then
			local teleporter = obj.BigTeleporter:create(etherealData.x, etherealData.y)
			teleporter:set("m_id", 33)
			if etherealData.depth then
				teleporter.depth = etherealData.depth
			end
		end
	end
	if stage == stg.RiskofRain and hardmode > 0 then
		local ground = obj.B:create(4810, 1296)
		ground.xscale = 60
		ground.yscale = 0.5
	end
end)

local syncDiff = net.Packet.new("SSDifficulty", function(player, hhardmode)
	hardmode = hhardmode
	updateHardmode()
end)

local syncTele
syncTele = net.Packet.new("SSTeleporter", function(sender, teleporter)
	if teleporter and teleporter:resolve() then
		local teleInstance = teleporter:resolve()
		local teleporterAc = teleInstance:getAccessor()
		teleporterAc.active = 1
		teleporterAc.locked = 0
		if teleInstance:get("isBig") then
			teleInstance:getData().step = 12
		end
		if net.host then
			syncTele:sendAsHost(net.EXCLUDE, sender, teleporter)
		end
	end
end)

table.insert(call.onStep, function()
	local teleActive = nil
	for _, teleporter in ipairs(obj.Teleporter:findAll()) do
		if teleporter:get("active") > 0 then
			teleActive = teleporter
			--syncTele:sendAsHost(net.ALL, nil, teleporter:getNetIdentity(), 1, 0)
			break
		end
	end
	for _, teleporter in ipairs(obj.Teleporter:findAll()) do
		if teleActive and teleActive ~= teleporter then
			if teleporter:get("active") > 0 or not teleporter:getData().lock then
				teleporter:set("active", 0)
				teleporter:set("locked", 1)
				teleporter:getData().lock = true
				--if net.host then
					--syncTele:sendAsHost(net.ALL, nil, teleporter:getNetIdentity(), 0,0) --1)
				--else
					--hostSyncTele:sendAsClient(teleporter:getNetIdentity(), 0, 1)
				--end	
			end
		end
	end
	if hardmode > 0 then
		director = misc.director:getAccessor()
		if #pobj.enemies:findMatchingOp("team", "==", "enemy") < 50 then
			if misc.director:getAlarm(0) == 1 and director.time_start % 75 == 0 then
				misc.director:setAlarm(1, 1)
			end
			if misc.director:getAlarm(0) == 1 and director.time_start % 90 == 0 then
				director.points = director.points + ((director.time_start * 0.02) * hardmode)
			end
		end
	end
	for _, teleporter in ipairs(obj.Teleporter:findMatchingOp("isBig", "==", 1)) do
		local teleporterAc = teleporter:getAccessor()
		
		teleporter:getData().display  = nil
		local player = objPlayer:findRectangle(teleporter.x - 50, teleporter.y - 30, teleporter.x + 50, teleporter.y + 1)
		if teleporterAc.locked == 1 and teleporterAc.active == 0 then
			if player and player:isValid() and not teleporter:getData().lock then
			
				local acceptInput = input.getControlString("enter", player)
				local gamepad = input.getPlayerGamepad(player)
				
				if teleporter:getData().step == 0 then
					if gamepad then
						teleporter:getData().display = "Press '"..acceptInput.."' to activate the ethereal teleporter"
					else
						teleporter:getData().display = "Press &y&'"..acceptInput.."'&!& to activate the ethereal teleporter"
					end
				elseif teleporter:getData().step == 1 then
					if hardmode == 0 then
						if gamepad then
							teleporter:getData().display = "This will radically increase the difficulty. Press '"..acceptInput.."'&!& to confirm"
						else
							teleporter:getData().display = "This will radically increase the difficulty. Press &y&'"..acceptInput.."' to confirm"
						end
					else
						if gamepad then
							teleporter:getData().display = "This will radically increase the difficulty (even more!). Press '"..acceptInput.."' to confirm"
						else
							teleporter:getData().display = "This will radically increase the difficulty (even more!). Press &y&'"..acceptInput.."'&!& to confirm"
						end
					end
				else
					if net.host then
						syncTele:sendAsHost(net.ALL, nil, teleporter:getNetIdentity())
					else
						syncTele:sendAsClient(teleporter:getNetIdentity())
					end					
					teleporterAc.active = 1
					teleporterAc.locked = 0
				end
				
				if player:control("enter") == input.PRESSED then
					teleporter:getData().step = teleporter:getData().step + 1
				end
			end
		end
		
		if teleporter:getData().step > 1 then
			if teleporterAc.active > 0 and teleporter:getData().soundPlayed == nil then
				teleporter:getData().soundPlayed = 1
				sBigTeleporter:play(0.9 + math.random() * 0.2)
				obj.ImpPortal:create(teleporter.x, teleporter.y - 50)
			end
			if teleporterAc.active > 1 then
				runData.pendingEtheral = true
			end
			if teleporterAc.active > 4 and not teleporter:getData().lock then
				--[[Scores.updateValue(sco.ethereal, Scores.getValue(sco.ethereal) + 1)
				hardmode = hardmode + 1
				if net.online and net.host then
					syncDiff:sendAsHost(net.ALL, nil, hardmode)
				end	
				updateHardmode()]]
				teleporter:getData().lock = true
			end
		end
	end
end)

table.insert(call.onDraw, function()
	for _, teleporter in pairs(obj.Teleporter:findMatchingOp("isBig", "==", 1, "locked", "==", 1)) do
		if teleporter:getData().display then
			graphics.setBlendMode("normal")
			graphics.color(Color.WHITE)
			graphics.alpha(1)
			local length = graphics.textWidth(teleporter:getData().display, 1) / 2
			graphics.printColor(teleporter:getData().display, teleporter.x - length + 25, teleporter.y - 45)
		end
	end
end)

table.insert(call.onStageEntry, function()
	if runData.pendingEtheral then
		Scores.updateValue(sco.ethereal, Scores.getValue(sco.ethereal) + 1)
		if net.host then
			hardmode = hardmode + 1
			if net.online then
				syncDiff:sendAsHost(net.ALL, nil, hardmode)
			end
		end
		updateHardmode()
		runData.pendingEtheral = false
	end
end)

local function makeHardmodeActor(actor)
	local actorAc = actor:getAccessor()
	
	local hardmult = hardmode
	
	if getRule(5, 8) == true then
		if hardmult == 0 then
			hardmult = 1
		end
	end
	
	if hardmode > 0 then
		actorAc.maxhp = actorAc.maxhp * (1 + 0.18 * hardmult)
		actorAc.hp = actorAc.maxhp
		actorAc.damage = actorAc.damage * (1 + 0.22 * hardmult)
	end
	actor:getData()._hardmodeEdited = true
end

local function makeUltra(actor, ultra)
	local actorAc = actor:getAccessor()
	
	local hardmult = math.max(hardmode, 1)
	
	--[[if getRule(5, 8) == true then
		if hardmult == 0 then
			hardmult = 1
		end
	end]]
	
	local image = actor.mask or actor.sprite
	local off = (image.height - image.yorigin)
	actor.y = actor.y - off
	
	actorAc.point_value = actorAc.point_value * (15 * hardmult)
	misc.shakeScreen(5)
	sUltraSpawn:play(0.9 + math.random() * 0.2)
	objFlash:create(0, -100)
	local lightning = obj.EfSparks:create(actor.x, actor.y)
	lightning.sprite = sprUltraSpawn
	lightning.xscale = 1
	lightning.yscale = 1
	actorAc.isUltra = 1
	if not ultraProvidence[actor:getObject()] then
		actorAc.ultraAspect = 1
	end
	actorAc.name = "Ultra "..actorAc.name
	actorAc.blast = 1
	if actorAc.exp_worth then
		actorAc.exp_worth = math.min(actorAc.exp_worth * (20 * hardmult), 5000000)
	end
	if actorAc.knockback_cap then
		actorAc.knockback_cap = actorAc.knockback_cap * (20 * hardmult)
	end
	actorAc.attack_speed = actorAc.attack_speed * 0.75
	if actorAc.z_range then actorAc.z_range = actorAc.z_range * 2 end
	if actorAc.x_range then actorAc.x_range = actorAc.x_range * 2 end
	if actorAc.c_range then actorAc.c_range = actorAc.c_range * 2 end
	if actorAc.v_range then actorAc.v_range = actorAc.v_range * 2 end
	if ultraProvidence[actor:getObject()] then
		if not obj.WurmController:find(1) then
			actorAc.show_boss_health = 1
		end
		actorAc.maxhp = actorAc.maxhp * (3.6 * hardmult)
		actorAc.damage = actorAc.damage * (1 + 0.7 * hardmult)
		actorAc.name2 = "Overruling Denouement"
	else
		if actorAc.name2 == nil or actorAc.name2 == "" then
			actorAc.name2 = "Entity"
		end
		local object = actor:getObject()
		if not obj.WurmController:find(1) then
			actorAc.show_boss_health = 1
		end
		actor.yscale = 2
		actor.xscale = math.sign(actor.xscale) * 2 
		actorAc.maxhp = actorAc.maxhp * (13 * hardmult)
		if actorAc.damage then
			actorAc.damage = actorAc.damage * (9.8 * hardmult)
		end
		actorAc.pHmax = actorAc.pHmax * 0.5
		actorAc.name2 = "Abiding "..actorAc.name2
		
		if object == obj.TotemController then
			for _, part in ipairs(actor:getData().parts) do
				part:set("maxhp", actorAc.maxhp / 4)
				part:set("hp", part:get("maxhp"))
			end
		elseif object == obj.Wyvern then
			if actor:getData().head and actor:getData().head:isValid() then
				actor:getData().head:set("maxhp", actorAc.maxhp)
				actor:getData().head:set("hp", actorAc.maxhp)
			end
			if actor:getData().tail and actor:getData().tail:isValid() then
				actor:getData().tail:set("maxhp", actorAc.maxhp)
				actor:getData().tail:set("hp", actorAc.maxhp)
			end
		end
		
	end
	actorAc.armor = actorAc.armor + (75 * hardmult)
	actorAc.hp = actorAc.maxhp
end

local syncUltra = net.Packet.new("SSUltra", function(player, actor)
	if actor then
		local inst = actor:resolve()
		if inst and inst:isValid() then
			if not inst:get("isUltra") then
				makeUltra(inst)
			end
		end
	end
end)

callback.register("onTrueActorInit", function(actor)
	if hardmode > 0 and getRule(5, 6) == true or getRule(5, 8) == true then
		local actorAc = actor:getAccessor()
		local hardmult = hardmode
		
		if getRule(5, 8) == true then
			if hardmult == 0 then
				hardmult = 1
			end
		end
		
		local actorObject = actor:getObject()
		
		if hardmode > 0 and not ultraProvidence[actorObject] and not actor:getData().isNemesis and Stage.getCurrentStage() ~= stg.Unknown then
			actor:set("show_boss_health", 0)
		end
		
		if actorAc.team == "enemy" and not ultraBlacklist[actor:getObject()] and not actor:getData().isNemesis then
			makeHardmodeActor(actor)
			
			if net.host and math.chance((1 + (misc.director:get("time_start") * (0.001 * hardmult)) * getRule(5, 10))) and math.chance(misc.director:get("time_start") * (0.07 * hardmult)) and misc.director:get("points") >= actorAc.point_value * (15) or ultraProvidence[actorObject] and hardmode > 0 then
				misc.director:set("points", misc.director:get("points") - actorAc.point_value * (15) )
				
				if net.online then
					actor:getData()._ultradelay = 3
				else
					makeUltra(actor)
				end
			end
		end
	end
end)

callback.register("onActorStep", function(actor)
	if actor:getData()._ultradelay then
		if actor:getData()._ultradelay == 0 then
			actor:getData()._ultradelay = nil
			syncUltra:sendAsHost(net.ALL, nil, actor:getNetIdentity())
			makeUltra(actor)
		else
			actor:getData()._ultradelay = actor:getData()._ultradelay - 1
		end
	end
end)

local onStepCall = function()
	if hardmode > 0 or getRule(5, 8) == true then
		for _, actor in pairs(pobj.actors:findMatchingOp("isUltra", "==", 1)) do
			if actor:get("isUltra") then
				if not ultraProvidence[actor:getObject()] then
					if math.abs(actor.xscale) == 1 then
						actor.xscale = actor.xscale * 2
					end
					if math.abs(actor.yscale) == 1 then
						actor.yscale = actor.yscale * 2
					end
				end
				passes = 2
				actor:set("hp", math.min(actor:get("hp") + (actor:get("maxhp") * (0.000003 * hardmode)), actor:get("maxhp")))
			else
				actor:set("hp", math.min(actor:get("hp") + (actor:get("maxhp") * (0.00001 * hardmode)), actor:get("maxhp")))
			end
			
			actor:set("death_timer", 3000)
			if global.quality == 3 then
				parUltraMain:burst("above", actor.x, actor.y, 1)
			elseif global.quality == 2 and math.chance(40) then
				parUltraMain:burst("above", actor.x, actor.y, 1)
			end
			if actor:isClassic() then
				local n = 0
				while actor:collidesMap(actor.x, actor.y - (n * 2)) and n < 55 do
					n = n + 1
				end
				if not actor:collidesWith(obj.BNoSpawn, actor.x, actor.y - (n * 2) + 2) then
					actor.y = actor.y - n * 2
				end
			end
			local r = 125
			for _, subActor in pairs(pobj.actors:findAllEllipse(actor.x - r, actor.y - r, actor.x + r, actor.y + r)) do
				if subActor:get("team") == actor:get("team") and not subActor:get("isUltra") then
					subActor:applyBuff(buffUltra, 120)
				end
			end
		end
	end
end
local postStepCall = function()
	if hardmode > 0 or getRule(5, 8) == true then
		for _, actor in pairs(pobj.actors:findMatchingOp("isUltra", "==", 1)) do
			--if not actor:isClassic() then
			if not ultraProvidence[actor:getObject()] then
				actor.xscale = math.sign(actor.xscale) * 2
				actor.yscale = math.sign(actor.yscale) * 2 
			end
		end
	end
end

local onDrawCall = function()
	if hardmode > 0 or getRule(5, 8) == true then
		for _, actor in pairs(pobj.actors:findMatchingOp("ultraAspect", "==", 1)) do
			if onScreen(actor) then
				local passes = 1
				if actor:get("isUltra") then
					passes = 2
				end
				for i = 0, passes do
					graphics.drawImage{
						image = actor.sprite,
						x = actor.x,
						y = actor.y,
						subimage = actor.subimage,
						alpha = 0.25,
						color = Color.fromHex(0x35896A),
						angle = actor.angle,
						width = actor.sprite.width + math.random(-3, 3),
						height = actor.sprite.height + math.random(-3, 3),
						xscale = actor.xscale,
						yscale = actor.yscale
					}
				end
			end
		end
		for _, actor in pairs(pobj.actors:findMatchingOp("isUltra", "==", 1)) do
			graphics.setBlendMode("subtract")
			graphics.color(Color.BLACK)
			graphics.alpha(0.15)
			graphics.circle(actor.x, actor.y, 125, false)
			graphics.setBlendMode("additive")
			graphics.color(Color.fromHex(0x35896A))
			graphics.circle(actor.x, actor.y, 125, true)
		end
	end
end

local onHUDDrawCall = function()
	local w, h = graphics.getHUDResolution()
	if hardmode > 1 and misc.hud:get("show_time") == 1 then
		graphics.alpha(1)
		graphics.color(Color.fromHex(0x332B3C))
		graphics.print(hardmode, w - 79, 26, FONT_DEFAULT, ALIGN_MIDDLE, ALIGN_CENTER)
		graphics.color(Color.fromHex(0xC0C0C0))
		graphics.print(hardmode, w - 80, 25, FONT_DEFAULT, ALIGN_MIDDLE, ALIGN_CENTER)
	end
	if doTitle then
		if math.round(misc.hud:get("title_alpha")) == 0 then
			if titleTimer > 0 then
				titleTimer = titleTimer - 1
				
				local alpha = math.min(titleTimer, 240 - titleTimer) * 0.05
				
				local text = "Difficulty Up"
				if doTitle < 0 then
					text = "Difficulty Down"
				end
				
				local yoff = 0 --misc.hud:get("title_alpha") * 2
				
				local topy, bottomy = -35, 27
				
				graphics.drawImage{image = Difficulty.getActive().icon, x = w / 2, y = (h / 2) + yoff + topy - 1, subimage = 2, alpha = alpha, solidColor = Color.DARK_GRAY}
				graphics.drawImage{image = Difficulty.getActive().icon, x = w / 2, y = (h / 2) + yoff + topy + 1, subimage = 2, alpha = alpha, solidColor = Color.DARK_GRAY}
				graphics.drawImage{image = Difficulty.getActive().icon, x = (w / 2) - 1, y = (h / 2) + yoff + topy, subimage = 2, alpha = alpha, solidColor = Color.DARK_GRAY}
				graphics.drawImage{image = Difficulty.getActive().icon, x = (w / 2) + 1, y = (h / 2) + yoff + topy, subimage = 2, alpha = alpha, solidColor = Color.DARK_GRAY}
				
				graphics.drawImage{
					image = Difficulty.getActive().icon,
					x = w / 2,
					y = (h / 2) + yoff + topy,
					subimage = 2,
					alpha = alpha,
					solidColor = Color.WHITE
				}
				
				graphics.alpha(alpha)
				graphics.color(Color.WHITE)
				
				if hardmode > 1 then
					outlinedPrint2(hardmode, (w / 2) + 9, (h / 2) + yoff + topy + 9, Color.DARK_GRAY, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTER)
				end
				
				graphics.color(Color.fromHex(0xBAFFDE))
				
				outlinedPrint2(text, w / 2, (h / 2) + yoff + bottomy, Color.DARK_GRAY, graphics.FONT_LARGE, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTER)
			else
				doTitle = nil
			end
		end
	end
end

callback.register("postSelection", function()
	if getRule(5, 8) == true then
		tcallback.register("onStep", onStepCall)
		tcallback.register("postStep", postStepCall)
		tcallback.register("onDraw", onDrawCall)
	end
end)

callback.register("onExtraDifficultyUpdate", function(value)
	if value > 0 then
		tcallback.register("onStep", onStepCall)
		tcallback.register("postStep", postStepCall)
		tcallback.register("onDraw", onDrawCall)
		tcallback.register("onHUDDraw", onHUDDrawCall)
	else
		tcallback.unregister("onStep", onStepCall)
		tcallback.unregister("postStep", postStepCall)
		tcallback.unregister("onDraw", onDrawCall)
		tcallback.unregister("onHUDDraw", onHUDDrawCall)
	end
end)