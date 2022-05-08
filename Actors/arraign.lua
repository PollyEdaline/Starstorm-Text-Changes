local path = "Actors/Arraign/"

--local sprPortrait = Sprite.load("ArraignPortrait", path.."Portrait", 2, 119, 119)
local sprMask = Sprite.load("ArraignMask", path.."Mask", 1, 6, 15)

local sprites = {
	phase1 = {
		idle = Sprite.load("ArraignIdle_1", path.."Idle_1", 5, 31, 44),
		jump = Sprite.load("ArraignJump_1", path.."Jump_1", 1, 31, 44),
		walk = Sprite.load("ArraignWalk_1", path.."Walk_1", 8, 31, 34),
		shoot1 = Sprite.load("ArraignShoot1_1", path.."Shoot1_1", 17, 35, 44),
		shoot2 = Sprite.load("ArraignShoot2_1", path.."Shoot2_1", 33, 31, 224),
		shoot3 = Sprite.load("ArraignShoot3_1", path.."Shoot3_1", 22, 26, 54),
		death = Sprite.load("ArraignDeath_1", path.."Death_1", 60, 58, 104)
	},
	phase2 = {
		idle = Sprite.load("ArraignIdle_2", path.."Idle_2", 5, 31, 44),
		jump = Sprite.load("ArraignJump_2", path.."Jump_2", 1, 31, 44),
		walk = Sprite.load("ArraignWalk_2", path.."Walk_2", 8, 31, 34),
		shoot1 = Sprite.load("ArraignShoot1_2", path.."Shoot1_2", 24, 31, 66),
		shoot2 = Sprite.load("ArraignShoot2_2", path.."Shoot2_2", 15, 49, 134),
		shoot3 = Sprite.load("ArraignShoot3_2", path.."Shoot3_2", 45, 42, 184),
		death = Sprite.load("ArraignDeath_2", path.."Death_2", 44, 50, 37)
	}
}

local phrases = {
	phase1 = {
		"Show me what you're made of.",
		"Bring it on!",
		"Candidate, demonstrate!",
		"Candidate, endure!",
		"Interesting candidate.",
		"Astounding resilience...",
		"Powerful being...",
		"Fair contender...",
		"Step up your strength!"
	},
	phase2 = {
		"Candidate, invigorate!",
		"Aggravate!",
		"Do it!",
		"Enrage!",
		"Behold!",
		"Come on!",
		"Impress me more!",
		"Don't hold back!",
		"Unfolding strength!",
		"Reveal your potential!",
		"Show me your power!"
	}
}

local sounds = {
	shoot1_1a = Sound.load("ArraignShoot1_1a", path.."Shoot1_1a"),
	shoot1_1b = Sound.load("ArraignShoot1_1b", path.."Shoot1_1b"),
	shoot1_2a = Sound.load("ArraignShoot1_2a", path.."Shoot1_2a"),
	shoot1_2b = Sound.load("ArraignShoot1_2b", path.."Shoot1_2b"),
	shoot2_1 = Sound.load("ArraignShoot2_1", path.."Shoot2_1"),
	shoot2_2 = Sound.load("ArraignShoot2_2", path.."Shoot2_2"),
	shoot3_1 = Sound.load("ArraignShoot3_1", path.."Shoot3_1"),
	shoot3_2 = Sound.load("ArraignShoot3_2", path.."Shoot3_2")
}


local syncSpeech = net.Packet.new("SSArrSp", function(player, actor, str)
	local actorI = actor:resolve()
	if actorI and actorI:isValid() then
		local data = actorI:getData()
		data.speech = str
		data.textTimer = 180
	end
end)

local syncGodDamage
syncGodDamage = net.Packet.new("SSGodDmg", function(sender, actor, dmg)
	local actorI = actor:resolve()
	if actorI and actorI:isValid() then
		local newHp = actorI:get("hp") - dmg
		actorI:set("hp", newHp)
		actorI:getData().lastHp = newHp
		if net.host then
			syncGodDamage:sendAsHost(net.EXCLUDE, sender, actorI:getNetIdentity(), dmg)
		end
	end
end)


local objArraignDeath = Object.new("ArraignDeath")
objArraignDeath.sprite = sprites.phase1.death
objArraignDeath:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.text = "Impressive..."
	selfData.final = false
end)
objArraignDeath:addCallback("step", function(self)
	local selfData = self:getData()
	self.spriteSpeed = 0.2
	if self.subimage >= self.sprite.frames then
		self:destroy()
	end
end)
objArraignDeath:addCallback("draw", function(self)
	local selfData = self:getData()
	if self.subimage >= 30 and self.subimage < 53 then
		local xshake, yshake = math.random(-1, 1), math.random(-1, 1)
		local xx, yy = self.x + xshake, self.y - 32 + yshake
		graphics.alpha(1)
		--graphics.color(Color.BLACK)
		--graphics.print(str, xx, yy + 1, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE)
		graphics.color(Color.GRAY)
		graphics.print(selfData.text, xx, yy, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE)
	end
end)
objArraignDeath:addCallback("destroy", function(self)
	if self:getData().final then
		local s = obj.EfSparks:create(self.x, self.y + 16)
		s.sprite = spr.EfRecall
		s.yscale = 1
		sfx.Teleporter:play()
		runData.defeatedArraign = true
		save.write("defeatedArraign", true)
		if it.Deicide then
			it.Deicide:setTier("use")
		end
	else
		local arr = obj.Arraign2:create(self.x, self.y)
		arr.xscale = math.sign(self.xscale)
	end
end)


local lightningHit = Sprite.load("ArraignLightning", path.."Lightning", 13, 21, 153)
local lightningWarning = Sprite.load("ArraignLightningWarning", path.."LightningWarning", 6, 9, 5)
local objArraignLightning = Object.new("ArraignLightning")
objArraignLightning.sprite = lightningWarning
local impactSound = sfx.Lightning

objArraignLightning:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.life = 120
	self:set("team", "enemy")
	self:set("damage", 1000)
	for i = 1, 800 do
		if self:collidesMap(self.x, self.y + i) then
			self.y = self.y + i - 1
			break
		end
	end
	self.spriteSpeed = 0.15
	selfData.drawLine = true
end)
objArraignLightning:addCallback("step", function(self)
	local selfData = self:getData()
	
	selfData.life = selfData.life - 1
	
	if selfData.life <= 0 then
		local image = obj.EfSparks:create(self.x, self.y + 4)
		image.xscale = table.irandom({1, -1})
		image.yscale = 1
		image.sprite = lightningHit
		image.spriteSpeed = 0.33
		impactSound:play(0.8 + math.random() * 0.2, 0.8)
		if selfData.parent and selfData.parent:isValid() then
			selfData.parent:fireExplosion(self.x, self.y - 30, 10 / 19, 60 / 4, 1)
		else
			misc.fireExplosion(self.x, self.y - 30, 10 / 19, 60 / 4, self:get("damage"), self:get("team"))
		end
		if onScreen(self) then
			misc.shakeScreen(5)
		end
		self:destroy()
	end
end)
objArraignLightning:addCallback("draw", function(self)
	if self:getData().drawLine then
		graphics.color(Color.fromHex(0xB5F7FF))
		graphics.alpha(1)
		graphics.line(self.x, self.y + 4, self.x + 4, 0, 2)
	end
end)

--local sSpawn = Sound.load("ArraignSpawn", path.."spawn")

obj.Arraign1 = Object.base("BossClassic", "Arraign1")
obj.Arraign1.sprite = sprites.phase1.idle
obj.Arraign1.depth = -7

NPC.setSkill(obj.Arraign1, 1, 1500, 60 * 3, sprites.phase1.shoot1, 0.2, nil, function(actor, relevantFrame)
	if relevantFrame == 1 then
		sounds.shoot1_1a:play(0.9 + math.random() * 0.2)
		local nearestEnemy = nearestMatchingOp(actor, pobj.actors, "team", "~=", actor:get("team"))
		if nearestEnemy then
			actor:getData().z_x = nearestEnemy.x + 30 * actor.xscale * -1
		else
			actor:getData().z_x = actor.x + 20 * actor.xscale
		end
	end
	if relevantFrame == 8 then
		sounds.shoot1_1b:play(0.9 + math.random() * 0.2)
	end
	if relevantFrame == 10 then
		if onScreen(actor) then
			misc.shakeScreen(20)
		end
		local dis = math.round((actor:getData().z_x or actor.x + 20 * actor.xscale) - actor.x)
		for i = 1, math.abs(dis) do
			local newx = actor.x + math.sign(dis)
			if not actor:collidesMap(newx, actor.y) then
				actor.x = newx
			else
				break
			end
		end
		--actor.x = actor:getData().z_x
		actor:set("ghost_x", actor.x)
		actor:fireExplosion(actor.x + 30 * actor.xscale, actor.y, 70 / 19, 30 / 4, 3)
	end
end)
NPC.setSkill(obj.Arraign1, 2, 200, 60 * 6, sprites.phase1.shoot2, 0.2, nil, function(actor, relevantFrame)
	if relevantFrame == 10 then
		sounds.shoot2_1:play(0.9 + math.random() * 0.2)
	end
	if relevantFrame == 10 then--or relevantFrame == 27 then
		actor:fireExplosion(actor.x + 10 * actor.xscale, actor.y - 451, 20 / 19, 411 / 4, 3)
	elseif relevantFrame >= 12 and relevantFrame <= 16 then --if relevantFrame == 12 or relevantFrame == 14 or relevantFrame == 16 then
		r = 400
		misc.shakeScreen(5)
		for _, actor2 in ipairs(pobj.actors:findAllRectangle(actor.x - r, actor.y - r, actor.x + r, actor.y + r)) do
			if actor2:get("team") ~= actor:get("team") then
				local lightning = objArraignLightning:create(actor2.x, actor2.y)
				lightning:set("team", actor:get("team"))
				lightning:set("damage", actor:get("damage"))
				lightning:getData().parent = actor
				lightning:getData().life = 100
			end
		end
	end
end)
NPC.setSkill(obj.Arraign1, 3, 200, 60 * 12, sprites.phase1.shoot3, 0.2, nil, function(actor, relevantFrame)
	if relevantFrame == 3 then
		sounds.shoot3_1:play(0.9 + math.random() * 0.2)
	end
	if relevantFrame > 13 and relevantFrame < 16 then
		misc.shakeScreen(10)
		
		local choice = table.irandom(global.aeonianEnemies)
		
		misc.director:set("card_choice", choice.id)
		misc.director:set("points", choice.cost + 100)
		misc.director:setAlarm(1, math.min(misc.director:getAlarm(1), 1))
	end
end)

local healthBarColor = Color.fromHex(0x0000FF)

local sprArraignPortrait = Sprite.load("ArraignPortrait", path.."Portrait", 2, 0, 0)

obj.Arraign1:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Arraign"
	selfAc.name2 = "The Judge"
	selfAc.damage = 5000 * Difficulty.getScaling("damage")
	selfAc.maxhp = 10000000
	selfAc.hp = selfAc.maxhp
	selfAc.pVmax = 3
	selfAc.pHmax = 0.9
	selfAc.can_jump = 1
	selfAc.can_drop = 1
	selfAc.exp_worth = 0 --* Difficulty.getScaling()
	selfAc.knockback_cap = selfAc.maxhp
	--selfAc.sound_death = sDeath.id
	--selfAc.sound_hit = sfx.ImpHit.id
	--selfAc.hit_pitch = 0.5
	--selfAc.sprite_palette = sprPalette.id
	self:setAnimations(sprites.phase1)
	self:setAnimation("death", spr.Nothing)
	
	misc.shakeScreen(10)
	
	self:getData().affixImmune = true
	
	self:getData().textTimer = 0
	self:getData().textCd = 0
	
	obj.EfFlash:create(0,0):set("parent", self.id):set("rate", 0.08)
	
	if not net.online then
		createDialogue({"You have gotten this far...", "Candidate, prevail. Or fall victim to my judgement."}, {{sprArraignPortrait, 1}, {sprArraignPortrait, 1}})
	end
end)

obj.Arraign1:addCallback("step", function(self)
	if self.sprite == self:getAnimation("idle") then
		self.spriteSpeed = 0.15
	end
	
	self:getData().dotData = nil
	for _, buff in ipairs(self:getBuffs()) do
		self:removeBuff(buff)
	end
	
	misc.hud:set("boss_hp_color", healthBarColor.gml)
	
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	local activity = selfAc.activity
	
	selfAc.maxhp = 10000000 -- never change pls
	
	if selfData.lastHp and selfAc.hp > selfData.lastHp then
		selfAc.hp = selfData.lastHp
	end
	selfData.lastHp = selfAc.hp
	
	if selfData.noInvincible then
		selfData.noInvincible = false
	else
		selfAc.invincible = 10
	end
	
	if selfData.textTimer > 0 then
		selfData.textTimer = selfData.textTimer - 1
	elseif net.host then
		if selfData.textCd > 0 then
			selfData.textCd = selfData.textCd - 1
		else
			if activity == 0 and math.chance(1) then
				selfData.textTimer = 180
				selfData.textCd = 420
				selfData.speech = table.irandom(phrases.phase1)
				if net.online then
					syncSpeech:sendAsHost(net.ALL, nil, self:getNetIdentity(), selfData.speech)
				end
			end
		end
	end
	
	if self:collidesMap(self.x, self.y) then
		for i = -20, 20 do
			if not self:collidesMap(self.x + i, self.y) then
				self.x = self.x + i
				break
			end
		end
	end
	
	self:set("disable_ai", 0)
	
	local target = Object.findInstance(self:get("target") or -4)
	if target and target:isValid() then
		if self:get("moveRight") then
			if target.x > self.x + 500 then
				self:set("moveRight", 1)
			elseif target.x < self.x - 500 then
				self:set("moveLeft", 1)
			end
		end
	end
	
	if self.sprite == self:getAnimation("death") then self.sprite = self:getAnimation("idle") end
	
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
obj.Arraign1:addCallback("draw", function(self)
	local selfData = self:getData()
	if selfData.textTimer > 0 then
		local str = selfData.speech
		--local xshake, yshake = math.random(-1, 1), math.random(-1, 1)
		local xx, yy = self.x, self.y - 42
		graphics.alpha(1)
		graphics.color(Color.GRAY)
		graphics.print(str, xx, yy, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE)
	end
	if selfData.z_x and self:get("activity") == 1 and self.subimage < 10 then
		graphics.alpha(self.subimage / 10)
		graphics.color(Color.fromHex(0x0000FF))
		graphics.circle(selfData.z_x, self.y, 3 + self.subimage, false)
		graphics.color(Color.fromHex(0xB5F7FF))
		graphics.circle(selfData.z_x, self.y, self.subimage * 0.7, true)
	end
end)

callback.register("onDamage", function(target, damage, source)
	if target:getObject() == obj.Arraign1 then
		local cancelDamage
		if source and source:getData().parent and source:getData().parent:isValid() and source:getData().canDamageArraign then
			if not net.online or source:getData().parent == net.localPlayer then
				if net.host then
					syncGodDamage:sendAsHost(net.ALL, nil, target:getNetIdentity(), damage)
				else
					syncGodDamage:sendAsClient(target:getNetIdentity(), damage)
				end
			else
				cancelDamage = true
			end
		end
		if not source or not source:getData().canDamageArraign or cancelDamage then
			return true
		end
	end
end)

obj.Arraign1:addCallback("destroy", function(self)
	local death = objArraignDeath:create(self.x, self.y)
	death.xscale = self.xscale
	death.yscale = self.yscale
	misc.director:setAlarm(1, -1)
	
	for _, actor in ipairs(pobj.actors:findMatching("team", self:get("team"))) do
		if actor ~= self then
			actor:kill()
		end
	end
end)



-- phase 2


local objArraignLance = Object.new("ArraignLance")
objArraignLance.sprite = Sprite.load("ArraignLance", path.."Lance", 4, 19, 13)

objArraignLance:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.life = 10 * 60
	self:set("team", "enemy")
	self:set("damage", 1000)
	self.spriteSpeed = 0.15
	selfData.hitList = {}
end)
objArraignLance:addCallback("step", function(self)
	local selfData = self:getData()
	if selfData.life > 0 then
		
		if global.quality > 1 and selfData.life % 2 == 0 then
			local t = obj.EfTrail:create(self.x, self.y)
			t.sprite = self.sprite
			t.angle = self.angle
			t.xscale = self.xscale
			t.subimage = self.subimage
		end
		
		self.x = self.x + self.xscale * 8
		selfData.life = selfData.life - 1
		if selfData.parent and selfData.parent:isValid() then
			local w, h = 40, 13
			for _, actor in ipairs(pobj.actors:findAllRectangle(self.x - w, self.y - h, self.x + w, self.y + h)) do
				if selfData.hitList[actor] == nil and actor:get("team") ~= self:get("team") and self:collidesWith(actor, self.x, self.y) then
					selfData.parent:fireBullet(actor.x - 2, actor.y, 0, 10, self:get("damage") / selfData.parent:get("damage")):set("specific_target", actor.id)
					selfData.hitList[actor] = true
				end
			end
		end
	else
		self:destroy()
	end
end)

local objArraignLaser = Object.new("ArraignLaser")
objArraignLaser.depth = -30
objArraignLaser:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.life = 120
	self:set("team", "enemy")
	local sound = Sound.find("Augury")
	if sound then
		sound:play()
	else -- what a weird backup plan
		sfx.GuardDeath:play(0.5)
		sfx.GuardDeath:play(0.8)
	end
end)
objArraignLaser:addCallback("step", function(self)
	local selfData = self:getData()
	
	selfData.life = selfData.life - 1
	
	if selfData.life > 0 then
		if selfData.parent and selfData.parent:isValid() then
			self.x = selfData.parent.x + 40 * self.xscale
			self.y = selfData.parent.y
		end
		if selfData.life > 30 then
			for _, actor in ipairs(pobj.actors:findAll()) do
				if actor.y > self.y - 150 and actor.y < self.y + 150 then
					if actor.x > self.x and self.xscale == 1 or actor.x < self.x and self.xscale == -1 then
						if actor:get("team") ~= self:get("team") then
							local isPlayer = isa(actor, "PlayerInstance")
							if isPlayer and not net.online or isPlayer and net.localPlayer == actor then
								actor:kill()
							end
						end
					end
				end
			end
			misc.shakeScreen(5)
		end
	else
		self:destroy()
	end
end)
objArraignLaser:addCallback("draw", function(self)
	local mult = (math.min(self:getData().life, 30) / 30)
	local width = 300 * mult
	graphics.alpha(1)
	
	graphics.color(Color.fromHex(0x0000FF))
	local w2 = width * 0.5
	graphics.triangle(self.x + 30 * (self.xscale * -1), self.y, self.x, self.y - w2, self.x, self.y + w2, false)
	graphics.line(self.x, self.y, self.x + 100000 * self.xscale, self.y, width)
	
	graphics.color(Color.fromHex(0xB5F7FF))
	local ww = math.max(width - 10, 0)
	local ww2 = ww * 0.5
	graphics.triangle(self.x + 28 * (self.xscale * -1), self.y, self.x - 1, self.y - ww2, self.x - 1, self.y + ww2, false)
	graphics.line(self.x, self.y, self.x + 100000 * self.xscale, self.y, ww)
	
	graphics.color(Color.WHITE)
	local www = math.max(width * 0.8 - 100, 0)
	local www2 = www * 0.5
	if www > 0 then
	graphics.triangle(self.x + 25 * (self.xscale * -1), self.y, self.x - 1, self.y - www2, self.x - 1, self.y + www2, false)
	graphics.line(self.x, self.y, self.x + 100000 * self.xscale, self.y, www)
	end
	
	graphics.alpha(0.1 * mult)
	graphics.rectangle(0, 0, 999999, 999999, false)
end)

obj.Arraign2 = Object.base("BossClassic", "Arraign2")
obj.Arraign2.sprite = sprites.phase2.idle
obj.Arraign2.depth = -7

NPC.setSkill(obj.Arraign2, 1, 3000, 60 * 3, sprites.phase2.shoot1, 0.2, nil, function(actor, relevantFrame)
	if relevantFrame == 3 then
		sounds.shoot1_2a:play(0.9 + math.random() * 0.2)
	end
	if relevantFrame == 19 then
		sounds.shoot1_2b:play(0.9 + math.random() * 0.2)
		if onScreen(actor) then
			misc.shakeScreen(10)
			local lance = objArraignLance:create(actor.x + actor.xscale * 30, actor.y - 5)
			lance:set("damage", actor:get("damage") * 3)
			lance:set("team", actor:get("team"))
			lance:getData().parent = actor
			lance.xscale = math.sign(actor.xscale)
		end
	end
end)
NPC.setSkill(obj.Arraign2, 2, 1000, 60 * 6, sprites.phase2.shoot2, 0.2, nil, function(actor, relevantFrame)
	if relevantFrame == 9 then
		sounds.shoot2_2:play(0.9 + math.random() * 0.2)
		for i = 0, 30 do
			local lightning = objArraignLightning:create(actor.x + 10 + 10 * i, actor.y)
			lightning:set("team", actor:get("team"))
			lightning:set("damage", actor:get("damage"))
			lightning:getData().life = 60 + i * 2
			lightning:getData().parent = actor
			lightning:getData().drawLine = false
		end
		for i = 0, 30 do
			local lightning = objArraignLightning:create(actor.x + (10 + 10 * i) * -1, actor.y)
			lightning:set("team", actor:get("team"))
			lightning:set("damage", actor:get("damage"))
			lightning:getData().life = 60 + i * 2
			lightning:getData().parent = actor
			lightning:getData().drawLine = false
		end
	end
end)
NPC.setSkill(obj.Arraign2, 3, 1000, 60 * 12, sprites.phase2.shoot3, 0.2, nil, function(actor, relevantFrame)
	if relevantFrame == 1 then
		sounds.shoot3_2:play(0.9 + math.random() * 0.2)
	end
	if relevantFrame == 29 then
		local laser = objArraignLaser:create(actor.x + 40 * actor.xscale, actor.y)
		laser.xscale = actor.xscale
		laser:set("team", actor:get("team"))
		laser:getData().parent = actor
	end
	if relevantFrame >= 29 and relevantFrame <= 40 then
		local newx = actor.x + 1 * (actor.xscale * -1)
		if not actor:collidesMap(newx, actor.y) then
			actor.x = newx
		end
	end
end)

obj.Arraign2:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Arraign"
	selfAc.name2 = "The Judge"
	selfAc.damage = 4000 * Difficulty.getScaling("damage")
	selfAc.maxhp = 10000 * Difficulty.getScaling("hp") * Difficulty.getScaling("hp")
	selfAc.hp = selfAc.maxhp
	selfAc.pVmax = 3
	selfAc.armor = 100
	selfAc.pHmax = 0.9
	selfAc.can_jump = 1
	selfAc.can_drop = 1
	selfAc.exp_worth = 0 --* Difficulty.getScaling()
	selfAc.knockback_cap = selfAc.maxhp
	--selfAc.sound_death = sDeath.id
	--selfAc.sound_hit = sfx.ImpHit.id
	--selfAc.hit_pitch = 0.5
	--selfAc.sprite_palette = sprPalette.id
	self:setAnimations(sprites.phase2)
	self:getData().textTimer = 0
	self:getData().textCd = 0
	
	self:getData().affixImmune = true
	
	self:setAnimation("death", spr.Nothing)
	
	misc.director:set("boss_id", self.id)
	Event.setActive(Event.find("Storm"), 1, 999999)
	
	if not net.online then
		createDialogue({"You are unlike anything that I have witnessed before..", "That strength..", "That power..", "We are not done yet.", "I shall not hold back!"}, {{sprArraignPortrait, 2}, {sprArraignPortrait, 2}, {sprArraignPortrait, 2}, {sprArraignPortrait, 2}})
	end
end)

obj.Arraign2:addCallback("step", function(self)
	if self.sprite == self:getAnimation("idle") then
		self.spriteSpeed = 0.15
	end
	
	misc.hud:set("boss_hp_color", Color.fromHex(0x51647D).gml)
	
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	local activity = selfAc.activity
	
	if self:collidesMap(self.x, self.y) then
		for i = -20, 20 do
			if not self:collidesMap(self.x + i, self.y) then
				self.x = self.x + i
				break
			end
		end
	end
	
	if selfData.textTimer > 0 then
		selfData.textTimer = selfData.textTimer - 1
	elseif net.host then
		if selfData.textCd > 0 then
			selfData.textCd = selfData.textCd - 1
		else
			if activity == 0 and math.chance(1) then
				selfData.textTimer = 180
				selfData.textCd = 420
				selfData.speech = table.irandom(phrases.phase2)
				if net.online then
					syncSpeech:sendAsHost(net.ALL, nil, self:getNetIdentity(), selfData.speech)
				end
			end
		end
	end
	
	self:set("disable_ai", 0)
	
	local target = Object.findInstance(self:get("target") or -4)
	if target and target:isValid() then
		if self:get("moveRight") then
			if target.x > self.x + 500 then
				self:set("moveRight", 1)
			elseif target.x < self.x - 500 then
				self:set("moveLeft", 1)
			end
		end
	end
	
	if self.sprite == sprDeath then self.subimage = 1 end
	
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
obj.Arraign2:addCallback("draw", function(self)
	local selfData = self:getData()
	if selfData.textTimer > 0 then
		local str = selfData.speech
		local xshake, yshake = math.random(-1, 1), math.random(-1, 1)
		local xx, yy = self.x + xshake, self.y - 42 + yshake
		graphics.alpha(1)
		graphics.color(Color.GRAY)
		graphics.print(str, xx, yy, graphics.FONT_DEFAULT, graphics.ALIGN_MIDDLE)
	end
end)

obj.Arraign2:addCallback("destroy", function(self)
	local death = objArraignDeath:create(self.x, self.y)
	death.sprite = sprites.phase2.death
	death.xscale = self.xscale
	death.yscale = self.yscale
	death:getData().final = true
	death:getData().text = "Ascend.."
	
	local currentStage = Stage.getCurrentStage()
	for _, enemy in ipairs(currentStage.enemies:toTable()) do
		currentStage.enemies:remove(enemy)
	end
	for _, actor in ipairs(pobj.actors:findMatching("team", "enemy")) do
		actor:set("hp", -99999)
	end
	misc.director:setAlarm(1, -1) 
	
end)