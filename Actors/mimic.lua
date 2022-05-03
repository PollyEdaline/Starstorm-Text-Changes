local path = "Actors/Mimic/"

local sprMask = Sprite.load("MimicMask", path.."Mask", 1, 7, 12)
local sprPalette = Sprite.load("MimicPal", path.."Palette", 1, 0, 0)
local sprSpawn = Sprite.load("MimicSpawn", path.."Spawn", 12, 19, 33)
local sprIdle = Sprite.load("MimicIdle", path.."Idle", 4, 8, 18)
local sprJump = Sprite.load("MimicJump", path.."Jump", 1, 9, 21)
local sprWalk = Sprite.load("MimicWalk", path.."Walk", 4, 8, 18)
local sprShoot1 = Sprite.load("MimicShoot1", path.."Shoot1", 12, 12, 26)
local sprDeath = Sprite.load("MimicDeath", path.."Death", 11, 16, 33)
local sprPortrait = Sprite.load("MimicPortrait", path.."Portrait", 1, 119, 119)

local sDeath = Sound.load("MimicDeath", path.."Death")
local sHit = Sound.load("MimicHit", path.."Hit")
local sShoot = Sound.load("MimicShoot", path.."Shoot")
local sSpawn = Sound.load("MimicSpawn", path.."Spawn")

local commandReskin = false

local sprites = {
	current = {
		Palette = sprPalette,
		Idle = sprIdle,
		Spawn = sprSpawn,
		Jump = sprJump,
		Walk = sprWalk,
		Shoot1 = sprShoot1,
		Death = sprDeath
	},
	original = {
	},
	command = {
	}
}

for k, s in pairs(sprites.current) do
	sprites.original[k] = Sprite.clone(s)
end
for k, s in pairs(sprites.current) do
	sprites.command[k] = Sprite.load(s:getName().."Command", path..k.."B", s.frames, s.xorigin, s.yorigin)
end

callback.register("onGameStart", function()
	if ar.Command.active and ar.Sacrifice.active then
		commandReskin = true
		for k, s in pairs(sprites.current) do
			s:replace(sprites.command[k])
		end
	elseif commandReskin then
		for k, s in pairs(sprites.current) do
			s:replace(sprites.original[k])
		end
	end
end)

local objDelayedSpawn = Object.new("DelayedSpawn")
objDelayedSpawn:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.timer = 45
	selfData.count = 1
end)
objDelayedSpawn:addCallback("step", function(self)
	local selfData = self:getData()
	selfData.timer = selfData.timer - 1
	if selfData.timer == 0 then
		self:destroy()
	end
end)
objDelayedSpawn:addCallback("destroy", function(self)
	local selfData = self:getData()
	if selfData.object then
		for i = 1, selfData.count do
			local inst = selfData.object:create(self.x, self.y)
			if selfData.func then
				selfData.func(inst)
			end
		end
	end
end)

obj.Mimic = Object.base("EnemyClassic", "Mimic")
obj.Mimic.sprite = sprIdle

EliteType.registerPalette(sprPalette, obj.Mimic)

local syncMimic = net.Packet.new("SSMimic", function(player, actor, target)
	local actorI = actor:resolve()
	local targetI = target:resolve()
	if actorI and actorI:isValid() then
		local actorData = actorI:getData()
		actorI:set("target", targetI.id)
		if isa(targetI, "ItemInstance") then
			actorData.sucItem = Item.fromObject(targetI:getObject())
			actorData.sucItemCount = 1
			NPCItems.giveItem(actorI, actorData.sucItem, 1)
			targetI.visible = false
			targetI.mask = spr.Nothing
			actorData.c_target = targetI
			actorI:set("state", "attack1")
		end
	end
end)
local syncMimic2 = net.Packet.new("SSMimic2", function(player, actor, target, item)
	local actorI = actor:resolve()
	local targetI = target:resolve()
	if actorI and actorI:isValid() then
		local actorData = actorI:getData()
		actorI:set("target", targetI.id)
		if isa(targetI, "PlayerInstance") then
			local count = targetI:countItem(item)
			targetI:removeItem(item, count)
			actorData.sucItem = item
			actorData.sucItemCount = count
			NPCItems.giveItem(actorI, actorData.sucItem, count)
			actorData.c_target = targetI
			actorI:set("state", "attack1")
		end
	end
end)

NPC.setSkill(obj.Mimic, 1, 100, 60 * 4, nil, 0.2, function(actor)
	local target = Object.findInstance(actor:get("target"))
	if target and target:isValid() and not actor:getData().fleeing then
		actor.sprite = sprShoot1
		actor:getData().c_target = target
		actor:getData().starting_z = true
	end
	--sCharge:play(0.9 + math.random() * 0.2)
end, function(actor, relevantFrame)
	local actorData = actor:getData()
	
	local target = actorData.c_target
	
	if target and target:isValid() then
		actor.sprite = sprShoot1
	end
	
	if relevantFrame == 2 then
		sShoot:play(0.9 + math.random() * 0.2, 0.8)
	end
	
	if relevantFrame == 4 then
		if target and target:isValid() and actor:getData().starting_z then
			--if distance(actor.x, actor.y, target.x, target.y) < 100 then
				if target == actorData.parent and actorData.sucItem then
					if net.host then
						actorData.sucItem:getObject():create(actorData.parent.x, actorData.parent.y - 3)
					end
					actorData.sucItem = nil
				elseif isa(target, "ItemInstance") and net.host then
					actorData.sucItem = Item.fromObject(target:getObject())
					actorData.sucItemCount = 1
					target.visible = false
					target.mask = spr.Nothing
					NPCItems.giveItem(actor, actorData.sucItem, 1)
					
					if net.online then
						syncMimic:sendAsHost(net.ALL, nil, actor:getNetIdentity(), target:getNetIdentity())
					end
				else
					if not isa(target, "PlayerInstance") then
						target = Object.findInstance(target:get("parent") or -4)
					end
					if target and target:isValid() then
						local tItems = getTrueItems(target)
						if tItems and #tItems > 0 and net.host then
							local citem = table.irandom(tItems)
							target:removeItem(citem.item, citem.count)
							actorData.sucItem = citem.item
							actorData.sucItemCount = citem.count
							NPCItems.giveItem(actor, actorData.sucItem, citem.count)
							if net.online then
								syncMimic2:sendAsHost(net.ALL, nil, actor:getNetIdentity(), target:getNetIdentity(), citem.item)
							end
						elseif isa(target, "PlayerInstance") then
							if not net.online or net.localPlayer == target then
								if misc.getGold() > 0 then
									sfx.Coins:play()
									local amount = math.min(50, misc.getGold())
									misc.setGold(misc.getGold() - amount)
									for i = 0, math.floor(amount / 2) do
										obj.EfGold:create(target.x, target.y - 10):set("direction", math.random(180)):set("speed", math.random(0.5, 3)):set("target", actor.id):set("value", 2)
									end
								end
							end
						end
					end
				end
			--end
			actor:getData().starting_z = nil
		end
		actorData.drawSuction = 0
	end
	
	if relevantFrame == 10 then
		if actorData.sucItem and actor:get("team") == "enemy" then
			actorData.fleeing = actorData.c_target
		end
		actorData.c_target = nil
		
		if target and target:isValid() and isa(target, "ItemInstance") then
			target:destroy()
		end
		
	elseif not actorData.fleeing then
		if actorData.c_target and actorData.c_target:isValid() then
			actorData.drawSuction = math.approach(actorData.drawSuction, 7, actor.spriteSpeed / 7)
		end
	end
end)

local preStepCall = function()
	for _, self in ipairs( obj.Mimic:findAll()) do
		if self:getData().jump and self:get("can_jump") == 1 then
			self:set("moveUp", 1)
			self:getData().jump = nil
		end
	end
end

obj.Mimic:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Security Chest"
	selfAc.damage = 10 * Difficulty.getScaling("damage")
	selfAc.maxhp = 200 * Difficulty.getScaling("hp") * math.max((Difficulty.getScaling("hp") * 0.075), 1)
	selfAc.armor = 0
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 1 + 0.2 + math.min(0.10 * Difficulty.getScaling(), 3)
	selfAc.pVmax = 5
	selfAc.knockback_cap = selfAc.maxhp --/ 3
	selfAc.exp_worth = 6 * Difficulty.getScaling()
	selfAc.can_drop = 1
	selfAc.can_jump = 1
	selfAc.sound_hit = sHit.id
	selfAc.hit_pitch = 1.2
	selfAc.sound_death = sDeath.id
	selfAc.sprite_idle = sprIdle.id
	selfAc.sprite_walk = sprWalk.id
	selfAc.sprite_jump = sprJump.id
	selfAc.sprite_death = sprDeath.id
	selfAc.sprite_palette = sprPalette.id
	self:getData().drawSuction = 0
	self:getData()._tameNoTarget = true
	self:getData().collectedGold = 0
	tcallback.register("preStep", preStepCall)
end)

obj.Mimic:addCallback("step", function(self)
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	local activity = selfAc.activity
	
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
		
		if selfAc.team == "enemy" then
			if selfData.fleeing and selfData.fleeing:isValid() then
				if selfData.fleeing.x > self.x then
					selfAc.moveLeft = 1
					selfAc.moveRight = 0
				else
					selfAc.moveLeft = 0
					selfAc.moveRight = 1
				end
				self:set("target", selfData.fleeing.id)
			else
				local target = nearestMatchingOp(self, obj.P, "dead", "==", 0)
				if target and target:isValid() then
					self:set("target", target.id)
				end
			end
		else
			selfData.fleeing = nil 
			self:set("target", -4)
			if selfData.sucItem then
				if selfData.parent and selfData.parent:isValid() then 
					self:set("target", selfData.parent.id)
					--if selfData.parent.x > self.x - 100 and selfData.parent.x < self.x + 100 and selfData.parent.y > self.y - 100 and selfData.parent.y < self.y + 100 then
					--	selfAc.state = "attack1"
					--end	
				end
			else
				local target = nearestMatchingOp(self, pobj.items, "used", "==", 0)
				if target and target:isValid() then
					if selfData.parent and selfData.parent:isValid() and pobj.items:findEllipse(selfData.parent.x - 100, selfData.parent.y - 100, selfData.parent.x + 100, selfData.parent.y + 100) ~= target then
						local range = 50
						if not obj.P:findEllipse(target.x - range, target.y - range, target.x + range, target.y + range) then
							if global.timer % 5 == 0 then
								if target.x > self.x then
									selfAc.moveLeft = 0
									selfAc.moveRight = 1
								else
									selfAc.moveLeft = 1
									selfAc.moveRight = 0
								end
							end
							self:set("target", target.id)
						else
							selfAc.moveLeft = 0
							selfAc.moveRight = 0
						end
					end
				end
			end
		end
		
		local t = Object.findInstance(selfAc.target)
		if t and t:isValid() then
			if t.y < self.y - 20 and selfAc.free == 0 then
				if t.x > self.x - 5 and t.x < self.x + 5 then
					selfData.jump = true
					selfAc.pVspeed = -4
				elseif selfAc.pHspeed == 0 then
					if selfAc.moveRight == 1 or selfAc.moveLeft == 1 then
						selfData.jump = true
						--selfAc.pVspeed = -4
					end
				end
			end
		end
		
		if activity == 0 then
			for k, v in pairs(NPC.skills[object]) do
				if self:get(v.key.."_skill") > 0 and self:getAlarm(k + 1) == -1 then
					selfData.attackFrameLast = 0
					self:set(v.key.."_skill", 0)
					if v.start then
						v.start(self)
						selfAc.activity = k
					end
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
		
		if selfAc.moveRight == 1 and self:collidesMap(self.x + 4, self.y) then
			selfData.jump = true
		elseif selfAc.moveLeft == 1 and self:collidesMap(self.x - 4, self.y) then
			selfData.jump = true
		end
	else
		self.spriteSpeed = 0
	end
	
	if self.sprite.id == selfAc.sprite_death then
		self.subimage = 1
		selfData.drawSuction = 0
	end
	
	if selfData.drawSuction > 0 then
		if not selfData.c_target or not selfData.c_target:isValid() then
			selfData.drawSuction = 0
		end
	end
	
	for _, gold in ipairs(obj.EfGold:findMatching("target", self.id)) do
		if self:collidesWith(gold, self.x, self.y) then
			gold:destroy()
			selfData.collectedGold = selfData.collectedGold + 2
		end
	end
end)

obj.Mimic:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	local target = selfData.c_target
	if selfData.drawSuction > 0 then
		local yy = self.y - 5
		local d = 30
		for i = 0, 2 do
			local tt
			if target == selfData.parent then
				tt = (-global.timer + i * 15) % d
			else
				tt = (global.timer + i * 15) % d
			end
			
			local ttt = d - tt
			graphics.alpha((tt / d) * (1 - selfData.drawSuction))
			graphics.color(Color.WHITE)
			graphics.circle(self.x + ttt * self.xscale, yy - 5, (ttt / d) * 15, true)
		end
		if selfData.sucItem and target and target:isValid() then
			local item = selfData.sucItem
			
			local ds = selfData.drawSuction
			if target == selfData.parent then
				ds = 1 - ds
			end
			
			local ratio = ds * distance(self.x, yy, target.x, target.y)
			local size = 1 - ds
			
			local x, y = pointInLine(target.x, target.y, self.x, yy, ratio)
			
			graphics.drawImage{
				image = item.sprite,
				x = x,
				y = y,
				scale = size
			}
		end
	end
end)

obj.Mimic:addCallback("destroy", function(self)
	local selfData = self:getData()
	
	if net.host and selfData.sucItem then
		--for i = 1, selfData.sucItemCount do
			local d = objDelayedSpawn:create(self.x, self.y - 7)
			d:getData().object = selfData.sucItem:getObject()
			d:getData().count = selfData.sucItemCount
		--end
	end
	for i = 1, math.floor(selfData.collectedGold / 2) do
		obj.EfGold:create(self.x, self.y - 4):set("direction", math.random(180)):set("speed", math.random(0.5, 3)):set("value", 2)
	end
end)


if not global.rormlflag.ss_stable then
mcard.Mimic = MonsterCard.new("Mimic", obj.Mimic)
mcard.Mimic.type = "classic"
mcard.Mimic.cost = 350
mcard.Mimic.sound = sSpawn
mcard.Mimic.sprite = sprSpawn
mcard.Mimic.isBoss = false
mcard.Mimic.canBlight = false
end

mlog.Mimic = MonsterLog.new("Mimic")
MonsterLog.map[obj.Mimic] = mlog.Mimic
mlog.Mimic.displayName = "Security Chest"
mlog.Mimic.story = "Who had the crazy idea of giving chests a failsafe? I know they want to make it harder for pirates, but they probably didn't think about emergencies.\nI'll never get used to chasing a mechanical box because it thinks I stole something.\n\n\n...Or maybe it's the berries I ate."
mlog.Mimic.statHP = 200
mlog.Mimic.statDamage = 0
mlog.Mimic.statSpeed = 1.3
mlog.Mimic.sprite = sprWalk
mlog.Mimic.portrait = sprPortrait