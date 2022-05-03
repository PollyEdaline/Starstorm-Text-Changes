local path = "Survivors/Loader/Skins/Nemesis/"

local sprIdle = Sprite.load("NemesisLoaderIdle", path.."IdleFull", 1, 11, 8)
local sprJump = Sprite.load("NemesisLoaderJump", path.."JumpFull", 1, 10, 11)
local sprWalk = Sprite.load("NemesisLoaderWalk", path.."WalkFull", 8, 15, 10)
local sprClimb = Sprite.load("NemesisLoaderClimb", path.."ClimbFull", 2, 6, 13)
local sprShoot1_1 = Sprite.load("NemesisLoaderShoot1A", path.."Shoot1_1Full", 5, 20, 12)
local sprShoot1_2 = Sprite.load("NemesisLoaderShoot1B", path.."Shoot1_2Full", 4, 18, 12)
local sprShoot1_3 = Sprite.load("NemesisLoaderShoot1C", path.."Shoot1_3Full", 9, 18, 16)
local sprShoot3 = Sprite.load("NemesisLoaderShoot3", path.."Shoot3", 10, 12, 9)
local sprShoot4 = Sprite.load("NemesisLoaderShoot4", path.."Shoot4", 7, 13, 11)
local sprDeath = Sprite.load("NemesisLoaderDeath", path.."DeathFull", 8, 15, 12)

local sShoot3 = Sound.load("NemesisLoaderShoot3", path.."Shoot3")
local sShoot3Grab = Sound.load("NemesisLoaderShoot3Grab", path.."Shoot3Grab")
local sShoot4 = Sound.load("NemesisLoaderShoot4", path.."Shoot4")

--local sprPortrait = Sprite.load("NemesisLoaderPortrait", path.."Portrait", 1, 119, 119)

obj.NemesisLoader = Object.base("BossClassic", "NemesisLoader")
obj.NemesisLoader.sprite = sprIdle

 
local sprFist = Sprite.load("NemesisLoaderFist", path.."Fist", 1, 0, 2)
local objNemLoaderRod = Object.new("NemLoaderRod")
objNemLoaderRod.depth = -1.1
objNemLoaderRod.sprite = sprFist
objNemLoaderRod:addCallback("create", function(self)
	local data = self:getData()
	data.team = "player"
	data.life = 30
	data.rate = 30
end)
objNemLoaderRod:addCallback("step", function(self)
	local data = self:getData()
	local selfAc = self:getAccessor()
	if data.stuck then
		selfAc.speed = 0
		if data.parent and data.parent:isValid() then
			if data.life % data.rate == 0 then
				if data.hit and data.hit:isValid() then
					data.parent:fireBullet(data.hit.x, data.hit.y, data.hit:getFacingDirection(), 2, 0.5, nil, DAMAGER_NO_PROC):set("specific_target", data.hit.id)
				end
				for _, actor in ipairs(pobj.actors:findAllLine(data.parent.x, data.parent.y, self.x, self.y)) do
					if actor:get("team") ~= data.team then
						if not data.hit or data.hit ~= actor then
							data.parent:fireBullet(actor.x, actor.y, actor:getFacingDirection(), 2, 0.5, nil, DAMAGER_NO_PROC):set("specific_target", actor.id)
						end
					end
				end
			end
		else
			self:destroy()
		end
		if data.hit and data.hit:isValid() then
			self.x = data.hit.x + data.xx
			self.y = data.hit.y + data.yy
		elseif data.hit then
			self:destroy()
		end
	else
		if self:collidesMap(self.x, self.y) then
			data.stuck = true
			data.life = 420
			selfAc.speed = 1
		else
			selfAc.speed = 10
			par.Spark:burst("middle", self.x, self.y, 1)
			local foundActors = pobj.actors:findAllLine(self.x, self.y, self.x + (data.life * 10) * self.xscale, self.y)
			local collidingActors = pobj.actors:findAllLine(self.x, self.y, self.x + 2 * self.xscale, self.y)
			for _, actor in ipairs(collidingActors) do
				if actor:get("team") ~= data.team then--not actor:getData().nemLGrapple then
					--[[local actors = {}
					for _, actor2 in ipairs(pobj.actors:findAllLine(self.x, self.y, self.x + (data.life / 10) * self.xscale, self.y)) do
						if actor2 ~= actor then
							table.insert(actors, actor2)
						end
					end]]
					--if #actors == 0 then
					data.lastActor = actor
					local nactors = {}
					for _, aactor in ipairs(foundActors) do
						if aactor:get("team") ~= data.team then
							table.insert(nactors, aactor)
						end
					end
					if #nactors == 1 then
						data.hit = actor
						data.stuck = true
						data.xx = self.x - actor.x
						data.yy = self.y - actor.y
						data.life = 420
						break
					elseif #nactors == 0 and data.lastActor and data.lastActor:isValid() then
						data.hit = data.lastActor
						data.stuck = true
						data.xx = self.x - data.lastActor.x
						data.yy = self.y - data.lastActor.y
						data.life = 420 -- edge case sucks
					end
				end
			end
			if #collidingActors == 0 and #foundActors == 0 and data.lastActor and data.lastActor:isValid() then
				data.hit = data.lastActor
				data.stuck = true
				data.xx = self.x - data.lastActor.x
				data.yy = self.y - data.lastActor.y
				data.life = 420 -- edge case sucks x2
			end
		end
	end
	if data.life > 0 then
		data.life = data.life - 1
	elseif self:isValid() then
		self:destroy()
	end
end)
objNemLoaderRod:addCallback("draw", function(self)
	local data = self:getData()
	if data.parent and data.parent:isValid() then
		graphics.alpha(1)
		graphics.color(Color.DARK_GRAY)
		graphics.line(self.x, self.y, data.parent.x, data.parent.y - 4, 1)
		if data.stuck then
			local color = data.color
			drawRodLightning(data.parent.x, data.parent.y - 4, self.x, self.y, nil, nil, color)
			drawRodLightning(data.parent.x, data.parent.y - 4, self.x, self.y, 4, nil, color)
		end
	end
end)

local grappleBlacklist = {
	[obj.GolemG] = true,
	[obj.Boar] = true,
	[obj.Ifrit] = true,
	[obj.WormBody] = true,
	[obj.WurmBody] = true,
	[obj.Turtle] = true,
}
if not global.rormlflag.ss_disable_enemies then
	grappleBlacklist[obj.SquallElver] = true
	grappleBlacklist[obj.TotemPart] = true
	grappleBlacklist[obj.Wyvern] = true
	grappleBlacklist[obj.WyvernHead] = true
	grappleBlacklist[obj.WyvernTail] = true
end

local objNemLoaderGrapple = Object.new("NemLoaderGrapple")
objNemLoaderGrapple.depth = -1.1
objNemLoaderGrapple.sprite = sprFist
objNemLoaderGrapple:addCallback("create", function(self)
	local data = self:getData()
	data.team = "player"
	data.life = 30
	data.grappleLife = 240
end)
objNemLoaderGrapple:addCallback("step", function(self)
	local data = self:getData()
	local selfAc = self:getAccessor()
	if data.stuck then
		selfAc.speed = 0
		if data.parent and data.parent:isValid() and (data.parent:get("activity") ~= 30 or not data.parent:collidesMap(data.parent.x, data.parent.y - 1)) then
			if data.hit and data.hit:isValid() then
				data.hit.x = self.x + data.xx
				data.hit.y = self.y + data.yy
				--data.hit.xscale = data.hit.xscale * math.sign(data.parent.xscale) * -1
				
				--[[local dis = distance(data.hit.x, data.hit.y, data.parent.x, data.parent.y)
				if dis > 20 then
					selfAc.speed = 7
					--local angle = posToAngle(data.hit.x, data.hit.y, data.parent.x, data.parent.y)
					selfAc.direction = posToAngle(data.hit.x, data.hit.y, data.parent.x, data.parent.y)
				else
					selfAc.speed = 0
				end]]
				if not data.hit:isBoss() then
					data.hit.subimage = 1
					if not isa(data.hit, "PlayerInstance") then
						data.hit:setAlarm(7, 80)
					end
					data.hit:set("activity", 52)
				end
				data.hit:set("pVspeed", data.parent:get("pVspeed"))
				local newx = math.approach(self.x, data.parent.x + data.targetx, 6)
				local newy = math.approach(self.y, data.parent.y - 4, 6)
				if data.parent:get("activity") ~= 30 or not data.hit:collidesMap(newx, newy) then
					self.x = newx
					self.y = newy
				end
			elseif data.hit then
				self:destroy()
			end
		else
			if data.hit and data.hit:isValid() then
				if not data.hit:isBoss() then
					data.hit:set("activity", 0)
				end
				data.hit:getData().nemLGrapple = nil
				for i = 1, 200 do
					if data.hit:collidesMap(data.hit.x, data.hit.y) then
						if not data.hit:collidesMap(data.hit.x, data.hit.y + 2) then
							data.hit.y = data.hit.y + 2
						elseif not data.hit:collidesMap(data.hit.x + 5, data.hit.y) then
							data.hit.x = data.hit.x + 5
						elseif not data.hit:collidesMap(data.hit.x - 5, data.hit.y) then
							data.hit.x = data.hit.x - 5
						else
							data.hit.y = data.hit.y - 1
						end
					else
						break
					end
				end
			end
			self:destroy()
		end
	else
		selfAc.speed = 10
		par.Spark:burst("middle", self.x, self.y, 1)
		if self:collidesMap(self.x, self.y) then
			data.life = 0
		else
			for _, actor in ipairs(pobj.actors:findAllLine(self.x, self.y, self.x + 4 * self.xscale,self.y)) do
				if actor:get("team") ~= data.team and not actor:getData().nemLGrapple and not grappleBlacklist[actor:getObject()]  then
					data.hit = actor
					data.stuck = true
					data.xx = actor.x - self.x 
					data.yy = actor.y - self.y
					data.life = data.grappleLife
					data.targetx = 20 * self.xscale
					actor:set("pVspeed", -2)
					actor:getData().nemLGrapple = true
					sShoot3Grab:play(0.9 + math.random() * 0.2)
					break
				end
			end
		end
	end
	if data.life > 0 then
		data.life = data.life - 1
	elseif self:isValid() then
			if data.hit and data.hit:isValid() then
				if not data.hit:isBoss() then
					data.hit:set("activity", 0)
				end
				data.hit:getData().nemLGrapple = nil
				for i = 1, 200 do
					if data.hit:collidesMap(data.hit.x, data.hit.y) then
						if not data.hit:collidesMap(data.hit.x, data.hit.y + 2) then
							data.hit.y = data.hit.y + 2
						elseif not data.hit:collidesMap(data.hit.x + 5, data.hit.y) then
							data.hit.x = data.hit.x + 5
						elseif not data.hit:collidesMap(data.hit.x - 5, data.hit.y) then
							data.hit.x = data.hit.x - 5
						else
							data.hit.y = data.hit.y - 1
						end
					else
						break
					end
				end
			end
		self:destroy()
	end
end)
objNemLoaderGrapple:addCallback("draw", function(self)
	local data = self:getData()
	if data.parent and data.parent:isValid() then
		graphics.alpha(1)
		graphics.color(Color.DARK_GRAY)
		graphics.line(self.x, self.y, data.parent.x, data.parent.y - 4, 1)
	end
end)

NPC.setSkill(obj.NemesisLoader, 1, 50, 30, nil, 0.2, function(actor)
	if actor:getData().hitStep == nil then
		actor.sprite = sprShoot1_1
	elseif actor:getData().hitStep == 1 then
		actor.sprite = sprShoot1_2
	elseif actor:getData().hitStep == 2 then
		actor.sprite = sprShoot1_3
	end
	actor:getData().hitStepLast = actor:getData().hitStep
	
	
	if actor:getData().hitStep then
		if actor:getData().hitStep == 2 then
			actor:getData().hitStep = nil
		else
			actor:getData().hitStep = 2
		end
	else
		actor:getData().hitStep = 1
	end
end, function(actor, relevantFrame)
	if actor:getData().hitStepLast == nil then
		actor.sprite = sprShoot1_1
		if relevantFrame == 4 then
			sfx.JanitorShoot1_2:play(1.1)
			actor:fireExplosion(actor.x + 10 * actor.xscale, actor.y, 26 / 19, 25 / 4, 1.2)
		end
	elseif actor:getData().hitStepLast == 1 then
		actor.sprite = sprShoot1_2
		if relevantFrame == 3 then
			sfx.JanitorShoot1_2:play(1.1)
			actor:fireExplosion(actor.x + 10 * actor.xscale, actor.y, 26 / 19, 25 / 4, 1.2)
		end
	elseif actor:getData().hitStepLast == 2 then
		actor.sprite = sprShoot1_3
		if relevantFrame == 4 then
			sfx.JanitorShoot4_2:play(1.5)
			actor:fireExplosion(actor.x + 10 * actor.xscale, actor.y, 26 / 19, 25 / 4, 2.4)
		end
	end
end)

NPC.setSkill(obj.NemesisLoader, 2, 12 * 60, 400, nil, 0.25, function(actor)
	actor:set("invincible", 3 * 60)
	sfx.BubbleShield:play(2.3)
end)

NPC.setSkill(obj.NemesisLoader, 3, 6 * 60, 500, sprShoot3, 0.25, nil, function(actor, relevantFrame)
	if relevantFrame == 1 then
		sShoot3:play(0.9 + math.random() * 0.2)
	elseif relevantFrame == 7 then
		local rod = objNemLoaderGrapple:create(actor.x, actor.y - 4)
		rod:set("direction", actor:getFacingDirection())
		rod.xscale = actor.xscale
		rod:getData().parent = actor
		rod:getData().team = actor:get("team")
		rod:getData().grappleLife = 25
	end
end)

NPC.setSkill(obj.NemesisLoader, 4, 11 * 60, 600, sprShoot4, 0.25, nil, function(actor, relevantFrame)
	if relevantFrame == 4 then
		local rod = objNemLoaderRod:create(actor.x, actor.y - 4)
		rod:set("direction", actor:getFacingDirection())
		rod.xscale = actor.xscale
		rod:getData().parent = actor
		rod:getData().team = actor:get("team")
		sShoot4:play(0.9 + math.random() * 0.2)
	end
end)


local preStepCall = function()
	for _, self in ipairs( obj.NemesisLoader:findAll()) do
		if self:getData().jump and self:get("can_jump") == 1 then
			self:set("moveUp", 1)
			self:getData().jump = nil
		end
	end
end

obj.NemesisLoader:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = spr.PMask
	selfAc.name = "Nemesis Loader"
	selfAc.name2 = "Hydraulic Behemoth"
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
	self:getData().isNemesis = "Loader"
	self:getData().noFallDeath = true
	
	tcallback.register("preStep", preStepCall)
end)

obj.NemesisLoader:addCallback("step", function(self)
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

obj.NemesisLoader:addCallback("draw", function(actor)
	if actor:get("invincible") > 0 then
		graphics.drawImage{actor.sprite, actor.x, actor.y, actor.subimage, angle = actor.angle, xscale = actor.xscale + math.random(0, 0.11), yscale = actor.yscale + math.random(0, 0.11), solidColour = Color.fromHex(0x4AFFFF), alpha = actor.alpha * 0.5}
	end
end)

obj.NemesisLoader:addCallback("destroy", function(actor)
	tcallback.unregister("preStep", preStepCall)
end)