-- PROTOTYPE

local path = "Survivors/DU-T/Skins/DELIVER-E/"

local survivor = Survivor.find("DU-T", "Starstorm")
local sprSelect = Sprite.load("DeliverySelect", path.."Select", 18, 2, 0)
local Delivery = SurvivorVariant.new(survivor, "SPEE-D", sprSelect, {
	idle = Sprite.load("DeliveryIdle", path.."idle", 1, 7, 11),
	walk = Sprite.load("DeliveryWalk", path.."walk", 8, 15, 11),
	jump = Sprite.load("DeliveryJump", path.."jump", 1, 7, 14),
	climb = Sprite.load("DeliveryClimb", path.."climb", 2, 4, 10),
	death = Sprite.load("DeliveryDeath", path.."death", 10, 10, 14),
	decoy = Sprite.load("DeliveryDecoy", path.."decoy", 1, 9, 14),
	
	shoot1_1 = Sprite.load("DeliveryShoot1_1", path.."shoot1_1", 3, 7, 11),
	shoot1_2 = Sprite.load("DeliveryShoot1_2", path.."shoot1_2", 3, 7, 11),
	shoot3 = Sprite.load("DeliveryShoot3", path.."shoot3", 9, 11, 15),
}, Color.fromHex(0x7298FF))
SurvivorVariant.setInfoStats(Delivery, {{"Strength", 5}, {"Vitality", 2}, {"Toughness", 3}, {"Agility", 9}, {"Difficulty", 6}, {"Patience", 2}})
SurvivorVariant.setDescription(Delivery, "&y&SPEE-D&!& models have one directive, to reach a destination as fast as optimally possible. Often a complicated task for this rustic model's hybrid oil engine.")

local sprSkills = Sprite.load("DeliverySkills", path.."Skills", 5, 0, 0)
local sSkill4_1 = Sound.find("DU-TSkill4_1")
local sSkill4_2 = Sound.find("DU-TSkill4_2")
local sSkill1_2 = Sound.load("DeliverySkill1_2", path.."shoot1_2")
local sSkill3 = Sound.load("DeliverySkill3", path.."shoot3")

SurvivorVariant.setLoadoutSkill(Delivery, "HARVEST", "&b&ABSORB SPEED&!& FROM &r&YOURSELF&!& AND &y&NEARBY ENEMIES.", sprSkills)
SurvivorVariant.setLoadoutSkill(Delivery, "RELEASE EMISSIONS", "CLEANSE THE SYSTEM FROM TOXIC CO2 EMISSIONS WITH A TRAIL FOR &y&100% DAMAGE PER SECOND.&!& &g&HEAL 8% OF YOUR TOTAL HEALTH.", sprSkills, 3)

Delivery.endingQuote = "..and so it left, traveling where no unit went before."

survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Delivery then
		player:survivorLevelUpStats(0, 0, 0.003, 0)
	end
end)

survivor:addCallback("scepter", function(player)
	if SurvivorVariant.getActive(player) == Delivery and player:getData().mode == 2 then
		player:setSkill(4, "ENERGY FUSILLADE", "CREATE A FUSILLADE THAT SUPPLIES SPEED FOR ENERGY. ENERGY GOES BACK TO YOU AS CHARGE.", sprSkills, 5, 12 * 60)
	end
end)

local buffSpeed = Buff.new("DeliveryBoost")
buffSpeed.sprite = spr.Buffs
buffSpeed.subimage = 6
buffSpeed:addCallback("start", function(actor)
	actor:set("pHmax", actor:get("pHmax") + 1)
end)
buffSpeed:addCallback("step", function(actor, timer)
	actor:getData().deliveryBuffTime = timer
end)
buffSpeed:addCallback("end", function(actor)
	actor:set("pHmax", actor:get("pHmax") - 1)
	actor:getData().deliveryBuffTime = nil
end)


local z_range = 130
local z_max = 9
local z_burst_range = 140

local mode2DrawFunc = function(player)
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

local mode2HoldFunc = function(player)
	local playerAc = player:getAccessor()
	local myTeam = playerAc.team
	local direction = player:getFacingDirection()
	local offset = 2 * player.xscale * -1
	for i, actor in ipairs(pobj.actors:findAllEllipse(player.x - z_range, player.y - z_range, player.x + z_range, player.y + z_range)) do
		if actor:get("team") ~= myTeam or actor == player then
			if not actor:get("dead") or actor:get("dead") == 0 then
				local val = 0.025
				if actor == player then val = 0.075 end
				player:getData().charge = math.min(player:getData().charge + val * (1 + playerAc.sp) * playerAc.attack_speed, z_max)
				--if (global.timer + i) % math.round(20 / (0.5 + playerAc.attack_speed * 0.5)) == 0 then
					actor:applyBuff(buff.slow, 10)
				--end
			end							
		end
	end
end

local mode2ShootFunc = function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	for _, actor in ipairs(pobj.actors:findAllEllipse(player.x - z_burst_range, player.y - z_burst_range, player.x + z_burst_range, player.y + z_burst_range)) do
		if actor:get("team") == player:get("team") then
			if not isaDrone(actor) then
				if not actor:get("dead") or actor:get("dead") == 0 then
					if actor:get("moveRight") == 1 or actor:get("moveLeft") == 1 then
						actor:getData().xAccel = actor.xscale * math.clamp(playerData.charge * 0.35, 1.2, 4)
					end
					local duration = (playerData.charge * 35) - (playerData.deliveryBuffTime or 0)
					if duration > 0 then
						actor:applyBuff(buffSpeed, duration)
					end
				end
			end
		end
	end
	local circle = obj.EfCircle:create(player.x, player.y)
	circle:set("radius", z_burst_range)
	circle:set("rate", 5)
	circle.blendColor = playerData.activeColor
	
	if playerAc.activity == 0  then
		player:survivorActivityState(1, player:getAnimation("shoot1_2"), 0.25, true, false)
	end
	
	sSkill1_2:play(0.9 + math.random() * 0.2)
end


callback.register("onSkinInit", function(player, skin)
	if skin == Delivery then
		player:getData().skin_skill3Override = true
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(158, 12, 0.056)
		else
			player:survivorSetInitialStats(108, 12, 0.026)
		end
		player:setSkill(2, "TOGGLE MODE", "SWITCH BETWEEN SELF AND ENEMY HARVEST MODE.",
		sprSkills, 2, 45)
		player:setSkill(3,
		"RELEASE EMISSIONS",
		"LEAVE A TRAIL FOR 100% DAMAGE PER SECOND. HEAL 8% OF YOUR TOTAL HEALTH.",
		sprSkills, 3, 9 * 60)
		player:getData()._EfColor2 = Color.fromHex(0x7298FF)
		player:getData().mode2HoldFunc = mode2HoldFunc
		player:getData().mode2DrawFunc = mode2DrawFunc
		player:getData().mode2ShootFunc = mode2ShootFunc
		player:getData().gasTimer = 0
	end
end)

local objDeliveryCircle = Object.new("DELIVERYCircle")
objDeliveryCircle:addCallback("create", function(self)
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
objDeliveryCircle:addCallback("step", function(self)
	local selfData = self:getData()
	if selfData.size > 0 then
		self.x = self.x + math.clamp(selfData.hspeed, -2, 2)
		--self.y = self.y + selfData.vspeed
		
		if selfData.timer == 180 then
			sSkill4_2:play(0.9 + math.random() * 0.2)
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
							local duration = (10) - (actor:getData().deliveryBuffTime or 0)
							if duration > 0 then
								actor:applyBuff(buffSpeed, duration)
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
objDeliveryCircle:addCallback("draw", function(self)
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

SurvivorVariant.setSkill(Delivery, 2, function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	if playerData.mode == 2 then
		player:setSkill(1, "HARVEST (SPEED)", "ABSORB HEALTH FROM YOURSELF AND NEARBY ENEMIES TO CHARGE. RELEASE TO DISCHARGE IN A SPEED BURST", sprSkills, 1, 2)
		if playerAc.scepter > 0 then
			player:setSkill(4, "ENERGY FUSILLADE", "CREATE A FUSILLADE THAT SUPPLIES SPEED FOR ENERGY. ENERGY GOES BACK TO YOU AS CHARGE.", sprSkills, 5, 12 * 60)
		else
			player:setSkill(4, "ENERGY FLARE", "CREATE A FLARE THAT SUPPLIES SPEED FOR ENERGY. ENERGY GOES BACK TO YOU AS CHARGE.", sprSkills, 4, 12 * 60)
		end
	end
end)
SurvivorVariant.setSkill(Delivery, 3, function(player)
	SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3"), 0.25, true, true)
end)
SurvivorVariant.setSkill(Delivery, 4, function(player)
	if player:getData().mode == 1 then
		SurvivorVariant.activityState(player, 4, player:getAnimation("shoot1_1"), 0.25, true, false)
	else
		SurvivorVariant.activityState(player, 4, player:getAnimation("shoot1_2"), 0.25, true, false)
	end
end)


local objGasEmitter = Object.new("GasEmitter")
objGasEmitter:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.life = 120
end)
objGasEmitter:addCallback("step", function(self)
	local selfData = self:getData()
	
	if selfData.life > 0 then
		selfData.life = selfData.life - 1
		if selfData.parent and selfData.parent:isValid() then
			local r = 22
			if not obj.poisonCloud:findEllipse(selfData.parent.x - r, selfData.parent.y - r, selfData.parent.x + r, selfData.parent.y + r) then
				local cloud = obj.poisonCloud:create(selfData.parent.x, selfData.parent.y):getData()
				cloud.height = 12
				cloud.width = 12
				cloud.life = 240
				cloud.parent = selfData.parent
				cloud.color = Color.fromHex(0xA5948B)
				cloud.canCrit = true
				cloud.canProc = true
				cloud.damage = 0.5
				cloud.partRate = 0.6
			end
		else
			selfData.life = 0
		end
	else
		self:destroy()
	end
end)

survivor:addCallback("onSkill", function(player, skill, relevantFrame)
	if SurvivorVariant.getActive(player) == Delivery then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		if skill == 3.01 then
			if relevantFrame == 1 then
				sSkill3:play(0.9 + math.random() * 0.2)
				local healval = playerAc.maxhp * 0.08
				playerAc.hp = playerAc.hp + healval
				misc.damage(healval, player.x, player.y - 10, false, Color.DAMAGE_HEAL)
			elseif relevantFrame == 5 then
				local emitter = objGasEmitter:create(0, 0)
				emitter:getData().life = 180
				emitter:getData().parent = player
			end
		elseif skill == 4.01 then
			if relevantFrame == 1 then
				sSkill4_1:play(0.9 + math.random() * 0.2)
				local scepter = playerAc.scepter
				for i = 1, (scepter + 1) do
					for ii = 0, playerAc.sp do
						local double = i % 2 == 0
						local side = 1
						if double then side = -1 end
						
						local circle = objDeliveryCircle:create(player.x + i * 2 * side, player.y - (ii * 8))
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
	end
end)