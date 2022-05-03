-- DOTs

local sPoisonDot = Sound.load("PoisonDot", "Misc/SFX/poisonDot")
local sFireDot = Sound.load("FireDot", "Misc/SFX/fireDot")
local sBaneDot = Sound.load("BaneDot", "Misc/SFX/baneDot")

local dotTypes = {
	{
		name = "poison",
		particle = par.Lightning,
		particleColor = Color.PURPLE,
		particleRate = 30,
		rate = 60,
		ignoreArmor = false,
		sound = sPoisonDot,
		showDamage = true,
		damageColor = Color.DAMAGE_ENEMY,
		hudColor = Color.PURPLE
	},
	{
		name = "corrosion",
		particle = par.Radioactive,
		particleColor = Color.WHITE,
		particleRate = 70,
		rate = 70,
		ignoreArmor = true,
		sound = sPoisonDot,
		soundPitchAdd = -0.3,
		showDamage = true,
		damageColor = Color.fromHex(0xC6E067),
		hudColor = Color.fromHex(0xFFFF7C)
	},
	{
		name = "fire",
		particle = par.Fire3,
		particleRate = 100,
		rate = 30,
		ignoreArmor = false,
		sound = sFireDot,
		showDamage = true,
		damageColor = Color.ROR_ORANGE,
		hudColor = Color.ROR_ORANGE
	},
	{
		name = "bane",
		particle = par.Dusty,
		particleColor = Color.fromHex(0x726542),
		particleRate = 80,
		rate = 100,
		ignoreArmor = true,
		sound = sBaneDot,
		showDamage = true,
		damageColor = Color.fromHex(0x918872),
		hudColor = Color.fromHex(0x706854)
	}
}

export("DOT")

DOT_POISON = dotTypes[1]
DOT_CORROSION = dotTypes[2]
DOT_FIRE = dotTypes[3]
DOT_BANE = dotTypes[4]

export("DOT_POISON")
export("DOT_CORROSION")
export("DOT_FIRE")
export("DOT_BANE")

DOT.new = function(name)
	if not isa(name, "string") then typeCheckError("DOT.new", 1, "name", "String", name) end
	
	local dotType = {
		name = name,
		particle = nil,
		particleColor = Color.WHITE,
		particleRate = 15,
		rate = 60,
		ignoreArmor = false,
		sound = nil,
		showDamage = true,
		damageColor = Color.WHITE
	}
	
	table.insert(dotTypes, dotType)
	return(dotTypes[#dotTypes])
end

DOT.find = function(name)
	if not isa(name, "string") then typeCheckError("DOT.find", 1, "name", "String", name) end
	
	for i, dotType in ipairs(dotTypes) do
		if dotType.name == name then
			return(dotType)
		end
	end
end

DOT.findAll = function()
	return(dotTypes)
end

DOT.addToDamager = function(damager, dotType, damage, tics, index, stacks)
	if not isa(damager, "DamagerInstance") then typeCheckError("DOT.addToDamager", 1, "damager", "DamagerInstance", damager) end
	if not isa(dotType, "table") then typeCheckError("DOT.addToDamager", 2, "dotType", "DoTType", dotType) end
	if not isa(damage, "number") then typeCheckError("DOT.addToDamager", 3, "damage", "number", damage) end
	if not isa(tics, "number") then typeCheckError("DOT.addToDamager", 4, "tics", "number", tics) end
	--if index and not isa(index, "number") then typeCheckError("DOT.addToDamager", 5, "index", "number", index) end
	if stacks and not isa(stacks, "boolean") then typeCheckError("DOT.addToDamager", 6, "stacks", "boolean", stacks) end
	
	local damagerData = damager:getData()
	
	if not damagerData.dotData then
		damagerData.dotData = {}
	end
	
	local t = {
		dotType = dotType,
		damage = damage,
		tics = tics,
		index = index,
		stacks = stacks
	}
	
	table.insert(damagerData.dotData, t)
end

DOT.applyToActor = function(actor, dotType, damage, tics, index, stacks)
	if not isa(actor, "ActorInstance") then typeCheckError("DOT.applyToActor", 1, "actor", "ActorInstance", actor) end
	if not isa(dotType, "table") then typeCheckError("DOT.addToDamager", 2, "dotType", "DoTType", dotType) end
	if not isa(damage, "number") then typeCheckError("DOT.addToDamager", 3, "damage", "number", damage) end
	if not isa(tics, "number") then typeCheckError("DOT.addToDamager", 4, "tics", "number", tics) end
	--if index and not isa(index, "number") then typeCheckError("DOT.addToDamager", 5, "index", "number", index) end
	if stacks and not isa(stacks, "boolean") then typeCheckError("DOT.addToDamager", 6, "stacks", "boolean", stacks) end
	
	local actorData = actor:getData()
	
	if not actorData.dotData then
		actorData.dotData = {}
	end
	
	local i
	for ti, t in ipairs(actorData.dotData) do
		if t.index == index then
			i = ti
		end
	end
	
	local t = {
		dotType = dotType,
		damage = damage,
		tics = tics,
		index = index,
		stacks = stacks,
		timer = 0,
		count = 0
	}
	
	if i and not stacks then
		if actorData.dotData[i].damage < t.damage then
			actorData.dotData[i].damage = t.damage
		end
		if actorData.dotData[i].tics < t.tics then
			actorData.dotData[i].tics = t.tics
		end
		actorData.dotData[i].count = 0
	else		
		table.insert(actorData.dotData, t)
	end
end

DOT.checkActor = function(actor, dotType)
	if not isa(actor, "ActorInstance") then typeCheckError("DOT.checkActor", 1, "actor", "ActorInstance", actor) end
	if not isa(dotType, "table") then typeCheckError("DOT.checkActor", 2, "dotType", "DoTType", dotType) end
	
	local actorData = actor:getData()
	
	if actorData.dotData then
		for _, dotData in ipairs(actorData.dotData) do
			if dotData.dotType == dotType then
				return true
			end
		end
	end
	return false
end

DOT.getActive = function(actor)
	if not isa(actor, "ActorInstance") then typeCheckError("DOT.getActive", 1, "actor", "ActorInstance", actor) end
	
	local actorData = actor:getData()
	
	if actorData.dotData then
		return actorData.dotData -- nice
	end
	return {}
end

DOT.removeFromActor = function(actor, dotType)
	if not isa(actor, "ActorInstance") then typeCheckError("DOT.removeFromActor", 1, "actor", "ActorInstance", actor) end
	if dotType and not isa(dotType, "table") then typeCheckError("DOT.removeFromActor", 2, "dotType", "DoTType", dotType) end
	
	local actorData = actor:getData()
	
	if actorData.dotData then
		for i, dotData in ipairs(actorData.dotData) do
			if dotType == nil or dotData.dotType == dotType then
				table.remove(actorData.dotData, i)
			end
		end
	end
end

table.insert(call.onHit, function(damager, actor)
	local damagerDotData = damager:getData().dotData
	if damagerDotData and not damager:getData().cancelDamage and not isaDrone(actor) then
		local actorData = actor:getData()
		
		if not actorData.dotData then
			actorData.dotData = {}
		end
		
		for _, d in ipairs(damagerDotData) do
			local i
			local ic = 0
			for ti, t in ipairs(actorData.dotData) do
				if t.index == d.index then
					i = ti
					ic = ic + 1
				end
			end
			
			local t = {
				dotType = d.dotType,
				damage = d.damage,
				tics = d.tics,
				index = d.index,
				stacks = d.stacks,
				timer = 0,
				count = 0
			}
			
			if i and not d.stacks or ic > 5 then
				if actorData.dotData[i].damage < t.damage then
					actorData.dotData[i].damage = t.damage
				end
				if actorData.dotData[i].tics < t.tics then
					actorData.dotData[i].tics = t.tics
				end
				actorData.dotData[i].count = 0
			else		
				table.insert(actorData.dotData, t)
			end
		end
	end
end)

procShell = function() end

callback.register("onActorStep", function(actor)
	local allDotData = actor:getData().dotData
	
	if allDotData then
		local actorAc = actor:getAccessor()
		
		local particlesDone = {}
		
		for i, dotData in ipairs(allDotData) do
			local dotType = dotData.dotType
			
			if dotType.particle and not particlesDone[dotType] then
				local sprite
				if actor.mask then sprite = actor.mask else sprite = actor.sprite end
				local sprW, sprH = sprite.width * math.abs(actor.xscale), sprite.height * math.abs(actor.yscale)
				local spriteWidth = sprW / 3
				local sizeMult = ((sprH + sprW) * 0.5) / 80
				
				if global.quality > 1 then
					if math.chance(dotType.particleRate * 0.85 * sizeMult) then
						dotType.particle:burst("above", math.random(actor.x - spriteWidth, actor.x + spriteWidth), math.random(actor.y - sprite.yorigin + (sprH * 0.2), actor.y - sprite.yorigin + (sprH * 0.8)), 1, dotType.particleColor)
					end
				end
				
				particlesDone[dotType] = true
			end
			
			if dotData.timer == dotType.rate then
				
				if not actorAc.invincible or actorAc.invincible <= 0 then
					local damageDone
					
					if dotType.ignoreArmor then
						damageDone = dotData.damage
					else
						damageDone = math.ceil(dotData.damage * (100 / (100 + actorAc.armor)))
					end
					
					if global.showDamage and dotData.dotType.showDamage and damageDone > 0 then
						misc.damage(damageDone, actor.x - 4 + (i * 3), actor.y - 10, false, dotType.damageColor)
					end
					
					if not actorAc.shield or actorAc.shield > 0 then
						actorAc.shield = actorAc.shield - damageDone
					else
						local shellPiece = actorAc.shellPiece
						if not procShell(actor, damageDone) then
							actorAc.hp = actorAc.hp - damageDone
						end
					end
					
					if not isa(actor, "PlayerInstance") then
						actor:setAlarm(6, math.max(60, actor:getAlarm(6)))
					end
				end
				
				if onScreen(actor) and dotType.sound then
					local add = dotType.soundPitchAdd or 0
					dotType.sound:play(0.9 + add + math.random() * 0.2)
				end
				
				if dotData.count >= dotData.tics then
					table.remove(allDotData, i)
				else
					dotData.count = dotData.count + 1
					dotData.timer = 0
				end
				
			else
				dotData.timer = dotData.timer + 1
			end
		end
	end
end)

local sprHpFadeMask = Sprite.load("HpFadeMask", "Gameplay/HUD/hpFadeMask", 2, 0, 0)

callback.register("onPlayerHUDDraw", function(player, x, y)
	local allDotData = player:getData().dotData
	
	if allDotData then
		local playerAc = player:getAccessor()
		
		for i, dotData in ipairs(allDotData) do
			local dotType = dotData.dotType
			
			if dotType.hudColor then
				local xx, yy, bw = x - 35, y + 29, 160 
				
				local mult = 1
				if dotData.count == dotData.tics then
					mult = (dotType.rate - dotData.timer) / dotType.rate
				else
					mult = 0.5 + ((dotType.rate - dotData.timer) / dotType.rate) * 0.5
				end
				
				if #obj.P:findAll() > 1 and not net.online then
					xx = x - 5
					yy = y + 24
					mult = mult * 0.5
					bw = 101
				end
				
				local hpMult = playerAc.hp / playerAc.maxhp
				local barPos = math.ceil(bw * hpMult)
				
				local width1 = math.clamp(barPos, 0, sprHpFadeMask.width)
				--local width2 = math.clamp(barPos - bw, sprHpFadeMask.width, 0)
				local ww = bw - sprHpFadeMask.width
				local width2 = math.clamp(barPos - ww, 0, sprHpFadeMask.width)
				local mult2 = (sprHpFadeMask.width - math.abs(width2)) / sprHpFadeMask.width
				graphics.alpha(1)
				graphics.drawImage{
					image = sprHpFadeMask,
					x = xx + 1,
					y = yy,
					subimage = 1,
					xscale = 1,
					color = dotType.hudColor,
					alpha = 0.6 * mult,
					region = {0, 0, width1, sprHpFadeMask.height}
				}
				graphics.drawImage{
					image = sprHpFadeMask,
					x = xx + bw - sprHpFadeMask.width + 1,
					y = yy,
					subimage = 2,
					xscale = 1,
					color = dotType.hudColor,
					alpha = 0.6 * mult,
					region = {0, 0, width2, sprHpFadeMask.height}
				}
				break
			end
		end
	end
end)

table.insert(call.onStageEntry, function()
	for _, player in ipairs(obj.P:findAll()) do
		player:getData().dotData = nil -- just removing active dots
	end
end)


-- Nooo my drones
table.insert(call.onStep, function()
	for _, drone in ipairs(pobj.drones:findAll()) do
		drone:getData().dotData = nil
	end
end)