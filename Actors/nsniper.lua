local path = "Survivors/Sniper/Skins/Nemesis/"

local efColor = Color.fromHex(0xFFFF5E)
local efColor2 = Color.fromHex(0xE57E24)

local vdescription = "Send SPOT to distract the most dangerous enemy nearby for 3 seconds, shocking it for 4x100% damage."
local vdescriptionScepter = "Send SPOT to distract the most dangerous enemy nearby for 6 seconds, shocking it for 8x100% damage."

local sprIdle = Sprite.load("NemesisSniperIdle", path.."Idle", 1, 4, 5)
local sprJump = Sprite.load("NemesisSniperJump", path.."Jump", 1, 4, 5)
local sprWalk = Sprite.load("NemesisSniperWalk", path.."Walk", 8, 6, 5)
local sprClimb_1 = Sprite.load("NemesisSniperClimbA", path.."Climb_1", 2, 5, 6)
local sprClimb_2 = Sprite.load("NemesisSniperClimbB", path.."Climb_2", 2, 5, 6)
local sprShoot1_1 = Sprite.load("NemesisSniperShoot1A", path.."Shoot1_1", 6, 6, 10)
local sprShoot1_2 = Sprite.load("NemesisSniperShoot1B", path.."Shoot1_2", 8, 6, 10)
local sprShoot1_3 = Sprite.load("NemesisSniperShoot1C", path.."Shoot1_3", 4, 7, 10)
local sprShoot2_1 = Sprite.load("NemesisSniperShoot2A", path.."Shoot2_1", 6, 38, 42)
local sprShoot2_2 = Sprite.load("NemesisSniperShoot2B", path.."Shoot2_2", 4, 7, 10)
local sprShoot3_1 = Sprite.load("NemesisSniperShoot3", path.."Shoot3", 12, 7, 15)
local sprDeath = Sprite.load("NemesisSniperDeath", path.."Death", 7, 14, 6)
local sprDroneIdle = Sprite.load("NemesisSniperDroneIdle", path.."DroneIdle", 2, 5, 10)
local sprDroneJump = Sprite.load("NemesisSniperDroneJump", path.."DroneJump", 1, 6, 10)
local sprDroneWalk = Sprite.load("NemesisSniperDroneWalk", path.."DroneWalk", 4, 6, 10)
local sprDroneMask = Sprite.load("NemesisSniperDroneMask", path.."DroneMask", 1, 4, 2)
local sprDroneSignal = Sprite.load("NemesisSniperDroneSignal", path.."DroneSignal", 4, 12, 20)
--local sprPortrait = Sprite.load("NemesisSniperPortrait", path.."Portrait", 1, 119, 119)
local sShoot1_1 = Sound.load("NemesisSniperShoot1_1", path.."Shoot1_1")
local sShoot1_2 = Sound.load("NemesisSniperShoot1_2", path.."Shoot1_2")
local sShoot2_1 = Sound.load("NemesisSniperShoot2_1", path.."Shoot2_1")
local sprSkills
callback.register("postLoad", function()
	sprSkills = Sprite.find("NemesisSniperSkills", "Starstorm") -- jank as hell
end)

obj.NemesisSniper = Object.base("BossClassic", "NemesisSniper")
obj.NemesisSniper.sprite = sprIdle

local jumpTime = 35

obj.NemesisSniperDrone = Object.new("NemesisSniperDrone")
obj.NemesisSniperDrone.depth = -7
obj.NemesisSniperDrone.sprite = sprDroneIdle
obj.NemesisSniperDrone:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.jumping = 0
	selfData.attackingTimer = 0
	selfData.gravity = 0.26
	selfData.yacc = 0
	selfData.xspeed = 1
	self.spriteSpeed = 0.02
	self.mask = sprDroneMask
end)
obj.NemesisSniperDrone:addCallback("step", function(self)
	local selfData = self:getData()
	local parent = selfData.parent
	
	if parent and parent:isValid() then
		selfData.xspeed = parent:get("pHmax") + 0.1
		if selfData.attacking then
			if selfData.attacking:isValid() then -- it's the target instance :)
				local target = selfData.attacking
				
				local targetTeam = selfData.attacking:get("team")
				local damage = 1
				if targetTeam and targetTeam == "player" then
					target:applyBuff(buff.exposed or buff.slow, 20)
					damage = 0.05
				end
				
				if selfData.attackingTimer % 60 == 0 then
					local lightning = obj.ChainLightning:create(self.x, self.y + 10)
					lightning:set("parent", parent.id)
					lightning:set("damage", math.ceil(parent:get("damage") * damage))
					lightning:set("bounce", 3)
				end
				
				if selfData.attackingTimer > 0 then
					selfData.attackingTimer = selfData.attackingTimer - 1
				else
					selfData.attacking = nil
					for _, poi in ipairs(obj.POI:findMatching("parent", self.id)) do
						poi:destroy()
					end
					
					if isa(parent, "PlayerInstance") then
						local title, desc, sindex = "SPOT: CONDUIT", vdescription, 3
						if parent:get("scepter") > 0 then
							title = "SPOT: OUTBURST"
							desc = vdescriptionScepter
							sindex = 5
						end
						parent:setSkill(4,
						title,
						desc,
						sprSkills, sindex, 12 * 60)
						parent:getData().correctVindex = sindex
						parent:activateSkillCooldown(4)
					end
				end
				
				if selfData.attackingTimer > 100 and #obj.POI:findMatching("parent", self.id) == 0 then
					obj.POI:create(self.x, self.y):set("parent", self.id)
				end
				--target:applyBuff(buff.noteam, 10)
				
				local free
				if self:collidesMap(self.x, self.y) then
					self.y = self.y - 1
					selfData.yacc = 0
				elseif not self:collidesMap(self.x, self.y + 1) then
					selfData.yacc = selfData.yacc + selfData.gravity
					self.sprite = sprDroneJump
					free = true
				elseif selfData.yacc > 0 then
					selfData.yacc = 0
				end
				
				if selfData.yacc ~= 0 then
					local sign = math.sign(selfData.yacc)
					for i = 1, math.floor(math.abs(selfData.yacc * 10)) do
						if self:collidesMap(self.x, self.y + 0.1 * sign) then
							break
						else
							self.y = self.y + 0.1 * sign
						end
					end
				end
			
				if target.x > self.x then
					self.xscale = 1
				else
					self.xscale = -1
				end
				
				local sign
				if target.x > self.x + 20 then
					sign = 1
				elseif target.x < self.x - 20 then
					sign = -1
				end
				
				if sign then
					if self:collidesMap(self.x + selfData.xspeed * 2 * sign, self.y) then
						if not free then
							selfData.yacc = -3
						end
					else
						self.x = self.x + selfData.xspeed * sign
						if not self:collidesMap(self.x + selfData.xspeed * 2 * sign, self.y + 18) and not free then
							selfData.yacc = -3
						end
					end
					if not free then
						self.sprite = sprDroneWalk
						self.spriteSpeed = 0.2 * selfData.xspeed
					end
				elseif not free then
					self.sprite = sprDroneIdle
					self.spriteSpeed = 0.02
				end
			else
				local found = false
				for _, actor in ipairs(pobj.actors:findAllRectangle(self.x - 50, self.y - 25, self.x + 50, self.y + 25)) do
					if actor:get("team") and actor:get("team") ~= parent:get("team") then
						selfData.attacking = actor
						found = true
						break
					end
				end
				if not found then
					selfData.attacking = nil
					for _, poi in ipairs(obj.POI:findMatching("parent", self.id)) do
						poi:destroy()
					end
					
					if isa(parent, "PlayerInstance") then
						local title, desc, sindex = "SPOT: CONDUIT", vdescription, 3
						if parent:get("scepter") > 0 then
							title = "SPOT: OUTBURST"
							desc = vdescriptionScepter
							sindex = 5
						end
						parent:setSkill(4,
						title,
						desc,
						sprSkills, sindex, 12 * 60)
						parent:getData().correctVindex = sindex
						parent:activateSkillCooldown(4)
					end
				end
			end
		else
			if selfData.jumping > 0 then
				selfData.jumping = selfData.jumping - 1
				
				self.sprite = sprDroneJump
				
				local tx, ty = selfData.jumpingTargetx, selfData.jumpingTargety
				if selfData.jumpingTarget:isValid() then
					tx = selfData.jumpingTarget.x
					ty = selfData.jumpingTarget.y
				end
				
				local xdis = tx - selfData.ogx
				local xstep = xdis / jumpTime
				
				local positiveTime = (jumpTime - selfData.jumping)
				
				local ydif = ty - selfData.yy
				
				self.x = selfData.ogx + xstep * positiveTime
				selfData.yy = math.approach(selfData.yy, ty, (ydif * 0.2) + 0.5)
				
				local yy = math.pi * 1 * (positiveTime / jumpTime)
				self.y = selfData.yy + math.sin(yy) * -50
				
				if selfData.jumpToDestroy then
					if selfData.jumping == 0 or self:collidesWith(parent, self.x, self.y) then
						self:destroy()
					end
				elseif selfData.jumpToAttack and selfData.jumping == 0 then
					selfData.attacking = selfData.jumpToAttack
					selfData.attackingTimer = 60 * 3 * (1 + parent:get("scepter"))
					selfData.jumpToAttack = nil
				end
			else
				if parent:get("activity") == 30 then
					selfData.jumping = jumpTime
					selfData.ogx = self.x
					selfData.yy = self.y
					selfData.jumpingTarget = parent
					selfData.jumpingTargetx = parent.x
					selfData.jumpingTargety = parent.y
					
					selfData.jumpToDestroy = true
				else
					local dis = distance(self.x, self.y, parent.x, parent.y)
					
					if dis > 300 then
						selfData.jumping = jumpTime					
						selfData.ogx = self.x
						selfData.yy = self.y
						selfData.jumpingTarget = parent
						selfData.jumpingTargetx = parent.x
						selfData.jumpingTargety = parent.y
					end
				end
				
				local free
				if self:collidesMap(self.x, self.y) then
					self.y = self.y - 1
					selfData.yacc = 0
				elseif not self:collidesMap(self.x, self.y + 1) then
					selfData.yacc = selfData.yacc + selfData.gravity
					self.sprite = sprDroneJump
					free = true
				elseif selfData.yacc > 0 then
					selfData.yacc = 0
				end
				
				if selfData.yacc ~= 0 then
					local sign = math.sign(selfData.yacc)
					for i = 1, math.floor(math.abs(selfData.yacc * 10)) do
						if self:collidesMap(self.x, self.y + 0.1 * sign) then
							break
						else
							self.y = self.y + 0.1 * sign
						end
					end
				end
			
				if parent.x > self.x then
					self.xscale = 1
				else
					self.xscale = -1
				end
				
				local sign
				if parent.x > self.x + 50 then
					sign = 1
				elseif parent.x < self.x - 50 then
					sign = -1
				end
				
				if sign then
					if self:collidesMap(self.x + selfData.xspeed * 2 * sign, self.y) then
						if not free then
							selfData.yacc = -3
						end
					else
						self.x = self.x + selfData.xspeed * sign
						if not self:collidesMap(self.x + selfData.xspeed * 2 * sign, self.y + 18) and not free then
							selfData.yacc = -3
						end
					end
					if not free then
						self.sprite = sprDroneWalk
						self.spriteSpeed = 0.2 * selfData.xspeed
					end
				elseif not free then
					self.sprite = sprDroneIdle
					self.spriteSpeed = 0.02
				end
			end
		end
	end
end)
obj.NemesisSniperDrone:addCallback("destroy", function(self)
	local parent = self:getData().parent
		
	if parent and parent:isValid() then
		parent:setAnimation("climb", sprClimb_2)
		if parent:get("activity") == 30 then
			parent.sprite = sprClimb_2
		end
	end
end)
obj.NemesisSniperDrone:addCallback("draw", function(self)
	local selfData = self:getData()
	
	if selfData.attacking and selfData.attacking:isValid() then
		graphics.drawImage{
			image = sprDroneSignal,
			x = self.x,
			y = self.y,
			subimage = (1 + (global.timer % 30) * 0.12)
		}
		--[[local target = selfData.attacking
		
		local alpha = math.sin(global.timer * 0.1)
		
		local ystart = global.timer % target.sprite.height * target.yscale
		local yend = math.min(4, (target.sprite.height * target.yscale) - ystart)
		--print(ystart, ystart + 4, target.sprite.height * target.yscale)
		graphics.drawImage{
			image = target.sprite,
			x = target.x + target.sprite.xorigin * target.xscale * -1,
			y = target.y + ystart + target.sprite.yorigin * target.yscale * -1,
			subimage = target.subimage,
			solidColor = Color.YELLOW,
			alpha = 0.7 + alpha * 0.1,
			angle = target.angle,
			xscale = target.xscale,
			yscale = target.yscale,
			region = {0, ystart, target.sprite.width, yend}
		}]]
	end
end)

NPC.setSkill(obj.NemesisSniper, 1, 400, 35, sprShoot1_1, 0.2, nil, function(actor, relevantFrame)
	if relevantFrame == 1 then
		sShoot1_1:play(1 + math.random() * 0.2)
		local bullet = actor:fireBullet(actor.x, actor.y + 3, actor:getFacingDirection(), 500, 1.75, nil)
		addBulletTrailLine(bullet, efColor, 1.5, 45, false, true)
		
		actor:getData().gunheat = math.min(actor:getData().gunheat + 15, 100)
	end
end)

NPC.setSkill(obj.NemesisSniper, 2, 600, 60 * 5, sprShoot2_1, 0.2, function(actor)
	if actor:getData().gunheat <= 0 then
		actor.sprite = sprIdle
		actor.subimage = actor.sprite.frames
	end
end, function(actor, relevantFrame)
	if relevantFrame == 1 then
		sShoot2_1:play(0.9 + math.random() * 0.2)
		local damageMult = actor:getData().gunheat / 100
		
		local bullet = actor:fireBullet(actor.x, actor.y + 3, actor:getFacingDirection(), 2000, 14 * damageMult, nil, DAMAGER_BULLET_PIERCE)
		addBulletTrailLine(bullet, efColor2, 2, 70, true, true)
		
		actor:getData().gunrefresh = 50
	end
end)

NPC.setSkill(obj.NemesisSniper, 3, 1000, 60 * 8, sprShoot3_1, 0.25, nil, function(actor, relevantFrame)
	actor:set("pHspeed", actor:get("pHmax") * actor.xscale * -3)
end)

NPC.setSkill(obj.NemesisSniper, 4, 400, 60 * 18, nil, 0.3, function(actor)
	local drone, lookForEnemy = nil, true
	if actor:getData().childDrone:isValid() then
		drone = actor:getData().childDrone
		
		--[[if drone:getData().attacking or drone:getData().jumpToAttack and drone:getData().jumping > 0 then
			drone:getData().jumpToAttack = nil
			drone:getData().attacking = nil
			drone:getData().jumping = 0
			lookForEnemy = false
			
			for _, poi in ipairs(obj.POI:findMatching("parent", drone.id)) do
				poi:destroy()
			end
		end]] -- No cancelling
	else
		drone = obj.NemesisSniperDrone:create(actor.x, actor.y)
		drone:getData().parent = actor
		actor:getData().childDrone = drone
		actor:setAnimation("climb", sprClimb_1)
		if actor:get("activity") == 30 then
			actor.sprite = sprClimb_1
		end
	end
	
	if lookForEnemy then
		local priorityEnemy = {instance = nil, damage = nil}
		for _, actor2 in ipairs(pobj.actors:findAll()) do
			if actor2:get("team") and actor2:get("team") ~= actor:get("team") then
				if actor2.x > actor.x - 300 and actor2.x < actor.x + 300 and actor2.y > actor.y - 150 and actor2.y < actor.y + 150 then
					if not priorityEnemy.instance or actor2:get("damage") > priorityEnemy.damage then
						priorityEnemy.instance = actor2
						priorityEnemy.damage = actor2:get("damage")
					end
				end
			end
		end
		
		if priorityEnemy.instance then
			drone:getData().jumping = jumpTime
			drone:getData().jumpToAttack = priorityEnemy.instance
			drone:getData().ogx = drone.x
			drone:getData().yy = drone.y
			drone:getData().jumpingTarget = priorityEnemy.instance
			drone:getData().jumpingTargetx = priorityEnemy.instance.x
			drone:getData().jumpingTargety = priorityEnemy.instance.y
		end
	end
end, nil)

local preStepCall = function()
	for _, self in ipairs( obj.NemesisSniper:findAll()) do
		if self:getData().jump and self:get("can_jump") == 1 then
			self:set("moveUp", 1)
			self:getData().jump = nil
		end
	end
end

obj.NemesisSniper:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = spr.PMask
	selfAc.name = "Nemesis Sniper"
	selfAc.name2 = "Specialized Agent"
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
	self:getData().isNemesis = "Sniper"
	self:getData().noFallDeath = true
	
	self:getData().gunheat = 0
	self:getData().gunrefresh = 0
	
	local drone = obj.NemesisSniperDrone:create(self.x, self.y)
	drone:getData().parent = self
	self:getData().childDrone = drone
	self:setAnimation("climb", sprClimb_1)
	
	tcallback.register("preStep", preStepCall)
end)

obj.NemesisSniper:addCallback("step", function(self)
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
	
	
	
	
	if not selfData.childDrone:isValid() then
		if selfAc.activity ~= 30 then
			local drone = obj.NemesisSniperDrone:create(self.x, self.y)
			drone:getData().parent = self
			self:getData().childDrone = drone
			self:setAnimation("climb", sprClimb_1)
		end
	end
	
	if selfData.gunrefresh > 0 then
		local downValue = math.min(selfData.gunrefresh / 40, 1)
		selfData.gunheat = math.max(selfData.gunheat - 2 * downValue, 0)
		selfData.gunrefresh = selfData.gunrefresh - 1
	end
	if selfData.gunheat > 0 then
		if selfData.gunoverheat then
			selfData.gunheat = selfData.gunheat - 0.3
		else
			selfData.gunheat = selfData.gunheat - 0.15
		end
		
		if #obj.CustomBar:findMatching("parent", self.id) == 0 then
			local bar = obj.CustomBar:create(self.x, self.y)
			bar:set("parent", self.id)
			bar:set("maxtime", 100)
			bar:set("time", 100)
			bar:set("barColor", efColor.gml)
			bar:set("charge", 1)
			bar:getData().isSniperHeat = true
			bar.subimage = 5
		else
			for _, bar in ipairs(obj.CustomBar:findMatching("parent", self.id)) do
				if bar:getData().isSniperHeat then
					bar:set("time", math.max(100 - self:getData().gunheat, 0))
					if selfData.gunoverheat then
						bar:set("barColor", efColor2.gml)
					end
				end
			end
		end
	else
		if selfData.gunoverheat then
			selfData.gunoverheat = false
		end
		for _, bar in ipairs(obj.CustomBar:findMatching("parent", self.id)) do
			if bar:getData().isSniperHeat then
				bar:destroy()
			end
		end
	end
end)

obj.NemesisSniper:addCallback("destroy", function(self)
	local selfData = self:getData()
	for _, bar in ipairs(obj.CustomBar:findMatching("parent", self.id)) do
		if bar:getData().isSniperHeat then
			bar:destroy()
		end
	end
	if selfData.childDrone:isValid() then
		selfData.childDrone:destroy()
	end
	tcallback.unregister("preStep", preStepCall)
end)