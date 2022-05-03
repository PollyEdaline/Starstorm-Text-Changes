local pPath = "Actors/Stray/"
local path = pPath.."Twirl/"

local sprPalette = Sprite.load("TwirlPal", pPath.."Palette", 1, 0, 0)
local sprMask = Sprite.load("TwirlMask", path.."Mask", 1, 8, 16)
local sprSpawn = Sprite.load("TwirlSpawn", path.."Spawn", 12, 20, 27)
local sprIdle = Sprite.load("TwirlIdle", path.."Idle", 1, 17, 27)
local sprWalk = Sprite.load("TwirlWalk", path.."Walk", 8, 22, 27)
local sprShoot1 = Sprite.load("TwirlShoot1", path.."Shoot1", 20, 19, 27)
local sprDeath = Sprite.load("TwirlDeath", path.."Death", 14, 20, 48)

local sSpawn = Sound.load("TwirlSpawn", path.."Spawn")
local sDeath = Sound.load("TwirlDeath", path.."Death")
local sShoot_1 = Sound.load("TwirlShoot_1", path.."Shoot_1")
local sShoot_2 = Sound.load("TwirlShoot_2", path.."Shoot_2")

obj.Twirl = Object.base("EnemyClassic", "Twirl")
obj.Twirl.sprite = sprIdle

EliteType.registerPalette(sprPalette, obj.Twirl)

objTwirlTrail = Object.new("TwirlTrail")
objTwirlTrail.sprite = Sprite.load("TwirlTrail", path.."Trail", 4, 7, 0)
objTwirlTrail:addCallback("create", function(self)
	self:getData().team = "enemy"
	self:getData().life = 160
	self.subimage = math.random(1, self.sprite.frames)
	self.spriteSpeed = 0
	for i = 1, 100 do
		if Stage.collidesPoint(self.x, self.y) then
			break
		else
			self.y = self.y + 1
			if i == 100 then
				self:destroy()
			end
		end
	end

end)
objTwirlTrail:addCallback("step", function(self)
	local parent = self:getData().parent
	if self:getData().life > 0 and self:getData().life % 30 == 0 then
		for _, actor in ipairs(pobj.actors:findAllLine(self.x - 3, self.y - 2, self.x + 3, self.y - 2)) do
			if actor:get("team") ~= self:getData().team then
				if not isaDrone(actor) then
					actor:applyBuff(buff.slow, 120)
				end
			end
		end
	end
	if self:getData().life > 0 then
		self:getData().life = self:getData().life - 1
	elseif self.alpha > 0 then
		self.alpha = self.alpha - 0.1
	else
		self:destroy()
	end
end)

local buffTwirl = Buff.new("twirl")
buffTwirl.sprite = Sprite.load("TwirlBuff", path.."Buff", 1, 9, 9)
buffTwirl:addCallback("start", function(actor)
	
end)
buffTwirl:addCallback("step", function(actor)
	local damage = actor:get("maxhp") * 0.001
	actor:set("hp", actor:get("hp") - damage)
	par.Darkness:burst("middle", actor.x, actor.y, 1)
end)

local objTwirlBullet = Object.new("TwirlBullet")
objTwirlBullet.sprite = Sprite.load("TwirlBullet", path.."Bullet", 4, 6, 5)
objTwirlBullet:addCallback("create", function(self)
	selfData = self:getData()
	self.spriteSpeed = 0.2
	selfData.life = 240
	selfData.hitList = {}
end)
objTwirlBullet:addCallback("step", function(self)
	selfData = self:getData()
	
	if global.quality > 1 then
		par.Darkness:burst("middle", self.x, self.y, 1)
	end
	if selfData.parent and selfData.parent:isValid() then
		local w, h = 10, 4
		for _, actor in ipairs(pobj.actors:findAllRectangle(self.x - w, self.y - h, self.x + w, self.y + h)) do
			if not selfData.hitList[actor] and actor:get("team") ~= selfData.team then
				selfData.hitList[actor] = true
				local bullet = selfData.parent:fireBullet(actor.x, actor.y, actor.xscale, 4, 1, nil)
				bullet:set("specific_target", actor.id)
				if not isaDrone(actor) then
					actor:applyBuff(buffTwirl, 120)
				end
			end
		end
	end
	if misc.getTimeStop() == 0 then
		self:set("speed", 4)
		if selfData.life > 0 then
			selfData.life = selfData.life - 1
		else
			self:destroy()
		end
	else
		self:set("speed", 0)
	end
end)

NPC.setSkill(obj.Twirl, 1, 250, 60 * 4, sprShoot1, 0.2, nil, function(actor, relevantFrame)
	local actorData = actor:getData()
	if relevantFrame == 1 then
		sShoot_1:play(0.9 + math.random() * 0.2)
	elseif relevantFrame == 15  then
		sShoot_2:play(0.9 + math.random() * 0.2)
		local bullet = objTwirlBullet:create(actor.x + 3 * actor.xscale, actor.y + 3)
		bullet.xscale = actor.xscale
		bullet:getData().team = actor:get("team")
		bullet:getData().parent = actor
		bullet:set("direction", actor:getFacingDirection())
		bullet:set("speed", 4)
	end
end)

obj.Twirl:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Twirl"
	selfAc.damage = 15 * Difficulty.getScaling("damage")
	selfAc.maxhp = 200 * Difficulty.getScaling("hp")
	selfAc.armor = 0
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 1.1
	selfAc.knockback_cap = selfAc.maxhp
	selfAc.exp_worth = 18 * Difficulty.getScaling()
	selfAc.point_value = 250
	selfAc.can_drop = 1
	selfAc.can_jump = 1
	selfAc.sound_hit = 100107
	selfAc.hit_pitch = 0.9
	selfAc.sound_death = sDeath.id
	selfAc.sprite_palette = sprPalette.id
	selfAc.sprite_idle = sprIdle.id
	selfAc.sprite_walk = sprWalk.id
	selfAc.sprite_jump = sprIdle.id
	selfAc.sprite_death = sprDeath.id
	self:getData().warpTimer = 0
	self:getData().lastHp = selfAc.hp
end)

obj.Twirl:addCallback("step", function(self)
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	local activity = selfAc.activity
	
	if not objTwirlTrail:findLine(self.x, self.y + 2, self.x, self.y + 102) then
		local trail = objTwirlTrail:create(self.x, self.y)
		trail:getData().team = selfAc.team
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
	
	local alarm7 = self:getAlarm(7)
	
	if selfData.warpTimer > 0 then
		selfData.warpTimer = selfData.warpTimer - 1 
	else
		if selfData.lastHp > selfAc.hp and self:getAlarm(7) <= 0 and selfAc.activity == 0 then
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
	
	if alarm7 > 2 then
		self:setAlarm(7, alarm7 - 1)
	end
	
	selfData.lastHp = selfAc.hp
	
	if self.sprite.id == selfAc.sprite_death then
		self.subimage = 1
	end
end)

mcard.Twirl = MonsterCard.new("Twirl", obj.Twirl)
mcard.Twirl.type = "classic"
mcard.Twirl.cost = 250
mcard.Twirl.sound = sSpawn
mcard.Twirl.sprite = sprSpawn
mcard.Twirl.isBoss = false
mcard.Twirl.canBlight = true