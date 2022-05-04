-- Hunter (comission)

local path = "Survivors/Sniper/Skins/Hunter/"

local efColor = Color.fromHex(0xFF514F)
local efColor2 = Color.fromHex(0xE58F49)

local jumpTime = 35

local vdescription = "Send the DRONE to freeze enemies around the most dangerous enemy nearby for 3 seconds, dealing 3x25% damage."
local vdescriptionScepter = "Send the DRONE to freeze enemies around the most dangerous enemy nearby for 6 seconds, dealing 6x25% damage."

local survivor = sur.Sniper
local sprSelect = Sprite.load("HunterSelect", path.."Select", 21, 2, 0)
local Hunter = SurvivorVariant.new(survivor, "Hunter", sprSelect, {
	idle = Sprite.load("HunterIdle", path.."Idle", 1, 5, 7),
	walk = Sprite.load("HunterWalk", path.."Walk", 8, 4, 7),
	jump = Sprite.load("HunterJump", path.."Jump", 1, 4, 5),
	climb_1 = Sprite.load("HunterClimbA", path.."Climb_1", 2, 5, 6),
	climb_2 = Sprite.load("HunterClimbB", path.."Climb_2", 2, 5, 6),
	death = Sprite.load("HunterDeath", path.."Death", 7, 14, 6),
	decoy = Sprite.load("HunterDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.load("HunterShoot1A", path.."Shoot1_1", 6, 8, 24),
	shoot1_2 = Sprite.load("HunterShoot1B", path.."Shoot1_2", 6, 9, 24),
	shoot1_3 = Sprite.load("HunterShoot1C", path.."Shoot1_3", 2, 9, 24),
	shoot2_1 = Sprite.load("HunterShoot2A", path.."Shoot2_1", 2, 5, 9),
	shoot2_2 = Sprite.load("HunterShoot2B", path.."Shoot2_2", 2, 5, 9),
	shoot3_1 = Sprite.load("HunterShoot3", path.."Shoot3", 12, 5, 14),
}, efColor)
SurvivorVariant.setInfoStats(Hunter, {{"Strength", 9}, {"Vitality", 2}, {"Toughness", 2}, {"Agility", 3}, {"Difficulty", 4.5}, {"Instinct", 7}})
SurvivorVariant.setDescription(Hunter, "The &y&Hunter&!& obliterates enemies with his axe, while firing his SMG at distant foes with no remorse. Build heat and release it with Barrage but beware: overheating stops you from handling your axe!")
Hunter.tag = "Comission"

local sprSkills = Sprite.load("HunterSkills", path.."Skills", 6, 0, 0)
local sprSparks = spr.Sparks10r

local sprDroneIdle = Sprite.load("HunterDroneIdle", path.."DroneIdle", 2, 6, 10)
local sprDroneJump = Sprite.load("HunterDroneJump", path.."DroneJump", 1, 6, 10)
local sprDroneWalk = Sprite.load("HunterDroneWalk", path.."DroneWalk", 4, 7, 10)
local sprDroneMask = Sprite.load("HunterDroneMask", path.."DroneMask", 1, 4, 2)
local sprDroneSignal = Sprite.load("HunterDroneSignal", path.."DroneSignal", 4, 12, 20)

local sShoot1_1 = Sound.load("HunterShoot1_1", path.."shoot1")
local sShoot1_2 = sfx.Teleporter--Sound.find("HunterShoot1_2", "Starstorm")
local sShoot2_1 = Sound.find("Baroness_Shoot1A")--Sound.find("HunterShoot2_1", "Starstorm")

SurvivorVariant.setLoadoutSkill(Hunter, "Decimate", "Swing an axe, dealing &y&160% damage.&!& Generates Heat.", sprSkills, 1)
SurvivorVariant.setLoadoutSkill(Hunter, "Barrage", "Fire an SMG, dealing &y&45% damage. Fires faster&!& the more Heat you have.", sprSkills, 2)
SurvivorVariant.setLoadoutSkill(Hunter, "DRONE: CHILL", "Send your drone to &b&freeze all enemies around the most dangerous enemy&!& nearby for 3 seconds, dealing &y&3x25% damage.", sprSkills, 3)

Hunter.endingQuote = "..and so he left, with another trophy for his collection."


obj.HunterDrone = Object.new("HunterDrone")
obj.HunterDrone.depth = -7
obj.HunterDrone.sprite = sprDroneIdle
obj.HunterDrone:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.jumping = 0
	selfData.attackingTimer = 0
	selfData.gravity = 0.26
	selfData.yacc = 0
	selfData.xspeed = 1
	self.spriteSpeed = 0.02
	self.mask = sprDroneMask
end)
obj.HunterDrone:addCallback("step", function(self)
	local selfData = self:getData()
	local parent = selfData.parent
	
	if parent and parent:isValid() then
		selfData.xspeed = parent:get("pHmax") + 0.1
		if selfData.attacking then
			if selfData.attacking:isValid() then
				local target = selfData.attacking
				
				local targetTeam = selfData.attacking:get("team")
				if targetTeam and targetTeam == "player" then
					target:applyBuff(buff.slow, 20)
				end
				
				if selfData.attackingTimer % 60 == 0 then
					local r = 100
					parent:fireExplosion(self.x, self.y, r / 19, r / 4, 0.25)
					
					for _, actor in ipairs(pobj.actors:findAllRectangle(self.x - r, self.y - r, self.x + r, self.y + r)) do
						if actor:get("team") == targetTeam then
							actor:applyBuff(buff.slow2, 58)
							actor:setAlarm(7, 50)
						end
					end
				end
				
				if selfData.attackingTimer > 0 then
					selfData.attackingTimer = selfData.attackingTimer - 1
				else
					selfData.attacking = nil
					for _, poi in ipairs(obj.POI:findMatching("parent", self.id)) do
						poi:destroy()
					end
					
					if isa(parent, "PlayerInstance") then
						local title, desc, sindex = "DRONE: CHILL", vdescription, 3
						if parent:get("scepter") > 0 then
							title = "DRONE: FREEZE"
							desc = vdescriptionScepter
							sindex = 5
						end
						--print(01)
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
						local title, desc, sindex = "DRONE: CHILL", vdescription, 3
						if parent:get("scepter") > 0 then
							title = "DRONE: FREEZE"
							desc = vdescriptionScepter
							sindex = 5
						end
						--print("spot: not found")
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
obj.HunterDrone:addCallback("destroy", function(self)
	local parent = self:getData().parent
		
	if parent and parent:isValid() then
		parent:setAnimation("climb", Hunter.animations.climb_2)
		if parent:get("activity") == 30 then
			parent.sprite = Hunter.animations.climb_2
		end
	end
end)
obj.HunterDrone:addCallback("draw", function(self)
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


callback.register("onSkinInit", function(player, skin)
	if skin == Hunter then
		player:getData().gunheat = 0
		player:getData().gunrefresh = 0
		player:getData().isHunter = true
		
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(135, 15.5, 0.04)
		else
			player:survivorSetInitialStats(85, 15.5, 0.01)
		end
		player:setSkill(1,
		"Decimate",
		"Swing an axe, dealing 160% damage. Generates Heat.",
		sprSkills, 1, 55)
		player:setSkill(2,
		"Barrage",
		"Fire an SMG, dealing 45% damage. Fires faster the more Heat you have.",
		sprSkills, 2, 16)
		player:setSkill(4,
		"DRONE: CHILL",
		"Send the DRONE to freeze enemies around the most dangerous enemy nearby for 3 seconds, dealing 3x25% damage.",
		sprSkills, 3, 12 * 60)
		player:getData().correctVindex = 3
		
		for _, drone in ipairs(obj.SniperDrone:findMatching("master", player.id)) do
			drone:destroy()
		end
		local drone = obj.HunterDrone:create(player.x, player.y)
		drone:getData().parent = player
		player:getData().childDrone = drone
		player:setAnimation("climb", Hunter.animations.climb_1)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Hunter then
		player:survivorLevelUpStats(1, 0, 0, 0)
	end
end)
SurvivorVariant.setSkill(Hunter, 1, function(player)
	if player:getData().gunoverheat then
		SurvivorVariant.activityState(player, 1.2, player:getAnimation("shoot1_3"), 0.2, false, true)
		sfx.Error:play(1)
	else
		--if player:getData().gunheat > 75 then
			if player:getData().gunheat > 84 and not player:getData().gunoverheat then
				--player:set("pHmax", player:get("pHmax") - 0.5)
				player:getData().gunoverheat = true
				player:setSkill(1,
				"Overheated!",
				"Cool down!",
				sprSkills, 6, 55)
			end
			--SurvivorVariant.activityState(player, 1.1, player:getAnimation("shoot1_2"), 0.2, true, true)
		--else
			if not player:getData().switch then
				SurvivorVariant.activityState(player, 1.1, player:getAnimation("shoot1_1"), 0.25, true, true)
				player:getData().switch = true
			else
				SurvivorVariant.activityState(player, 1.1, player:getAnimation("shoot1_2"), 0.25, true, true)
				player:getData().switch = false
			end
		--end
	end
end)
SurvivorVariant.setSkill(Hunter, 2, function(player)
	if not player:getData().gunswitch then
		SurvivorVariant.activityState(player, 2.1, player:getAnimation("shoot2_1"), 0.25, true, true)
		player:activateSkillCooldown(2)
		player:getData().gunswitch = true
	else
		SurvivorVariant.activityState(player, 2.1, player:getAnimation("shoot2_2"), 0.25, true, true)
		player:activateSkillCooldown(2)
		player:getData().gunswitch = false
	end
	local gunSpeed = 16 * player:getData().gunheat * 0.01
	player:setAlarm(3, 16 - gunSpeed)
end)
SurvivorVariant.setSkill(Hunter, 4, function(player)
	local drone, lookForEnemy, scepter = nil, true, player:get("scepter")
	--print("checking drone")
	if player:getData().childDrone:isValid() then
		drone = player:getData().childDrone
		--print("valid drone")
		if drone:getData().attacking and drone:getData().attacking:isValid() and drone:getData().attackingTimer > 0 or drone:getData().jumpToAttack and drone:getData().jumping > 0 then
			--print("bring back")
			drone:getData().jumpToAttack = nil
			drone:getData().attacking = nil
			drone:getData().jumping = 0
			lookForEnemy = false
			
			for _, poi in ipairs(obj.POI:findMatching("parent", drone.id)) do
				poi:destroy()
			end
			
			local title, desc, sindex = "DRONE: CHILL", vdescription, 3
			if scepter > 0 then
				title = "DRONE: FREEZE"
				desc = vdescriptionScepter
				sindex = 5
			end
			player:setSkill(4,
			title,
			desc,
			sprSkills, sindex, 12 * 60)
			player:getData().correctVindex = sindex
			player:activateSkillCooldown(4)
		end
	else
		--print("invalid drone, creating")
		drone = obj.HunterDrone:create(player.x, player.y)
		drone:getData().parent = player
		player:getData().childDrone = drone
		player:setAnimation("climb", Hunter.animations.climb_1)
		if player:get("activity") == 30 then
			player.sprite = Hunter.animations.climb_1
		end
	end
	
	if lookForEnemy then
		--print("looking for enemy")
		local priorityEnemy = {instance = nil, damage = nil}
		for _, actor in ipairs(pobj.actors:findAll()) do
			if actor:get("team") and actor:get("team") ~= player:get("team") then
				if actor.x > player.x - 400 and actor.x < player.x + 400 and actor.y > player.y - 250 and actor.y < player.y + 250 then
					local actorDamage = actor:get("damage")
					if not priorityEnemy.instance or actorDamage and not priorityEnemy.damage or actorDamage and priorityEnemy.damage and actorDamage > priorityEnemy.damage then
						priorityEnemy.instance = actor
						priorityEnemy.damage = actorDamage
					end
				end
			end
		end
		
		if priorityEnemy.instance then
			--print("enemy found")
			drone:getData().jumping = jumpTime
			drone:getData().jumpToAttack = priorityEnemy.instance
			drone:getData().ogx = drone.x
			drone:getData().yy = drone.y
			drone:getData().jumpingTarget = priorityEnemy.instance
			drone:getData().jumpingTargetx = priorityEnemy.instance.x
			drone:getData().jumpingTargety = priorityEnemy.instance.y
			
			local title, desc = "DRONE: CHILL", vdescription
			if scepter > 0 then
				title = "DRONE: FREEZE"
				desc = vdescriptionScepter
			end
			player:setSkill(4,
			title,
			desc,
			sprSkills, 4, 60)
			player:getData().correctVindex = 4
			--player:setSkillIcon(4, sprSkills, 4)
			player:activateSkillCooldown(4)
			sfx.Error:stop()
			sfx.JanitorShoot2_2:play(2, 0.7)
		else
			--print("not enemy found")
			if not net.online or player == net.localPlayer then
				sfx.Error:play()
				local title, desc, sindex = "DRONE: CHILL", vdescription, 3
				if scepter > 0 then
					title = "DRONE: FREEZE"
					desc = vdescriptionScepter
					sindex = 5
				end
				player:setSkill(4,
				title,
				desc,
				sprSkills, sindex, 30)
				player:getData().correctVindex = sindex
			end
			player:activateSkillCooldown(4)
		end
	end
end)

callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
	if variant == Hunter then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		if skill == 1.1 then
			if relevantFrame == 3 then
				sShoot1_1:play(0.9 + math.random() * 0.1)
				if not player:survivorFireHeavenCracker(1.6) then
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x, player.y + 3, player:getFacingDirection(), 40, 1.6, nil, DAMAGER_BULLET_PIERCE)
						--addBulletTrailLine(bullet, efColor, 1.5, 30, false, true)
						bullet:getData().skin_spark = spr.Sparks10r
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
				playerData.gunheat = math.min(playerData.gunheat + 15, 100)
			end
		elseif skill == 2.1 then
			if relevantFrame == 1 then
				sShoot2_1:play(1.2 + math.random() * 0.2)
				for i = 0, playerAc.sp do
					local bullet = player:fireBullet(player.x, player.y + 3, player:getFacingDirection(), 500, 0.45, nil)
					--addBulletTrailLine(bullet, efColor2, 1, 30, false, true)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
				--if not playerData.gunoverheat then
					playerData.gunrefresh = 5
				--end
			end
		end
		if skill > 2 and skill < 3 then
			for _, bar in ipairs(obj.CustomBar:findAll()) do
				if bar.id == playerAc.activity_var2 then
					bar:destroy()
					playerAc.bullet_ready = 1
				end
			end
			for _, bar in ipairs(obj.SniperBar:findMatching("parent", player.id)) do
				bar:destroy()
			end
		end
	end
end)
local onPlayerStepCall = function(player)
	if SurvivorVariant.getActive(player) == Hunter then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		
		playerAc.bullet_ready = 1
		
		if player:getData().removeDrone then
			for _, drone in ipairs(obj.SniperDrone:findMatching("master", player.id)) do
				drone:destroy()
				player:getData().removeDrone = nil
			end
		end
		
		if not playerData.childDrone:isValid() then
			if playerAc.activity ~= 30 then
				local drone = obj.HunterDrone:create(player.x, player.y)
				drone:getData().parent = player
				player:getData().childDrone = drone
				player:setAnimation("climb", Hunter.animations.climb_1)
			end
		end
		
		if playerData.gunrefresh > 0 then
			local downValue = math.min(playerData.gunrefresh / 5, 1)
			playerData.gunheat = math.max(playerData.gunheat - 2 * downValue, 0)
			playerData.gunrefresh = playerData.gunrefresh - 1
		end
		if playerData.gunheat > 0 then
			if playerData.gunoverheat then
				playerData.gunheat = playerData.gunheat - 0.3
			else
				playerData.gunheat = playerData.gunheat - 0.15
			end
			
			if #obj.CustomBar:findMatching("parent", player.id) == 0 then
				local bar = obj.CustomBar:create(player.x, player.y)
				bar:set("parent", player.id)
				bar:set("maxtime", 100)
				bar:set("time", 100)
				bar:set("barColor", efColor2.gml)
				bar:set("charge", 1)
				bar:getData().isSniperHeat = true
				bar.subimage = 5
			else
				for _, bar in ipairs(obj.CustomBar:findMatching("parent", player.id)) do
					if bar:getData().isSniperHeat then
						bar:set("time", math.max(100 - player:getData().gunheat, 0))
						if playerData.gunoverheat then
							bar:set("barColor", efColor.gml)
						end
					end
				end
			end
		else
			if playerData.gunoverheat then
				--player:set("pHmax", player:get("pHmax") + 0.5)
				playerData.gunoverheat = false
				player:setSkill(1,
				"Decimate",
				"Swing an axe dealing damage. Generates Heat.",
				sprSkills, 1, 55)
			end
			for _, bar in ipairs(obj.CustomBar:findMatching("parent", player.id)) do
				if bar:getData().isSniperHeat then
					bar:destroy()
				end
			end
		end
		
		player:setSkillIcon(4, sprSkills, player:getData().correctVindex)
		
		--player:getData().skill1 = true
	end
end
survivor:addCallback("scepter", function(player)
	if player:getData().gunoverheat and player:getData().isHunter then
		player:setSkill(4,
		"DRONE: FREEZE",
		vdescriptionScepter,
		sprSkills, 5, 12 * 60)
		player:getData().correctVindex = 5
	end
end)
survivor:addCallback("draw", function(player)
	if player:getData().gunoverheat and player:getData().isHunter then
		graphics.drawImage{
			x  = player.x,
			y = player.y,
			image = player.sprite,
			xscale = player.xscale,
			yscale = player.yscale,
			alpha = player.alpha * 0.4,
			solidColor = Color.RED
		}
	end
end)


callback.register("onSkinInit", function(player, skin)
	if skin == Hunter then
		tcallback.register("onPlayerStep", onPlayerStepCall)
	end
end)