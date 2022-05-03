local pPath = "Actors/Stray/"
local path = pPath.."Amalgolem/"

local sprPalette = Sprite.load("AmalgolemPal", pPath.."Palette", 1, 0, 0)
local sprMask = Sprite.load("AmalgolemMask", path.."Mask", 1, 10, 15)
local sprSpawn = Sprite.load("AmalgolemSpawn", path.."Spawn", 11, 27, 28)
local sprIdle = Sprite.load("AmalgolemIdle", path.."Idle", 1, 18, 24)
local sprWalk = Sprite.load("AmalgolemWalk", path.."Walk", 8, 27, 25)
local sprShoot1 = Sprite.load("AmalgolemShoot1", path.."Shoot1", 28, 28, 24)
local sprDeath = Sprite.load("AmalgolemDeath", path.."Death", 15, 23, 28)

local sSpawn = Sound.load("AmalgolemSpawn", path.."Spawn")
--local sCharge = Sound.load("AmalgolemCharge", path.."Charge")

obj.Amalgolem = Object.base("EnemyClassic", "Amalgolem")
obj.Amalgolem.sprite = sprIdle

EliteType.registerPalette(sprPalette, obj.Amalgolem)

NPC.setSkill(obj.Amalgolem, 1, 250, 60 * 6, sprShoot1, 0.2, nil, function(actor, relevantFrame)
	local actorData = actor:getData()
	if relevantFrame == 10 or relevantFrame == 15 or relevantFrame == 20 or relevantFrame == 25 then
		actor:fireExplosion(actor.x + 10 * actor.xscale, actor.y + 5, 34 / 19, 18 / 4, 1.5, nil, spr.Sparks7)
		sfx.GolemAttack1:play(1 + math.random() * 0.2, 0.8)
	end
end)

obj.Amalgolem:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Slag Golem"
	selfAc.damage = 25 * Difficulty.getScaling("damage")
	selfAc.maxhp = 450 * Difficulty.getScaling("hp")
	selfAc.armor = 0
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 0.9
	selfAc.knockback_cap = selfAc.maxhp
	selfAc.exp_worth = 40 * Difficulty.getScaling()
	selfAc.point_value = 280
	selfAc.can_drop = 0
	selfAc.can_jump = 0
	selfAc.sound_hit = sfx.GolemHit.id
	selfAc.hit_pitch = 0.8
selfAc.sound_death = sfx.GolemDeath.id--sDeath.id
	selfAc.sprite_palette = sprPalette.id
	selfAc.sprite_idle = sprIdle.id
	selfAc.sprite_walk = sprWalk.id
	selfAc.sprite_jump = sprIdle.id
	selfAc.sprite_death = sprDeath.id
	self:getData().warpTimer = 0
	self:getData().lastHp = selfAc.hp
end)

obj.Amalgolem:addCallback("step", function(self)
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

mcard.SlagGolem = MonsterCard.new("Slag Golem", obj.Amalgolem)
mcard.SlagGolem.type = "classic"
mcard.SlagGolem.cost = 280
mcard.SlagGolem.sound = sSpawn
mcard.SlagGolem.sprite = sprSpawn
mcard.SlagGolem.isBoss = false
mcard.SlagGolem.canBlight = true