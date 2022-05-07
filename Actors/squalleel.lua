local path = "Actors/Squall Eel/"

local sprMask = Sprite.load("SquallEelMask", path.."Mask", 1, 40, 68)
local sprPalette = Sprite.load("SquallEelPal", path.."palette", 1, 0, 0)
local sprSpawn = Sprite.load("SquallEelSpawn", path.."Spawn", 10, 70, 101)
local sprIdle = Sprite.load("SquallEelIdle", path.."Idle", 7, 60, 81)
--local sprWalk = Sprite.load("SquallEelWalk", path.."Walk", 5, 90, 112)
local sprShoot1 = Sprite.load("SquallEelShoot1", path.."Shoot1", 21, 53, 101)
local sprShoot2 = Sprite.load("SquallEelShoot2", path.."Shoot2", 12, 60, 111)
--local sprShoot3 = Sprite.load("SquallEelShoot3", path.."Shoot3", 8, 97, 99)
--local sprShoot4 = Sprite.load("SquallEelShoot4", path.."Shoot4", 5, 92, 111)
local sprDeath = Sprite.load("SquallEelDeath", path.."Death", 13, 57, 91)
local sprPortrait = Sprite.load("SquallEelPortrait", path.."Portrait", 1, 119, 119)
local sprLogBook = Sprite.load("SquallEelLogBook", path.."LogBook", 7, 60, 42)

local sSpawn = Sound.load("SquallEelSpawn", path.."Spawn")
local sShoot1_1 = Sound.load("SquallEelShoot1_1", path.."Shoot1_1")
local sShoot1_2 = Sound.load("SquallEelShoot1_2", path.."Shoot1_2")
local sShoot2 = Sound.load("SquallEelShoot2", path.."Shoot2")
--local sRabid = Sound.load("SquallEelRabid", path.."Rabid")
local sDeath = Sound.load("SquallEelDeath", path.."Death")
--local sHit = Sound.load("SquallEelHit", path.."Hit")

obj.SquallEel = Object.base("BossClassic", "Squall Eel")
obj.SquallEel.sprite = sprIdle

EliteType.registerPalette(sprPalette, obj.SquallEel)

NPC.setSkill(obj.SquallEel, 1, 9000, 60 * 10, sprShoot1, 0.2, nil, function(actor, relevantFrame)
	if relevantFrame == 1 then
		local target = Object.findInstance(actor:get("target") or -4) or actor
		if target and target:isValid() then
			local w, h = 500, 200
			local grounds = obj.B:findAllRectangle(actor.x - w, actor.y - h, actor.x + w, actor.y + h)
			local ground = table.irandom(grounds)
			local groundL = ground.x - (ground.sprite.boundingBoxLeft * ground.xscale) + 8
			local groundR = ground.x + (ground.sprite.boundingBoxRight * ground.xscale) - 8
			local x = math.random(groundL, groundR)
			actor:getData().xnew = x
			local image = actor.mask or actor.sprite
			actor:getData().ynew = ground.y - ((image.height - image.yorigin) * actor.yscale)
		else
			actor:getData().xnew = actor.x
			actor:getData().ynew = actor.y
		end
	elseif relevantFrame == 4 then
		sShoot1_1:play(0.9 + math.random() * 0.2)
		actor:fireExplosion(actor.x + 50, actor.y + 10, 1.4, 0.8, 1)
	elseif relevantFrame == 10 then
		--sClaw:play()
		if actor:getData().xnew then
			actor.x = actor:getData().xnew
			actor.y = actor:getData().ynew
			actor:set("ghost_x", actor.x)
			actor:set("ghost_y", actor.y)
			actor:getData().rx = actor.x
			actor:getData().ry = actor.y
		end
		local target = Object.findInstance(actor:get("target") or -4)
		if target and target:isValid() then
			if target.x > actor.x then
				actor:getData().xscale = 1
				actor.xscale = 1
			else
				actor:getData().xscale = -1
				actor.xscale = -1
			end
		end
	elseif relevantFrame == 13 then
		sShoot1_2:play(0.9 + math.random() * 0.2)
	end
end)

NPC.setSkill(obj.SquallEel, 2, 300, 60 * 4, sprShoot2, 0.15, nil, function(actor, relevantFrame)
	if relevantFrame == 1 then
		sShoot2:play(0.9 + math.random() * 0.2)
	elseif relevantFrame == 8 then
		for i = -4, 4 do
			local angle = (i * 18) + actor:getFacingDirection()
			local ang = math.rad(angle)
			local xx = math.cos(ang) * 30
			local yy = math.sin(ang) * 20
			local bullet = obj.TotemBullet:create(actor.x + xx, actor.y + yy - 20)
			bullet:getData().parent = actor
			bullet:getData().team = actor:get("team")
			bullet:getData().damage = actor:get("damage")
			bullet:getData().setDir = true
			bullet:set("speed", 1)
			bullet:set("direction", angle)
			local elite = actor:getElite()
			if elite then
				bullet:getData()._EfColor = elite.color
			end
		end
	end
end)

obj.SquallEel:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Squall Eel"
	selfAc.name2 = "Unearthed Peacekeeper"
	selfAc.damage = 28 * Difficulty.getScaling("damage")
	selfAc.maxhp = 1100 * Difficulty.getScaling("hp")
	selfAc.armor = 0
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 0
	selfAc.knockback_cap = selfAc.maxhp
	selfAc.exp_worth = 60 * Difficulty.getScaling()
	selfAc.point_value = 820
	selfAc.can_drop = 0
	selfAc.can_jump = 0
	selfAc.sound_hit = sfx.LizardGHit.id
	selfAc.hit_pitch = 1.2
	selfAc.sound_death = sDeath.id
	selfAc.sprite_palette = sprPalette.id
	selfAc.sprite_idle = sprIdle.id
	selfAc.sprite_walk = sprIdle.id
	selfAc.sprite_jump = sprIdle.id
	selfAc.sprite_death = sprDeath.id
	self:getData().knockbackImmune = true
end)

obj.SquallEel:addCallback("step", function(self)
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	local activity = selfAc.activity
	
	if selfData.xscale then
		self.xscale = math.abs(self.xscale) * math.sign(selfData.xscale)
	else
		selfData.xscale = self.xscale	
	end
	
	selfAc.moveUp = 0
	
	if selfData.rx then
		self.x = selfData.rx
		self.y = selfData.ry
	else
		selfData.rx = self.x
		selfData.ry = self.y
	end
	
	
	if selfAc.team == "enemy" then
		local t = obj.POI:findNearest(self.x, self.y)
		if t and t:isValid() then
			selfAc.target = t.id
		end
	end
	
	--[[if self:collidesMap(self.x, self.y) then
		for i = 1, 20 do
			if not self:collidesMap(self.x + i, self.y) then
				self.x = self.x + i
				break
			end
		end
		for i = 1, 20 do
			if not self:collidesMap(self.x - i, self.y) then
				self.x = self.x - i
				break
			end
		end
	end]]
	
	--[[if selfAc.state == "chase" then
		if selfAc.target then
			local target = Object.findInstance(selfAc.target)
			if target and target:isValid() then
				if target.x > self.x + 10 and self:collidesMap(self.x + selfAc.pHmax, self.y) == false and self:collidesMap(self.x + self.mask.width, self.y + 2) == true then
					selfAc.moveRight = 1
					selfAc.moveLeft = 0
				elseif target.x < self.x - 10 and self:collidesMap(self.x - selfAc.pHmax, self.y) == false and self:collidesMap(self.x - self.mask.width, self.y + 2) == true then
					selfAc.moveLeft = 1
					selfAc.moveRight = 0
				end
			elseif global.timer % 100 == 0 then
				syncInstanceVar:sendAsClient(self:getNetIdentity(), "target")
			end
		end
	end]]
	
	if self.sprite.id == selfAc.sprite_death then
		self.subimage = 1
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

mcard.SquallEel = MonsterCard.new("SquallEel", obj.SquallEel)
mcard.SquallEel.cost = 820
mcard.SquallEel.sound = sSpawn
mcard.SquallEel.sprite = sprSpawn
mcard.SquallEel.isBoss = true
mcard.SquallEel.canBlight = true

mlog.SquallEel = MonsterLog.new("SquallEel")
MonsterLog.map[obj.SquallEel] = mlog.SquallEel
mlog.SquallEel.displayName = "Squall Eel"
mlog.SquallEel.story = "It is blind..\n\nYet it sees.\n\nNot by sensing movement through the ground, nor by hearing clues, but rather by the Elvers they protect.\n\nThe Elvers will chant to the Eel, even from the greatest distances.\n\nWithout Elvers, would the Eels succumb?\nIt's an unusual symbiosis."
mlog.SquallEel.statHP = 1100
mlog.SquallEel.statDamage = 28
mlog.SquallEel.statSpeed = 0
mlog.SquallEel.sprite = sprLogBook
mlog.SquallEel.portrait = sprPortrait

callback.register("onLoad", function()

local stages = {
	stg.UnchartedMountain
}

local postLoopStages = {
	stg.SkyMeadow,
	stg.AncientValley,
	stg.TempleoftheElders
}

for _, stage in ipairs(stages) do
	stage.enemies:add(mcard.SquallEel)
end

table.insert(call.onStageEntry, function()
	if misc.director:get("stages_passed") > 4 then
		for _, stage in ipairs(postLoopStages) do
			if not stage.enemies:contains(mcard.SquallEel) then
				stage.enemies:add(mcard.SquallEel)
			end
		end
	end
end)

callback.register("onGameStart", function()
	for _, stage in ipairs(postLoopStages) do
		if stage.enemies:contains(mcard.SquallEel) then
			stage.enemies:remove(mcard.SquallEel)
		end
	end
end)
end)