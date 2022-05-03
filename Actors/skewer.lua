local pPath = "Actors/Stray/"
local path = pPath.."Skewer/"

local sprPalette = Sprite.load("SkewerPal", pPath.."Palette", 1, 0, 0)
local sprMask = Sprite.load("SkewerMask", path.."Mask", 1, 11, 11)
local sprSpawn = Sprite.load("SkewerSpawn", path.."Spawn", 10, 26, 17)
local sprIdle = Sprite.load("SkewerIdle", path.."Idle", 1, 21, 17)
local sprJump = Sprite.load("SkewerJump", path.."Jump", 1, 21, 17)
local sprWalk = Sprite.load("SkewerWalk", path.."Walk", 8, 24, 17)
local sprShoot1 = Sprite.load("SkewerShoot1", path.."Shoot1", 9, 21, 32)
local sprDeath = Sprite.load("SkewerDeath", path.."Death", 9, 21, 17)

local sSpawn = Sound.load("SkewerSpawn", path.."Spawn")
local sShoot1 = Sound.load("SkewerShoot1", path.."Shoot1")
local sDeath = Sound.load("SkewerDeath", path.."Death")

obj.Skewer = Object.base("EnemyClassic", "Skewer")
obj.Skewer.sprite = sprIdle

EliteType.registerPalette(sprPalette, obj.Skewer)

NPC.setSkill(obj.Skewer, 1,30, 60 * 2, sprShoot1, 0.2, nil, function(actor, relevantFrame)
	local actorData = actor:getData()
	if relevantFrame == 1 then
		sShoot1:play(0.9 + math.random() * 0.2)
	elseif relevantFrame == 7 then
		local yy = 15
		if actor:getData().climb == 0 then yy = -15 end
		actor:fireExplosion(actor.x + 10 * actor.xscale, actor.y + yy , 36 / 19, 30 / 4, 2, nil, spr.Sparks7)
	end
end)

obj.Skewer:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Skewer"
	selfAc.damage = 20 * Difficulty.getScaling("damage")
	selfAc.maxhp = 400 * Difficulty.getScaling("hp")
	selfAc.armor = 0
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 1.5
	selfAc.knockback_cap = selfAc.maxhp
	selfAc.exp_worth = 50 * Difficulty.getScaling()
	selfAc.point_value = 200
	selfAc.can_drop = 1
	selfAc.can_jump = 1
	selfAc.sound_hit = sfx.LizardGHit.id
	selfAc.hit_pitch = 2
	selfAc.sound_death = sDeath.id
	selfAc.sprite_palette = sprPalette.id
	selfAc.sprite_idle = sprIdle.id
	selfAc.sprite_walk = sprWalk.id
	selfAc.sprite_jump = sprJump.id
	selfAc.sprite_death = sprDeath.id
	self:getData().warpTimer = 0
	self:getData().lastHp = selfAc.hp
	self:getData().animOverride = 1
end)

obj.Skewer:addCallback("step", function(self)
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	local activity = selfAc.activity
	
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
	
	local alarm7 = self:getAlarm(7)
	
	if selfData.warpTimer > 0 then
		selfData.warpTimer = selfData.warpTimer - 1 
	else
		if selfData.lastHp > selfAc.hp and alarm7 <= 0 and selfAc.activity == 0 then
			local xx = 0
			for i = 1, 20 do
				if self:collidesMap(self.x + self.xscale * i, self.y) then
					break
				else
					xx = xx + 1
				end
			end
			if selfData.climb then
				selfData.climb = nil
				self.angle = 0
			end
			if xx > 0 then
				obj.EfFlash:create(0,0):set("parent", self.id):set("rate", 0.08)
				selfData.warpTimer = 60
				self.x = self.x + self.xscale * xx
			end
		end
	end
	
	if alarm7 > 2 then
		self:setAlarm(7, alarm7 - 1)
	end
	
	local target = Object.findInstance(selfAc.target)
	if target and target:isValid() then
		if selfData.climb then
			selfAc.pVspeed = 0---selfAc.pGravity1
			if selfData.climb > 0 then
				if self:collidesMap(self.x, self.y) then
					self.x = self.x - 1
				end
				selfAc.moveRight = 1
				selfAc.moveLeft = 0
				if not self:collidesMap(self.x + 4, self.y) and  (target.y < self.y - 5 or target.y > self.y + 8) then
					selfData.climb = nil
					self.angle = 0
				end
			elseif selfData.climb < 0 then
				if self:collidesMap(self.x, self.y) then
					self.x = self.x + 1
				end
				selfAc.moveLeft = 1
				selfAc.moveRight = 0
				if not self:collidesMap(self.x - 4, self.y) and  (target.y < self.y - 5 or target.y > self.y + 8) then
					selfData.climb = nil
					self.angle = 0
				end
			else
				if target.y > self.y + 10 then
					if not selfData.releaseTimer then
						selfData.releaseTimer = 80
					else
						if selfData.releaseTimer > 0 then
							selfData.releaseTimer = selfData.releaseTimer - 1
						else
							selfData.lastClimb = nil
							self.angle = 0
							self.y = self.y + 3
							if self:collidesMap(self.x - 11 - 2, self.y) then
								self.x = self.x + 2
							elseif self:collidesMap(self.x + 11 + 2, self.y) then
								self.x = self.x - 2
							end
							selfData.releaseTimer = nil
						end
					end
				end
				if self:collidesMap(self.x, self.y) then
					self.y = self.y + 1
				end
				selfAc.pVspeed = -selfAc.pGravity1
				if selfAc.activity == 0 and misc.getTimeStop() == 0 then
					self.xscale = self.xscale * -1 --math.abs(self.xscale) * math.sign(self.x - target.y)
				else
					selfAc.pHspeed = 0
				end
				--[[if target.x > self.x + 8 then
					selfAc.moveRight = 1
					selfAc.moveLeft = 0
				elseif target.x < self.x - 8 then
					selfAc.moveLeft = 1
					selfAc.moveRight = 0
				else]]
					if (not Stage.collidesPoint(self.x - 15, self.y - 15) or (not Stage.collidesPoint(self.x - 35, self.y - 15) and not self:collidesMap(self.x - 2, self.y))) or obj.BNoSpawn:findLine(self.x, self.y, self.x + 130, self.y) and not obj.BNoSpawn:findLine(self.x, self.y, self.x - 130, self.y) then
						selfAc.moveLeft = 1
						selfAc.moveRight = 0
					elseif (not Stage.collidesPoint(self.x + 15, self.y - 15) or (not Stage.collidesPoint(self.x + 35, self.y - 15) and not self:collidesMap(self.x + 2, self.y))) or obj.BNoSpawn:findLine(self.x, self.y, self.x - 130, self.y) and not obj.BNoSpawn:findLine(self.x, self.y, self.x + 130, self.y) then
						selfAc.moveRight = 1
						selfAc.moveLeft = 0
					end
				--end
				--[[if selfAc.moveRight == 1 or selfAc.moveLeft == 1 then
					if Stage.collidesPoint(self.x + 15 * self.xscale, self.y + 4) and not Stage.collidesPoint(self.x, self.y + 20) then
						selfData.climb = nil
						self.angle = 0
						self.y = self.y + 3
						print("L")
					end
				end]]
				if not self:collidesMap(self.x, self.y - 5) then
					selfData.climb = selfData.lastClimb
					self.angle = 90 * (selfData.lastClimb or 0)
					--self.x = self.x + 1 * selfData.lastClimb
					selfData.lastClimb = nil
					selfData.releaseTimer = nil
					if self:collidesMap(self.x + 5, self.y - 5) then
						selfData.climb = 1
						--if not self:collidesMap(self.x - 2, self.y - 10) then
							self.y = self.y - 10
						--end
					elseif self:collidesMap(self.x - 5, self.y - 5) then
						selfData.climb = -1
						--if not self:collidesMap(self.x + 2, self.y - 10) then
							self.y = self.y - 10
						--end
					end
				end
			end
			
			local still = false
			local dir = 1
			
			if selfData.climb and selfData.climb ~= 0 then
				if target.y > self.y - 11 and target.y < self.y + 2 then still = true end
				if target.y > self.y + 10 then
					dir = -1
					if misc.getTimeStop() == 0 then
						for i = 1, selfAc.pHmax * 10 do
							if self:collidesMap(self.x, self.y + 0.1) then
								break
							else
								self.y = self.y + 0.1
							end
						end
					end
					--self.y = self.y + selfAc.pHmax
					if self:collidesMap(self.x, self.y + 7) then --Stage.collidesPoint(self.x, self.y + ((self.sprite.height - self.sprite.yorigin) * self.yscale) + 2) then
						selfData.climb = nil
						self.angle = 0
					end
				elseif not self:collidesMap(self.x + selfData.climb, self.y - 17) or target.y < self.y - 10 then
					if misc.getTimeStop() == 0 then
						for i = 1, selfAc.pHmax * 10 do
							if self:collidesMap(self.x, self.y - 0.1) then
								break
							else
								self.y = self.y - 0.1
							end
						end
					end
					--self.y = self.y - selfAc.pHmax
					if self:collidesMap(self.x, self.y - 2) then--Stage.collidesPoint(self.x, self.y - (self.sprite.yorigin * self.yscale) - 2) then -- self:collidesMap(self.x, self.y - 2) then
						selfData.lastClimb = selfData.climb
						--self.x = self.x + 10 * selfData.climb * -1
						selfData.climb = 0
						self.y = self.y + 1
						self.angle = 180
					end
				end
			end
			if selfAc.activity == 0 then
				self.sprite = self:getAnimation("walk")
				if misc.getTimeStop() == 0 and not still then
					selfData.animOverride = selfData.animOverride + (0.2 * selfAc.pHmax * dir) % self.sprite.frames
				end
				self.subimage = selfData.animOverride + 1
			end
		elseif target.y < self.y - 11 then
			if selfData.overrideRight then
				selfData.overrideRight = nil
				selfAc.moveRight = 1
				selfAc.moveLeft = 0
			elseif selfData.overrideLeft then
				selfData.overrideLeft = nil
				selfAc.moveLeft = 1
				selfAc.moveRight = 0
			end
			if selfAc.moveRight == 1 then --target.x > self.x then 
				if self:collidesMap(self.x + 2, self.y) then
					selfData.climb = 1
					selfAc.moveRight = 1
					selfAc.moveLeft = 0
					self.angle = 90
					self.y = self.y - 2
					self.x = self.x - 2
				elseif obj.BNoSpawn:findLine(self.x, self.y, self.x + 200, self.y) then
					selfData.overrideRight = true
					--selfAc.moveRight = 1
					--selfAc.moveLeft = 0
				end
			elseif selfAc.moveLeft == 1 then --target.x < self.x then
				if self:collidesMap(self.x - 2, self.y) then
					selfData.climb = -1
					selfAc.moveLeft = 1
					selfAc.moveRight = 0
					self.angle = -90
					self.y = self.y - 2
					self.x = self.x + 2
				elseif obj.BNoSpawn:findLine(self.x, self.y, self.x - 200, self.y) then
					selfData.overrideLeft = true
					--selfAc.moveLeft = 1
					--selfAc.moveRight = 0
				end
			end
		elseif selfData.climb then
			selfData.climb = nil
			self.angle = 0
		end
	end
	
	selfData.lastHp = selfAc.hp
	
	if self.sprite.id == selfAc.sprite_death then
		self.subimage = 1
	end
end)

mcard.Skewer = MonsterCard.new("Skewer", obj.Skewer)
mcard.Skewer.type = "classic"
mcard.Skewer.cost = 200
mcard.Skewer.sound = sSpawn
mcard.Skewer.sprite = sprSpawn
mcard.Skewer.isBoss = false
mcard.Skewer.canBlight = true