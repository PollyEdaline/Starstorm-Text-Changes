local path = "Actors/Eye/"

local stages = {}
--stages.desolate = stg.DesolateForest
--stages.dried = stg.DriedLake
stages.damp = stg.DampCaverns
--stages.sky = stg.SkyMeadow
stages.ancient = stg.AncientValley
--stages.sunken = stg.SunkenTombs
--stages.boar = stg.BoarBeach
stages.magma = stg.MagmaBarracks
stages.hive = stg.HiveCluster
stages.temple = stg.TempleoftheElders
--stages.risk = stg.RiskofRain

local sprPortrait = Sprite.load("EyePortrait", path.."Portrait", 1, 119, 119)
local sprMask = Sprite.load("EyeMask", path.."Mask", 1, 21, 23)
local sprPalette = Sprite.load("EyePal", path.."palette", 1, 0, 0)
local sprSpawn = Sprite.load("EyeSpawn", path.."Spawn", 16, 21, 24)
local sprIdle = Sprite.load("EyeIdle", path.."Idle", 13, 21, 24)
local sprWalk = Sprite.load("EyeWalk", path.."Walk", 8, 23, 25)
local sprShoot1 = Sprite.load("EyeShoot1", path.."Shoot1", 13, 21, 24)
local sprShoot2 = Sprite.load("EyeShoot2", path.."Shoot2", 15, 21, 34)
local sprShoot3 = Sprite.load("EyeShoot3", path.."Shoot3", 13, 21, 24)
local sprDeath = Sprite.load("EyeDeath", path.."Death", 2, 21, 26)
local sprDeath2 = Sprite.load("EyeDeath2", path.."Death2", 12, 21, 24)
local sprImpact = Sprite.load("EyeImpact", path.."Impact", 4, 19, 19)
local sprPreimpact = Sprite.load("EyePreimpact", path.."Preimpact", 3, 20, 20)
local sDeath = Sound.load("EyeDeath", path.."death")
local sCharge = Sound.load("EyeCharge", path.."charge")
local sExplosion = Sound.load("EyeExplosion", path.."explosion")
local sShoot1 = Sound.load("EyeShoot1", path.."shoot1")
local sShoot2 = Sound.load("EyeShoot2", path.."shoot2")
local sShoot3 = Sound.load("EyeShoot3", path.."shoot3")
local sSpawn = Sound.load("EyeSpawn", path.."spawn")

local phaseTwo = {
	mask = Sprite.load("EyeMask2", path.."Mask2", 1, 10, 8),
	idle = Sprite.load("EyeIdle2", path.."Idle2", 4, 21, 24),
	shoot1 = Sprite.load("EyeShoot1_2", path.."Shoot1_2", 13, 21, 24),
	death = Sprite.load("EyeDeath2_2", path.."Death2_2", 2, 21, 24)
}

local mixColor = Color.fromHex(0xDCA0E0)

local objEyeBomb = Object.new("EyeBomb")
objEyeBomb.sprite = Sprite.load("EyeBomb", path.."bomb", 5, 12, 12)
objEyeBomb.depth = -12
objEyeBomb:addCallback("create", function(self)
	obj.EfFlash:create(0,0):set("parent", self.id):set("rate", 0.08)
	local selfData = self:getData()
	self.spriteSpeed = 0.18
	
	selfData.timer = 130
	selfData.range = 25
	selfData.btimer = 15
	selfData.team = "enemy" 
	selfData.damage = 30
	selfData.ctimer = 0
end)
objEyeBomb:addCallback("step", function(self)
	local selfData = self:getData()
	
	if misc.getTimeStop() == 0 then
		self.spriteSpeed = 0.18
		local target = nearestMatchingOp(self, pobj.actors, "team", "~=", selfData.team)
		if target and target:isValid() then
			local angle = posToAngle(self.x, self.y, target.x, target.y)
			local odir = self:get("direction")
			local dif = odir - angle
			
			if target.x < self.x then angle = angle - 360 end
			
			self:set("direction", odir + (angleDif(odir, angle) * -0.0135))
			self:set("speed", math.max(1, self:get("speed") + 0.01))
		end
		
		if selfData.ctimer < 0 then
			local parent = selfData.parent
			local r = selfData.range
			if parent and parent:isValid() then
				for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - r, self.y - r, self.x + r, self.y + r)) do
					if actor:get("team") ~= parent:get("team") then
						selfData.boom = true
					end
				end
			end
			
			if selfData.timer < 0 or selfData.boom then
				self.xscale = 0.5 + (selfData.btimer / 60)
				self.yscale = 0.5 + (selfData.btimer / 60)
				self.blendColor = Color.mix(mixColor, Color.WHITE, selfData.btimer / 30)
				if selfData.btimer < 0 then
					obj.EfSparks:create(self.x, self.y):set("depth", -12).sprite = sprImpact
					if parent and parent:isValid() then
						parent:fireExplosion(self.x, self.y, r / 19, r / 4, selfData.damage / parent:get("damage"))
					else
						misc.fireExplosion(self.x, self.y, (r * 0.8) / 19, (r * 0.8) / 4, selfData.damage, selfData.team)
					end
					if onScreen(self) then
						misc.shakeScreen(3)
					end
					sExplosion:play(0.9 + math.random() * 0.2, 0.8)
					self:destroy()
				else
					if selfData.btimer == 15 then
						obj.EfSparks:create(self.x, self.y):set("depth", -12).sprite = sprPreimpact
						sCharge:play(0.9 + math.random() * 0.2, 0.8)
					end
					selfData.btimer = selfData.btimer - 1
				end
			else
				selfData.timer = selfData.timer - 1
			end
		else
			selfData.ctimer = selfData.ctimer -1
		end
	else
		self.spriteSpeed = 0
		self:set("speed", 0)
	end
end)

obj.Eye = Object.base("BossClassic", "Eye")
obj.Eye.sprite = sprIdle

EliteType.registerPalette(sprPalette, obj.Eye)

NPC.setSkill(obj.Eye, 1, 390, 60 * 3.5, nil, 0.2, function(actor)
	if actor:getData().phase2 then
		sShoot1:play(1.1 + math.random() * 0.2, 0.74)
	else
		sShoot1:play(0.9 + math.random() * 0.2, 0.74)
	end
	actor.sprite = actor:getAnimation("shoot1")
	actor.subimage = 1
end, function(actor, relevantFrame)
	actor.sprite = actor:getAnimation("shoot1")
	
	local dir = actor:getFacingDirection()
	local target = Object.findInstance(actor:get("target"))
	if target and target:isValid() then
		dir = posToAngle(actor.x, actor.y, target.x, target.y)
	end
	if relevantFrame == 11 then
		sfx.BossSkill2:play(0.8, 0.8)
		if actor:getData().phase2 then
			for i = -1, 1 do
				local o = objEyeBomb:create(actor.x, actor.y)
				local od = o:getData()
				o:set("direction", dir + (25 * i))
				od.parent = actor
				od.damage = actor:get("damage")
				od.team = actor:get("team")
				od.range = od.range * 0.85
				od.timer = od.timer + (i * 5)
				o.xscale = o.xscale * 0.7
				o.yscale = o.yscale * 0.7
				if onScreen(actor) then
					misc.shakeScreen(7)
				end
			end
		else
			local o = objEyeBomb:create(actor.x, actor.y)
			local od = o:getData()
			o:set("direction", dir)
			od.parent = actor
			od.damage = actor:get("damage") * 1.5
			od.team = actor:get("team")
			--sfx.BossSkill2:play(0.7, 0.2)
			if onScreen(actor) then
				misc.shakeScreen(7)
			end
		end
	end
end)

NPC.setSkill(obj.Eye, 2, 0, 999, sprShoot2, 0.2, function(actor)
	if actor:getData().phase2 then
		sShoot2:play(1.1 + math.random() * 0.2, 0.8)
	else
		sShoot2:play(0.9 + math.random() * 0.2, 0.8)
	end
	actor:setAnimations(phaseTwo)
	actor:setAnimation("jump", actor:getAnimation("idle"))
	actor:setAnimation("walk", actor:getAnimation("idle"))
	actor:getData().phase2 = true
	actor:set("invincible", 40)
	actor:set("pHmax", actor:get("pHmax") - 0.2)
end, function(actor, relevantFrame)
	if relevantFrame == 11 then
		actor.mask = phaseTwo.mask
		if onScreen(actor) then
			misc.shakeScreen(3)
		end
		--actor:fireExplosion(actor.x, actor.y, 45 / 19, 70 / 4, 2)
	end
end)


NPC.setSkill(obj.Eye, 3, 60, 60 * 20, nil, 0.2, function(actor)
	if not actor:getData().phase2 then
		sShoot3:play(0.9 + math.random() * 0.2, 1)
		actor.sprite = actor:getAnimation("shoot3")
		actor.subimage = 1
	end
end, function(actor, relevantFrame)
	if not actor:getData().phase2 then
		actor.sprite = actor:getAnimation("shoot3")
		if relevantFrame == 9 then
			local nearB = nil
			for _, instance2 in ipairs(obj.B:findAll()) do
				if not instance2:collidesWith(actor, instance2.x, instance2.y - 1) then
					local dis = distance(actor.x, actor.y, instance2.x, instance2.y)
					if not nearB or dis < nearB.dis then
						nearB = {inst = instance2, dis = dis}
					end
				end
			end
			if nearB then
				nearB = nearB.inst
				if nearB:isValid() then
					local groundL = nearB.x - (nearB.sprite.boundingBoxLeft * nearB.xscale)
					local groundR = nearB.x + (nearB.sprite.boundingBoxRight * nearB.xscale)
					xx = math.clamp(actor.x, groundL, groundR)
					
					actor.y = nearB.y - actor.sprite.height + actor.sprite.yorigin
					actor.x = xx
					actor:set("ghost_x", actor.x)
					actor:set("ghost_y", actor.y)
				end
			end
		end
	end
end)


obj.Eye:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Overseer"
	selfAc.name2 = "Lurcher of Planes"
	selfAc.damage = 22 * Difficulty.getScaling("damage")
	selfAc.maxhp = 1200 * Difficulty.getScaling("hp")
	selfAc.hp = selfAc.maxhp
	selfAc.pVmax = 3
	selfAc.pHmax = 1
	selfAc.can_jump = 1
	selfAc.can_drop = 1
	selfAc.exp_worth = 50 * Difficulty.getScaling()
	selfAc.point_value = 1310
	selfAc.knockback_cap = selfAc.maxhp * 0.3
	selfAc.sound_death = sDeath.id
	selfAc.sound_hit = sfx.ImpHit.id
	selfAc.hit_pitch = 0.9
	selfAc.sprite_palette = sprPalette.id
	selfAc.sprite_idle = sprIdle.id
	selfAc.sprite_walk = sprWalk.id
	selfAc.sprite_jump = sprWalk.id
	selfAc.sprite_death = sprDeath.id
	self:setAnimation("shoot1", sprShoot1)
	self:setAnimation("shoot3", sprShoot3)
end)

obj.Eye:addCallback("step", function(self)
	self.spriteSpeed = 0.15
	
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	local activity = selfAc.activity
	
	if self.sprite == self:getAnimation("death") then self.subimage = 1 end
	
	if selfAc.hp <= selfAc.maxhp * 0.5 and not selfData.phase2 and net.host then
		selfAc.x_skill = 1
		syncInstanceVar:sendAsHost(net.ALL, nil, self:getNetIdentity(), "x_skill", 1)
	end
	
	if selfData.phase2 then
		selfAc.pGravity1 = 0
		selfAc.pGravity2 = 0
		if misc.getTimeStop() == 0 and activity < 2 then
			local target = Object.findInstance(selfAc.target)
			if target and target:isValid() then
				selfAc.pVspeed = 0
				local dif = target.y - self.y
				local ty = math.approach(self.y, target.y, dif * 0.08)
				
				if self:collidesMap(self.x, self.y) or self:collidesMap(self.x -1, self.y) or self:collidesMap(self.x + 1, self.y) then -- NICE CODE WEIRDO
					if target.x < self.x - 20 then
						self.x = self.x - selfAc.pHmax
					elseif target.x > self.x + 20 then
						self.x = self.x + selfAc.pHmax
					end
				end
				
				--if not self:collidesMap(self.x, ty) then
					self.y = ty
				--end
			end
		end
	end
	
	if misc.getTimeStop() == 0 then
		if activity == 0 then
			for k, v in pairs(NPC.skills[object]) do
				if self:get(v.key.."_skill") > 0 and self:getAlarm(k + 1) == -1 then
					selfData.attackFrameLast = 0
					self:set(v.key.."_skill", 0)
					if v.start then
						v.start(self)
					end
					selfAc.activity = k
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
				selfAc.activity_type = 1
				if skill.sprite then
					self.sprite = skill.sprite
				end
				if newFrame == self.sprite.frames then
					selfAc.activity = 0
					selfAc.activity_type = 0
					selfAc.state = "chase"
				end
			end
		end
	else
		self.spriteSpeed = 0
	end
end)

table.insert(call.preHit, function(damager, target)
	local damage = damager:get("damage")
	if target:getObject() == obj.Eye then
		local tAc = target:getAccessor()
		if tAc.hp > tAc.maxhp * 0.5 and tAc.hp - damage <= tAc.maxhp * 0.5 and not target:getData().phase2 then
			damager:set("damage", math.min(damage, tAc.maxhp * 0.5))
			tAc.invincible = 40
		elseif target.sprite == target:getAnimation("shoot2") then
			damager:set("damage", 0)
		end
	end
end)

mcard.Overseer = MonsterCard.new("Overseer", obj.Eye)
mcard.Overseer.type = "classic"
mcard.Overseer.cost = 1310
mcard.Overseer.sound = sSpawn
mcard.Overseer.sprite = sprSpawn
mcard.Overseer.isBoss = false
mcard.Overseer.canBlight = true
 
for s, stage in pairs(stages) do
	stage.enemies:add(mcard.Overseer)
end

local c = Color.fromHex(0x8F4E4E)

onNPCDeath.eye = function(npc, object)
	if object == obj.Eye then
		local s = obj.EfSparks:create(npc.x, npc.y)
		s.sprite = sprDeath2
		s.xscale = npc.xscale
		s.yscale = npc.yscale
		s.blendColor = npc.blendColor
		for i = 1, 4 do
			obj.Guts:create(npc.x, npc.y):set("particle_color", c.gml):set("direction", math.random(360)).blendColor = c
		end
	end
end

mlog.Overseer = MonsterLog.new("Overseer")
MonsterLog.map[obj.Eye] = mlog.Overseer
mlog.Overseer.displayName = "Overseer"
mlog.Overseer.story = "It is during a moment of peace that I find this extraordinary outlier. The Overseer watches, calmly hidden behind a distant rock formation as I shelter myself for the storm brewing on the horizon.\nRaindrops start falling from the sky as I stare back. It takes notice; it has been caught. However, it doesn't move.\nThe next thing I see is a pair of Imps rapidly approaching it; it blinks away the same way the Imps do. I turn around to hide and there it is, still attentive of my actions, but just a few feet away from me. I feel threatened and can't take chances.. it's a duel.\n\nI can't help but wonder if it had good intentions. It's clear its presence wasn't appreciated by the Imps. Could it be an outcast of their family?"
mlog.Overseer.statHP = 1200
mlog.Overseer.statDamage = 22
mlog.Overseer.statSpeed = 1
mlog.Overseer.sprite = sprIdle
mlog.Overseer.portrait = sprPortrait