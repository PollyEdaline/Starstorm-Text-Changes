local path = "Survivors/Enforcer/Skins/Nemesis/"

local sprIdle_1 = Sprite.load("NemesisEnforcerIdleA", path.."Idle_1", 1, 15, 11)
local sprIdle_2 = Sprite.load("NemesisEnforcerIdleB", path.."Idle_2", 1, 6, 10)
local sprJump_1 = Sprite.load("NemesisEnforcerJumpA", path.."Jump_1", 1, 13, 16)
local sprJump_2 = Sprite.load("NemesisEnforcerJumpB", path.."Jump_2", 1, 10, 16)
local sprWalk_1 = Sprite.load("NemesisEnforcerWalkA", path.."Walk_1", 8, 15, 18)
local sprWalk_2 = Sprite.load("NemesisEnforcerWalkB", path.."Walk_2", 8, 6, 18)
local sprClimb = Sprite.load("NemesisEnforcerClimb", path.."Climb", 2, 4, 6)
local sprShoot1_1 = Sprite.load("NemesisEnforcerShoot1A", path.."Shoot1_1", 7, 21, 15)
local sprShoot1_2 = Sprite.load("NemesisEnforcerShoot1B", path.."Shoot1_2", 2, 13, 15)
local sprShoot1_3 = Sprite.load("NemesisEnforcerShoot1C", path.."Shoot1_3", 36, 8, 15)
local sprShoot2 = Sprite.load("NemesisEnforcerShoot2", path.."Shoot2", 11, 18, 34)
local sprShoot3_1 = Sprite.load("NemesisEnforcerShoot3A", path.."Shoot3_1", 5, 16, 14)
local sprShoot3_2 = Sprite.load("NemesisEnforcerShoot3B", path.."Shoot3_2", 5, 16, 14)
local sprDeath = Sprite.load("NemesisEnforcerDeath", path.."Death", 5, 13, 14)
local sprBullet = Sprite.load("NemesisEnforcerBullet", path.."Bullet", 5, 2, 7)
local sprSparks = spr.Sparks9r
--local sprPortrait = Sprite.load("NemesisEnforcerPortrait", path.."Portrait", 1, 119, 119)
--local sShoot1 = Sound.load("NemesisEnforcerSlash", path.."Shoot1")

obj.NemesisEnforcer = Object.base("BossClassic", "NemesisEnforcer")
obj.NemesisEnforcer.sprite = sprIdle_1

NPC.setSkill(obj.NemesisEnforcer, 1, 40, 30, nil, 0.2, function(actor)
	if actor:getData().minigun == true then
		actor.sprite = sprShoot1_3
	else
		actor.sprite = sprShoot1_1
	end
end, function(actor, relevantFrame)
	if actor:getData().minigun == true then
		actor.sprite = sprShoot1_3
	else
		actor.sprite = sprShoot1_1
	end
	local direction = actor:getFacingDirection()
	if actor:getData().minigun == true then
		if relevantFrame % 2 == 1 then
			sfx.Bullet3:play(1.4)
			local bullet = actor:fireBullet(actor.x, actor.y - 3, direction + math.random(-1.5, 1.5), 500, 0.45, spr.Sparks1)
			local sparks = obj.EfSparks:create(actor.x + (10 * actor.xscale), actor.y)
			sparks.sprite = sprBullet
			sparks.depth = -9
			sparks.xscale = actor.xscale
		end
	else
		if relevantFrame == 1 then
			sfx.JanitorShoot1_2:play(1.1, 1)
			for i = 0, actor:get("sp") or 1 do
				local bullet = actor:fireBullet(actor.x + (10 * (actor.xscale * -1)) , actor.y, direction, 40, 5, sprSparks)
				bullet:set("knockback", bullet:get("knockback") + 6)
				bullet:set("knockup", bullet:get("knockup") + 2)
				bullet:set("stun", bullet:get("stun") + 0.4)
			end
		end
	end
end)

NPC.setSkill(obj.NemesisEnforcer, 2, 50, 60 * 4, sprShoot2, 0.25, nil, function(actor, relevantFrame)
	if relevantFrame == 6 then
		local direction = actor:getFacingDirection()
		sfx.JanitorShoot1_2:play(0.8)
		local bullet = actor:fireBullet(actor.x + (2 * actor.xscale * -1), actor.y - 1, direction, 50, 2.5, spr.Sparks5, DAMAGER_BULLET_PIERCE)
		bullet:set("knockback", 7)
		bullet:set("stun", 2)
	end
end)

NPC.setSkill(obj.NemesisEnforcer, 3, 500, 60 * 5, nil, 0.2, function(actor)
	if actor:getData().minigun == true then
		actor.sprite = sprShoot3_1
	else
		actor.sprite = sprShoot3_2
	end
end, function(actor, relevantFrame)
	local actorAc = actor:getAccessor()
	if relevantFrame == 1 then
		if actor:getData().minigun == true then
			actor.sprite = sprShoot3_2
		else
			actor.sprite = sprShoot3_1
		end
	elseif relevantFrame == 4 then
		if actor:getData().minigun == true then
			actor:getData().minigun = false
			actorAc.z_range = 40
			actorAc.pHmax = actorAc.pHmax + 0.5
			actorAc.activity_type = 0
			actorAc.sprite_idle = sprIdle_1.id
			actorAc.sprite_walk = sprWalk_1.id
			actorAc.sprite_jump = sprJump_1.id
		else
			actor:getData().minigun = true
			actorAc.z_range = 400
			actorAc.pHmax = actorAc.pHmax - 0.5
			actorAc.activity_type = 4
			actorAc.sprite_idle = sprIdle_2.id
			actorAc.sprite_walk = sprWalk_2.id
			actorAc.sprite_jump = sprJump_2.id
		end
	end
end)

NPC.setSkill(obj.NemesisEnforcer, 4, 400, 60 * 6, sprShoot1_1, 0.25, nil, function(actor, relevantFrame)
	if relevantFrame == 1 then
		local direction = actor:getFacingDirection()
		sfx.RiotGrenade:play()
		local grenade = obj.RiotGrenade:create(actor.x, actor.y - 4)
		grenade:set("team", actor:get("team"))
		grenade:getData().cParent = actor
		grenade:set("bounces", 0)
		grenade:set("angle", direction)
		grenade:set("speed", 8)
		grenade:set("direction", direction)
	end
end)

obj.RiotGrenade:addCallback("destroy", function(self)
	if self:getData().cParent then
		local parent = self:getData().cParent
		
		if parent:isValid() then
			local explosion = parent:fireExplosion(self.x, self.y, 20 / 19, 20 / 4, 2.5, spr.RiotGrenadeExplosion)
			explosion:set("stun", 1.5)
		end
	end
end)

local onStepCall = function()
	for _, grenade in ipairs(obj.RiotGrenade:findAll()) do
		if grenade:getData().cParent then
			local nearestActor = pobj.actors:findNearest(grenade.x, grenade.y)
			if nearestActor and grenade:collidesWith(nearestActor, grenade.x, grenade.y) and nearestActor:get("team") ~= grenade:get("team") then
				grenade:destroy()
			end
		end
	end
end

local preStepCall = function()
	for _, self in ipairs( obj.NemesisEnforcer:findAll()) do
		if self:getData().jump and self:get("can_jump") == 1 then
			self:set("moveUp", 1)
			self:getData().jump = nil
		end
	end
end

obj.NemesisEnforcer:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = spr.PMask
	selfAc.name = "Nemesis Enforcer"
	selfAc.name2 = "Incorruptible Shadow"
	selfAc.hp_regen = 0.01 * Difficulty.getScaling("hp")
	selfAc.damage = 15 * Difficulty.getScaling("damage")
	selfAc.maxhp = 1000 * getVestigeScaling("hp")
	selfAc.armor = 25
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 1
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
	selfAc.sprite_idle = sprIdle_1.id
	selfAc.sprite_walk = sprWalk_1.id
	selfAc.sprite_jump = sprJump_1.id
	selfAc.sprite_death = sprDeath.id
	local outline = obj.EfOutline:create(0, 0)
	outline:set("rate", 0)
	outline:set("parent", self.id)
	outline.blendColor = Color.RED
	outline.alpha = 0.1
	outline.depth = self.depth + 1
	self:getData().isNemesis = "Enforcer"
	self:getData().noFallDeath = true
	
	tcallback.register("onStep", onStepCall)
	tcallback.register("preStep", preStepCall)
end)

obj.NemesisEnforcer:addCallback("step", function(self)
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
			elseif not self:collidesMap(self.x, self.y + 5) then
				self.y = self.y + 5
			else
				self.y = self.y - 1
				n = n + 1
			end
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
							
			if self:collidesWith(obj.Rope, self.x, self.y) then
				nearestRope = obj.Rope:findRectangle(self.x - 3, self.y - 30, self.x + 3, self.y + 30)
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
					if self:collidesWith(nearestRope, self.x, self.y + 1) then
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
				if target.y < self.y + 5 and target.y > self.y - 5 and self:collidesMap(self.x, self.y) == false  then
					selfAc.activity = 0
					self.sprite = sprWalk_1
				else
					if nearestRope and nearestRope:isValid() and nearestRope:collidesWith(self, nearestRope.x, nearestRope.y - 1) then
						if self.sprite ~= sprClimb then
							self.sprite = sprClimb
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
						self.sprite = sprWalk_1
					end
				end
			end
		end
	elseif selfAc.activity == 30 then
		selfAc.activity = 0
		self.sprite = sprIdle_1
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
					if selfAc.free == 0 and selfAc.activity_type ~= 4 then
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

obj.NemesisEnforcer:addCallback("destroy", function(self)
	tcallback.unregister("preStep", preStepCall)
end)