local pPath = "Actors/Stray/"
local path = pPath.."Shudder/"

local sprPalette = Sprite.load("ShudderPal", pPath.."Palette", 1, 0, 0)
local sprMask = Sprite.load("ShudderMask", path.."Mask", 1, 5, 13)
local sprSpawn = Sprite.load("ShudderSpawn", path.."Spawn", 15, 10, 15)
local sprIdle = Sprite.load("ShudderIdle", path.."Idle", 1, 8, 15)
local sprWalk = Sprite.load("ShudderWalk", path.."Walk", 8, 6, 17)
local sprShoot2 = Sprite.load("ShudderShoot2", path.."Shoot2", 22, 15, 24)
local sprDeath = Sprite.load("ShudderDeath", path.."Death", 14, 12, 24)

local sSpawn = Sound.load("ShudderSpawn", path.."Spawn")
local sDeath = Sound.load("ShudderDeath", path.."Death")
local sShoot = Sound.load("ShudderShoot", path.."Shoot")
local sShoot2 = Sound.load("ShudderShoot2", path.."Shoot2")
local sHit = Sound.load("ShudderHit", path.."Hit")

obj.Shudder = Object.base("EnemyClassic", "Shudder")
obj.Shudder.sprite = sprIdle

EliteType.registerPalette(sprPalette, obj.Shudder)

local buffShudder = Buff.new("shudder")
buffShudder.sprite = Sprite.load("ShudderBuff", path.."Buff", 1, 9, 9)
buffShudder:addCallback("start", function(actor)
	actor:set("invincible", 5)
	local outline = obj.EfOutline:create(0, 0)
	outline:set("rate", 0)
	outline:set("parent", actor.id)
	outline.blendColor = Color.WHITE
	outline.alpha = 0.8
	outline.depth = actor.depth + 1
end)
buffShudder:addCallback("step", function(actor)
	actor:set("invincible", 2)
end)
buffShudder:addCallback("end", function(actor)
	for _, outline in ipairs(obj.EfOutline:findMatching("parent", actor.id)) do
		if Color.equals(outline.blendColor, Color.WHITE) then
			outline:destroy()
			break
		end
	end
end)

local objShudderBullet = Object.new("ShudderBullet")
objShudderBullet:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.life = 240
	selfData.damage = 15
	selfData.team = "enemy"
	self.sprite = spr.EfBomb
	self.alpha = 0
	self.xscale = 0.4
	self.yscale = 0.4
end)
objShudderBullet:addCallback("step", function(self)
	local selfData = self:getData()
	if misc.getTimeStop() == 0 then
		self:set("speed", math.min(self:get("speed") + 0.02, 4))
		if selfData.target and selfData.target:isValid() then
			if self:collidesWith(selfData.target, self.x, self.y) then
				selfData.life = 0
				if selfData.parent and selfData.parent:isValid() then
					selfData.parent:fireExplosion(self.x, self.y, 15 / 19, 15 / 4, 0.4, nil, spr.Sparks7)
				else
					misc.fireExplosion(self.x, self.y, 15 / 19, 15 / 4, selfData.damage, selfData.team, spr.Sparks7)
				end
			end
		else
			local target = nearestMatchingOp(self, pobj.actors, "team", "~=", selfData.team)
			if target then
				self:set("direction", posToAngle(self.x, self.y, target.x, target.y))
				selfData.target = target
			end
		end
		if selfData.life > 0 then
			selfData.life = selfData.life - 1
		else
			self:destroy()
		end
	else
		self:set("speed", 0)
	end
end)
objShudderBullet:addCallback("draw", function(self)
	local selfData = self:getData()
	local size = math.min(4 + math.sin(selfData.life * 0.4) * 0.5, selfData.life * 0.5)
	local color = Color.WHITE
	if selfData.elite then color = selfData.elite.color end
	graphics.color(Color.WHITE)
	graphics.alpha(0.8)
	graphics.circle(self.x, self.y, size, true)
	graphics.color(color)
	graphics.circle(self.x, self.y, size - 2, false)
end)

NPC.setSkill(obj.Shudder, 1, 300, 60 * 8, sprShoot1, 0.2, function(actor)--, function(actor, relevantFrame)
	local actorData = actor:getData()
	local c = obj.EfCircle:create(actor.x, actor.y)
	c:set("radius", 100)
	c.blendColor = Color.WHITE
	c.depth = -3
	sShoot:play(0.9 + math.random() * 0.2, 0.9)
	local myTeam = actor:get("team")
	for _, aactor in ipairs(pobj.actors:findAllEllipse(actor.x - 100, actor.y - 100, actor.x + 100, actor.y + 100)) do
		if aactor:get("team") == myTeam then
			if not isaDrone(aactor) then
				aactor:applyBuff(buffShudder, 180)
			end
		end
	end
end)

NPC.setSkill(obj.Shudder, 2, 500, 60 * 7, sprShoot2, 0.2, function()
	sShoot2:play(0.9 + math.random() * 0.2, 0.9)
end, function(actor, relevantFrame)
	if relevantFrame >= 10 and relevantFrame <= 18 and relevantFrame % 2 == 0 then
		local bullet = objShudderBullet:create(actor.x, actor.y - 9)
		bullet:getData().damage = actor:get("damage") * 0.8
		bullet:getData().team = actor:get("team")
		bullet:getData().parent = actor
		bullet:getData().elite = actor:getElite()
	end
end)



obj.Shudder:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Shudder"
	selfAc.damage = 13 * Difficulty.getScaling("damage")
	selfAc.maxhp = 180 * Difficulty.getScaling("hp")
	selfAc.armor = 0
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 0.7
	selfAc.knockback_cap = selfAc.maxhp
	selfAc.exp_worth = 20 * Difficulty.getScaling()
	selfAc.point_value = 85
	selfAc.can_drop = 0
	selfAc.can_jump = 0
	selfAc.sound_hit = sHit.id
	selfAc.hit_pitch = 1
	selfAc.sound_death = sDeath.id
	selfAc.sprite_palette = sprPalette.id
	selfAc.sprite_idle = sprIdle.id
	selfAc.sprite_walk = sprWalk.id
	selfAc.sprite_jump = sprIdle.id
	selfAc.sprite_death = sprDeath.id
	self:getData().warpTimer = 0
	self:getData().lastHp = selfAc.hp
	self:getData().fearTimer = 0
end)

obj.Shudder:addCallback("step", function(self)
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	local activity = selfAc.activity
	
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
	
	local alarm7 = self:getAlarm(7)
	
	if selfData.warpTimer > 0 then
		selfData.warpTimer = selfData.warpTimer - 1 
	else
		if selfData.lastHp > selfAc.hp and self:getAlarm(7) <= 0 and selfAc.activity == 0 and selfAc.invincible == 0 then
			local xx = 0
			for i = 1, 20 do
				if self:collidesMap(self.x + self.xscale * i, self.y) then
					break
				else
					xx = xx + 1
				end
			end
			if xx > 0 then
				obj.EfFlash:create(0,0):set("parent", self.id):set("rate", 0.08)
				selfData.warpTimer = 60
				self.x = self.x + self.xscale * xx
			end
		end
	end
	
	self:getData().lastHp = selfAc.hp
	
	if self.sprite.id == selfAc.sprite_death then
		self.subimage = 1
	end
	local target = Object.findInstance(selfAc.target)
	if target and target:isValid() then
		if target.x > self.x - 200 and target.x < self.x + 200 and
		target.y > self.y - 150 and target.y < self.y + 150 then
			if selfData.fearTimer > 0 then
				selfData.fearTimer = selfData.fearTimer - 1
			else
				selfData.fearTimer = 180
				local damager = misc.fireBullet(self.x, self.y, self:getFacingDirection(), 4, 0, "n"):set("specific_target", self.id)
				damager:set("fear", 2)
			end
		end
	end
	for _, fear in ipairs(obj.EfFear:findMatching("parent", self.id)) do
		fear.visible = false
	end
end)

--[[obj.Shudder:addCallback("destroy", function(self)
	local selfAc = self:getAccessor()
	--objShudderBlast
end)]]

mcard.Shudder = MonsterCard.new("Shudder", obj.Shudder)
mcard.Shudder.type = "classic"
mcard.Shudder.cost = 85
mcard.Shudder.sound = sSpawn
mcard.Shudder.sprite = sprSpawn
mcard.Shudder.isBoss = false
mcard.Shudder.canBlight = true