local path = "Actors/Totem/"

local stages = {}
--stages.desolate = stg.DesolateForest
--stages.dried = stg.DriedLake
--stages.damp = stg.DampCaverns
--stages.sky = stg.SkyMeadow
stages.ancient = stg.AncientValley
--stages.sunken = stg.SunkenTombs
--stages.boar = stg.BoarBeach
--stages.magma = stg.MagmaBarracks
--stages.hive = stg.HiveCluster
--stages.temple = stg.TempleoftheElders
--stages.risk = stg.RiskofRain

local sprIdle = spr.Totem1Idle
local sprShoot2 = Sprite.load("TotemShoot2", path.."Shoot2", 18, 35, 43)
local sprShoot3 = Sprite.load("TotemShoot3", path.."Shoot3", 10, 27, 40)
local sprShoot4 = Sprite.load("TotemShoot4", path.."Shoot4", 12, 20, 59)
local sprPalette = Sprite.load("TotemPal", path.."Palette", 1, 0, 0)

local partSprites = {
	[1] = spr.Totem1Idle,
	[2] = spr.Totem2Idle,
	[3] = spr.Totem3Idle,
	[4] = spr.Totem4Idle
}

--local sSpawn = Sound.load("TotemSpawn", path.."spawn")

obj.TotemController = Object.base("Boss", "TotemController")
obj.TotemController.sprite = spr.Totem4Idle

obj.TotemPart = Object.base("Enemy", "TotemPart")
obj.TotemPart.sprite = spr.Totem1Idle

EliteType.registerPalette(sprPalette, obj.TotemController)
EliteType.registerPalette(sprPalette, obj.TotemPart)

local syncAttack = net.Packet.new("SSTotem", function(player, x, y, var)
	local instance = obj.TotemPart:findNearest(x, y)
	if instance and instance:isValid() then
		instance:set(var, 1)
	end
end)
local syncDeath = net.Packet.new("SSTotem2", function(player, x, y)
	local instance = obj.TotemPart:findEllipse(x - 10, y - 10, x + 10, y + 10)
	if instance and instance:isValid() then
		instance:kill()
	end
end)

local objTotemShockwave = Object.new("TotemShockwave")
objTotemShockwave.sprite = spr.Nothing
objTotemShockwave.depth = -12
objTotemShockwave:addCallback("create", function(self)
	local selfData = self:getData()
	
	selfData.timer = 180
	selfData.range = 8
	selfData.team = "enemy" 
	selfData.damage = 25
	selfData.speed = 2
	selfData.dir = 1
	
	selfData._EfColor = Color.fromHex(0xE7967E)
end)
objTotemShockwave:addCallback("step", function(self)
	local selfData = self:getData()
	
	if misc.getTimeStop() == 0 then
		local newx = self.x + selfData.speed * selfData.dir
		if Stage.collidesPoint(newx, self.y) and Stage.collidesPoint(newx, self.y - 16) then
			selfData.timer = -1
			selfData.boom = true
		else
			self.x = newx
		end
		
		local parent = selfData.parent
		local r = selfData.range
		if parent and parent:isValid() then
			local pTeam = parent:get("team")
			for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - r, self.y - r, self.x + r, self.y + r)) do
				if actor:get("team") ~= pTeam then
					selfData.boom = true
					break
				end
			end
		end
		
		if selfData.timer < 0 or selfData.boom then
			r = r + 6
			if parent and parent:isValid() then
				local damager = parent:getData().controller:fireExplosion(self.x, self.y, r / 19, r / 4, selfData.damage / parent:get("damage")):set("knockup", 4)
				if parent:getElite() == elt.Blazing then
					local trail = obj.FireTrail:create(self.x, self.y)
					trail:set("damage", math.ceil(selfData.damage * 0.3))
					trail:set("team", parent:get("team"))
					trail:set("parent", parent.id)
				end
			else
				misc.fireExplosion(self.x, self.y, (r * 0.8) / 19, (r * 0.8) / 4, selfData.damage, selfData.team):set("knockup", 4)
			end
			if selfData.boom then
				if onScreen(self) then
					misc.shakeScreen(4)
					local sparks = obj.EfSparks:create(self.x, self.y):set("depth", -12)
					sparks.sprite = spr.TotemShockwave
					sparks.yscale = 1
				end
				sfx.Smite:play(1.3 + math.random() * 0.2, 0.8)
			end
			self:destroy()
		else
			selfData.timer = selfData.timer - 1
			
			if selfData.timer % 10 == 0 then
				local sparks = obj.EfSparks:create(self.x, self.y):set("depth", -12)
				sparks.sprite = spr.TotemShockwave
				local mult = math.max(selfData.timer / 360, 0.2)
				sparks.xscale = mult
				sparks.yscale = mult
			end
			
			local destroy = true
			for i = -4, 40 do
				local ii = (i * 4)
				if Stage.collidesPoint(self.x, self.y + ii) then
					self.y = self.y + ii
					destroy = false
					break
				end
			end
			if destroy then
				selfData.timer = -1
			end
		end
	end
end)

obj.TotemBullet = Object.new("TotemBullet")
obj.TotemBullet.depth = -12
obj.TotemBullet:addCallback("create", function(self)
	local selfData = self:getData()
	
	selfData.timer = 240
	selfData.range = 8
	selfData.team = "enemy" 
	selfData.damage = 17
	selfData.size = 1
	
	selfData._EfColor = Color.fromHex(0xE7967E)
end)
obj.TotemBullet:addCallback("step", function(self)
	local selfData = self:getData()
	
	if misc.getTimeStop() == 0 or selfData.team == "player" then
		if not selfData.setDir then
			local nearestInstance = nil
			for _, instance2 in ipairs(pobj.actors:findAll()) do
				if not isa(instance2, "PlayerInstance") or instance2:get("dead") == 0 then
					if instance2:get("team") ~= selfData.team and not isaDrone(instance2) then
						local dis = distance(self.x, self.y, instance2.x, instance2.y)
						if not nearestInstance or dis < nearestInstance.dis then
							nearestInstance = {inst = instance2, dis = dis}
						end
					end
				end
			end
			local target
			if nearestInstance then
				target = nearestInstance.inst
			end
			if target and target:isValid() then
				local angle = posToAngle(self.x, self.y, target.x, target.y)
				
				self:set("direction", angle)
				self:set("speed", 3)
				selfData.setDir = true
			end
		else
			self:set("speed", 3)
		end
		
		local parent = selfData.parent
		local r = selfData.range
		if parent and parent:isValid() then
			for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - r, self.y - r, self.x + r, self.y + r)) do
				if actor:get("team") ~= parent:get("team") then
					selfData.boom = true
					break
				end
			end
		end
		
		if selfData.timer < 0 or selfData.boom then
			r = r + 3
			if parent and parent:isValid() then
				local source = parent:getData().controller or parent
				local damager = source:fireExplosion(self.x, self.y, r / 19, r / 4, selfData.damage / parent:get("damage"), spr.JellyMissile, nil, selfData.properties)
				if parent:getElite() == elt.Blazing then
					local trail = obj.FireTrail:create(self.x, self.y)
					trail:set("damage", math.ceil(selfData.damage * 0.3))
					trail:set("team", parent:get("team"))
					trail:set("parent", parent.id)
				end
			else
				misc.fireExplosion(self.x, self.y, (r * 0.8) / 19, (r * 0.8) / 4, selfData.damage, selfData.team, spr.JellyMissile)
			end
			if selfData.boom then
				if onScreen(self) then
					misc.shakeScreen(2)
				end
				sfx.GiantJellyExplosion:play(1.1 + math.random() * 0.2, 0.8)
			end
			self:destroy()
		else
			selfData.timer = selfData.timer - 1
		end
	else
		self.spriteSpeed = 0
		self:set("speed", 0)
	end
end)
obj.TotemBullet:addCallback("draw", function(self)
	local r = math.random(3, 5) * self:getData().size
	graphics.color(self:getData()._EfColor)
	graphics.circle(self.x, self.y, r * 2, false)
	graphics.color(Color.WHITE)
	graphics.circle(self.x, self.y, r, false)
end)

NPC.setSkill(obj.TotemPart, 1, 400, 60 * 9, spr.Totem1Shoot, 0.2, function(actor)
	sfx.Reload:play(0.6 + math.random() * 0.2, 0.5)
end, function(actor, relevantFrame)
	if relevantFrame == 3 then
		sfx.Smite:play(0.8 + math.random() * 0.2, 0.8)
		
		local bullet = objTotemShockwave:create(actor.x + 5, actor.y)
		bullet:getData().parent = actor
		bullet:getData().team = actor:get("team")
		bullet:getData().damage = actor:get("damage") * 1.8
		
		bullet = objTotemShockwave:create(actor.x - 5, actor.y)
		bullet:getData().parent = actor
		bullet:getData().team = actor:get("team")
		bullet:getData().damage = actor:get("damage") * 1.8
		bullet:getData().dir = -1
	end
end)

NPC.setSkill(obj.TotemPart, 2, 400, 60 * 9, sprShoot2, 0.2, function(actor)
	sfx.Shield:play(0.9 + math.random() * 0.2)
end, function(actor, relevantFrame)
	local actorData = actor:getData()
	if relevantFrame == 6 then
		actorData.lastAim = 270
		
		local target = nearestMatchingOp(actor, pobj.actors, "team", "~=", actor:get("team"))
		if target then
			--local dir = posToAngle(actor.x, actor.y - 24, target.x, target.y)
			--actorData.lastAim = dir
			actorData.currentAim = 0
			if target.x < actor.x then
				actorData.currentAim = 180
			end
		end
	end
	if relevantFrame == 3 then
		sfx.LizardGShoot1:play(0.9 + math.random() * 0.2)
	end
	if actor.subimage >= 7 and actor.subimage < 16 then
		local target = nearestMatchingOp(actor, pobj.actors, "team", "~=", actor:get("team"))
		if target then
			--local dir = posToAngle(actor.x, actor.y - 24, target.x, target.y)
			--local dir = 0
			
			local turnSpeed = 0.0235
			if actorData.towerSlot == 1 then
				turnSpeed = 0.049
			end
			
			if actor:getElite() == elt.Frenzied then
				turnSpeed = turnSpeed + 0.02
			end
			
			actorData.lastAim = actorData.lastAim + (angleDif(actorData.lastAim, actorData.currentAim) * -turnSpeed)
			
			if actor:getData().controller:isValid() then
				local bullet = actor:getData().controller:fireBullet(actor.x, actor.y - 24, actorData.lastAim, 600, 0.05, spr.Sparks2, DAMAGER_BULLET_PIERCE)
				if actor:getElite() == elt.Blazing then
					DOT.addToDamager(bullet, DOT_FIRE, actor:get("damage") * 0.1, 5, "totem", false)
				end
				bullet:getData().burnGround = true
				local color = Color.fromHex(0xE7967E)
				local elite = actor:getElite()
				if elite then
					color = elite.color
				end
				addBulletTrailLine(bullet, color, 5)
			end
		end
	end
end)

table.insert(call.onImpact, function(damager, x, y)
	if damager:getData().burnGround then
		local parent = damager:getParent()
		if parent and parent:isValid() and not obj.FireTrail:findRectangle(x - 4, y - 3, x + 4, y + 3) then
			local trail = obj.FireTrail:create(x, y)
			trail:set("damage", math.ceil(parent:get("damage") * 0.15))
			trail:set("team", parent:get("team"))
			trail:set("parent", parent.id)
		end
	end
end)

local buffArmor = Buff.new("armor")
buffArmor.sprite = spr.Buffs
buffArmor.subimage = 9
buffArmor:addCallback("start", function(actor)
	obj.EfFlash:create(0,0):set("parent", actor.id):set("rate", 0.08).alpha = 0.7
	actor:set("armor", actor:get("armor") + 100)
end)
buffArmor:addCallback("end", function(actor)
	actor:set("armor", actor:get("armor") - 100)
end)

NPC.setSkill(obj.TotemPart, 3, 400, 60 * 12, sprShoot3, 0.2, function(actor)
	--sfx.Blastdoor:play(1.3 + math.random() * 0.2, 0.5)
end, function(actor, relevantFrame)
	if relevantFrame == 7 then
		local r = 400
		local myTeam = actor:get("team")
		sfx.Crit:play(0.5 + math.random() * 0.2)
		
		local leeching = actor:getElite() == elt.Leeching
		
		for _, actor2 in ipairs(pobj.actors:findAllEllipse(actor.x - r, actor.y - r, actor.x + r, actor.y + r)) do
			if actor2:get("team") == myTeam then
				actor2:applyBuff(buffArmor, 300)
				if leeching then
					actor2:applyBuff(buff.burstHealth, 120)
				end
			end
		end
	end
end)

NPC.setSkill(obj.TotemPart, 4, 400, 60 * 6, sprShoot4, 0.2, function(actor)
	--sfx.Chat:play(0.3 + math.random() * 0.2)
end, function(actor, relevantFrame)
	if relevantFrame >= 3 and relevantFrame <= 10 then
		sfx.SpiderShoot1:play(0.5 + math.random() * 0.2, 0.5)
		local bullet = obj.TotemBullet:create(actor.x, actor.y - 46)
		bullet:getData().parent = actor
		bullet:getData().team = actor:get("team")
		bullet:getData().damage = actor:get("damage") * 0.5
		local elite = actor:getElite()
		if elite then
			bullet:getData()._EfColor = elite.color
		end
	end
end)

callback.register("onEliteInit", function(actor)
	if actor:getObject() == obj.TotemController then
		local aElite = actor:getElite()
		actor:getData().applyElite = aElite
		if aElite == elt.Frenzied then
			actor:set("attack_speed", actor:get("attack_speed") + 0.4)
			actor:set("cdr", actor:get("cdr") + 0.1)
		elseif aElite == elt.Leeching then
			for _, part in ipairs(actor:getData().parts) do
				part:set("hp_regen", actor:get("hp_regen") + 0.005)
			end
		end
	end
end)

obj.TotemPart:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	selfAc.name = "Mechanical Totem"
	selfAc.name2 = ""
	selfAc.damage = 27 * Difficulty.getScaling("damage")
	selfAc.maxhp = 300 * Difficulty.getScaling("hp")
	selfAc.hp = selfAc.maxhp
	selfAc.pVmax = 0
	selfAc.pHmax = 0
	selfAc.exp_worth = 0
	--selfAc.sound_death = sDeath.id
	selfAc.sound_hit = sfx.PodHit.id
	selfAc.hit_pitch = 1.3
	selfAc.sprite_palette = sprPalette.id
	
	self:getData().knockbackImmune = true
	self:getData().lastAim = 270
end)

obj.TotemController:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.visible = false
	self.mask = spr.Pixel
	selfAc.name = "Mechanical Totem"
	selfAc.name2 = "Automated Defense System"
	selfAc.damage = 27 * Difficulty.getScaling("damage")
	selfAc.maxhp = 1200 * Difficulty.getScaling("hp")
	selfAc.hp = selfAc.maxhp
	selfAc.pVmax = 0
	selfAc.pHmax = 0
	selfAc.exp_worth = 40 * Difficulty.getScaling()
	selfAc.point_value = 640
	--selfAc.sound_death = sDeath.id
	--selfAc.sound_hit = sfx.ImpHit.id
	selfAc.hit_pitch = 1
	selfAc.sprite_palette = sprPalette.id
	selfAc.sprite_idle = sprIdle.id
	
	self.y = self.y - 1
	
	local selfData = self:getData()
	
	selfData.parts = {}
	
	for i = 1, 500 do
		if Stage.collidesPoint(self.x, self.y + i) then
			self.y = self.y + i + 1
			break
		end
	end
	--[[local ground = obj.B:findNearest(self.x, self.y)
	local ww = self.sprite.width * 0.5
	local xx = math.clamp(ground.x + ww, ground.x + (ground.xscale * 16) - ww, self.x)
	self.x = xx
	self.y = ground.y]]
	
	for i = 0, 3 do
		local index = i + 1
		local part = obj.TotemPart:create(self.x, self.y)
		part.sprite = partSprites[index]
		part:set("sprite_idle", partSprites[index].id)
		selfData.parts[index] = part
		part:getData().controller = self
		part:getData().partIndex = index
		part:getData().towerSlot = index
		part:setAlarm(index + 1, 90 + (i * 60))
	end
	
	selfData.xx = self.x
end)

obj.TotemController:addCallback("step", function(self)
	local selfAc = self:getAccessor() 
	local selfData = self:getData()
	
	self.x = selfData.xx
	
	if selfData.lastElite ~= selfAc.elite_type then
		selfData.lastElite = selfAc.elite_type
		for _, part in ipairs(selfData.parts) do
			if part:isValid() then
				part:set("elite_type", selfAc.elite_type)
				part:set("prefix_type", selfAc.prefix_type)
			end
		end
	end
	
	local hp = 0
	local toRemove
	for i, part in pairs(selfData.parts) do
		if part:isValid() then
			if selfData.applyElite then
				part:set("prefix_type", 1)
				part:set("elite_type", selfData.applyElite.id)
				part:set("damage", self:get("damage"))
				part:set("attack_speed", self:get("attack_speed"))
				part:set("maxhp", math.ceil(self:get("maxhp") / 4))
				part:set("hp", part:get("maxhp"))
			end
			
			hp = hp + math.max(part:get("hp"), 0)
			part.yscale = self.yscale
			part.xscale = self.xscale
			local targety = self.y - 1 - (i - 1) * (40 * self.yscale)
			local dif = 0
			if part.y ~= targety then
				dif = 0.5 + math.abs(part.y - targety) * 0.08
			end
			part.y = math.approach(part.y, targety, dif)
			
			part:getData().towerSlot = i
		else
			toRemove = i
		end
	end
	if selfData.applyElite then
		selfData.applyElite = nil
	end
	if toRemove then table.remove(selfData.parts, toRemove) end
	self:set("hp", hp)
end)

callback.register("onDamage", function(target, damage, source)
	if target:getObject() == obj.TotemController then
		return true
	end
end)

local partToKey = {
	[1] = "z",
	[2] = "x",
	[3] = "c",
	[4] = "v"
}
local keyToAlarm = {
	["z"] = 2,
	["x"] = 3,
	["c"] = 4,
	["v"] = 5
}

obj.TotemPart:addCallback("step", function(self)
	self.spriteSpeed = 0.15
	
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	local activity = selfAc.activity
	
	selfAc.ghost_x = self.x
	selfAc.ghost_y = self.y
	
	if misc.getTimeStop() == 0 then
		if activity == 0 then
			
			if net.host then
				local myTeam = selfAc.team
				local xr, yr = 300, 65
				for _, actor in ipairs(pobj.actors:findAllRectangle(self.x - xr, self.y - yr, self.x + xr, self.y + yr)) do
					if actor:get("team") ~= myTeam then
						local k = partToKey[selfData.partIndex]
						if self:getAlarm(keyToAlarm[k]) <= 0 and global.timer % 10 == 0 then
							local var = k.."_skill"
							selfAc[var] = 1
							syncAttack:sendAsHost(net.ALL, nil, self.x, self.y, var)
							break
						end
					end
				end
			end
			
			for k, v in pairs(NPC.skills[object]) do
				if self:get(v.key.."_skill") > 0 and self:getAlarm(k + 1) == -1 then
					selfData.attackFrameLast = 0
					self:set(v.key.."_skill", 0)
					if v.start then
						v.start(self)
						selfAc.activity = k
					end
					self.subimage = 1
					if v.cooldown then
						self:setAlarm(k + 1, v.cooldown * (1 - self:get("cdr")))
					end
				else
					self:set(v.key.."_skill", 0)
				end
			end
		else
			local skill = NPC.skills[object][activity]
			if skill then
				local relevantFrame = 0
				local newFrame = math.floor(self.subimage)
				if newFrame > selfData.attackFrameLast then
					relevantFrame = newFrame
					selfData.attackFrameLast = newFrame
				end
				if selfAc.free == 0 then
					selfAc.pHspeed = 0
				end
				if skill.update then
					skill.update(self, relevantFrame)
				end
				self.spriteSpeed = skill.speed * selfAc.attack_speed
				self:set("activity_type", 1)
				if skill.sprite then
					self.sprite = skill.sprite
				end
				if newFrame == self.sprite.frames then
					selfAc.activity = 0
					selfAc.activity_type = 0
					selfAc.state = "chase"
					self.sprite = self:getAnimation("idle")
				end
			end
		end
	else
		self.spriteSpeed = 0
	end
	
	if not net.host then
		selfAc.hp = math.max(selfAc.hp, 1)
	end
	
	if not selfData.controller or not selfData.controller:isValid() then
		self:delete()
	else
		self.x = selfData.controller.x
	end
end)

table.insert(call.postStep, function()
	for _, self in ipairs(obj.TotemPart:findMatchingOp("hp", "<=", 0)) do
		self:set("hp", 1)
	end
end)

obj.TotemPart:addCallback("destroy", function(self)
	syncDeath:sendAsHost(net.ALL, nil, self.x, self.y)
end)

mcard.MechanicalTotem = MonsterCard.new("MechanicalTotem", obj.TotemController)
mcard.MechanicalTotem.type = "classic"
mcard.MechanicalTotem.cost = 640
--mcard.MechanicalTotem.sound = sSpawn
mcard.MechanicalTotem.sprite = spr.Nothing
mcard.MechanicalTotem.isBoss = true
mcard.MechanicalTotem.canBlight = false

local originalElites = {
	elt.Blazing,
	elt.Overloading,
	elt.Frenzied,
	elt.Leeching,
	elt.Volatile
}

for _, eliteType in ipairs(originalElites) do
	mcard.MechanicalTotem.eliteTypes:add(eliteType)
end

for s, stage in pairs(stages) do
	stage.enemies:add(mcard.MechanicalTotem)
end