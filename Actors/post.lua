local path = "Actors/Post/"

local stages = {}
stages.sky = stg.SkyMeadow

local sprPortrait = Sprite.load("PostPortrait", path.."Portrait", 1, 119, 119)
local sprMask = Sprite.load("PostMask", path.."Mask", 1, 15, 43)
local sprPalette = Sprite.load("PostPal", path.."Palette", 1, 0, 0)
local sprSpawn = Sprite.load("PostSpawn", path.."Spawn", 7, 30, 70)
local sprIdle = Sprite.load("PostIdle", path.."Idle", 7, 30, 70)
local sprWalk = Sprite.load("PostWalk", path.."Walk", 7, 30, 61)
local sprShoot1 = Sprite.load("PostShoot1", path.."Shoot1", 15, 30, 70)
local sprShoot1Effect = Sprite.load("PostShoot1Ef", path.."Shoot1Effect", 4, 28, 37)
local sprShoot2 = Sprite.load("PostShoot2", path.."Shoot2", 9, 30, 70)
local sprDeath = Sprite.load("PostDeath", path.."Death", 15, 30, 70)
--local sprImpact = Sprite.load("PostImpact", path.."impact", 6, 9, 12)
local sSpawn = Sound.load("PostSpawn", path.."spawn")
local sSkill1 = Sound.load("PostShoot1", path.."Shoot1")
local sSkill2A = Sound.load("PostShoot2A", path.."Shoot2")
local sSkill2B = Sound.load("PostShoot2B", path.."Shoot2b")
local sSkill3 = Sound.load("PostShoot3", path.."Shoot3")
local sDeath = Sound.load("PostDeath", path.."death")

obj.Post = Object.base("BossClassic", "Post")
obj.Post.sprite = sprIdle

EliteType.registerPalette(sprPalette, obj.Post)

local postBuff = Buff.new("post")
postBuff.sprite = spr.Buffs
postBuff.subimage = 56
postBuff:addCallback("start", function(actor)
	if actor and actor:isValid() then
		actor:set("pHmax", actor:get("pHmax") + 0.3)
		actor:getData()._prePost = {actor:get("can_jump"), actor:get("can_drop")}
		actor:set("can_jump", 1)
		actor:set("can_drop", 1)
	end
end)	
postBuff:addCallback("end", function(actor)
	if actor and actor:isValid() then
		actor:set("pHmax", actor:get("pHmax") - 0.3)
		local data = actor:getData()._prePost
		if data and data[1] and data[2] then
			actor:set("can_jump", data[1])
			actor:set("can_drop", data[2])
		end
	end
end)
local glowColor = Color.fromHex(0xFDFAD9)
table.insert(call.onDraw, function()
	for _, actor in pairs(pobj.actors:findAll()) do
		if actor:hasBuff(postBuff) and actor.visible then
			graphics.drawImage{
			image = actor.sprite,
			x = actor.x + math.random(-0.5, 0.5),
			y = actor.y + math.random(-0.5, 0.5),
			subimage = actor.subimage,
			solidColor = glowColor,
			alpha = 0.3 * actor.alpha,
			angle = actor.angle,
			xscale = actor.xscale,
			yscale = actor.yscale,
			width = actor.sprite.width,
			height = actor.sprite.height
			}
		end
	end
	for _, actor in ipairs(obj.Post:findMatchingOp("team", "==", "player")) do
		if actor.alpha < 1 then
			graphics.drawImage{
				image = actor.sprite,
				x = actor.x + math.random(-0.5, 0.5),
				y = actor.y + math.random(-0.5, 0.5),
				subimage = actor.subimage,
				solidColor = Color.GREEN,
				alpha = (1 - math.clamp(actor.alpha, 0, 1)) * 0.15,
				angle = actor.angle,
				xscale = actor.xscale,
				yscale = actor.yscale,
				width = actor.sprite.width,
				height = actor.sprite.height
			}
		end
	end
end)

NPC.setSkill(obj.Post, 1, 85, 60 * 3, sprShoot1, 0.2, function(actor)
	sSkill1:play(0.9 + math.random() * 0.2, 0.6)
end, function(actor, relevantFrame)
	if relevantFrame == 10 then
		sfx.BossSkill2:play(0.7, 0.2)
		if onScreen(actor) then
			misc.shakeScreen(7)
		end
		if not actor.visible then
			obj.EfSparks:create(actor.x, actor.y).sprite = sprShoot1Effect
		end
		actor:fireExplosion(actor.x, actor.y, 45 / 19, 70 / 4, 1.75)
	end
end)
NPC.setSkill(obj.Post, 2, 900, 60 * 16, nil, 0.2, function(actor)
	sSkill2A:play(0.9 + math.random() * 0.2, 0.6)
	actor:getData().invisTimer = 100
end)
local range = 150
NPC.setSkill(obj.Post, 3, 900, 60 * 9, sprShoot2, 0.2, function(actor)
	sSkill3:play(0.9 + math.random() * 0.2, 0.6)
end, function(actor, relevantFrame)
	if relevantFrame == 7 then
		local elite = actor:getElite()
		for _, actor2 in ipairs(pobj.actors:findAllEllipse(actor.x - range, actor.y - range, actor.x + range, actor.y + range)) do
			if actor2:get("team") == actor:get("team") and actor2 ~= actor then
				actor2:applyBuff(postBuff, 500)
				
				if elite == elt.Leeching then
					actor2:applyBuff(buff.burstHealth, 60 * 2)
				end
			end
		end
	elseif relevantFrame == 6 then
		local c = obj.EfCircle:create(actor.x, actor.y)
		c:set("radius", range)
		local color = glowColor
		local elite = actor:getElite()
		if elite then
			color = elite.color
		end
		c.blendColor = color
	end
end)

obj.Post:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Wayfarer"
	selfAc.name2 = "Usher of light"
	selfAc.damage = 25 * Difficulty.getScaling("damage")
	selfAc.maxhp = 900 * Difficulty.getScaling("hp")
	selfAc.hp = selfAc.maxhp
	selfAc.pVmax = 3
	selfAc.pHmax = 0.9
	selfAc.can_jump = 1
	selfAc.can_drop = 1
	selfAc.exp_worth = 40 * Difficulty.getScaling()
	selfAc.point_value = 640
	selfAc.knockback_cap = selfAc.maxhp * 0.2
	selfAc.sound_death = sDeath.id
	selfAc.sound_hit = sfx.ImpHit.id
	selfAc.hit_pitch = 0.5
	selfAc.sprite_palette = sprPalette.id
	selfAc.sprite_idle = sprIdle.id
	selfAc.sprite_walk = sprWalk.id
	selfAc.sprite_jump = sprIdle.id
	selfAc.sprite_death = sprDeath.id
end)

obj.Post:addCallback("step", function(self)
	self.spriteSpeed = 0.15
	
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	local activity = selfAc.activity
	
	if self:collidesMap(self.x, self.y) then
		for i = -20, 20 do
			if not self:collidesMap(self.x + i, self.y) then
				self.x = self.x + i
				break
			end
		end
	end
	
	if self.sprite == sprDeath then self.subimage = 1 end
	
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
	
	if selfData.invisTimer then
		if selfData.invisTimer > 0 then
			self.alpha = selfData.invisTimer / 100
			selfData.invisTimer = selfData.invisTimer - 1
		else
			if not selfData.invis then
				self.visible = false
				self:set("pHmax", self:get("pHmax") + 0.9)
			end
			selfData.invis = 60 * 7
			selfData.invisTimer = nil
		end
	end
	if selfData.invis then
		if selfData.invis > 0 then
			if selfData.invis / 100 == 1 then
				sSkill2B:play(0.9 + math.random() * 0.2, 0.6)
				local target = nearestMatchingOp(self, pobj.actors, "team", "~=", self:get("team"))
				if target and target:isValid() then
					local xOffset = target.x
					local yOffset = target.y
					
					local newX = xOffset
					local newY = yOffset
					
					if target.mask and self.mask then
						yOffset = target.y - target.mask.yorigin + target.mask.height
						
						newY = yOffset - self.mask.height + self.mask.yorigin
					end
					if not self:collidesMap(xOffset, newY) and Stage.collidesRectangle(xOffset, newY, xOffset + 1, newY + 1000) then
						self.x = newX
						self.y = newY
						selfAc.ghost_x = self.x
						selfAc.ghost_y = self.y
					end
				end
			end
			if selfData.invis / 100 < 1 then
				self.visible = true
			end
			self.alpha = 1 - (selfData.invis / 100)
			selfData.invis = selfData.invis - 1
		else
			self.visible = true
			self:set("pHmax", self:get("pHmax") - 0.9)
			selfData.invis = nil
		end
	end
end)

mcard.Wayfarer = MonsterCard.new("Wayfarer", obj.Post)
mcard.Wayfarer.type = "classic"
mcard.Wayfarer.cost = 640
mcard.Wayfarer.sound = sSpawn
mcard.Wayfarer.sprite = sprSpawn
mcard.Wayfarer.isBoss = true
mcard.Wayfarer.canBlight = false

mlog.Wayfarer = MonsterLog.new("Wayfarer")
MonsterLog.map[obj.Post] = mlog.Wayfarer
mlog.Wayfarer.displayName = "Wayfarer"
mlog.Wayfarer.story = "What I saw was familiar. It had close resemblance to an ancient light post, of all things... However, it cast a cold, eerie light that was somehow beyond perception..\n\nWhile possessing what seem to be legs, it doesn't walk. Instead, it hovers over the ground. I sincerely can't discern if this is just an illusion.\n\The other creatures of this planet seem to be comforted around this entity. A kind of comfort that feels as if it had been stripped away from me the very moment I came here."
mlog.Wayfarer.statHP = 900
mlog.Wayfarer.statDamage = 25
mlog.Wayfarer.statSpeed = 0.9
mlog.Wayfarer.sprite = sprWalk
mlog.Wayfarer.portrait = sprPortrait

for s, stage in pairs(stages) do
	stage.enemies:add(mcard.Wayfarer)
end