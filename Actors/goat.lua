local path = "Actors/Goat/"

local sprMask = Sprite.load("GoatMask", path.."Mask", 1, 6, 7)
local sprIdle = Sprite.load("GoatIdle", path.."Idle", 1, 8, 9)
local sprWalk = Sprite.load("GoatWalk", path.."Walk", 4, 9, 9)
local sprJump = Sprite.load("GoatJump", path.."Jump", 1, 7, 9)
local sprDeath = Sprite.load("GoatDeath", path.."Death", 5, 8, 9)

obj.Goat = Object.base("EnemyClassic", "Goat")
obj.Goat.sprite = sprIdle
obj.Goat.depth = 1

obj.Goat:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Goat"
	selfAc.name2 = "Fellow Friend"
	selfAc.team = "neutral"
	selfAc.damage = 5 * Difficulty.getScaling("damage")
	selfAc.maxhp = 100 * Difficulty.getScaling("hp")
	selfAc.armor = 5
	selfAc.hp = selfAc.maxhp
	selfAc.pHmax = 2
	selfAc.pVmax = 5
	selfAc.exp_worth = 0
	selfAc.can_drop = 1
	selfAc.can_jump = 1
	selfAc.sound_hit = sfx.LizardHit.id
	selfAc.hit_pitch = 1
	selfAc.sound_death = -4
	selfAc.sprite_idle = sprIdle.id
	selfAc.sprite_walk = sprWalk.id
	selfAc.sprite_jump = sprJump.id
	selfAc.sprite_death = sprDeath.id
end)

obj.Goat:addCallback("step", function(self)
	if misc.getTimeStop() > 0 then
		self.spriteSpeed = 0
	end
end)

table.insert(call.preHit, function(damager, hit)
	if hit:getObject() == obj.Goat then
		damager:set("fear", 5)
	end
end)

onNPCDeath.goat = function(npc, object)
	if object == obj.Goat then
		if net.host and math.chance(25) then
			it.PaulsGoatHoof:create(npc.x, npc.y - 10)
		end
	end
end

NPC.registerBossDrops(obj.Goat, 15)
NPC.addBossItem(obj.Goat, it.MeatNugget)