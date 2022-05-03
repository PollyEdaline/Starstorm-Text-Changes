local path = "Survivors/Mercenary/Skins/Nemesis/"

local sprIdle = Sprite.load("NemesisMercenaryIdle", path.."Idle", 1, 4, 5)
local sprIdle2 = Sprite.load("NemesisMercenaryIdle_2", path.."Idle_2", 1, 4, 5)
local sprJump = Sprite.load("NemesisMercenaryJump", path.."Jump", 1, 4, 5)
local sprWalk = Sprite.load("NemesisMercenaryWalk", path.."Walk", 8, 5, 5)
local sprClimb = Sprite.load("NemesisMercenaryClimb", path.."Climb", 2, 4, 7)
local sprShoot1_1 = Sprite.load("NemesisMercenaryShoot1_1", path.."Shoot1_1", 9, 7, 10)
local sprShoot1_2 = Sprite.load("NemesisMercenaryShoot1_2", path.."Shoot1_2", 9, 9, 10)
local sprShoot2_1 = Sprite.load("NemesisMercenaryShoot2_1", path.."Shoot2_1", 5, 6, 14)
local sprShoot2_2 = Sprite.load("NemesisMercenaryShoot2_2", path.."Shoot2_2", 5, 7, 14)
local sprShoot3 = Sprite.load("NemesisMercenaryShoot3", path.."Shoot3", 2, 9, 5)
local sprShoot4 = Sprite.load("NemesisMercenaryShoot4", path.."Shoot4", 18, 30, 16)
local sprSparks = Sprite.load("NemesisMercenarySlash", path.."Slash", 5, 26, 25)
local sprDeath = Sprite.load("NemesisMercenaryDeath", path.."Death", 10, 9, 8)
local sShoot2_1 = Sound.load("NemesisMercenaryShoot2_1", path.."Shoot2_1")
local sShoot2_2 = Sound.load("NemesisMercenaryShoot2_2", path.."Shoot2_2")
local sShoot4 = Sound.load("NemesisMercenaryShoot4", path.."Shoot4")

obj.NemesisMercenary = Object.base("BossClassic", "NemesisMercenary")
obj.NemesisMercenary.sprite = sprIdle


NPC.setSkill(obj.NemesisMercenary, 1, 30, 30, nil, 0.25, function(actor)
	if actor:getData().sliding then
		actor.sprite = sprShoot1_2
	else
		actor.sprite = sprShoot1_1
	end
end, function(actor, relevantFrame)
	if actor:getData().sliding then
		actor.sprite = sprShoot1_2
	else
		actor.sprite = sprShoot1_1
	end
	if relevantFrame == 4 then
		local direction = actor:getFacingDirection()
		sfx.SamuraiShoot1:play(0.9 + math.random() * 0.2)
		local bullet = actor:fireBullet(actor.x + 4 * actor.xscale * -1, actor.y - 2, direction, 33, 1.3, spr.Sparks9, DAMAGER_BULLET_PIERCE)
	end
end)

NPC.setSkill(obj.NemesisMercenary, 2, 100, 3 * 60, nil, 0.25, function(actor)
	if actor:getData().sliding then
		actor.sprite = sprShoot2_2
	else
		actor.sprite = sprShoot2_1
	end
end, function(actor, relevantFrame)
	if actor:getData().sliding then
		actor.sprite = sprShoot2_2
	else
		actor.sprite = sprShoot2_1
	end
	if relevantFrame == 1 then
		sShoot2_1:play(0.9 + math.random() * 0.2)
		if onScreen(actor) then
			misc.shakeScreen(3)
		end
		local bullet = actor:fireBullet(actor.x, actor.y, actor:getFacingDirection(), 100, 5, spr.Sparks4, DAMAGER_BULLET_PIERCE)
		bullet:set("damage_degrade", 0.4)
	elseif relevantFrame == actor.sprite.frames - 2 then
		sShoot2_2:play(0.9 + math.random() * 0.2, 0.5)
	end
end)

NPC.setSkill(obj.NemesisMercenary, 3, 1000, 60 * 5, nil, 0.25, function(actor)
	actor:setAnimation("idle", sprIdle2)
	actor:setAnimation("walk", sprIdle2)
	actor:setAnimation("jump", sprIdle2)
	actor:getData().xAccel = 3 * actor:get("pHmax") * actor.xscale
	actor:getData().sliding = true
	
	if actor:get("free") == 0 then
		local ef = obj.EfSparks:create(actor.x, actor.y)
		ef.sprite = spr.MinerShoot2Dust1
		ef.yscale = 1
		ef.xscale = actor.xscale
	end
	
	if actor:get("invincible") < 20 then
		actor:set("invincible", actor:get("invincible") + 20)
	end
end)

NPC.setSkill(obj.NemesisMercenary, 4, 100, 60 * 6, sprShoot4, 0.3, nil, function(actor, relevantFrame)
	--[[if relevantFrame == 2 or relevantFrame == 4 or relevantFrame == 6 or relevantFrame == 8 or relevantFrame == 10 or relevantFrame == 12 then
		local target = Object.findInstance(actor:get("target") or - 4) or actor
		
		local angle = posToAngle(actor.x, actor.y, target.x, target.y, true)
		local dis = math.min(distance(actor.x, actor.y, target.x, target.y), 100)
		local x = actor.x + math.cos(angle) * dis
		local y = actor.y + math.sin(-angle) * dis
		
		sfx.Bullet3:play()
		actor:fireBullet(x + 2 * actor.xscale * -1, y - 3,  actor:getFacingDirection(), 10, 0.5, spr.Sparks9)
		sfx.SamuraiShoot1:play(0.9 + math.random() * 0.2)
	end]]
	if relevantFrame == 7 then
		sShoot4:play(0.9 + math.random() * 0.2)
		if onScreen(actor) then
			misc.shakeScreen(4)
		end
		local nearestEnemy = Object.findInstance(actor:get("target") or - 4) or actor
		if nearestEnemy and distance(actor.x, actor.y, nearestEnemy.x, nearestEnemy.y) <= 100 then
			local bullet = actor:fireBullet(nearestEnemy.x, nearestEnemy.y, actor:getFacingDirection(), 5, 7, sprSparks)
		end
	end
end)

local preStepCall = function()
	for _, self in ipairs( obj.NemesisMercenary:findAll()) do
		if self:getData().jump and self:get("can_jump") == 1 then
			self:set("moveUp", 1)
			self:getData().jump = nil
		end
	end
end

obj.NemesisMercenary:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = spr.PMask
	selfAc.name = "Nemesis Mercenary"
	selfAc.name2 = "Avenging Deserter"
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
	self:getData().isNemesis = "Mercenary"
	self:getData().noFallDeath = true
	
	tcallback.register("preStep", preStepCall)
end)

obj.NemesisMercenary:addCallback("step", function(self)
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	selfAc.disable_ai = 0
	
	if selfData.sliding then
		if not selfData.xAccel then
			selfData.sliding = nil
			
			self:setAnimation("idle", sprIdle)
			self:setAnimation("walk", sprWalk)
			self:setAnimation("jump", sprJump)
			self:setAnimation("shoot1_1", sprShoot1_1)
		end
	end
	
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
			local nearestRope = nil--obj.Rope:findNearest(target.x, target.y)
			
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
						for i = 1, selfAc.pHmax * 10 do
							if self:collidesWith(nearestRope, self.x + (i * 0.1) * self.xscale, self.y + 1) then
								self.x = self.x + i * 0.1
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

obj.NemesisMercenary:addCallback("destroy", function(self)
	tcallback.unregister("preStep", preStepCall)
end)