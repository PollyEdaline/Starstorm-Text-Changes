-- SPECIALIST

local path = "Survivors/Commando/Skins/Specialist/"

local survivor = sur.Commando
local sprSelect = Sprite.load("SpecialistSelect", path.."Select", 19, 2, 0)
local Specialist = SurvivorVariant.new(survivor, "Specialist", sprSelect, {
	idle = Sprite.load("SpecialistIdle", path.."Idle", 1, 6, 6),
	walk = Sprite.load("SpecialistWalk", path.."Walk", 8, 2, 5),
	jump = Sprite.load("SpecialistJump", path.."Jump", 1, 3, 3),
	climb = Sprite.load("SpecialistClimb", path.."Climb", 2, 4, 6),
	death = Sprite.load("SpecialistDeath", path.."Death", 5, 14, 3),
	decoy = Sprite.load("SpecialistDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1 = Sprite.load("SpecialistShoot1", path.."Shoot1", 5, 6, 8),
	shoot2 = Sprite.load("SpecialistShoot2", path.."Shoot2", 5, 5, 5),
	shoot3 = Sprite.load("SpecialistShoot3", path.."Shoot3", 9, 6, 7),
	shoot4_1 = Sprite.load("SpecialistShoot4A", path.."Shoot4A", 15, 19, 7),
	shoot4_2 = Sprite.load("SpecialistShoot4B", path.."Shoot4B", 15, 19, 7),
	shoot5_1 = Sprite.load("SpecialistShoot5A", path.."Shoot5A", 23, 38, 20),
	shoot5_2 = Sprite.load("SpecialistShoot5B", path.."Shoot5B", 24, 19, 7),
}, Color.fromHex(0xB14670))
SurvivorVariant.setInfoStats(Specialist, {{"Strength", 7}, {"Vitality", 4}, {"Toughness", 3}, {"Agility", 5}, {"Difficulty", 3}, {"Dexterity", 7}})
SurvivorVariant.setDescription(Specialist, "The &y&Specialist&!& is equipped with a heavy pistol for delivering piercing damage to his enemies, at the cost of a slower firerate.")

Specialist.endingQuote = "..and so he left, unable to redeem a new sorrow." -- im not sure what to change this to but it doesnt really read well

local sprSparks = spr.Sparks1
local sprSkill = Sprite.load("SpecialistSkill", path.."Skills", 2, 0, 0)
local sShoot = Sound.load("SpecialistShoot1", path.."Shoot1")

SurvivorVariant.setLoadoutSkill(Specialist, "Deadeye", "Fire a heavy pistol for &y&165% piercing damage.", sprSkill)
SurvivorVariant.setLoadoutSkill(Specialist, "Dirt Bomb", "Launch a dirt bomb which &y&stuns&!& and deals &y&310% damage.", sprSkill, 2)

local sprDirtExplosion = Sprite.clone(spr.ChefOilExplosion, "DirtExplosion", 46, 58)

local objGrenade = Object.new("SpecialistGrenade")
objGrenade.sprite = spr.PartPixel

objGrenade:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.xspeed = 0
	selfData.gravity = 0.2
	selfData.yspeed = 0
	selfData.range = 65
	selfData.team = "player"
	selfData.count = 0
	self.blendColor = Color.fromHex(0x8E6952)
	self.xscale = 2
	self.yscale = 2
end)
objGrenade:addCallback("step", function(self)
	local selfData = self:getData()
	selfData.xspeed = math.approach(selfData.xspeed, 0, 0.04)
	self.y = self.y + selfData.yspeed
	self.x = self.x + selfData.xspeed
	selfData.yspeed = selfData.yspeed + selfData.gravity
	
	if self:collidesMap(self.x, self.y) then
		if selfData.count == 2 then
			self:destroy()
		else
			local ysign = 1
			local xsign = 1
			if not self:collidesMap(self.x, self.y - 5) or not self:collidesMap(self.x, self.y + 5) then
				local n = 0
				while n < 20 and self:collidesMap(self.x, self.y) do
					n = n + 1
					self.y = self.y + math.sign(selfData.yspeed) * -1
				end
				ysign = -1
			elseif not self:collidesMap(self.x - 5, self.y) or not self:collidesMap(self.x + 5, self.y) then
				local n = 0
				while n < 20 and self:collidesMap(self.x, self.y) do
					n = n + 1
					self.x = self.x + math.sign(selfData.xspeed) * -1
				end
				xsign = -1
			end
			selfData.count = selfData.count + 1
			selfData.yspeed = selfData.yspeed * 0.4 * ysign
			selfData.xspeed = selfData.xspeed * 0.8 * xsign
			sfx.Reflect:play(1.5 + math.random() * 0.2, 0.2)
		end
	end
end)
objGrenade:addCallback("destroy", function(self)
	local selfData = self:getData()
	if selfData.parent and selfData.parent:isValid() then
		for i = 0, selfData.parent:get("sp") do
			local r = selfData.range
			local explosion = selfData.parent:fireExplosion(self.x, self.y + 4, r / 19, r / 4, 3.1, sprDirtExplosion, spr.Sparks):set("stun", 1.3)
			if i ~= 0 then
				explosion:set("climb", i * 8)
			end
		end
		sfx.RiotGrenade:play(0.8 + math.random() * 0.2, 1)
	end
end)

callback.register("onSkinInit", function(player, skin)
	if skin == Specialist then
		player:set("pHmax", player:get("pHmax") + 0.05)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(162, 12, 0.05)
		else
			player:survivorSetInitialStats(112, 12, 0.02)
		end
		player:setSkill(1,
		"Deadeye",
		"Fire a heavy pistol for 165% piercing damage.",
		sprSkill, 1, 39)
		player:setSkill(2,
		"Dirt Bomb",
		"Launch a dirt bomb which stuns and deals 310% damage.",
		sprSkill, 2, 4.5 * 60)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Specialist then
		player:survivorLevelUpStats(2, 0, 0, -0.5)
		player:set("attack_speed", player:get("attack_speed") + 0.015)
	end
end)
SurvivorVariant.setSkill(Specialist, 1, function(player)
	SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1"), 0.2, true, true)
end)
SurvivorVariant.setSkill(Specialist, 2, function(player)
	SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2"), 0.2, true, true)
end)
callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
	if variant == Specialist then
		local playerAc = player:getAccessor()
		if skill == 1 then
			if relevantFrame == 1 then
				sShoot:play(1 + math.random() * 0.2)
				if not player:survivorFireHeavenCracker(1.65) then
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 300, 1.65, sprSparks, DAMAGER_BULLET_PIERCE)
						bullet:set("damage_degrade", 0.4)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			end
		elseif skill == 2 then
			if relevantFrame == 1 then
				sShoot:play(0.8 + math.random() * 0.2)
				for i = 0, playerAc.sp do
					local grenade = objGrenade:create(player.x, player.y):getData()
					grenade.xspeed = playerAc.pHspeed + 3 * player.xscale
					grenade.yspeed = - 2
					grenade.parent = player
					grenade.team = playerAc.team
				end
			end
		end
	end
end)