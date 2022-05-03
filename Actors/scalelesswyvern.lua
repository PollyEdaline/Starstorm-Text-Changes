-- Thanks DeegerDill!

--======
local function bezier_Point_Find(t, p0x, p0y, p1x, p1y, p2x, p2y, p3x, p3y)

	--Lerp is a value from 0-1 to find on the line between p0 and p3
	--p1 and p2 are the control points

	--returns array (x,y)


	--Precalculated power math
	local tt  = t  * t;
	local ttt = tt * t;
	local u   = 1  - t; --Inverted
	local uu  = u  * u;
	local uuu = uu * u;

	--Calculate the point
	local px = uuu * p0x; --first term
	local py = uuu * p0y;
	px = px +  3 * uu * t * p1x; --second term
	py = py + 3 * uu * t * p1y;
	px = px + 3 * u * tt * p2x; --third term 
	py = py + 3 * u * tt * p2y;
	px = px + ttt * p3x; --fourth term
	py = py + ttt * p3y;

	--Pack into an array
	local PA = {}
		PA[0] = px
		PA[1] = py
	return PA;
end

local function nCoordinates(x1,y1,x2,y2,x3,y3,x4,y4)

	local nA = {}
		nA[0] = {x = x1, y = y1}
		nA[1] = {x = x2, y = y2}
		nA[2] = {x = x3, y = y3}
		nA[3] = {x = x4, y = y4}
	return nA;

end

local function turnTowards (dir1,dir2,ratio)

	local angdiff = (((((dir1 - dir2) % 360) + 540) % 360) - 180)
	local rDir = dir1
	rDir = rDir - (angdiff / ratio)
	return rDir
end
--======
--functions end heres

local stages = {}
table.insert(stages, stg.AncientValley)
table.insert(stages, stg.MagmaBarracks)
table.insert(stages, stg.TempleoftheElders)

local path = "Actors/Scaleless Wyvern/"

local sprMask = Sprite.load("WyvernMask", path.."Mask", 1, 22, 67)
local sprPalette = Sprite.load("WyvernPal", path.."palette", 1, 0, 0)
--local sprSpawn = Sprite.load("WyvernSpawn", path.."Spawn", 7, 94, 130)

--local sprLogBook = Sprite.load("WyvernLogBook", path.."LogBook", 6, 90, 20)
local sprImpact = Sprite.load("WyvernImpact", path.."impact", 6, 9, 12)

local normalSprites = {
	idle = Sprite.load("WyvernIdle", path.."Idle", 1, 111, 104),
	idleWing = Sprite.load("WyvernIdleWing", path.."idleWing", 1, 111, 104),
	walk = Sprite.load("WyvernWalk", path.."Walk", 12, 112, 104),
	walkWing = Sprite.load("WyvernWalkWing", path.."WalkWing", 12, 112, 104),
	fly = Sprite.load("WyvernFly", path.."flying", 6, 113, 168),
	flyPrep = Sprite.load("WyvernFlyPrep", path.."flyPrep", 5, 111, 170),
	flyPrepWing = Sprite.load("WyvernFlyPrepWing", path.."flyPrepWing", 5, 111, 170),
	flyWing = Sprite.load("WyvernFlyWing", path.."flyingWing", 6, 113, 168),
	head1 = Sprite.load("WyvernHeadDefault", path.."wyernHead", 1, 0, 14),
	head2 = Sprite.load("WyvernHeadShoot", path.."headShoot1", 13, 0, 16),
	neck = Sprite.load ("WyvernNeck", path.."wyverNeck", 3, 10, 18),
	tail = Sprite.load("WyvernTail", path.."wyvernTail", 3, 0, 9),
	death = Sprite.load("WyvernDeath", path.."Death", 11, 153, 64)
}

local eliteSprites = {
	[elt.Blazing] = {
		idle = Sprite.load("WyvernIdleBl", path.."Blazing/".."Idle", 1, 111, 104),
		idleWing = Sprite.load("WyvernIdleWingBl", path.."Blazing/".."idleWing", 1, 111, 104),
		walk = Sprite.load("WyvernWalkBl", path.."Blazing/".."Walk", 12, 112, 104),
		walkWing = Sprite.load("WyvernWalkWingBl", path.."Blazing/".."WalkWing", 12, 112, 104),
		fly = Sprite.load("WyvernFlyBl", path.."Blazing/".."flying", 6, 113, 168),
		flyPrep = Sprite.load("WyvernFlyPrepBl", path.."Blazing/".."flyPrep", 5, 111, 170),
		flyPrepWing = Sprite.load("WyvernFlyPrepWingBl", path.."Blazing/".."flyPrepWing", 5, 111, 170),
		flyWing = Sprite.load("WyvernFlyWingBl", path.."Blazing/".."flyingWing", 6, 113, 168),
		head1 = Sprite.load("WyvernHeadDefaultBl", path.."Blazing/".."wyernHead", 1, 0, 14),
		head2 = Sprite.load("WyvernHeadShootBl", path.."Blazing/".."headShoot1", 13, 0, 16),
		neck = Sprite.load ("WyvernNeckBl", path.."Blazing/".."wyverNeck", 3, 10, 18),
		tail = Sprite.load("WyvernTailBl", path.."Blazing/".."wyvernTail", 3, 0, 9),
		death = Sprite.load("WyvernDeathBl", path.."Blazing/".."Death", 11, 153, 64)
	}
}
callback.register("postLoad", function()
	eliteSprites[elt.Aeonian] = {
		idle = Sprite.load("WyvernIdleAe", path.."Aeonian/".."Idle", 1, 111, 104),
		idleWing = Sprite.load("WyvernIdleWingAe", path.."Aeonian/".."idleWing", 1, 111, 104),
		walk = Sprite.load("WyvernWalkAe", path.."Aeonian/".."Walk", 12, 112, 104),
		walkWing = Sprite.load("WyvernWalkWingAe", path.."Aeonian/".."WalkWing", 12, 112, 104),
		fly = Sprite.load("WyvernFlyAe", path.."Aeonian/".."flying", 6, 113, 168),
		flyPrep = Sprite.load("WyvernFlyPrepAe", path.."Aeonian/".."flyPrep", 5, 111, 170),
		flyPrepWing = Sprite.load("WyvernFlyPrepWingAe", path.."Aeonian/".."flyPrepWing", 5, 111, 170),
		flyWing = Sprite.load("WyvernFlyWingAe", path.."Aeonian/".."flyingWing", 6, 113, 168),
		head1 = Sprite.load("WyvernHeadDefaultAe", path.."Aeonian/".."wyernHead", 1, 0, 14),
		head2 = Sprite.load("WyvernHeadShootAe", path.."Aeonian/".."headShoot1", 13, 0, 16),
		neck = Sprite.load ("WyvernNeckAe", path.."Aeonian/".."wyverNeck", 3, 10, 18),
		tail = Sprite.load("WyvernTailAe", path.."Aeonian/".."wyvernTail", 3, 0, 9),
		death = Sprite.load("WyvernDeathAe", path.."Aeonian/".."Death", 11, 153, 64)
	}
	eliteSprites[elt.Void] = {
		idle = Sprite.load("WyvernIdleVo", path.."Void/".."Idle", 1, 111, 104),
		idleWing = Sprite.load("WyvernIdleWingVo", path.."Void/".."idleWing", 1, 111, 104),
		walk = Sprite.load("WyvernWalkVo", path.."Void/".."Walk", 12, 112, 104),
		walkWing = Sprite.load("WyvernWalkWingVo", path.."Void/".."WalkWing", 12, 112, 104),
		fly = Sprite.load("WyvernFlyVo", path.."Void/".."flying", 6, 113, 168),
		flyPrep = Sprite.load("WyvernFlyPrepVo", path.."Void/".."flyPrep", 5, 111, 170),
		flyPrepWing = Sprite.load("WyvernFlyPrepWingVo", path.."Void/".."flyPrepWing", 5, 111, 170),
		flyWing = Sprite.load("WyvernFlyWingVo", path.."Void/".."flyingWing", 6, 113, 168),
		head1 = Sprite.load("WyvernHeadDefaultVo", path.."Void/".."wyernHead", 1, 0, 14),
		head2 = Sprite.load("WyvernHeadShootVo", path.."Void/".."headShoot1", 13, 0, 16),
		neck = Sprite.load ("WyvernNeckVo", path.."Void/".."wyverNeck", 3, 10, 18),
		tail = Sprite.load("WyvernTailVo", path.."Void/".."wyvernTail", 3, 0, 9),
		death = Sprite.load("WyvernDeathVo", path.."Void/".."Death", 11, 153, 64)
	}
end)

local sRoar = Sound.load("WyvernRoar", path.."roar")
local sRumble = Sound.load("WyvernGrumble", path.."grumble")
local sDeath = Sound.load("WyvernDeath", path.."Death")
local sHit = Sound.load("WyvernHit", path.."Hit")

obj.Wyvern = Object.base("Boss", "Wyvern")
obj.Wyvern.sprite = normalSprites.head1
obj.Wyvern.depth = -4

obj.WyvernHead = Object.base("enemy", "WyvernHead")
obj.WyvernHead.sprite = normalSprites.head1
obj.WyvernHead.depth = -4

obj.WyvernTail = Object.base("enemy", "WyvernTail")
obj.WyvernTail.sprite = normalSprites.tail
obj.WyvernTail.depth = -4

obj.WyvernCorpse = Object.new("WyvernCorpse")
obj.WyvernCorpse.sprite = normalSprites.death

--EliteType.registerPalette(sprPalette, obj.Wyvern)

local updateEliteType = function(actor)
	if actor:getObject() == obj.Wyvern then
		local aElite = actor:getElite()
		local data = actor:getData()
		
		local eliteVar = actor:get("elite_type")
		local isElite = eliteVar > -1 and actor:get("prefix_type") == 1
		
		local spriteSet = eliteSprites[aElite] or normalSprites
		
		local color = Color.WHITE
		if spriteSet == normalSprites then
			if isElite then
				color = aElite.color
			end
		end
		
		actor.blendColor = color
		
		for key, sprite in pairs(data.sprites) do
			if sprite == actor.sprite then
				actor.sprite = spriteSet[key]
				break
			end
		end
		
		if data.tail and data.tail:isValid() then
			for key, sprite in pairs(data.sprites) do -- funky
				if sprite == data.tail.sprite then
					data.tail.sprite = spriteSet[key]
					break
				end
			end
			if isElite then
				data.tail:set("elite_type", eliteVar)
				data.tail:set("prefix_type", 1)
				data.tail.blendColor = color
			end
			data.tail:set("maxhp", actor:get("maxhp"))
			data.tail:set("hp", actor:get("hp"))
		end
		if data.head and data.head:isValid() then
			for key, sprite in pairs(data.head:getData().sprites) do
				if sprite == data.head.sprite then
					data.head.sprite = spriteSet[key]
					break
				end
			end
			data.head:getData().sprites = spriteSet
			if isElite then
				data.head:set("elite_type", eliteVar)
				data.head:set("prefix_type", 1)
				data.head.blendColor = color
			end
			data.head:set("maxhp", actor:get("maxhp"))
			data.head:set("hp", actor:get("hp"))
		end
		data.sprites = spriteSet
	end
end

--Code for the head
--================
obj.WyvernHead:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	selfAc.name = "Scaleless Wyvern"
	selfAc.damage = 40 * Difficulty.getScaling("damage")
	selfAc.maxhp = 2100 * Difficulty.getScaling("hp")
	selfAc.armor = 100
	selfAc.hp = selfAc.maxhp
	selfAc.exp_worth = 90 * Difficulty.getScaling()
	selfAc.can_drop = 1
	selfAc.can_jump = 0
	selfAc.team = "enemy"
	--selfAc.sprite_death = normalSprites.death.id
	selfData.xTarget = self.x
	selfData.yTarget = self.y
	selfData.parent = nil
	selfAc.target = -4
	
	selfData.hpt = 2
	
	--[[local t = nearestMatchingOp(self, pobj.actors, "team", "~=", self:get("team"))
	if t then t = t.id end
	selfAc.target = t or -4]]
	
	selfData.timer = 60 * 3
	selfData.didAction = false
	selfData.actionNumber = 3
	selfData.savedAngle = 0
	selfData.relativeX = 0
	self.spriteSpeed = 0
	--self.visible = false
	
	selfData.sprites = normalSprites
end)

obj.WyvernHead:addCallback("destroy", function(self)
	local data = self:getData()
	if data.parent and data.parent:isValid() then
		data.parent:destroy()
	end
end)

obj.WyvernHead:addCallback("step", function(self)
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	local parent = selfData.parent
	
	local sprite = selfData.sprites
	
	if selfData.hpt then
		if selfData.hpt > 0 then
			selfData.hpt = selfData.hpt - 1
		else
			selfAc.hp = selfAc.maxhp
			selfData.hpt = nil
		end
	end
	
	self:setAlarm(6, -1)
	
	if misc.getTimeStop() == 0 then
		if parent and parent:isValid() then
			self.yscale = parent.yscale
			
			local dis = distance(self.x, self.y, parent.x, parent.y)
			if dis > 150 * math.abs(self.xscale) then
				local angle = posToAngle(self.x, parent.y, parent.x, self.y, true)
				local x = self.x + math.cos(angle) * dis
				local y = self.y + math.sin(angle) * dis
				self.x = x
				self.y = y
			end
			
			selfAc.target = parent:get("target")
			
			if selfData.actionNumber >=6 then
				self.spriteSpeed = 0
			elseif selfData.actionNumber >= 5 then
				self.spriteSpeed = 0.09 * parent:get("attack_speed")
			else
				self.spriteSpeed = 0.10 * parent:get("attack_speed")
			end
			--sync the HP so that it matches the body and the tail
			local controller = parent:getData().controller
			
			if selfAc.hp < controller:get("hp") then
				controller:set("hp", selfAc.hp)
			end
			
			selfAc.hp = controller:get("hp")
			selfAc.team = parent:get("team")

			local target = Object.findInstance(selfAc.target)
			
			--when the head is targetting the player to ready an attack:
			if parent:getData().aimMode == 1 or parent:getData().aimMode == 2 then
				if selfData.timer > 0 then
					selfData.timer = self:getData().timer-1
				end
				
				if self.sprite == sprite.head2 then
					--move the head slightly each frame
					if math.floor(self.subimage) == 8 then
						if selfData.relativeX ~=  math.floor(self.subimage) then
							local xx = self.x+5*math.cos(selfAc.direction*(math.pi/180))
							local xy = self.y+5*-math.sin(selfAc.direction*(math.pi/180))
							self.x = xx
							self.y = xy
							selfAc.ghost_x = xx
							selfAc.ghost_y = xy
							selfData.relativeX =  math.floor(self.subimage)
						end
					end
					
					if math.floor(self.subimage) == 9 then
						if selfData.relativeX ~=  math.floor(self.subimage) then
							local xx = self.x+10*math.cos(selfAc.direction*(math.pi/180))
							local xy = self.y+10*-math.sin(selfAc.direction*(math.pi/180))
							self.x = xx
							self.y = xy
							selfAc.ghost_x = xx
							selfAc.ghost_y = xy
							selfData.relativeX =  math.floor(self.subimage)
						end
					end
					
					--calculate angle of shot, adjust head back into original spot to convey knockback, and shoot blast relative to head angle
					if math.floor(self.subimage) == 10 and selfData.didAction == false then
						if selfData.relativeX ~=  math.floor(self.subimage) then
							local xx = self.x+11*math.cos((selfAc.direction*(math.pi/180)))
							local xy = self.y+11*-math.sin((selfAc.direction*(math.pi/180)))
							self.x = xx
							self.y = xy
							selfAc.ghost_x = xx
							selfAc.ghost_y = xy
							selfData.relativeX =  math.floor(self.subimage)
						end
						selfData.didAction = true
						misc.shakeScreen(4)
						Sound.find("FeralShoot2"):play(1.4 + math.random() * 0.2)
						
						local xx = self.x+23*math.cos(selfAc.direction*(math.pi/180))
						local xy = self.y+23*-math.sin(selfAc.direction*(math.pi/180))
						local peeBlast = parent:fireBullet(xx, xy, selfAc.direction, 600, 1, sprImpact, nil)
						local color, elite = nil, parent:getElite()
						if elite then
							if elite == elt.Void then
								color = Color.fromHex(0xFF00B6)
							else
								color = elite.color
							end
						end
						if elite == elt.Blazing then
							addBulletTrailParticle(peeBlast, par.Fire4, nil, 6, false)
							DOT.addToDamager(peeBlast, DOT_FIRE, parent:get("damage") * 0.5, 4, "elite_fire", true)
						else
							addBulletTrailParticle(peeBlast, par.WyvernSpit, color, 10, false)
						end
						
					--loop attack x times
					elseif math.floor(self.subimage) > 11 then
						selfData.didAction = false
						selfData.actionNumber = selfData.actionNumber -1
						if selfData.actionNumber > 0 then
							self.subimage = 6
						end
					end
					
					--at the last frame, reset attack cycle
					if self.subimage > 12.5 then
					
						parent:getData().aimMode = 0
						parent:getData().timer = 60 * 3
						parent:getData().hState = 0
						if parent:getData().fly == 1 then
							parent:getData().fly = 2
						end
						selfData.timer = -1
						self.angle = 0
						if parent:getData().attack_mode == 1 then
							parent:getData().attack_mode = 0
						end
						self.sprite = sprite.head1
						self.subimage = 0
						self.spriteSpeed = 0
						
					end
				end
					if math.floor(self.subimage) < 8 then
						if selfData.relativeX ~= math.floor(self.subimage) then
							selfData.relativeX = math.floor(self.subimage)
							local xx = self.x+math.random(8)+20*math.cos(selfAc.direction*(math.pi/180))
							local xy = self.y+math.random(8)+20*-math.sin(selfAc.direction*(math.pi/180))
							par.Spark:burst("middle", xx, xy, 1)
						end
					end
					
				
				if self.sprite == sprite.head2 and self.subimage < 8 then
					if target and target:isValid() then
						selfData.savedAngle = angle
						if target.y < selfData.yTarget then
							selfData.yTarget  = math.max(parent:getData().nC[0].y-60, target.y)
						elseif  target.y > selfData.yTarget  then
							selfData.yTarget = math.min(parent:getData().nC[0].y+30, target.y)
						end
						
						
						local dist = math.sqrt((target.x-self.x)*(target.x-self.x) + (target.y-self.y)*(target.y-self.y))
						local theta = math.atan2(selfData.yTarget - self.y,target.x - self.x)
						local velx = math.cos(theta)
						local vely = math.sin(theta)
						
						
						if selfData.yTarget < self.y then
							self.y = math.max(parent:getData().nC[0].y-60, (self.y + (vely)*dist/16))
						elseif selfData.yTarget > self.y then
							self.y = math.min(parent:getData().nC[0].y+30, (self.y + (vely)*dist/16))
						end
						
						if ((target.x > self.x and parent.xscale > 0) or (target.x < self.x and parent.xscale <= 0)) then 
							parent:getData().aimMode = 1
						elseif ((target.x > self.x and parent.xscale <= 0) or (target.x < self.x and parent.xscale > 0)) then
							parent:getData().aimMode = 2
						end
						
						selfAc.direction = posToAngle(self.x, self.y, target.x, target.y) 
						
						if self.xscale > 0  then
							self.angle = selfAc.direction
						else
							self.angle = selfAc.direction+180
						end
						
					end
					if not target or not target:isValid() or target:getAccessor().team == selfAc.team then
						local t = nearestMatchingOp(self, pobj.actors, "team", "~=", self:get("team"))
						if t then t = t.id end
							selfAc.target = t or -4
						
						self.y = parent:getData().nC[0].y+30
					end
				end
			end
			
			selfData.xTarget = parent.x+100*parent.xscale
				
			if parent:getData().aimMode ==  0 and self.sprite == sprite.head1 then
				selfData.yTarget = parent.y + parent:getData().yOffset + 30 * parent.yscale
			end
				
			local dist = math.sqrt((selfData.xTarget-self.x)*(selfData.xTarget-self.x) + (selfData.yTarget-self.y)*(selfData.yTarget-self.y))
			local theta = math.atan2(selfData.yTarget - self.y,selfData.xTarget- self.x)
			local velx = math.cos(theta)
			local vely = math.sin(theta)
			
			local newx = (self.x + (velx)*dist/4)
			
			self.x = newx
			selfAc.ghost_x = newx
			if (parent:getData().aimMode == 0 or parent:getData().aimMode == 3) and self.sprite == sprite.head1 then
				local newy = (self.y + (vely)*dist/4)
				self.y = newy
				selfAc.ghost_y = newy
			end
				
			self.xscale = parent.xscale
			
			if net.online and net.host and global.timer % 300 == 0 then
				syncInstanceData:sendAsHost(net.ALL, nil, self:getNetIdentity(), "timer", self:getData().timer)
			end
		else
			self:delete()
		end
	else
		self.spriteSpeed = 0
	end
end)


--Code for the Tail
--================
obj.WyvernTail:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	self.spriteSpeed = 0
	
	selfAc.name = "Scaleless Wyvern"
	selfAc.damage = 40 * Difficulty.getScaling("damage")
	selfAc.maxhp = 2100 * Difficulty.getScaling("hp")
	selfAc.armor = 100
	selfAc.hp = selfAc.maxhp
	selfAc.exp_worth = 90 * Difficulty.getScaling()
	selfAc.can_drop = 1
	selfAc.can_jump = 0
	self:set("team", "enemy")
	selfData.xTarget = self.x
	selfData.yTarget = self.y
	selfData.xQ = self.x
	selfData.yQ = self.y
	selfData.sTimer = 120
	selfData.parent = nil
	selfAc.target = -4
	local t = nearestMatchingOp(self, pobj.actors, "team", "~=", self:get("team"))
		if t then t = t.id end
	selfAc.target = t or -4
	
	selfData.timer = 60*3
	selfData.didAction = false
	selfData.actionNumber = 3
	selfData.savedAngle = 0
	self.spriteSpeed = 0.20
	selfData.relativeX = 0
	
	selfData.hpt = 2
	
	self.spriteSpeed = 0
	self.subimage = 2
	--self.visible = false
end)

obj.WyvernTail:addCallback("destroy", function(self)
	local data = self:getData()
	if data.parent and data.parent:isValid() then
		data.parent:destroy()
	end
end)

obj.WyvernTail:addCallback("step", function(self)
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	local parent = selfData.parent
	
	if selfData.hpt then
		if selfData.hpt > 0 then
			selfData.hpt = selfData.hpt - 1
		else
			selfAc.hp = selfAc.maxhp
			selfData.hpt = nil
		end
	end
	
	self:setAlarm(6, -1)
	
	if misc.getTimeStop() == 0 then
		if parent and parent:isValid() then
			local controller = parent:getData().controller
			
			selfAc.target = parent:get("target")
			
			if selfAc.hp < controller:get("hp") then
				controller:set("hp", selfAc.hp)
			end
			
			selfAc.hp = controller:get("hp")
			selfAc.team = parent:get("team")

			local target = Object.findInstance(selfAc.target)
			
			
			if not target or not target:isValid() or target:getAccessor().team == selfAc.team then
					local t = nearestMatchingOp(self, pobj.actors, "team", "~=", self:get("team"))
						if t then t = t.id end
					selfAc.target = t or -4
			end
			
			if parent:getData().tState == 0 or not target or not target:isValid() then
				selfData.xTarget = parent.x-125*parent.xscale
				selfData.yTarget = self.y
				local dist = math.sqrt((selfData.xTarget-self.x)*(selfData.xTarget-self.x) + (selfData.yTarget-self.y)*(selfData.yTarget-self.y))
				local theta = math.atan2(selfData.yTarget - self.y,selfData.xTarget- self.x)
				local velx = math.cos(theta)
				local vely = math.sin(theta)
				
				local newx, newy = (self.x + (velx)*dist/4), parent.y+parent:getData().yOffset2 + (30*math.sin(math.rad(parent:getData().ySine))) * parent.yscale
				
				self.x = newx
				selfAc.ghost_x = newx
				self.y = newy
				selfAc.ghost_y = newy
			end
			if parent:getData().tState == 1 and target and target:isValid() then
				
				selfData.sTimer = selfData.sTimer- 1
				if selfData.sTimer > -40 then
					selfData.sTimer = selfData.sTimer-1
				end
				if selfData.sTimer > 0 then
					
					
					if target.x < selfData.xTarget then
						selfData.xTarget  = math.max(parent:getData().nC2[0].x-100, target.x)
					elseif  target.x > selfData.xTarget  then
						selfData.xTarget = math.min(parent:getData().nC2[0].x+100, target.x)
					end
							
					selfAc.direction = posToAngle(self.x,self.y,target.x,target.y) 
							
					if self.xscale > 0  then
						self.angle = selfAc.direction
					else
						self.angle = selfAc.direction+180
					end

					local dist = math.sqrt((target.x-self.x)*(target.x-self.x) + (target.y-self.y)*(target.y-self.y))
					local theta = math.atan2(selfData.xTarget - self.y,target.x - self.x)
					local velx = math.cos(theta)
					local vely = math.sin(theta)
					
					if selfData.xTarget < self.x then
						local newx = math.max(parent:getData().nC2[0].x-100, (self.x + (velx)*dist/3))
						self.x = newx
						selfAc.ghost_x = newx
					elseif selfData.xTarget > self.x then
						local newx = math.min(parent:getData().nC2[0].x+100, (self.x + (velx)*dist/3))
						self.x = newx
						selfAc.ghost_x = newx
					end
					
					local newy = parent.y - 100 * parent.yscale
					self.y = newy
					selfAc.ghost_y = newy
					
				
				elseif selfData.sTimer == 0 then
					selfData.xQ = target.x
					selfData.yQ = target.y
					local c = Object.find("EfCircle"):create(self.x, self.y)
						c:set("radius", 0.02)
						c.blendColor = Color.fromHex(0x9cffff)
						
				elseif selfData.sTimer < 0 and selfData.sTimer > -10 then
					local xx = self.x-1*math.cos((selfAc.direction*(math.pi/180)))
					local xy = self.y-1*-math.sin((selfAc.direction*(math.pi/180)))
					self.x = xx
					self.y = xy	
					selfAc.ghost_x = xx
					selfAc.ghost_y = xy
					
				elseif selfData.sTimer == -40 then
					local xx = selfData.xQ
					local xy = selfData.yQ
					selfData.xQ = self.x
					selfData.yQ = self.y
					self.x = xx
					self.y = xy
					selfAc.ghost_x = xx
					selfAc.ghost_y = xy
					parent:fireExplosion(self.x, self.y, 0.30, 0.5, 1, nil, spr.Sparks10r)
					sfx.Boss1Shoot1:play(1.1 + math.random() * 0.2)
					misc.shakeScreen(10)
					local elite = parent:getElite()
					if elite == elt.Blazing then
						for i = -5, 5 do
							local trail = obj.FireTrail:create(self.x + i * 8, self.y - 5)
							trail:set("damage", math.ceil(parent:get("damage") * 0.3))
							trail:set("team", parent:get("team"))
							trail:set("parent", parent.id)
						end
					end
					
				elseif selfData.sTimer == -60 then	
					parent:getData().tState = 0
					parent:getData().tState = 0
					selfData.sTimer = 120
					local cd = 60 * 4
					parent:setAlarm(3, cd - cd * selfAc.cdr)
					
				end
			end
		else
			self:delete()
		end
	end
end)


--Main Body code here
--===============
obj.Wyvern:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	self.sprite = normalSprites.idle
	self.mask = sprMask
	selfAc.name = "Scaleless Wyvern"
	selfAc.name2 = "Toxic Flyer"
	selfAc.damage = 40 * Difficulty.getScaling("damage")
	selfAc.maxhp = 2100 * Difficulty.getScaling("hp")
	selfAc.armor = 100
	selfAc.team = "enemy"
	selfAc.hp = selfAc.maxhp
	--self:getData().knockbackImmune = true
	selfAc.z_skill = 0
	selfAc.z_range = 700
	selfAc.x_skill = 0
	selfAc.x_range = 750
	selfAc.c_skill = 0
	selfAc.c_range = 166
	self:setAlarm(2, 60 * 2)
	
	selfData.hpt = 2
	
	selfData.lastElite = -1
	
	self.y = 0
	--selfAc.knockback_cap = selfAc.maxhp
	selfAc.exp_worth = 90 * Difficulty.getScaling()
	selfAc.point_value = 2300
		--man i gave this guy a lotta variables. Theres probably a way to optimize this but i swear im doing my best
	--Action and cooldown related variables
	selfData.moveX = 0
	selfData.hState = 0
	selfData.tState = 0
	selfData.yGround = 5
	selfData.flyStall = 0
	selfData.attack_mode = 2
	
	selfData.xOffset = 35
	selfData.yOffset = -42
	selfData.xOffset2 = -10
	selfData.yOffset2 = -28
	selfData.aimMode = 0
	selfData.ySine = 0
	
	selfAc.hit_pitch = 1
	
	selfAc.target = -4
	--[[local t = nearestMatchingOp(self, pobj.actors, "team", "~=", self:get("team"))
	if t then t = t.id end
	selfAc.target = t or -4]]
	
	selfData.gTarget = nil
	selfAc.sound_hit = sHit.id
	--selfAc.sound_death = sDeath.id
	--selfAc.sprite_palette = sprPalette.id
	--selfAc.sprite_death = sprDeath.id
	
	--==set the sprites


	--Variables for the base physics system
	selfAc.pVmax = 0
	selfAc.pHmax = 1.3
	selfData.pVspeed = 0
	selfData.pHspeed = 1
	selfData.fly = 1
	selfData.free = true
	selfData.grav = 0.25
	
	--neckCoordinateSet 1
	local off1, off2, off3 = 75, 30, 100
	
	selfData.eC = nCoordinates(self.x+selfData.xOffset*self.xscale,self.y+selfData.yOffset,self.x+off1*self.xscale,self.y+selfData.yOffset,self.x+off1*self.xscale,
	self.y+selfData.yOffset+off2,self.x+(selfData.xOffset+off3)*self.xscale,self.y+selfData.yOffset+off2)

	selfData.nC = nCoordinates(self.x+selfData.xOffset*self.xscale,self.y+selfData.yOffset,self.x+off1*self.xscale,self.y+selfData.yOffset,self.x+off1*self.xscale,
	self.y+selfData.yOffset+off2,self.x+(selfData.xOffset+off3)*self.xscale,self.y+selfData.yOffset+off2)
	
	--tailCoordinateSet1
	selfData.eC2 = nCoordinates(self.x+selfData.xOffset2*self.xscale,self.y+selfData.yOffset2,self.x-off1*self.xscale,self.y+selfData.yOffset2,self.x-off1*self.xscale,
	self.y+selfData.yOffset2,self.x+(selfData.xOffset2-off3)*self.xscale,self.y+selfData.yOffset2+off2)
	selfData.nC2 = nCoordinates(self.x+selfData.xOffset2*self.xscale,self.y+selfData.yOffset2,self.x+off1*self.xscale,self.y+selfData.yOffset2,self.x+off1*self.xscale,
	self.y+selfData.yOffset2+off2,self.x+(selfData.xOffset2+off3)*self.xscale,self.y+selfData.yOffset2+off2)
	
	selfData.controller = self
	
	selfData.sprites = normalSprites
	
	sRoar:play(0.9 + math.random() * 0.2)
end)

--there is so much code here jesus fuck im so sorry neik 
			-- its ok this is awesome :)
obj.Wyvern:addCallback("step", function(self)
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	local activity = selfAc.activity
	local target = Object.findInstance(selfAc.target)
	
	local sprite = selfData.sprites
	
	--coreAi
	--==
	if self:collidesMap(self.x, self.y + 1) then
		selfData.free = nil
	else 
		selfData.free = true
	end
	
	if selfData.hpt then
		if selfData.hpt > 0 then
			selfData.hpt = selfData.hpt - 1
		else
			selfAc.hp = selfAc.maxhp
			selfData.hpt = nil
		end
	end
	
	--creates the head and Tail
	if not selfData.created then
		selfData.head = obj.WyvernHead:create(self.x, self.y - 50)
		selfData.head:getData().parent = self
		selfData.head.depth = self.depth-1
		--====
		selfData.tail = obj.WyvernTail:create(self.x, self.y - 50)
		selfData.tail:getData().parent = self
		selfData.tail.depth = self.depth-1
		
		selfData.created = true
	end
	
	local elite = selfAc.elite_type
	if elite ~= selfData.lastElite or selfData.forceEliteUpdate then
		selfData.lastElite = elite
		selfData.forceEliteUpdate = nil
		updateEliteType(self)
	end

	local head = selfData.head
	local tail = selfData.tail
	
	if misc.getTimeStop() == 0 then
		self.spriteSpeed = 0.20
		selfData.pHspeed = 0
		--this Code only runs when the boss isnt in its fly mode
		--======
		if selfData.fly == 0 then
			--==Gravity!!
			while self:collidesMap(self.x, self.y) do
				self.y = self.y - 1
				if selfData.pVspeed > 0 then
					selfData.pVspeed = 0
				end
			end
			if not self:collidesMap(self.x, self.y +1) then
				self.y = self.y+selfData.pVspeed
				selfData.pVspeed = selfData.pVspeed+selfData.grav
			end
		
			--Move the boss a certain distance forwards
			if selfData.moveX > 0 then
				if not selfData.free then 
					selfData.moveX = selfData.moveX-1
					if not self:collidesMap(self.x+(selfAc.pHmax*self.xscale), self.y) then
						if not (math.floor(self.subimage) == 5 or math.floor(self.subimage) == 6 or math.floor(self.subimage) == 11 or math.floor(self.subimage) == 12) and selfData.hState == 0 then
							selfData.pHspeed = selfAc.pHmax
							self.spriteSpeed = 0.20
							local newx = self.x+(selfData.pHspeed*self.xscale)
							self.x = newx
							selfAc.ghost_x = newx
						end
						self.sprite = sprite.walk
					else
						selfData.pHspeed = 0
						self.sprite = sprite.idle
					end
					
				else
					self.sprite = sprite.fly
				end
			elseif selfData.hState == 0 then
				if target and target:isValid() then
					if self.x < target.x then
						self.xscale = math.abs(self.xscale)
					else
						self.xscale = math.abs(self.xscale) * -1
					end
				end
				
				selfData.moveX = 30
			end
			
			--Makes sure the boss isnt stuck on the ground
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
		
		end
		
		--When both head and body exists, run main code
		if head and head:isValid() and tail and tail:isValid() then
			
			--when idle or walking
			if selfData.attack_mode == 0 then
				selfData.aimMode = 0
				self:set("activity_type", 0)
				head.angle = 0
				if selfData.pHspeed == 0 and selfData.flyStall < 60 then
					selfData.flyStall = selfData.flyStall + 0.12
				end
				
				if selfData.flyStall >= 60 and selfData.hState == 0 then
					selfData.attack_mode = 2
				end
			
			--mouthShooting sprite setting
			elseif selfData.attack_mode == 1 then
				self:set("activity_type", 1)
				self.sprite = sprite.idle
				selfAc.pHspeed = 0
				
			elseif selfData.attack_mode == 2 then
			
				--beforeFlight
				if selfData.fly == 0 then
					self.subimage = 1
					self.spriteSpeed = 0.20
					self.sprite = sprite.flyPrep
					selfData.fly = 0.5 
				end
				
				--preparing flight
				if selfData.fly == 0.5 then
					if self.subimage >= 5 then
						self.sprite = sprite.fly
						self.spriteSpeed = 0.20
						self.subimage = 1
						selfAc.direction = 90
						selfData.fly = 1
						self:setAlarm(2, 30 - 30 * selfAc.cdr)
					end
				end
				
				--Mid-flight
				if selfData.fly == 1 then
					selfAc.pVspeed = 0
					selfAc.pHspeed = 0
					self.sprite = sprite.fly
						if selfData.hState == 0 then
							selfAc.speed = 3
						else
							selfAc.speed = 1.25
						end
					selfData.aState = 1
					if target and target:isValid() then
						selfAc.direction = turnTowards(selfAc.direction,  posToAngle(self.x,self.y,target.x,target.y-100),50)
						if  selfData.hState == 0 then
							if self.x < target.x then
								self.xscale = 1
							else
								self.xscale =-1
							end
						end
					end
					self.spriteSpeed = 0.20
				end
				
				if selfData.fly == 2 then
					selfData.fly = 2.5
					
					if target and target:isValid() then
						selfData.gTarget = obj.BossSpawn:findNearest(target.x, target.y)
					else
						selfData.gTarget = obj.BossSpawn:findNearest(self.x, self.y)
					end
				end
				
				if selfData.fly == 2.5 then
					selfAc.speed = 2.5
					selfAc.direction = turnTowards(selfAc.direction,  posToAngle(self.x,self.y,selfData.gTarget.x,selfData.gTarget.y-4),2)
					
					if math.abs((selfData.gTarget.x - self.x)) < 20 and  math.abs(selfData.gTarget.y-self.y ) < 10 and self.y < selfData.gTarget.y then
						selfAc.speed = 0
						selfData.fly = 0
						selfData.gTarget = nil
						selfData.timer = 60*5
						selfData.attack_mode = 0
						local cd = 60 * 3
						self:setAlarm(3, cd - cd * selfAc.cdr)
						
						selfData.flyStall = 0
					end
				end
			end
			
			--Determines the shape the neck should take
			if selfData.aimMode <= 1 then
				selfData.eC = nCoordinates(self.x+selfData.xOffset*self.xscale,self.y+selfData.yOffset,self.x+75*self.xscale,self.y+selfData.yOffset,
				self.x+75*self.xscale,head.y,head.x,head.y)
			elseif selfData.aimMode == 2 then
				selfData.eC = nCoordinates(self.x+selfData.xOffset*self.xscale,self.y+selfData.yOffset,self.x+100*self.xscale,self.y+selfData.yOffset,self.x+125*self.xscale,head.y,head.x,head.y)
			end
			
			--smoothly transition to required position, Head
			for i = 0,3 do
				if i < 3 and i > 0 then
					local eC = selfData.eC
					
					local dist = math.sqrt((eC[i].x-selfData.nC[i].x)*(eC[i].x-selfData.nC[i].x) + (eC[i].y-selfData.nC[i].y)*(eC[i].y-selfData.nC[i].y))
					
					local theta = math.atan2(eC[i].y - selfData.nC[i].y,eC[i].x - selfData.nC[i].x)
					
					local velx = math.cos(theta)
					local vely = math.sin(theta)
					
					selfData.nC[i].x = (selfData.nC[i].x + (velx)*dist/6)
					selfData.nC[i].y = (selfData.nC[i].y + (vely)*dist/6)
				else
					selfData.nC[0].x = self.x+selfData.xOffset*self.xscale
					selfData.nC[0].y = self.y+selfData.yOffset*self.yscale
					selfData.nC[3].x = head.x
					selfData.nC[3].y = head.y
				end
			end
			
			--smoothly transition to required position,  tail
			for i = 0,3 do
				if  i < 3 and i > 0 then
					local eC2 = selfData.eC2
					
					local dist = math.sqrt((eC2[i].x-selfData.nC2[i].x)*(eC2[i].x-selfData.nC2[i].x) + (eC2[i].y-selfData.nC2[i].y)*(eC2[i].y-selfData.nC2[i].y))
					
					local theta = math.atan2(eC2[i].y - selfData.nC2[i].y,eC2[i].x - selfData.nC2[i].x)
					
					local velx = math.cos(theta)
					local vely = math.sin(theta)
					
					selfData.nC2[i].x = (selfData.nC2[i].x + (velx)*dist/6)
					selfData.nC2[i].y = (selfData.nC2[i].y + (vely)*dist/6)
				else
					selfData.nC2[0].x = self.x+selfData.xOffset2*self.xscale
					selfData.nC2[0].y = self.y+selfData.yOffset2*self.yscale
					selfData.nC2[3].x = tail.x
					selfData.nC2[3].y = tail.y
				end
			end
			if selfData.ySine < 360 then
				selfData.ySine = selfData.ySine +2
			else
				selfData.ySine = 0
			end
			
			local ySine = selfData.ySine
			
			--sets coordinates for both tail Shapes
			if selfData.tState == 0 then
				selfData.eC2 = nCoordinates(self.x+selfData.xOffset2*self.xscale,self.y+selfData.yOffset2+(10*math.sin(math.rad(ySine+270))),self.x-50*self.xscale,
				self.y+selfData.yOffset2+(30*math.sin(math.rad(ySine+180))),self.x-75*self.xscale,self.y+selfData.yOffset2+(60*math.sin(math.rad(ySine+90))),tail.x,tail.y)
			elseif selfData.tState == 1 then
				selfData.eC2 = nCoordinates(self.x+selfData.xOffset2*self.xscale,self.y+selfData.yOffset2,self.x-75*self.xscale,
				self.y-100,self.x-10*self.xscale,self.y-160,tail.x,tail.y)
			end
			
			
			--Attack Code
			--===========
			if target and target:isValid() then
			
				--==Conditions to trigger attacks
				if selfData.hState == 0 then
						if (math.abs(target.x - self.x) < selfAc.z_range and  math.abs(target.y - self.y) < 100) and selfData.attack_mode == 0 and selfData.tState == 0 then
							selfAc.z_skill = 1
						end
						
						if (math.abs((target.x - self.x)) > selfAc.x_range or  math.abs((target.y - self.y)) > 100) and selfData.attack_mode == 0 and selfData.tState == 0 then
							selfAc.x_skill = 1
						end
				end
				if selfData.tState == 0 then
						if target and target:isValid() then
							if math.abs((target.x - self.x)) < selfAc.c_range and  math.abs((target.y - self.y)) < 25 and (selfData.attack_mode == 0 or selfData.attack_mode == 1) then
								selfAc.c_skill = 1
							end
						end
				end
				
				--== takes flight here
				if selfAc.x_skill == 1 and self:getAlarm(3) == -1 and selfData.attack_mode == 0 then
					selfData.attack_mode = 2
					selfAc.x_skill = 0
				end
				
				--==shoots mouth blast
				if ((selfAc.z_skill == 1 and selfData.attack_mode == 0 and self:getAlarm(2) == -1 and selfData.tState == 0)  or 
					(self:getAlarm(2) == -1 and selfData.fly == 1 and math.abs(target.y - self.y) < 200) and selfData.hState == 0) then
					selfAc.z_skill = 0
					local cd = 60 * 10
					self:setAlarm(2,  cd - cd * selfAc.cdr)
					selfData.hState = 1
					
					self.sprite = sprite.idle
					self:set("pHspeed", 0)
					sRumble:play(1,1.75)
						
					selfData.timer = -1

					selfData.aimMode = 1
					head:getData().timer = 60*3
					head.sprite = sprite.head2
					if selfData.attack_mode == 0 then
						head.subimage = 1
						head.spriteSpeed = 0.10 * selfAc.attack_speed
						head:getData().actionNumber = 3
						selfData.attack_mode = 1
					else
						head.subimage = 3
						head.spriteSpeed = 0.09 * selfAc.attack_speed
						head:getData().actionNumber = 5
					end
				end
				
				--==Handles tail Stabbing
				if (selfAc.c_skill == 1 and (selfData.attack_mode == 0 or selfData.attack_mode == 1) and self:getAlarm(3) == -1) then
					selfData.tState = 1
					selfAc.c_skill = 0
				end
			else
				self.spriteSpeed = 0
				if selfData.free ~= true then
					selfAc.speed = 0
				end
			end
			if net.online and net.host and global.timer % 300 == 0 then
				syncInstanceData:sendAsHost(net.ALL, nil, self:getNetIdentity(), "timer", selfData.timer)
				syncInstanceData:sendAsHost(net.ALL, nil, self:getNetIdentity(), "sTimer", selfData.sTimer)
				syncInstanceData:sendAsHost(net.ALL, nil, self:getNetIdentity(), "attack_mode", selfData.attack_mode)
				syncInstanceVar:sendAsHost(net.ALL, nil, self:getNetIdentity(), "target", selfAc.target)
				syncInstanceAlarm:sendAsHost(net.ALL, nil, self:getNetIdentity(), 2, self:getAlarm(2))
				syncInstanceAlarm:sendAsHost(net.ALL, nil, self:getNetIdentity(), 3, self:getAlarm(3))
				syncInstancePosition:sendAsHost(net.ALL, nil, self:getNetIdentity(), self.x, self.y) -- desyncs ugh.
			end
		else
			self:kill()
		end
	else
		self.spriteSpeed = 0
		selfAc.speed = 0
	end
	
	if not target or not target:isValid() then
		if selfAc.team == "enemy" then
			local t = obj.POI:findNearest(self.x, self.y)
			if t then t = t.id end
			selfAc.target = t or -4
		else
			local nearestEnemy = nearestMatchingOp(self, pobj.actors, "team", "~=", selfAc.team)
			if nearestEnemy then
				selfAc.target = nearestEnemy.id
			end
		end
	end
end)

obj.Wyvern:addCallback("destroy", function(self)
	local data = self:getData()
	if data.tail and data.tail:isValid() then
		data.tail:delete()
	end
	if data.head and data.head:isValid() then
		data.head:delete()
	end
	sDeath:play(0.9 + math.random() * 0.2)
	local corpse = obj.WyvernCorpse:create(self.x + 5 * self.xscale, self.y  - 30 * self.yscale)
	corpse.sprite = data.sprites.death
	corpse.blendColor = self.blendColor
	corpse.xscale = self.xscale
	corpse.yscale = self.yscale
end)

--==Lots of rendering Nightmare
obj.Wyvern:addCallback("draw",function(self)
	local selfData = self:getData()
	--first establish the tail and the head belonging to the boss
	
	local head = selfData.head
	local tail = selfData.tail
	
	local sprite = selfData.sprites
	
	--render the tail, using the coordinates found, startng with the tail's base connecting to the torso
	local n3Max = 16
	for n3 = 0, n3Max do
		local b = bezier_Point_Find(n3/n3Max,selfData.nC2[0].x,selfData.nC2[0].y,selfData.nC2[1].x,selfData.nC2[1].y,selfData.nC2[2].x,selfData.nC2[2].y,selfData.nC2[3].x,selfData.nC2[3].y)
		local b2 = bezier_Point_Find((n3+1)/n3Max,selfData.nC2[0].x,selfData.nC2[0].y,selfData.nC2[1].x,selfData.nC2[1].y,selfData.nC2[2].x,selfData.nC2[2].y,selfData.nC2[3].x,selfData.nC2[3].y)
		local b3 = bezier_Point_Find((n3-1)/n3Max,selfData.nC2[0].x,selfData.nC2[0].y,selfData.nC2[1].x,selfData.nC2[1].y,selfData.nC2[2].x,selfData.nC2[2].y,selfData.nC2[3].x,selfData.nC2[3].y)
		if n3 == 0 then
			graphics.drawImage{
				image = sprite.tail,
					x = b[0],
					y = b[1],
					subimage = 3,
					angle = posToAngle(b[0],b[1],b2[0],b2[1]),
					alpha = self.alpha,
					yscale = self.xscale,
					color = self.blendColor
				}
				graphics.drawImage{
					image = self.sprite,
					x = self.x,
					y = self.y,
					subimage = self.subimage,
					angle = self.angle,
					xscale = self.xscale,
					yscale = self.yscale,
					alpha = self.alpha,
					color = self.blendColor
				}

		--render the girth of the tail
		elseif n3 > 0 and n3 < n3Max then
			graphics.drawImage{
				image = sprite.tail,
				x = b[0],
				y = b[1],
				subimage = 1,
				angle = posToAngle(b[0],b[1],b2[0],b2[1]),
				alpha = self.alpha,
				yscale = (self.xscale/math.max(1,(n3/5))),
				color = self.blendColor
			}
			
		end
		
		--render the Tail Tip, depending on if its attacking or not
		if n3 == n3Max then
			if tail and tail:isValid() then
				if selfData.tState == 0 then
					tail.angle = posToAngle(b3[0],b3[1],b[0],b[1])
					tail.yscale = self.xscale
					--[[graphics.drawImage{
						image = sprTail,
						x = tail.x,
						y = tail.y,
						subimage = 2,
						angle = posToAngle(b3[0],b3[1],b[0],b[1]),
						alpha = 1,
						yscale = self.xscale
					}]]
				else
					tail.angle = posToAngle(b3[0],b3[1],b[0],b[1])
					tail.yscale = self.xscale
					--[[graphics.drawImage{
						image = sprTail,
						x = tail.x,
						y = tail.y,
						subimage = 2,
						angle = tail.angle,
						alpha = 1,
						yscale = self.xscale
					}]]
				end
			end
		end
	end	
	
		--render the neck, using the coordinates found
		--= math.ceil(distance(self.x,self.y,x,y)/2.5)
		local n2Max = 50
		for n2 = 0, n2Max do
			
			local b = bezier_Point_Find(n2/n2Max,selfData.nC[0].x,selfData.nC[0].y,selfData.nC[1].x,selfData.nC[1].y,selfData.nC[2].x,selfData.nC[2].y,selfData.nC[3].x,selfData.nC[3].y)
			local b2 = bezier_Point_Find((n2+1)/n2Max,selfData.nC[0].x,selfData.nC[0].y,selfData.nC[1].x,selfData.nC[1].y,selfData.nC[2].x,selfData.nC[2].y,selfData.nC[3].x,selfData.nC[3].y)
			if n2 < n2Max-1 then
				graphics.drawImage{
					image = sprite.neck,
					x = b[0],
					y = b[1],
					subimage = 2,
					angle = posToAngle(b[0],b[1],b2[0],b2[1]),
					alpha = self.alpha,
					yscale = self.xscale,
					color = self.blendColor
				}
			end
		end	
		
		--the spiky parts of the neck
		local nMax = 5
		for n = 0, nMax do
			
			local b = bezier_Point_Find(n/nMax,selfData.nC[0].x,selfData.nC[0].y,selfData.nC[1].x,selfData.nC[1].y,selfData.nC[2].x,selfData.nC[2].y,selfData.nC[3].x,selfData.nC[3].y)
			local b2 = bezier_Point_Find((n+1)/nMax,selfData.nC[0].x,selfData.nC[0].y,selfData.nC[1].x,selfData.nC[1].y,selfData.nC[2].x,selfData.nC[2].y,selfData.nC[3].x,selfData.nC[3].y)
			local b3 = bezier_Point_Find((n-1)/nMax,selfData.nC[0].x,selfData.nC[0].y,selfData.nC[1].x,selfData.nC[1].y,selfData.nC[2].x,selfData.nC[2].y,selfData.nC[3].x,selfData.nC[3].y)
			if n < nMax  and n > 0 then
				graphics.drawImage{
					image = sprite.neck,
					x = b[0],
					y = b[1],
					subimage = 0,
					angle = posToAngle(b[0],b[1],b2[0],b2[1]),
					alpha = self.alpha,
					yscale = self.xscale,
					color = self.blendColor
				}
			elseif n == 0 then
			
				graphics.drawImage{
					image = sprite.neck,
					x = b[0],
					y = b[1],
					subimage = 3,
					angle = posToAngle(b[0],b[1],b2[0],b2[1]),
					alpha = self.alpha,
					yscale = self.xscale,
					color = self.blendColor
				}
			end
		end
		
		--render head and assign to head object's position
		--[[if head and head:isValid() then
			graphics.drawImage{
				image = head.sprite,
				x = head.x,
				y = head.y,
				subimage = head.subimage,
				angle = head.angle,
				alpha = 1,
				xscale = head.xscale,
				yscale = head.yscale,
				color = self.blendColor
			}
		end]]
		
	--Render Wings here
	local sp = sprite.idleWing
	if self.sprite == sprite.walk then
		sp = sprite.walkWing
	elseif self.sprite == sprite.fly then
		sp = sprite.flyWing
	elseif self.sprite == sprite.flyPrep then
		sp = sprite.flyPrepWing
	end
	graphics.drawImage{
		image = sp,
		x = self.x,
		y = self.y,
		subimage = self.subimage,
		angle = self.angle,
		alpha = self.alpha,
		xscale = self.xscale,
		color = self.blendColor
	}
	
	if tail and tail:isValid() and tail:getData().sTimer < -40 then
		graphics.color(Color.WHITE)
		
		graphics.line(tail.x, tail.y, tail:getData().xQ, tail:getData().yQ, (tail:getData().sTimer+60)/4)
	end
end)

obj.WyvernCorpse:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.speed = 2
	selfData.direction = 0
	selfData.accel = 0
	self.spriteSpeed = 0.11
end)
obj.WyvernCorpse:addCallback("step", function(self)
	local selfData = self:getData()
	if self.subimage >= self.sprite.frames then
		self.spriteSpeed = 0
	end
	--[[if selfData.speed > 0 then
		selfData.speed = math.approach(selfData.speed, 0, 0.1)
		
		local 
	end]]
	if not Stage.collidesRectangle(self.x - 20, self.y, self.x + 20, self.y + 36 * self.yscale) then
		for i = 1, selfData.accel * 10 do
			if not Stage.collidesRectangle(self.x - 20, self.y, self.x + 20, self.y + 36 * self.yscale) then
				self.y = self.y + 0.1
			else
				break
			end
		end
		selfData.accel = selfData.accel + 0.1
	else
		selfData.accel = 0
	end
end)

mcard.Wyvern = MonsterCard.new("Wyvern", obj.Wyvern)
mcard.Wyvern.type = "offscreen"
mcard.Wyvern.cost = 2300
mcard.Wyvern.sound = nil
mcard.Wyvern.sprite =  spr.Nothing
mcard.Wyvern.isBoss = true
mcard.Wyvern.canBlight = false
mcard.Wyvern.eliteTypes:add(elt.Blazing)
--[[
mlog.wyvern = MonsterLog.new("wyvern")
MonsterLog.map[obj.Wyvern] = mlog.wyvern
mlog.wyvern.displayName = "Scaleless Wyvern"
mlog.wyvern.story = "Biggestest boi."
mlog.wyvern.statHP = 1400
mlog.wyvern.statDamage = 30
mlog.wyvern.statSpeed = 1.3
mlog.wyvern.sprite = sprLogBook
mlog.wyvern.portrait = sprPortrait]]

for _, stage in ipairs(stages) do
	stage.enemies:add(mcard.Wyvern)
end