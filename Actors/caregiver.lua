local pPath = "Actors/Stray/"
local path = pPath.."Caregiver/"

local sprPalette = Sprite.load("CaregiverPal", pPath.."Palette", 1, 0, 0)
local sprMask = Sprite.load("CaregiverMask", path.."Mask", 1, 12, 23)
local sprSpawn = Sprite.load("CaregiverSpawn", path.."Spawn", 12, 22, 26)
local sprIdle = Sprite.load("CaregiverIdle", path.."Idle", 1, 17, 26)
local sprWalk = Sprite.load("CaregiverWalk", path.."Walk", 8, 17, 26)
local sprShoot1 = Sprite.load("CaregiverShoot1", path.."Shoot1", 18, 37, 26)
local sprDeath = Sprite.load("CaregiverDeath", path.."Death", 25, 19, 26)

local sSpawn = Sound.load("CaregiverSpawn", path.."Spawn")
local sShoot1 = Sound.load("CaregiverShoot1", path.."Shoot1")
local sDeath = Sound.load("CaregiverDeath", path.."Death")

obj.Caregiver = Object.base("EnemyClassic", "Caregiver")
obj.Caregiver.sprite = sprIdle

EliteType.registerPalette(sprPalette, obj.Caregiver)

NPC.setSkill(obj.Caregiver, 1, 30, 60 * 4, sprShoot1, 0.2, nil, function(actor, relevantFrame)
	local actorData = actor:getData()
	if relevantFrame == 1  then
		sShoot1:play(0.9 + math.random() * 0.2)
	elseif relevantFrame == 12  then
		local b = actor:fireExplosion(actor.x + 10 * actor.xscale, actor.y + 5, 30 / 19, 18 / 4, 1.5, nil, spr.Sparks5)
		b:set("taser", 1)
	end
end)

obj.Caregiver:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Caregiver"
	selfAc.damage = 35 * Difficulty.getScaling("damage")
	selfAc.maxhp = 500 * Difficulty.getScaling("hp")
	selfAc.armor = 0
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 0.9
	selfAc.knockback_cap = selfAc.maxhp
	selfAc.exp_worth = 55 * Difficulty.getScaling()
	selfAc.point_value = 350
	selfAc.can_drop = 1
	selfAc.can_jump = 1
	selfAc.sound_hit = sfx.ChildHit.id
	selfAc.hit_pitch = 0.8
	selfAc.sound_death = sDeath.id
	selfAc.sprite_palette = sprPalette.id
	selfAc.sprite_idle = sprIdle.id
	selfAc.sprite_walk = sprWalk.id
	selfAc.sprite_jump = sprIdle.id
	selfAc.sprite_death = sprDeath.id
	self:getData().warpTimer = 0
	self:getData().lastHp = selfAc.hp
end)

obj.Caregiver:addCallback("step", function(self)
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

mcard.Caregiver = MonsterCard.new("Caregiver", obj.Caregiver)
mcard.Caregiver.type = "classic"
mcard.Caregiver.cost = 350
mcard.Caregiver.sound = sSpawn
mcard.Caregiver.sprite = sprSpawn
mcard.Caregiver.isBoss = false
mcard.Caregiver.canBlight = true