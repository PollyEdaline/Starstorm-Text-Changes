
-- All DU-T data

local path = "Survivors/DU-T/"

local dut = Survivor.new("DU-T")

-- Sounds
local sDutSkill1_1a = Sound.load("DU-TSkill1_1A", path.."skill1_1a")
local sDutSkill1_1b = Sound.load("DU-TSkill1_1B", path.."skill1_1b")
local sDutSkill1_1c = Sound.load("DU-TSkill1_1C", path.."skill1_1c")
local sDutSkill1_2a = Sound.load("DU-TSkill1_2A", path.."skill1_2a")
local sDutSkill2 = Sound.load("DU-TSkill2", path.."skill2")
local sDutSkill3 = Sound.load("DU-TSkill3", path.."skill3")
local sDutSkill4_1 = Sound.load("DU-TSkill4_1", path.."skill4_1")
local sDutSkill4_2 = Sound.load("DU-TSkill4_2", path.."skill4_2")
local sDutCharge =  Sound.load("DU-TSkill1Full", path.."skill1Full")--sfx.Crit

-- Color of highlights during selection
dut.loadoutColor = Color.fromHex(0x687186)

-- Table sprites
local sprites = {
	idle = Sprite.load("DU-T_Idle", path.."idle", 1, 7, 11),
	walk = Sprite.load("DU-T_Walk", path.."walk", 8, 15, 11),
	jump = Sprite.load("DU-T_Jump", path.."jump", 1, 7, 14),
	climb = Sprite.load("DU-T_Climb", path.."climb", 2, 4, 10),
	death = Sprite.load("DU-T_Death", path.."death", 10, 10, 14),
	decoy = Sprite.load("DU-T_Decoy", path.."decoy", 1, 9, 14),
	
	shoot1_1 = Sprite.load("DU-T_Shoot1_1", path.."shoot1_1", 3, 7, 11),
	shoot1_2 = Sprite.load("DU-T_Shoot1_2", path.."shoot1_2", 3, 7, 11),
	shoot3 = Sprite.load("DU-T_Shoot3", path.."shoot3", 7, 25, 26)
}

-- Skill sprites
local sprSkillsLoadout = Sprite.load("DU-T_LoadoutSkills", path.."skillsLoadout", 4, 0, 0)
local sprSkills = Sprite.load("DU-T_Skills", path.."skills", 8, 0, 0)

-- Selection sprite
dut.loadoutSprite = Sprite.load("DU-T_Select", path.."select", 18, 2, 0)

-- Selection description
dut:setLoadoutInfo(
[[--- &y&DU-T&!&, THE GO-TO SERVICE UNIT FOR ANY JOB! ---
THIS UNIT HAS BEEN GIVEN THE FOLLOWING INSTRUCTIONS:
&g&- HARVEST RESOURCES FROM COLLECTED ASTEROIDS
&g&- CARRY HEAVY PACKAGES
&r&- HELP ME ]].."[ERROR: INSTRUCTION UNCLEAR #4f68206869203a29]".."\n---", sprSkillsLoadout)

-- Skill descriptions

dut:setLoadoutSkill(1, "HARVEST", [[&y&ABSORB HEALTH&!& FROM &y&NEARBY ENEMIES&!& OR &r&YOURSELF&!& TO &y&CHARGE ENERGY.
RELEASE TO DISCHARGE ENERGY IN A &y&LASER BLAST&!& OR A &g&HEALING AURA&!&.]])

dut:setLoadoutSkill(2, "TOGGLE MODE", [[SWITCH BETWEEN &g&SELF&!& AND &r&ENEMY&!& HARVEST MODE.]])

dut:setLoadoutSkill(3, "PERFORMANCE BOOST", [[TEMPORARILY &b&INCREASE MOVEMENT SPEED&!&.]])

dut:setLoadoutSkill(4, "ENERGY FLARE", [[CREATE AN ENERGY FLARE THAT &y&ABSORBS HEALTH
FROM NEARBY ENEMIES&!& OR &g&HEALS ALLIES &y&FOR ENERGY&!&.
&y&ABSORBED ENERGY GOES BACK TO YOU AS CHARGE&!&.]])

-- Misc. menus sprite
dut.idleSprite = sprites.idle

-- Main menu sprite
dut.titleSprite = sprites.walk

-- Endquote
dut.endingQuote = "..and so it left, serving for more than it was made for."

dut:addCallback("init", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	playerData.charge = 0
	playerData._EfColor1 = Color.RED
	playerData._EfColor2 = Color.GREEN
	playerData.activeColor = playerData._EfColor1
	playerData.mode = 1
	
	player:setAnimations(sprites)
	
	if Difficulty.getActive() == dif.Drizzle then
		player:survivorSetInitialStats(150, 11, 0.034)
	else
		player:survivorSetInitialStats(110, 11, 0.004)
	end
	
	playerAc.pHmax = playerAc.pHmax - 0.2
	
	player:setSkill(1, "HARVEST (ENEMY)", "ABSORB HEALTH FROM ENEMIES TO CHARGE. RELEASE TO DISCHARGE IN A LASER BLAST.",
	sprSkills, 1, 2)
		
	player:setSkill(2, "TOGGLE MODE", "SWITCH BETWEEN SELF AND ENEMY HARVEST MODE.",
	sprSkills, 2, 45)
		
	player:setSkill(3, "PERFORMANCE BOOST", "TEMPORARILY INCREASE MOVEMENT SPEED.",
	sprSkills, 3, 6 * 60)
		
	player:setSkill(4, "ENERGY FLARE", "CREATE A FLARE THAT ABSORBS HEALTH FROM ENEMIES FOR ENERGY. ENERGY GOES BACK TO YOU AS CHARGE.",
	sprSkills, 4, 12 * 60)
end)

-- Called when the player levels up
dut:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(28, 2.5, 0.0008, 2)
end)

-- Called when the player picks up the Ancient Scepter
dut:addCallback("scepter", function(player)
	if player:getData().mode == 1 then
		player:setSkill(4, "ENERGY FUSILLADE", "CREATE A FUSILLADE THAT ABSORBS HEALTH FROM ENEMIES FOR ENERGY. ENERGY GOES BACK TO YOU AS CHARGE.",
		sprSkills, 5, 12 * 60)
	else
		player:setSkill(4, "ENERGY FUSILLADE", "CREATE A FUSILLADE THAT HEALS ALLIES FOR ENERGY. ENERGY GOES BACK TO YOU AS CHARGE.",
		sprSkills, 8, 12 * 60)
	end
end)

local z_range = 90
local z_heal_range = 100
local z_max = 9

buff.Charge = Buff.new("charge")
buff.Charge.sprite = spr.Nothing
buff.Charge:addCallback("start", function(actor)
	if actor and actor:isValid() then
		--actor:set("attack_speed", actor:get("attack_speed") + 0.6)
		actor:set("pHmax", actor:get("pHmax") + 0.6)
	end
end)
buff.Charge:addCallback("end", function(actor)
	if actor and actor:isValid() then
		--actor:set("attack_speed", actor:get("attack_speed") - 0.6)
		actor:set("pHmax", actor:get("pHmax") - 0.6)
	end
end)

local objDUTCircle = Object.new("DUTCircle")
objDUTCircle:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.isize = 80
	selfData.size = 80
	selfData.damage = 150
	selfData.team = "player"
	selfData.timer = 0
	selfData.rate = 40
	selfData.hspeed = 0
	selfData.vspeed = 0
	selfData.mode = 1
	--selfData.scepter = 0
end)
objDUTCircle:addCallback("step", function(self)
	local selfData = self:getData()
	if selfData.size > 0 then
		selfData.size = selfData.size - 0.35
		
		self.x = self.x + math.clamp(selfData.hspeed, -2, 2)
		--self.y = self.y + selfData.vspeed
		
		if selfData.timer == 0 then
			selfData.timer = selfData.rate
			if selfData.mode == 1 then
				if selfData.parent and selfData.parent:isValid() then
					selfData.parent:fireExplosion(self.x, self.y, selfData.size / 19, selfData.size / 4, (selfData.isize - selfData.size) / 10)
				else
					misc.fireExplosion(self.x, self.y, selfData.size / 19, selfData.size / 4,  (selfData.isize - selfData.size) / (selfData.damage * 0.1), selfData.team)
				end
			else
				local r = selfData.size
				for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - r, self.y - r, self.x + r, self.y + r)) do
					if actor:get("team") == selfData.team then
						local healval = math.max(actor:get("maxhp") * (selfData.isize - selfData.size) * 0.01, 5)
						actor:set("hp", actor:get("hp") + healval)
						if global.showDamage then
							misc.damage(healval, actor.x, actor.y - 10, false, Color.DAMAGE_HEAL)
						end
					end
				end
			end
		else
			selfData.timer = selfData.timer - 1
		end
	else
		self:destroy()
	end
end)
objDUTCircle:addCallback("draw", function(self)
	local selfData = self:getData()
	graphics.alpha(self.alpha)
	graphics.color(self.blendColor)
	local fill = selfData.timer % selfData.rate ~= 0
	graphics.circle(self.x, self.y, selfData.size, fill)
end)

local objDUTCircle2 = Object.new("DUTCircle2")
objDUTCircle2:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.size = 5
	selfData.damage = 150
	selfData.team = "player"
	selfData.timer = 0
	selfData.timer2 = 0
	selfData.rate = 40
	selfData.hspeed = 0
	selfData.vspeed = 0
	selfData.mode = 1
	selfData.range = 100
	selfData.rate = 1
	--selfData.scepter = 0
end)
objDUTCircle2:addCallback("step", function(self)
	local selfData = self:getData()
	if selfData.size > 0 then
		self.x = self.x + math.clamp(selfData.hspeed, -2, 2)
		--self.y = self.y + selfData.vspeed
		
		if selfData.timer == 180 then
			sDutSkill4_2:play(0.9 + math.random() * 0.2)
		end
		
		if selfData.timer < 180 then
			local r = selfData.range
			
			if selfData.mode == 1 then
				local hasParent = selfData.parent and selfData.parent:isValid()
				for i, actor in ipairs(pobj.actors:findAllEllipse(self.x - r, self.y - r, self.x + r, self.y + r)) do
					if actor:get("team") ~= selfData.team then
						if not actor:get("dead") or actor:get("dead") == 0 then
							if (selfData.timer2 + i) % math.round(20 / (0.5 + selfData.rate * 0.5)) == 0 then
								if hasParent then
									local direction = selfData.parent:getFacingDirection()
									local offset = -2
									if selfData.parent.x > self.x then
										offset = 2
									end
									local bullet = selfData.parent:fireBullet(actor.x + offset, actor.y, direction, 4, 0.1, spr.Sparks2):set("specific_target", actor.id)
									bullet:set("damage_fake", bullet:get("damage"))
								else
									local bullet = misc.fireBullet(actor.x - 2, actor.y, 0, 4, 0.1, selfData.team, spr.Sparks2):set("specific_target", actor.id)
									bullet:set("damage_fake", bullet:get("damage"))
								end
							end
							
							selfData.size = math.min(selfData.size + 0.01 * selfData.rate, 40)
						end
					end
				end
			else
				local count = 0
				for i, actor in ipairs(pobj.actors:findAllEllipse(self.x - r, self.y - r, self.x + r, self.y + r)) do
					if actor:get("team") == selfData.team then
						if not actor:get("dead") or actor:get("dead") == 0 then
							if (selfData.timer2 + i) % math.round(19 / (0.5 + selfData.rate * 0.5)) == 0 then
								local healval = actor:get("maxhp") * 0.05
								actor:set("hp", actor:get("hp") + healval)
								misc.damage(healval, actor.x, actor.y - 10, false, Color.DAMAGE_HEAL)
							end
							
							count = count + 1
						end
					end
				end
				local mult = (0.1 - 0.1 / (0.43 * count + 1))
				selfData.size = math.min(selfData.size + mult, 40)
			end
			selfData.timer2 = selfData.timer2 + 1
		else
			if selfData.parent and selfData.parent:isValid() then
				local parentData = selfData.parent:getData()
				parentData.charge = math.min(parentData.charge + 0.4, 40)
			end
			selfData.size = selfData.size - 0.5 --(0.5 / (selfData.scepter + 1)) 
		end
		selfData.timer = selfData.timer + 1
	else
		self:destroy()
	end
end)
objDUTCircle2:addCallback("draw", function(self)
	local selfData = self:getData()
	graphics.alpha(self.alpha)
	graphics.color(self.blendColor)
	local outline = selfData.timer2 % math.round(19 / (0.5 + selfData.rate * 0.5)) == 0
	graphics.circle(self.x, self.y, selfData.size, outline)
	
	if selfData.timer < 180 then
		local r = selfData.range
		if selfData.mode == 1 then
			for i, actor in ipairs(pobj.actors:findAllEllipse(self.x - r, self.y - r, self.x + r, self.y + r)) do
				if actor:get("team") ~= selfData.team then
					if not actor:get("dead") or actor:get("dead") == 0 then
						graphics.line(actor.x, actor.y, self.x, self.y, 2)
					end
				end
			end
		else
			for i, actor in ipairs(pobj.actors:findAllEllipse(self.x - r, self.y - r, self.x + r, self.y + r)) do
				if actor:get("team") == selfData.team then
					if not actor:get("dead") or actor:get("dead") == 0 then
						graphics.line(actor.x, actor.y, self.x, self.y, 2)
					end
				end
			end
		end
	elseif selfData.parent and selfData.parent:isValid() then
		graphics.line(selfData.parent.x, selfData.parent.y, self.x, self.y, math.min(4, selfData.size))
	end
	
	graphics.color(Color.WHITE)
	graphics.circle(self.x, self.y, math.max(selfData.size - 4, 0), fill)
end)

local syncState
syncState = net.Packet.new("SSDUTState", function(sender, player, mode)
	local inst = player:resolve()
	if inst and inst:isValid() then
		local playerData = inst:getData()
		playerData.mode = mode
		playerData.activeColor = playerData["_EfColor"..mode]
		if net.host then
			syncState:sendAsHost(net.EXCLUDE, sender, player, mode)
		end
	end
end)

local mode1HoldFunc = function(player)
	local playerAc = player:getAccessor()
	local myTeam = playerAc.team
	local direction = player:getFacingDirection()
	local offset = 2 * player.xscale * -1
	for i, actor in ipairs(pobj.actors:findAllEllipse(player.x - z_range, player.y - z_range, player.x + z_range, player.y + z_range)) do
		if actor:get("team") ~= myTeam then
			if not actor:get("dead") or actor:get("dead") == 0 then
				player:getData().charge = math.min(player:getData().charge + 0.02 * (1 + playerAc.sp) * playerAc.attack_speed, z_max)
				if (global.timer + i) % math.round(20 / (0.5 + playerAc.attack_speed * 0.5)) == 0 then
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(actor.x + offset, actor.y, direction, 4, 0.1, spr.Sparks2):set("specific_target", actor.id)
						bullet:set("damage_fake", bullet:get("damage"))
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			end							
		end
	end
end

local mode1DrawFunc = function(player)
	local xx = player.x + (5 + (player:getData().charge * 0.2)) * player.xscale
	local yy = player.y - 2
	
	graphics.alpha(0.5)
	graphics.color(player:getData().activeColor)
	local myTeam = player:get("team")
	for _, actor in ipairs(pobj.actors:findAllEllipse(player.x - z_range, player.y - z_range, player.x + z_range, player.y + z_range)) do
		if actor:get("team") ~= myTeam then
			graphics.line(xx, yy, actor.x, actor.y, 2)
		end
	end
end

local mode1ShootFunc = function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	if not player:survivorFireHeavenCracker(playerData.charge * 1.75) then
		for i = 0, playerAc.sp do
			local b = player:fireBullet(player.x + 4 * player.xscale, player.y - 1, player:getFacingDirection(), 100 * playerData.charge, playerData.charge * 1.5, spr.Sparks2, DAMAGER_BULLET_PIERCE):set("knockback", math.max(playerData.charge - 4, 0))
			addBulletTrailLine(b, playerData.activeColor, 1 + playerData.charge * 0.5, 30 + playerData.charge * 4, true, true)
			if i ~= 0 then
				b:set("climb", i * 8)
			end
		end
	end
	if playerData.charge > 3 then
		misc.shakeScreen((playerData.charge - 3) * 2)
	end
	
	if playerAc.activity == 0  then
		player:survivorActivityState(1, player:getAnimation("shoot1_1"), 0.25, true, false)
	end
	
	if playerData.charge > 11 then
		sDutSkill1_1c:play(0.9 + math.random() * 0.2)
	elseif playerData.charge > 7 then
		sDutSkill1_1b:play(0.9 + math.random() * 0.2)
	else
		sDutSkill1_1a:play(0.9 + math.random() * 0.2)
	end
end

local mode2HoldFunc = function(player)
	local playerAc = player:getAccessor()
	local offset = 2 * player.xscale * -1
	if global.timer % math.round(19 / (0.5 + playerAc.attack_speed * 0.5)) == 0 then
		player:fireBullet(player.x + offset, player.y, player:getFacingDirection(), 4, (0.1 * playerAc.hp) / playerAc.damage, spr.Sparks2, DAMAGER_NO_RECALC + DAMAGER_NO_PROC):set("specific_target", player.id):set("team", "neutral"):set("parent_m_id ", playerAc.m_id)
	end
	player:getData().charge = math.min(player:getData().charge + 0.08 * playerAc.attack_speed, z_max)
end

local mode2ShootFunc = function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	for _, actor in ipairs(pobj.actors:findAllEllipse(player.x - z_heal_range, player.y - z_heal_range, player.x + z_heal_range, player.y + z_heal_range)) do
		if actor:get("team") == player:get("team") then
			if not actor:get("dead") or actor:get("dead") == 0 then
				local healval = playerAc.damage * playerData.charge * 0.54
				actor:set("hp", actor:get("hp") + healval)
				if global.showDamage then
					misc.damage(healval, actor.x, actor.y - 10, false, Color.DAMAGE_HEAL)
				end
			end
		end
	end
	local circle = obj.EfCircle:create(player.x, player.y)
	circle:set("radius", z_heal_range)
	circle:set("rate", 5)
	circle.blendColor = playerData.activeColor
	
	if playerAc.activity == 0  then
		player:survivorActivityState(1, player:getAnimation("shoot1_2"), 0.25, true, false)
	end
	
	sDutSkill1_2a:play(0.9 + math.random() * 0.2)
end

-- Skills
dut:addCallback("useSkill", function(player, skill)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	if playerAc.activity == 0 then
		
		if skill == 1 and playerAc.x_skill == 0 and not playerData.skin_skill1Override then
			-- Z skill
			if playerData.charge < z_max then
				local laserTurbine = player:countItem(it.LaserTurbine)
				if laserTurbine > 0 then
					playerAc.turbinecharge = playerAc.turbinecharge + 0.05 * laserTurbine
				end
				
				
				if playerData.mode == 1 then
					playerData.mode1HoldFunc(player)
				else
					playerData.mode2HoldFunc(player)
				end
			end
		elseif skill == 2 and not playerData.skin_skill2Override then
			-- X skill
			--player:survivorActivityState(2, player:getAnimation("shoot2"), 0.25, true, false)
			if playerData.mode == 1 then
				playerData.mode = 2
				player:setSkill(1, "HARVEST (SELF)", "ABSORB HEALTH FROM YOURSELF TO CHARGE. RELEASE TO DISCHARGE IN A LASER BLAST.", sprSkills, 6, 2)
				if playerAc.scepter > 0 then
					player:setSkill(4, "ENERGY FUSILLADE", "CREATE A FUSILLADE THAT HEALS ALLIES FOR ENERGY. ENERGY GOES BACK TO YOU AS CHARGE.", sprSkills, 8, 12 * 60)
				else
					player:setSkill(4, "ENERGY FLARE", "CREATE A FLARE THAT HEALS ALLIES FOR ENERGY. ENERGY GOES BACK TO YOU AS CHARGE.", sprSkills, 7, 12 * 60)
				end
			else
				playerData.mode = 1
				player:setSkill(1, "HARVEST (ENEMY)", "ABSORB HEALTH FROM ENEMIES TO CHARGE. RELEASE TO DISCHARGE IN A LASER BLAST.", sprSkills, 1, 2)
				if playerAc.scepter > 0 then
					player:setSkill(4, "ENERGY FUSILLADE", "CREATE A FUSILLADE THAT ABSORBS HEALTH FROM ENEMIES FOR ENERGY. ENERGY GOES BACK TO YOU AS CHARGE.", sprSkills, 5, 12 * 60)
				else
					player:setSkill(4, "ENERGY FLARE", "CREATE A FLARE THAT ABSORBS HEALTH FROM ENEMIES FOR ENERGY. ENERGY GOES BACK TO YOU AS CHARGE.", sprSkills, 4, 12 * 60)
				end
			end
			sDutSkill2:play(0.9 + math.random() * 0.2)
			playerData.activeColor = playerData["_EfColor"..playerData.mode]
			
			playerData.syncChange = 50
		elseif skill == 3 then
			-- C skill
			--sDutSkill3:play(0.9 + math.random() * 0.2)
			player:survivorActivityState(3, player:getAnimation("shoot3"), 0.25, false, true)
		elseif skill == 4 then
			-- V skill
			--sDutSkill4_1:play(0.9 + math.random() * 0.2)
			if playerData.mode == 1 then
				player:survivorActivityState(4, player:getAnimation("shoot1_1"), 0.25, true, false)
			else
				player:survivorActivityState(4, player:getAnimation("shoot1_2"), 0.25, true, false)
			end
		end
		player:activateSkillCooldown(skill)
	end
end)

dut:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if skill == 3 and not player:getData().skin_skill3Override then
		if relevantFrame == 1 then
			player:applyBuff(buff.Charge, 180)
			sDutSkill3:play(0.9 + math.random() * 0.2)
		end
		if player.subimage > 2 and playerAc.free == 0 then
			playerAc.pHspeed = playerAc.pHmax * player.xscale
		end
	elseif skill == 4 and not player:getData().skin_skill4Override then
		if relevantFrame == 1 then
			sDutSkill4_1:play(0.9 + math.random() * 0.2)
			local circles = {}
			for _, circle in ipairs(objDUTCircle2:findAll()) do
				if circle:getData().parent == player then
					table.insert(circles, circle)
				end
			end
			local scepter = playerAc.scepter
			if #circles > 7 then
				circles[1 + scepter]:destroy()
				circles[1 + scepter] = nil
			end
			for i = 1, (scepter + 1) do
				for ii = 0, playerAc.sp do
					local double = i % 2 == 0
					local side = 1
					if double then side = -1 end
					
					local circle = objDUTCircle2:create(player.x + i * 2 * side, player.y - (ii * 8))
					circle.blendColor = playerData.activeColor
					circle.alpha = 0.7
					circleData = circle:getData()
					circleData.damage = playerAc.damage * 10
					circleData.team = playerAc.team
					circleData.parent = player
					circleData.hspeed = playerAc.pHspeed * 0.5 + (scepter * 0.1)
					--circleData.vspeed = playerAc.pVspeed
					circleData.mode = playerData.mode
					circleData.rate = playerAc.attack_speed
					--circleData.scepter = playerAc.scepter
					if double then
						circleData.hspeed = (playerAc.pHspeed * 0.5 + (scepter * 0.1)) * -1
					end
				end
			end
		end
	end
end)

dut:addCallback("step", function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	if syncControlRelease(player, "ability1") and not player:getData().skin_skill1Override then
		playerAc.z_skill = 0
		if playerData.charge > 0 then
			if playerData.mode == 1 then
				playerData.mode1ShootFunc(player)
			else
				playerData.mode2ShootFunc(player)
			end
			playerData.charge = 0
		end
	end
	if playerData.charge >= z_max then
		if not playerData._chargeMax then
			sDutCharge:play(0.9 + math.random() * 0.2)
			playerData._chargeMax = true
		end
		if global.timer % 60 == 0 then
			local flash = obj.EfFlash:create(0,0):set("parent", player.id):set("rate", 0.01)
			flash.depth = player.depth - 1
			flash.alpha = 0.75
			flash.blendColor = playerData.activeColor
		else
			for _, flash in ipairs(obj.EfFlash:findMatching("parent", player.id)) do
				flash.blendColor = playerData.activeColor
				break
			end
		end
	else
		playerData._chargeMax = false
	end
	
	if playerData.syncChange then
		if playerData.syncChange > 0 then
			playerData.syncChange = playerData.syncChange - 1
		else
			if net.online and player == net.localPlayer then
				if net.host then
					syncState:sendAsHost(net.ALL, nil, player:getNetIdentity(), playerData.mode)
				else
					syncState:sendAsClient(player:getNetIdentity(), playerData.mode)
				end
			end
			playerData.syncChange = nil
		end
	end
end) 

local onPlayerDrawBelowCall = function(player)
	if player:getSurvivor() == dut and player:get("activity") == 30 then
		local playerData = player:getData()
		
		local size = playerData.charge
		if playerData.charge > z_max then
			local add = (playerData.charge - z_max) * 0.05
			size = size + math.random(- 5 * add, 5 * add)
		end
		
		graphics.alpha(0.7)
		graphics.color(playerData.activeColor)
		graphics.circle(player.x, player.y - 8, size, false)
		graphics.color(Color.WHITE)
		graphics.circle(player.x, player.y - 8, math.max(size - 3, 0), false)
	end
end
dut:addCallback("draw", function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	

	
	--[[if player:hasBuff(buff.Charge) then
		graphics.drawImage{
			image = player.sprite,
			x = player.x,
			y = player.y,
			color = Color.YELLOW,
			alpha = player.alpha * 0.55,
			angle = player.angle,
			xscale = player.xscale,
			yscale = player.yscale,
			subimage = player.subimage
		}
	end]]
	
	if playerAc.z_skill == 1 and playerAc.activity < 6 then
		if  playerData.charge < z_max then
			if playerData.mode == 1 then
				playerData.mode1DrawFunc(player)
			else
				playerData.mode2DrawFunc(player)
			end
		end
	end
	
	if playerAc.activity ~= 30 then
		local size = playerData.charge
		if playerData.charge > z_max then
			local add = (playerData.charge - z_max) * 0.05
			size = size + math.random(- 5 * add, 5 * add)
		end
		
		local xx = player.x + (5 + (player:getData().charge * 0.2)) * player.xscale
		local yy = player.y - 2
		graphics.alpha(0.7)
		graphics.color(playerData.activeColor)
		graphics.circle(xx, yy, size, false)
		graphics.color(Color.WHITE)
		graphics.circle(xx, yy, math.max(size - 3, 0), false)
	end
end)

dut:addCallback("init", function(player)
	player:getData().mode1HoldFunc = mode1HoldFunc
	player:getData().mode1DrawFunc = mode1DrawFunc
	player:getData().mode1ShootFunc = mode1ShootFunc
	player:getData().mode2HoldFunc = mode2HoldFunc
	player:getData().mode2DrawFunc = function() end
	player:getData().mode2ShootFunc = mode2ShootFunc
	tcallback.register("onPlayerDrawBelow", onPlayerDrawBelowCall)
end)

sur.DUT = dut