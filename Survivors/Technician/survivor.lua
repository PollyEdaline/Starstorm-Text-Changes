
-- All Technician data

local path = "Survivors/Technician/"

local technician = Survivor.new("Technician")

-- Sounds
local sShoot1a = Sound.load("Technician_Shoot1A", path.."skill1a")
local sShoot1b = Sound.load("Technician_Shoot1B", path.."skill1b")
local sShoot1Up = Sound.load("Technician_Shoot1UP", path.."skill1Up")

local sShoot2 = Sound.load("Technician_Shoot2", path.."skill2")
local sShoot2Ex = Sound.load("Technician_Shoot2EX", path.."skill2Ex")
local sShoot2Up = Sound.load("Technician_Shoot2UP", path.."skill2Up")
local sShoot2UpEx = Sound.load("Technician_Shoot2UPEX", path.."skill2UpEx")

local sSkill3 = Sound.load("Technician_Skill3", path.."skill3")
local sShoot3Up = Sound.load("Technician_Shoot3UP", path.."skill3Up")

local sShoot4 = Sound.load("Technician_Shoot4", path.."skill4")
local sShoot4Ex = Sound.load("Technician_Shoot4EX", path.."skill4Ex")
local sShoot4Up = Sound.load("Technician_Shoot4UP", path.."skill4Up")
local sTurretShoot = Sound.load("Technician_TurretShoot", path.."turretShoot")

-- Sprite Table
local sprites = {
	-- Right
	idle_1 = Sprite.load("Technician_IdleR", path.."idler", 1, 4, 6),
	walk_1 = Sprite.load("Technician_WalkR", path.."walkr", 8, 5, 7),
	jump_1 = Sprite.load("Technician_JumpR", path.."jumpr", 1, 4, 6),
	shoot1_1 = Sprite.load("Technician_Shoot1R", path.."shoot1r", 6, 6, 7),
	shoot2_1 = Sprite.load("Technician_Shoot2R", path.."shoot2r", 6, 6, 7),
	shoot3_1_1 = Sprite.load("Technician_Shoot3R", path.."shoot3r", 12, 6, 7),
	shoot3_1_2 = Sprite.load("Technician_Shoot3RW", path.."shoot3rw", 12, 6, 7),
	shoot4_1 = Sprite.load("Technician_Shoot4R", path.."shoot4r", 6, 4, 7),
	
	-- Left
	idle_2 = Sprite.load("Technician_IdleL", path.."idlel", 1, 4, 6),
	walk_2 = Sprite.load("Technician_WalkL", path.."walkl", 8, 4, 7),
	jump_2 = Sprite.load("Technician_JumpL", path.."jumpl", 1, 4, 6),
	shoot1_2 = Sprite.load("Technician_Shoot1L", path.."shoot1l", 6, 6, 7),
	shoot2_2 = Sprite.load("Technician_Shoot2L", path.."shoot2l", 6, 6, 7),
	shoot3_2_1 = Sprite.load("Technician_Shoot3L", path.."shoot3l", 12, 6, 7),
	shoot3_2_2 = Sprite.load("Technician_Shoot3LW", path.."shoot3lw", 12, 6, 7),
	shoot4_2 = Sprite.load("Technician_Shoot4L", path.."shoot4l", 6, 4, 7),
	
	death = Sprite.load("Technician_Death", path.."death", 5, 6, 7),
	climb = Sprite.load("Technician_Climb", path.."climb", 2, 3, 7),
	decoy = Sprite.load("Technician_Decoy", path.."decoy", 1, 9, 12),
	
	-- Objects
	mine1 = Sprite.load("TechnicianMineA", path.."minea", 6, 5, 8),
	mine2 = Sprite.load("TechnicianMineB", path.."mineb", 6, 5, 8),
	
	vending1 = Sprite.load("TechnicianVendingA", path.."shoot3ma", 10, 5, 17),
	vending2 = Sprite.load("TechnicianVendingB", path.."shoot3mb", 10, 5, 17),
	
	turret1_1 = Sprite.load("TechnicianTurretA", path.."turreta", 2, 7, 7),
	turret1_2 = Sprite.load("TechnicianTurretA_Shoot", path.."turretashoot", 4, 7, 7),
	
	turret2_1 = Sprite.load("TechnicianTurretB", path.."turretb", 2, 8, 9),
	turret2_2 = Sprite.load("TechnicianTurretB_Shoot", path.."turretbshoot", 4, 9, 9),
	
	turret3_1 = Sprite.load("TechnicianTurretC", path.."turretc", 2, 8, 9),
	turret3_2 = Sprite.load("TechnicianTurretC_Shoot", path.."turretcshoot", 4, 9, 9),
}
-- Hit sprites
local sprTurretsparks = Sprite.load("TechnicianTurret_Sparks", path.."turretsparks", 3, 13, 8)
-- Skill sprites
local sprSkills = Sprite.load("Technician_Skills", path.."skills", 6, 0, 0)

-- Selection sprite
technician.loadoutSprite = Sprite.load("Technician_Select", path.."select", 15, 2, 0)

-- Selection description
technician:setLoadoutInfo(
[[The &y&Technician&!& is incredibly skilled at handling high-tech devices.
While fixing robot janitors is the daily routine for the Technician,
deploying turrets and drinking energy drinks is what he loves the most.
Set up and upgrade your gadgets to make the most of any situation.]], sprSkills)

-- Skill descriptions
technician:setLoadoutSkill(1, "Troubleshoot",
[[Throw a wrench which pierces enemies for &y&150% damage&!&.
Hitting &y&gadgets&!& three times &b&upgrades them&!&.]])

technician:setLoadoutSkill(2, "Forced Shutdown",
[[Drop a &y&bomb&!& which deals &y&700% damage&!& on manual detonation.
&b&Upgraded:&!& &y&Stuns and pulls enemies for 400% damage&!& on detonation.]])

technician:setLoadoutSkill(3, "24/7 Energy",
[[Deploy a vending machine which grants a &b&move&!& and &y&attack speed boost&!& when used.
&b&Upgraded:&!& Also grants &y&Critical Strike chance&!&.]])

technician:setLoadoutSkill(4, "Backup Firewall",
[[Place a stationary drone turret that fires in the direction it was built for &y&70% damag&!&.
&b&Upgraded:&!& Fires for &y&80% damage&!&.]])

-- Color of highlights during selection
technician.loadoutColor = Color.fromRGB(107,173,186)

-- Misc. menus sprite
technician.idleSprite = sprites.idle_1

-- Main menu sprite
technician.titleSprite = sprites.walk_1

-- Endquote
technician.endingQuote = "..and so he left, by turning the whole ship off and on again."

registercallback("onPlayerStep", function(player)
	if player:getSurvivor() == technician then
		if player:getFacingDirection() == 0 then
			player:setAnimation("idle", player:getAnimation("idle_1"))
			player:setAnimation("walk", player:getAnimation("walk_1"))
			player:setAnimation("jump", player:getAnimation("jump_1"))
		else
			player:setAnimation("idle", player:getAnimation("idle_2"))
			player:setAnimation("walk", player:getAnimation("walk_2"))
			player:setAnimation("jump", player:getAnimation("jump_2"))
		end
	end
end)

-- Stats & Skills
technician:addCallback("init", function(player)
	local playerAc = player:getAccessor()
	
	player:setAnimations(sprites)
	
	if Difficulty.getActive() == dif.Drizzle then
		player:survivorSetInitialStats(152, 11, 0.041)
	else
		player:survivorSetInitialStats(102, 11, 0.011)
	end
	
	player:setSkill(1, "Troubleshoot", "Throw a piercing wrench for 150% damage. Can upgrade gadgets.",
	sprSkills, 1, 45)
		
	player:setSkill(2, "Forced Shutdown", "Drop a bomb which deals 700% damage on detonation. Upgraded: Stuns and pulls nearby enemies for 400% damage.",
	sprSkills, 2, 3 * 60)
		
	player:setSkill(3, "24/7 Energy", "Deploy a vending machine which grants a move and attack speed boost. Upgraded: Also grants Critical Strike chance.",
	sprSkills, 3, 12 * 60)
		
	player:setSkill(4, "Backup Firewall", "Place a turret that fires forward for 70% damage. Upgraded: Deals 80% damage.",
	sprSkills, 4, 7 * 60)
end)

-- Called when the player levels up
technician:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(29, 3, 0.0018, 2)
end)

-- Called when the player picks up the Ancient Scepter
technician:addCallback("scepter", function(player)
	player:setSkill(4,
	"Backup Firewall 2.0", "Place an upgraded turret that fires forward rapidly for 350% damage per second. Upgraded: Launches missiles.", 
	sprSkills, 5, 5 * 60)
	if player:getData().activeTurret and player:getData().activeTurret:isValid() then
		player:getData().activeTurret:getData().scepter = true
	end
end)

-- Skills

-- Wrench Object
local objWrench = Object.new("Technician_Wrench")
local sprWrench = Sprite.load("TechnicianWrench", path.."wrench", 8, 5, 5)
local sprWrenchMask = Sprite.load("TechnicianWrenchMask", path.."wrenchmask", 1, 4, 4)

objWrench.sprite = sprWrench
objWrench.depth = 0.1

objWrench:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self:getData().life = 170
	self:getData().team = "player"
	self:getData().hitEnemies = {}
	self:getData().hitEnemyCount = 0
	self:getData().speed = 3
	self:getData().damage = 1.5
	self.spriteSpeed = 0.25
	self.mask = sprWrenchMask
end)
objWrench:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	
	if selfAc.direction == 0 then
		self.x = self.x + self:getData().speed
	else
		self.x = self.x - self:getData().speed
	end
	
	local parent = self:getData().parent
	
	if parent and parent:isValid() then
		local r = 3.5 * self.xscale
		for _, actor in ipairs(pobj.actors:findAllRectangle(self.x - r, self.y - r, self.x + r, self.y + r)) do
			if actor:get("team") ~= self:getData().team and self:collidesWith(actor, self.x, self.y) and not self:getData().hitEnemies[actor] then
				if global.quality > 1 then
					par.Spark:burst("middle", self.x, self.y, 2)
				end
				sShoot1b:play(1 + math.random() * 0.2)
				self:getData().hitEnemies[actor] = true
				self:getData().hitEnemyCount = self:getData().hitEnemyCount + 1
				for i = 0, parent:get("sp") do
					damage = parent:fireExplosion(self.x, self.y, 8 / 19, 8 / 4, self:getData().damage, nil, nil)
					if i ~= 0 then
						damage:set("climb", i * 8)
					end
				end
			end
		end
	end
	
	if self:getData().life == 0 or self:getData().hitEnemies and self:getData().hitEnemyCount >= 3 or Stage.collidesPoint(self.x, self.y) then
		if Stage.collidesPoint(self.x, self.y) and onScreen(self) then
			sShoot1b:play(1 + math.random() * 0.2)
		end
		if global.quality > 1 and self.visible then
			par.Spark:burst("middle", self.x, self.y, 4)
		end
		self:destroy()
	else
		self:getData().life = self:getData().life - 1
	end
end)

-- Mine Object
local objMine = Object.new("Technician_Mine")
local sprMineMask = Sprite.load("TechnicianMineMask", path.."minemask", 1, 5, 5)
local sprExplosion = Sprite.load("TechnicianMineEX", path.."mineexplosion", 5, 55, 32)

objMine.sprite = sprites.mine1
objMine.depth = 13

objMine:addCallback("create", function(mine)
	local mineAc = mine:getAccessor()
	mine:set("team", "player")
	mine:getData().life = 110
	mine:getData().timer = 0
	mine:getData().counter = 0
	mine:getData().acc = 0
	mine:getData().initspeed = 4
	mine.spriteSpeed = 0.2
	mine.mask = sprMineMask
end)
objMine:addCallback("step", function(mine)
	local mineAc = mine:getAccessor()
	local wrench = objWrench:findNearest(mine.x, mine.y)
	local enemy = pobj.enemies:findNearest(mine.x, mine.y)
	local parent = mine:getData().parent
	
	local data = mine:getData()
	
	if wrench and mine:collidesWith(wrench, mine.x, mine.y) and data.timer == 0 then
		data.timer = 8
		data.counter = data.counter + 1
		if data.counter <= 3 then
			--data.life = 100
			sShoot1Up:play(1 + math.random() * 0.2)
			if global.quality > 1 then
				par.Spark:burst("middle", mine.x, mine.y, 4)
			end
		end
		if data.counter == 3 then
			--data.life = 380
			sShoot2Up:play(1 + math.random() * 0.2)
			mine.sprite = sprites.mine2
			if parent then
				mine.sprite = parent:getAnimation("mine2")
			end
		end
	end
	
	if data.initspeed > 0 and not mine:collidesMap(mine.x, mine.y) then
		if enemy and mine:collidesWith(enemy, mine.x, mine.y) then
			data.initspeed = 0
			data.acc = 0
		end
		if mineAc.direction == 0 then
			mine.x = mine.x + data.initspeed
		else
			mine.x = mine.x - data.initspeed
		end
		data.initspeed = data.initspeed * 0.9
	end
	
	if mine:collidesMap(mine.x, mine.y + 1) then
		data.acc = 0
	else
		data.acc = data.acc + 0.1
		mine.y = mine.y + data.acc
	end
	
	if mine:collidesMap(mine.x, mine.y) then
		mine.y = mine.y - 1
		data.initspeed = 0
		if not mine:collidesMap(mine.x - 2, mine.y) then
			mine.x = mine.x - 2
		elseif not mine:collidesMap(mine.x + 2, mine.y) then
			mine.x = mine.x + 2
		end
	end
	
	if data.timer > 0 then
		data.timer = data.timer - 1
	end
	
	if data.life > 0 and parent and parent:isValid() then
		if parent:getData().childMine ~= mine or parent:get("dead") ~= 0 then
			data.life = 0
		end
		--data.life = data.life - 1
		
		if data.counter >= 3 then
			for _, actor in ipairs(pobj.actors:findAllEllipse(mine.x - 55, mine.y - 55, mine.x + 55, mine.y + 55)) do
				local dis = distance(actor.x, actor.y, mine.x, mine.y)
				local speed = math.min((60 - dis) * 0.05, 1.4 * parent:get("attack_speed"))
				
				if actor:get("team") ~= mine:get("team") and not actor:isBoss() then
					actor.x = math.approach(actor.x, mine.x, speed)
					actor.y = math.approach(actor.y, mine.y, speed)
					if actor:isClassic() then
						local n = 0
						while actor:collidesMap(actor.x, actor.y) and n < 20 do
							actor.y = actor.y - 1
							n = n + 1
						end
						n = 0
						while actor:collidesMap(actor.x - 1, actor.y) and n < 30 do
							actor.x = actor.x + 1
							n = n + 1
						end
						n = 0
						while actor:collidesMap(actor.x + 1, actor.y) and n < 30 do
							actor.x = actor.x - 1
							n = n + 1
						end
					end
				end
			end
		end
		
	else
		if global.quality > 1 then
			par.Spark:burst("middle", mine.x, mine.y, 4)
		end
		if data.counter >= 3 then
			misc.shakeScreen(5)
			sShoot2UpEx:play(1 + math.random() * 0.2)
			if parent and parent:isValid() then
				for i = 0, parent:get("sp") do
					local explosion = parent:fireExplosion(mine.x, mine.y, 55 / 19, 55 / 4, 7, sprExplosion, nil)
					explosion:set("knockback", 3)
					explosion:set("stun", 0.8)
					if i ~= 0 then
						explosion:set("climb", i * 8)
					end
				end
			end
		else
			misc.shakeScreen(2)
			sShoot2Ex:play(1 + math.random() * 0.2)
			if parent and parent:isValid() then
				for i = 0, parent:get("sp") do
					local explosion = parent:fireExplosion(mine.x, mine.y, 35 / 19, 35 / 4, 7, sprExplosion, nil)
					explosion:getData().blast = true
					explosion:set("knockback", 6)
					if i ~= 0 then
						explosion:set("climb", i * 8)
					end
				end
			end
		end
		mine:destroy()
	end
end)
local onDrawCall = function()
	for _, mine in ipairs(objMine:findAll()) do
		local mineAc = mine:getAccessor()
		if mine:getData().drawCounter then
			mine:getData().drawCounter = mine:getData().drawCounter + 0.1
			if mine:getData().counter >= 3 then
				graphics.alpha((0.2 * math.sin(mine:getData().drawCounter)) + 0.4)
				graphics.color(Color.AQUA)
				local size = math.atan(-mine:getData().drawCounter % math.pi) * 55
				graphics.circle(mine.x, mine.y, size, true)
			else
				graphics.alpha((0.3 * math.sin(mine:getData().drawCounter)) + 0.4)
				graphics.color(Color.RED)
				graphics.circle(mine.x, mine.y, 35, true)
			end
		else 
			mine:getData().drawCounter = 0
		end
	end
end
table.insert(call.onHit, function(damager, hit)
	if damager:getData().blast then
		if damager:get("damage") >= hit:get("hp") then
			hit:set("blast", 1)
		end
	end
end)

-- Vending Machine Object
local objVending = Object.new("Technician_Vending")
objVending.sprite = sprites.vending1

objVending.depth = 3

local vrange = 10
objVending:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.life = 120 * 60
	selfData.timer = 0
	selfData.acc = 0
	selfData.team = "player"
	selfData.damage = 10
	selfData.utimer = 0
	selfData.counter = 0
	self.spriteSpeed = 0
	obj.EfFlash:create(0,0):set("parent", self.id):set("rate", 0.08)
end)
objVending:addCallback("step", function(self)
	local selfData = self:getData()
	selfData.life = selfData.life - 1
	self.alpha = selfData.life * 0.1
	
	local wrench = objWrench:findNearest(self.x, self.y)
	
	if wrench and self:collidesWith(wrench, self.x, self.y) and selfData.utimer == 0 and selfData.counter < 3 then
		selfData.utimer = 8
		selfData.counter = selfData.counter + 1
		if selfData.counter <= 3 then
			sShoot1Up:play(1 + math.random() * 0.2)
			if global.quality > 1 then
				par.Spark:burst("middle", self.x, self.y, 4)
			end
		end
		if selfData.counter == 3 then
			sShoot3Up:play(0.9 + math.random() * 0.2)
			self.sprite = sprites.vending2
			if parent then
				self.sprite = parent:getAnimation("vending2")
			end
		end
	end
	
	if selfData.utimer > 0 then
		selfData.utimer = selfData.utimer - 1
	end
	
	if selfData.parent and selfData.parent:isValid() and selfData.parent:getData().currentVending ~= self and selfData.life > 10 then
		selfData.life = 10
	end
	
	if selfData.timer == 0 then
		for _, player in ipairs(obj.P:findAllEllipse(self.x - vrange, self.y - vrange, self.x + vrange, self.y + vrange)) do
			if player:get("dead") == 0 and player:get("team") == selfData.team and not player:hasBuff(buff.hydrated1) and not player:hasBuff(buff.hydrated2) then
				if selfData.counter == 3 then
					sSkill3:play(0.8 + math.random() * 0.2)
					applySyncedBuff(player, buff.hydrated2, 320, true)
					selfData.timer = 40
				else
					sSkill3:play(0.9 + math.random() * 0.2)
					applySyncedBuff(player, buff.hydrated1, 280, true)
					selfData.timer = 60
				end
				self.spriteSpeed = 0.2
				break
			end
		end
	else
		selfData.timer = selfData.timer - 1
	end
	
	if self.subimage >= 10 then
		self.subimage = 1
		self.spriteSpeed = 0
	end
	
	if self:collidesMap(self.x, self.y) then
		if not self:collidesMap(self.x, self.y + 7) then
			self.y = self.y + 7
		elseif not self:collidesMap(self.x - 4, self.y) then
			self.x = self.x - 4
		elseif not self:collidesMap(self.x + 4, self.y) then
			self.x = self.x + 4
		else
			self.y = self.y - 1
		end
	elseif not self:collidesMap(self.x, self.y + 1) then
		selfData.acc = selfData.acc + 0.1
		self.y = self.y + selfData.acc
	else
		if selfData.acc > 3 then
			misc.shakeScreen(selfData.acc)
			sfx.GiantJellyExplosion:play(0.9 + math.random() * 0.2, 0.6)
			misc.fireExplosion(self.x, self.y, 40 / 19, 10 / 4, selfData.damage * 3 * (selfData.acc - 1), selfData.team, nil, spr.Sparks1):getData().vendingImpact = selfData.parent
		end
		selfData.acc = 0
	end
	if selfData.life == 0 then
		self:destroy()
	end
end)
objVending:addCallback("destroy", function(self)
	local selfData = self:getData()
end)

-- Turret Object
local objTurret = Object.new("Technician_Turret")
local sprTurretExplosion = Sprite.load("TechnicianTurretEX", path.."turretexplosion", 4, 10, 10)

objTurret.sprite = sprites.turret1_1
objTurret.depth = 1

objTurret:addCallback("create", function(self)
	--local selfAc = self:getAccessor()
	local selfData = self:getData()
	selfData.timer = 0
	selfData.fireTimer = 0
	selfData.animTimer = 0
	selfData.counter = 0
	selfData.direction = 0
	selfData.mc = 0
	self.spriteSpeed = 0.2
	if selfData.parent then
		self.sprite = parent:getAnimation("turret1_1")
	end
end)
objTurret:addCallback("step", function(self)
	local turretAc = self:getAccessor()
	local selfData = self:getData()
	local parent = selfData.parent
	local wrench = objWrench:findNearest(self.x, self.y)
	if selfData.direction ~= 0 then
		self.xscale = -1
	end
	
	if wrench and self:collidesWith(wrench, self.x, self.y) and selfData.timer == 0 then
		selfData.timer = 8
		selfData.counter = selfData.counter + 1
		if selfData.counter == 3 then
			sShoot4Up:play(1 + math.random() * 0.2)
			self.sprite = sprites.turret2_1
			if parent and parent:isValid() then
				self.sprite = parent:getAnimation("turret2_1")
			end
		end
		if selfData.counter <= 3 or selfData.scepter and selfData.counter <= 6 then
			sShoot1Up:play(1 + math.random() * 0.2)
			if global.quality > 1 then
				par.Spark:burst("middle", self.x, self.y, 4)
			end
		end
		if selfData.counter == 6 and selfData.scepter then
			sShoot1Up:play(0.8 + math.random() * 0.2)
			self.sprite = sprites.turret3_1
			if parent and parent:isValid() then
				self.sprite = parent:getAnimation("turret3_1")
			end
		end
	end

	if turretAc.drawCounter then
		turretAc.drawCounter = turretAc.drawCounter + 0.1
		self.y = self.y + 0.1 * math.cos(turretAc.drawCounter)
	else 
		turretAc.drawCounter = 0
	end
	
	if selfData.timer > 0 then
		selfData.timer = selfData.timer - 1
	end
	if selfData.fireTimer > 0 then
		selfData.fireTimer = selfData.fireTimer - 1
	end
	if selfData.animTimer > 0 then
		selfData.animTimer = selfData.animTimer - 1
	else
		if selfData.counter >= 6 and selfData.scepter then
			self.sprite = sprites.turret3_1
			if parent and parent:isValid() then
				self.sprite = parent:getAnimation("turret3_1")
			end
		elseif selfData.counter >= 3 then
			self.sprite = sprites.turret2_1
			if parent and parent:isValid() then
				self.sprite = parent:getAnimation("turret2_1")
			end
		else
			self.sprite = sprites.turret1_1
			if parent and parent:isValid() then
				self.sprite = parent:getAnimation("turret1_1")
			end
		end
	end
	
	if parent and parent:isValid() and parent:getData().activeTurret == self and parent:get("dead") == 0 then
		if selfData.fireTimer == 0 then
			for _, enemy in ipairs(pobj.enemies:findAllLine(self.x, self.y, self.x + 500 - (1000 * math.sign(selfData.direction)), self.y)) do
				if enemy:get("team") ~= parent:get("team") then
					sTurretShoot:play(1 + math.random() * 0.2)
					if selfData.counter >= 6 and selfData.scepter then
						self.sprite = sprites.turret3_2
						if parent then
							self.sprite = parent:getAnimation("turret3_2")
						end
						selfData.fireTimer = 11
						local bullet = parent:fireBullet(self.x, self.y + 2, selfData.direction, 500, 0.7, sprTurretsparks)
						bullet:set("knockback", 1)
						selfData.mc = selfData.mc + 1
						if selfData.mc % 4 == 0 then
							obj.EfMissile:create(self.x + 5 * self.xscale, self.y):set("parent", parent.id):set("damage", parent:get("damage"))
						end
					elseif selfData.counter >= 3 then
						self.sprite = sprites.turret2_2
						if parent then
							self.sprite = parent:getAnimation("turret2_2")
						end
						selfData.fireTimer = 12
						local bullet = parent:fireBullet(self.x, self.y + 2, selfData.direction, 500, 0.7, sprTurretsparks)
						bullet:set("knockback", 1)
					else
						self.sprite = sprites.turret1_2
						if parent then
							self.sprite = parent:getAnimation("turret1_2")
						end
						selfData.fireTimer = 50
						local bullet = parent:fireBullet(self.x, self.y + 2, selfData.direction, 500, 1.8, sprTurretsparks)
						bullet:set("knockback", 2)
					end
					self.subimage = 1
					selfData.animTimer = 12
					break
				end
			end
		end
	else
		if global.quality > 1 then
			par.Spark:burst("middle", self.x, self.y, 5)
		end
		if onScreen(self) then
			sShoot4Ex:play(1 + math.random() * 0.2)
		end
		if parent and parent:isValid() then
			parent:fireExplosion(self.x, self.y, 5 / 19, 5 / 5, 0.5, sprTurretExplosion, nil)
		end
		self:destroy()
	end
end)
local onHUDDrawCall = function()
	for _, turret in ipairs(objTurret:findAll()) do
		local parent = turret:getData().parent
		if parent and parent:isValid() then
		
			local playerIndex = 1
			
			for p, player in ipairs(misc.players) do
				if player == parent then
					playerIndex = p
					break
				end
			end
			
			graphics.color(playerColor(parent, playerIndex))
			
			if not net.online or net.localPlayer == parent then
				drawOutOfScreen(turret)
			end
			
		end
	end
end

local onStageEntryCall = function()
	for _, player in ipairs(misc.players) do
		if player:getSurvivor() == technician then
			player:setSkill(2, "Forced Shutdown", "Drop a bomb which deals 700% damage on detonation. Upgraded: Stuns and pulls nearby enemies for 400% damage.",
			sprSkills, 2, 3 * 60)
		end
	end
end

-- Skill Activation

technician:addCallback("useSkill", function(player, skill)
	local playerAc = player:getAccessor()
	if player:get("activity") == 0 then
		if player:getFacingDirection() == 0 then
			if skill == 1 then
				-- Z skill
				player:survivorActivityState(1, player:getAnimation("shoot1_1"), 0.22, true, true)
			elseif skill == 2 then
				-- X skill
				if player:getData().childMine and player:getData().childMine:isValid() then
					player:getData().childMine = nil
					player:setSkill(2, "Forced Shutdown", "Drop a bomb which deals 700% damage on detonation. Upgraded: Stuns and pulls nearby enemies for 400% damage.",
					sprSkills, 2, 3 * 60)
				else
					player:survivorActivityState(2, player:getAnimation("shoot2_1"), 0.2, true, true)
					player:setSkill(2, "The Red Button", "Detonate the dropped bomb for 700% damage.",
					sprSkills, 6, 30)
				end
			elseif skill == 3 then
				-- C skill
				if playerAc.pHspeed ~= 0 then
					player:survivorActivityState(3, player:getAnimation("shoot3_1_2"), 0.25, false, false)
				else
					player:survivorActivityState(3, player:getAnimation("shoot3_1_1"), 0.25, false, false)
				end
			elseif skill == 4 then
				-- V skill
				player:survivorActivityState(4, player:getAnimation("shoot4_1"), 0.25, false, true)
			end
		else
			if skill == 1 then
				-- Z skill
				player:survivorActivityState(1, player:getAnimation("shoot1_2"), 0.22, true, true)
			elseif skill == 2 then
				-- X skill
				if player:getData().childMine and player:getData().childMine:isValid() then
					player:getData().childMine = nil
					player:setSkill(2, "Forced Shutdown", "Drop a bomb which deals 700% damage on detonation. Upgraded: Stuns and pulls nearby enemies for 400% damage.",
					sprSkills, 2, 3 * 60)
				else
					player:survivorActivityState(2, player:getAnimation("shoot2_2"), 0.2, true, true)
					player:setSkill(2, "The Red Button", "Detonate the dropped bomb for 700% damage.",
					sprSkills, 6, 30)
				end
			elseif skill == 3 then
				-- C skill
				if playerAc.pHspeed ~= 0 then
					player:survivorActivityState(3, player:getAnimation("shoot3_2_2"), 0.25, false, false)
				else
					player:survivorActivityState(3, player:getAnimation("shoot3_2_1"), 0.25, false, false)
				end
			elseif skill == 4 then
				-- V skill
				player:survivorActivityState(4, player:getAnimation("shoot4_2"), 0.25, false, true)
			end
		end
		player:activateSkillCooldown(skill)
	end
end)
-- nice code, neik
technician:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	
	if skill == 1 and not player:getData().skin_skill1Override then
		-- Troubleshoot
		if relevantFrame == 3 then
			sShoot1a:play(0.9 + math.random() * 0.2)
			if player:survivorFireHeavenCracker(1.3) == nil then
				local wrench = objWrench:create(player.x, player.y)
				wrench:set("direction", player:getFacingDirection())
				wrench:getData().parent = player
				wrench:getData().team = playerAc.team
			end
		end
		
	elseif skill == 2 and not player:getData().skin_skill2Override then
		-- Forced Shutdown
		if relevantFrame == 3 then
			sShoot2:play(0.9 + math.random() * 0.2)
			local mine = objMine:create(player.x + player.xscale * -1, player.y)
			player:getData().childMine = mine
			mine:set("team", playerAc.team)
			mine:set("direction", player:getFacingDirection())
			mine:getData().parent = player
			mine.sprite = player:getAnimation("mine1")
		end
	elseif skill == 3 and not player:getData().skin_skill3Override then
        -- 24/7 Energy
        if relevantFrame == 1 then
			local v = objVending:create(player.x, player.y + 5)
			local vd = v:getData()
			vd.team = playerAc.team
			vd.damage = playerAc.damage
			vd.parent = player
			player:getData().currentVending = v
			--sSkill3:play(0.9 + math.random() * 0.2)
        elseif relevantFrame == 8 then
			--player:applyBuff(buff.hydrated1, 230)
		end

	elseif skill == 4 and not player:getData().skin_skill4Override then
		-- Backup Firewall
		if relevantFrame == 4 then
			if playerAc.scepter > 0 then
				sShoot4Up:play(0.9 + math.random() * 0.2)
				local turret = objTurret:create(player.x, player.y - 5)
				local turretData = turret:getData()
				turretData.direction = player:getFacingDirection()
				turretData.parent = player
				turretData.counter = 3
				turretData.scepter = true
				player:getData().activeTurret = turret
			else
				sShoot4:play(0.9 + math.random() * 0.2)
				local turret = objTurret:create(player.x + 5 * player.xscale, player.y - 4)
				local turretData = turret:getData()
				turretData.direction = player:getFacingDirection()
				turretData.parent = player
				player:getData().activeTurret = turret
			end
		end
	end
end)

technician:addCallback("init", function(player)
	tcallback.register("onDraw", onDrawCall)
	tcallback.register("onHUDDraw", onHUDDrawCall)
	tcallback.register("onStageEntry", onStageEntryCall)
end)

sur.Technician = technician