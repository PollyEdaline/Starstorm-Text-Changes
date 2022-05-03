
-- All event data

local events = {}

local event = {
	active = nil,
	countdown = 0,
	duration = 0,
	timer = 0,
	currentSounds = nil,
}

export("Event")
local intId = 1
function Event.new(name, onStep, onSubevent, onEnd)
	if not events[name] then
		if isa(name, "string") then
			events[name] = {
				name = name,
				alert = "An event is starting...",
				baseDuration = 60,
				durationScaling = 1,
				onStep = onStep,
				onSubevent = onSubevent,
				onEnd = onEnd,
				subeventChance = 0.15,
				id = intId,
				persistent = true
			}
			intId = intId + 1
			return events[name]
		else
			error("Argument 1: string expected, got "..type(name), 2)
		end
	else
		error("an Event with the name "..[["]]..name..[["]].." already exists.", 2)
	end
end

function Event.setFX(event, particle, backgroundSound, randomSounds, screenMaskColor, screenMaskAlpha, fullscreen)
	if isa(event, "table") and event.id and event.baseDuration then
		if isa(particle, "ParticleType") or particle == nil then
			if not event.defaultStageData then event.defaultStageData = {} end
			event.defaultStageData.particle = particle
			
			if isa(backgroundSound, "Sound") or backgroundSound == nil then
				if not event.defaultStageData then event.defaultStageData = {} end
				if not event.defaultStageData.sounds then event.defaultStageData.sounds = {} end
				event.defaultStageData.sounds.main = backgroundSound
				
				if isa(randomSounds, "table") or randomSounds == nil then
					if not event.defaultStageData then event.defaultStageData = {} end
					if not event.defaultStageData.sounds then event.defaultStageData.sounds = {} end
					event.defaultStageData.sounds.mix = randomSounds
					
					if isa(screenMaskColor, "Color") or screenMaskColor == nil then
						if not event.defaultStageData then event.defaultStageData = {} end
						event.defaultStageData.color = screenMaskColor
						
						if isa(screenMaskAlpha, "number") or screenMaskAlpha == nil then
							if not event.defaultStageData then event.defaultStageData = {} end
							event.defaultStageData.alpha = screenMaskAlpha
							
							if isa(fullscreen, "boolean") or fullscreen == nil then
								if fullscreen then
									event.defaultStageData.fullScreen = true
								end
								
								return event.defaultStageData
								
							else
								error("Argument 7: Boolean expected, got "..type(fullscreen), 2)
							end
						else
							error("Argument 6: Color expected, got "..type(screenMaskAlpha), 2)
						end
					else
						error("Argument 5: Color expected, got "..type(screenMaskColor), 2)
					end
				else
					error("Argument 4: Table expected, got "..type(randomSounds), 2)
				end
			else
				error("Argument 3: Sound expected, got "..type(backgroundSound), 2)
			end
		else
			error("Argument 2: ParticleType expected, got "..type(particle), 2)
		end
	else
		error("Argument 1: Event expected, got "..type(event), 2)
	end
end

function Event.setStageFX(event, stage, particle, backgroundSound, randomSounds, screenMaskColor, screenMaskAlpha, fullscreen)
	if isa(event, "table") and event.id and event.baseDuration then
		if isa(stage, "Stage") then
			if not event.stageData then event.stageData = {} end
			local stageData = event.stageData
			if isa(particle, "ParticleType") or particle == nil then
				if not stageData[stage] then stageData[stage] = {} end
				stageData[stage].particle = particle
				
				if isa(backgroundSound, "Sound") or backgroundSound == nil then
					if not stageData[stage] then stageData[stage] = {} end
					if not stageData[stage].sounds then stageData[stage].sounds = {} end
					stageData[stage].sounds.main = backgroundSound
					
					if isa(randomSounds, "table") or randomSounds == nil then
						if not stageData[stage] then stageData[stage] = {} end
						if not stageData[stage].sounds then stageData[stage].sounds = {} end
						stageData[stage].sounds.mix = randomSounds
						
						if isa(screenMaskColor, "Color") or screenMaskColor == nil then
							if not stageData[stage] then stageData[stage] = {} end
							stageData[stage].color = screenMaskColor
							
							if isa(screenMaskAlpha, "number") or screenMaskAlpha == nil then
								if not stageData[stage] then stageData[stage] = {} end
								stageData[stage].alpha = screenMaskAlpha
							
								if isa(fullscreen, "boolean") or fullscreen == nil then
									if fullscreen then
										stageData[stage].fullScreen = true
									end
									
									return stageData[stage]
									
								else
									error("Argument 8: Boolean expected, got "..type(fullscreen), 2)
								end
							else
								error("Argument 7: Color expected, got "..type(screenMaskAlpha), 2)
							end
						else
							error("Argument 6: Color expected, got "..type(screenMaskColor), 2)
						end
					else
						error("Argument 5: Table expected, got "..type(randomSounds), 2)
					end
				else
					error("Argument 4: Sound expected, got "..type(backgroundSound), 2)
				end
			else
				error("Argument 3: ParticleType expected, got "..type(particle), 2)
			end
		else
			error("Argument 2: Stage expected, got "..type(stage), 2)
		end
	else
		error("Argument 1: Event expected, got "..type(event), 2)
	end
end

function Event.find(name)
	if isa(name, "string") then
		return events[name]
	else
		error("Argument 1: string expected, got "..type(name), 2)
	end
end

function Event.findAll()
	local allEvents = {}
	for _, event in pairs(events) do
		table.insert(allEvents, event)
	end
	return allEvents
end

function Event.getActive()
	return event.active
end

local syncEvent

function Event.setActive(eevent, countdown, duration) --eevent haaaaaa
	if eevent then
	if countdown == nil then countdown = (16 * 60) end
	if duration == nil then duration = (eevent.baseDuration * 60) + (Difficulty.getScaling() * 60 * eevent.durationScaling) end
	if isa(eevent, "table") and eevent.id and eevent.baseDuration then
		if isa(countdown, "number") then
			if isa(duration, "number") then
				if event.active then
					if event.active.onEnd then
						local strengthMult = getRule(5, 5)
						event.active.onEnd(strengthMult)
					end
					if event.currentSounds and event.currentSounds.main and event.currentSounds.main:isPlaying() then
						event.currentSounds.main:stop()
						event.currentSounds = nil
					end
				end
				
				event.active = eevent
				event.countdown = countdown
				event.duration = duration
				event.timer = 0
				if net.host then
					syncEvent:sendAsHost(net.ALL, nil, eevent.id, countdown, duration)
				end
			else
				error("Argument 3: number expected, got "..type(duration), 2)
			end
		else
			error("Argument 2: number expected, got "..type(countdown), 2)
		end
	else
		error("Argument 1: Event expected, got "..type(name), 2)
	end
	else
		event.active = eevent
		
	end
end

syncEvent = net.Packet.new("SSEvent", function(player, eventID, countdown, duration)
	local currentEvent = nil
	for _, event in pairs(events) do
		if event.id == eventID then
			currentEvent = event
			break
		end
	end
	if currentEvent then
		Event.setActive(currentEvent, countdown, duration)
	end
end)

local syncEventProc = net.Packet.new("SSEventProc", function(player, eventID, strengthMult, timer)
	local currentEvent = nil
	for _, event in pairs(events) do
		if event.id == eventID then
			currentEvent = event
			break
		end
	end
	if currentEvent then
		if currentEvent.onSubevent then
			currentEvent.onSubevent(strengthMult, timer)
		end
		
		if stgData and stgData.sounds and stgData.sounds.mix then
			table.irandom(stgData.sounds.mix):play(0.9 + math.random() * 0.2)
		end
	end
end)


local function getStageData()
	local currentEvent = event.active
	local currentStage = Stage.getCurrentStage()
	local stgData
	if currentEvent then
		if currentEvent.stageData and currentEvent.stageData[currentStage] then
			stgData = currentEvent.stageData[currentStage]
		else
			stgData = currentEvent.defaultStageData
		end
	end
	return stgData
end

--local alertDisplay = nil

table.insert(call.onStep, function()
	if getRule(5, 1) == true then
		
		local strengthMult = getRule(5, 5)
		
		if event.active then
			
			event.ending = false
			
			local currentEvent = event.active
			local stgData = getStageData()
			
			if event.countdown > 0 then
				--if not alertDisplay or not alertDisplay:isValid() then
				--	alertDisplay = typewriter("Alert: "..currentEvent.alert)
				--end
				event.countdown = event.countdown - 1
			else
				if alertDisplay and alertDisplay:isValid() then
					alertDisplay:destroy()
					alertDisplay = nil
				end
				if event.timer < event.duration then
					if event.timer > event.duration - 120 then
						event.ending = true
					end
					if stgData and stgData.sounds and stgData.sounds.main and not stgData.sounds.main:isPlaying() then
						stgData.sounds.main:loop()
						event.currentSounds = stgData.sounds
					end
					
					if currentEvent.onStep then
						currentEvent.onStep(strengthMult, event.timer)
					end
					
					local firstChance = math.max(currentEvent.subeventChance, 1)
					local secondChance = currentEvent.subeventChance * 100
					
					if net.host and math.chance(firstChance) and math.chance(secondChance) then
						if currentEvent.onSubevent then
							currentEvent.onSubevent(strengthMult, event.timer)
						end
						
						if stgData and stgData.sounds and stgData.sounds.mix then
							table.irandom(stgData.sounds.mix):play(0.9 + math.random() * 0.2)
						end
						syncEventProc:sendAsHost(net.ALL, nil, currentEvent.id, strengthMult, event.timer)
					end
					
					event.timer = event.timer + 1
				else
					
					if currentEvent.onEnd then
						currentEvent.onEnd(strengthMult)
					end
					
					event.timer = 0
					event.active = nil
				end
			end
			
		else
			
			if event.currentSounds and event.currentSounds.main and event.currentSounds.main:isPlaying() then
				event.currentSounds.main:stop()
				event.currentSounds = nil
			end
		end
	end
end)

callback.register("globalRoomStart", function()
	if event.active and event.currentSounds and event.currentSounds.main and event.currentSounds.main:isPlaying() then
		event.currentSounds.main:stop()
		event.currentSounds = nil
	end
	if event.active and not event.active.persistent then
		local strengthMult = getRule(5, 5)
		
		if event.active.onEnd then
			event.active.onEnd(strengthMult)
		end
		event.timer = 0
		event.active = nil
	end
end)

callback.register("onGameStart", function()
	if event.active then
		event.timer = 0
		event.active = nil
	end
end)

table.insert(call.onStep, function()
	if getRule(5, 1) == true and event.active and event.countdown == 0 then
		local stgData = getStageData()
		if stgData then
			local w = misc.camera.width
			local h = misc.camera.height
			
			local xOffset = stgData.xoffset or 0
			local yOffset = stgData.yoffset or 0
			local amount = stgData.particleAmount or 3
			local color = stgData.particleColor or Color.WHITE
			
			local ii = 1
			
			local hh = h * -0.1
			if stgData.fullScreen then
				hh = math.random(h * -0.2, h * 1.2)
				if global.quality > 2 then
					ii = 3
				else
					ii = 2
				end
			end
			if stgData.particle and global.quality > 1 then
				for i = 1, ii do
					if amount >= 1 or math.chance(amount * 100) then
						stgData.particle:burst(table.irandom{"below", "middle", "above"}, math.random(misc.camera.x, misc.camera.x + w) + xOffset, misc.camera.y + hh + yOffset, math.ceil(amount), color)
					end
				end
			end
		end
	end
end)

local screenBlendRatio = 0

local alphaEntryRatio = 0

table.insert(call.preHUDDraw, function()
	if getRule(5, 1) == true then
		if event.active and event.countdown == 0 and not event.ending then
			if screenBlendRatio < 1 then
				screenBlendRatio = screenBlendRatio + 0.01
			end
		else
			if screenBlendRatio > 0 then
				screenBlendRatio = screenBlendRatio - 0.01
			end
		end
		
		local w, h = graphics.getGameResolution()
		
		if screenBlendRatio > 0 then
			
			local stgData = getStageData()
			
			if stgData and stgData.color and stgData.alpha then
				graphics.color(stgData.color)
				if stgData.color.gml == Color.BLACK.gml then
					graphics.setBlendMode("normal")
				else
					graphics.setBlendMode("additive")
				end
				graphics.alpha(stgData.alpha * screenBlendRatio)
				graphics.rectangle(0, 0, w, h)
			end
		end
		if event.active and event.countdown > 0 then
			local alphaMult = math.min((event.countdown - 120) / 60, 1)
			if alphaEntryRatio < 1 then alphaEntryRatio = alphaEntryRatio + 0.01 end
			graphics.alpha(0.8 * alphaMult * alphaEntryRatio)
			
			graphics.color(Color.BLACK)
			graphics.print(event.active.alert, w / 2, h / 2 - 58, graphics.FONT_LARGE, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTER)
			graphics.color(Color.WHITE)
			graphics.print(event.active.alert, w / 2, h / 2 - 60, graphics.FONT_LARGE, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTER)
			
		elseif alphaEntryRatio > 0 then alphaEntryRatio = alphaEntryRatio - 0.01 end
	end
end)