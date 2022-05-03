local path = "Survivors/Executioner/Skins/Nemesis/"

local efColor = Color.fromHex(0xCC4D4D)

local sprIdle = Sprite.load("NemesisExecutionerIdle", path.."Idle", 1, 5, 8)
local sprJump = Sprite.load("NemesisExecutionerJump", path.."Jump", 1, 5, 8)
local sprWalk = Sprite.load("NemesisExecutionerWalk", path.."Walk", 8, 8, 9)
local sprClimb = Sprite.load("NemesisExecutionerClimb", path.."Climb", 2, 4, 7)
local sprShoot1 = Sprite.load("NemesisExecutionerShoot1", path.."Shoot1", 6, 7, 14)
local sprShoot2 = Sprite.load("NemesisExecutionerShoot2", path.."Shoot2", 13, 8, 14)
local sprShoot3 = Sprite.load("NemesisExecutionerShoot3", path.."Shoot3", 8, 24, 20)
local sprShoot4 = Sprite.load("NemesisExecutionerShoot4", path.."Shoot4", 14, 29, 24)
local sprDeath = Sprite.load("NemesisExecutionerDeath", path.."Death", 5, 7, 4)
--local sprPortrait = Sprite.load("NemesisExecutionerPortrait", path.."Portrait", 1, 119, 119)

local sShoot1a = Sound.load("NemesisExecutionerShoot1a", path.."skill1a")
local sShoot1b = Sound.load("NemesisExecutionerShoot1b", path.."skill1b")
local sShoot2a = Sound.load("NemesisExecutionerShoot2a", path.."skill2a")
local sShoot2b = Sound.load("NemesisExecutionerShoot2b", path.."skill2b")
local sShoot4a = Sound.load("NemesisExecutionerShoot4a", path.."skill4a")
local sShoot4b = Sound.load("NemesisExecutionerShoot4b", path.."skill4b")

local sprBullet_1 = Sprite.load("NemesisExecutionerBullet1", path.."Bullet_1", 4, 5, 5)
local sprBullet_2 = Sprite.load("NemesisExecutionerBullet2", path.."Bullet_2", 4, 13, 13)

obj.NemesisExecutioner = Object.base("BossClassic", "NemesisExecutioner")
obj.NemesisExecutioner.sprite = sprIdle

local sprSkeleIdle = Sprite.load("NExeSkeleIdle", path.."SkeleIdle", 4, 10, 10)
local sprSkeleWalk = Sprite.load("NExeSkeleWalk", path.."SkeleWalk", 8, 10, 10)
local sprSkeleShoot = Sprite.load("NExeSkeleShoot", path.."SkeleShoot", 6, 10, 10)
local sprSkeleDeath = Sprite.load("NExeSkeleDeath", path.."SkeleDeath", 7, 12, 19)

local sSkeleShoot = Sound.load("NExeSkeleShoot", path.."skeleShoot")
local sSkeleDeath = Sound.load("NExeSkeleDeath", path.."skeleDeath")

objNExeBullet = Object.new("NExeBullet")
objNExeBullet.sprite = sprBullet_1
objNExeBullet:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.life = 20
	--self.blendColor = Color.RED
	self.spriteSpeed = 0.2
	selfData.team = "player"
	selfData.speed = 1.5
	selfData.yscale = table.irandom{1, -1}
	self.yscale = 0
	
	if global.quality > 1 then
		for i = 1, 50 do
			if Stage.collidesPoint(self.x, self.y + i) then
				selfData.draw = i
				break
			end
		end
	end
end)
objNExeBullet:addCallback("step", function(self)
	local selfData = self:getData()
	
	if selfData.life > 0 then
		if self.yscale ~= selfData.yscale then
			self.yscale = math.approach(self.yscale, selfData.yscale, 0.1)
		end
		selfData.life = selfData.life - 1
	else
		if selfData.parent and selfData.parent:isValid() then
			local dir = 0
			if self.xscale < 0 then dir = 180 end
			for i = 0, selfData.parent:get("sp") do
				local bullet = selfData.parent:fireBullet(self.x, self.y, dir, 170 * selfData.parent:get("attack_speed"), 0.9, sprBullet_2)
				addBulletTrailLine(bullet, efColor, 2, 25, false, false)
				if onScreen(self) then
					sShoot1b:play(0.9 + math.random() * 0.2, 1)
				end
				if i ~= 0 then
					bullet:set("climb", i * 8)
				end
			end
		end
		self:destroy()
	end
end)
objNExeBullet:addCallback("draw", function(self)
	local selfData = self:getData()
	if selfData.draw then
		if selfData.life > 10 then
			local t = selfData.life - 100
			graphics.alpha(1)
			graphics.color(efColor)
			graphics.line(self.x, self.y, self.x, self.y + selfData.draw, 3 * (t / 10))
		end
	end
end)



local objNExeSkeleton = Object.base("EnemyClassic", "NExeSkeleton")

local onStepCall =  function()
	for _, _ in ipairs(obj.Teleporter:findMatching("active", 2)) do
		for _, skeleton in ipairs(objNExeSkeleton:findAll()) do
			skeleton:set("ghost", 1)
		end
		break
	end
end

local postStepCall = function()
	for _, skele in ipairs(objNExeSkeleton:findMatchingOp("hp", "<=", 0)) do
		if not skele:getData()._destroyCheck then
			skele:getData()._destroyCheck = true
			if skele:get("team") ~= "player" then
				if net.online and net.host then
					syncDestroy(skele)
				else
					skele:destroy()
				end
			end
		end
	end
end

local preStepCall = function()
	for _, self in ipairs(objNExeSkeleton:findAll()) do
		if self:getData().jump and self:get("can_jump") == 1 then
			self:set("moveUp", 1)
			self:getData().jump = nil
		end
	end
end

objNExeSkeleton.sprite = sprSkeleIdle
objNExeSkeleton:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = spr.PMask
	selfAc.name = "Ion Skeleton"
	selfAc.damage = 17 * Difficulty.getScaling("damage")
	selfAc.maxhp = 50 * Difficulty.getScaling("hp")
	selfAc.pHmax = 1.35
	selfAc.armor = 0
	selfAc.team = "player"
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 1
	selfAc.knockback_cap = selfAc.maxhp
	selfAc.exp_worth = 0
	selfAc.can_drop = 1
	selfAc.can_jump = 1
	--selfAc.sound_hit = sHit.id
	selfAc.sound_death = sSkeleDeath.id
	--selfAc.sprite_palette = sprPalette.id
	selfAc.sprite_idle = sprSkeleIdle.id
	selfAc.sprite_walk = sprSkeleWalk.id
	selfAc.sprite_jump = sprSkeleIdle.id
	selfAc.sprite_death = sprSkeleDeath.id
	self:getData().life = 1200
	self:getData()._EfColor = efColor
	self:getData().noFallDeath = true
	
	tcallback.register("preStep", preStepCall)
	
	tcallback.register("onStep", onStepCall)
	tcallback.register("postStep", postStepCall)
end)

NPC.setSkill(objNExeSkeleton, 1, 40, 60 * 1.5, sprSkeleShoot, 0.2, function(actor)
end, function(actor, relevantFrame)
	local actorData = actor:getData()
	
	if relevantFrame == 4 then
		sSkeleShoot:play(0.9 + math.random() * 0.2, 1)
		actor:fireExplosion(actor.x + 10 * actor.xscale, actor.y, 20 / 19, 10 / 4, 0.5)
	end
end)

objNExeSkeleton:addCallback("step", function(self)
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	local activity = selfAc.activity
	
	local target = Object.findInstance(selfAc.target or -4)
	if target and target:isValid() then
		if target.x > self.x + 10 then
			selfAc.moveRight = 1
			selfAc.moveLeft = 0
		elseif target.x < self.x - 10 then
			selfAc.moveLeft = 1
			selfAc.moveRight = 0
		end
		
		if selfAc.free == 0 then
			if target.x > self.x and not Stage.collidesPoint(self.x + 10, self.y + 10) or
			target.x < self.x and not Stage.collidesPoint(self.x - 10, self.y + 10) then
				self:getData().jump = true
			end
		end
	end
	
	if global.quality > 1 and math.chance(50) then
		par.Hologram:burst("middle", self.x + math.random(-3, 3), self.y + math.random(-6, 2), 1, selfData._EfColor)
	end
	
	if selfData.life % 120 == 0 then
		local nearestEnemy = nearestMatchingOp(self, pobj.actors, "team", "~=", selfAc.team)
		if nearestEnemy then
			selfAc.target = nearestEnemy.id
		end
	end
	
	selfData.life = selfData.life - 1
	
	if self:collidesMap(self.x, self.y) then
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
	
	if self.sprite.id == selfAc.sprite_death then
		self.subimage = 1
	end
	
	if selfData.life <= 0 then
		local sparks = obj.EfSparks:create(self.x, self.y)
		sparks.sprite = sprSkeleDeath
		sparks.yscale = self.yscale
		sparks.xscale = self.xscale
		if net.online and net.host then
			syncDestroy(self)
		elseif not net.online or selfData.life <= -120 then
			self:destroy()
		end
	end
end)

objNExeSkeleton:addCallback("destroy", function(self)
	sSkeleDeath:play(0.9 + math.random() * 0.2, 1)
	if global.quality > 1 then
		for i = 1, 10 do
			par.Hologram:burst("middle", self.x + math.random(-5, 5), self.y + math.random(-6, 2), 1, self:getData()._EfColor)
		end
	end
end)


local spawnSkeleFunc = setFunc(function(actor, parent)
	if parent:isValid() then
		local parentAc = parent:getAccessor()
		local actorAc = actor:getAccessor()
		
		actorAc.maxhp = parentAc.maxhp * 0.05
		actorAc.hp = actorAc.maxhp
		actorAc.armor = parentAc.armor
		actorAc.damage = parentAc.damage * 0.5
		actorAc.pHmax = parentAc.pHmax
		actorAc.attack_speed = parentAc.attack_speed
		actorAc.cdr = parentAc.cdr
		actorAc.critical_chance = parentAc.critical_chance
		actorAc.hp_regen = parentAc.hp_regen
		actorAc.team = parentAc.team
	end
end)


NPC.setSkill(obj.NemesisExecutioner, 1, 150, 60, sprShoot1, 0.2, nil, function(actor, relevantFrame)
	if relevantFrame == 1 then
		local actorAc = actor:getAccessor()
		sShoot1a:play(0.9 + math.random() * 0.2, 1)
		for i = 1, 3 do
			local l = objNExeBullet:create(actor.x + (17 * i) * actor.xscale, actor.y + math.random(0, 4) - 2)
			l:getData().parent = actor
			l:getData().life = 70 - (10 * i) --- 5 + 100
			l.xscale = actor.xscale
			l:getData().team = actorAc.team
			l:getData().speed = actorAc.attack_speed * 1.5
		end
	end
end)

NPC.setSkill(obj.NemesisExecutioner, 2, 600, 60 * 5, sprShoot2, 0.2, function(actor)
	actor:getData().charges = 3
end, function(actor, relevantFrame)
	if relevantFrame >= 3 and actor:getData().charges > 0 then
		if relevantFrame == 3 then
			sShoot2a:play(0.9 + math.random() * 0.2, 1)
		else
			sShoot2b:play(0.9 + math.random() * 0.2, 1)
		end
		--for i = 1, playerAc.ionBullets do
			createSynced(objNExeSkeleton, actor.x + 3 * relevantFrame * actor.xscale, actor.y, spawnSkeleFunc, actor)
		--end
		actor:getData().charges = actor:getData().charges - 1
	end
end)

NPC.setSkill(obj.NemesisExecutioner, 3, 1000, 60 * 7, sprShoot3, 0.25, nil, function(actor, relevantFrame)
	local actorAc = actor:getAccessor()
	if global.quality == 3 then
		par.Hologram:burst("middle", actor.x + math.random(-5,5), actor.y + math.random(-20,4), 1, actor:getData()._EfColor)
	end
	if relevantFrame == 8 then
		if actorAc.invincible <= 8 then
			actorAc.invincible = 0
		end
	else
		if actorAc.invincible < 8 then
			actorAc.invincible = 8
		end
		if relevantFrame == 1 then
			Sound.find("ExecutionerSkill3", "Starstorm"):play(1, 1)
			local bullet = actor:fireExplosion(actor.x, actor.y, 6, 4, 0, nil, nil, DAMAGER_NO_PROC)
			bullet:set("knockback", 1)
			bullet:set("fear", 1)
		end
	end
	actorAc.pHspeed = actorAc.pHmax * 2.2 * actor.xscale
end)

NPC.setSkill(obj.NemesisExecutioner, 4, 100, 60 * 9, sprShoot4, 0.3, nil, function(actor, relevantFrame)
	local actorAc = actor:getAccessor()
	if global.quality == 3 then
		par.Hologram:burst("middle", actor.x + math.random(-15, 15), actor.y + math.random(-7, 7), 1, actor:getData()._EfColor)
	end
	if relevantFrame == 1 then
		sShoot4a:play(0.9 + math.random() * 0.2, 1)
	end
	if relevantFrame == 4 or relevantFrame == 5 or relevantFrame == 6 or relevantFrame == 7 or relevantFrame == 8 or relevantFrame == 9 then
		actorAc.pHspeed = 0
	end
	if actorAc.invincible < 5 then
		actorAc.invincible = 5
	end
	if relevantFrame == 9 then
		obj.MinerDust:create(actor.x + actor.xscale * 10, actor.y).xscale = actor.xscale
		local n = 0
		while not actor:collidesMap(actor.x + 2 * actor.xscale, actor.y) and n < math.max(math.ceil(20 * actorAc.pHmax), 1) do
			actor.x = actor.x + 2 * actor.xscale
			n = n + 1
		end
		sShoot4b:play(1, 1)
		
		misc.shakeScreen(5)
		local xadd = n
		for i = 0, actorAc.sp do
			local damage
			if actorAc.scepter > 0 then
				damage = 4 + (3 * actorAc.scepter)
			else
				damage = 9
			end
			local addHalf = xadd
			local bullet = actor:fireExplosion(actor.x + addHalf * actor.xscale * -1, actor.y - 7, (xadd + 4) / 19, 14 / 4, damage, nil, sprExSparks3)
			bullet:set("knockback", bullet:get("knockback") + 2)
			--bullet:set("bleed", bullet:get("bleed") + 0.08)
			if actorAc.scepter > 0 then
				bullet:set("fear", 1)
			end
			if i ~= 0 then
				bullet:set("climb", i * 8)
			end
		end
	end
end)

local preStepCall2 = function()
	for _, self in ipairs( obj.NemesisExecutioner:findAll()) do
		if self:getData().jump and self:get("can_jump") == 1 then
			self:set("moveUp", 1)
			self:getData().jump = nil
		end
	end
end

obj.NemesisExecutioner:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Nemesis Executioner"
	selfAc.name2 = "Ferryman of the Damned"
	selfAc.hp_regen = 0.01 * Difficulty.getScaling("hp")
	selfAc.damage = 14 * Difficulty.getScaling("damage")
	selfAc.maxhp = 1000 * getVestigeScaling("hp")
	selfAc.armor = 0
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 1.4
	selfAc.knockback_cap = selfAc.maxhp
	selfAc.exp_worth = 52 * Difficulty.getScaling()
	selfAc.can_drop = 1
	selfAc.can_jump = 1
	selfAc.ropeUp = 0
	selfAc.ropeDown = 0 
	selfAc.pGravity1 = 0.26
	selfAc.pGravity2 = 0.22
	--selfAc.sound_hit = sHit.id
	--selfAc.sound_death = sDeath.id
	--selfAc.sprite_palette = sprPalette.id
	selfAc.sprite_idle = sprIdle.id
	selfAc.sprite_walk = sprWalk.id
	selfAc.sprite_jump = sprJump.id
	selfAc.sprite_death = sprDeath.id
	local outline = obj.EfOutline:create(0, 0)
	outline:set("rate", 0)
	outline:set("parent", self.id)
	outline.blendColor = Color.RED
	outline.alpha = 0.1
	outline.depth = self.depth + 1
	self:getData().isNemesis = "Executioner"
	
	self:getData()._EfColor = efColor
	
	self:setAnimation("climb", sprClimb)
	
	tcallback.register("preStep", preStepCall2)
end)

obj.NemesisExecutioner:addCallback("step", function(self)
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	selfAc.disable_ai = 0
	
	if selfData.timer then
		if selfData.timer < 60 then
			selfData.timer = selfData.timer + 1
			if selfData.timer == 60 then
				if not selfData.items_Held then
					if not net.online or net.host then
						local items = {}
						for i = 1, getVestigeScaling("items") do
							local item = itp.npc:roll()
							items[item] = (items[item] or 0) + 1
							NPCItems.giveItem(self, item, 1)
						end
						--copyParentVariables(self, nil, items)		
						for item, amount in pairs(items) do
							syncNpcItem:sendAsHost(net.ALL, nil, self:getNetIdentity(), item, amount)
						end
					end
				end
			end
		end
	else
		selfData.timer = 0
	end
	
	local activity = selfAc.activity
	
	if obj.POI:findRectangle(self.x - 40, self.y - 300, self.x + 40, self.y + 30) then
		selfAc.moveRight = 0
		selfAc.moveLeft = 0
	end
	
	self.spriteSpeed = 0.25 * selfAc.pHmax
	
	if selfAc.activity ~= 30 then
		local n = 0
		while self:collidesMap(self.x, self.y) and n < 100 do
			if not self:collidesMap(self.x + 4, self.y) then
				self.x = self.x + 4
			elseif not self:collidesMap(self.x - 4, self.y) then
				self.x = self.x - 4
			elseif not self:collidesMap(self.x, self.y + 6) then
				self.y = self.y + 6
			else
				self.y = self.y - 1
			end
			n = n + 1
		end
	end
	
	if misc.director:get("time_start") % 5 == 0 then
		local target = nearestMatchingOp(self, pobj.actors, "team", "~=", self:get("team"))
		if target then target = target.id end
		selfAc.target = target or -4
	end
	
	if selfAc.target then
		local target = Object.findInstance(selfAc.target)
		
		local nearRope = obj.Rope:findRectangle(self.x - 150, self.y - 20, self.x + 150, self.y + 20) 
		
		if target and target:isValid() and misc.getTimeStop() == 0 then
			local nearestRope = obj.Rope:findNearest(target.x, target.y)
			
			local nearestRope = nil
			
			if not nearestRope or nearestRope.obj:isValid() then
				local targetAdd = 300
				local selfAdd = -300
				if target.x < self.x then
					targetAdd = -300
					selfAdd = 300
				end
				
				for _, object in ipairs(obj.Rope:findAllRectangle(self.x + selfAdd, self.y - 10, target.x + targetAdd, target.y - 20) ) do
					if nearestRope then
						local dis = distance(object.x, object.y, self.x, self.y)
						if dis < nearestRope.dis then
							nearestRope = {obj = object, dis = dis}
						end
					else
						nearestRope = {obj = object, dis =  distance(object.x, object.y, self.x, self.y)}
					end
				end
			end
			
			if nearestRope then nearestRope = nearestRope.obj end
			
			local collidesRope = self:collidesWith(obj.Rope, self.x, self.y)
			
			if collidesRope then
				local xx = 3
				if selfAc.pHspeed ~= 0 then
					xx = 3 + selfAc.pHmax
				end
				nearestRope = obj.Rope:findRectangle(self.x - xx, self.y - 30, self.x + xx, self.y + 30)
			end
			
			if selfAc.activity ~= 30 then
				if target.y < self.y + 25 and target.y > self.y - 25 or not nearRope then
					if target.x > self.x + 10 then
						selfAc.moveRight = 1
						selfAc.moveLeft = 0
					elseif target.x < self.x - 10 then
						selfAc.moveLeft = 1
						selfAc.moveRight = 0
					end
				elseif nearestRope and nearestRope:isValid() then
					local collidesRope = self:collidesWith(nearestRope, self.x, self.y + 1)
					if selfAc.pHspeed ~= 0 then
						for i = 1, selfAc.pHmax do
							if self:collidesWith(nearestRope, self.x + i * self.xscale, self.y + 1) then
								self.x = self.x + i
								collidesRope = true
								break
							end
						end
					end
					if collidesRope then
						selfAc.activity = 30
					elseif self.x < nearestRope.x then
						selfAc.moveRight = 1
						selfAc.moveLeft = 0
					elseif self.x > nearestRope.x then
						selfAc.moveLeft = 1
						selfAc.moveRight = 0
					end
					if self.x < nearestRope.x + 20 and self.x > nearestRope.x - 20 and self.y > nearestRope.y then
						self:getData().jump = true
					end
				end
			else
				if target.y < self.y + 5 and target.y > self.y - 5 and self:collidesMap(self.x, self.y) == false then
					selfAc.activity = 0
					self.sprite = sprWalk
				else
					if nearestRope and nearestRope:isValid() and nearestRope:collidesWith(self, nearestRope.x, nearestRope.y - 1) then
						if self.sprite ~= self:getAnimation("climb") then
							self.sprite = self:getAnimation("climb")
						end
						self.spriteSpeed = 0.12 * selfAc.pHmax
						self.x = nearestRope.x + 1
						selfAc.pVspeed = 0
						selfAc.activity = 30
						
						local rheight = nearestRope.yscale * 16
						
						if self.y < target.y then
							selfAc.ropeUp = 0
							selfAc.ropeDown = 1
							--local yy = self.y - nearestRope.y
							self.y = math.clamp(self.y + selfAc.pHmax, nearestRope.y, nearestRope.y + rheight)
						elseif self.y > target.y then
							selfAc.ropeUp = 1
							selfAc.ropeDown = 0
							self.y = math.clamp(self.y - selfAc.pHmax, nearestRope.y, nearestRope.y + rheight)
						end
						if self.y == nearestRope.y and selfAc.ropeUp == 1 or self.y == nearestRope.y + rheight and selfAc.ropeDown == 1 then
							selfAc.activity = 0
						end
					else
						selfAc.activity = 0
						self.sprite = sprWalk
					end
				end
			end
		end
	elseif selfAc.activity == 30 then
		selfAc.activity = 0
		self.sprite = sprIdle
	end
	
	if selfAc.moveRight == 1 and self:collidesMap(self.x + (selfAc.pHmax), self.y + 2) == false then
		self:getData().jump = true
	elseif selfAc.moveLeft == 1 and self:collidesMap(self.x - (selfAc.pHmax), self.y + 2) == false then
		self:getData().jump = true
	end
	
	otherNpcItems(self)
	
	if self.sprite == sprDeath then self.subimage = 1 end
	
	if misc.getTimeStop() == 0 then
		if selfAc.activity ~= 30 then
			if activity == 0 then
				for k, skill in pairs(NPC.skills[object]) do
					if self:get(skill.key.."_skill") > 0 and self:getAlarm(k + 1) == -1 then
						selfData.attackFrameLast = 0
						self:set(skill.key.."_skill", 0)
						if skill.start then
							skill.start(self)
						end
						selfAc.activity = k
						self.subimage = 1
						if skill.cooldown then
							self:setAlarm(k + 1, skill.cooldown * (1 - self:get("cdr")))
						end
					else
						self:set(skill.key.."_skill", 0)
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
					end
				end
			end
		end
	else
		self.spriteSpeed = 0
	end
	
	if self.y >= global.currentStageHeight - 10 then
		local b = obj.B:findNearest(self.x, self.y)
		if b then
			self.x = b.x
			self.y = b.y
			local s = obj.EfSparks:create(self.x, self.y)
			s.sprite = spr.EfRecallFail
			s.yscale = 1
		end
	end
end)

obj.NemesisExecutioner:addCallback("destroy", function(self)
	tcallback.unregister("onStep", onStepCall)
	tcallback.unregister("preStep", preStepCall)
	tcallback.unregister("preStep", preStepCall2)
end)