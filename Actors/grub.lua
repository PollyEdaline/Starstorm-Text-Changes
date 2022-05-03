--local postLoopStages = {}
--postLoopStages.cluster = stg.HiveCluster

local path = "Actors/Archer Bug Grub/"

local sprMask = Sprite.load("GrubMask", path.."Mask", 1, 7, 7)
local sprPalette = Sprite.load("GrubPal", path.."Palette", 1, 0, 0)
--local sprSpawn = Sprite.load("GrubSpawn", path.."Spawn", 6, 16, 16)
local sprIdle = Sprite.load("GrubIdle", path.."Idle", 1, 9, 4)
local sprWalk = Sprite.load("GrubWalk", path.."Walk", 4, 10, 5)
--local sprShoot1 = Sprite.load("GrubShoot1", path.."Shoot1", 14, 18, 30)
local sprDeath = Sprite.load("GrubDeath", path.."Death", 8, 14, 28)

--local sCharge = Sound.load("GrubCharge", path.."Charge")

obj.Grub = Object.base("EnemyClassic", "Archer Grub")
obj.Grub.sprite = sprIdle

EliteType.registerPalette(sprPalette, obj.Grub)

NPC.setSkill(obj.Grub, 1, 20, 40 * 1, nil, 0.2, function(self)
	local r = 20
	local myTeam = self:get("team")
	for _, actor in ipairs(pobj.actors:findAllRectangle(self.x - r, self.y - r, self.x + r, self.y + r)) do
		if actor:get("team") ~= myTeam and actor:collidesWith(self, actor.x, actor.y) then
			actor:applyBuff(buff.slow, 40)
		end
	end
end, nil)

obj.Grub:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Archer Grub"
	selfAc.damage = 15 * Difficulty.getScaling("damage")
	selfAc.maxhp = 50 * Difficulty.getScaling("hp")
	selfAc.armor = 0
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 0.6
	selfAc.knockback_cap = selfAc.maxhp / 4
	selfAc.exp_worth = 4 * Difficulty.getScaling()
	selfAc.can_drop = 1
	selfAc.can_jump = 0
	--selfAc.sound_hit = sHit.id
	selfAc.hit_pitch = 1
	--selfAc.sound_death = sDeath.id
	selfAc.sprite_palette = sprPalette.id
	selfAc.sprite_idle = sprIdle.id
	selfAc.sprite_walk = sprWalk.id
	selfAc.sprite_jump = sprIdle.id
	selfAc.sprite_death = sprDeath.id
	selfAc.invincible = 10
end)

obj.Grub:addCallback("step", function(self)
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	local activity = selfAc.activity
	
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
end)
obj.Grub:addCallback("destroy", function(self)
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	local r = 50
	local myTeam = selfAc.team
	local myHp = selfAc.maxhp
	for _, actor in ipairs(pobj.actors:findAllRectangle(self.x - r, self.y - r, self.x + r, self.y + r)) do
		if actor:get("team") == myTeam and actor:get("hp") then
			actor:set("hp", actor:get("hp") + myHp)
			obj.EfFlash:create(0,0):set("parent", actor.id):set("rate", 0.05).blendColor = Color.GREEN
			actor:setAlarm(6, 300)
		end
	end
	sfx.CrabSpawn:play(2)
end)

if obj.ArcherBugHive then
	obj.ArcherBugHive:addCallback("destroy", function(self)
		if net.host then
			for i = -1, 1 do
				createSynced(obj.Grub, self.x + i * 2, self.y - 2)
			end
		end
	end)
end

--[[mcard.Grub = MonsterCard.new("Archer Grub", obj.Grub)
mcard.Grub.type = "classic"
mcard.Grub.cost = 70
--mcard.Grub.sound = sSpawn
--mcard.Grub.sprite = sprSpawn
mcard.Grub.isBoss = false
mcard.Grub.canBlight = true]]
--[[
table.insert(call.onStageEntry, function()
	if misc.director:get("stages_passed") > 4 then
		for _, stage in pairs(postLoopStages) do
			if not stage.enemies:contains(mcard.Grub) then
				stage.enemies:add(mcard.Grub)
			end
		end
	end
end)

callback.register("onGameStart", function()
	for _, stage in pairs(postLoopStages) do
		if stage.enemies:contains(mcard.Grub) then
			stage.enemies:remove(mcard.Grub)
		end
	end
end)]]