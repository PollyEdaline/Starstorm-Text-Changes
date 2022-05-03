-- R-MOR

local path = "Survivors/HAN-D/Skins/R-MOR/"

local survivor = sur.HAND
local sprSelect = Sprite.load("RMORSelect", path.."Select", 16, 0, 0)
local RMOR = SurvivorVariant.new(survivor, "R-MOR", sprSelect, {
	idle = Sprite.load("RMORIdleA", path.."Idle_1", 1, 10, 17),
	idlehot = Sprite.load("RMORIdleB", path.."Idle_2", 1, 10, 18),
	walk = Sprite.load("RMORWalkA", path.."Walk_1", 8, 26, 18),
	walkhot = Sprite.load("RMORWalkB", path.."Walk_2", 8, 26, 18),
	jump = Sprite.load("RMORJumpA", path.."Jump_1", 1, 10, 21),
	jumphot = Sprite.load("RMORJumpB", path.."Jump_2", 1, 10, 21),
	climb = Sprite.load("RMORClimbA", path.."Climb_1", 2, 9, 16),
	climbhot = Sprite.load("RMORClimbB", path.."Climb_2", 2, 9, 16),
	death = Sprite.load("RMORDeathA", path.."Death", 7, 6, 1),
	death_2 = Sprite.load("RMORDeathB", path.."Death_2", 7, 10, 34),
	decoy = Sprite.load("RMORDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1 = Sprite.load("RMORShoot1A", path.."Shoot1_1", 15, 20, 22),
	shoot1hot = Sprite.load("RMORShoot1B", path.."Shoot1_2", 15, 20, 22),
	shoot4 = Sprite.load("RMORShoot4A", path.."Shoot4_1", 18, 33, 39),
	shoot4hot = Sprite.load("RMORShoot4B", path.."Shoot4_2", 18, 33, 39),
	shoot5 = Sprite.load("RMORShoot5A", path.."Shoot4_1", 18, 33, 39),
	shoot5hot = Sprite.load("RMORShoot5B", path.."Shoot4_2", 18, 33, 39),
}, Color.fromHex(0x888E80))
SurvivorVariant.setInfoStats(RMOR, {{"Strength", 8}, {"Vitality", 5}, {"Toughness", 10}, {"Agility", 4}, {"Difficulty", 4.5}, {"Affection", 2}})
SurvivorVariant.setDescription(RMOR, "&y&R-MOR&!& is a devastating machine made for critical encounters: extreme armor, retractable blades and missile launchers. An unstoppable behemoth.")

local sprSkill = Sprite.load("RMORSkill", path.."Skill", 1, 0, 0)
local sShoot = Sound.load("RMORShoot1", path.."Shoot1")
local sprSparks = spr.Sparks6

SurvivorVariant.setLoadoutSkill(RMOR, "ERADICATE", "SHOOT A MISSILE WHICH &y&EXPLODES ON IMPACT FOR 220% DAMAGE.", sprSkill)

RMOR.endingQuote = "..and so it left, exposing signs of decay."

-- Bullet Object
local objBullet = Object.new("R-MORBullet")
local sprBullet = Sprite.load("R-MORMissile", path.."Bullet", 3, 16, 3)
local sprBulletMask = Sprite.load("R-MORMissileMask", path.."BulletMask", 1, 7, 5)
local sprBulletExplosion = Sprite.load("R-MORExplosion", path.."Explosion", 6, 27, 28)
local sExplosion = Sound.load("RMORExplosion", path.."Explosion")
local enemies = pobj.enemies

objBullet.sprite = sprBullet
objBullet.depth = 0.1

local parSmoke = par.Smoke2

objBullet:addCallback("create", function(self)
	local selfData = self:getData()
	self.mask = sprBulletMask
	selfData.life = 92
	selfData.damage = 2.2
	selfData.bspeed = 3.1
	self.spriteSpeed = 0.25
end)
objBullet:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	local enemy = enemies:findNearest(self.x, self.y)
	
	if selfData.direction == 0 then
		self.x = self.x + selfData.bspeed
	else
		self.xscale = -1
		self.x = self.x - selfData.bspeed
	end
	if global.quality > 1 then 
		parSmoke:burst("middle", self.x, self.y, 1)
	end
	
	local parent = self:getData().parent
	
	if enemy and parent then
		if self:getData().parent and self:collidesWith(enemy, self.x, self.y) and enemy:get("team") ~= parent:get("team") then
			if global.quality > 1 then
				par.Spark:burst("middle", self.x, self.y, 2)
			end
			selfData.life = 0
			for _, gauge in ipairs(obj.JanitorGauge:findMatching("parent", parent.id)) do
				gauge:set("steam", gauge:get("steam") + 5)
			end
		end
	end
	
	if selfData.life == 0 or Stage.collidesPoint(self.x, self.y) then
		if onScreen(self) then
			sExplosion:play(1 + math.random() * 0.2, 0.7)
			misc.shakeScreen(2)
		end
		if parent then
			for i = 0, parent:get("sp") do
				explosion = parent:fireExplosion(self.x, self.y, 25 / 19, 25 / 4, selfData.damage, sprBulletExplosion, sprSparks)
				explosion:set("direction", parent:getFacingDirection())
				explosion:set("knockback", 5)
				selfData.life = 0
				if i ~= 0 then
					explosion:set("climb", i * 8)
				end
			end
		end
			
		if global.quality > 1 then
			par.Spark:burst("middle", self.x, self.y, 4)
		end
		self:destroy()
	else
		selfData.life = selfData.life - 1
		selfData.bspeed = selfData.bspeed * 1.025
	end
end)


callback.register("onSkinInit", function(player, skin)
	if skin == RMOR then
		player:getData().skin_skill1Override = true
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(159, 13, 0.035)
		else
			player:survivorSetInitialStats(109, 13, 0.005)
		end
		player:set("pHmax", player:get("pHmax") - 0.1)
		player:set("armor", player:get("armor") + 20)
		player:setSkill(1,
		"ERADICATE",
		"SHOOT A MISSILE WHICH EXPLODES ON IMPACT FOR 220% DAMAGE.",
		sprSkill, 1, 40)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == RMOR then
		player:survivorLevelUpStats(-19, 0.4, -0.002, 3)
	end
end)
SurvivorVariant.setSkill(RMOR, 1, function(player)
	SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1"), 0.25, true, true)
end)
callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
	if variant == RMOR then
		local playerAc = player:getAccessor()
		if skill == 1 then
			if relevantFrame == 7 then
				misc.shakeScreen(4)
				sShoot:play()
				if not player:survivorFireHeavenCracker(2.2) then
					for i = 0, playerAc.sp do
						local bullet = objBullet:create(player.x + (5 * player.xscale), player.y - 9 + (i * 8))
						bullet:getData().parent = player
						bullet:getData().direction = player:getFacingDirection()
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			end
		end
	end
end)