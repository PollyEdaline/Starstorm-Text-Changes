local stages = {}
stages.temple = stg.TempleoftheElders
stages.risk = stg.RiskofRain

local postLoopStages = {}
postLoopStages.desolate = stg.DesolateForest
postLoopStages.sky = stg.SkyMeadow
postLoopStages.sunken = stg.SunkenTombs

local path = "Actors/Gatekeeper/"

local sprMask = Sprite.load("GatekeeperMask", path.."Mask", 1, 16, 47)
local sprPalette = Sprite.load("GatekeeperPal", path.."Palette", 1, 0, 0)
local sprSpawn = Sprite.load("GatekeeperSpawn", path.."Spawn", 20, 37, 74)
local sprIdle = Sprite.load("GatekeeperIdle", path.."Idle_1", 1, 29, 63)
local sprIdleShield = Sprite.load("GatekeeperIdleShield", path.."Idle_2", 1, 29, 63)
local sprWalk = Sprite.load("GatekeeperWalk", path.."Walk_1", 6, 29, 63)
local sprShoot1_1 = Sprite.load("GatekeeperShoot1_1", path.."Shoot1_1", 7, 29, 63)
local sprShoot1_2 = Sprite.load("GatekeeperShoot1_2", path.."Shoot1_2", 17, 29, 63)
local sprShoot2_1 = Sprite.load("GatekeeperShoot2_1", path.."Shoot2_1", 5, 29, 63)
local sprShoot2_2 = Sprite.load("GatekeeperShoot2_2", path.."Shoot2_2", 5, 29, 63)
local sprDeath = Sprite.load("GatekeeperDeath", path.."Death", 7, 37, 74)
local sprPortrait = Sprite.load("GatekeeperPortrait", path.."Portrait", 1, 119, 119)
--local sprLogBook = Sprite.load("SandCrabLogBook", path.."LogBook", 5, 90, 20)
local sSpawn = Sound.load("GatekeeperSpawn", path.."Spawn")
local sLaserHit = Sound.load("GatekeeperLaserHit", path.."LaserHit")
local sLaserCharge = Sound.find("Drone1Spawn")--Sound.load("GatekeeperLaserCharge", path.."LaserCharge")
local sLaserFire = Sound.load("GatekeeperLaserFire", path.."LaserFire")
local sLaserFire2 = Sound.load("GatekeeperLaserFire2", path.."LaserFire2")
local sDeath = Sound.load("GatekeeperDeath", path.."Death")

obj.Gatekeeper = Object.base("EnemyClassic", "Gatekeeper")
obj.Gatekeeper.sprite = sprIdle

EliteType.registerPalette(sprPalette, obj.Gatekeeper)


local objGatekeeperLaser = Object.new("GatekeeperLaser")
objGatekeeperLaser.sprite = spr.Nothing
objGatekeeperLaser.depth = - 5
local sprLaserMask = Sprite.load("GatekeeperLaserMask", path.."LaserMask", 1, 3, 10)

local laserColor = Color.fromHex(0x83CDCD)

objGatekeeperLaser:addCallback("create", function(self)
	self.mask = sprLaserMask
	
	local n = 0
	while n < 100 and not self:collidesMap(self.x, self.y + 1) do
		self.y = self.y + 1
		n = n + 1
	end
	if n >= 100 then
		self.y = self.y - 16
	end
	self:getData().charge = 0
	self:getData().timer = 30
	
	self:getData().color = laserColor
end)
objGatekeeperLaser:addCallback("step", function(self)	
	local parent = self:getData().parent
	
	local n = 0
	while n < 100 and not self:collidesMap(self.x, self.y + 1) do
		self.y = self.y + 1
		n = n + 1
	end
	
	if self:getData().direction then
		self.x = self.x + self:getData().direction * 0.9
	end
	
	if self:getData().timer > 0 then
		self:getData().timer = self:getData().timer - 1
	else
		if misc.director:getAlarm(0) % 6 == 0 and parent and parent:isValid() then
			local explosion = parent:fireExplosion(self.x, self.y - 240, ((self:getData().charge * 0.15) + 4) / 19, 200 / 4, 1 * self:getData().charge * 0.005)
			explosion:getData().gk_laser = true
			parent:fireExplosion(self.x, self.y, 0, 0, 0)
		end
		
		local target = self:getData().target
		
		if self:getData().colorCheck == nil and parent and parent:isValid() then
			if parent:getElite() then
				self:getData().color = parent:getElite().color
			end
			self:getData().colorCheck = true
		end
		
		if self:getData().charge < 110 then
			self:getData().charge = self:getData().charge + 1
		else
			self:destroy()
		end
	end
end)
objGatekeeperLaser:addCallback("draw", function(self)
	if self:getData().timer > 0 then
		local width = self:getData().timer * 0.2
		
		graphics.color(Color.WHITE)
		graphics.alpha(0.3 + self:getData().timer * 0.01)
		graphics.rectangle(self.x - (width * 0.5), 0, self.x + (width * 0.5), self.y - 1, true)
	else
		local color = self:getData().color
		local parent = self:getData().parent
		
		local width = self:getData().charge * 0.2
		local alpha = math.min((110 - self:getData().charge) * 0.08, 1)
		
		--graphics.setBlendMode("normal")
		graphics.color(color)
		graphics.alpha(0.75 * alpha)
		graphics.rectangle(self.x - width, 0, self.x + width, self.y - 1)
		graphics.color(Color.WHITE)
		graphics.alpha(0.9 * alpha)
		graphics.rectangle(self.x - (width * 0.5), 0, self.x + (width * 0.5), self.y - 1)
	end
end)
table.insert(call.onHit, function(damager, hit)
	if damager:getData().gk_laser then
		if hit:isValid() and onScreen(hit) then
			sLaserHit:play(0.9 + math.random() * 0.2, 0.6)
			misc.shakeScreen(2)
		end
	end
end)

NPC.setSkill(obj.Gatekeeper, 1, 400, 60 * 4, nil, 0.16, function(actor)
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
				local laser = objGatekeeperLaser:create(target.x, target.y)
				laser:getData().parent = actor
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
				local xx = target.x - originx
				local yy = originy - target.y
				local angle = math.deg(math.atan2(yy, xx))
				local laserBullet = actor:fireBullet(originx, originy, angle, 10000, 1, spr.Sparks2, DAMAGER_BULLET_PIERCE)
				laserBullet:getData().gk_bullet = {p = actor, x = originx, y = originy}
			end
		
		elseif relevantFrame == 16 then
			sLaserFire2:play(0.9 + math.random() * 0.2, 0.6)
			local target = actorData.gk_targetting
			
			if target then
				local originx = actor.x + 18 * actor.xscale
				local originy = actor.y - 13
				local xx = target.x - originx
				local yy = originy - target.y
				local angle = math.deg(math.atan2(yy, xx))
				local laserBullet = actor:fireBullet(originx, originy, angle, 10000, 1, spr.Sparks2, DAMAGER_BULLET_PIERCE)
				laserBullet:getData().gk_bullet = {p = actor, x = originx, y = originy}
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

NPC.setSkill(obj.Gatekeeper, 2, 300, 60 * 7, nil, 0.15, function(actor)
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

obj.Gatekeeper:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Gatekeeper"
	selfAc.damage = 24 * Difficulty.getScaling("damage")
	selfAc.maxhp = 800 * Difficulty.getScaling("hp")
	selfAc.armor = 25
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 0.7
	selfAc.knockback_cap = selfAc.maxhp / 3
	selfAc.exp_worth = 52 * Difficulty.getScaling()
	selfAc.point_value = 780
	selfAc.can_drop = 0
	selfAc.can_jump = 0
	selfAc.sound_hit = sfx.GuardHit.id
	selfAc.hit_pitch = 0.9
	selfAc.sound_death = sDeath.id
	selfAc.sprite_palette = sprPalette.id
	selfAc.sprite_idle = sprIdle.id
	selfAc.sprite_walk = sprWalk.id
	selfAc.sprite_jump = sprIdle.id
	selfAc.sprite_death = sprDeath.id
	self:getData().attack_mode = 1
	self:getData().knockbackImmune = true
end)

obj.Gatekeeper:addCallback("step", function(self)
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
obj.Gatekeeper:addCallback("draw", function(self)
	local color = laserColor
	
	if self:getElite() then
		color = self:getElite().color
	end
	
	graphics.setBlendMode("additive")
	if self:getData().gk_targetting then
		local target = self:getData().gk_targetting
		if self.sprite == sprShoot1_2 then
			
			local yy = self.y - 18 * self.yscale
			
			local x, y = self.x, yy
			local i = 1
			local dis = distance(self.x, yy, target.x, target.y)
			
			while not Stage.collidesPoint(x, y) and i < dis do
				i = math.approach(i, dis, 6)
				x, y =  pointInLine(self.x, yy, target.x, target.y, i)
			end
			
			graphics.color(color)
			graphics.alpha(0.64)
			graphics.line(self.x, yy, x, y, 2)
			if i >= dis then
				graphics.circle(target.x, target.y, 3, true)
			end
			--graphics.circle(target.x, target.y, 5, true)
			--graphics.circle(target.x, target.y, 10, true)
		end
	end
	if self:getData().gk_bullethit and self:getData().gk_bullettimer then
		local bulletData = self:getData().gk_bullethit
		local timer = self:getData().gk_bullettimer
		
		graphics.color(color)
		graphics.alpha(0.5 * math.min(timer * 0.05, 1))
		graphics.line(bulletData.x1, bulletData.y1, bulletData.x2, bulletData.y2, 4)
	end
	graphics.setBlendMode("normal")
end)

table.insert(call.postStep, function()
	for _, actor in ipairs(obj.Gatekeeper:findAll()) do
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

table.insert(call.onImpact, function(damager, x, y)
	if damager:getData().gk_bullet then
		local bulletParent = damager:getData().gk_bullet
		
		if bulletParent and bulletParent.p:isValid() then
			bulletParent.p:getData().gk_bullethit = {x1 = x, y1 = y, x2 = bulletParent.x, y2 = bulletParent.y}
			bulletParent.p:getData().gk_bullettimer = 30
		end
	end
end)

mcard.Gatekeeper = MonsterCard.new("Gatekeeper", obj.Gatekeeper)
mcard.Gatekeeper.type = "classic"
mcard.Gatekeeper.cost = 780
mcard.Gatekeeper.sound = sSpawn
mcard.Gatekeeper.sprite = sprSpawn
mcard.Gatekeeper.isBoss = false
mcard.Gatekeeper.canBlight = false

mlog.Gatekeeper = MonsterLog.new("Gatekeeper")
MonsterLog.map[obj.Gatekeeper] = mlog.Gatekeeper
mlog.Gatekeeper.displayName = "Gatekeeper"
mlog.Gatekeeper.story = "Civilized constructs in this environment are scarce. Most creatures are completely feral, but the Gatekeepers are more advanced than most.\nThey have an impressive royal demeanor, protecting adorned teleporters and scaring fauna away. Unlike the Guards I found in the temple, their armor is remarkably tough. Their intelligence makes me doubt whether they are completely mechanical or some kind of hybrid.\n\nThey aren't easy to take down, hampering my progress. Defeating them is a major relief as, they can be extremely dangerous. They hunker down to defend themselves, shooting with extreme precision at any target in their vision.\n\nIf there is any way I can avoid having to confront them, I will take it. I can feel my chances of survival getting slimmer each time I see one..."
mlog.Gatekeeper.statHP = 800
mlog.Gatekeeper.statDamage = 24
mlog.Gatekeeper.statSpeed = 0.7
mlog.Gatekeeper.sprite = Sprite.load("GatekeeperLogbook", path.."Logbook", 20, 37, 54)
mlog.Gatekeeper.portrait = sprPortrait

for s, stage in pairs(stages) do
	stage.enemies:add(mcard.Gatekeeper)
end

table.insert(call.onStageEntry, function()
	if misc.director:get("stages_passed") > 4 then
		for _, stage in pairs(postLoopStages) do
			if not stage.enemies:contains(mcard.Gatekeeper) then
				stage.enemies:add(mcard.Gatekeeper)
			end
		end
	end
end)

callback.register("onGameStart", function()
	for _, stage in pairs(postLoopStages) do
		if stage.enemies:contains(mcard.Gatekeeper) then
			stage.enemies:remove(mcard.Gatekeeper)
		end
	end
end)