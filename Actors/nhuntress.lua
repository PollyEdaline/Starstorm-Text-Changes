local path = "Survivors/Huntress/Skins/Nemesis/"

local sprIdle = Sprite.load("NemesisHuntressIdle", path.."Idle", 1, 7, 5)
local sprIdleHalf = Sprite.load("NemesisHuntressIdleHalf", path.."IdleHalf", 1, 4, 5)
local sprJump = Sprite.load("NemesisHuntressJump", path.."Jump", 1, 7, 6)
local sprJumpHalf = Sprite.load("NemesisHuntressJumpHalf", path.."JumpHalf", 1, 3, 5)
local sprWalk = Sprite.load("NemesisHuntressWalk", path.."Walk", 8, 5, 5)
local sprWalkHalf = Sprite.load("NemesisHuntressWalkHalf", path.."WalkHalf", 8, 5, 5)
local sprClimb = Sprite.load("NemesisHuntressClimb", path.."Climb", 2, 3, 6)
local sprShoot1 = Sprite.load("NemesisHuntressShoot1", path.."Shoot1", 9, 7, 7)
local sprShoot2 = Sprite.load("NemesisHuntressShoot2", path.."Shoot2", 9, 11, 7)
local sprShoot4 = Sprite.load("NemesisHuntressShoot4", path.."Shoot4", 10, 15, 12)
local sprShoot5 = Sprite.load("NemesisHuntressShoot5", path.."Shoot5", 10, 15, 12)
local sprDeath = Sprite.load("NemesisHuntressDeath", path.."Death", 10, 14, 3)

local sprCape = Sprite.load("NemesisHuntressCape", path.."Cape", 4, 7, 5)
--local sprPortrait = Sprite.load("NemesisHuntressPortrait", path.."Portrait", 1, 119, 119)
--local sShoot1 = Sound.load("NemesisHuntressSlash", path.."Shoot1")

obj.NemesisHuntress = Object.base("BossClassic", "NemesisHuntress")
obj.NemesisHuntress.sprite = sprIdle

local objNHuntressHatchet = Object.new("NHuntressHatchet")

objNHuntressHatchet.sprite = Sprite.load("NemesisHuntressHatchet", path.."Hatchet", 1, 7, 12)
objNHuntressHatchet.depth = 0.1

objNHuntressHatchet:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self:getData().life = 200
	self.spriteSpeed = 0.25
	self:getData().hitEnemies = {}
	selfAc.speed = 4
end)
objNHuntressHatchet:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local enemy
	
	local parent = self:getData().parent
	
	if parent and parent:isValid() and parent:get("team") ~= "enemy" then
		enemy = nearestMatchingOp(self, pobj.actors, "team", "~=", parent:get("team"))
	else
		enemy = obj.P:findNearest(self.x, self.y)
	end
	
	if not self:getData().dir then
		self:getData().dir = true
		
		if enemy and enemy:isValid() then
			local yy = enemy.y
			if enemy:isClassic() then
				yy = enemy.y - enemy.sprite.yorigin + enemy.sprite.height - 6
			end
			selfAc.direction = posToAngle(self.x, self.y, enemy.x, yy)
		end
	end
	
	if enemy and parent and parent:isValid() then
		if self:collidesWith(enemy, self.x, self.y) and enemy:get("team") ~= parent:get("team") and not contains(self:getData().hitEnemies, enemy.id) then
			if global.quality > 1 then
				par.Spark:burst("middle", self.x, self.y, 2)
			end
			sfx.Reflect:play(0.6 + math.random() * 0.2)
			table.insert(self:getData().hitEnemies, enemy.id)
			for i = 0, parent:get("sp") do
				damage = parent:fireExplosion(self.x, self.y, 17 / 19, 17 / 4, 6, nil, spr.Sparks2)
				misc.shakeScreen(3)
				if i ~= 0 then
					damage:set("climb", i * 8)
				end
			end
		end
	end
	
	if self:getData().invertSpin then
		self.angle = self.angle + 10
	else
		self.angle = self.angle - 10
	end
	
	if global.quality > 1 and global.timer % 2 == 0 then
		local t = obj.EfTrail:create(self.x, self.y)
		t.sprite = self.sprite
		t.angle = self.angle
	end
	
	if self:getData().life == 0 or self:getData().hitEnemies and #self:getData().hitEnemies >= 6 then
		if global.quality > 1 then
			par.Spark:burst("middle", self.x, self.y, 4)
		end
		self:destroy()
	else
		self:getData().life = self:getData().life - 1
	end
end)
local objNHuntressArrow = Object.new("NHuntressArrow")
objNHuntressArrow.sprite = spr.HuntressBolt1
objNHuntressArrow:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self:getData().life = 120
	self.spriteSpeed = 0.25
	selfAc.speed = 7
	self:getData().doTrail = false
	self:getData().climb = 0
end)
objNHuntressArrow:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local enemy = pobj.actors:findNearest(self.x, self.y)
	
	local parent = self:getData().parent
	
	if enemy and enemy:isValid() and parent and parent:isValid() then
		if self:collidesWith(enemy, self.x, self.y) and enemy:get("team") ~= parent:get("team") then
			self:getData().life = 0
			--for i = 0, parent:get("sp") do
				damage = parent:fireExplosion(enemy.x, enemy.y, 5 / 19, 5 / 4, 1.4, nil, spr.Sparks2)
				damage:set("climb", self:getData().climb * 9)
				--if i ~= 0 then
				--	damage:set("climb", damage:get("climb") + i * 8)
				--end
			--end
		end
	end
	
	self.angle = selfAc.direction
	
	if self:getData().doTrail then
		if global.timer % 2 == 0 then
			local t = obj.EfTrail:create(self.x, self.y)
			t.sprite = self.sprite
			t.angle = self.angle
		end
	end
	
	if self:getData().targetAngle then
		self:set("direction", self:get("direction") + (angleDif(self:get("direction"), self:getData().targetAngle) * -0.0235))
	end
	
	if self:getData().life == 0 or self:collidesMap(self.x, self.y) then
		self:destroy()
	else
		self:getData().life = self:getData().life - 1
	end
end)

NPC.setSkill(obj.NemesisHuntress, 1, 500, 20, sprShoot1, 0.3, nil, function(actor, relevantFrame)
	if relevantFrame == 5 then
		sfx.HuntressShoot1:play(0.9 + math.random() * 0.2)
		local b = objNHuntressArrow:create(actor.x + 5 * actor.xscale, actor.y)
		b:getData().parent = actor
		b:set("speed", b:get("speed") + 1)
		b:set("direction", actor:getFacingDirection())
		b:getData().doTrail = true
		for i = -1, 1 do
			if i ~= 0 then
				local bullet = objNHuntressArrow:create(b.x, b.y + i * 2)
				bullet:getData().parent = actor
				bullet:set("direction", b:get("direction") + 3 * i * (b.xscale * -1))
				bullet:getData().skin_checked = true
				bullet:getData().targetAngle = b:get("direction") + 3 * i * b.xscale
				bullet:getData().doTrail = true
			end
		end
	end
end)

NPC.setSkill(obj.NemesisHuntress, 2, 600, 60 * 5, sprShoot2, 0.25, nil, function(actor, relevantFrame)
	if relevantFrame == 6 then
		local bullet = objNHuntressHatchet:create(actor.x, actor.y)
		bullet:getData().parent = actor
		bullet:set("direction", actor:getFacingDirection())
		sfx.HuntressShoot1:play(0.8 + math.random() * 0.2)
	end
end)

NPC.setSkill(obj.NemesisHuntress, 3, 1000, 60 * 5, nil, 0.25, function(actor, relevantFrame)
	obj.EfSparks:create(actor.x, actor.y).sprite = spr.Huntress1Shoot3
	local i = 0
	while not actor:collidesMap(actor.x + i * actor.xscale, actor.y) and i < 30 do
		i = i + 1
	end
	actor.x = actor.x + i * actor.xscale
	obj.EfSparks:create(actor.x, actor.y).sprite = spr.Huntress1Shoot3
	sfx.HuntressShoot3:play(0.9 + math.random() * 0.2)
end)

--[[NPC.setSkill(obj.NemesisHuntress, 4, 400, 60 * 6, sprShoot4, 0.3, nil, function(actor, relevantFrame)
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
	for _, self in ipairs( obj.NemesisHuntress:findAll()) do
		if self:getData().jump and self:get("can_jump") == 1 then
			self:set("moveUp", 1)
			self:getData().jump = nil
		end
	end
end

obj.NemesisHuntress:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = spr.PMask
	selfAc.name = "Nemesis Huntress"
	selfAc.name2 = "Cunning Stalker"
	selfAc.hp_regen = 0.01 * Difficulty.getScaling("hp")
	selfAc.damage = 14 * Difficulty.getScaling("damage")
	selfAc.maxhp = 1000 * getVestigeScaling("hp")
	selfAc.armor = 0
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 1.4
	selfAc.attack_speed = 0.6
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
	self:getData().isNemesis = "Huntress"
	self:getData().noFallDeath = true
	
	tcallback.register("preStep", preStepCall)
end)

obj.NemesisHuntress:addCallback("step", function(self)
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

obj.NemesisHuntress:addCallback("destroy", function(self)
	tcallback.unregister("preStep", preStepCall)
end)