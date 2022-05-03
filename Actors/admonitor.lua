local postLoopStages = {
	stg.AncientValley,
	stg.SunkenTombs,
	stg.BoarBeach,
	stg.MagmaBarracks,
	stg.TempleoftheElders
}
callback.register("onLoad", function()
	if stg.WhistlingBasin then
		table.insert(postLoopStages, stg.WhistlingBasin)
	end
end)

local path = "Actors/Clay Admonitor/"

local sprMask = Sprite.load("AdmonitorMask", path.."Mask", 1, 8, 15)
local sprPalette = spr.ClayPal--Sprite.load("AdmonitorPal", path.."Palette", 1, 0, 0)
local sprSpawn = Sprite.load("AdmonitorSpawn", path.."Spawn", 13, 14, 17)
local sprIdle = Sprite.load("AdmonitorIdle", path.."Idle", 1, 14, 17)
local sprJump = Sprite.load("AdmonitorJump", path.."Jump", 1, 14, 17)
local sprWalk = Sprite.load("AdmonitorWalk", path.."Walk", 8, 13, 17)
local sprShoot1 = Sprite.load("AdmonitorShoot1", path.."Shoot1", 22, 25, 17)
local sprDeath = Sprite.load("AdmonitorDeath", path.."Death", 13, 15, 17)
local sprPortrait = Sprite.load("AdmonitorPortrait", path.."Portrait", 1, 119, 119)

local sDeath = Sound.load("AdmonitorDeath", path.."Death")
--local sHit = Sound.load("AdmonitorHit", path.."Hit")
local sShoot1_1 = Sound.load("AdmonitorShoot1_1", path.."Shoot1_1")
local sShoot1_2 = Sound.load("AdmonitorShoot1_2", path.."Shoot1_2")
local sSpawn = Sound.load("AdmonitorSpawn", path.."Spawn")

obj.Admonitor = Object.base("EnemyClassic", "Admonitor")
obj.Admonitor.sprite = sprIdle

EliteType.registerPalette(spr.ClayPal, obj.Admonitor)

NPC.setSkill(obj.Admonitor, 1, 100, 60 * 4, sprShoot1, 0.18, nil, function(actor, relevantFrame)
	local actorData = actor:getData()
	
	if relevantFrame == 1 then
		sShoot1_1:play(0.9 + math.random() * 0.2)
	elseif relevantFrame == 13 then
		local bullet = actor:fireExplosion(actor.x + 36 * actor.xscale, actor.y + 5, 36 / 19, 10 / 4, 4.2, nil, spr.Sparks4)
		bullet:getData().pushAd = 4 * actor.xscale
		sShoot1_2:play(0.9 + math.random() * 0.2)
	end
end)

local preHitCall = function(damager, hit)
	if damager:getData().pushAd and not hit:isBoss() then
		hit:getData().xAccel = damager:getData().pushAd
	end
end

obj.Admonitor:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Clay Admonitor"
	selfAc.damage = 17 * Difficulty.getScaling("damage")
	selfAc.maxhp = 350 * Difficulty.getScaling("hp")
	selfAc.armor = 0
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 0.8
	selfAc.knockback_cap = selfAc.maxhp / 5
	selfAc.exp_worth = 30 * Difficulty.getScaling()
	selfAc.point_value = 160
	selfAc.can_drop = 0
	selfAc.can_jump = 0
	selfAc.sound_hit = sfx.ClayHit.id
	selfAc.hit_pitch = 0.9
	selfAc.sound_death = sDeath.id
	selfAc.sprite_palette = sprPalette.id
	selfAc.sprite_idle = sprIdle.id
	selfAc.sprite_walk = sprWalk.id
	selfAc.sprite_jump = sprJump.id
	selfAc.sprite_death = sprDeath.id
	tcallback.register("preHit", preHitCall)
end)

obj.Admonitor:addCallback("step", function(self)
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

mcard.ClayAdmonitor = MonsterCard.new("Clay Admonitor", obj.Admonitor)
mcard.ClayAdmonitor.type = "classic"
mcard.ClayAdmonitor.cost = 160
mcard.ClayAdmonitor.sound = sSpawn
mcard.ClayAdmonitor.sprite = sprSpawn
mcard.ClayAdmonitor.isBoss = false
mcard.ClayAdmonitor.canBlight = true

table.insert(call.onStageEntry, function()
	if misc.director:get("stages_passed") > 4 or Difficulty.getActive().scale >= 0.2 then
		for _, stage in ipairs(postLoopStages) do
			if not stage.enemies:contains(mcard.ClayAdmonitor) then
				stage.enemies:add(mcard.ClayAdmonitor)
			end
		end
	end
end)

callback.register("onGameStart", function()
	for _, stage in ipairs(postLoopStages) do
		if stage.enemies:contains(mcard.ClayAdmonitor) then
			stage.enemies:remove(mcard.ClayAdmonitor)
		end
	end
end)

mlog.ClayAdmonitor = MonsterLog.new("Clay Admonitor")
MonsterLog.map[obj.Admonitor] = mlog.ClayAdmonitor
mlog.ClayAdmonitor.displayName = "Clay Admonitor"
mlog.ClayAdmonitor.story = "Upright, right next to me it stood. Bothered by my prolonged wandering without a specific destination, knowing I didn't belong here.\n\nIt knew I was alert and ready to pull the trigger.\n\nIt didn't like that.\nIt despised having its territory disturbed with my hurry.\n\nIt knew it was me or them."
mlog.ClayAdmonitor.statHP = 350
mlog.ClayAdmonitor.statDamage = 17
mlog.ClayAdmonitor.statSpeed = 0.8
mlog.ClayAdmonitor.sprite = sprShoot1
mlog.ClayAdmonitor.portrait = sprPortrait