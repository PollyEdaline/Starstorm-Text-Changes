
-- All Nucleator data

local path = "Survivors/Nucleator/"

local nucleator = Survivor.new("Nucleator")

-- Bar
local sprBar = Sprite.load("Nucleator_Bar", path.."bar", 1, 4, 6)

-- Skill 3 Buff
local radiation = buff.radiation

-- Sounds
local sShoot1a = Sound.load("Nucleator_Shoot1A", path.."skill1a")
local sShoot1b = Sound.load("Nucleator_Shoot1B", path.."skill1b")
local sShoot1c = Sound.load("Nucleator_Shoot1C", path.."skill1c")

local sShoot2 = Sound.load("Nucleator_Shoot2", path.."skill2")

local sShoot3a = Sound.load("Nucleator_Shoot3A", path.."skill3a")
local sShoot3b = Sound.load("Nucleator_Shoot3B", path.."skill3b")
local sShoot3c = Sound.load("Nucleator_Shoot3C", path.."skill3c")

local sShoot4a = Sound.load("Nucleator_Shoot4A", path.."skill4a")
local sShoot4b = Sound.load("Nucleator_Shoot4B", path.."skill4b")
local sShoot4c = Sound.load("Nucleator_Shoot4C", path.."skill4c")

local sAlarm = Sound.load("Nucleator_Alarm", path.."alarm")

-- Sprite Table
local sprites = {
	idle = Sprite.load("Nucleator_Idle", path.."idle", 1, 7, 9),
	walk = Sprite.load("Nucleator_Walk", path.."walk", 8, 7, 9),
	jump = Sprite.load("Nucleator_Jump", path.."jump", 1, 6, 10),
	climb = Sprite.load("Nucleator_Climb", path.."climb", 2, 4, 9),
	death = Sprite.load("Nucleator_Death", path.."death", 5, 5, 9),
	decoy = Sprite.load("Nucleator_Decoy", path.."decoy", 1, 9, 10),
	
	shoot1 = Sprite.load("Nucleator_Shoot1", path.."shoot1", 19, 10, 26),
	shoot2 = Sprite.load("Nucleator_Shoot2", path.."shoot2", 23, 10, 12),
	shoot2_2 = Sprite.load("Nucleator_Shoot2B", path.."shoot2_2", 6, 10, 12),
	shoot3 = Sprite.load("Nucleator_Shoot3", path.."shoot3", 16, 15, 24),
	shoot4_1 = Sprite.load("Nucleator_Shoot4", path.."shoot4", 6, 11, 12),
	shoot4_2 = Sprite.load("Nucleator_Shoot5", path.."shoot5", 6, 11, 12),
}
-- Hit sprites
local sprSparks = Sprite.load("Nucleator_Sparks", path.."sparks", 3, 13, 8)

-- Skill sprites
local sprSkills = Sprite.load("Nucleator_Skills", path.."skills",5, 0, 0)

-- Selection sprite
nucleator.loadoutSprite = Sprite.load("Nucleator_Select", path.."select", 16, 2, 0)

-- Selection description
nucleator:setLoadoutInfo(
[[The &y&Nucleator&!& is a radioactive juggernaut with rad-proof armor,
which allows him to manipulate nuclear components for long periods of time.
He takes advantage of radiation; &y&being able to inflict it to enemies&!& for the
strongest contamination effect. Nucleator can &b&charge&!& his skills for &y&maximum output&!&,
however, be careful as &r&overcharging&!& them may lead to &r&self-harm!]], sprSkills)

-- Skill descriptions
nucleator:setLoadoutSkill(1, "Irradiate",
[[Fire a bullet for up to &y&500% damage&!&, &r&900% on overcharge.&!&
The bullet's &y&damage increases the farther it travels.]])

nucleator:setLoadoutSkill(2, "Quarantine",
[[Push enemies in front of you for &y&300% piercing damage.]])

nucleator:setLoadoutSkill(3, "Fission Impulse",
[[&b&Hold to launch yourself into any direction&!& dealing &y&550% damage.
&b&Control the direction&!& using the movement keys.]])

nucleator:setLoadoutSkill(4, "Radionuclide Surge",
[[Enter a &y&Nuclear&!& state for 6 seconds.
While &y&Nuclear&!&, all attacks deal &y&radiation&!& damage over time.
&r&Overcharging&!& abilities doesn't damage you in this state.]])

-- Color of highlights during selection
nucleator.loadoutColor = Color.fromRGB(255, 250, 0)

-- Misc. menus sprite
nucleator.idleSprite = sprites.idle

-- Main menu sprite
nucleator.titleSprite = sprites.walk

-- Endquote
nucleator.endingQuote = "..and so he left, health status undisclosed."

-- Stats & Skills
nucleator:addCallback("init", function(player)
	local playerAc = player:getAccessor()
	playerAc.pHmax = 1.115
	playerAc.walk_speed_coeff = 1.09
	
	player:setAnimations(sprites)
	
	if Difficulty.getActive() == dif.Drizzle then
		player:survivorSetInitialStats(165, 12, 0.0395)
	else
		player:survivorSetInitialStats(115, 12, 0.0095)
	end
	
	player:setSkill(1, "Irradiate", "Fire a bullet for a minimum of 160% damage, 550% maximum on larger distances.",
	sprSkills, 1, 25)
		
	player:setSkill(2, "Quarantine", "Push enemies in front of you for 300% pierce-degrading damage",
	sprSkills, 2, 4 * 60)
		
	player:setSkill(3, "Fission Impulse", "Hold to launch yourself into any direction for 550% damage. Control the direction with the movement controls.",
	sprSkills, 3, 6 * 60)
		
	player:setSkill(4, "Radionuclide Rush", "Go into a nuclear state, adding radiation DoT to every attack while becoming invulnerable to overcharging skills. Lasts 6 seconds",
	sprSkills, 4, 13 * 60)
end)

-- Called when the player levels up
nucleator:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(34, 3, 0.002, 2)
end)

-- Called when the player picks up the Ancient Scepter
nucleator:addCallback("scepter", function(player)
	player:setSkill(4,
	"Radionuclide Efflux", "Go into a nuclear state, adding radiation DoT to every attack while becoming invulnerable to overcharging skills. Lasts 12 seconds.", 
	sprSkills, 5, 15 * 60)
end)

-- Skills

-- Bullet Object
local objBullet = Object.new("NucleatorBullet")
local sprBullet = Sprite.load("NucleatorBullet", path.."bullet", 4, 10, 5)
local sprBulletMask = Sprite.load("NucleatorBulletMask", path.."bulletMask", 1, 4, 3)
local sprBulletExplosion = Sprite.load("NucleatorBulletEX", path.."bulletExplosion", 6, 11, 10)
local enemies = pobj.enemies

objBullet.sprite = sprBullet
objBullet.depth = 0.1

local parNuclear = par.NucleatorBullet

objBullet:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	selfAc.life = 92
	selfAc.speed = 2.9
	selfAc.size = 0.5
	selfAc.damage = 1.45
	self.spriteSpeed = 0.25
	self.mask = sprBulletMask
	selfData.team = "player"
end)
objBullet:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	local parent = selfData.parent
	
	self.y = self.y - (math.max(0, 1.55 - selfAc.size) * math.sin(selfAc.speed * 10))
	if selfAc.direction == 0 then
		self.yscale = selfAc.size * 1.28
		self.xscale = selfAc.size * 1.28
		self.x = self.x + selfAc.speed
	else
		self.yscale = selfAc.size * 1.28
		self.xscale = -1 * selfAc.size * 1.28
		self.x = self.x - selfAc.speed
	end
	if global.quality > 1 and math.chance(selfAc.size * 32) then 
		parNuclear:burst("middle", self.x, self.y, 1)
	end
	if parent and parent:isValid() then
		local xr, yr = 4 * self.xscale, 3 * self.yscale
		for _, actor in ipairs(pobj.actors:findAllRectangle(self.x - xr, self.y - yr, self.x + xr, self.y + yr)) do
			if actor:get("team") ~= selfData.team and self:collidesWith(actor, self.x, self.y) then
				if global.quality > 1 then
					par.Spark:burst("middle", self.x, self.y, 2)
				end
				selfAc.life = 0
			end
		end
	end
	
	if selfAc.life == 0 or Stage.collidesPoint(self.x, self.y) then
		sShoot1b:play(math.max((1 + math.random() * 0.2) - (selfAc.size * 0.5), 0.3), 0.7)
		if parent and parent:isValid() then
			for i = 0, parent:get("sp") do
				explosion = parent:fireExplosion(self.x, self.y, 12 / 19, 12 / 4, selfAc.damage, sprBulletExplosion, nil)
				explosion:set("direction", parent:getFacingDirection())
				explosion:set("knockback", 4)
				explosion:set("damage_fake", selfAc.damage * parent:get("damage"))
				selfAc.life = 0
				if i ~= 0 then
					explosion:set("climb", i * 8)
				end
			end
		end
			
		if global.quality > 1 then
			par.Spark:burst("middle", self.x, self.y, 4)
		end
		self:destroy()
	else
		selfAc.life = selfAc.life - 1
		selfAc.speed = selfAc.speed * 0.99
		selfAc.size = selfAc.size * 1.01
		selfAc.damage = selfAc.damage + 0.062
	end
end)

-- Efflux Object
local objEfflux = Object.new("NucleatorEfflux")
local sprEffluxMask = Sprite.load("NucleatorEffluxMask", path.."effluxMask", 1, 10, 10)

objEfflux:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	selfAc.life = 110
	selfAc.speed = 2
	selfAc.size = 0.5
	selfAc.damage = 5
	self.spriteSpeed = 0.25
	self.mask = sprEffluxMask
	selfData.team = "player"
	selfData.side = 1
end)
objEfflux:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	local parent = selfData.parent
	
	self.yscale = selfAc.size * 1.28
	self.xscale = selfAc.size * 1.28
	
	if global.quality > 1 and math.chance(selfAc.size * 90) then 
		parNuclear:burst("above", self.x, self.y, 2)
	end
	
	local target = nil
	for _, instance2 in ipairs(pobj.actors:findAll()) do
		if not isa(instance2, "PlayerInstance") or instance2:get("dead") == 0 then
			if instance2:get("team") ~= selfData.team then
				if selfData.side > 0 and instance2.x > self.x or selfData.side < 0 and instance2.x < self.x then 
					local dis = distance(self.x, self.y, instance2.x, instance2.y)
					if not target or dis < target.dis then
						target = {inst = instance2, dis = dis}
					end
				end
			end
		end
	end
	if target then
		target = target.inst
	end
	
	if target and target:getObject() ~= obj.actorDummy then
		local angle = selfAc.direction
		if target.y < self.y + 80 and target.y > self.y - 80 then
			angle = posToAngle(self.x, self.y, target.x, target.y)
		end
		local speedMult = selfAc.speed / 2
		selfAc.direction = selfAc.direction + (angleDif(selfAc.direction, angle) * -0.025 * speedMult)
		if parent and parent:isValid() and self:collidesWith(target, self.x, self.y) then
			if global.quality > 1 then
				par.Spark:burst("middle", self.x, self.y, 2)
			end
			selfAc.life = 0
		end
	end
	
	if selfAc.life == 0 then
		sShoot4c:play((1 + math.random() * 0.2) + 0.5 - (selfAc.size * 0.5), 0.9)
		if parent then
			for i = 0, parent:get("sp") do
				explosion = parent:fireExplosion(self.x, self.y, (selfAc.size * 19) / 19, (selfAc.size * 19) / 4, selfAc.damage, sprBulletExplosion, nil)
				--explosion:getData().radiate = true
				explosion:set("direction", parent:getFacingDirection())
				explosion:set("knockback", 4)
				explosion:set("damage_fake", selfAc.damage * parent:get("damage"))
				selfAc.life = 0
				for i = 0, 3 do 
					local bolt = obj.ChainLightning:create(self.x, self.y)
					bolt:set("blend", Color.fromHex(0xE1FF00).gml)
					bolt:set("damage", math.floor(selfAc.damage * parent:get("damage")))
					bolt:set("team", selfData.team)
					bolt:set("parent", parent.id)
				end
				if i ~= 0 then
					explosion:set("climb", i * 8)
				end
			end
		end
			
		if global.quality > 1 then
			par.Spark:burst("middle", self.x, self.y, 15)
		end
		self:destroy()
	else
		selfAc.life = selfAc.life - 1
		selfAc.speed = selfAc.speed * 0.99
		selfAc.size = selfAc.size * 1.0091
		selfAc.damage = selfAc.damage + 0.073
	end
end)
objEfflux:addCallback("draw", function(self)
	local add = math.random() * 2
	graphics.color(Color.fromHex(0xE1FF00))
	graphics.alpha(0.9)
	graphics.circle(self.x, self.y, self:get("size") * 18 + add, false)
	graphics.color(Color.WHITE)
	graphics.alpha(1)
	graphics.circle(self.x, self.y, self:get("size") * 14 + add, false)
end)

-- Push Object
local objPush = Object.new("NucleatorPush")
objPush.sprite = Sprite.load("NucleatorPush", path.."push", 4, 22, 15)
local sprPushMask = Sprite.load("NucleatorPushMask", path.."pushMask", 1, 3, 10)
objPush:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	selfData.timer = 90
	selfData.timer2 = 0
	selfData.team = "player"
	selfData.damage = 10
	self.spriteSpeed = 0.15
	self.mask = sprPushMask
	self.alpha = 0
end)

objPush:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	self.y = self.y + 0.116
	
	if selfData.timer > 0 then
		self.alpha = math.min(selfData.timer * 0.2, selfData.timer2)
		selfData.timer2 = selfData.timer2 + 0.15
		
		if math.chance(50) and global.quality > 1 then
			parNuclear:burst("above", self.x, self.y + math.random(-15, 15), 1)
		end
		selfAc.speed = 2.3
		self.angle = selfAc.direction
		if selfData.timer % 4 == 0 then
			local proc = DAMAGER_NO_PROC
			if selfData.timer % 30 == 0 then proc = 0 end
			if selfData.parent and selfData.parent:isValid() then
				local r = 50
				for _, actor in ipairs(pobj.actors:findAllRectangle(self.x - r, self.y - 1, self.x + r, self.y + r)) do
					if actor:get("team") ~= selfData.team and actor:collidesWith(self, actor.x, actor.y) then
						selfData.parent:fireBullet(self.x, actor.y, selfAc.direction, 30, 0.4, nil, proc):set("knockback", 6.4):set("knockup", 2):set("specific_target", actor.id)
					end
				end
			else
				for _, actor in ipairs(pobj.actors:findAll()) do
					if actor:get("team") ~= selfData.team and actor:collidesWith(self, actor.x, actor.y) then
						misc.fireBullet(self.x, actor.y, selfAc.direction, 30, selfData.damage, selfData.team, nil, proc):set("knockback", 6.4):set("knockup", 2):set("specific_target", actor.id)
					end
				end
			end
		end
		self.yscale = self.yscale - 0.01
		selfData.timer = selfData.timer - 1
	else
		self:destroy()
	end
end)

-- Arrow Object
local objArrow = Object.new("NucleatorSkillHelper")
local sprArrow = Sprite.load("Arrow", path.."arrow", 1, 9, 1)
objArrow.sprite = sprArrow
objArrow.depth = -99

objArrow:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.life = 92
	selfData.xx = 0
	selfData.yy = 0
	selfData.parent = nil
	self.angle = -45
end)
objArrow:addCallback("step", function(self)
	local selfData = self:getData()
	local parent = selfData.parent
	
	if parent and parent:isValid() then
		local pHspeed = (parent:get("pHmax") + 2.3) / 3 
		local pVspeed = ((parent:get("pHmax") * 0.5) + 0.7 + parent:get("pVmax")) / 4
		
		local gamepad = input.getPlayerGamepad(parent)
		if gamepad == nil then
			if parent:control("left") == input.HELD then
				selfData.xx = selfData.xx - pHspeed
			elseif parent:control("right") == input.HELD then
				selfData.xx = selfData.xx + pHspeed
			end
			if parent:control("up") == input.HELD then
				selfData.yy = selfData.yy - pVspeed
			elseif parent:control("down") == input.HELD then
				selfData.yy = selfData.yy + pVspeed
			end
		else
			-- DPAD
			if input.checkGamepad("padl", gamepad) == input.HELD  then
				selfData.xx = selfData.xx - pHspeed
			elseif input.checkGamepad("padr", gamepad) == input.HELD  then
				selfData.xx = selfData.xx + pHspeed
			end
			if input.checkGamepad("padu", gamepad) == input.HELD  then
				selfData.yy = selfData.yy - pVspeed
			elseif input.checkGamepad("padd", gamepad) == input.HELD  then
				selfData.yy = selfData.yy + pVspeed
			end
			-- L JOYSTICK
			if input.getGamepadAxis("lh", gamepad) ~= 0 then
				selfData.xx = selfData.xx + pHspeed * input.getGamepadAxis("lh", gamepad)
			end
			if input.getGamepadAxis("lv", gamepad) ~= 0 then
				selfData.yy = selfData.yy + pVspeed * input.getGamepadAxis("lv", gamepad)
			end
		end
		self.x = parent.x + selfData.xx
		self.y = parent.y + selfData.yy
		self.angle = math.deg(math.atan2(selfData.yy * -1, selfData.xx)) - 45
		if parent:get("dead") == 1 or not parent:getData().chargingC then
			self:destroy()
		end
	else
		self:destroy()
	end
end)
objArrow:addCallback("draw", function(self)
	local selfData = self:getData()
	local parent = selfData.parent
	graphics.alpha(0.65)
	graphics.color(Color.WHITE)
	if parent and parent:isValid() then
		graphics.line(parent.x, parent.y-4, self.x, self.y, 2)
	end
end)

-- Sync Arrow
local syncNucArrow
syncNucArrow = net.Packet.new("SSNucleatorArrow", function(player, player, arrowx, arrowy, arrowxx, arrowyy)
	if player and arrowx and arrowy then
		local instanceRes = player:resolve()
		if instanceRes and instanceRes:isValid() then
			local arrow = instanceRes:getData().childArrow
			if arrow and arrow:isValid() then
				arrow.x = arrowx
				arrow:getData().xx = arrowxx
				arrow.y = arrowy
				arrow:getData().yy = arrowyy
			end
			if net.host then
				syncNucArrow:sendAsHost(net.EXCLUDE, sender, instanceRes:getNetIdentity(), arrowx, arrowy, arrowxx, arrowyy)
			end
		end
	end
end)

-- Skill Activation

nucleator:addCallback("useSkill", function(player, skill)
	local playerAc = player:getAccessor()
	if player:get("activity") == 0 then
		if skill == 1 and not player:getData().skill1Used then
			-- Z skill
			player:survivorActivityState(1, player:getAnimation("shoot1"), 0.19, true, true)
		elseif skill == 2 then
			-- X skill
			player:survivorActivityState(2, player:getAnimation("shoot2"), 0.22, true, true)
		elseif skill == 3 then
			-- C skill
			player:survivorActivityState(3, player:getAnimation("shoot3"), 0.18, false, true)
		elseif skill == 4 then
			-- V skill
			if playerAc.scepter > 0 then
				player:survivorActivityState(4, player:getAnimation("shoot4_1"), 0.25, true, true)
			else
				player:survivorActivityState(4, player:getAnimation("shoot4_2"), 0.25, true, true)
			end
		end
		player:activateSkillCooldown(skill)
	end
end)

nucleator:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if skill == 1 and not playerData.skin_skill1Override then
		-- Irradiate
		if relevantFrame == 1 then
			playerData.skill1Used = true
		end
		
		if relevantFrame == 3 then
			local bar = obj.CustomBar:create(player.x, player.y + 100)
			bar.sprite = sprBar
			bar:set("time", player.sprite.frames - player.subimage)
			bar:set("maxtime", player.sprite.frames - 4)
			bar:set("barColor", Color.fromHex(0xE0F82C).gml)
			bar:set("parent", player.id)
			bar:set("charge", 1)
			bar:setAlarm(0, 1000)
			playerData.chargeBar = bar
			playerData.chargeBar:getData().yy = 100
		end
		
		if playerData.chargeBar and playerData.chargeBar:isValid() then
			playerData.chargeBar:set("time", player.sprite.frames - player.subimage)
			
			if player.subimage >= 11 then
				local charge = math.clamp((player.subimage - 11) / (player.sprite.frames - 4 - 11), 0, 1)
				playerData.zCharge = charge
				playerData.chargeBar:set("barColor", Color.mix(Color.fromHex(0xE0F82C), Color.RED, charge).gml)
				if not net.online or net.localPlayer == player then
					misc.shakeScreen(1)
				end
			end
		end
		
		if relevantFrame < 11 then
			playerData.zCharge2 = player.subimage / (player.sprite.frames - 4 - 5)
		end
		
		if relevantFrame == 11 then
			sAlarm:play()
		end
		if relevantFrame == 4 then
			sShoot3c:play(1 + math.random() * 0.2, 0.7)
		end
		if relevantFrame > 11 and relevantFrame < player.sprite.frames - 3 and not player:hasBuff(radiation) then
			if global.quality > 1 then
				parNuclear:burst("above", player.x, player.y, 1)
			end
			playerAc.hp = math.max(playerAc.hp * 0.80, 1) 
		end
		
		if relevantFrame == player.sprite.frames - 3 then
			sShoot1a:play(1 + math.random() * 0.2, 0.7)
			if playerData.zCharge then
				sShoot1c:play(1 + math.random() * 0.2, 0.7)
				local ball = objEfflux:create(player.x, player.y - 5)
				ball:set("damage", (playerData.zCharge * 2) * 1.5)
				ball:set("size", (playerData.zCharge * 0.3) + 0.5)
				ball:set("life", 120 - math.floor(playerData.zCharge * 20))
				ball:set("speed", (math.sqrt(player:get("attack_speed") * 3) + 6 - (playerData.zCharge * 4.5)) / 2)
				ball:set("direction", player:getFacingDirection())
				ball:getData().parent = player
				ball:getData().side = player.xscale
				playerData.zCharge = nil
			else
				if player:survivorFireHeavenCracker(2) == nil then
					local bullet = objBullet:create(player.x, player.y - 2)
					--bullet:getData().radiate = true
					bullet:set("size", (playerData.zCharge2 * 0.5) + 0.45)
					bullet:set("speed", 3 - playerData.zCharge2)
					bullet:set("damage", 1.3 + playerData.zCharge2)
					bullet:set("direction", player:getFacingDirection())
					bullet:getData().parent = player
					playerData.zCharge2 = nil
				end
			end
			if playerData.chargeBar and playerData.chargeBar:isValid() then
				playerData.chargeBar:destroy()
			end
		end
		
	elseif skill == 2 and not playerData.skin_skill2Override then
		-- Quarantine
		if relevantFrame == 1 then
			playerData.skill2Used = true
		end
		
		local midp, endp = 9, player.sprite.frames - 7
		
		if relevantFrame == 2 then
			local bar = obj.CustomBar:create(player.x, player.y + 100)
			bar.sprite = sprBar
			bar:set("time", endp - player.subimage)
			bar:set("maxtime", endp)
			bar:set("barColor", Color.fromHex(0xE0F82C).gml)
			bar:set("parent", player.id)
			bar:set("charge", 1)
			bar:setAlarm(0, 1000)
			playerData.chargeBar = bar
			playerData.chargeBar:getData().yy = 100
		end
		
		if playerData.chargeBar and playerData.chargeBar:isValid() then
			playerData.chargeBar:set("time", endp - player.subimage)
			
			if player.subimage >= midp then
				local charge = math.clamp((player.subimage - 9) / (endp - 7), 0, 1)
				
				playerData.xCharge = charge
				playerData.chargeBar:set("barColor", Color.mix(Color.fromHex(0xE0F82C), Color.RED, charge).gml)
				if not net.online or net.localPlayer == player then
					misc.shakeScreen(1)
				end
			end
		end
		
		if relevantFrame < midp then
			playerData.xCharge2 = player.subimage / (endp - 4)
		end
		
		if relevantFrame == midp then
			sAlarm:play()
		end
		if relevantFrame == 4 then
			sShoot3c:play(1 + math.random() * 0.2, 0.7)
		end
		if relevantFrame > midp and relevantFrame < player.sprite.frames - 9 and not player:hasBuff(radiation) then
			if global.quality > 1 then
				parNuclear:burst("above", player.x, player.y, 1)
			end
			playerAc.hp = math.max(playerAc.hp * 0.8, 1) 
		end
		
		if relevantFrame == endp then
			if playerData.chargeBar and playerData.chargeBar:isValid() then
				playerData.chargeBar:destroy()
			end
		elseif relevantFrame == endp + 1 then
			
			sShoot2:play(1 + math.random() * 0.2, 0.7)
			if playerData.xCharge then
				local bullet = objPush:create(player.x, player.y - (9 + 3 * playerData.xCharge))
				local bData = bullet:getData()
				local bAc = bullet:getAccessor()
				bAc.direction = player:getFacingDirection()
				bData.parent = player
				bData.damage = playerAc.damage
				bData.team = playerAc.team
				bData.timer = math.ceil(45 + playerData.xCharge * 105)
				bullet.yscale = bullet.yscale + playerData.xCharge * 0.4
				playerData.xCharge = nil
				misc.shakeScreen(3)
			else
				local sparks = obj.EfSparks:create(player.x, player.y)
				sparks.xscale = player.xscale
				sparks.yscale = player.yscale
				sparks.sprite = player:getAnimation("shoot2_2")
				sparks.spriteSpeed = player.spriteSpeed
				for i = 0, playerAc.sp do
					local bullet = player:fireBullet(player.x, player.y - 2, player:getFacingDirection(), 90, 3, nil, DAMAGER_BULLET_PIERCE)
					--bullet:getData().radiate = true
					bullet:set("knockback", 11)
					bullet:set("knockback_direction", player.xscale)
					bullet:set("knockup", 3)
					bullet:set("damage_degrade", 0.5)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
				playerData.xCharge2 = nil
			end
		end
		
	elseif skill == 3 and not playerData.skin_skill3Override then
        -- Fission Impulse
		if relevantFrame == 2 then
		local bar = obj.CustomBar:create(player.x, player.y)
			bar.sprite = sprBar
			bar:set("time", player.sprite.frames - player.subimage)
			bar:set("maxtime", player.sprite.frames - 2)
			bar:set("barColor", Color.fromHex(0xE0F82C).gml)
			bar:set("parent", player.id)
			bar:set("charge", 1)
			bar:setAlarm(0, 1000)
			playerData.chargeBar = bar
			playerData.chargeBar:getData().yy = 100
		end
		
		if playerData.chargeBar and playerData.chargeBar:isValid() then
			playerData.chargeBar:set("time", player.sprite.frames - player.subimage)
			
			if player.subimage >= 9 then
				local charge = math.clamp((player.subimage - 9) / (player.sprite.frames - 2 - 9), 0, 1)
				playerData.chargeBar:set("barColor", Color.mix(Color.fromHex(0xE0F82C), Color.RED, charge).gml)
				if not net.online or net.localPlayer == player then
					misc.shakeScreen(1)
				end
			end
		end
		if relevantFrame == 9 then
			sAlarm:play()
		end
		if relevantFrame == 6 then
			sShoot3c:play(1 + math.random() * 0.2, 0.7)
		end
		if relevantFrame > 9 and relevantFrame < player.sprite.frames - 1 and not player:hasBuff(radiation) then
			playerAc.hp = math.max(playerAc.hp * 0.92, 1) 
		end
		
		if relevantFrame < 9 then
			playerAc.invincible = playerAc.invincible + 1
		end
		
		if net.online and player == net.localPlayer then
			local child = playerData.childArrow
			if child and child:isValid() then
				if net.host then
					syncNucArrow:sendAsHost(net.ALL, nil, player:getNetIdentity(), child.x, child.y, child:getData().xx, child:getData().yy)
				else
					syncNucArrow:sendAsClient(player:getNetIdentity(), child.x, child.y, child:getData().xx, child:getData().yy)
				end
			end
		end
		
        if relevantFrame == 1 then
			playerData.chargingC = true
			playerAc.invincible = playerAc.invincible + 2
			local arrow = objArrow:create(player.x, player.y)
			playerData.childArrow = arrow
			arrow:getData().yy = -4
			arrow:getData().parent = player
			sShoot3a:play(1 + math.random() * 0.2, 0.7)
		elseif relevantFrame == player.sprite.frames - 1 then
			playerData.chargingC = false
			local child = playerData.childArrow
			if child and child:isValid() then
				local angle = child.angle + 45
				local xx = child:getData().xx
				local yy = child:getData().yy
				local xspeed = math.abs(math.cos(math.rad(angle)) * xx)
				local yspeed = math.abs(math.sin(math.rad(angle)) * yy)
				local xy = (xspeed + yspeed)
				sShoot3b:play(1 + math.random() * 0.2, 0.7)
				for i = 0, playerAc.sp do
					local bullet = player:fireBullet(player.x, player.y-2, angle + 0.1, 1.09 * xy, 5.5, sprSparks, DAMAGER_BULLET_PIERCE)
					--bullet:getData().radiate = true
					if yy ~= 0 then
						bullet:set("knockup", math.abs(yy) * 0.1)
					end
					if xx ~= 0 then
						bullet:set("knockback", math.abs(xx) * 0.08)
					end
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
				player.y = player.y - 1
				--playerAc.pHspeed = xx * 0.19
				playerData.xAccel = xx * 0.1
				playerAc.pVspeed = yy * 0.1
				--[[if net.online then
					if player == net.localPlayer then
						if net.host then
							syncInstanceVar:sendAsHost(net.ALL, nil, player:getNetIdentity(), "pVspeed", playerAc.pVspeed)
							syncInstanceData:sendAsHost(net.ALL, nil, player:getNetIdentity(), "xAccel", playerData.xAccel)
						else
							syncInstanceVar:sendAsClient(player:getNetIdentity(), "pVspeed", playerAc.pVspeed)
							syncInstanceData:sendAsClient(player:getNetIdentity(), "xAccel", playerData.xAccel)
						end
					end
				end]]
				playerAc.skill3 = 1
				local dis = distance(child.x, child.y, player.x, player.y)
				local amount = dis / 3 + (3 - global.quality)
				for i = 1, amount do
					local ratio = (i * dis) / amount
					local xx, yy = pointInLine(child.x, child.y, player.x, player.y, ratio)
					if global.quality > 1 then
						parNuclear:burst("above", xx, yy, 1)
					end
				end
				child:destroy()
			end
			if global.quality > 1 then
				par.Spark:burst("middle", player.x, player.y, 4)
			end
			if playerData.chargeBar and playerData.chargeBar:isValid() then
				playerData.chargeBar:destroy()
			end
		end

	elseif skill == 4 and not playerData.skin_skill4Override then
		-- Radionuclide Rush
		if relevantFrame == 1 then
			
			misc.shakeScreen(3)
			if playerAc.scepter > 0 then
				if global.quality > 2 then
					par.NucleatorBullet:burst("above", player.x, player.y, 24)
				elseif global.quality > 1 then
					par.NucleatorBullet:burst("above", player.x, player.y, 12)
				end
				sShoot4b:play(1 + math.random() * 0.2)
				player:applyBuff(radiation, 375 + (405 * playerAc.scepter))
			else
				if global.quality > 2 then
					par.NucleatorBullet:burst("above", player.x, player.y, 14)
				elseif global.quality > 1 then
					par.NucleatorBullet:burst("above", player.x, player.y, 6)
				end
				sShoot4a:play(1 + math.random() * 0.2)
				player:applyBuff(radiation, 375)
			end
		end
	end
end)

nucleator:addCallback("step", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	local syncRelease1 = syncControlRelease(player, "ability1")
	local syncRelease2 = syncControlRelease(player, "ability2")
	local syncRelease3 = syncControlRelease(player, "ability3")
	
	if playerAc.activity == 1 and not playerData.skin_skill1Override then
		if syncRelease1 and playerData.skill1Used then
			player.subimage = player.sprite.frames - 3
			sShoot3c:stop()
			playerData.skill1Used = nil
			if playerData.chargeBar and playerData.chargeBar:isValid() then
				playerData.chargeBar:destroy()
			end
		end
	elseif playerAc.activity == 2 and not playerData.skin_skill2Override then
		if syncRelease2 and playerData.skill2Used then
			playerData.skill2Used = nil
			if player.subimage < player.sprite.frames - 7 then
				player.subimage = player.sprite.frames - 7
				sShoot3c:stop()
			end
			if playerData.chargeBar and playerData.chargeBar:isValid() then
				playerData.chargeBar:destroy()
			end
		end
	elseif playerAc.activity == 3 and not playerData.skin_skill3Override then
		if syncRelease3 then
			if player.subimage > 4 then
				player.subimage = player.sprite.frames - 1
				sShoot3c:stop()
			else
				playerData.endChargeAt = 7
			end
			if playerData.chargeBar and playerData.chargeBar:isValid() then
				playerData.chargeBar:destroy()
			end
		end
	end
	
	if playerAc.activity == 0 and playerData.chargeBar and playerData.chargeBar:isValid() then
		playerData.chargeBar:destroy()
	end
	
	if syncRelease1 and playerAc.activity ~= 1 and playerData.skill1Used then
		playerData.skill1Used = nil
	end
	-- ew code
	if playerData.endChargeAt and player.subimage >= playerData.endChargeAt then
		if playerAc.activity == 3 then
			player.subimage = player.sprite.frames - 1
		end
		playerData.endChargeAt = nil
		sShoot3c:stop()
	end
	if playerAc.skill3 == 1 then
		if playerAc.free == 0 or playerAc.pVspeed > 1 or playerAc.activity == 30 then
			playerAc.skill3 = 0
		end
		if global.quality > 2 and math.chance(60) then
			par.NucleatorBullet:burst("below", player.x, player.y, 2)
		end
	end
end)

callback.register("onPlayerDeath", function(player)
	if player:getSurvivor() == nucleator then
		if player:getData().chargeBar and player:getData().chargeBar:isValid() then
			player:getData().chargeBar:destroy()
		end
	end
end)

sur.Nucleator = nucleator