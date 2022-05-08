
-- All Pyro data

local path = "Survivors/Pyro/"

local pyro = Survivor.new("Pyro")

-- Sounds
local sPyroSkill3 = Sound.load("PyroSkill3", path.."skill3")
local sPyroSkill4 = Sound.load("PyroSkill4", path.."skill4")
local sPyroBullet = Sound.load("PyroBullet", path.."bulletImpact")
local sPyroBulletH = Sound.load("PyroBulletH", path.."bullethImpact")

par.PyroJump = ParticleType.new("PyroJump")
par.PyroJump:sprite(spr.EfFirey, true, true, false)
par.PyroJump:color(Color.WHITE, Color.WHITE, Color.BLACK)
par.PyroJump:alpha(1, 1)
par.PyroJump:size(0.55, 1, -0.002, 0.1)
par.PyroJump:speed(0.1, 0.2, -0.01, 0.1)
par.PyroJump:angle(0, 360, 0, 4, true)
par.PyroJump:direction(75, 105, 0, 2)
par.PyroJump:gravity(0.01, 90)
par.PyroJump:life(40, 70)

spr.EfFireyBlue = Sprite.load("EfFireyBlue", path.."EfFireyBlue", 7, 2, 5)

par.PyroBullet2 = ParticleType.new("PyroBullet2")
par.PyroBullet2:sprite(spr.EfFireyBlue, true, true, false)
par.PyroBullet2:color(Color.WHITE, Color.WHITE, Color.BLACK)
par.PyroBullet2:alpha(1, 1)
par.PyroBullet2:size(0.25, 0.6, -0.002, 0.1)
par.PyroBullet2:speed(0.05, 0.1, -0.01, 0.1)
par.PyroBullet2:angle(0, 360, 0, 4, true)
par.PyroBullet2:direction(75, 105, 0, 2)
par.PyroBullet2:gravity(0.01, 90)
par.PyroBullet2:life(40, 70)

par.PyroBullet = ParticleType.new("PyroBullet")
par.PyroBullet:sprite(spr.EfFirey, true, true, false)
par.PyroBullet:color(Color.WHITE, Color.WHITE, Color.BLACK)
par.PyroBullet:alpha(1, 1)
par.PyroBullet:size(0.25, 0.6, -0.002, 0.1)
par.PyroBullet:speed(0.05, 0.1, -0.01, 0.1)
par.PyroBullet:angle(0, 360, 0, 4, true)
par.PyroBullet:direction(75, 105, 0, 2)
par.PyroBullet:gravity(0.01, 90)
par.PyroBullet:life(40, 70)


-- Color of highlights during selection
pyro.loadoutColor = Color.fromHex(0xD78326)

-- Table sprites
local sprites = {
	idle = Sprite.load("Pyro_Idle", path.."idle", 5, 4, 6),
	walk = Sprite.load("Pyro_Walk", path.."walk", 8, 8, 6),
	walkShoot = Sprite.load("Pyro_WalkShoot", path.."walkShoot", 8, 8, 7),
	jump = Sprite.load("Pyro_Jump", path.."jump", 5, 4, 6),
	climb = Sprite.load("Pyro_Climb", path.."climb", 2, 4, 7),
	death = Sprite.load("Pyro_Death", path.."death", 9, 10, 14),
	decoy = Sprite.load("Pyro_Decoy", path.."decoy", 1, 9, 11),
	
	shoot1 = Sprite.load("Pyro_Shoot1", path.."shoot1", 3, 7, 6),
	shoot3 = Sprite.load("Pyro_Shoot3", path.."shoot3", 5, 11, 6),
	shoot4 = Sprite.load("Pyro_Shoot4", path.."shoot4", 6, 10, 13),
	
	fire1 = Sprite.find("PyroFire", "Vanilla"),
	fire2 = Sprite.find("PyroFire2", "Vanilla"),
	
	heatBar = Sprite.load("Pyro_Bar", path.."heatBar", 2, 14, 10),
}

-- Skill sprites
local sprSkills = Sprite.load("Pyro_Skills", path.."skills", 5, 0, 0)

-- Selection sprite
pyro.loadoutSprite = Sprite.load("Pyro_Select", path.."select", 14, 2, 0)

-- Selection description
pyro:setLoadoutInfo(
[[The &y&Pyro&!& uses heat to his advantage. Equipped with a flamethrower,
&y&scorch&!& enemies to build up his heat gauge, as with high heat levels, other abilities
are empowered. The Pyro is also able to distance himself from threats with &y&Suppressive Fire&!&, 
while clearing groups of enemies with &y&Blazeborne&!&.]], sprSkills)

-- Skill descriptions

pyro:setLoadoutSkill(1, "Scorch",
[[Heat up by burning nearby enemies for &y&40% damage&!&.
]] .. colorString("High heat sets enemies on fire,", pyro.loadoutColor) .. [[ dealing &!&damage over time&!&.]])

pyro:setLoadoutSkill(2, [["Suppressive Fire"]],
colorString("Consume heat ", pyro.loadoutColor) .. [[by burning enemies for &y&80% damage, pushing them back&!&.
]] .. colorString("High heat applies extra damage.", pyro.loadoutColor).." &y&Always sets enemies on fire&!&.")

pyro:setLoadoutSkill(3, "Plan B",
[[&b&Launch yourself forward at low heat levels&!&.
]] .. colorString("Heat launches you upward instead.", pyro.loadoutColor))

pyro:setLoadoutSkill(4, "Blazeborne",
[[Launch heat pellets that &y&deal &y&150% damage and set enemies on fire&!&.
]] .. colorString("Higher heat levels yield more fire pellets,", pyro.loadoutColor) .. [[ up to 8.
Burning enemies return pellets that ]] .. colorString("heat", pyro.loadoutColor) .. " and &g&heal&!& you on contact.")

-- Misc. menus sprite
pyro.idleSprite = sprites.idle

-- Main menu sprite
pyro.titleSprite = sprites.walk

-- Endquote
pyro.endingQuote = "..and so he left, with something rumbling in his stomach."

pyro:addCallback("init", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	playerData._flight = false
	playerData.heat = 0
	playerData.maxHeat = 100
	playerData.particleBig = par.PyroJump
	playerData.particleSmall = par.PyroBullet
	playerData.particleSmall2 = par.PyroBullet2
	
	player:setAnimations(sprites)
	
	if Difficulty.getActive() == dif.Drizzle then
		player:survivorSetInitialStats(150, 11, 0.04)
	else
		player:survivorSetInitialStats(100, 11, 0.01)
	end
	
	player:setSkill(1, "Scorch", "Ignite enemies at close range for 40% damage. Heat burns them.",
	sprSkills, 1, 10)
		
	player:setSkill(2, "Suppressive Fire", "Consume heat to ignite at a closer range for 80% damage and high knockback.",
	sprSkills, 2, 10)
		
	player:setSkill(3, "Plan B", "Launch yourself forward. Heat increases verticality.",
	sprSkills, 3, 4 * 60)
		
	player:setSkill(4, "Blazeborne", "Launch up to 8 fire pellets that seek and set enemies on fire. Enemies already on fire return a heating pellet which heals you.",
	sprSkills, 4, 10 * 60)
end)

callback.register("onSkinInit", function(player)
	if player:getSurvivor() == pyro then
		player:setAnimation("_walk", player:getAnimation("walk"))
		player:setAnimation("_idle", player:getAnimation("idle"))
		player:setAnimation("_jump", player:getAnimation("jump"))
	end
end)

-- Called when the player levels up
pyro:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(28, 3, 0.001, 1)
end)

-- Called when the player picks up the Ancient Scepter
pyro:addCallback("scepter", function(player)
	player:setSkill(4,
		"Hellborne", "Launch up to 12 fire pellets that seek and set enemies on fire. Enemies already on fire return a heating pellet which heals you.",
		sprSkills, 5, 10 * 60
	)
end)

local function shootFire(player, range, damage, spr, ispr, index)
	local data = player:getData()
	if not player:collidesMap(player.x + 8 * player.xscale, player.y) and player:get("disable_ai") == 0 then
		local laserTurbine = player:countItem(it.LaserTurbine)
		if laserTurbine > 0 then
			player:set("turbinecharge", player:get("turbinecharge") + 0.9 * laserTurbine)
			if player:get("turbinecharge") >= 100 then
				player:set("turbinecharge", 0)
				misc.fireExplosion(player.x, player.y, 600 / 19, 20 / 4, player:get("damage") * 20, player:get("team"))
				obj.EfLaserBlast:create(player.x, player.y)
				sfx.GuardDeath:play(0.7)
			end
		end
		for i = 0, player:get("sp") do
			local bullet = player:fireBullet(player.x, player.y - 2, player:getFacingDirection(), range, damage * player:get("attack_speed"), ispr, DAMAGER_BULLET_PIERCE)
			bullet:set("fire", 1)
			if index == 1 and data.heat >= data.maxHeat * 0.7 then
				bullet:set("knockback", 1)
				DOT.addToDamager(bullet, DOT_FIRE, damage * player:get("damage") * 0.4, 11, "pyro_fire", false)
			elseif index == 2 then
				bullet:set("knockback", 4)
				local damagex = damage
				if data.heat >= data.maxHeat * 0.7 then
					damagex = damagex * 1.5
					bullet:set("damage", bullet:get("damage") * 1.5)
					bullet:set("damage_fake", bullet:get("damage_fake") * 1.8)
				end
				DOT.addToDamager(bullet, DOT_FIRE, damage * player:get("damage") * 0.2, 11, "pyro_fire_x", false)
				bullet:getData().cancelRing = true
			end
			if i ~= 0 then
				bullet:set("climb", i * 8)
			end
		end
		if spr then
			local sprite = obj.EfSparks:create(player.x + (player.xscale * 13), player.y - 1)
			sprite:getData()._afx = {player, player.xscale * 13, -1}
			sprite.xscale = player.xscale
			sprite.sprite = spr
		end
	end
end

table.insert(call.preHit, function(damager)
	if damager:getData().cancelRing then
		damager:set("skull_ring", 0)
	end
end)

-- Skills
pyro:addCallback("useSkill", function(player, skill)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	if playerAc.activity == 0 then
		local cd = true
		
		if skill == 1 and playerAc.x_skill == 0 and not playerData.skin_skill1Override then
			-- Z skill (Scorch)
			if not player:survivorFireHeavenCracker(0.5) then
				shootFire(player, math.random(50, 60), 0.4, player:getAnimation("fire1"), nil, skill)
			end
			playerAc.z_skill = 1
		elseif skill == 2 and not playerData.skin_skill2Override then
			-- X skill (Supressive Fire)
			if playerData.heat > 0 then
				shootFire(player, 40, 0.8, player:getAnimation("fire2"), nil, skill)
			else
				cd = false
			end
			playerAc.x_skill = 1
		elseif skill == 3 then
			-- C skill
			sPyroSkill3:play(0.9 + math.random() * 0.2)
			player:survivorActivityState(3, player:getAnimation("shoot3"), 0.25, false, false)
		elseif skill == 4 then
			-- V skill
			sPyroSkill4:play(0.9 + math.random() * 0.2)
			player:survivorActivityState(4, player:getAnimation("shoot4"), 0.25, true, false)
		end
		if cd then
			player:activateSkillCooldown(skill)
		end
	end
end)

local objBullet = Object.new("PyroHeatMissile")
local sprBullet = Sprite.load("PyroHeatMissile", path.."bullet", 2, 9, 1)
local sprBulletExplosion = Sprite.load("PyroHeatMissileEX", path.."bulletExplosion", 5, 10, 10)

objBullet.sprite = sprBullet
objBullet.depth = 0.1

objBullet:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local data = self:getData()
	data.team = "player"
	selfAc.speed = 4
	data.life = 120
	data.timer = 10
	self.subimage = 1
	self.spriteSpeed = 0
	data.particle = par.PyroBullet
end)
objBullet:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local data = self:getData()
	
	selfAc.speed = selfAc.speed + 0.02
	
	self.angle = selfAc.direction
	
	if global.quality > 1 then 
		data.particle:burst("middle", self.x, self.y, 1)
	end
	
	if data.timer > 0 then
		data.timer = data.timer - 1
	else
		if data.target and data.target:isValid() and not DOT.checkActor(data.target, DOT_FIRE) or data.target and data.target:isValid() and data.t_any then
			if data.parent and data.parent:isValid() then
				data.team = data.parent:get("team")
			end
			if data.lastTarget ~= data.target then
				data.life = 80
				data.lastTarget = data.target
			end
			
			local target = data.target
			
			local angle = posToAngle(self.x, self.y, target.x, target.y)
			
			local dif = selfAc.direction - angle
			
			selfAc.direction = selfAc.direction + (angleDif(selfAc.direction, angle) * -0.115 * (selfAc.speed / 3))
			
			
			if self:collidesWith(target, self.x, self.y) then
				data.life = 0
			end
		else
			local nearestInstance = nil
			for _, enemy in ipairs(pobj.actors:findAll()) do
				if data.team ~= enemy:get("team") and not DOT.checkActor(enemy, DOT_FIRE) then
					if not enemy:get("dead") or enemy:get("dead") == 0 then
						if not enemy:getData()._pbtargetted or enemy:getData()._pbtargetted == self or not enemy:getData()._pbtargetted:isValid() then
							local dis = distance(self.x, self.y, enemy.x, enemy.y)
							if dis < 400 then
								if not nearestInstance or dis < nearestInstance.dis then
									nearestInstance = {inst = enemy, dis = dis}
								end
							end
						end
					end
				end
			end
			if nearestInstance then
				data.target = nearestInstance.inst
			else
				local inst = nearestMatchingOp(self, pobj.actors, "team", "~=", data.team)
				--local inst = pobj.enemies:findNearest(self.x, self.y)
				data.target = inst
				data.t_any = true
				if inst and inst:isValid() then
					inst:getData()._pbtargetted = self
				end
			end
		end
	end
	
	--[[if self:collidesMap(self.x, self.y) then
		data.life = 0
		sPyroBullet:play(0.9 + math.random() * 0.2)
		local damager = data.parent:fireExplosion(self.x, self.y, 9 / 19, 9 / 4, 0.5, sprBulletExplosion)
		DOT.addToDamager(damager, DOT_FIRE, data.parent:get("damage") * 0.3, 10, "pyro_fire", false)
	end]]
	
	if data.life <= 0 then
		if data.parent and data.parent:isValid() then
			local damager = data.parent:fireExplosion(self.x, self.y, 9 / 19, 9 / 4, 1.5, sprBulletExplosion)
			DOT.addToDamager(damager, DOT_FIRE, data.parent:get("damage") * 0.4, 15, "pyro_fire", false)
			damager:set("fire", 1)
		end
		self:destroy()
	else
		data.life = data.life - 1
	end
end)

local objHBullet = Object.new("PyroHeater")

objHBullet.sprite = sprBullet
objHBullet.depth = 0.1

objHBullet:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local data = self:getData()
	selfAc.speed = 4
	self.subimage = 2
	self.spriteSpeed = 0
	data.life = 280
	data.particle = par.PyroBullet2
end)
objHBullet:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local data = self:getData()
	
	selfAc.speed = selfAc.speed + 0.02
	
	self.angle = selfAc.direction
	
	if global.quality > 1 then 
		data.particle:burst("middle", self.x, self.y, 1)
	end
	
	if data.parent and data.parent:isValid() then
		local target = data.parent
		
		local angle = posToAngle(self.x, self.y, target.x, target.y)
		
		local dif = selfAc.direction - angle
		
		selfAc.direction = selfAc.direction + (angleDif(selfAc.direction, angle) * -0.115 * (selfAc.speed / 3))
		
		if self:collidesWith(target, self.x, self.y) then
			data.parent:getData().heat = math.min(data.parent:getData().heat + 10, 100)
			local healVal = data.parent:get("maxhp") * 0.075
			data.parent:set("hp", data.parent:get("hp") + healVal)
			if global.showDamage then
				misc.damage(healVal, data.parent.x, data.parent.y, false, Color.DAMAGE_HEAL)
			end
			data.destroy = true
		end
		if data.parent:get("dead") == 1 then
			data.destroy = true
		end
	else
		data.destroy = true
	end
	
	if data.life > 0 then
		data.life = data.life - 1
	else
		data.destroy = true
	end
	
	if data.destroy then
		sPyroBulletH:play(0.9 + math.random() * 0.2)
		self:destroy()
	end
end)

pyro:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if skill == 3 and not player:getData().skin_skill3Override then
		if onScreen(player) then
			misc.shakeScreen(1)
		end
		
		local mult = playerData.heat / 100
		
		if not player:getData()._flight then
			local val = (0.25 / (mult + 0.1)) * playerAc.pHmax
			playerAc.pHmax = playerAc.pHmax + val
			player:getData()._flight = val
		end
		
		playerData.heat = math.approach(playerData.heat, 0, 5 * mult)
		
		playerAc.pVspeed = - 1.5 - ((6 + playerAc.pVmax) * mult)
		--if playerAc.moveRight == 1 or playerAc.moveLeft == 1 then
			--playerAc.pHspeed = 3 * player.xscale
		--end
		
		if playerAc.moveRight == 1 and not player:collidesMap(player.x + playerAc.pHmax, player.y) and playerAc.pHspeed < playerAc.pHmax then
			playerAc.pHspeed = math.approach(playerAc.pHspeed, playerAc.pHmax * 2, playerAc.pHmax * 0.1)
		elseif playerAc.moveLeft == 1 and not player:collidesMap(player.x - playerAc.pHmax, player.y) and playerAc.pHspeed > -playerAc.pHmax then
			playerAc.pHspeed = math.approach(playerAc.pHspeed, - playerAc.pHmax * 2, playerAc.pHmax * 0.1)
		end
		
	elseif skill == 4 and not player:getData().skin_skill4Override then
		-- Ee
		if relevantFrame == 1 then
			local count
			
			if onScreen(player) then
				misc.shakeScreen(math.ceil(playerData.heat * 0.1))
			end
			
			if playerAc.scepter > 0 then
				count = math.ceil(0.1 + (playerData.heat / 100) * 6 + (4 * playerAc.scepter))
			else
				count = math.ceil(0.1 + (playerData.heat / 100) * 6)
			end
			
			--if count > 0 then
				
				local pellets = {}
				for _, pellet in ipairs(objBullet:findAll()) do
					if pellet:getData().parent == player then
						table.insert(pellets, pellet)
					end
				end
				if #pellets > 25 then
					for i = 0, count do
						if pellets[i + 1] then
							pellets[i + 1]:destroy()
							pellets[i + 1] = nil
						end
					end
				end
				if playerAc.free == 1 then
					for i = 0, count do
					
						local b = objBullet:create(player.x, player.y)
						b:getData().parent = player
						b:set("direction", (i * (360 / (count + 1))) + 90)
						b:getData().particle = playerData.particleSmall
					end
				else
					for i = 0, count do
						local b = objBullet:create(player.x, player.y - 4)
						b:getData().parent = player
						b:set("direction", i * (180 / count))
						b:getData().particle = playerData.particleSmall
					end	
				end
				playerData.heat = 0
			--else
				local blazedEnemies = {}
				for _, enemy in ipairs(pobj.actors:findMatchingOp("team", "~=", playerAc.team)) do
					if DOT.checkActor(enemy, DOT_FIRE) then
						if not enemy:get("dead") or enemy:get("dead") == 0 then
							table.insert(blazedEnemies, enemy)
						end
					end
				end
				for _, enemy in ipairs(blazedEnemies) do
					player:fireExplosion(enemy.x, enemy.y, 4 / 19, 4 / 4, 3, sprBulletExplosion)
					DOT.removeFromActor(enemy, DOT_FIRE)
					local b = objHBullet:create(enemy.x, enemy.y)
					b:getData().parent = player
					b:getData().particle = playerData.particleSmall2
					b:set("direction", posToAngle(player.x, player.y, enemy.x, enemy.y))
				end
			--end
		end
	end
end)

pyro:addCallback("step", function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	if playerData.heat > 0 then
		playerData.heat = math.approach(playerData.heat, 0, 0.08)
	end
	if syncControlRelease(player, "ability1") then
		playerAc.z_skill = 0
	end
	if syncControlRelease(player, "ability2") then
		playerAc.x_skill = 0
	end
	if playerAc.z_skill == 1 and playerAc.activity == 0 and not playerData.skin_skill1Override or playerAc.x_skill == 1 and playerData.heat > 0 and playerAc.activity == 0 and not playerData.skin_skill2Override then
		if not playerData._scz then
			playerData._scz = player.xscale
			playerAc.pHmax = playerAc.pHmax - 0.4
			player:setAnimation("walk", player:getAnimation("walkShoot"))
			player:setAnimation("idle", player:getAnimation("shoot1"))
			player:setAnimation("jump", player:getAnimation("shoot1"))
		else
			player.xscale = playerData._scz
		end
		if not sfx.PyroShoot1:isPlaying() then
			if playerAc.z_skill == 1 then
				sfx.PyroShoot1:play(1.2 + math.random() * 0.2, 1)
			else
				sfx.PyroShoot1:play(0.9 + math.random() * 0.2, 1)
			end
		end
		
		if playerAc.z_skill == 1 and playerAc.x_skill == 0 then
			playerData.heat = math.approach(playerData.heat, playerData.maxHeat, 0.4 * playerAc.attack_speed)
		else
			playerData.heat = math.approach(playerData.heat, 0, 0.5)
		end
	else
		if playerData._scz then
			playerData._scz = nil
			playerAc.pHmax = playerAc.pHmax + 0.4
			sfx.PyroShoot1:stop()
			player:setAnimation("walk", player:getAnimation("_walk"))
			player:setAnimation("idle", player:getAnimation("_idle"))
			player:setAnimation("jump", player:getAnimation("_jump"))
		end
	end
	
	if playerData._flight then
		playerData.particleBig:burst("middle", player.x - (4 * player.xscale), player.y + 2, 2)
		if playerAc.pVspeed >= -0.1 or playerAc.free == 0 then
			playerAc.pHmax = playerAc.pHmax - playerData._flight
			playerData._flight = nil
		end
	end
		
	if playerAc.moveRight == 1 or playerAc.moveLeft == 1 then
		if not playerData._moving then
			playerData._moving = true
			playerAc.attack_speed = playerAc.attack_speed - 0.2
		end
	elseif playerData._moving then
		playerData._moving = nil
		playerAc.attack_speed = playerAc.attack_speed + 0.2
	end
end) 

callback.register("onPlayerDeath", function(player)
	if player:getSurvivor() == pyro then
		if player:get("z_skill") == 1 or player:get("x_skill") == 1 then
			sfx.PyroShoot1:stop()
		end
	end
end)

--[[callback.register("onPlayerHUDDraw", function(player, x, y)
	if player:getSurvivor() == pyro and not player:getData().skin_skill2Override then
		local bullets = player:get("ionBullets")
		
		graphics.drawImage{
			image = sprSkills,
			subimage = bullets + 1,
			y = y - 11,
			x = x + 18 + 5
		}
	end
end)]]


local onStepCall = function()
	for _, ef in ipairs(obj.EfSparks:findAll()) do
		local data = ef:getData()._afx
		if data and data[1]:isValid() then
			ef.x = data[1].x + data[2]
			ef.y = data[1].y + data[3]
		end
	end
end

local onDrawCall = function()
	for _, player in ipairs(misc.players) do
		if player:getSurvivor() == pyro and player:get("dead") == 0 then
			local playerData = player:getData()
			
			if playerData.heat > 0 then
				local sub = 1
				if playerData.heat >= playerData.maxHeat * 0.7 then
					sub = 2
				end
				
				local yy = player.y + 11
				
				graphics.drawImage{
					image = player:getAnimation("heatBar"),
					subimage = sub,
					x = player.x,
					y = yy,
				}
				
				graphics.alpha(1)
				graphics.color(Color.BLACK)
				local xx = player.x - 12 + (25 * (playerData.heat / playerData.maxHeat)) 
				
				local xxx = player.x + 12
				graphics.rectangle(xx, yy, xxx, yy + 2, false)
			end
		end
	end
end

local onPlayerStepCall = function(player)
	local playerData = player:getData()
	if playerData._scz then
		local playerAc = player:getAccessor()
		if playerAc.z_skill == 1 or playerAc.x_skill == 1 then 
			player.xscale = playerData._scz
		end
	end
end

pyro:addCallback("init", function(player)
	tcallback.register("onStep", onStepCall)
	tcallback.register("onPlayerStep", onPlayerStepCall)
	tcallback.register("onDraw", onDrawCall)
end)

sur.Pyro = pyro