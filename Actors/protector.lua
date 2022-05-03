local parentpath = "Actors/Gatekeeper/"
local path = "Actors/Gatekeeper/Protector/"

local sprMask = Sprite.find("GatekeeperMask", "Starstorm")
local sprSpawn = Sprite.load("ProtectorSpawn", path.."Spawn", 20, 37, 74)
local sprIdle = Sprite.load("ProtectorIdle", path.."Idle_1", 1, 29, 63)
local sprIdleShield = Sprite.load("ProtectorIdleShield", path.."Idle_2", 1, 29, 63)
local sprWalk = Sprite.load("ProtectorWalk", path.."Walk_1", 6, 29, 63)
local sprShoot1_1 = Sprite.load("ProtectorShoot1_1", path.."Shoot1_1", 7, 29, 63)
local sprShoot1_2 = Sprite.load("ProtectorShoot1_2", path.."Shoot1_2", 17, 29, 63)
local sprShoot2_1 = Sprite.load("ProtectorShoot2_1", path.."Shoot2_1", 5, 29, 63)
local sprShoot2_2 = Sprite.load("ProtectorShoot2_2", path.."Shoot2_2", 5, 29, 63)
local sprDeath = Sprite.load("ProtectorDeath", path.."Death", 7, 37, 74)

local sSpawn = Sound.find("GatekeeperSpawn", "Starstorm")
local sLaserHit = Sound.find("GatekeeperLaserHit", "Starstorm")
local sLaserCharge = Sound.find("Drone1Spawn")

local sLaserFire = Sound.find("GatekeeperLaserFire", "Starstorm")
local sLaserFire2 = Sound.find("GatekeeperLaserFire2", "Starstorm")
local sDeath = Sound.find("GatekeeperDeath", "Starstorm")

obj.Protector = Object.base("BossClassic", "Protector")
obj.Protector.sprite = sprIdle


local objProtectorLaser = Object.find("GatekeeperLaser")
local laserColor = Color.fromHex(0xCC5951)

NPC.setSkill(obj.Protector, 1, 400, 60 * 4, nil, 0.16, function(actor)
	if actor:getData().attack_mode == 1 then
		actor.sprite = sprShoot1_1
		sLaserFire:play()
	else
		actor.sprite = sprShoot1_2
		sLaserCharge:play(2)
	end
end, function(actor, relevantFrame)
	local actorData = actor:getData()
	if actor:getData().attack_mode == 1 then
		actor.sprite = sprShoot1_1
		
		if relevantFrame == 4 then
			--sfx.GuardDeath:play(0.5, 0.8)
			local target = actorData.gk_targetting
			
			if target then
				local laser = objProtectorLaser:create(target.x, target.y)
				laser:getData().color = laserColor
				laser:getData().parent = actor
				if target.moving ~= 0 then
					laser:getData().direction = target.moving
				end
				
				local laser = objProtectorLaser:create(target.x + 20, target.y)
				laser:getData().color = laserColor
				laser:getData().parent = actor
				laser:getData().timer = 50
				if target.moving ~= 0 then
					laser:getData().direction = target.moving
				end
				
				local laser = objProtectorLaser:create(target.x - 20, target.y)
				laser:getData().color = laserColor
				laser:getData().parent = actor
				laser:getData().timer = 50
				if target.moving ~= 0 then
					laser:getData().direction = target.moving
				end
			end
			
		elseif relevantFrame > 4 then
			actorData.gk_targetting = nil
			
		elseif relevantFrame < 4 then
			local target = Object.findInstance(actor:get("target"))
			
			if target and target:isValid() then
				if actorData.gk_targetting then
					
					local dif = actorData.gk_targetting.x - target.x
					actorData.gk_targetting.x = math.approach(actorData.gk_targetting.x, target.x, dif * 0.6)
					dif = actorData.gk_targetting.y - target.y
					actorData.gk_targetting.y = math.approach(actorData.gk_targetting.y, target.y, dif * 0.6)
					
					if target:getObject() == obj.POI then
						local ttarget = Object.findInstance(target:get("parent"))
						if ttarget then
							if ttarget:get("pHspeed") == 0 then
								actorData.gk_targetting.moving = 0
							else
								actorData.gk_targetting.moving = ttarget:get("pHspeed")
							end
						end
					else
						if target:get("pHspeed") == 0 then
							actorData.gk_targetting.moving = 0
						else
							actorData.gk_targetting.moving = target:get("pHspeed")
						end
					end
				else
					actorData.gk_targetting = {x = target.x, y = target.y, laser = true}
				end
			end
		end
	else
		actor.sprite = sprShoot1_2
		
		if relevantFrame == 14 then
			sLaserFire2:play(0.9 + math.random() * 0.2, 0.6)
			local target = actorData.gk_targetting
			
			if target then
				local originx = actor.x - 19 * actor.xscale
				local originy = actor.y - 13
				
				local missileType = obj.EfMissileEnemy
				if actor:get("team") == "player" then missileType = obj.EfMissile end
				
				local missile = missileType:create(originx, originy)
				missile:set("target",  actor:get("target"))
				missile:set("targetx", target.x)
				missile:set("targety", target.y)
				missile:set("team", actor:get("team"))
				missile:set("damage", actor:get("damage") * 1.5)
				
				local x2, y2 = target.x, target.y
				local t = Object.findInstance(actor:get("target"))
				if t and t:isValid() then
					if t:getObject() == obj.POI then t = Object.findInstance(t:get("parent")) end
					x2 = t.x + t:get("pHspeed") * 5
					y2 = t.y + t:get("pVspeed") * 5
				end
				
				local missile = missileType:create(originx, originy)
				missile:set("target",  actor:get("target"))
				missile:set("targetx", x2)
				missile:set("targety", y2)
				missile:set("team", actor:get("team"))
				missile:set("damage", actor:get("damage") * 1.5)
			end
		
		elseif relevantFrame == 16 then
			sLaserFire2:play(0.9 + math.random() * 0.2, 0.6)
			local target = actorData.gk_targetting
			
			if target then
				local originx = actor.x + 18 * actor.xscale
				local originy = actor.y - 13
				local missileType = obj.EfMissileEnemy
				if actor:get("team") == "player" then missileType = obj.EfMissile end
				
				local missile = missileType:create(originx, originy)
				missile:set("target",  actor:get("target"))
				missile:set("targetx", target.x)
				missile:set("targety", target.y)
				missile:set("team", actor:get("team"))
				missile:set("damage", actor:get("damage") * 1.5)
				
				local x2, y2 = target.x, target.y
				local t = Object.findInstance(actor:get("target"))
				if t and t:isValid() then
					if t:getObject() == obj.POI then t = Object.findInstance(t:get("parent")) end
					x2 = t.x + t:get("pHspeed") * 5
					y2 = t.y + t:get("pVspeed") * 5
				end
				
				local missile = missileType:create(originx, originy)
				missile:set("target",  actor:get("target"))
				missile:set("targetx", x2)
				missile:set("targety", y2)
				missile:set("team", actor:get("team"))
				missile:set("damage", actor:get("damage") * 1.5)
			end
			
		elseif relevantFrame > 16 then
			actorData.gk_targetting = nil
			
		elseif relevantFrame ~= 14 and relevantFrame ~= 16 then
			local target = Object.findInstance(actor:get("target"))
			
			if target and target:isValid() then
				if actorData.gk_targetting then
				
					local dif = actorData.gk_targetting.x - target.x
					actorData.gk_targetting.x = math.approach(actorData.gk_targetting.x, target.x, dif * 0.18)
					dif = actorData.gk_targetting.y - target.y
					actorData.gk_targetting.y = math.approach(actorData.gk_targetting.y, target.y, dif * 0.18)
				else
					actorData.gk_targetting = {x = target.x, y = target.y}
				end
			end
		end
	end
end)

NPC.setSkill(obj.Protector, 2, 300, 60 * 7, nil, 0.15, function(actor)
	if actor:getData().attack_mode == 1 then
		actor.sprite = sprShoot2_1
		actor:getData().attack_mode = 2
		actor:set("sprite_idle", sprIdleShield.id)
		actor:set("armor", actor:get("armor") + 100)
		--actor:getData().gk_prespeed = actor:get("pHmax")
		actor:set("pHmax", actor:get("pHmax") - 100)
	else
		actor.sprite = sprShoot2_1
		actor:getData().attack_mode = 1
		actor:set("sprite_idle", sprIdle.id)
		actor:set("armor", actor:get("armor") - 100)
		actor:set("pHmax", actor:get("pHmax") + 100)
	end
end, function(actor, relevantFrame)
	if actor:getData().attack_mode == 1 then
		actor.sprite = sprShoot2_2
	else
		actor.sprite = sprShoot2_1
	end
end)

obj.Protector:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Protector"
	selfAc.name2 = "Keeper of the Artifact"
	selfAc.damage = 34 * Difficulty.getScaling("damage")
	selfAc.maxhp = 1400 * Difficulty.getScaling("hp")
	selfAc.armor = 25
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 0.8
	selfAc.knockback_cap = selfAc.maxhp
	selfAc.exp_worth = 90 * Difficulty.getScaling()
	selfAc.can_drop = 0
	selfAc.can_jump = 0
	selfAc.sound_hit = sfx.GuardHit.id
	selfAc.hit_pitch = 0.85
	selfAc.sound_death = sDeath.id
	selfAc.sprite_idle = sprIdle.id
	selfAc.sprite_walk = sprWalk.id
	selfAc.sprite_jump = sprIdle.id
	selfAc.sprite_death = sprDeath.id
	self:getData().attack_mode = 1
	selfAc.boss_drop_item = 0
	self:getData().knockbackImmune = true
end)

obj.Protector:addCallback("step", function(self)
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	local activity = selfAc.activity
	
	if selfAc.moveRight ~= 0 or selfAc.moveLeft ~= 0 then
		self.spriteSpeed = 0.135 * selfAc.pHmax
	end
	
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
	
	if misc.getTimeStop() == 0 then
		if activity == 0 then
			for k, v in pairs(NPC.skills[object]) do
				if self:get(v.key.."_skill") > 0 and self:getAlarm(k + 1) == -1 then
					selfData.attackFrameLast = 0
					self:set(v.key.."_skill", 0)
					if v.start then
						v.start(self)
					end
					selfAc.activity = k
					self.subimage = 1
					if v.cooldown then
						self:setAlarm(k + 1, v.cooldown * (1 - self:get("cdr")))
					end
				else
					self:set(v.key.."_skill", 0)
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
				selfAc.activity_type = 1
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
	else
		self.spriteSpeed = 0
	end
	
	if self.sprite.id == selfAc.sprite_death then
		self.subimage = 1
	end
	
	if self:getData().gk_bullettimer then
		if self:getData().gk_bullettimer > 0 then
			self:getData().gk_bullettimer = self:getData().gk_bullettimer - 1
		else
			self:getData().gk_bullettimer = nil
		end
	end
	
	if selfAc.cdr > 0.8 then -- more just makes it dumb
		selfAc.cdr = 0.8
	end
end)
obj.Protector:addCallback("draw", function(self)
	local color = laserColor
	
	if self:getElite() then
		color = self:getElite().color
	end
	
	if self:getData().gk_targetting then
		local target = self:getData().gk_targetting
		if self.sprite == sprShoot1_2 then
			
			graphics.color(color)
			graphics.alpha(0.6)
			local yy = self.y - 18 * self.yscale
			
			--graphics.circle(target.x, target.y, 3, true)
			graphics.line(target.x - 10, target.y, target.x - 2, target.y, 2)
			graphics.line(target.x + 2, target.y, target.x + 10, target.y, 2)
			graphics.line(target.x, target.y - 10, target.x, target.y - 2, 2)
			graphics.line(target.x, target.y + 2, target.x, target.y + 10, 2)
		end
	end
end)

table.insert(call.postStep, function()
	for _, actor in ipairs(obj.Protector:findAll()) do
		if actor:getData().attack_mode == 2 then
			if actor:get("moveRight") == 1 then
				actor:set("moveRight", 0)
			end
			if actor:get("moveLeft") == 1 then
				actor:set("moveLeft", 0)
			end
		end
	end
end)