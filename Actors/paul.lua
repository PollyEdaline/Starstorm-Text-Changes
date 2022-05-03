local path = "Actors/Goat/Paul/"

local sprMask = Sprite.load("PaulMask", path.."Mask", 1, 6, 7)
local sprIdle = Sprite.load("PaulIdle", path.."Idle", 1, 8, 9)
local sprWalk = Sprite.load("PaulWalk", path.."Walk", 4, 9, 9)
local sprJump = Sprite.load("PaulJump", path.."Jump", 1, 7, 9)
local sprDeath = Sprite.load("PaulDeath", path.."Death", 5, 8, 9)

obj.Paul = Object.base("BossClassic", "Paul")
obj.Paul.sprite = sprIdle
obj.Paul.depth = 1

obj.Paul:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Paul"
	selfAc.name2 = "The Architect"
	selfAc.team = "neutral"
	selfAc.damage = 100 * Difficulty.getScaling("damage")
	selfAc.maxhp = 1000 * Difficulty.getScaling("hp")
	selfAc.armor = 25
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 2
	selfAc.pVmax = 5
	selfAc.knockback_cap = selfAc.maxhp
	selfAc.exp_worth = 0 --* Difficulty.getScaling()
	selfAc.can_drop = 1
	selfAc.can_jump = 1
	selfAc.sound_hit = sfx.LizardHit.id
	selfAc.hit_pitch = 1
	selfAc.sound_death = -4
	selfAc.sprite_idle = sprIdle.id
	selfAc.sprite_walk = sprWalk.id
	selfAc.sprite_jump = sprJump.id
	selfAc.sprite_death = sprDeath.id
	self:getData().knockbackImmune = true
end)

obj.Paul:addCallback("step", function(self)
	local selfAc = self:getAccessor() 
	local object = self:getObject()
	local selfData = self:getData()
	
	local activity = selfAc.activity
	
	if misc.getTimeStop() == 0 then
		local target = selfAc.target
		local tInstance = Object.findInstance(target)
		if tInstance and tInstance:isValid() then
			if selfAc.team == "neutral" then
				if misc.director:getAlarm(0) == 50 then
					local fear = misc.fireBullet(self.x - 2, self.y, 0, 4, 0, "player", nil, nil)
					fear:set("fear", 1)
					fear:set("specific_target", self.id)
				end
			else
				if misc.director:getAlarm(0) == 50 then
					misc.shakeScreen(4)
					sfx.WispSpawn:play(0.6 + (math.random() * 0.2), 0.5)
					local attack = obj.BossSkill2old:create(tInstance.x, tInstance.y)
					local crit = 0
					if math.chance(selfAc.critical_chance) then crit = 1 end
					attack:set("team", selfAc.team)
					attack:set("critical", crit)
					if crit == 1 then
						attack:set("damage", selfAc.damage * 4)
					else
						attack:set("damage", selfAc.damage * 2)
					end
				end
			end
		end
	else
		self.spriteSpeed = 0
	end
end)

table.insert(call.preHit, function(damager, hit)
	if hit:getObject() == obj.Paul then
		local parent = damager:getParent()
		if parent and parent:isValid() then
			if hit:get("team") == "neutral" then
				if parent:get("team") == "player" then
					hit:set("team", "enemy")
				elseif parent:get("team") == "enemy" then
					hit:set("target", parent.id)
				end
			end
		end
	end
end)