local stages = {}
stages.dried = stg.DriedLake
stages.sunken = stg.SunkenTombs

local path = "Actors/Sand Crab King/"

local sprMask = Sprite.load("SandCrabKingMask", path.."Mask", 1, 52, 76)
local sprPalette = Sprite.load("SandCrabKingPal", path.."palette", 1, 0, 0)
local sprSpawn = Sprite.load("SandCrabKingSpawn", path.."Spawn", 7, 94, 130)
local sprIdle = Sprite.load("SandCrabKingIdle", path.."Idle", 8, 93, 125)
local sprWalk = Sprite.load("SandCrabKingWalk", path.."Walk", 5, 90, 112)
local sprShoot1 = Sprite.load("SandCrabKingShoot1", path.."Shoot1", 11, 90, 125)
local sprShoot2 = Sprite.load("SandCrabKingShoot2", path.."Shoot2", 13, 94, 130)
local sprShoot3 = Sprite.load("SandCrabKingShoot3", path.."Shoot3", 8, 97, 99)
local sprShoot4 = Sprite.load("SandCrabKingShoot4", path.."Shoot4", 5, 92, 111)
local sprDeath = Sprite.load("SandCrabKingDeath", path.."Death", 9, 94, 130)
--local sprPortrait = Sprite.load("SandCrabPortrait", path.."Portrait", 1, 119, 119)
local sprLogBook = Sprite.load("SandCrabLogBook", path.."LogBook", 5, 90, 20)
local sprBubble = Sprite.load("Bubble", path.."Bubble", 5, 15, 16)
local sprBubblePop = Sprite.load("BubblePop", path.."BubblePop", 3, 15, 16)
local sSpawn = Sound.load("SandCrabKingSpawn", path.."Spawn")
local sRabid = Sound.load("SandCrabKingRabid", path.."Rabid")
local sClaw = Sound.load("SandCrabKingClaw", path.."Claw")
local sBubblePop = Sound.load("BubblePop", path.."BubblePop")
local sDeath = Sound.load("SandCrabKingDeath", path.."Death")
local sHit = Sound.load("SandCrabKingHit", path.."Hit")

obj.SandCrabKing = Object.base("BossClassic", "SandCrabKing")
obj.SandCrabKing.sprite = sprIdle

EliteType.registerPalette(sprPalette, obj.SandCrabKing)

obj.CrabKingBubble = Object.new("CrabKingBubble")
obj.CrabKingBubble.sprite = sprBubble
obj.CrabKingBubble.depth = -9

obj.CrabKingBubble:addCallback("create", function(self)
	self.spriteSpeed = 0.1
	self:set("team", "enemy")
	self:getData().life = 600
	self.subimage = math.random(self.sprite.frames)
	local scale = math.random(8, 11) / 10
	self.xscale = scale
	self.yscale = scale
	if net.online then
		misc.director:set("points", misc.director:get("points") + 20)
	end
end)
obj.CrabKingBubble:addCallback("step", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	if selfAc.speed > 0 then
		selfAc.speed = selfAc.speed * 0.984
	end
	
	if self:getData().pursue then
		local target = self:getData().pursue
		
		if target:isValid() then
			if target:getObject() == obj.POI then target = Object.findInstance(target:get("parent")) end
			if target and target:isValid() and target:get("team") ~= self:get("team") then
				if not target:getData().bubbled then
					local xx = target.x - self.x
					local yy = target.y - self.y
					
					local direction = math.deg(math.atan2(yy * -1, xx))
					local dif = selfAc.direction - direction
					
					selfAc.direction = math.approach(selfAc.direction, direction, 1)
					
					if target.x <= self.x + 10 and target.x >= self.x - 10
					and target.y <= self.y + 10 and target.y >= self.y - 10 then
						self:getData().life = 90
						target:getData().bubbled = self
						selfAc.speed = 0.3
					end
				elseif target:getData().bubbled == self then
					target.x = self.x
					target.y = self.y
					target:set("disable_ai", 1)
					target:set("pVspeed", 0)
					if isa(target, "ActorInstance") and target:getAnimation("idle") then
						target.sprite = target:getAnimation("idle")
					end
					if target:get("activity") ~= 30 and target:collidesMap(target.x, target.y - 2) then
						selfAc.speed = 0
					end
					
					selfAc.direction = 90
				end
			end
		end
	else
		if selfAc.direction < 89 then
			selfAc.direction = selfAc.direction + 1
		elseif selfAc.direction > 91 then
			selfAc.direction = selfAc.direction - 1
		end
	end
	
	
	if selfData.life <= 0 then
		local pop = obj.EfSparks:create(self.x, self.y)
		pop.sprite = sprBubblePop
		sBubblePop:play()
		if global.quality > 2 then
			par.BigBubbles:burst("above", self.x, self.y, 6)
		end
		if self:getData().pursue then
			local target = self:getData().pursue
			if target and target:isValid() then
				target:getData().bubbled = nil
				target:set("disable_ai", 0)
				target:set("activity_type", 0)
				if target:get("activity") == 30 then
					for i = 1, 100 do
						if not target:collidesMap(target.x, target.y - i) then
							target.y = target.y - i
							break
						end
					end
					target:set("activity", 0)
				end
			end
		end
		self:destroy()
	else
		selfData.life = selfData.life - 1
	end
end)

table.insert(call.onPlayerStep, function(player)
	if player:getData().bubbled and not player:getData().bubbled:isValid() then
		player:getData().bubbled = nil
		player:set("disable_ai", 0)
		player:set("activity_type", 0)
		if player:getSurvivor():getOrigin() == "Vanilla" and player:get("activity") > 0 and player:get("activity") < 5 then
			player:set("activity_type", 1)
		else
			player:set("activity_type", 0)
		end
		if player:getSurvivor() == sur.Miner then
			player:set("activity", 0)
			player:set("activity_type", 0)
			player:set("activity_var", 0)
		end
		if player:get("activity") == 30 then
			player:set("activity", 0)
		end
	end
end)

NPC.setSkill(obj.SandCrabKing, 1, 130, 60 * 4, sprShoot1, 0.12, nil, function(actor, relevantFrame)
	if relevantFrame == 7 then
		sClaw:play()
		sfx.GolemAttack1:play()
		actor:fireExplosion(actor.x + 100 * actor.xscale, actor.y, 40 / 19, 64 / 4, 1, nil, spr.Sparks5)
	end
end)

NPC.setSkill(obj.SandCrabKing, 2, 80, 60 * 4, sprShoot2, 0.15, nil, function(actor, relevantFrame)
	if relevantFrame == 9 then
		sClaw:play()
		actor:fireExplosion(actor.x + 50 * actor.xscale, actor.y, 60 / 19, 40 / 4, 1, nil, spr.Sparks7)
	elseif relevantFrame == 10 then
		sClaw:play()
	end
end)

NPC.setSkill(obj.SandCrabKing, 3, 400, 60 * 14, sprShoot3, 0.15, function(actor)
	--if actor:getData().attack_mode == 2 then
		sRabid:play()
		for i = 1, 5 do
			if i == 1 then
				for i, player in ipairs(obj.POI:findAll()) do
					local bubble = obj.CrabKingBubble:create(actor.x, actor.y - 50)
					local speed = 3.8
					local elite = actor:get("elite_type")
					if elite == 1 then
						speed = 5.8
					end
					bubble:set("speed", speed)
					bubble:set("team", actor:get("team"))
					
					local xx = player.x - bubble.x
					local yy = player.y - bubble.y
					
					local direction = math.deg(math.atan2(yy * -1, xx))
					bubble:set("direction", direction)
					bubble:getData().life = 280
					bubble:getData().pursue = player
				end
			else
				local bubble = obj.CrabKingBubble:create(actor.x, actor.y - 50)
				bubble.xscale = bubble.xscale * 0.8
				bubble.yscale = bubble.yscale * 0.8
				bubble:set("speed", math.random(0.5, 1.5))
				bubble:set("direction", math.random(360))
				bubble:getData().life = math.random(100, 400)
			end
		end
	--else
	--	actor.sprite = sprIdle
	--	actor:set("activity", 0)
	--	actor:set("activity_type", 0)
	--	actor:set("state", "chase")
	--end
end, 
function(actor, relevantFrame)
	--if actor:getData().attack_mode == 2 then
	if global.quality > 2 then
		par.BigBubbles:burst("above", actor.x, actor.y - 50, 1)
	end
	--end
end)

NPC.setSkill(obj.SandCrabKing, 4, 400, 60 * 9, nil, 0.15, function(actor)
	if actor:getData().attack_mode == 1 then
		actor:getData().attack_mode = 2
		actor:set("sprite_walk", sprShoot4.id)
		actor:set("pHmax", actor:get("pHmax") + 0.8)
	else
		actor:getData().attack_mode = 1
		actor:set("sprite_walk", sprWalk.id)
		actor:set("sprite_idle", sprIdle.id)
		actor:set("pHmax", actor:get("pHmax") - 0.8)
	end
end)

obj.SandCrabKing:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	obj.EfFlash:create(0,0):set("parent", self.id)
	
	local ground = obj.BossSpawn:findNearest(self.x, self.y)
	if ground then
		local xx = ground.x + (ground.xscale * 15 * 16 * 0.5)
		self.x = xx
		self.y = ground.y - self.mask.height + self.mask.yorigin
	end
	
	selfAc.sync = 1
	selfAc.name = "Sand Crab King"
	selfAc.name2 = "Hardened Monstrosity"
	selfAc.damage = 30 * Difficulty.getScaling("damage")
	selfAc.maxhp = 1200 * Difficulty.getScaling("hp")
	selfAc.armor = 70
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 0.8
	selfAc.knockback_cap = selfAc.maxhp
	selfAc.exp_worth = 52 * Difficulty.getScaling()
	selfAc.point_value = 760
	selfAc.can_drop = 0
	selfAc.can_jump = 0
	selfAc.sound_hit = sHit.id
	selfAc.sound_death = sDeath.id
	selfAc.sprite_palette = sprPalette.id
	selfAc.sprite_idle = sprIdle.id
	selfAc.sprite_walk = sprWalk.id
	selfAc.sprite_jump = sprIdle.id
	selfAc.sprite_death = sprDeath.id
	self:getData().attack_mode = 1
	self:getData().lastXscale = 1
	self:getData().knockbackImmune = true
end)

obj.SandCrabKing:addCallback("step", function(self)
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	local activity = selfAc.activity
	
	if selfData.attack_mode == 2 then
		if selfAc.moveRight == 0 and selfAc.moveLeft == 0 then
			selfAc.moveRight = 1
		end
	else
		if obj.POI:findRectangle(self.x - 40, self.y - 300, self.x + 40, self.y + 30) then
			selfAc.moveRight = 0
			selfAc.moveLeft = 0
		end
	end
	
	if selfAc.team == "enemy" then
		local t = obj.POI:findNearest(self.x, self.y)
		if t and t:isValid() then
			selfAc.target = t.id
		end
	end
	
	--[[if self:collidesMap(self.x, self.y) then
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
	end]]
	
	if selfAc.moveRight == 0 and selfAc.moveLeft == 0 then
		self.spriteSpeed = 0.16 * selfAc.pHmax
	else
		if selfAc.pHspeed == 0 and selfAc.state == "chase" and selfAc.activity == 0 then
			self.sprite = self:getAnimation("walk")
			if selfAc.moveRight == 1 and Stage.collidesPoint(self.x + selfAc.pHmax + 53 * self.xscale, self.y + 7 * self.yscale) then
				self.x = self.x + selfAc.pHmax
			elseif selfAc.moveLeft == 1 and Stage.collidesPoint(self.x - selfAc.pHmax + 53 * self.xscale, self.y + 7 * self.yscale) then
				self.x = self.x - selfAc.pHmax
			end
		end
		self.spriteSpeed = 0.14
	end
	
	if selfAc.state == "chase" then
		if selfAc.target then
			local target = Object.findInstance(selfAc.target)
			if target and target:isValid() then
				if target.x > self.x + 10 and self:collidesMap(self.x + selfAc.pHmax, self.y) == false and self:collidesMap(self.x + self.mask.width, self.y + 2) == true then
					selfAc.moveRight = 1
					selfAc.moveLeft = 0
				elseif target.x < self.x - 10 and self:collidesMap(self.x - selfAc.pHmax, self.y) == false and self:collidesMap(self.x - self.mask.width, self.y + 2) == true then
					selfAc.moveLeft = 1
					selfAc.moveRight = 0
				end
			elseif global.timer % 100 == 0 then
				syncInstanceVar:sendAsClient(self:getNetIdentity(), "target")
			end
		end
	end
	
	if self.sprite.id == selfAc.sprite_death then
		self.subimage = 1
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
	
	-- this was a dumb attempt at making it not flip like crazy at the edge of a platform...
	--[[if selfData.lastXscale ~= self.xscale and not selfData.xscaleOverride then
		selfData.newXscale = self.xscale
		selfData.xscaleOverride = 10
	end
	if not selfData.xscaleOverride then
		selfData.lastXscale = self.xscale
	else
		if selfData.xscaleOverride > 0 then
			self.xscale = selfData.lastXscale
			selfData.xscaleOverride = selfData.xscaleOverride - 1
		else
			selfData.xscaleOverride = nil
			self.xscale = selfData.newXscale
			selfData.lastXscale = selfData.newXscale
		end
	end]]
end)

mcard.SandCrabKing = MonsterCard.new("SandCrabKing", obj.SandCrabKing)
mcard.SandCrabKing.type = "player"
mcard.SandCrabKing.cost = 760
mcard.SandCrabKing.sound = sSpawn
mcard.SandCrabKing.sprite = sprSpawn
mcard.SandCrabKing.isBoss = true
mcard.SandCrabKing.canBlight = false

--[[
mlog.SandCrabKing = MonsterLog.new("SandCrabKing")
MonsterLog.map[obj.SandCrabKing] = mlog.SandCrabKing
mlog.SandCrabKing.displayName = "Sand Crab King"
mlog.SandCrabKing.story = "Biggest boi."
mlog.SandCrabKing.statHP = 1400
mlog.SandCrabKing.statDamage = 30
mlog.SandCrabKing.statSpeed = 1.3
mlog.SandCrabKing.sprite = sprLogBook
mlog.SandCrabKing.portrait = sprPortrait]]

for s, stage in pairs(stages) do
	stage.enemies:add(mcard.SandCrabKing)
end
stg.DriedLake.enemies:remove(mcard.Colossus)