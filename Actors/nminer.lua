local path = "Survivors/Miner/Skins/Nemesis/"

local efColor = Color.fromHex(0xCC4D4D)

local sprIdle = Sprite.load("NemesisMinerIdle", path.."Idle", 1, 6, 5)
local sprJump = Sprite.load("NemesisMinerJump", path.."Jump", 1, 5, 6)
local sprWalk = Sprite.load("NemesisMinerWalk", path.."Walk", 8, 8, 5)
local sprClimb = Sprite.load("NemesisMinerClimb", path.."Climb", 2, 4, 6)
local sprShoot1 = Sprite.load("NemesisMinerShoot1Full", path.."Shoot1Full", 5, 11, 11)
local sprShoot2 = Sprite.load("NemesisMinerShoot2", path.."Shoot2", 6, 23, 6)
local sprShoot3 = Sprite.load("NemesisMinerShoot3", path.."Shoot3", 19, 22, 7)
local sprShoot4 = Sprite.load("NemesisMinerShoot4", path.."Shoot4", 9, 25, 39)
local sprDeath = Sprite.load("NemesisMinerDeath", path.."Death", 10, 10, 14)
--local sprPortrait = Sprite.load("NemesisMinerPortrait", path.."Portrait", 1, 119, 119)

local sShoot1 = Sound.load("NemesisMinerShoot1", path.."Shoot1")
local sShoot3 = Sound.load("NemesisMinerShoot3", path.."Shoot3")
local sShoot4_1 = Sound.load("NemesisMinerShoot4_1", path.."Shoot4_1")
local sShoot4_2 = Sound.load("NemesisMinerShoot4_2", path.."Shoot4_2")


obj.NemesisMiner = Object.base("BossClassic", "NemesisMiner")
obj.NemesisMiner.sprite = sprIdle


local objNemMinerShockwave = Object.new("NemMinerShockwave")
objNemMinerShockwave.sprite = spr.Nothing
objNemMinerShockwave.depth = 1
objNemMinerShockwave:addCallback("create", function(self)
	local selfData = self:getData()
	
	selfData.timer = 140
	selfData.range = 8
	selfData.team = "player" 
	selfData.damage = 25
	selfData.speed = 1.8
	selfData.dir = 1
	
	selfData._EfColor = Color.fromHex(0xE7967E)
end)
objNemMinerShockwave:addCallback("step", function(self)
	local selfData = self:getData()
	
	local newx = self.x + selfData.speed * selfData.dir
	if Stage.collidesPoint(newx, self.y) and Stage.collidesPoint(newx, self.y - 16) then
		selfData.timer = -1
		selfData.boom = true
	else
		self.x = newx
	end
	
	local parent = selfData.parent
	local r = selfData.range
	if parent and parent:isValid() then
		for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - r, self.y - r, self.x + r, self.y + r)) do
			if actor:get("team") ~= parent:get("team") then
				selfData.boom = true
				break
			end
		end
	end
	
	if selfData.timer < 0 or selfData.boom then
		r = r + 6
		if parent and parent:isValid() then
			local damager = parent:fireExplosion(self.x, self.y, r / 19, r / 4, selfData.damage / parent:get("damage")):set("knockup", 4)
		else
			misc.fireExplosion(self.x, self.y, (r * 0.8) / 19, (r * 0.8) / 4, selfData.damage, selfData.team):set("knockup", 4)
		end
		if selfData.boom then
			if onScreen(self) then
				misc.shakeScreen(4)
				local sparks = obj.EfSparks:create(self.x, self.y):set("depth", -12)
				sparks.sprite = spr.TotemShockwave
				sparks.yscale = 1
			end
			sfx.Smite:play(1.3 + math.random() * 0.2, 0.5)
		end
		self:destroy()
	else
		selfData.timer = selfData.timer - 1
		
		if selfData.timer % 10 == 0 then
			local sparks = obj.EfSparks:create(self.x, self.y):set("depth", -12)
			sparks.sprite = spr.TotemShockwave
			local mult = math.max(selfData.timer / 360, 0.2)
			sparks.xscale = mult
			sparks.yscale = mult
		end
		
		local destroy = true
		for i = -4, 40 do
			local ii = (i * 4)
			if Stage.collidesPoint(self.x, self.y + ii) then
				self.y = self.y + ii
				destroy = false
				break
			end
		end
		if destroy then
			selfData.timer = -1
		end
	end
end)

NPC.setSkill(obj.NemesisMiner, 1, 50, 60, sprShoot1, 0.2, nil, function(actor, relevantFrame)
	if relevantFrame == 1 then
		local actorAc = actor:getAccessor()
		sShoot1:play(0.9 + math.random() * 0.2, 0.6)
		actor:fireBullet(actor.x, actor.y, actor:getFacingDirection(), 40, actor:get("damage"))
	end
end)

NPC.setSkill(obj.NemesisMiner, 2, 400, 60 * 8, sprShoot2, 0.25, nil, function(actor, relevantFrame)
	local actorAc = actor:getAccessor()
	if relevantFrame == 1 then
		sfx.MinerShoot2:play(1, 1)
		actor:fireBullet(actor.x, actor.y, actor:getFacingDirection(), 100, actor:get("damage") * 1.5)
	end
	actorAc.pHspeed = actorAc.pHmax * 2.5 * actor.xscale
	if relevantFrame >= 1 and relevantFrame <= 6 and actorAc.free == 0 then
		obj.MinerDust:create(actor.x + actor.xscale * 10, actor.y).xscale = actor.xscale * -1
	end
	if actorAc.invincible < 4 then
		actorAc.invincible = 4
	end
end)

NPC.setSkill(obj.NemesisMiner, 3, 1000, 60 * 6, sprShoot3, 0.2, nil, function(actor, relevantFrame)
	local actorAc = actor:getAccessor()
	local actorData = actor:getData()
	if global.quality > 1 then
		par.Smoke:burst("middle", actor.x, actor.y, 1)
	end
	if actorAc.invincible < 2 then
		actorAc.invincible = 2
	end
	
	if relevantFrame == 1 then
		sShoot3:play(0.9 + math.random() * 0.2, 0.8)
		actorData.drillDirection = actor:getFacingDirection()
		actorData.drillLastXscale = actor.xscale
		actor.xscale = math.abs(actor.xscale)
		actorAc.pHspeed = 0
		actorData.drillEff = true
	elseif relevantFrame > 1 then
		local damager = actor:fireExplosion(actor.x, actor.y, 11 / 19, 11 / 4, 0.4, nil, nil)
		damager:set("knockback", 3)
	end
	if actorData.drillDirection then
		if global.quality > 1 then
			if actorData.drillDirection > - 45 and actorData.drillDirection < 45 and actor:collidesMap(actor.x + 1, actor.y) then
				par.Debris:burst("above", actor.x + 4, actor.y, 1)
			elseif actorData.drillDirection > 135 and actorData.drillDirection < 225 and actor:collidesMap(actor.x - 1, actor.y) then
				par.Debris:burst("above", actor.x - 4, actor.y, 1)
			end
		end
		
		actor.angle = actorData.drillDirection * -1 
	end
	local dir = math.rad(actorData.drillDirection)
	local speed = actorAc.pHmax + 0.4
	local xx = math.cos(dir) * speed
	local yy = math.sin(dir) * speed
	if actorData.drillDirection == 180 then yy = 0 end
	
	for i = 0, math.abs(xx * 10) do
		local newx = actor.x + math.sign(xx) * 0.1
		if actor:collidesMap(newx, actor.y) then
			break
		else
			actor.x = newx
		end
	end
	for i = 0, math.abs(yy * 10) do
		local newy = actor.y + math.sign(yy) * 0.1
		if actor:collidesMap(actor.x, yy) then
			break
		else
			actor.y = newy
		end
	end
	
	actorAc.pVspeed = actorAc.pGravity1 * -1
	
	if actor.subimage >= actor.sprite.frames - 0.25 then
		actor.angle = 0
		actor.xscale = actor.xscale * math.sign(actorData.drillLastXscale)
	end
end)

NPC.setSkill(obj.NemesisMiner, 4, 100, 60 * 6, sprShoot4, 0.2, nil, function(actor, relevantFrame)
	local actorAc = actor:getAccessor()
	local actorData = actor:getData()
	if actorAc.invincible < 3 then
		actorAc.invincible = 3
	end
	if relevantFrame == 1 then
		actorAc.pVspeed = -2
		sShoot4_1:play(0.9 + math.random() * 0.2)
	elseif relevantFrame == 4 then
		sShoot4_2:play(0.9 + math.random() * 0.2)
		local yy = 0
		for i = 1, 100 do
			if actor:collidesMap(actor.x, actor.y + i * 8) then
				actor.y = actor.y + ((i - 1) * 8)
				yy = yy + ((i - 1) * 8)
				break
			end
		end
		for i = 1, 16 do
			if actor:collidesMap(actor.x, actor.y + i) then
				actor.y = actor.y + (i - 1)
				yy = yy + (i - 1)
				break
			end
		end
		if global.quality > 1 then
			for i = 1, yy do
				par.Smoke:burst("middle", actor.x, actor.y - i, 1)
			end
		end
		
		local shockwave = objNemMinerShockwave:create(actor.x, actor.y - 5)
		shockwave:getData().parent = actor
		shockwave:getData().dir = 1
		shockwave:getData().damage = actorAc.damage * 2.5
		local shockwave = objNemMinerShockwave:create(actor.x, actor.y - 5)
		shockwave:getData().parent = actor
		shockwave:getData().dir = -1
		shockwave:getData().damage = actorAc.damage * 2.5
		
	end
end)

local preStepCall = function()
	for _, self in ipairs( obj.NemesisMiner:findAll()) do
		if self:getData().jump and self:get("can_jump") == 1 then
			self:set("moveUp", 1)
			self:getData().jump = nil
		end
	end
end

obj.NemesisMiner:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = spr.PMask
	selfAc.name = "Nemesis Miner"
	selfAc.name2 = "Alpha Excavator"
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
	self:getData().isNemesis = "Miner"
	self:getData().noFallDeath = true
	
	self:getData()._EfColor = efColor
	
	self:setAnimation("climb", sprClimb)
	
	tcallback.register("preStep", preStepCall)
end)

obj.NemesisMiner:addCallback("step", function(self)
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

obj.NemesisMiner:addCallback("destroy", function(self)
	tcallback.unregister("preStep", preStepCall)
end)