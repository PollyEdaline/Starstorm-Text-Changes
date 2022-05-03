local path = "Actors/VGuard/"

local sprPalette = Sprite.load("VoidGuardPal", path.."Palette", 1, 0, 0)
local sprMask = Sprite.load("VoidGuardMask", path.."Mask", 1, 11, 14)
local sprSpawn = Sprite.load("VoidGuardSpawn", path.."Spawn", 18, 25, 26)
local sprIdle = Sprite.load("VoidGuardIdle", path.."Idle", 4, 22, 18)
local sprWalk = Sprite.load("VoidGuardWalk", path.."Walk", 8, 25, 25)
local sprShoot1 = Sprite.load("VoidGuardShoot1", path.."Shoot1", 16, 26, 30)
local sprDeath = Sprite.load("VoidGuardDeath", path.."Death", 12, 27, 18)

local sSpawn = Sound.load("VoidGuardSpawn", path.."Spawn")
local sShoot = Sound.load("VoidGuardShoot", path.."Shoot")
local sDeath = Sound.load("VoidGuardDeath", path.."Death")

obj.VoidGuard = Object.base("EnemyClassic", "VoidGuard")
obj.VoidGuard.sprite = sprIdle

EliteType.registerPalette(sprPalette, obj.VoidGuard)

NPC.setSkill(obj.VoidGuard, 1, 250, 60 * 4, sprShoot1, 0.2, nil, function(actor, relevantFrame)
	local actorData = actor:getData()
	if relevantFrame >= 8 and relevantFrame <= 13  then
		sShoot:play(0.9 + math.random() * 0.2, 0.9)
		local bullet = obj.TotemBullet:create(actor.x + 10 * math.abs(actor.xscale), actor.y - 7 * math.abs(actor.yscale))
		bullet:getData().parent = actor
		bullet:getData().team = actor:get("team")
		bullet:getData().damage = actor:get("damage") * 0.4
		local elite = actor:getElite()
		if elite then
			bullet:getData()._EfColor = elite.color
		else
			bullet:getData()._EfColor = Color.fromHex(0xFF00B6)
		end
		
		local bullet = obj.TotemBullet:create(actor.x - 10 * math.abs(actor.xscale), actor.y - 7 * math.abs(actor.yscale))
		bullet:getData().parent = actor
		bullet:getData().team = actor:get("team")
		bullet:getData().damage = actor:get("damage") * 0.4
		if elite then
			bullet:getData()._EfColor = elite.color
		else
			bullet:getData()._EfColor = Color.fromHex(0xFF00B6)
		end
	end
end)

obj.VoidGuard:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Void Guard"
	selfAc.damage = 25 * Difficulty.getScaling("damage")
	selfAc.maxhp = 600 * Difficulty.getScaling("hp")
	selfAc.armor = 0
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 1
	selfAc.knockback_cap = selfAc.maxhp
	selfAc.exp_worth = 40 * Difficulty.getScaling()
	selfAc.point_value = 450
	selfAc.can_drop = 1
	selfAc.can_jump = 1
	selfAc.sound_hit = sfx.GuardHit.id
	selfAc.hit_pitch = 0.8
	selfAc.sound_death = sDeath.id
	selfAc.sprite_palette = sprPalette.id
	selfAc.sprite_idle = sprIdle.id
	selfAc.sprite_walk = sprWalk.id
	selfAc.sprite_jump = sprIdle.id
	selfAc.sprite_death = sprDeath.id
end)

obj.VoidGuard:addCallback("step", function(self)
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
	
	if alarm7 > 2 then
		self:setAlarm(7, alarm7 - 1)
	end
	
	if self.sprite.id == selfAc.sprite_death then
		self.subimage = 1
	end
end)

mcard.VoidGuard = MonsterCard.new("Void Guard", obj.VoidGuard)
mcard.VoidGuard.type = "classic"
mcard.VoidGuard.cost = 450
mcard.VoidGuard.sound = sSpawn
mcard.VoidGuard.sprite = sprSpawn
mcard.VoidGuard.isBoss = false
mcard.VoidGuard.canBlight = true