local path = "Survivors/HAN-D/Skins/Nemesis/"

local sprIdle = Sprite.load("NemJanitorIdleA", path.."Idle_1", 1, 11, 19)
local sprJump = Sprite.load("NemJanitorJumpA", path.."Jump_1", 1, 8, 19)
local sprWalk = Sprite.load("NemJanitorWalkA", path.."Walk_1", 8, 25, 16)
local sprClimb = Sprite.load("NemJanitorClimbA", path.."Climb_1", 2, 9, 16)
local sprShoot1 = Sprite.load("NemJanitorShoot1A", path.."Shoot1_1", 8, 14, 16)
local sprShoot4 = Sprite.load("NemJanitorShoot4A", path.."Shoot4_1", 20, 50, 29)
local sprDeath = Sprite.load("NemJanitorDeathB", path.."Death_2", 7, 10, 34)

local sShoot1 = Sound.load("NemJanitorShoot1", path.."Shoot1")
local sShoot4 = Sound.load("NemJanitorShoot4", path.."Shoot4")

--local sprPortrait = Sprite.load("NemesisEngineerPortrait", path.."Portrait", 1, 119, 119)

obj.NemesisEngineer = Object.base("BossClassic", "NemesisEngineer")
obj.NemesisEngineer.sprite = sprIdle

NPC.setSkill(obj.NemesisEngineer, 1, 50, 40, sprShoot1, 0.22, nil, function(actor, relevantFrame)
	if relevantFrame == 4 then
		sShoot1:play(0.9 + math.random() * 0.2, 0.9)
		actor:fireExplosion(actor.x + 20 * actor.xscale, actor.y, 28 / 19, 15 / 4, 1.2)
	end
end)

--[[NPC.setSkill(obj.NemesisEngineer, 2, 400, 60 * 7, nil, 0.25, function(actor)
	obj.JanitorBaby:create(actor.x, actor.y):set("parent", actor.id):set("state", 1)
end)]]

NPC.setSkill(obj.NemesisEngineer, 3, 200, 60 * 8, nil, 0.25, function(actor)
	--actor:applyBuff(buff.slowStrength, 240)
	if not actor:getData().gaugeChild or not actor:getData().gaugeChild:isValid() then
		actor:getData().gaugeChild = obj.NemJanitorGauge:create(actor.x, actor.y - 30)
		actor:getData().gaugeChild:getData().parent = actor
	end
end)

NPC.setSkill(obj.NemesisEngineer, 4, 100, 60 * 6, sprShoot4, 0.25, nil, function(actor, relevantFrame)
	if relevantFrame == 6 then
		sShoot4:play(0.9 + math.random() * 0.2, 0.9)
	end
	if relevantFrame >= 8 and relevantFrame <= 19 then
		local bullet = actor:fireExplosion(actor.x, actor.y, 28 / 19, 15 / 4, 0.75)
		par.Spark:burst("middle", actor.x - 15, actor.y, 1)
		par.Spark:burst("middle", actor.x + 15, actor.y, 1)
	end
end)

--[[NPC.setSkill(obj.NemesisEngineer, 4, 400, 60 * 6, sprShoot4, 0.3, nil, function(actor, relevantFrame)
	if relevantFrame == 6 then
		sfx.HuntressShoot1:play(0.7 + math.random() * 0.2)
		local b = obj.HuntressBolt2:create(actor.x + 5 * actor.xscale, actor.y)
		b:set("parent", actor.id)
		b:set("direction", actor:getFacingDirection())
		local t = -4
		if obj.P:findNearest(b.x, b.y) then t = obj.P:findNearest(b.x, b.y).id end
		b:set("target", t)
	end
end)]]

local preStepCall = function()
	for _, self in ipairs( obj.NemesisEngineer:findAll()) do
		if self:getData().jump and self:get("can_jump") == 1 then
			self:set("moveUp", 1)
			self:getData().jump = nil
		end
	end
end

obj.NemesisEngineer:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = spr.PMask
	selfAc.name = "Nemesis HAN-D"
	selfAc.name2 = "Rampant Horticulturist"
	selfAc.hp_regen = 0.01 * Difficulty.getScaling("hp")
	selfAc.damage = 14 * Difficulty.getScaling("damage")
	selfAc.maxhp = 1000 * getVestigeScaling("hp")
	selfAc.armor = 0
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 1.3
	selfAc.attack_speed = 1
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
	self:getData().isNemesis = "Engineer"
	self:getData().noFallDeath = true
	
	tcallback.register("preStep", preStepCall)
end)

obj.NemesisEngineer:addCallback("step", function(self)
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

obj.NemesisEngineer:addCallback("draw", function(actor)
	if actor:getData().gaugeChild then
		graphics.setBlendMode("additive")
		graphics.drawImage{
			image = actor.sprite,
			subimage = actor.subimage,
			x = actor.x,
			y = actor.y,
			color = Color.RED,
			alpha = 0.8,
			angle = actor.angle,
			xscale = actor.xscale + math.random(0, 10) * 0.02,
			yscale = actor.yscale + math.random(0, 10) * 0.02
		}
		graphics.setBlendMode("normal")
	end
end)

obj.NemesisEngineer:addCallback("destroy", function(self)
	tcallback.unregister("preStep", preStepCall)
end)