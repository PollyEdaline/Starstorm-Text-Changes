local path = "Survivors/Bandit/Skins/Nemesis/"

local sprIdle = Sprite.load("NemesisBanditIdle", path.."Idle", 1, 5, 9)
local sprJump = Sprite.load("NemesisBanditJump", path.."Jump", 1, 5, 9)
local sprWalk = Sprite.load("NemesisBanditWalk", path.."Walk", 8, 9, 16)
local sprClimb = Sprite.load("NemesisBanditClimb", path.."Climb", 2, 5, 6)
local sprShoot1 = Sprite.load("NemesisBanditShoot1", path.."Shoot1", 4, 7, 9)
local sprShoot2a = Sprite.load("NemesisBanditShoot2A", path.."Shoot2a", 10, 9, 13)
local sprShoot2b = Sprite.load("NemesisBanditShoot2B", path.."Shoot2b", 9, 9, 13)
local sprShoot4 = Sprite.load("NemesisBanditShoot4", path.."Shoot4", 9, 7, 13)
local sprDeath = Sprite.load("NemesisBanditDeath", path.."Death", 17, 13, 16)
--local sprPortrait = Sprite.load("NemesisBanditPortrait", path.."Portrait", 1, 119, 119)
local sShoot1 = Sound.load("NemesisBanditGun", path.."Shoot1")
local sShoot2a = Sound.load("NemesisBanditWhipA", path.."Shoot2a")
local sShoot2b = Sound.load("NemesisBanditWhipB", path.."Shoot2b")

obj.NemesisBandit = Object.base("BossClassic", "NemesisBandit")
obj.NemesisBandit.sprite = sprIdle

NPC.setSkill(obj.NemesisBandit, 1, 400, 60, sprShoot1, 0.25, nil, function(actor, relevantFrame)
	if relevantFrame == 1 then
		local direction = actor:getFacingDirection()
		sShoot1:play(0.9 + math.random() * 0.2)
		local bullet = actor:fireBullet(actor.x, actor.y, direction, 400, 2.2, spr.Sparks1)
		bullet:set("knockback", 2)
	end
end)

NPC.setSkill(obj.NemesisBandit, 2, 300, 60 * 3, nil, 0.25, function(actor)
	local actorData = actor:getData()
	if actorData.whipChild and actorData.whipChild:isValid() then
		actor:setAnimation("shoot2", sprShoot2b)
	else
		actor:setAnimation("shoot2", sprShoot2a)
	end
end, function(actor, relevantFrame)
	local actorData = actor:getData()
	local actorAc = actor:getAccessor()
	
	actor.sprite = actor:getAnimation("shoot2")
	
	if actor.sprite == sprShoot2b then
		local child = actorData.whipChild
		if child and child:isValid() then
			if child.x < actor.x then
				actor.xscale = -1
			else
				actor.xscale = 1
			end
		end
		if relevantFrame == 1 then
			sShoot2b:play(1 + math.random() * 0.2)
		elseif relevantFrame == 4 then
			if child and child:isValid() then
				local bullet = actor:fireBullet(child.x - 2, child.y, 0, 4, 0.2, nil)
				bullet:set("specific_target", child.id)
				
				child:set("pVspeed", -2)
				child:setAlarm(7, 60)
				child.y = child.y - 1
				if child.x < actor.x then
					child:getData()._pullDir = 1
				else
					child:getData()._pullDir = -1
				end
				child:applyBuff(buff.nBanditPull, 60)
			end
		elseif relevantFrame == 7 then
			actorData.whipChild = nil
		end
	else
		if relevantFrame == 1 then
			sShoot2a:play(1 + math.random() * 0.2)
		elseif relevantFrame == 8 then
			local bullet = actor:fireBullet(actor.x, actor.y, actor:getFacingDirection(), 400, 0.8, nil)
			bullet:getData().isNBanditWhip = true
		end
		if relevantFrame > 8 and actorData.whipChild and actorData.whipChild:isValid() then
			actor.subimage = actor.sprite.frames
		end
	end
end)

NPC.setSkill(obj.NemesisBandit, 3, 1000, 60 * 16, nil, 0.25, function(actor)
	local ef = obj.EfSparks:create(actor.x, actor.y)
	ef.sprite = spr.CowboyShoot3
	ef.xscale = actor.xscale
	ef.yscale = actor.yscale
	sfx.WispSpawn:play(1.5)
	if actor:getData().smokeBomb <= 0 then
		actor:set("pHmax", actor:get("pHmax") + 0.5)
		actor.alpha = actor.alpha - 1
	end
	actor:getData().smokeBomb = 200
end)

NPC.setSkill(obj.NemesisBandit, 4, 100, 60 * 7, sprShoot4, 0.25, nil, function(actor, relevantFrame)
	if relevantFrame == 1 then
		sfx.CowboyShoot4_1:play(0.9 + math.random() * 0.2)
	elseif relevantFrame == 6 then
		sfx.CowboyShoot4_2:play(0.9 + math.random() * 0.2)
		local bullet = actor:fireBullet(actor.x, actor.y, actor:getFacingDirection(), 110, 6, spr.Sparks4, DAMAGER_BULLET_PIERCE)
		bullet:set("knockback", 3)
	end
end)

local preStepCall = function()
	for _, self in ipairs( obj.NemesisBandit:findAll()) do
		if self:getData().jump and self:get("can_jump") == 1 then
			self:set("moveUp", 1)
			self:getData().jump = nil
		end
	end
end

obj.NemesisBandit:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = spr.PMask
	selfAc.name = "Nemesis Bandit"
	selfAc.name2 = "Blackened Outlaw"
	selfAc.hp_regen = 0.01 * Difficulty.getScaling("hp")
	selfAc.damage = 15 * Difficulty.getScaling("damage")
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
	self:getData().isNemesis = "Bandit"
	self:getData().smokeBomb = 0
	self:getData().noFallDeath = true
	
	tcallback.register("preStep", preStepCall)
end)

obj.NemesisBandit:addCallback("step", function(self)
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	selfAc.disable_ai = 0
	
	if selfData.smokeBomb > 0 then
		selfData.smokeBomb = selfData.smokeBomb - 1
		
		local xx = self.x + math.random(-3, 3)
		local yy = self.y + math.random(-5, 5)
		
		par.SmokeFirework:burst("middle", xx, yy, 1)
		
		if selfData.smokeBomb == 1 then
			sfx.WispSpawn:play(1.5)
			local ef = obj.EfSparks:create(self.x, self.y)
			ef.sprite = spr.CowboyShoot3
			ef.xscale = self.xscale
			ef.yscale = self.yscale
			selfAc.pHmax = selfAc.pHmax - 0.5
			self.alpha = self.alpha + 1
		end
	end
	
	local whipChild = selfData.whipChild
	if self:get("activity") ~= 2 or self.sprite == sprShoot2b and self.subimage < 3 then
		if whipChild then
			if whipChild:isValid() then
				whipChild:setAlarm(7, 10)
			end
			if whipChild:isValid() == false or whipChild.y > self.y + 40 or whipChild.y < self.y - 40 then
				selfData.whipChild = nil
				self:setAnimation("shoot2", sprShoot2a)
			else
				self:setAnimation("shoot2", sprShoot2b)
			end
		end
	end
	if selfData.whipChildTimer then
		if selfData.whipChildTimer > 0 then
			selfData.whipChildTimer = selfData.whipChildTimer - 1
		else
			selfData.whipChild = nil
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

local childColor = Color.fromHex(0xB59C77)

obj.NemesisBandit:addCallback("draw", function(self)
	local child = self:getData().whipChild
	if child and child:isValid() then
		graphics.alpha(1)
		graphics.color(childColor)
		graphics.line(self.x, self.y - 1, child.x, child.y)
	end
end)

obj.NemesisBandit:addCallback("destroy", function(self)
	tcallback.unregister("preStep", preStepCall)
end)