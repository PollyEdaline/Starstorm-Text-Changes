
local path = "Actors/Squall Elver/"

local sprMask = Sprite.load("SquallElverMask", path.."Mask", 1, 3, 5)
local sprPalette = Sprite.load("SquallElverPal", path.."palette", 1, 0, 0)
local sprHead = Sprite.load("SquallElverHead", path.."Head", 1, 3, 10)
local sprBody = Sprite.load("SquallElverBody", path.."Body", 1, 3, 11)
local sprTail = Sprite.load("SquallElverTail", path.."Tail", 1, 3, 8)
local sprTailEnd = Sprite.load("SquallElverTailEnd", path.."TailEnd", 1, 3, 11)
local sprPortrait = Sprite.load("SquallElverPortrait", path.."Portrait", 1, 119, 119)
local sprLog = Sprite.load("SquallElverLog", path.."Log", 8, 20, 11)

obj.SquallElverC = Object.base("Enemy", "Squall Elver")
obj.SquallElverC.sprite = sprHead

obj.SquallElver = Object.base("Enemy", "Squall Elver Body")
obj.SquallElver.sprite = sprLog
obj.SquallElver.depth = -17

callback.register("onEliteInit", function(actor)
	if actor:getObject() == obj.SquallElverC then
		local aElite = actor:getElite()
		for _, section in ipairs(actor:getData().sections) do
			if section:isValid() then
				section:set("prefix_type", 1)
				section:set("elite_type", aElite.id)
				section:set("pHmax", actor:get("pHmax"))
				section:set("damage", actor:get("damage"))
				section:set("maxhp", actor:get("maxhp"))
				section:set("hp", actor:get("hp"))
			end
		end
	end
end)

obj.SquallElverC:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local length = 6
	local sections = {}
	for i = 1, length do
		local section = obj.SquallElver:create(self.x - (21 * i), self.y)
		section:getData().controller = self
		section:getData().section = i
		sections[i] = section
		
		if i == 1 then
			section.sprite = sprHead
		elseif i == 2 then
			section.sprite = sprBody
		elseif i == length then
			section.sprite = sprTail
		else
			section.sprite = sprTailEnd
		end
		
		if i > 1 then
			section:getData().nextSection = sections[i - 1]
		end
		
		section.depth = section.depth - (i)
		
	end

	selfAc.name = "Squall Elver"
	selfAc.damage = 14 * Difficulty.getScaling("damage")
	selfAc.maxhp = 200 * Difficulty.getScaling("hp")
	selfAc.armor = 0
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 1.2
	selfAc.knockback_cap = selfAc.maxhp
	selfAc.exp_worth = 10 * Difficulty.getScaling()
	selfAc.point_value = 100
	selfAc.can_drop = 0
	selfAc.can_jump = 0
	self:setAnimation("idle", sprHead)
	--selfAc.sound_hit = sfx.GuardHit.id
	selfAc.hit_pitch = 1
	--selfAc.sound_death = sDeath.id
	selfAc.sprite_palette = sprPalette.id
	selfAc.target = -4
	
	selfAc.disable_ai = 1
	self.x = sections[1].x
	self.y = sections[1].y
	self.mask = spr.Nothing
	
	self:getData().sections = sections
	self.visible = false
end)
obj.SquallElverC:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	local sections = selfData.sections
	selfAc.pHspeed = 0
	selfAc.pVspeed = 0
	
	local deleteSelf
	
	local sw, sh = Stage.getDimensions()
	
	if sections then
		local target = Object.findInstance(selfAc.target)
		
		for i, section in ipairs(sections) do
			if section:isValid() then
				if i == 1 then
					self.x = section.x
					self.y = section.y
				end
			elseif self:isValid() then
				deleteSelf = true
			end
		end
		if target and target:isValid() then
			local side = 1
			if target.x < self.x then side = -1 end
			for i, section in ipairs(sections) do
				if section:isValid() then
					section.yscale = (1.1 - (i * 0.1)) * side
				end
			end
		else
			if selfAc.team == "enemy" then
				local t = obj.POI:findNearest(self.x, self.y)
				if t then t = t.id end
				selfAc.target = t or -4
			else
				local t = nil
				for _, actor in ipairs(pobj.actors:findAll()) do
					if actor:get("team") ~= selfAc.team then
						t = actor.id
					end
				end
				selfAc.target = t or -4
			end
		end
	end
	
	if self.x < 0 or self.x > sw or self.y < 0 or self.y > sh then
		if not selfData.outOfMap then selfData.outOfMap = 1 end
		selfData.outOfMap = selfData.outOfMap + 1
		
		if selfData.outOfMap > 280 then
			deleteSelf = true
		end
	elseif selfData.outOfMap then
		selfData.outOfMap = nil
	end
	if deleteSelf then syncDelete(self) self:delete() end
end)

obj.SquallElver:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	self.sprite = sprHead
	selfAc.name = "Squall Elver"
	selfAc.damage = 14 * Difficulty.getScaling("damage")
	selfAc.maxhp = 200 * Difficulty.getScaling("hp")
	selfAc.armor = 0
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 1.2
	selfAc.exp_worth = 10 * Difficulty.getScaling()
	selfAc.sprite_death = spr.Nothing.id
	selfAc.sound_hit = sfx.LizardGHit.id
	selfAc.hit_pitch = 1.4
	--selfAc.sound_death = sDeath.id
	selfAc.sprite_palette = sprPalette.id
	selfAc.sprite_idle = sprHead.id
	self:setAnimation("idle", sprHead)
	selfAc.team = "enemy"
	self:getData().knockbackImmune = true
	self:getData().awaitingSprites = true
end)
local bloodColor = Color.fromHex(0x74B27F)
obj.SquallElver:addCallback("destroy", function(self)
	if global.quality > 1 then
		par.Blood1:burst("above", self.x, self.y, 6, bloodColor)
	end
end)
obj.SquallElver:addCallback("step", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	--selfAc.pHspeed = 0
	--selfAc.pVspeed = 0
	
	selfAc.ghost_x = self.x
	selfAc.ghost_y = self.y
	
	local controller = selfData.controller
	
	if controller and controller:isValid() then
		local section = selfData.section
		local nextSection = selfData.nextSection
		
		if section ~= 1 then
			self:setAlarm(6, -1)
		end

		if section == 1 or nextSection and nextSection:isValid() then
			if selfAc.hp < controller:get("hp") then
				if controller:getData().sections[1] and controller:getData().sections[1]:isValid() then
					controller:getData().sections[1]:setAlarm(6, controller:getData().sections[1]:getAlarm(6) + 100)
				end
				controller:set("hp", selfAc.hp)
			end
			selfAc.hp = controller:get("hp")
			
			if selfData.awaitingSprites then
				selfData.awaitingSprites = nil
				if section == 1 then
					self.sprite = sprHead
				elseif section == 2 then
					self.sprite = sprBody
				elseif section == #controller:getData().sections then
					self.sprite = sprTailEnd
				else
					self.sprite = sprTail
				end
			end
			
			self.xscale = 1
			
			selfAc.death_timer = 999
			
			selfData.timer = (selfData.timer or 0) + 1
			
			local target = Object.findInstance(controller:get("target"))
			
			if section > 1 then
				local angle = posToAngle(nextSection.x, self.y, self.x, nextSection.y)
				self.angle = (angle + 180) * -1
				
				local length = 20
				
				self.x = nextSection.x + math.cos(math.rad(angle)) * length
				self.y = nextSection.y + math.sin(math.rad(angle)) * length
				
			else
				self.angle = selfAc.direction
				
				selfAc.speed = selfAc.pHmax
				
				if misc.getTimeStop() > 0 then selfAc.speed = 0 end
				
				if target and target:isValid() and misc.getTimeStop() == 0 then
					local angle = posToAngle(self.x, self.y, target.x, target.y)
					local wave = math.sin(selfData.timer * 0.06)  * 14
					
					local fangle = angle + wave
					
					local dif = selfAc.direction - fangle
					
					if math.abs(dif) < 10 then
						selfAc.speed = selfAc.speed + 1
					end
					
					if target.x < self.x then fangle = fangle - 360 end
					
					selfAc.direction = selfAc.direction + (angleDif(selfAc.direction, fangle) * -0.0135)
				end
			end
			
			if target and target:isValid() and misc.getTimeStop() == 0 then
				if obj.P:findEllipse(self.x - 10, self.y - 10, self.x + 10, self.y + 10) then
					if misc.director:getAlarm(0) % 30 == 0 then
						local damager = self:fireExplosion(self.x, self.y, 20 / 19, 20 / 4, 1, nil, spr.Sparks2)
					end
				end
			end
		elseif self:isValid() then
			par.Blood1:burst("above", self.x, self.y, 6, bloodColor)
			syncDelete(self)
			self:delete()
		end
	elseif self:isValid() then
		par.Blood1:burst("above", self.x, self.y, 6, bloodColor)
		syncDelete(self)
		self:delete()
	end
end)

EliteType.registerPalette(sprPalette, obj.SquallElverC)

mcard.SquallElver = MonsterCard.new("Squall Elver", obj.SquallElverC)
mcard.SquallElver.type = "offscreen"
mcard.SquallElver.cost = 100
mcard.SquallElver.isBoss = false
mcard.SquallElver.canBlight = true

local originalElites = {
	elt.Blazing,
	elt.Overloading,
	elt.Frenzied,
	elt.Leeching,
	elt.Volatile
}

for _, eliteType in ipairs(originalElites) do
	mcard.SquallElver.eliteTypes:add(eliteType)
end

mlog.SquallElver = MonsterLog.new("Squall Elver")
MonsterLog.map[obj.SquallElver] = mlog.SquallElver
mlog.SquallElver.displayName = "Squall Elver"
mlog.SquallElver.story = "These creatures are majestic, yet aggressively territorial. They glide in from afar just to make sure you don't get anywhere near their nests.. Or at least that's what I assume they are protecting.\n\nWhat captivates me the most about the Elvers is how they manage their flight. I suspect their long, cloth-like appendages may be the culprit, a kind of biological advance I have never seen before.\n\nYet, it is highly reminiscent of fauna commonly found underwater."
mlog.SquallElver.statHP = 200
mlog.SquallElver.statDamage = 14
mlog.SquallElver.statSpeed = 1.2
mlog.SquallElver.sprite = sprLog
mlog.SquallElver.portrait = sprPortrait

callback.register("onLoad", function()

local stages = {
	stg.UnchartedMountain
}

local postLoopStages = {
	stg.SkyMeadow,
	stg.AncientValley,
	stg.TempleoftheElders,
	stg.Overgrowth
}

for _, stage in ipairs(stages) do
	stage.enemies:add(mcard.SquallElver)
end

table.insert(call.onStageEntry, function()
	if misc.director:get("stages_passed") > 4 then
		for _, stage in ipairs(postLoopStages) do
			if not stage.enemies:contains(mcard.SquallElver) then
				stage.enemies:add(mcard.SquallElver)
			end
		end
	end
end)

callback.register("onGameStart", function()
	for _, stage in ipairs(postLoopStages) do
		if stage.enemies:contains(mcard.SquallElver) then
			stage.enemies:remove(mcard.SquallElver)
		end
	end
end)
end)