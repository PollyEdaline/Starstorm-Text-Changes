local path = "Survivors/Commando/Skins/Nemesis/"

local sprIdle = Sprite.load("NemesisCommandoIdle", path.."Idle", 1, 6, 6)
local sprJump = Sprite.load("NemesisCommandoJump", path.."Jump", 1, 3, 5)
local sprWalk = Sprite.load("NemesisCommandoWalk", path.."Walk", 8, 2, 5)
local sprClimb = Sprite.load("NemesisCommandoClimb", path.."Climb", 2, 4, 6)
local sprShoot1 = Sprite.load("NemesisCommandoShoot1", path.."Shoot1", 4, 6, 34)
local sprShoot2_1 = Sprite.load("NemesisCommandoShoot2_1", path.."Shoot2_1", 5, 6, 11)
local sprShoot2_2 = Sprite.load("NemesisCommandoShoot2_2", path.."Shoot2_2", 4, 16, 9)
local sprShoot3 = Sprite.load("NemesisCommandoShoot3", path.."Shoot3", 9, 6, 6)
local sprShoot4 = Sprite.load("NemesisCommandoShoot4B", path.."Shoot4B", 15, 19, 7)
local sprDeath = Sprite.load("NemesisCommandoDeath", path.."Death", 5, 14, 3)
--local sprPortrait = Sprite.load("NemesisCommandoPortrait", path.."Portrait", 1, 119, 119)
local sShoot1 = Sound.load("NemesisCommandoShoot1", path.."Shoot1")
local sShoot2 = Sound.load("NemesisCommandoShoot2", path.."Shoot2")

obj.NemesisCommando = Object.base("BossClassic", "NemesisCommando")
obj.NemesisCommando.sprite = sprIdle


obj.NemesisSlash = Object.new("NemesisSlash")
obj.NemesisSlash.sprite = sprShoot2_2
obj.NemesisSlash.depth = -8
obj.NemesisSlash:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.life = 80
	selfData.direction = 0
	selfData.speed = 4
	selfData.team = "player"
	selfData.hitList = {}
	self.spriteSpeed = 0.2
	self.yscale = 1.25
end)
obj.NemesisSlash:addCallback("step", function(self)
	local selfData = self:getData()
	if selfData.life > 0 then
		selfData.life = selfData.life - 1
		self.x = self.x + selfData.direction * selfData.speed
		
		self.yscale = self.yscale - 0.0085
		self.xscale = selfData.direction
		
		--if self:collidesMap(self.x + selfData.direction, self.y) then
		--	selfData.life = 0
		--end
		self.alpha = selfData.life * 0.1
		
		local xr, yr = 10, 50
		if selfData.parent and selfData.parent:isValid() then
			for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - xr, self.y - yr, self.x + xr, self.y + yr)) do
				if actor:get("team") ~= selfData.team and not selfData.hitList[actor] then
					if actor:collidesWith(self, actor.x, actor.y) then
						selfData.hitList[actor] = true
						local b = selfData.parent:fireBullet(actor.x + (selfData.direction * -1), actor.y, actor:getFacingDirection(), 2, 1.8, spr.Sparks9r)
						b:set("specific_target", actor.id)
						b:set("bleed", 1)
					end
				end
			end
		end
	else
		self:destroy()
	end
end)

NPC.setSkill(obj.NemesisCommando, 1, 25, 10, sprShoot1, 0.3, nil, function(actor, relevantFrame)
	if relevantFrame == 1 then
		local direction = actor:getFacingDirection()
		sShoot1:play(0.9 + math.random() * 0.2)
		local bullet = actor:fireBullet(actor.x + 2 * actor.xscale, actor.y - 3, direction, 25, 2.3, spr.Sparks9r, DAMAGER_BULLET_PIERCE)
		bullet:set("bleed", bullet:get("bleed") + 0.2)
	end
end)

NPC.setSkill(obj.NemesisCommando, 2, 600, 60 * 4, sprShoot2_1, 0.25, nil, function(actor, relevantFrame)
	if relevantFrame == 1 then
		sShoot2:play(0.9 + math.random() * 0.2)
		local slash = obj.NemesisSlash:create(actor.x + actor.xscale * 3, actor.y + 6)
		slash:getData().direction = actor.xscale
		slash:getData().parent = actor
		slash:getData().team = actor:get("team")
	end
end)

NPC.setSkill(obj.NemesisCommando, 3, 1000, 60 * 5, sprShoot3, 0.25, nil, function(actor, relevantFrame)
	actor:set("pHspeed", 2.6 * actor.xscale)
end)

NPC.setSkill(obj.NemesisCommando, 4, 400, 60 * 6, sprShoot4, 0.3, nil, function(actor, relevantFrame)
	if relevantFrame == 2 or relevantFrame == 4 or relevantFrame == 6 or relevantFrame == 8 or relevantFrame == 10 or relevantFrame == 12 then
		local direction = actor:getFacingDirection()
		sfx.Bullet3:play()
		actor:fireBullet(actor.x + 2 * actor.xscale, actor.y - 3, direction, 400, 0.8, spr.Sparks1)
	end
end)

local preStepCall = function()
	for _, self in ipairs( obj.NemesisCommando:findAll()) do
		if self:getData().jump and self:get("can_jump") == 1 then
			self:set("moveUp", 1)
			self:getData().jump = nil
		end
	end
end

obj.NemesisCommando:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = spr.PMask
	selfAc.name = "Nemesis Commando"
	selfAc.name2 = "Lone Echo"
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
	self:getData().isNemesis = "Commando"
	self:getData().noFallDeath = true
	
	tcallback.register("preStep", preStepCall)
end)

obj.NemesisCommando:addCallback("step", function(self)
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

obj.NemesisCommando:addCallback("destroy", function(self)
	tcallback.unregister("preStep", preStepCall)
end)