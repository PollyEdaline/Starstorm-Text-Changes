local stages = {}
stages.damp = stg.DampCaverns
stages.sky = stg.SkyMeadow
stages.hive = stg.HiveCluster

local path = "Actors/Suicider/"

local sprMask = Sprite.load("SuiciderMask", path.."mask", 1, 7, 7)
local sprPalette
local sprSpawn
local sprIdle
local sprWalk
local sprJump
local sprShoot1
local sprDeath
local sprImpact = Sprite.load("SuiciderImpact", path.."impact", 6, 9, 12)
local sprPortrait = Sprite.load("SuiciderPortrait", path.."Portrait", 1, 119, 119)
local sSpawn = Sound.load("SuiciderSpawn", path.."spawn")
local sSkill1A = Sound.load("SuiciderActivate", path.."skill1a")
local sSkill1B = Sound.load("SuiciderExplode", path.."skill1b")
local sDeath = Sound.load("SuiciderDeath", path.."death")

if global.rormlflag.ss_classic_exploder then
sprPalette = Sprite.load("SuiciderPal", path.."palette", 1, 0, 0)
sprSpawn = Sprite.load("SuiciderSpawn", path.."SuiciderSpawn", 5, 9, 7)
sprIdle = Sprite.load("SuiciderIdle", path.."SuiciderIdle", 6, 9, 7)
sprWalk = Sprite.load("SuiciderWalk", path.."SuiciderWalk", 4, 10, 7)
sprJump = Sprite.load("SuiciderJump", path.."SuiciderJump", 1, 8, 8)
sprShoot1 = Sprite.load("SuiciderExplode", path.."SuiciderShoot1", 20, 20, 23)
sprDeath = Sprite.load("SuiciderDeath", path.."SuiciderDeath", 7, 20, 24)
else
sprPalette = Sprite.load("SuiciderPal", path.."palette2", 1, 0, 0)
sprSpawn = Sprite.load("SuiciderSpawn", path.."Suicider2Spawn", 5, 9, 7)
sprIdle = Sprite.load("SuiciderIdle", path.."Suicider2Idle", 5, 25, 17)
sprWalk = Sprite.load("SuiciderWalk", path.."Suicider2Walk", 6, 25, 17)
sprJump = Sprite.load("SuiciderJump", path.."Suicider2Jump", 1, 8, 8)
sprShoot1 = Sprite.load("SuiciderExplode", path.."Suicider2Shoot1", 20, 20, 23)
sprDeath = Sprite.load("SuiciderDeath", path.."Suicider2Death", 7, 20, 24)
end

EliteType.registerPalette(sprPalette, obj.Suicider)

obj.Suicider.sprite = sprIdle
obj.Suicider:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = sprMask
	selfAc.name = "Exploder"
	selfAc.damage = 17 * Difficulty.getScaling("damage")
	selfAc.pHmax = 1.3
	selfAc.zsound = 0
	selfAc.z_range = 14
	selfAc.sound_death = sDeath.id
	selfAc.sprite_palette = sprPalette.id
	selfAc.sprite_idle = sprIdle.id
	if sprWalk then
		selfAc.sprite_walk = sprWalk.id
	end
	selfAc.sprite_shoot1 = sprShoot1.id
	selfAc.sprite_jump = sprJump.id
	selfAc.sprite_death = sprDeath.id
	selfAc.point_value = 18
end)

table.insert(call.onStep, function()
	for _, suicider in pairs(obj.Suicider:findAll()) do
		local suiciderAc = suicider:getAccessor() 
	
		--if not suicider:getData().edited then
		--	suicider:getData().edited = true
		--end
		if suicider.sprite == sprShoot1 and suiciderAc.zsound == 0 then
			suiciderAc.zsound = 1
			sSkill1A:play(0.9 + math.random() * 0.2)
		elseif suicider.sprite ~= sprShoot1 and suiciderAc.zsound == 1 then
			suiciderAc.zsound = 0
		end
		if suicider.sprite == sprShoot1 and suicider.subimage >= 15 then
			if not suicider:getData().expoding then
				suicider:getData().expoding = true
				suiciderAc.pGravity1 = 0
				suiciderAc.pGravity2 = 0
				suiciderAc.pVspeed = 0
				suicider.mask = spr.Nothing
				suicider:setAlarm(6, -1)
				suiciderAc.knockback_cap = math.huge -- hehe
				sSkill1B:play(0.9 + math.random() * 0.2)
				suicider:fireExplosion(suicider.x, suicider.y - 8, 60 / 19, 28 / 4, 2, nil, sprImpact)
			end
		elseif suicider.sprite == sprShoot1 and suicider.subimage >= 18 then
			suicider:destroy()
		end
	end
end)

--[[callback.register("onDamage", function(target)
	if target:getData().exploding then
		return true
	end
end)]]

mcard.Suicider = MonsterCard.new("Exploder", obj.Suicider)
mcard.Suicider.type = "classic"
mcard.Suicider.cost = 18
mcard.Suicider.sound = sSpawn
mcard.Suicider.sprite = sprSpawn
mcard.Suicider.isBoss = false
mcard.Suicider.canBlight = false

mlog.Suicider = MonsterLog.new("Exploder")
MonsterLog.map[obj.Suicider] = mlog.Suicider
mlog.Suicider.displayName = "Exploder"
mlog.Suicider.story = "There's nothing I hate more than being chased down by these creatures. Although they can be easily dealt with alone, whenever they come in packs, I'm better off running away. It's as if their entire bloodstream is filled with this viscous, acidic material that managed to dissolve the circuits of one of my drones with a single drop.\n\nI.. really don't want to know what it would do to my skin."
mlog.Suicider.statHP = 100
mlog.Suicider.statDamage = 17
mlog.Suicider.statSpeed = 1.3
mlog.Suicider.sprite = sprWalk
mlog.Suicider.portrait = sprPortrait

for s, stage in pairs(stages) do
	stage.enemies:add(mcard.Suicider)
end