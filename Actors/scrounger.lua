local postLoopStages = {
	stg.DriedLake,
	stg.DampCaverns,
	stg.SunkenTombs,
	stg.HiveCluster
}

local path = "Actors/Scrounger/"

local sprMask = Sprite.load("ScroungerMask", path.."Mask", 1, 7, 12)
local sprPalette = Sprite.load("ScroungerPal", path.."Palette", 1, 0, 0)
local sprSpawn = Sprite.load("ScroungerSpawn", path.."Spawn", 6, 16, 16)
local sprIdle = Sprite.load("ScroungerIdle", path.."Idle", 4, 16, 16)
local sprWalk = Sprite.load("ScroungerWalk", path.."Walk", 4, 16, 16)
local sprShoot1 = Sprite.load("ScroungerShoot1", path.."Shoot1", 14, 18, 30)
local sprDeath = Sprite.load("ScroungerDeath", path.."Death", 11, 20, 16)

local sCharge = Sound.load("ScroungerCharge", path.."Charge")
local sDeath = Sound.load("ScroungerDeath", path.."Death")
local sHit = Sound.load("ScroungerHit", path.."Hit")
local sImpact = Sound.load("ScroungerImpact", path.."Impact")
local sShoot = Sound.load("ScroungerShoot", path.."Shoot")
local sSpawn = Sound.load("ScroungerSpawn", path.."Spawn")

obj.Scrounger = Object.base("EnemyClassic", "Scrounger")
obj.Scrounger.sprite = sprIdle

EliteType.registerPalette(sprPalette, obj.Scrounger)

objBullet = Object.new("ScroungerBullet")
objBullet:addCallback("create", function(self)
	local data = self:getData()
	local ac = self:getAccessor()
	
	--ac.speed = 4
	data.acc = 0
	data.life = 140
	data.damage = 10
	data.team = "enemy"
	data.flV = 6
	data.flA = 0
	data.flVDecay = 0.06
end)
local acidColor = Color.fromHex(0xE0FF75)
objBullet:addCallback("step", function(self)
	if global.quality > 1 then
		par.Acid:burst("middle", self.x, self.y, 1, acidColor)
	end
	
	local data = self:getData()
	local ac = self:getAccessor()
	
	data.acc = data.acc + 0.05
	--ac.speed = ac.speed + 0.05
	
	self.y = self.y + data.acc
	
	data.flA = math.rad(ac.direction)
	
	if not self:collidesMap(self.x + math.cos(data.flA) * data.flV, self.y - math.sin(data.flA) * data.flV) then
		self.x, self.y = self.x + math.cos(data.flA) * data.flV, self.y - math.sin(data.flA) * data.flV
		data.flV = data.flV - data.flVDecay
	else 
		data.flV = 0
		--self:set("pVspeed", 0)
		misc.shakeScreen(1)
	end
	
	
	if self:collidesMap(self.x, self.y) or self:collidesWith(obj.P, self.x, self.y) then
		if data.parent and data.parent:isValid() then
			local b = data.parent:fireExplosion(self.x, self.y, 20 / 19, 20 / 4, 1, nil, nil)
			DOT.addToDamager(b, DOT_CORROSION, data.damage * 0.45, 6, "scrounger", true)
		else
			local b = misc.fireExplosion(self.x, self.y, 20 / 19, 20 / 4, data.damage, data.team, nil, nil)
			DOT.addToDamager(b, DOT_CORROSION, data.damage * 0.45, 6, "scrounger", true)
		end
		
		sImpact:play(0.9 + math.random() * 0.2)
		
		for i = -4, 4 do
			local trail = obj.CorrosiveTrail:create(self.x + i * 11, self.y - 5)
			trail:getData().parent = data.parent
			trail:getData().team = data.team
			trail:getData().damage = data.damage * 0.08
			trail:getData().life = 500
		end
		
		data.destroy = true
	end
		
	if data.life > 0 and not data.destroy then
		data.life = data.life - 1
	else
		self:destroy()
	end
end)
objBullet:addCallback("draw", function(self)
	local data = self:getData()
	local ac = self:getAccessor()
	
	graphics.color(acidColor)
	graphics.circle(self.x, self.y, 5, false)
end)

NPC.setSkill(obj.Scrounger, 1, 400, 60 * 6, sprShoot1, 0.2, function(actor)
	local target = Object.findInstance(actor:get("target"))
	if target and target:isValid() then
		if target.x > actor.x then
			actor.xscale = math.abs(actor.xscale)
		else
			actor.xscale = math.abs(actor.xscale) * -1
		end
	end
	sCharge:play(0.9 + math.random() * 0.2)
end, function(actor, relevantFrame)
	local actorData = actor:getData()
	
	if relevantFrame == 9 then
		local bullet = objBullet:create(actor.x, actor.y)
		
		local target = Object.findInstance(actor:get("target"))
		
		local dis
		if target and target:isValid() then
			dis = distance(actor.x, actor.y, target.x, target.y)
		end
		
		bullet:getData().team = actor:get("team")
		bullet:getData().damage = actor:get("damage")
		if dis then
			bullet:getData().flV = math.clamp(1 + dis * 0.023, 3, 7.5)
		end
		if actor:getFacingDirection() > 0 then
			bullet:set("direction", -225)
		else
			bullet:set("direction", 45)
		end
		sShoot:play(0.9 + math.random() * 0.2)
	end
end)

obj.Scrounger:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Scrounger"
	selfAc.damage = 17 * Difficulty.getScaling("damage")
	selfAc.maxhp = 170 * Difficulty.getScaling("hp")
	selfAc.armor = 0
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 1
	selfAc.knockback_cap = selfAc.maxhp / 5
	selfAc.exp_worth = 20 * Difficulty.getScaling()
	selfAc.point_value = 120
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
end)

obj.Scrounger:addCallback("step", function(self)
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
	
	if self.sprite.id == selfAc.sprite_death then
		self.subimage = 1
	end
end)

mcard.Scrounger = MonsterCard.new("Scrounger", obj.Scrounger)
mcard.Scrounger.type = "classic"
mcard.Scrounger.cost = 120
mcard.Scrounger.sound = sSpawn
mcard.Scrounger.sprite = sprSpawn
mcard.Scrounger.isBoss = false
mcard.Scrounger.canBlight = true

table.insert(call.onStageEntry, function()
	if misc.director:get("stages_passed") > 4 then
		for _, stage in ipairs(postLoopStages) do
			if not stage.enemies:contains(mcard.Scrounger) then
				stage.enemies:add(mcard.Scrounger)
			end
		end
	end
end)

callback.register("onGameStart", function()
	for _, stage in ipairs(postLoopStages) do
		if stage.enemies:contains(mcard.Scrounger) then
			stage.enemies:remove(mcard.Scrounger)
		end
	end
end)