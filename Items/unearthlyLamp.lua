local path = "Items/Resources/"

it.UnearthlyLamp = Item.new("Unearthly Lamp")
--local sUnearthyLamp = Sound.load("UnearthlyLamp", path.."UnearthlyLamp")
it.UnearthlyLamp.pickupText = "Every second attack fires a haunted projectile." 
it.UnearthlyLamp.sprite = Sprite.load("Unearthly Lamp", path.."Unearthly Lamp.png", 1, 15, 15)
itp.legendary:add(it.UnearthlyLamp)
it.UnearthlyLamp.color = "y"
it.UnearthlyLamp:setLog{
	group = "boss",
	description = "Every second attack &y&fires a haunted projectile which deals 100% damage.",
	story = "What I witnessed transcended my understanding, not only did the remains glow for me, but they sensed something I wasn't aware of, something of a different nature. May this light guide me in my journey.",
	priority = "&b&Field-Found&!&",
	destination = "ROMEO 3,\nCollector 335,\nMars",
	date = "Unknown"
}
it.UnearthlyLamp:addCallback("pickup", function(player)
	player:set("unearthlyLamp", (player:get("unearthlyLamp") or 0) + 1)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.UnearthlyLamp then
		player:set("unearthlyLamp", player:get("unearthlyLamp") - amount)
	end
end)
if obj.Post then
	NPC.registerBossDrops(obj.Post)
	NPC.addBossItem(obj.Post, it.UnearthlyLamp)
end

local objLampBullet = Object.new("LampBullet")

objLampBullet.sprite = Sprite.load("Unearthly Lamp Bullet", path.."unearthlyLampdis.png", 1, 3, 3)
objLampBullet.depth = - 4

objLampBullet:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local data = self:getData()
	selfAc.speed = 4
	self.spriteSpeed = 0
	data.life = 50
end)
objLampBullet:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local data = self:getData()
	
	selfAc.speed = selfAc.speed + 0.2
	
	self.angle = selfAc.direction
	
	if global.quality > 1 then 
		par.SmokeFirework:burst("middle", self.x, self.y, 1, Color.fromHex(0xECB06F))
	end
	
	if data.target and data.target:isValid() then
		
		local target = data.target
		
		local angle = posToAngle(self.x, self.y, target.x, target.y)
		
		local dif = selfAc.direction - angle
		
		selfAc.direction = selfAc.direction + (angleDif(selfAc.direction, angle) * -0.115 * (selfAc.speed / 3))
		
		if self:collidesWith(target, self.x, self.y) then
			if data.parent and data.parent:isValid() then
				local damager = data.parent:fireExplosion(self.x, self.y, 4 / 19, 4 / 4, 1, nil, nil, DAMAGER_NO_PROC)
				damager:getData().skin_newDamager = true --heh
			end
			data.destroy = true
		end
	else
		local nearestInstance = nil
		for _, actor in ipairs(pobj.actors:findAll()) do
			if data.team ~= actor:get("team") then
				local dis = distance(self.x, self.y, actor.x, actor.y)
				if dis < 100 then
					if not nearestInstance or dis < nearestInstance.dis then
						nearestInstance = {inst = actor, dis = dis}
					end
				end
			end
		end
		if nearestInstance then
			data.target = nearestInstance.inst
		end
	end
	
	if data.life <= 0 or data.destroy then
		self:destroy()
	else
		data.life = data.life - 1
	end
end)

callback.register("postLoad", function()
	for _, survivor in ipairs(Survivor.findAll()) do
		local count = 2
		if survivor == sur.DUT then
			count = 20
		end
		
		survivor:addCallback("useSkill", function(player, skill)
			local data = player:getData()
			local playerAc = player:getAccessor()
			
			if not data.uLampCd then
				if skill >= 1 and skill < 1.2 then
					local lamp = player:get("unearthlyLamp")
					if lamp and lamp > 0 then
						
						if data.uLampC then
							if data.uLampC % count == 0 then
								for i = 1, lamp do
									local target
									local nearestEnemy
									for _, actor2 in ipairs(pobj.actors:findAll()) do
										if actor2:get("team") ~= player:get("team") then
											local dis = distance(actor2.x, actor2.y, player.x, player.y)
											if dis < 200 then
												if not nearestEnemy or dis < nearestEnemy.dis then
													nearestEnemy = {inst = actor2, dis = dis}
												end
											end
										end
									end
									if nearestEnemy then
										target = nearestEnemy.inst
									end
									
									local b = objLampBullet:create(player.x, player.y - (i * 2))
									if target then
										b:set("direction", posToAngle(target.x, target.y, player.x, player.y))
										b:getData().target = target
									else
										b:set("direction", player:getFacingDirection())
									end
									b:getData().team = player:get("team")
									b:getData().parent = player
								end
							end
							data.uLampC = data.uLampC + 1
							data.uLampCd = true
						else
							data.uLampC = 0
						end
					end
				end
			end
		end)
	end
end)

callback.register("onActorStep", function(actor)
	local lamp = actor:get("unearthlyLamp")
	if lamp and lamp > 0 then
		local data = actor:getData()
		
		if not isa(actor, "PlayerInstance") then
			if data.uLampC then
				local currentCooldown = actor:getAlarm(2)
				if currentCooldown > 0 and data.uLampC.cd == -1 or force then
					if data.uLampC.c % 2 == 0 then
						for i = 1, lamp do
							local target
							local nearestEnemy
							for _, actor2 in ipairs(pobj.actors:findAll()) do
								if actor2:get("team") ~= actor:get("team") then
									local dis = distance(actor2.x, actor2.y, actor.x, actor.y)
									if dis < 200 then
										if not nearestEnemy or dis < nearestEnemy.dis then
											nearestEnemy = {inst = actor2, dis = dis}
										end
									end
								end
							end
							if nearestEnemy then
								target = nearestEnemy.inst
							end
							
							local b = objLampBullet:create(actor.x, actor.y - (i * 2))
							if target then
								b:set("direction", posToAngle(target.x, target.y, actor.x, actor.y))
								b:getData().target = target
							else
								b:set("direction", actor:getFacingDirection())
							end
							b:getData().team = actor:get("team")
							b:getData().parent = actor
						end
					end
					data.uLampC.c = data.uLampC.c + 1
				end
				data.uLampC.cd = currentCooldown
			else
				data.uLampC = {cd = actor:getAlarm(2), c = 0}
			end
		elseif actor:get("activity") == 0 then
			data.uLampCd = false
		end
	end
end)